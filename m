Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3A03A213C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFJAUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:20:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJAUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:20:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A0FZNj020471;
        Wed, 9 Jun 2021 17:18:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J34feOJHKx1AyuSQ65XUqaVzKmaCPHgJstKACdEw5Zw=;
 b=IOgg+Vmu4v4nHMgVpkKIKz1/nSKsrM9K3Rv6IbWxne8Saku9ZO/rggn5pOTbrioqrt8R
 ZU1iK0dzWjqL5aZJOFmNZKruG0FXy1hDo0g5fvTGoCQYsMhHIC1y1Q2PN3Hjl5JG6Qef
 9Jz7keqMCa/miUclB38815m1N9a1iXCEyws= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3925y2vgfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 17:18:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:18:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbdSEu/0u3rUUUgvm+WW91soFKQZ46hOt4tvxZViaqliEqp7CUlp1MhIkFyUf2wB7+7WUZWDRAcpJiK/6pJYFVN3ooKdc4bMdNd6IxnfUeCtzPie3DfvNeiZycA1uwipk5Zv1zrDKeKBjfBRAy9Cj/l+MZRKDwz/0/iG7sMW1AMbD7V+MGESlMPEhWlO0IHGvDNhyZnfgvlRTDNbCQC17pnMQSJvpOvIrHYe1A5hfE5l41aP9wqep8mAEB4+3yjnGAPSBS7FKcIoSAadpAw/gar6Tmco6X/YCBLdzusYmh3yc4BOACfau82lQEnSzeHO0OwBQTIexNMDePFH4FX9YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J34feOJHKx1AyuSQ65XUqaVzKmaCPHgJstKACdEw5Zw=;
 b=bzJorR/Ye864rnWhK51xo4h19wWAE+WEyXLu0nl9DkqMCO/1BrDq51MUxxZXCd0IEMBbu72foGtnGAJiIccr8oOTs+hBiXFWAUL+6NJRrgBO8huic/Sz4pZ4rtGnrLV1JiqkAtRtGOYU3Ejwz99M/D7U7F5WdHmuUHczAryPqie1M27lSZegJ/hEmw7HrciIkNWItEKHRrwvmweD0AM0JHqc3gcczm6jSH6Lo5f1r4cO+evDP+MBphRea2EZizy2oPDpl+RoHvhtrbYCn68MFJGQYBP/YST2nYmUH65XtpZU1MiV9BRY+LipsSsK7/zsUioTPll1la+a+V1MSvQs3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4176.namprd15.prod.outlook.com (2603:10b6:806:10c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 00:18:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 00:18:50 +0000
Subject: Re: [PATCH bpf-next 00/17] Clean up and document RCU-based object
 protection for XDP_REDIRECT
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20210609103326.278782-1-toke@redhat.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6f212b89-7b55-0545-7154-f75e93b3e076@fb.com>
Date:   Wed, 9 Jun 2021 17:18:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:92ff]
X-ClientProxiedBy: SJ0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:92ff) by SJ0PR05CA0018.namprd05.prod.outlook.com (2603:10b6:a03:33b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 00:18:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c804472-042d-45be-4e80-08d92ba552a2
X-MS-TrafficTypeDiagnostic: SN7PR15MB4176:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB4176ECE3AD6A2A319424F050D3359@SN7PR15MB4176.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCQj3vqWM8OKv9nBU0csWG5JL7yDgTbAwVXYYB5s2u/31eDxKzQQfoBBI0LH6m72JT83eMH7M6v8m7JUnXNv9d14z98OWDv5m04rzwuF9wcrkw5MH5aRR4gP7Ne5EjfkayjccJFnauIOVR5Oi+50VqaMtMDAtCGj1sYHBkWom7WdMgq7qjiB54+b0H8vmDEg2J1WFEDYwFiw2J8Jn5/taNwNug25Zz9xy6u2zYPp6I2cOo+JzfjzH7oK25YykxN7XgvW0P0OSBukOHtZao6KozC0St3Yzbh64CgYM2YWxYRbGAFUqUj1bTvN4w4sqqz6yNaey7YkL8Es2ABf3o8tNVGmvmSZaZqRGKurfqUqFtW5kSah1enPVHCMhYMyWYAl3HxZEkjbF/ERd6hc1Iv+YA+J6BUj57rhC7pYSftykr7uqT7Jp62L2Bkv7AZ+ZITfGgCrzjglOgmtMF8pnGSg61avxakmrOd9pbaztvgch/DnGfM2L9Prr3RdwnlInT1+wE2nmm9Dh7AflDpBF/Lt21+VT709x7naEXXxxHSbmDstu0LC3sk4bZJYhqU0EU6H7H9wchoDiyz56rubc/HHSilt00FA4zkskeBS7E+A+VUYyz9ctoYx//7mBfFdo0P2ycDRWA7Dg93r5nXiiDJDeF7BqlftA+x0bhNldkKQw5LOr9SU+lME4EKFBy2kZO6N8OxSisHBP6MAfFy+yljr8eCOok4iERgQrE5moOJXql9Sz23jv815GZtuO2XRn5NBpi39xnkAe8nqojvFId5AbxVmtyb2V8KDeOnOM7O3tqUnCJpgh1vQOcEq/8ycMIjO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(4326008)(52116002)(54906003)(316002)(5660300002)(6486002)(31686004)(31696002)(2906002)(83380400001)(66574015)(36756003)(186003)(966005)(8676002)(2616005)(66476007)(478600001)(66946007)(16526019)(8936002)(66556008)(86362001)(53546011)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlVuZzVsWWxTVUErRWgzd2N5c0tFL21ucE5IYmUrQms4Q21lWDRRWnEraFd6?=
 =?utf-8?B?OEpSejRpRDF3UTJmeTNwZFhNa1A4VjlDRTAzaHB5TGRhWThOQTlremtLeWVR?=
 =?utf-8?B?T2dHVWtZelZzRlZ4VU9CeGZVQ3pDTXp1TFZWNWhDWk04d2F1NnFXYlhNd1Zh?=
 =?utf-8?B?UkdnT0VvaFZYRFJQQndDTmhiZ0NKY0xDbmxGUWRyYjF4L01NMkxvNU5XbzRL?=
 =?utf-8?B?aEFEbDFMcUg1S3F0S3o4U28xZ1N0eUV2R0NOVmxFOUE2QWNJVDdiV2RTN1ZB?=
 =?utf-8?B?azBtTU9uUkltVDZPc0p0UTlEMTQzN21CMU96bTdwUFpFRENSazFJYm5hRWNo?=
 =?utf-8?B?RlIvYmRDVmtQcHRqcGhlVWxwV3Vocmhtdzc4WEw2RkExOWRQZWFDNHNhUXRL?=
 =?utf-8?B?Ymo4d3FnMlkwc1lpTjVBd0Nta1FmVmx6bTlXelFIUnM1OXJRTTAvYyt6NW4y?=
 =?utf-8?B?dTgxZlAzSHVlRVdwTTFlWmdISEV4OUdDMVhuQldsYzkwZnlDSzVOcG51UU93?=
 =?utf-8?B?a1k1VEV5QmkybXNORVlESnBhcTNaUGxDemo4VzQycHN1aXJFT3p6ZExlV2Iz?=
 =?utf-8?B?K1lYWTZhK0QrRmM5anZEY0YxZDRYaWE0L1ViamlQRmlJR3BYVXR0bGdYRzdH?=
 =?utf-8?B?OWdmNzBwc1pnY2EwMDA4UUhJQ2h1b1lsTzkxUm0xSWl0bmlzY2VoNEJsRFd5?=
 =?utf-8?B?SzJOS0k0Rno0aHJpTzM4VjgxTjJKdWZ6R2RRd0FRRnBxdFlWanhwOHQvcjdD?=
 =?utf-8?B?bG8yVCtrNnZVOHloL0NmRUgwb0xtdlRXWGs3amVUTXRXenRGUkJHVHlkb21S?=
 =?utf-8?B?V0N3dXpUUG9vZDYxclY1MXQ4RVJ2QVpZalkyY0U1SzZmMG42ekppTTdxaTJP?=
 =?utf-8?B?OCtPU1J5Q3A2NTBZNG45SkIxTlhiR29tMWE4eHlDUlVtclN3NG1jVzh4ODNn?=
 =?utf-8?B?NXZqUG1sb1RwUEI4RnY4Q1NrUU95Y0ZOSXd1RmRoU2Q5ZWRIV3gxTmdRVmVh?=
 =?utf-8?B?WHhFMGlmTmgrbk1yUG85L2ZYcTZpMHJLN0JBY1hWNmpkR21EeTZ5U29mSkM1?=
 =?utf-8?B?aVRWTk9iVVQ1dXJlSmpjdnFsUkMzajQvSlVKVmZOUTUzUVZYWXN5U2VhcFBC?=
 =?utf-8?B?TlJ2OU9lUUtLd084dTUvRVIxKzliTm52NzJybVZiV1h3eDhQQUZuc0VnUEtY?=
 =?utf-8?B?NFZxQ0NOM2lKbEwvS1hkM0dNeGZiYUsyT2x5LzVua1NwMXR1dmhldGJuM1FW?=
 =?utf-8?B?alZwWE5uMjg5QXpEN1dqdVJlYWp5YU9na1hkOFppREU5Z1dQMXNLRUNQTXN3?=
 =?utf-8?B?L3VmZTAzWndGRk1wWm1iUXJwUDhaRms4cEJNbHdaaGhGTlhqWXBRczgyZURY?=
 =?utf-8?B?SHZFWDN2aVI5WjdVd2xCSFFQckh5Wmp5ZkQvQjBydXppcGpuTnZybU1KS20z?=
 =?utf-8?B?OTNqUmh6VzdVdGJEeVFFV3FFTTI3cUYvK1Y3cXZnR21CdXp0NWFpRHV2Vk5T?=
 =?utf-8?B?R21nRzByQkI4K3ZONXo4SWNnNkUxUG1aT3VYb0ZCYUl2YVhQRXliTG5jNEhn?=
 =?utf-8?B?TmE0NnE0WmRQSmJrRUJyUGdDMktzUHVoQjMxNVoyL2krSk1HaXdkbEZaWk04?=
 =?utf-8?B?MytrOFdDd1luUWMwVHBKRS9XN1BTbDZBcVlJbHloTk4rSzF2UC8wL1BQVEIx?=
 =?utf-8?B?cmRiTVcxKzlkYUpEWUplOVBQUy9TYXJTRVF0bGtJblR3eFlvUzJONzVSRzc1?=
 =?utf-8?B?Snhid3krY0h4YjI3bzM5WTNxWlI0YXlhc0RuVGNncEhaRldaT0JYUmNXdEVO?=
 =?utf-8?Q?d/tUoCRQTjq6QSZwtXTDfK+mB0FsN2XD88wDQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c804472-042d-45be-4e80-08d92ba552a2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:18:50.7301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPxPzyMk0kCzm1HrDqRdvcA0K98B9BwhaQq+a1iEffmmsiG4ZBuleFnDH8/xz3Lj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4176
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Lc7oZ-jT6LJTb7d7j-7JmHIwuGZrrP3m
X-Proofpoint-ORIG-GUID: Lc7oZ-jT6LJTb7d7j-7JmHIwuGZrrP3m
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011 mlxscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 3:33 AM, Toke Høiland-Jørgensen wrote:
> During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
> that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
> no means obvious. I promised to look into cleaning this up, and Paul helpfully
> provided some hints and a new unrcu_pointer() helper to aid in this.
> 
> This is mostly a documentation exercise, clearing up the description of the
> lifetime expectations and adding __rcu annotations so sparse and lockdep can
> help verify it.
> 
> Patches 1-2 are prepatory: Patch 1 adds Paul's unrcu_pointer() helper (which has
> already been added to his tree) and patch 2 is a small fix for
> dev_get_by_index_rcu() so lockdep understands _bh-disabled access to it. Patch 3
> is the main bit that adds the __rcu annotations and updates documentation
> comments, and the rest are patches updating the drivers, with one patch per
> distinct maintainer.
> 
> Unfortunately I don't have any hardware to test any of the driver patches;
> Jesper helpfully verified that it doesn't break anything on i40e, but the rest
> of the driver patches are only compile-tested.
> 
> [0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/
> 
> Paul E. McKenney (1):
>    rcu: Create an unrcu_pointer() to remove __rcu from a pointer
> 
> Toke Høiland-Jørgensen (16):
>    bpf: allow RCU-protected lookups to happen from bh context
>    dev: add rcu_read_lock_bh_held() as a valid check when getting a RCU
>      dev ref
>    xdp: add proper __rcu annotations to redirect map entries
>    ena: remove rcu_read_lock() around XDP program invocation
>    bnxt: remove rcu_read_lock() around XDP program invocation
>    thunderx: remove rcu_read_lock() around XDP program invocation
>    freescale: remove rcu_read_lock() around XDP program invocation
>    net: intel: remove rcu_read_lock() around XDP program invocation
>    marvell: remove rcu_read_lock() around XDP program invocation
>    mlx4: remove rcu_read_lock() around XDP program invocation
>    nfp: remove rcu_read_lock() around XDP program invocation
>    qede: remove rcu_read_lock() around XDP program invocation
>    sfc: remove rcu_read_lock() around XDP program invocation
>    netsec: remove rcu_read_lock() around XDP program invocation
>    stmmac: remove rcu_read_lock() around XDP program invocation
>    net: ti: remove rcu_read_lock() around XDP program invocation
> 
>   drivers/net/ethernet/amazon/ena/ena_netdev.c  |  3 --
>   drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  2 -
>   .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 -
>   .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  8 +--
>   .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 --
>   drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  2 -
>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  6 +--
>   drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 +--
>   drivers/net/ethernet/intel/ice/ice_xsk.c      |  6 +--
>   drivers/net/ethernet/intel/igb/igb_main.c     |  2 -
>   drivers/net/ethernet/intel/igc/igc_main.c     |  7 +--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 -
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  6 +--
>   .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 -
>   drivers/net/ethernet/marvell/mvneta.c         |  2 -
>   .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 --
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  8 +--
>   .../ethernet/netronome/nfp/nfp_net_common.c   |  2 -
>   drivers/net/ethernet/qlogic/qede/qede_fp.c    |  6 ---
>   drivers/net/ethernet/sfc/rx.c                 |  9 +---
>   drivers/net/ethernet/socionext/netsec.c       |  3 --
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +---
>   drivers/net/ethernet/ti/cpsw_priv.c           | 10 +---
>   include/linux/rcupdate.h                      | 14 +++++
>   include/net/xdp_sock.h                        |  2 +-
>   kernel/bpf/cpumap.c                           | 14 +++--
>   kernel/bpf/devmap.c                           | 52 ++++++++-----------
>   kernel/bpf/hashtab.c                          | 21 +++++---
>   kernel/bpf/helpers.c                          |  6 +--
>   kernel/bpf/lpm_trie.c                         |  6 ++-
>   net/core/dev.c                                |  2 +-
>   net/core/filter.c                             | 28 ++++++++++
>   net/xdp/xsk.c                                 |  4 +-
>   net/xdp/xsk.h                                 |  4 +-
>   net/xdp/xskmap.c                              | 29 ++++++-----
>   35 files changed, 134 insertions(+), 159 deletions(-)

Martin, could you help review this patch set? You had participated
in early discussions related to this patch. Thanks!
