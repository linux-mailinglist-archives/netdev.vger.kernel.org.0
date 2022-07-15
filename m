Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678415766AB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiGOSVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 14:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiGOSVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 14:21:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE026050A;
        Fri, 15 Jul 2022 11:21:30 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26FGH5Aa016541;
        Fri, 15 Jul 2022 11:21:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6Dk+kpsEU1bHhYIdXLh50f4AAtXgquOX2kDkHBIMQrU=;
 b=jRh2d8Bwq4bv6z+IkG00bYVeSsQmYGDNy0YwTprjBC2mj7gqYh1jOduWNBu1ApLXd2bP
 wHVgv3WNNnQkID6RwhHLoQvh4n+nSV/uMw6uVZUVldiLAnqO+0MRNo063mvgYnJdR3J8
 xa0F/OMAmFQGBsK5Hn51Ov+h29qO9bK7wHw= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hak159eyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 11:21:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BF5O7tOzMZvpsGHVP3+x5k46BNoX1ntogSIbtOmbBf8EwDuHFzV41r7bu0bQiPZMiO56SuMYfgWelfD/2EMk1f2slKrs0/ej/asm+eNzHT3hASR1+jXZQi6R42TFxNyVvIFtVQH73AU15hIR11tfve0RMgN0bMXJZrSBbSnc2oHqf6wJ1BFAwjWKij4h71SV2plwVW7AtfZbIHMgG+k9U4svcNgk1tJ+JNT6+KLG/GI74W/jmkuVcfr1bySeLgExj6G0sOIQM1qFmawDT1CdUHb7jWfNIIBA4Jy0viczZ2U4LhtjN6DsECS5uTKLbl7xBmQs028hSoJPJnVNp0SjRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Dk+kpsEU1bHhYIdXLh50f4AAtXgquOX2kDkHBIMQrU=;
 b=FzBjJpeZrZYtvNLc33N0eGwbQjcalhbQOZ43krKtMvRglu696T9TVG+NaLVAafRKBBQZ3ZUeIxcIrEeD1P4qPmUMO4qElNWi74V1ws7bcRzY1sYqQbU1adDrSMz8eiaEDV4b4Lkko/XiiJGJhWihZobIgTpBv2seiWsSFspsgNz4wGcPm09r5f4VUPuYw74HaJkhGK3tmgjjvaJQDZ+pbI9QXbXeD6QZYiIM8Sh9AOR9CAajifhVHrAL8lzfr0L+WJuxUA5Y6CAiNS9fvsUzH8s8afrOZ1jES4hU2f0x4pY/Gnk+tDJg2BcvWZV6Bp7QSRGnnKh2ATvQBJI63OsRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 18:21:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 18:21:11 +0000
Message-ID: <fe77bef0-bbfa-261d-6419-548160c986e5@fb.com>
Date:   Fri, 15 Jul 2022 11:21:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf 4/5] bpf: Set flow flag to allow any source IP in
 bpf_tunnel_key
Content-Language: en-US
To:     Paul Chaignon <paul@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <cover.1657895526.git.paul@isovalent.com>
 <627e34e78283b84c79db8945b05930b70eeaa925.1657895526.git.paul@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <627e34e78283b84c79db8945b05930b70eeaa925.1657895526.git.paul@isovalent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:180::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51835c02-7212-494e-624a-08da668ecb92
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fbIr1TfeulOZmUH4A4jqG0RYzLLUZPlHjROREi65z9gpxvokpNnxB+sOE2ClNMsvZKahfkR68ROkgGFTq94/Se8l7fLGIF05JMyCcb1qvpUuboeOpr9fd+uhXUY7WOaqv9bWXGqVF9OmjyYvj7OwRSL3vwSSTVqYWH5aR62XoaTCAzNxn14KxMnlmdT1CPcc3uwwK0kPcvDlqry9L20i9PzPR4P2XPZ/Ou1NBVNFxLq+RUE2ZIvOOPaAj+N/aI46n7uOu+UjXrKuDhsSJy+GUys6B4JvN8VJgiZuHKQqVoECsSZFFSmzWgpfmzcG1ywQ6tsuaj3Idk/71BOJCYNjkahENtGbZVTqLQI2AnNKSDOKyuTx0vKQC2dkgaSgpSv0imzRTJ5iNhLTGyTUSSPNRCdigxSrzi+Uq5sEnuAw8B8zFAcqcUAcEKCAo4q8nNj/NGSKgo5FJDxVZy24SNy3MNfDHOrmuN33C6qzggqkc2LYEfXfG/mBNkq0r3mXJFb2T2+R4w/HMnrNxiIDzbQa/ysqf5EQ4MqnK97gCkusRUpvtNjmheTKmRllGKaN7ctqAmzEfYYohqkwmUEUHuM6JHqf5B5IV3grdkhVcatOx2Qnn3W0goID3g9EOm9COnLl/GTTdoPJpN0lHgbe8aqwPhTRE3rNIRl9VZeFDClTsWlJvXJz8k2wwMNNdq9Nk4hDutBkJ5PS1HCFOda/Kk8sQoQQYb8OLyepJ+ympMnMAtc4wsxDGXcKtiMysupTIyCWzGh93H/XKSvsVH2FiRkGiSShcmZTnLn4IqY9647pp33UFcmGepe4AabVteirraXwxsu1DPiJSHtq/dAM5gO5jQgdvywRMCYPgK/vwnogi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(6512007)(4326008)(54906003)(110136005)(53546011)(2616005)(41300700001)(478600001)(86362001)(316002)(31696002)(6506007)(6666004)(6486002)(38100700002)(8936002)(5660300002)(7416002)(66476007)(66556008)(186003)(66946007)(2906002)(31686004)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTBiZkVUSmFFaWVBODREY3pUUnNVZ3RSNTkydGYzWmxSbEFTVTBrc1M5Qm5q?=
 =?utf-8?B?SmZpNmp2OTkrUFlpa29SMlJXdGIyWWxPTktzaENja3l3U3JGWmhHL2VNYVAw?=
 =?utf-8?B?TSs2OWxYelVjV3FPUGt2K3FFNWlSSjgxMWorZXBmNmZnbjdEMDd1aFdHYXpz?=
 =?utf-8?B?a0hsZnVYUDY4MWN4cUFLenFmK2k2NXdqNmJCaU1tdTBjdElkUFRLVEEyd2pR?=
 =?utf-8?B?NmpKWHJpQmVheG54NHpTdU1JUUtaaVFHT2hsY3RvVlB0NnZRcHpTbXlpNTZR?=
 =?utf-8?B?RU5hb2JDbTJhdHZvcERIa28vU0pkc29ibUhyR0F6aUJObytXRTJCbHprQ29T?=
 =?utf-8?B?ZkpJdjM2QVhWcVptUVVOWlRUTlpNbC9IdGp4TU9SN0NoQmphQkVvUGhHbmov?=
 =?utf-8?B?aitwY3pyc0tLWGJVWlFKZUtxRmFUbW41bHM4Y2xiVzA3bTRDbmRFUDg2UTRF?=
 =?utf-8?B?a21uRVlIZ2Z2VE9sYkZTYkdhUXhmV1hsbjJ1enUxL1h2L2VraFFTaE83d3pi?=
 =?utf-8?B?OTJOQUZ4Ri8rc3d0ekNEbEJhRHhSV2VrcDBQWGlkbE8wYkw2bm9rMnQrMGRv?=
 =?utf-8?B?cGlpSEcvaU9QN2ZPOVI5ekFUeXYzQ0g0QmdsWEQ3UHR6aWIxNnJGd3FXQVNh?=
 =?utf-8?B?NDhPVGR0WGM5eis5VXVIWmRXSVVaKzR1NVhVNE02Q1U3alRUU1VBdnJPNUZy?=
 =?utf-8?B?ZnA3NjI4ZGRzY2hqQkhwMjlRVzBNNnhoMzBWNlYzVlhTdUtuK2kybFJWRTZF?=
 =?utf-8?B?am9LbnBLVXA2WDc2VzA0OWFWemswK2NMQ2xBQUNkRFptR1kzWWcreERqeUZr?=
 =?utf-8?B?cmQ5Mi9PdDQyOHZadUlhQ0lrcmdhakUrY0tSdkhBZ1Bxam5sWGhTazRrc1BP?=
 =?utf-8?B?eHlha2RocHArV01wUE5rdjZIQnc3N3hKbVNtUVJ1OUF1b1c1VkVTVGlTZE5k?=
 =?utf-8?B?MW4yaFlKWTVpNHEvOGZCMHcxWmkvdHc1bmNhU3ROa2Rmc2tvTFpGU24xOHky?=
 =?utf-8?B?UHJtb3hTdXlyQUl4ZjJlNXpSZFplVkxYdng3SmM2dVBEc00vNU9VQXY4R1R2?=
 =?utf-8?B?bEZlVDdLc3dOZ2xNT09TNktFaDFydGl2SncwVnd0bWVVa2FWQTdKTEVqM0t1?=
 =?utf-8?B?Q21iSnljc1NVbG91aHpaUytvOXhZdTFCTVV2M2ZEbXJiMVkwcWlvOGxvbXly?=
 =?utf-8?B?eUdhVDRBdkxBbzk3d3lyRWd6VkF4WmFueTh1RzBUb1lSc0hqNzM4YWw5UnZh?=
 =?utf-8?B?VFFFZ3VNQWVBZDNKdG5LTlNiUVB5QlN1NzNiUTNwVTd2V0dBN25EWkJLL2ZM?=
 =?utf-8?B?VmNtYjFSRVA3Vk50cU5ZMXVwaWh6c0wwcC82WEliOFRrT3RHbG9HWnJiRnJD?=
 =?utf-8?B?bCtLazhuN3JBcnBCOHFvbnJnVzg2N0tvZkcydzJVeDdib2JEMEJMejh2cXZJ?=
 =?utf-8?B?c3NQTm1UQUJYellQMno0cS9ZQTBxc3pYdzc0Q2pOTWV2a25xdDRqUlVOSXVs?=
 =?utf-8?B?UlBmVVZHYzRySFZWYkVRa1lHVXhQMlVURU9PQlJjQ3Y2aFk1SHlRWFNzbXBQ?=
 =?utf-8?B?ODF5UWRDdkpWMUsrMGVWYXNBbXNmdVc0TmdEQTVnNHJabTZIRS9hTHY2SVJn?=
 =?utf-8?B?K0Q0Z1NYZW1QbVpLOUtIZTljdHJGaTdpNkViRDAxeEMxUG1hcDhSbWdYMVBK?=
 =?utf-8?B?UVdlRnVBZHhZYVBQbEFnSktHaDBQejZ3em5yaTZEOEQyUWN4dEZiNjRrMjAx?=
 =?utf-8?B?aktyVmxSbzkvQmdtU2lXbG5TUUplKzZONUVLTUd2Wm9YZldTcmdnTTIyQndN?=
 =?utf-8?B?VGRRbFZDbTRjNGJ5MXg5b0FLM3F1T0NlNEhEZmRPS2grZHduak1Zb1ByZDQ0?=
 =?utf-8?B?Wnp5Zm1MWStpUUMzaVlkY0RnRS94YWxpeGtKVDFsVFdCb3VYK3RpR1dLTU1X?=
 =?utf-8?B?VFNQVWpRNU1qcjZRL001aEtlSHVZRTMvb1hpMGZyR1BUZDZ5MXMwQy9QK05k?=
 =?utf-8?B?bUUzSnB1d0Z6d0d2cHdtWmErRVNPWTVCMHdIcHYyY2oyU0ZteTlJSlV6M1pJ?=
 =?utf-8?B?eVd4VTc5TUdLVEhjNVZMbXNoQmhVbmZvRXMxWU5aVTY1QjVYbjhBZUlwSzNJ?=
 =?utf-8?B?T3NvbUFpd0tEaEJnS1FHR1J1WkM1Szdjd2lod2R1eXhkSlo0ZDg5MjAyKytp?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51835c02-7212-494e-624a-08da668ecb92
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 18:21:11.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGeu7Tw9tGRGwLNku32u5WuvuiQllcRyz1xUCv03M5yVV7BnfcuAyVvQiyYzLrO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-Proofpoint-ORIG-GUID: Jm8XcCfrJt2WMYOztLsIX-hcIRvgU7Va
X-Proofpoint-GUID: Jm8XcCfrJt2WMYOztLsIX-hcIRvgU7Va
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_10,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/22 8:02 AM, Paul Chaignon wrote:
> Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> added support for getting and setting the outer source IP of encapsulated
> packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> allows BPF programs to set any IP address as the source, including for
> example the IP address of a container running on the same host.
> 
> In that last case, however, the encapsulated packets are dropped when
> looking up the route because the source IP address isn't assigned to any
> interface on the host. To avoid this, we need to set the
> FLOWI_FLAG_ANYSRC flag.
> 
> Fixes: 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> Signed-off-by: Paul Chaignon <paul@isovalent.com>
> ---
>   net/core/filter.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5d16d66727fc..6d9c800cdab9 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4641,6 +4641,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
>   	info->key.tun_id = cpu_to_be64(from->tunnel_id);
>   	info->key.tos = from->tunnel_tos;
>   	info->key.ttl = from->tunnel_ttl;
> +	info->key.flow_flags = FLOWI_FLAG_ANYSRC;

Can we set FLOWI_FLAG_ANYSRC in all conditions?
In lwt_bpf.c, func bpf_lwt_xmit_reroute(), FLOWI_FLAG_ANYSRC
is set for ipv4 but not for ipv6. I am wondering whether
FLOWI_FLAG_ANYSRC needs to be set for ipv6 packet or not
in bpf_skb_set_tunnel_key().

>   
>   	if (flags & BPF_F_TUNINFO_IPV6) {
>   		info->mode |= IP_TUNNEL_INFO_IPV6;
