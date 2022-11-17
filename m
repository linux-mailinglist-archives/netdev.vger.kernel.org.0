Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E8A62D25D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238865AbiKQEkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKQEk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:40:29 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA799627D8;
        Wed, 16 Nov 2022 20:40:27 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH4e1Ja029582;
        Wed, 16 Nov 2022 20:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=DIzxxjTPgyXbM103hEUx5uEJIT/ZsJ8PhZiwCsO1sgs=;
 b=gPJaQWM1RCKCSDeT/c0H4OX/Ik+3/VAMIEYGJGNMVhnDghOWqb9rEYFBGypkHedGN9qV
 zyjrCn+5oSd5j2nSN86x43stvxyc/rJ4NVdRQHEneZ7LZBsF/Sg/nQ/FuHreE3kAAVn8
 9j4csQG/N1NfPJ8rC2CbAmd++vUNbrw9CkVsckPJEI3Rr9FjyMopPeLT5wmfakXHV++K
 S7sfV3msPPgXrxy8HMJIOxYuYl582em2uMT/kWCJ+A0RMTV6FYkYo2R7/pb83QWTUyAx
 NAgmwF6D0ZR5W94P4BI/3diqrVlX4fdCcMHNNbECJq6glRZxEf4QOa3gJkew+U71/mko Qw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kwbve02py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 20:40:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXHJKTxibN2VbBJxilk6AClS+qgcspEa3h8njv3O06IIfkmxzwHzFuJPkSoSLH68CbC/aTPVRwZhZ3uvqYwDltUSLbmPOgOllwjeqkrzpDicc6BXUszppWmF+tfzYyVbVTUw0cqpWdJzPrPg9xfWzypDvN0cMV6UVVtGCcurCGynii2/23XHs8BX3VM1vWlxZ5GNIWleFsLYAMJhV5XwRc1izS+vVEwe/kSniX+FSGn4/ZYNP7qzlI5Uf2BsEFlxVSaINeiFGC+bXpZchy2RSD7t+Gfwe/c8y3xMZEhvUwB+JTTzNpz5E/OqP+OCbDcN/KOIK4wZty7Qwo++ifF0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIzxxjTPgyXbM103hEUx5uEJIT/ZsJ8PhZiwCsO1sgs=;
 b=nzuWLB2eUn0dVEa5rb/BADFiL/Tu1CspTl1l31Uxf9bPAVTbxjIfVPB0CujnxKzgRfreQRAgPxfX7byaphbCwyW7T96Sb8gpSJXAKUv4dWPOiEJVCVbly+NGlgtGJ65f5sMkFfofiY2neIJt84qcWqlM4D4wb4/nLdMIfoFeJzqJmWScCTWVsD9gGxBUpPOyD1mHjQLlGRLjsyqJuMOwB/b5WlvdD5KvGvwxmGQrSWpYzgGLP/uoFkpdOIDSM6dHuwnTjz8JMZliPmlZRYUYSDeK4Y1VCTq6fk972S7zJiDNJUI5Uar+QqeZstnpQnIefq2AYl25os5K6i3ePw5LUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH7PR11MB7028.namprd11.prod.outlook.com (2603:10b6:510:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 04:39:56 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 04:39:56 +0000
Message-ID: <2d6e5cdd-bcfb-1632-1458-38d506e15b82@windriver.com>
Date:   Thu, 17 Nov 2022 12:39:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-2-xiaolei.wang@windriver.com>
 <980ef04d-a303-4a69-a980-0c910571c835@gmail.com>
From:   "Wang, Xiaolei" <xiaolei.wang@windriver.com>
In-Reply-To: <980ef04d-a303-4a69-a980-0c910571c835@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0223.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::6) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH7PR11MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b16f26c-1ebc-4b90-1cce-08dac855c6c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MY/b7gzYsWhrDIYDM5vHyA5KgZF64mPVHC+9ZA4ScVzJkrR4sxahXEJJeZWYVGmzXd5bSoK7ser1egdnsZGfKWZeBPPVgijZgGQB9Ybwkmsltmh27cFh4dXHuZ4UAD4jTycFUpit2XQsqDdO7R8LOExnIzJLDK3s+1UKCgK4OVW+DlfpW62HRubEaM31kn8TpLz6WhT4881RBfx6ytk7gRZZNPZkFZOtpsUS+96Een1nN2f1DIvvhax09sNYNta7/Ik7tJqedB5mtPtngWdu5jq2HUNpje2nCqAD08xN3W/gOiI5QAApFGbXJZVbMhJIQi9hFIxZh8VuNMu6o0hRjg8B+DkgjdxlWcCQPs5f/xyImxqf0pqrG/0BzSRmgegs+tUjVdHO/zeVXLx3CUkcLQLT1S4CzCOdD3pNKSxhMSJMG2fSL9HTPD290mo6Saz1B4R1eRPi2NGCIW1p+pQaj6yI8r98Bg7X1vdZeAyZPYnsIz4+Pb07VohZUSsyvJYaWHXl70fd3b37CW9qMZ17Tq0Kqw+WlLoM0NA3zx99xr2UmK6d0JiSLNUylBgs4gXQ0rQcF6fHWZaqJ8rkFg9pbg7ceSsJ2J7Cb9idXOTbFp8eghAssaa/RPpGg0g9GolnXaqfHmU2DPARl0emAE3hxzIyibc8BSp1d5YEYEb13JMow4zIBLclxJVXrXk20YNRSXzuoZZhrwLlM2v3gxxPxKeJVW7tm2BZIp9JEt3fltBzyv2kF5QPls55I9Ol2TKJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(451199015)(83380400001)(31686004)(2906002)(8936002)(478600001)(38100700002)(186003)(7416002)(5660300002)(38350700002)(6486002)(2616005)(52116002)(53546011)(316002)(86362001)(41300700001)(31696002)(6512007)(26005)(6666004)(36756003)(6506007)(4326008)(8676002)(66476007)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V29IUkczNmQ1NnE3aXB1dkFoMGJicnQ4YTBuZ0h3UEU4NDhFeHZPbEtmQUlY?=
 =?utf-8?B?OThmbExZNjl1WDJuZFJJZUNpZUhJOVcxYVBEbGFGYWR6SEdrelVYa2pUczk0?=
 =?utf-8?B?TDN6WThtaHlBWCsxd0tKVWVFTXhuQXFsWjZQdmtnRnZveUNkZC9wVDhmRG0v?=
 =?utf-8?B?WS91b0tvejNsUFdMVmR4d3ZZMEtNelZycCt5WWh4QnlWWHRvRFl5UHMrYkdC?=
 =?utf-8?B?aVJNbmlTWDR5MVJwbUVubmwwTllFcEk3cTVQZFNWMEpuRG9vYzVJWFhoSml1?=
 =?utf-8?B?OXlQRDJXK1ZMTDRFVlo1d3BtOSsyTE96bFFQQkFnK0REMEJGbFp3eVFiY25S?=
 =?utf-8?B?USsrSWRVZHdGNlRuUW1ja0h0aC9QbWNoeVZYdlRqSTBIMXczbkFBa2Q2RWpu?=
 =?utf-8?B?VDFyb0hHcmMyZWhHTS9yOWNiLzRVejVGZlc2ZkUySTNOb2ErQXVsUjlQWkQ5?=
 =?utf-8?B?YUZ4azFocVVMTU5BdHAraVV4bjFha2tRQ3ZOcm9EQXJBa2tEb2VsVEVOUmYy?=
 =?utf-8?B?eHhJYzcwNFM1S0tPVkU1aG9LVEdQYWVSUDFiclNxdWxSUVFPQTRYcjlOT055?=
 =?utf-8?B?d1BKZkZ4RTdTSU80S243RlZ3cGdIeXc2SUNrb3NBWXo3UFpBeUVwVCtFanFi?=
 =?utf-8?B?c1FxSmhURG5wWWRFaTIrY1hSNVBEb0hBMGU4U3RFWDk4UUtCMzlrRDNtZURp?=
 =?utf-8?B?R3ZNQll3UTJTVkUveFhxUitkdUdES0txR21FN0ZENlo4bzJNUE03TDJKSDA2?=
 =?utf-8?B?V0xSTGFKODY5VU51cGROK1lRWldTbjZKcGpWMmczNEt1cktVM25adEhMVkMy?=
 =?utf-8?B?dkI3a3kwWlJRbjY1bzhwUnBRdXdwU0lieWQ0aVByYjA4eUk1anJmeGprbVc0?=
 =?utf-8?B?RzY4ZlNFb0F5UjFsQnVtZndxZTlKc2RiNzJJYkhyMjlZQUVDbks1Y0Nob3U0?=
 =?utf-8?B?ZVg1VkIzWnpwRjgxV3FHalZxc3l1Z0tTT08xQnNVQklRNFd2MHNEUTU1M0Vi?=
 =?utf-8?B?VmtzcWhZU2JCMkhZeDVEU05MMlNBZVRlU3hnSXZuT3lweFRTb3dPclYyWGQ0?=
 =?utf-8?B?dEhVd3dObVRHNDRWV3hrNEZQUTJmalpIMzVQTHhpN2xMZ0ZXUWU0VVFPMlJV?=
 =?utf-8?B?dGVud1JvS21zSW9LZmgzU0w3KzhHdnFzYWliYzdWSUd6ZTBadWJPYWQrcSs1?=
 =?utf-8?B?c0NFZVBVdXBXNkhkWVRwdGtRTWNTQUxpWWRYRWY5NTlnL0ZkTnBCMEFxK3NZ?=
 =?utf-8?B?Y2hFQlA2Q3BNeWNpeWhOQlN5M0RFVm9SWE0vd21kd0hPcDk0QTV5L1k2SjBm?=
 =?utf-8?B?U3VPV3VmZDNjZ2hMcjZXeXhsTDhTcVNjSHpZQUt4WHhvbk1iMFNCaHpPeEs5?=
 =?utf-8?B?RjlsT1lhcitHK2VNdHB2Q1hRaFU0U2FqNzhvQXFTSDRaLzhTYW8yYnVQcEZz?=
 =?utf-8?B?bEwyOU5zMXhsUFBOYkphaWlnS2VDU2lyZ1dldkJpaVZWUHg4YTMreE05VGdE?=
 =?utf-8?B?SkMwbVNhTWZsL3hxNDgzYnJzYWNpaUU1S2VGZitMb0I5U1liZjZyaS9XT0Ur?=
 =?utf-8?B?RE9nYUpUb3JNMHVlSGE1Wm82b2JBY2RYejE4a2VsUC9nRmVTdWFvQ0tWYnA2?=
 =?utf-8?B?VzNkdlhKRXhtRVpkKzhlV001bUl1bWF0L25SZGh6cVB5VjI2T3Q0S3czaUcz?=
 =?utf-8?B?Tk1NUHhTc3pmVXJEWDM1YWZveU0vYk1QZVVjd0k0V1h1K1VlQ2tFdDd4d0ZO?=
 =?utf-8?B?TE5YV1gzeXpzODhNa05WNjluLzl5RkpCd1huLzJ3cDVCK2hZUjRWV0dGWlI5?=
 =?utf-8?B?eWRhQjFHSHZaRTdlb3Bvbm5sQVFpVkVFQXRzZ1UwbnZyRWUrVGdZWWVndzZp?=
 =?utf-8?B?eDZqK2YwT1dwNVd1OXFjZy9ITWJIRW8zYVpNZmhJZFl1c091RllQYUVtRjhE?=
 =?utf-8?B?SGpVWURxMDEyNzhIUk1hVzVhUlUzbzJqTTkvU2JIOEVzems4blhSVmN1SDNQ?=
 =?utf-8?B?aWoyTHJueWZwRWZmZ2o2bWpEdW9weHYzcnhvKzZUbUpIeGl0RlVpQjlUVU55?=
 =?utf-8?B?NXNMVDRiQ0JJUysxY2svNVlxVEpoeXNFUDFMcG94aU45UmFBc3ZBam5abTV2?=
 =?utf-8?B?WHg5UnlETVRlQUlpUmVodjh1YUJFNENBbXZYbDZqNkZlbTVKT1pRSTkyODlD?=
 =?utf-8?B?c1E9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b16f26c-1ebc-4b90-1cce-08dac855c6c5
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 04:39:56.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXhia86VyoW3iAmgboxUl3D66/WqqSeCmC94nZjR8e4+GUG+NLdE6gIpdyPujz1f5gFQtVQCSwUQMwbByIIFEMa0eGzwHcvaFmr2qPn0XE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7028
X-Proofpoint-GUID: zZF9qCndVSTQdLau22-mRJjQUmpQwS8v
X-Proofpoint-ORIG-GUID: zZF9qCndVSTQdLau22-mRJjQUmpQwS8v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_02,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/17/2022 7:22 AM, Florian Fainelli wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> On 11/16/22 06:43, Xiaolei Wang wrote:
>> The external phy used by current mac interface
>> is managed by another mac interface, so we should
>> create a device link between phy dev and mac dev.
>>
>> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
>> ---
>>   drivers/net/phy/phy.c | 20 ++++++++++++++++++++
>>   include/linux/phy.h   |  1 +
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index e741d8aebffe..0ef6b69026c7 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -35,6 +35,7 @@
>>   #include <net/netlink.h>
>>   #include <net/genetlink.h>
>>   #include <net/sock.h>
>> +#include <linux/of_mdio.h>
>>
>>   #define PHY_STATE_TIME      HZ
>>
>> @@ -1535,3 +1536,22 @@ int phy_ethtool_nway_reset(struct net_device 
>> *ndev)
>>       return phy_restart_aneg(phydev);
>>   }
>>   EXPORT_SYMBOL(phy_ethtool_nway_reset);
>> +
>> +/**
>> + * The external phy used by current mac interface is managed by
>> + * another mac interface, so we should create a device link between
>> + * phy dev and mac dev.
>> + */
>> +void phy_mac_link_add(struct device_node *phy_np, struct net_device 
>> *ndev)
>> +{
>> +     struct phy_device *phy_dev = of_phy_find_device(phy_np);
>> +     struct device *dev = phy_dev ? &phy_dev->mdio.dev : NULL;
>> +
>> +     if (dev && ndev->dev.parent != dev)
>> +             device_link_add(ndev->dev.parent, dev,
>> +                             DL_FLAG_PM_RUNTIME);
>
> Where is the matching device_link_del()?

Hi

Oh, what do you mean when some modules are uninstalled, should we delete 
the link?
My original idea was to wait for the dev (consumer or supplier) to be 
unregistered and automatically deleted, I read the comment of 
device_link_add, if DL_FLAG_STATELESS is not set, the caller of this 
function will completely hand over the management of the link to the 
driver core, then The link will remain until one of the devices it 
points to (consumer or provider) is unregistered.

thanks

xiaolei

> -- 
> Florian
>
