Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3952E42E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345436AbiETFHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiETFHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:07:01 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1624BC9;
        Thu, 19 May 2022 22:06:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUekDGjZ2qh/R4zRxNqwThR82k4ggC0jC5Iltzj3GXYJ96ZogL3xCPQ0gKiNFqICHcpOhK4LA3sMQYbTchUgzHHgsl1crscKU5Cqr9cfw/exFgv+Zi1zU/RcAptsc/TRPN0+sr9WHcfMVDoVl4aF66HLrTrhpL1egIu145kBxYUjxiKOJSuTHaSy8N1oBGQpSIW4SjZJiAyAolGXxeZNw7HPdKZ9yz/+28FMUqUbVYNkK+1vVjmAr2AEgQss6eBUA914Q/G0Kyfr5vwQXvmWBo1CRhjI8X1YWEtuwutmIjL45AARKfOczRh9eh9ECPCKb5yN05EDvLkQH0wSreMWSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5ssm/mHDkl/F4RhQ2D4pvxvU7keIgME3b5hI/kehKA=;
 b=nj8CfS4ynSIENRoIbIwBopz5DvZm8uqx+xMH17jQ9KLcZbl1aXPFw3LX0vI66Kq6b54TWiFrZLk+rZMcOCCJNDVxIRvgI/+nXPsij7c76Yg2p2zjDK11dsDZ0ItNWuirjWS/sILfFqXowI7fB4ulzwI+Ga953W6sbwdRO784cI2D+LMrl+4pKXMexQpyHtY13Fe3Z3xElxns5sK2ot9ydxGAxFohKwfuP78vl2QuLF/UZOo1xmDzs8UOcgSVIl8CGQbo31Q8PlBBtEvMmPjtnFYws4jFyiOA4xWruRmoCoJZEWe87Ha5er+XYI0Mz5yCBE7/kLM76i+KN5HzJbMFHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5ssm/mHDkl/F4RhQ2D4pvxvU7keIgME3b5hI/kehKA=;
 b=Hu1TBTLAFh5oyLIvraLuhK+BY7eRi5Ib5o6L7sFkeYEnoiOgLwwoQFGr3ZlncHqefqUsvXz+/AF+lnS7HgEWhFHTFhFF0Tm2Bssw+q44jAYFs9GrM1gvSjlMwsZK++N2MLQ2IGLYfxHGnY4FQP+VnC6mEj/jTO4g2JcXl4A5YV3+6n8/4l3KgnWUpv4MtKhJ6XTRqa7qVKWxFnGTp9GZtr4Qx+X1s8NEnokoaaTy+6TM1gRHvDwdGMtVG/sKbbuQgC9g7bZU9XVnCa+WuSxvuRaD/AOWBXdQAWtVrX1T7JprAKiX4tiW71kICNT6rEY+UAiNrMbY5lq7J+8ImIrU5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CH0PR12MB5092.namprd12.prod.outlook.com (2603:10b6:610:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 05:06:55 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 05:06:55 +0000
Message-ID: <7dbf218e-1a9a-13a4-6b6f-0e23899fb1cb@nvidia.com>
Date:   Thu, 19 May 2022 22:06:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
References: <20220520003614.6073-1-eng.alaamohamedsoliman.am@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220520003614.6073-1-eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05854892-6956-4291-6380-08da3a1e8f4b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5092:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5092CD2C16ADE5B74024AD3FCBD39@CH0PR12MB5092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajYKRMWCiJfLXPut25ROy7qPwUukrig752SnRIimkv8y4/ZNQSvrOPP/XqmNmAyT17tahFsbQ774wnppoY7WLO9Ky26PPg7iCzkDW/Ndk4mEk8URXh5O3seWmGXxTH87McBZJAyDfLOTbHAjQnojl4mcHv7dD6G06i3YoZZ3WwYacPI+xrqoAJ0W4qAeUc/Z7Lfvv1Dimz9o6QP+uk4FUF45/sqNb7G3N6rxMCeH4hcs6aDPhhgmfhnZCSHrUVf225u3ID1bmEP9xTsCQ6MiaXsM6sT22934QJl7gF4Q2vFaJsjNnr64bBznkAXO6Xy0OC1wg5/Lf5mTe65buv91P/dAzm3XLw69MU4qCD3RIe09xrKuJj2aOvvR8i7s/2wskbf5sJqtqTZDQjeOPo4oIoQIiGu0hFEwzWdEHKp+4tbtS2RQdd3NQSHh1y2wORV1zPixhAaLk7vXWnuKonGa16x1NJfEiSYWMK7FcEckwWgJHwH1mO0ztf2ewBB+D09gkup1QdXlbHqdTfCqQTHIPi7XieOdJYTuRxefO7YeRWVIzkWxxFfc0jcLw6qwL/cha7xYpauvh79sJJuGurEY1Qm5/scbAZBuxnYjcF0evt3rAtNKHL1tjUCxj8+0nA7Qgi2XrpC4AUgKKE1W4UbSQXr3Aj8oaSwt56Lv+B/e1NZUl6a1CkVx7760QsEVG7z7169aseSJcWbChIogQGoC64DkyYjnjRxlxw4ZRjmkjU8y7JwK3LpW3aKsVKBZP0er
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(66476007)(6506007)(26005)(6512007)(4326008)(31696002)(8676002)(53546011)(508600001)(83380400001)(2906002)(6486002)(8936002)(86362001)(2616005)(5660300002)(38100700002)(31686004)(316002)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVYwRnovOEY0M3FaRU1mYXozYmV6YjM4RmgxaWRIOUlMQmpDU1JPTFNLT1Ft?=
 =?utf-8?B?WVYvMERFL3FsMWl2QjFMNWlEZ0NMc21WbTVLVUJpRGlyR2FIUTBiamhVS3Iy?=
 =?utf-8?B?MUQwTStQdUJMSWJhMjh1QTVzVEJVWXVrdDUybTBXU3lYQkt3VnFnekhlb2xl?=
 =?utf-8?B?NlJmNzJkTDBsYkNJNFRQQkNPR2tYUmd4TTA2V05jbkQvVlF5YWxmOFEyS0c0?=
 =?utf-8?B?dkx6c1JRMzRVUWpqekJ5dTZNODBQQlNUTGluODJPOGpZMlEwRThiK0I5eEZ4?=
 =?utf-8?B?a1J3VWRyY1RkbUtEWU1WTzBRWG1IRnlDM3ZPM3Z4VzdGM21SZkpUK2tKcGp3?=
 =?utf-8?B?T3JRejN1bHFMeUZtTmw1TVR5bXVqbkZoNU5Kd0RDczd4MTk2UDExQ2JHZStN?=
 =?utf-8?B?V0tyekNiMGVXaGJBS3ROODhGSGFYejkxNjE5YllOaEF6eVNxcEpURlozNXBE?=
 =?utf-8?B?TGRDMVF1WVhWdE5tK3k1cWlYM1E2c3poZVhIRVUzaXRWbmZkemF1YVprcllO?=
 =?utf-8?B?dEtNN1ZpYWVpVG0vZjBPU0twYlhiRTRIclZWQUtSbnk1YzlDSzl3ZFg0ZHhO?=
 =?utf-8?B?bWkyakk2NkJMU1gwaFJuTDlocWZvS3RGR094T2VDR2NyejhJaWdSNWYzZjht?=
 =?utf-8?B?a1RsY0c1WjgreUtDUVZVNlhUdWhHbm5LME5TVkY0WEFnbm50cklobEZtMXV5?=
 =?utf-8?B?ZTFSQjRkU0NqdlZjd2hqOU9vb0NoNlp1V002Z3kzbVNnRWVjS1hTVVorYzUy?=
 =?utf-8?B?ZVRQaS9BU0FESEtTN3p4dWFxTnc0dlBlZDJLbDV4NXJMaS9HWTE1U2pZZDln?=
 =?utf-8?B?MkYxbURpd2NlU3NadTVTVHZZZklMVW9HV1U3dXFHdkdFUDduOW9kdVo5cWtI?=
 =?utf-8?B?YW05ZlVWbTBtZzdqblpYNm91bUtBMERNMm11ZE9DRXJFUTJsNE9LYmRTM3Zz?=
 =?utf-8?B?aG5vT0xzak5MN1lKMGlpRi9BTFBpbC9DdTZub2hNNUZSUTF4Y1pnUGM0ZTFX?=
 =?utf-8?B?Wk5FOUxnQndVcWU3TTIzaEE0STdzK2xuY2hjczVtdHhHTWJxREt0Z1YwaHRG?=
 =?utf-8?B?bGYwSVhpQ2FzTDh2RkRlSUh6bW1FK2ZyTVV2T0V1MzVadG1YdWhnallNWjMy?=
 =?utf-8?B?TEpoKzN6b1lKUlNEMnAvRk03eml1RWRuckZwSFZscitsL2hpUDl3L2Z6dVhr?=
 =?utf-8?B?OVZadytoQWx0TFV1dGloaUxHWmRJWDdjWWFTeG00VnJBejJpdGtiOUowWVJ5?=
 =?utf-8?B?NEYyblg3L0hCc1VLaXNJcVVqUTFrZkpuMEhpbmxTV3pwQkVLa2VMbVFBWlFP?=
 =?utf-8?B?cXJFMWRqNXVTalhLNEswckZMWTBYSzQ4ZklJb3Irck00azA0OHB0djJYRFZU?=
 =?utf-8?B?UTlkWS85TXl2VERrMi93Y2dib0RVU05lM3MyUUwxZVB4YkhpRklWUTN2Lzd2?=
 =?utf-8?B?TXgwNVg1azhwNGtjTEwrSksxS05TVVBLQ3VYdUVOQU1vN2RrYWhQa1NtWWZP?=
 =?utf-8?B?V2VodUI1eXpPNllYVGZGQXVEamR0K0U5L2ZjL3IyU1lZUGI3NHZHWEc2SDRS?=
 =?utf-8?B?bi9YN2NoTUg1dE1XTnVrdGJIaHhvL2lTT2oxUUVYUDdWL1hmU21RdEEvYlZE?=
 =?utf-8?B?V0JpdkFEOHJnVHlWRXJLdGNuaHJTZ0pGeUZuc0FwZDVsWnJYL2F6anA1eVJI?=
 =?utf-8?B?Z3BlVmF0ZnRZSEk2b1ZINGNnT0NubEJzT01QS3VYUlA5TjVrNXkrYk9BMlBt?=
 =?utf-8?B?N3JhOWY2ak9wL2FmNlpScFIxREdYQjZyRTExQVNKOXhxOUh6ZHpiWUhiVEda?=
 =?utf-8?B?bG1pSUh3ODhiWEwwRWprakhRREpKVDU5NDRkRkNLNHl1YlZ5dGNzMDVsZWpX?=
 =?utf-8?B?Q1NFeXd3TVhhdU1VNGl4YmRyZ3lTczZxbUhpZ2luczJHeTNwUjNRcGtEZWhW?=
 =?utf-8?B?K3VsRlp4T3dqMm5YZUlOTWVONmNLWlNseVZCNnRaYlB6R1hyOXhCb3pzQ0lR?=
 =?utf-8?B?dnN4c1pYOG51RDRmV0doVlJtVHhiVUV6WnI4RkhFL1VOTi80YXpJa3I5RGFs?=
 =?utf-8?B?Nk8yTFQrVEs4M1BiRnVaaEgvWjZqK2JCOE1JYkFBNWIwMlhkLzAyYXA1MG80?=
 =?utf-8?B?aTJNUmw2OXB2S1BRUkJVdDBYWjVBS01neFQxQ3I1UmxSaTN3ZmNxVTVRVEdr?=
 =?utf-8?B?VHFZM3ArSnFLQWROa2g4Mm9iRTNsbEpOOE9PYlUrSTJURmJXTjRmSVhoT2xl?=
 =?utf-8?B?NjNMeGYvNCtZNkduSTdVYXI5anpiaHltcHY3aHh6Q2NCRWt0WGU2ZTVZNjdP?=
 =?utf-8?B?RExhVDVUc1BiVjFOT2pzK29FQktkUnRhVEt2cVhxd0lTdzViZThGdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05854892-6956-4291-6380-08da3a1e8f4b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 05:06:55.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMG5bDACBj+0SZLwrk5id2KT4qjim1VOjing2dchg1DHVFL5Mvtf2nOCYfECRje0EWpvBH/Glxx/6RM7ioRyOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/19/22 17:36, Alaa Mohamed wrote:
> The continuation line does not align with the opening bracket
> and this patch fix it.
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---
> changes in v2:
> 	fix the alignment of the "DST, VNI, ifindex and port are mutually exclusive with NH_ID"
>    string to the open parenthesis of the NL_SET_ERR_MSG macro in vxlan_fdb_parse().
> ---
>   drivers/net/vxlan/vxlan_core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index 293082c32a78..29db08f15e38 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -1138,7 +1138,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>   	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
>   	    tb[NDA_PORT])) {
>   			NL_SET_ERR_MSG(extack,
> -						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
> +					"DST, VNI, ifindex and port are mutually exclusive with NH_ID");
it looks still off by a space.

>   			return -EINVAL;
>   		}


this closing brace should line up with the if

>   
> @@ -1297,7 +1297,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
>   static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>   			    struct net_device *dev,
>   			    const unsigned char *addr, u16 vid,
> -				struct netlink_ext_ack *extack)
> +			    struct netlink_ext_ack *extack)
>   {
>   	struct vxlan_dev *vxlan = netdev_priv(dev);
>   	union vxlan_addr ip;
