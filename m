Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72A44EE925
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 09:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbiDAHfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiDAHfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 03:35:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204273C735
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 00:33:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2316asCg027068;
        Fri, 1 Apr 2022 07:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TPsqm9XnXaylqTfIaP1rhS7vfQp6Ah2R+U5IJuSO2HY=;
 b=agBmk/TwTqKNwTv7BdVL3sKKyEQQkX5ikrvdCnBlYp6OOzWXOgZSgcYKFb856SHQgkpK
 Wxh3HusNdg4ZWj35DG2irmjn0pUIPVT3NPtS9cyWvnjydAHugdv72pSEvs/mfrUQ9mNl
 e+ih+2HO99uf/vk3SstUI71vAIfG6nH/ynxFlAYzB9YJmnhA8OTbpeaR79SNgDacevFo
 CSnVZ9z4ZUQfYzr9e9+qgCJ1b41QhS+wvZ1TokdPnKidvsF87O+RSs7yYxt7dSlbnncX
 g41nGubDrkeFB059Z2Wx30nMjFcqiRikWUtUHK04b+pujtfOmjIo8Rljs6YErvqRD7Yp tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1s8cwx95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 07:33:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2317Wlke006304;
        Fri, 1 Apr 2022 07:33:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s96affn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 07:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2rVAeXoz6BnQtW+76ii3NC0hOcJY4kLzps+d1Xma0IY/sIn4Prmksb+NA6gD7ao/Jh70O3YYXIDjLnWIaCwsvKslqKYbVKx3kB5s7a4T6ez9RpazqeWyfF56HpET037FCIiHcDvd1hsLOys6b/SBX/7I2doDeYejtNyE3kXSRKJ8mwmCTOl0vxDf/6Qys/JB2TnOO/QDJEWCdpY9GudsSGp2ttac9PIiCb3KLCIdUGeo/L3dCaV+H9mwKFH+ud0yLrGhb8axBz9kKYhS7VPdRiM1jHV6zGNyc3YmE5Roi3Q62vkUhwjiaeCCMNSZxJuNGAXj6gnS4++Ir7Sr/2jxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPsqm9XnXaylqTfIaP1rhS7vfQp6Ah2R+U5IJuSO2HY=;
 b=jtHOuTz2jWloE/wZ3bXwWGXfn2kl8Qxfvpilzwsu2IELFhOWOZicw/KbvKbvIU4ZEUeG/xqZF2YfxSndKGvbXYs9r6KEGGLv1Nxpx6ncxbwVVNFP0mSMoCQ3ehxgjsnpqzflgMogWWjFkcI4hzFUBT0XYxRy9+un5F5Y1h31z79Ox/K2QbYqsLPCqevVpeDGxHIJOycdsswh1gs8kV0GhzV3XjUnqk/8lgjG074oXHN5KQ9zm74bNj8mSLP2bf+tSE0BDb/VyY3MfRG+e/ktsdmtkXi1Hyb4kZOHNJAO1IngnvWNb0w6Z76jbYb4odT9evz2Svf+wSPjOxQmoPiaUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPsqm9XnXaylqTfIaP1rhS7vfQp6Ah2R+U5IJuSO2HY=;
 b=gpuGZBtqARhwjM3KmYSbwwJ6XwMXNykb72NXL8V84OuVeAQm1uujzeNoiVwPNw9P5arpehAZAqM8mf1JTQWDUQML5X/8/BGNqoIyLoiuY9tNkFyYdQp13UIPpGm2iZ3HLuq9wuppRqeQw7xys6WnIC9cU/TtalO28FlaTW4V+Po=
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18)
 by DM6PR10MB4379.namprd10.prod.outlook.com (2603:10b6:5:21e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.26; Fri, 1 Apr
 2022 07:33:32 +0000
Received: from SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::ad45:bd47:3389:608f]) by SJ0PR10MB4638.namprd10.prod.outlook.com
 ([fe80::ad45:bd47:3389:608f%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 07:33:32 +0000
Message-ID: <7c6d4b3c-10b9-1801-f3da-a6f01a81a70c@oracle.com>
Date:   Fri, 1 Apr 2022 10:33:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: sched: fix use-after-free in tc_new_tfilter()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20220131172018.3704490-1-eric.dumazet@gmail.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20220131172018.3704490-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OL1P279CA0013.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:12::18) To SJ0PR10MB4638.namprd10.prod.outlook.com
 (2603:10b6:a03:2d8::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae0a6ee-37bd-4c40-9099-08da13b1ec01
X-MS-TrafficTypeDiagnostic: DM6PR10MB4379:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4379DF8A5429ADFF05263C60D3E09@DM6PR10MB4379.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJJPrr5rvroapHkB/mZnE1zF8LoXaBw/nEbWTc3bT0XAGCKxFPH1pQ079rSpnOpukRu6gzTiG2SDQrvYZmy4t9ie4IbPbcuXIYiKAEFyDje/CRENt32XpRJqtnYdszCiX2q77EG5wy1/bOjAkWnFKvn43WaYGfxdGfGi/aBscLW7d58enyb41W/guuhGwR8T213hiINGBoAsuKWJnsdEo7c3Ga3PmQUId3tCkab1GIKYnQQpkazhlT9lmJB5uCC3Q1SDWkL7+5b2bQhmra/HTudkcqUexnHRbBgrPf+301BISgYzmRwCmPX7CXbl6atZnAuwt1yQOSRAHQsgVJ+j6c5DEkUoOtY9qX2qYHDkCNBJ1VnwXffajgDb5aDOwGS9yZanJzTfHf8oXNRzd811/hvSGvhBjMoAiQY6LoNtlot4lm5BrfLOwZO4XP2wwavhBDvKL1m+S/VbQlC6kSzhKmrMTPh5ju+qCslt4C8aE9VG+dAasJFlOkvLj+az18K6TA8V4kbatKivWTDiu3HCEyWOOqV6SDek8Y20qmKiulcHUu9N14111Zcj+0tAvHAnsLTN1ZzqKPApupjuQ9LylpO97wMKgfj7Q0Cr21ARxFG1WYPtnpmH5fEWltdZU4Jp4U5S62dLvWHg8PbXeAQrUCQE5jdpGbmYmHqH6il2r9VIhSzA7H0zkYLKxZ1qyUREAY20INlJY1GH0/qDb3D84+azBWmKmYVXT67sGvcMuhc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4638.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(2616005)(2906002)(8936002)(6486002)(31696002)(86362001)(508600001)(6506007)(53546011)(316002)(6512007)(110136005)(66946007)(54906003)(4326008)(66556008)(66476007)(38100700002)(8676002)(5660300002)(6666004)(83380400001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0h2ZFdtbUlDZ0xLWkhsL3FWVFRFNVV6QXY2Q1piNWdBaE9MUC9iL2hpS2Ft?=
 =?utf-8?B?cUQzSHVsREQ0ZjRYWG9TM0tPdkg1Z1k3SlFxa3VuZ2NHUUJYRGMvWUJGM0pE?=
 =?utf-8?B?UlpSdlZDdHlkWkxzTkxmUHUzTks3elVZdFRBc3IyVldMN0ZhWkVLNHQwSjJM?=
 =?utf-8?B?VTNROW9FYkRLM2ZIbFg0T2lUcGVXbTV6SUI2L1BjQjcxQVNkeVNzcjBpS2ZJ?=
 =?utf-8?B?eGNnSzFjL09meVNRd08vRHN4YXAxaXR3NlFObG9iWjRMSHd1dm9sVnd5OFlO?=
 =?utf-8?B?ZlFybzFvQ0xLT2RHVjNDU0lINy8rREtrSUhJcDlqa0hCaDU1WEJTMFQxeGNY?=
 =?utf-8?B?NW83bnljcWNXb2hkenRJOXFqWWlJQmN2REZvTVhlMUtpblZZSmJJYzIwT0dS?=
 =?utf-8?B?ZnhwUXFyWXJLbjdCSG93Sk02VzZPd3VpQzJlRGdNMk9nQlRpSE81MU83ZmIw?=
 =?utf-8?B?dDhQK3ZWSk53R2xVcU51OEtqbmtnNFJ0bm5CTzYyNnVtamY3U1cyNVA0OU9I?=
 =?utf-8?B?dVJpd21pQUhVbm9yT29xYUZjQitNQ01JamhuL2NvWHkxVnV0ZytteHk3elBQ?=
 =?utf-8?B?TDJ0dGRYclJCOE82YVJaVWxuNmtjUDl6SzV3QytWM3BublBSS0dXazhHSEY3?=
 =?utf-8?B?dzE2MVVGemdJVDVvZGNsMUgrQUJhWG5CM0haYjg0OXVwanRURUE2N0lBSnE4?=
 =?utf-8?B?UENJUFhYUkNrNkJaY1hveXpMRGNhYzc3Zi9ZOXhvUGQ0YnViNU51VjRkckZX?=
 =?utf-8?B?MkhDMm81K1hwUlc1T1lKck4rZUtnUkl4SUdZdDZ2ekpoU2kxVXRFVmdib0JK?=
 =?utf-8?B?T3ZIaG5IdlBUMTFKaE5TbEsyTGo3SEhaR0w3aFJSNGcvQkFhV2tPb0lVRW1K?=
 =?utf-8?B?bVkxMDlCZkpUZkY4d0xYMUJ4ck5TV0xJZlVqajZxZlV5UVFDRUJ0bXJtUlBF?=
 =?utf-8?B?dUdmZXVteWYwZ1FJRFlObG9pU1JpVjZYVmhaUlhBMDJGektEbTZFYmt2ck1S?=
 =?utf-8?B?YVFzZDJhK1k0bEY2dWt0OE9ielU4bVhRRDd2MTFRUnQxbUdqUk9QaUhiaTVi?=
 =?utf-8?B?aytLeTRzNS9PcUg2RXA5WTNCSzEzcXJvOVA4Z2F2eE4yV0JzQm90c1l6blgy?=
 =?utf-8?B?Y2pKajYxMktlUXY2TzVhTmxpWWhwU0Vmc0loeDlzMmNJcG5GV1lHRnJWdGRV?=
 =?utf-8?B?OVRxbUhkUkJsRmIzV1dHdEsvWGxSS3J0Z3JWcFBOVVhOUXVIR3YwWXVFazla?=
 =?utf-8?B?M1I2UUZMaFRhd0dNZVkwL2NvZVI3YzhUZnRwRTJtTnd6WHNtVFlLejZGOUs3?=
 =?utf-8?B?N0VjZmNBN1pNeE1oMUVjaWxlUDVJZldqTVJGRGdLcnZWaTdlZ2lSd3VHZE9n?=
 =?utf-8?B?YmlZMFk2bUFvWmZad29DN3ZTZkhzUFpuL25MRXE3MmZwNm1JSE1qTy9STzFo?=
 =?utf-8?B?YjQrMUlLMlVDOExkMk9lNldKcVNwcUM0YjZrK1l0Y0FCMEwwNFJaSlVtWUNB?=
 =?utf-8?B?cEFFeFVtUXV5c2VSSXkrRnV0bHp2ME5TYWp6aEhjeDNMbUYramhBeGNkWlNP?=
 =?utf-8?B?QnVOVEpkd2Y5b2Frb3lnV09rT0ZQU3Y2SFJFQWJRSTJjc0pIaWZINUlKUkNz?=
 =?utf-8?B?WVkxbGxNbjR3NEhTeGF1YmNITlJnMzhhbHduS3hSZGRVZmNUelErQzBLeE44?=
 =?utf-8?B?ay9HeHFqRS9RN01HMTh3bEtzdWVlSlRSUGRhZkJmT1h1U0tEYWp3M1RtSTBF?=
 =?utf-8?B?dmNndzVvY01JMy9icE1MU1A4ZVNmYko3QU9NWnh1dlNzNzA5YXpjTnROYUtj?=
 =?utf-8?B?RDRXVEdPWmFFTitHZXBVNDhBSTNqYjl2VUlTdzJIZHZ1UStxY283eE1YQm1u?=
 =?utf-8?B?WmkzdXJlbUJNbnJHdFQzemRzMnlQRDV5Z2lMZ2RVY2MvTysyK016eUJiSmNC?=
 =?utf-8?B?RzR6clJNblRaYi95Njl4SnhqRU9pYmRaczBWdGtsWVFJZW9JZG9BVXl2OGxH?=
 =?utf-8?B?V3FsUHRMdGFkYTJpbHd4M1BIa01rZ0hTYkg1OWhSTyswK0NieXdla0VVL05U?=
 =?utf-8?B?U3RCcFB5MFZqM21IbGhYSW1JRkxpL1UzZ3ppenk3WXc5cDBmekJIRUpvWmxl?=
 =?utf-8?B?WTJHZmc4LytvNWM4ZXpXL1NIcGR4aW1mNGFZMWkvZ0FZaXFYdnFBZCtGdkht?=
 =?utf-8?B?UStERWg5YmpQQUVpRmVDdEpZcEd6VW9PMG5sam8xWnQ1ZEhDVWlGWTdTa3Bl?=
 =?utf-8?B?WTQ2OUwzNkxaTEtTRGJZQkkxUk9YNG1Wd0taOUVpdUdlNDlWVVhic1d2RkRJ?=
 =?utf-8?B?cEIzbGdLT0REVEpER0UzZGlkUVJwR2hIenFlSFFnNkVMN1hmbjRreHJrVytB?=
 =?utf-8?Q?fCO7+tYtFDYB/qu4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae0a6ee-37bd-4c40-9099-08da13b1ec01
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4638.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 07:33:32.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FooS6N/XAKWt6zXzlilGvf1V8PMpLIGDyxBCYhZMcAWYcfkC/wQ7MI3abr0VpfcoHtswdNY78IkSpH0PHZFz3Q1FM2fhFNEEeFzPqv/rt0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4379
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-01_02:2022-03-30,2022-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010035
X-Proofpoint-GUID: 6MK7ER5dfWq68qdm0cxaBlZBbhdWcWQX
X-Proofpoint-ORIG-GUID: 6MK7ER5dfWq68qdm0cxaBlZBbhdWcWQX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/31/22 20:20, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever tc_new_tfilter() jumps back to replay: label,
> we need to make sure @q and @chain local variables are cleared again,
> or risk use-after-free as in [1]
> 
> For consistency, apply the same fix in tc_ctl_chain()
> 
> BUG: KASAN: use-after-free in mini_qdisc_pair_swap+0x1b9/0x1f0 net/sched/sch_generic.c:1581

> 
> Fixes: 470502de5bdb ("net: sched: unlock rules update API")

Could you please recheck the Fixes commit?
470502de5bdb commit open codes for tcf_block_find function.

> -	struct Qdisc *q = NULL;
> +	struct Qdisc *q;
>  	struct tcf_chain_info chain_info;
> -	struct tcf_chain *chain = NULL;
> +	struct tcf_chain *chain;
>  	struct tcf_block *block;
>  	struct tcf_proto *tp;
>  	unsigned long cl;
> @@ -1976,6 +1976,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	tp = NULL;
>  	cl = 0;
>  	block = NULL;
> +	q = NULL;
> +	chain = NULL;
>  	flags = 0;
>  
>  	if (prio == 0) {

I'm not 100% sure but it looks like the error could be introduced by the commit
7960d1daf278 ("net: sched: use block index as a handle instead of qdisc when block is shared")

This affects linux-4.19.y backporting.

I'm checking it because CVE-2022-1055 was assigned to the fix.

Thanks,
Denis Efremov
