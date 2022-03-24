Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41234E5EA6
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 07:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348149AbiCXGYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 02:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348192AbiCXGYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 02:24:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698342AFE
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 23:23:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22O57jQp021129;
        Thu, 24 Mar 2022 06:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=gBeW3OehIlymPAQSWoTewZ02NVSE43Sl3RrjvrAkjzw=;
 b=ZOq8VHV8CRkkj+J3pcEu5/PTqNgGDLrUs2ScCpZ7wVqGEkVEUvwrSW/scZ7WevkXSien
 pPgmENDLRgdoSZHEOlPVe7ePO8djMrHgUE275czwXm1gDCeOj3rB0doHuKzGvEgMVpkB
 77FdyFkEg+qg6TxoYHVGSik7H4Ac9B/5DAsIgFMITgHni3MkEiEFxT92wZfQeyPgqmtg
 BUABNeQ+NVo8lCJtOA6AvSRjdFqRTZVa3ATFUySh9LhlJuZZydvqkeY8RHDGXZ86/wIo
 b71ZkrFTKPMUhDO8ekFCV5rw1zURgDd5XWeCMZZM4HB9uP1VKYQ/j0kYW5mXwZl7TkOs kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qtbmae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 06:23:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22O6KHE5025710;
        Thu, 24 Mar 2022 06:22:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3ew49rbxyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 06:22:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aC6MkAEJP3IpA+RCt1tGkDJz2kM2PjJ6tUz1+mDZkdIapbG7dx7TzCwzBd82KXRKfTrMvv3gcujg6+c8vQJdReaBOxFQH0wKNTez5pkb8HkU5S7i/PBSMUXWSQIC5zcXtZ045tBDy19GPToxiOMCeg57kTNQ/W+vUnJecfYuTYjy3Yv3py1q1IZLNBA6sSKBlcvNqg9yEGeJwYbvh7Zh3zZsNSyEZxFYVNetUrjx35mt9JBQXW4dihULdBoMYhGodVHVe85GwUG4G3cHEZfIDBUUkZqr4KoW7pbwoOf+gDckK1UfTvHihwApbArcxyRj52VHnhcAgKFu/5imeD0i0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBeW3OehIlymPAQSWoTewZ02NVSE43Sl3RrjvrAkjzw=;
 b=jPDIDwI6IMD1Tp2FbiTPCXq0vXhyzAyqmyRRi+jcfaiXE5sXuLOc0DTzlghXAxzjkguh9jiKlULCDke/2cnAyIqpdQijEm3rqtjejcnFsxyHVUlcLW0NfEkJYqjcE35ruG+NLXSEAqcDUbk5M1V6CML4fqbLd7NdBvWIw7BX510cG+fQamwWqNKY3EU7vMyGCefg9W/rozM9eKlHJxLjc5id7y5ZH1AaC6bL8Ijtsd42IcvOdDDHhJcHdv6XoFMv9Rz5FWGxx4sCMRwhsF9glyeuYOQRyet2CYZp1eIsdSJOHmw0OjdZa5RcaStXMbGY1kk54A5Y05Nw1JmDIqaejA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBeW3OehIlymPAQSWoTewZ02NVSE43Sl3RrjvrAkjzw=;
 b=YoC9/iC6W017NqlDt4qJwbCZsGhUmiL+043esw73sRdsxv9cX2+6i7ki9ksIswxIab0MEWFDxlX2p5qE+NiNVvNVivk+1QjsgqvEtVPq+P3nyHPbTFzB3F7n7vceyuYdweEbJoznfASSeovpOQAZa+Yz8I/THdj2LhSplHb7fXg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3684.namprd10.prod.outlook.com
 (2603:10b6:408:bb::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Thu, 24 Mar
 2022 06:22:56 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.023; Thu, 24 Mar 2022
 06:22:56 +0000
Date:   Thu, 24 Mar 2022 09:22:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH net-next] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220324062243.GA2496@kili>
References: <20220323004147.1990845-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220323004147.1990845-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e6f21c-0fd6-4120-3a72-08da0d5ebba8
X-MS-TrafficTypeDiagnostic: BN8PR10MB3684:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36849247425F213C84858F998E199@BN8PR10MB3684.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kpn+3ItEYeT6yvXbfTWE9pFBaMgPOqqjFBcO9UWCDXo79bCX45uclxtVgQdtAvgFzLeV7hvO7OT8g1bctJY2a6Rc9ZQNZwz9hb40AlTFV6bz8ZXcE3edTzwYNH6Hnz7cqAc+fuO1/Mi7MqBsXe/1JSprE2T4dDrvt/fu7UA6ptJ/qPquOW21H/MDs02AoVssuytteaa8edWdXj1mPla+5G7HMhlGn63B9a0T23zdMiQrglCZZma3AlAxKmkt0O9O8u3ygXvmhlzZuQJbRZNqg4l55o6pv9XRsD/3szGxZ8aXKOlOLl31a98XJYxHCclC3Ry57BTdTz3br3Hr/Ke+U+39I5iQXt7MeaPdJLw5lZ2hXyVy4po72mtnKuuUOn/uKWEE5GRD//cwuI6shx/uvQWjTFdzVevOjOqOCSDl3pYTTzTCZIIaE9oyH3LLUSMWOGCCyg43kZ8Uoyk2IEDeEIQeoJ0aipSyQNS1LK84TKbAVjkh8y6riC4LdpbsDGe71vjoMo2JgZCgqc0lift1OY+B7XJ6tjgMOM6dvVEeJUm0JFKJQs4BT2GaSgEkE3k9JEVQW6Ays3nWAvfNpb1SyqGvtR6smn4VWZZ72HI2pM1pwFmpo3dSLw52M+dqBya5C0GR7EZ52jYjasjVDCwEaHlGt0PChildkFFn3kbfB1wMEEmaOWXVk8EbKgV20LjNDQxHMkXI1TgFrhYj8kxCVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(44832011)(83380400001)(2906002)(38100700002)(66946007)(1076003)(9686003)(6506007)(6666004)(8936002)(66556008)(26005)(52116002)(38350700002)(186003)(33716001)(6486002)(33656002)(508600001)(5660300002)(86362001)(4326008)(54906003)(316002)(6916009)(6512007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0xQQ0RnQ3ZQVUFCR25UbDNTTjVFZ0RsZWpBenNzTFpvMVY3RkIyWXR3VzRM?=
 =?utf-8?B?am9XdXVaQWxIMTJyTFlncm5NcG1jbnF0OU9iRDdXNjhZU2xLa09uRGE5MjE1?=
 =?utf-8?B?MWZScUVMRXlsZ1F5cExaY2tjd2NIYWhrUGFyZmhJNFFQSkU5MEtWbk5kdmN0?=
 =?utf-8?B?VHJXMTBYVm5DMzIwU0RWWkdITXdaNTlnNzFwRXFqa1MxUFBHWndLUVp4ek4y?=
 =?utf-8?B?dkt6N0Z1V1pvVVFXY3k5Z3c3MmcweXZPR1NHNUZ0VU1zSGhwZzhIeGVHakly?=
 =?utf-8?B?M3RVRTVaaWVwQlg1RVFzUHMyMEtpcENTbXoxVXN5dENzaHBjc0UvR3JZZytu?=
 =?utf-8?B?Y0QwK1F5TmdLZ0RDUDNVdWxncDE4NFlnczN4V2R6NWovQzRRa04rT1RnMTdm?=
 =?utf-8?B?bEl1MmljU0pLU1FZQUZLZTVjMTlETy9GMk10bHFxNmgrUkVGN04yck8yOU5L?=
 =?utf-8?B?YU9wVU9BY1AvR1AvK1BDZUVtK3M1cDN6N1FaVmJncnNwenZuTUJXRkhDVGFp?=
 =?utf-8?B?RC83d2RGeDQzN0I4N1VqZzFGSGFnRXc1NG9VYUNsRC8vWnhoUFloOUZ6bW45?=
 =?utf-8?B?VlRSdkV3TnhxdmY0M1BEM1JqRkwwSW9lR0xkbzlhNEFTNkNpenlpT0IzcFJ5?=
 =?utf-8?B?d3NUL0s5bTF0S0llWE5IODh3V05yckc1RWY1bU9wY1lZcDEwSUs3L2x3WnVH?=
 =?utf-8?B?SVhqTlRUU3BEN1loNW5qOXhqRjFyd05JWGtTZlVta2pCQVZrV0t1RmNrRXB5?=
 =?utf-8?B?eit2OEVJQWtJZUw4VSt3Y0RwZ2RtVWJKY0FrTHpvRk4zNTd5clVLejV5TU5Z?=
 =?utf-8?B?UC93NE9CcUVRSVFaV3c2eERxRytJS0lWMDdqTGNseW1tZE5tUk5Kdjh5TkF3?=
 =?utf-8?B?SU1Gc2pzNkRicUN0dWViZElqMnM1NkpIa29YR1ZSQWc3ci9vdTVoNU9YZURM?=
 =?utf-8?B?b0hMaHIySXZSb05QVmtHcDRCK0VPYUVRTjBWOFkvTFlGRlJNd0l0N1VySnp1?=
 =?utf-8?B?QXZmdm9PL3hUeVBTcXc0ZHZjSlg2MUVrYWJibEFqdlpQaEdzVStVekIzREE0?=
 =?utf-8?B?ZjhHc2d1TUZMVXFnN0hSbzBkNWlrK0lRb01qQWRaSjFhcmtVbUQ0UU52Umor?=
 =?utf-8?B?ckNWR0xiWUszWkIvRXBJTzZkY0h0OXl1N2pGeStSTVgyTG1HZFdGZEo0TVBv?=
 =?utf-8?B?ejRNYk9nSno0SDhSNU4vdkl0V2luWm12bk0vYnZDUWRuS0QxRXZISkI0Tm9t?=
 =?utf-8?B?WnAxamN1MnlkT0RRMTU2cU14ZDY0YWdsZ2hNRHNPMmVRZlJOcHk0bVFiakdF?=
 =?utf-8?B?MTB4S3RkWkorZ0VnOVFtVWZEb2F3NzJGa0ljL3daNi8zczNwdEZoU2poT3Zy?=
 =?utf-8?B?Rms3WkpIUDlrTWU1Tk5uVWRDRHY1YmVWOG5ZYWphczJMWmU4dDFZN0FEQ3ND?=
 =?utf-8?B?Q1E1M2pqV25FYTJHeW82cG44S3BYcm5ELzBkQmhya2ZBN0cvVWQ5R2V1aGR4?=
 =?utf-8?B?NDd6b0JCYURYZE55Sk5TQ3YvMmRrTTk0YVBrSkJJQU9mb3ZzT0Vvc1IydTlN?=
 =?utf-8?B?K25CaFhWOUVMdy9NL0Jsd0RFa0RXODhwY1c3dFk0TmZrY3VrZmNGN3RQM1V3?=
 =?utf-8?B?UlhiZlNJUTNFU0gzeFIrVUpKNHVydjNIdlJWTW9ORTFTQWlKWnQrcERCZDdB?=
 =?utf-8?B?NTVvSkZQY2k1bElwc1A4T0ovaVdvcjA0UFYwWlI4aVJyV1FMcWlQZDZ6NDdv?=
 =?utf-8?B?Q2ROT09TUCtiSzgrWCtBVWtOSU1uRUp0bmhHMWVZVXloZ3EyRnVzRnBpYVpv?=
 =?utf-8?B?RXBaVGJRaDliY2QvejQ1dHRlM0JtWWVyckVpY0JybHVkWElVc0hhdHNrbTM5?=
 =?utf-8?B?d1o0T0pGR0VEWjhTaGVQbDJYNWxWdEJYZno5M3BhWDhqMUlpRnNKYjIreTQr?=
 =?utf-8?B?SDBaYUVDRllUVnorRFczOXlCOFM3aHFIL0VEaEFEY0grY2tXS3NzM2p5STFw?=
 =?utf-8?B?NGNhYlh6OE9lSEtoVDJVVXJZSjRJVXZGMitoVDAwQ2VxVEg3QVN4SlBJWk9J?=
 =?utf-8?B?SHU0aVVUbjZPam9pTFErWDI5aFJlcnYxNHlGRUF3c3RZMHpIdjkxbFVWUDhS?=
 =?utf-8?B?aUswMzJXNmZVTStHTlZhVFNqaC81STVkMmJuWnNMdGRHQmp6ZWtMMFYrZkY1?=
 =?utf-8?B?dXpsQ0pMcEpGbERiVFJtd0xOVFc5V05TMjNETEp2YzEyOHgwZWJEaHRob1Bw?=
 =?utf-8?B?RkdpZG1STWZpbkRDTWw0U3EvcFdaeDJZdklsWk1ZV1g5aTIwSk9iZUMrR0hL?=
 =?utf-8?B?ZUkvRk9LUkliYlVpSVNudXFGYk1ZMGNXa1cySFhybjFzN2IwTjAvYjhHOU52?=
 =?utf-8?Q?KJngyHJyg4uaLL9Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e6f21c-0fd6-4120-3a72-08da0d5ebba8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 06:22:56.2328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykcTsU2om0HPtctBZ6oRDzVl2iR0qehMcP2ojZ8w/wn2FC3fXlGUaHqfoF4lu4uBiEoniOfGedi70coAiAu0U0iylmj94t87IgNAp9Djvvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3684
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10295 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203240038
X-Proofpoint-GUID: X8mvylekZNc_iJXKcoQkjlv7PPGFZS9Y
X-Proofpoint-ORIG-GUID: X8mvylekZNc_iJXKcoQkjlv7PPGFZS9Y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 05:41:47PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever llc_ui_bind() and/or llc_ui_autobind()
> took a reference on a netdevice but subsequently fail,
> they must properly release their reference
> or risk the infamous message from unregister_netdevice()
> at device dismantle.
> 
> unregister_netdevice: waiting for eth0 to become free. Usage count = 3
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: 赵子轩 <beraphin@gmail.com>
> Reported-by: Stoyan Manolov <smanolov@suse.de>
> ---
> 
> This can be applied on net tree, depending on how network maintainers
> plan to push the fix to Linus, this is obviously a stable candidate.

This patch is fine, but it's that function is kind of ugly and difficult
for static analysis to parse.

net/llc/af_llc.c
   274  static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
   275  {
   276          struct sock *sk = sock->sk;
   277          struct llc_sock *llc = llc_sk(sk);
   278          struct llc_sap *sap;
   279          int rc = -EINVAL;
   280  
   281          if (!sock_flag(sk, SOCK_ZAPPED))
   282                  goto out;

This condition is checking to see if someone else already initialized
llc->dev.  If we call dev_put_track(llc->dev, &llc->dev_tracker) on
something we didn't allocate then it leads to a use after free.  But
fortunately the callers all check SOCK_ZAPPED so the condition is
impossible.

   283          if (!addr->sllc_arphrd)
   284                  addr->sllc_arphrd = ARPHRD_ETHER;
   285          if (addr->sllc_arphrd != ARPHRD_ETHER)
   286                  goto out;

Thus we know that "llc->dev" is NULL on these first couple gotos and
calling dev_put_track(llc->dev, &llc->dev_tracker); is a no-op so it's
fine.

But complicated to review.

   287          rc = -ENODEV;
   288          if (sk->sk_bound_dev_if) {
   289                  llc->dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
   290                  if (llc->dev && addr->sllc_arphrd != llc->dev->type) {
   291                          dev_put(llc->dev);
   292                          llc->dev = NULL;
   293                  }
   294          } else
   295                  llc->dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
   296          if (!llc->dev)
   297                  goto out;
   298          netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KERNEL);
   299          rc = -EUSERS;
   300          llc->laddr.lsap = llc_ui_autoport();
   301          if (!llc->laddr.lsap)
   302                  goto out;
   303          rc = -EBUSY; /* some other network layer is using the sap */
   304          sap = llc_sap_open(llc->laddr.lsap, NULL);
   305          if (!sap)
   306                  goto out;
   307          memcpy(llc->laddr.mac, llc->dev->dev_addr, IFHWADDRLEN);
   308          memcpy(&llc->addr, addr, sizeof(llc->addr));
   309          /* assign new connection to its SAP */
   310          llc_sap_add_socket(sap, sk);
   311          sock_reset_flag(sk, SOCK_ZAPPED);
   312          rc = 0;
   313  out:
   314          if (rc) {
   315                  dev_put_track(llc->dev, &llc->dev_tracker);
   316                  llc->dev = NULL;
   317          }
   318          return rc;
   319  }

regards,
dan carpenter
