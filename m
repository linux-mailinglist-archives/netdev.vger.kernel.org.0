Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF36507130
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiDSO6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353558AbiDSO5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:57:38 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60FCB7D1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:54:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj5Bda7SV6IB66pbJm+Hli5VQvr6J8n3ng0e3khpwO/exf4F5wEsEuPWVbX6G+LOfXgjUsHf6+LiJ9fXUCJDDJStd3xsc1JT+J1o3hsJHwSJKvGjQt5FWTYDQvg4oBkJxz33RH7/vUzGMnXTPykGJq1pGJ3A9ICFN7TtXJMEMV/URaQ5PrXoVkvftHd197PGvevrDHoWcbC5kYw1Z3D8vWGxenp+yk8ObQoYu8TgP+oS9DvINvBa3olM6sycSLwPU4xCIBIT5zJApsHLRG76GbcACVqGuxV21i5kLMaRWJ+iGbsKmyWOiGZC80ol55bszRI1r/sIWRyxRZYna4wzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPW87FaUQEsbo1uSDFY+82+N5zqihGAdqU/dFu2UuYk=;
 b=GdobhfRnJ/P9JSREtRKZ2cLyOFd/XBucu5tHmdpims8n6AUiFdJ0Ua+3d4gY13bEjqIFf67K+TIQif2pXSbaB6yXh1Muy10Ia0r4o7mKY4yCL9rLEXWUAZTbicQ/+4BcGDEnf6nbQF6tcKjQfQqg+3iYFPg/8Oo+yMrpzsfiHIjO4iUPFzkOr72Zu+03SgOFT15FLOjgLejd+WFjalXcDlxmFSKAzbsS/AzqOu7dCLHPQB7UxxeUQYy86LHXcwdIQb3BMgaNz0aqqgFthyHETkcVnDvCg6qd6ugN3ry51bV/krnmcbr50neqHpRP03zUoDPvFNCuUbn6LjyywTC3+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPW87FaUQEsbo1uSDFY+82+N5zqihGAdqU/dFu2UuYk=;
 b=j9EE9FnQmbNcIs2mBn0yiJCtD8q78YAZ7Sykj+F3GbkSjnyEt8pR5dlaR9oPlgtC/NKo4M4k6Mn97yRbdTskVswrgYnJUOnmR3mON9TlKvAIznIUHrW7KT0Sh7oMHFivo1xO8iHe4HKGRfHEk249yMlTo+NpLSOIdQTHkW+TRisPxldvXSgDNaaa1zxNbmhg05uW+11C/MfZs8wJON+Jm9h7SGb+Tno15rAxgscAIqR5cWhLG2FByo53a9KjFte5zXCuAuEEkG2mSpOmAyQJiHLerfdk2dECLZSqLebFC32s356tHB5edvV0x+Sap9GqOOsqgP2DTwXtxY8w3H65hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BN6PR1201MB0196.namprd12.prod.outlook.com (2603:10b6:405:4d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:54:52 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%8]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:54:52 +0000
Message-ID: <e7f8ba31-e056-b8f6-d496-9c04ed15e852@nvidia.com>
Date:   Tue, 19 Apr 2022 07:54:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 2/2] net: vxlan: vxlan_core.c: Add extack support
 to vxlan_fdb_delet
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa.prabhu@gmail.com,
        jdenham@redhat.com, sbrivio@redhat.com
References: <cover.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
 <c6765ff1f66cf74ba6f25ba9b1c91dfe410abcfd.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <c6765ff1f66cf74ba6f25ba9b1c91dfe410abcfd.1650377624.git.eng.alaamohamedsoliman.am@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:610:74::16) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79647289-1ba6-4f9c-17c0-08da22148f01
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0196:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01968C9C89F717309411955CCBF29@BN6PR1201MB0196.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gz1+oCSqgTrRuiPtRiirgPT579uebhz7wVy9dn/lqhbBSCBQTeLizbyUE0SlaaVisHnieoUy9DW++L+yEYbxggqLkeFOPFxZet4TVsRz2dpTqVPOZvo2w5YMia699c/RY6nQ0Y2dWf9wn/z13RBt0hEnQEpSwrYEslmcasW0aqM6ctNtlrW93+07nGcwLinQTQhQKD5YLbm8k+DRLWT/38sDEmnI3sHkMjEY9bJ1MZFZ7bcFr7b4N7qgSpWeuer2qgnVEXQFkcEj1SSw3KdxTk5G3G2MA+s28C4TDoZQ0tqPMv9KsDsT9H/04ovoV/n1N69FhuzE5f+uzqzlP58YezYcwjoaxr93HM+P4gJuwk4pz01bL5zN8jwFKeT1oeQURDQYHXAAB2SNrvvjIYTAz48uCWDRwCWHBzyWTH7RE/ep+/SmWTITspsxmNhdl3uTZ4RlcwvpgdGzdUBvZk+w3YGHK9mtZojtB00NwHjiKUaSaxAA6EHTqpMTExIQTOqJAoDLmZcnoBLpXPUec5l2gDyaKtGicEWvDtQX0KWDKOsEeeEuyAmdp7RDIvWsKXTVNJXp1X9lvusEU/wPjBVGLlbJVOGRIeI8kbvPeK1O5AVWYznGHOJNpZLpg/tmWM5Oo4q0crywgb5Y3hXOPmxGZMaYmcaibVb2Elm+1nFgYqfIpwMGx7M7WnNJ6NndktRV25agKkLHistehonx6H7XHC/JJGo48GT9zhPpj4XEqgw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(31686004)(31696002)(6506007)(6512007)(26005)(2616005)(6666004)(36756003)(186003)(38100700002)(5660300002)(53546011)(66946007)(66556008)(4326008)(66476007)(508600001)(86362001)(2906002)(8936002)(316002)(8676002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2FNV0hIdnJOVDU4MEJzZXRrSTh5cUcyRHRud2lUbllHRGtZVTlkRnYrWVI4?=
 =?utf-8?B?MWhwVzZKWndBa1JTSUovdGpwS1FvVzdCdm1tNUo1dW1Tc0EyZ2kwZEdvM1JC?=
 =?utf-8?B?OVpSenhhWjZ4RmkxTExoUmRCZFdOOTNwVzltMmRsbjZsOTJiUkx2cXlJYUt0?=
 =?utf-8?B?dFJzbU5tbDRCbEx5eUhxdTA1Yk04OTVvZDZmeWFHWHAwaTI2Yk1xVmQ3UmRF?=
 =?utf-8?B?dlFCV25tb2tMdmZHWVM5RW9FU01UM2ZjVjRZZ1NOZmpHUDNHQml3eUo2cnhs?=
 =?utf-8?B?SERkQnJML1pmYmJsMkFqakF2Z0VMLzlFeDNPUjR4ZWc4VUFuQmd1Uk9YRis3?=
 =?utf-8?B?N1gvaE1rOFBkL2oxUjg0UkFUdCtDNEJqbmtlbVN1MUI4Qkc1T01VR3FJOVBH?=
 =?utf-8?B?Tm5Nc3VmUTVUMmNBdjY3OWNObEtDRGJUbGpGemp0cVhZbFRsVktVUmF2VkhZ?=
 =?utf-8?B?TmNZUS9YSUR3WWtPaUlBUVVQQkV5VHJoNCswcnpjOVk0eW13M0lOanpkOEl1?=
 =?utf-8?B?K0FQNC9PTituSVoyMnhiMnR0NklOVTZkUmM3aFFqY3RrTWlBVnZRdUE4bEF1?=
 =?utf-8?B?ZVg5dW90eFRUOVJWMW5QRUpKYlBTcytCTThaTSszMmdwK2xuVVZ5Y2JVTDJ0?=
 =?utf-8?B?MkswOW9LY2pIeDQxZ0VPRHBVVjZCUlE1Vm5JbkgwZDk4RzhVZENKUU02RitT?=
 =?utf-8?B?QlpSbzJFWFlrbE83SE9rbS90WGRBRzZUbjNhYUhYZXpRbnlNY2YxSzZsZTdv?=
 =?utf-8?B?QlNwTjNlMUQ2TkFGc0kvdjFQMXlRc1pLcTdsbUZkdHFKRHowQ1FUU01wYW1v?=
 =?utf-8?B?cC93V1Uxa2R1RmtzYjIzZ2I4YjRhb2tBOVRkdUV1N241SnhCNmdpYmEzSGp5?=
 =?utf-8?B?NUVYOVMvNmJIRzVMYUdvaUVJL0lncUtXdTBXU3BCRFVEazlhQkZwcEJQQnlw?=
 =?utf-8?B?VHRudFFyQWwvYTJRbDZJT29PTGo2VXRtTkIrdVBHRCtkdVllL2hFZzhwV09o?=
 =?utf-8?B?N28rYS84dmRkRHZEN0xjY1ZQK2pHRUZJT29pTytnTnBLYTJFMkFUamhJNTNE?=
 =?utf-8?B?UHd6bWhWV0JLUnVVSEY2UjdGbWtkRHBaNVZnd3hCL2prR1AyeG12dko4UXNm?=
 =?utf-8?B?TXg1YmVrVnNneitsR2RuK2c0UFE4TTNDS2xWNTdWbW90KzB3bW8yMCt5aktH?=
 =?utf-8?B?a3NmZElDUlZDZFVzOWo5ek01WVJrdVpTenNrekxzWU5BYzY4SlFZRTg1WTNY?=
 =?utf-8?B?dTdiekJKR3BPY3BtL1QreXl3VFNqeEpTVDNYNHQwUjVxSTZQZTZDSXlCSFYz?=
 =?utf-8?B?V2RLclVLOFFkZElldmhJSUhHOWJJa3BNY2dvemlDdWx4NmpnTXlWcGVaN3kw?=
 =?utf-8?B?VkRHQVBVcFpRcnVONHNnKzdSTVRVTUtkT3B0WWRYam4yTlk2ZHdWaXhmTU0w?=
 =?utf-8?B?bG1TUDFVSDh0V3BkbHhORkl0d2VsU29SNjNOc2hCWVBxSEFuY3RaVHVuTE5n?=
 =?utf-8?B?ZjFWMDVSRTlRSmFkUWlzV09oZStoK1RXV2xPcFBjemJiaHBDVG5hSTZUSHBa?=
 =?utf-8?B?YXNvNXRzMG5IcHZzSWEwMkdiV3BoZFAxTHpkTHJwczgvRlplZDlqT2xyUzlr?=
 =?utf-8?B?ZEFVN05UMWJmQWhlZ0RIaDJWaTlqaXg4QklmUWNXa2ZDWEIrN1VmckgraFVm?=
 =?utf-8?B?eG1RTzFaSTB6RnZVS2x6alJDdklpQ0ozVTJOc3YwTGJQcm5ZaUxMbHNwWFhI?=
 =?utf-8?B?V2VET0ppQXU4Nk95MGlmQm9aUEpNdGc4MTlaclpSMzgzS1FhQXJjTFdiaStU?=
 =?utf-8?B?R1paV2w2NzF0WE5DbEtSNFQ5ZDl3NEtrV3dVK1lwc1FYZ045SyswT2pnU1dP?=
 =?utf-8?B?Tk5EaHhWdFZPd1krVG13Q0hhcUw1Nmh3NThNNjYyNlJOWExtS09JK3VJZjhL?=
 =?utf-8?B?bjBWZFUxSC9OSmY2TW9LdWpENVhpUEtyVTdsTEU1b214OG1MckVXZjdFbEwy?=
 =?utf-8?B?SURFeTg5SjBaVmpXQ0EwWEFsbDlDNXgwQ25QN21WdW1BKzZNbVNoVEMyZGZK?=
 =?utf-8?B?S3VoblY2VDY5Q0xTZlhkU3pzdS83OEg0eVlFYml2NzgzZ1NSOTdxM1I2bEFk?=
 =?utf-8?B?TGwrS1hkQ3p4bWw1QlQ1WDRVNnhJdXpadDIzT2x3Q2J0bjVpL2FvYXNrMmh2?=
 =?utf-8?B?cG5BL3g1NVIwN2MxTEZISWV4Rnd3eU5HU21HRkRoQ2NrVUlMMlYvUnMwZFBP?=
 =?utf-8?B?UC9QM3ZFT3ExRi95OXpwMUtoa1A0RC8wUTN6Q3VITlkwbUlySlN4bHdxNWhl?=
 =?utf-8?B?Qm9vaUFnQXdPcHcyZFh1aDVOcVQ0cEdadkVzYzhOdEc3bUpyaHlpQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79647289-1ba6-4f9c-17c0-08da22148f01
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:54:52.1968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3midtFs+LEJn7YmTAWpTE3txB4nBPcxP01/vSMuUbOUygukUMP25cSulBXxF30HKyEu0Om29HuZAyvPai4Gzxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0196
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/19/22 07:37, Alaa Mohamed wrote:
> Add extack to vxlan_fdb_delet and vxlan_fdb_parse
>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---

Alaa, minor nit: fix spelling vxlan_fdb_delete


>   drivers/net/vxlan/vxlan_core.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index cf2f60037340..4ecbb5878fe2 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -1129,18 +1129,20 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
>
>   static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>   			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
> -			   __be32 *vni, u32 *ifindex, u32 *nhid)
> +			   __be32 *vni, u32 *ifindex, u32 *nhid, struct netlink_ext_ack *extack)
>   {
>   	struct net *net = dev_net(vxlan->dev);
>   	int err;
>
>   	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
>   	    tb[NDA_PORT]))
> +		NL_SET_ERR_MSG(extack, "Missing required arguments");
>   		return -EINVAL;
>
>   	if (tb[NDA_DST]) {
>   		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
>   		if (err)
> +			NL_SET_ERR_MSG(extack, "Unsupported address family");
>   			return err;
>   	} else {
>   		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;
> @@ -1158,6 +1160,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>
>   	if (tb[NDA_PORT]) {
>   		if (nla_len(tb[NDA_PORT]) != sizeof(__be16))
> +			NL_SET_ERR_MSG(extack, "Invalid vxlan port");
>   			return -EINVAL;
>   		*port = nla_get_be16(tb[NDA_PORT]);
>   	} else {
> @@ -1166,6 +1169,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>
>   	if (tb[NDA_VNI]) {
>   		if (nla_len(tb[NDA_VNI]) != sizeof(u32))
> +			NL_SET_ERR_MSG(extack, "Invalid vni");
>   			return -EINVAL;
>   		*vni = cpu_to_be32(nla_get_u32(tb[NDA_VNI]));
>   	} else {
> @@ -1174,6 +1178,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>
>   	if (tb[NDA_SRC_VNI]) {
>   		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32))
> +			NL_SET_ERR_MSG(extack, "Invalid src vni");
>   			return -EINVAL;
>   		*src_vni = cpu_to_be32(nla_get_u32(tb[NDA_SRC_VNI]));
>   	} else {
> @@ -1184,10 +1189,12 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>   		struct net_device *tdev;
>
>   		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32))
> +			NL_SET_ERR_MSG(extack, "Invalid ifindex");
>   			return -EINVAL;


Missing braces.

>   		*ifindex = nla_get_u32(tb[NDA_IFINDEX]);
>   		tdev = __dev_get_by_index(net, *ifindex);
>   		if (!tdev)
> +			NL_SET_ERR_MSG(extack,"Device not found");
>   			return -EADDRNOTAVAIL;

same here

>   	} else {
>   		*ifindex = 0;
> @@ -1226,7 +1233,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>   		return -EINVAL;
>
>   	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
> -			      &nhid);
> +			      &nhid, extack);
>   	if (err)
>   		return err;
>
> @@ -1291,7 +1298,7 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>   	int err;
>
>   	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
> -			      &nhid);
> +			      &nhid, extack);
>   	if (err)
>   		return err;
>
> --
> 2.35.2
>
