Return-Path: <netdev+bounces-5350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E6359710EA0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26D5C1C20EF7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCDD156F0;
	Thu, 25 May 2023 14:54:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA76FC1B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:54:44 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2126.outbound.protection.outlook.com [40.107.95.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EA2187;
	Thu, 25 May 2023 07:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4JcEhlUacTAVWmRMzmm9QEPMma7Jvx1yQWbaLpqFugDvwSsQMfgBC/tPVXE6gh7E2mQE/DcfRHMqaS52oueGcF0cKO9rNQIN2ERpr8+rDniwLtFkzs0St1WqjJX/Sm38FcyYJsOrnnJXvOPZA9Om0XoER7pbDtKU/umE7UuYuMvuSDk0tZ/5QffyN26kWBDVwYYjHftndLAwvksrGZvT2FPzhiDRfo396XJizDXtJ9Hom+DuU4LrsAWkiEUWZd3deI09+BDNewJummLSA7woeMSytGb7RzEEhlnxdqeDyblND0Ko507Bca9BOHwebxdDMTWHRAa+mPn+XKdqaM9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYqW+Jey5AzNRVCqPA+x/LzFw4l+sFHJUjGVezQ6mII=;
 b=oUNl3N7fV+I/7r6XxXDhnxtyb9WOcKmu3PejxJSGhy3VURNLE2tOENbmeXDBp0dj/ndiwpfbfHKtWcI+ZkS+DcXZWn4Gd1j/KiazpReAak12lMmXYqIzDbNXhiZBgRJG4q+Vj577bBK4EXAUueM9uBfApvKKNH1vQ6m3fTE5/A+uOUgIaneB5CbHW8ev/MqBj9+0BiaTCWGXDqpEq88UAni4Sg2DFJAnihawvWCUQXJKxcXcsS/bnd+y36fh6LW/HF7wrhzkcog+qkJdqQ6tH+ulFjOhubaHp/e7tx6/8epym77ntQUEdtnrVlcxXE0MhXMn4pzaOIfpyZhoV9urwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYqW+Jey5AzNRVCqPA+x/LzFw4l+sFHJUjGVezQ6mII=;
 b=ZordmC6hLdRoGQY5xPFadV+OyZVQ70DxAqb3fTOCjou4pX6FfL70oSBNbkvSBPaMmFaoIYP79gz2jxUsL4HEbQ0i9LY7p/y6hFqrnx0ewEKuluTU2yxaH8dNmX0t7Qry5X2zFqVakrchMoFiXCdt7+XyPrFTxX8+wnMkzUOdV+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4436.namprd13.prod.outlook.com (2603:10b6:208:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 14:54:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 14:54:36 +0000
Date: Thu, 25 May 2023 16:54:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Breno Leitao <leitao@debian.org>, dsahern@kernel.org,
	willemdebruijn.kernel@gmail.com,
	Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk,
	asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZG92ox2BWE3rS1xR@corigine.com>
References: <20230525125503.400797-1-leitao@debian.org>
 <CANn89i+neca0ApNxRdZCiTMkwy-5=0mnOMM=9Z3u78VPNw4_fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+neca0ApNxRdZCiTMkwy-5=0mnOMM=9Z3u78VPNw4_fg@mail.gmail.com>
X-ClientProxiedBy: AM9P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4436:EE_
X-MS-Office365-Filtering-Correlation-Id: e04d81c6-bdfe-4b97-b746-08db5d2ff54b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	alMePwIja8hbBCglsVVCb4LB5UVyhpZY/tvsaxUdSZzeQqWl9I6ChnzjU2rNBTEAD/txNNyVx6xtB/T6/PYsjWYWnzF/WL8OCNcmMIH3LTFbz2d4ft8BbrYBpf9Yu3mUJtPbiZBFslrzseaMcRFB7NWERU/MSrhstbhlFmyrOaV5rQF2pkb0YynjM+BiPzrFEWxbLKfdahqIU255YxXYQGjc230tefditX6Hi8gfhY/J6g7OFfiQ4fLSfuTDub2h8ZZY2f3wThEcewFsURSufRrcIkurpRozD7toGecBrAbMeWUUTlDnDu8rvozf63htjwvcAwsBJYUr5wdd3TMXeb3rtHIqTXbw6W9t9sYsecnz69xIASaH1J4NiZJlUmqgdd2jWTy9KCR6GfFgNk9iipm4s1sG6MnGSd7so1zY7zjctO6KcSWyqQR0uAQfog1+PLbAwurWPljGu7u+oxWG+6q3gKrZihsptWe1lJXt1WmpDYmqGNGJZ26OKKJt7r4kbaHw/stg5E1rUe7xSFib9ZQQKnwpcEMmCtDgpCVc4NvN/Qmap0uCknyfX/2llcl0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(346002)(376002)(396003)(136003)(451199021)(36756003)(86362001)(54906003)(4326008)(316002)(6916009)(66556008)(66476007)(66946007)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(44832011)(2906002)(7416002)(38100700002)(2616005)(6506007)(6512007)(53546011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmtWb093QzVEbGdaeEVzL1lDWitHai9SYXBXR0kxKzhMamh5V081eGtPRno1?=
 =?utf-8?B?U3RvTVZDaEJqVm9OaUJBajUrVlZnQUMvK0RDWVpaK0Zydk9zMElkSXM2dCs2?=
 =?utf-8?B?b3VVaDRYVUg3TzNvMFpGazJtRFZqZ1VyeU40YS9iWHNhd1ZPTk4wYzNNUFFy?=
 =?utf-8?B?d0RIM2hIb3NUQWVmM3JFTDBmbmRPaHBYdnlrc2h6ZCt4U0hkZzdNL0Vlb3l6?=
 =?utf-8?B?cUxnZTNXd1FubEl1bC9WTEx2Sm9jQktjOWNIdTE4d0U5OVdEaWZzVVVTcjEy?=
 =?utf-8?B?dWR3U2M0b0FCY3ZjYVJhanNaTmh1VXozcXRKRjBReTVUYXd6R2FQOGxKMXBj?=
 =?utf-8?B?bW9tdnVKUW4vUmJaeTVuWG1yWDlWUzUzU1FnNFhJNGYxVlo5dHUzTEUxN3pS?=
 =?utf-8?B?SkNaNlF6aHRlRVZsd0xZUVBMTmFvbk85cFIzUlhxN3pUWEw5YW1rRTRmRnRT?=
 =?utf-8?B?cFRGN3NEWEJzU1NOb05BeUpuYm0xYThic21Zd3pTUjErcWd1RnlyRXdBY2hr?=
 =?utf-8?B?ZThVUzg3Skowa2tOYzdDWjMvQ0I4NkVoTXJ2RWYrWFAvYXllQmljNkttT2Jj?=
 =?utf-8?B?S3ArUy9ZN285UEJRZDByR0hzK25LenRzaDVTalpNSTZGM0JrbEl5UU04cnVt?=
 =?utf-8?B?Q1d2UFEzTzJaSVJmclJxQXozMTNxb2I3UGVGZ1dhbWNXWUszUjdJbVJudStx?=
 =?utf-8?B?bGhxdGtTZkdSeEJhR2dTdTBGZGNaVDFBVVBOR25aQUFOa3R5eHFSN25JNXVa?=
 =?utf-8?B?YmRiM01CdGdJZ1BqSWJtdm1DMGU3N3pVVm8ya1Q2NDlkVjlZRU9OejB1UmVB?=
 =?utf-8?B?bTZiT1NraUsySzRXZWwrOXhMUHN4QXUya205REtOVUZIQjBFT0dJMW9uNmRu?=
 =?utf-8?B?MGt1cGlIUWtPaGhERm5IZzFjWDN6S0ozaGtpUm5ZMTlsUDhBYWFVNmVhVnlL?=
 =?utf-8?B?MURFME1uK0dZc1ZiVmhrK2h3cWVQRW9iT1FNQ24zM2RKMEorTzNzK0ZnYkFW?=
 =?utf-8?B?RmVQRERxbUNQZnZVNXhvOFNHNmZ2MC9xeGwxRVpMS3JJTlB1OVlWZG96S3Js?=
 =?utf-8?B?cjVlaFU3SDhqUEN0dHhidFN2SWhjdUtpbWZNcjBsWmRCYU5LRGZIMzVHSVRD?=
 =?utf-8?B?ZjRKQ3lIT3lDVWNNa05ZYkNLT3JaWXBENThWdktZU3gvQ1FPcm8rR0h2UE00?=
 =?utf-8?B?enR0Vlg2STVpVFVXeWZJTXdlK1dDNGpYeHJHZHBPYnE5aGlEWWRSdWdPdVR0?=
 =?utf-8?B?VkhJUmMxUHJZOVU0RXZUSXdCb1RmZWM2a0hhTTAvTGk3Qk9LZUNLaVl0bGFl?=
 =?utf-8?B?WHJFa1dEYnorWFVNYm5KeGEzazZRWFZEcWpEWW9hWUdQeVNadXZsdW1kZzZ2?=
 =?utf-8?B?ckZmaU9DWHJleHZBdmlYbDRoQ0lCQm81ZXA1MFRkRXBWTXBOOEpERmUzNTlF?=
 =?utf-8?B?NlNJRGNuZ3pWWnhpeFJoK0Q1NElzTWQ1cEVGR0EwR2xlR1NVN3grMWVPYVRo?=
 =?utf-8?B?ejZ6ZDQ5VXlGY1prQSszZU9TN21QV2IvcDhMYnIrU3ZqVnd0cUpxYTE1Ulc3?=
 =?utf-8?B?RkVJaHVleDRTaVYwWGVGaTVMVTk4MHBtaVJJSDhvOEJkelRCWTZRSHNnZnVr?=
 =?utf-8?B?cmlCUlAwbFNuRFFhN3JpVmN1ZlQ4OUNNTGkvU2hZTU9mY3dwY05UOTJjUHpk?=
 =?utf-8?B?MTladUpsSlBrbzRydzNVUlJLelBkNG16ZTNKNUdYc2NQcDJiV2xYcmRyUUZ6?=
 =?utf-8?B?KzdLZ1VtWDFoRnlKNHZORGtDaFA0RC9KNDdaN2p1MGdWd1NSam53NWlKQWU4?=
 =?utf-8?B?NzUwVnhkRjQ3MXNrRENOSGZIS1F5V25MKzd5NXlUL3NqT3hmcyt2Y0R2QTh2?=
 =?utf-8?B?d05KeThEaUdNRG50cW1hd0pURU0vM0NxU3ZmNVBqNXNja0FGdlZKYXEwRFVF?=
 =?utf-8?B?c2oxSmR5QU45eUJyOGRHQll1OXV5Si82di8vcHpHQnlOZjlaQU5URzRYMkRy?=
 =?utf-8?B?emd5RVhlVjZrSkR0L1NvNlZOQ3VsRFB3akU2eVhXcEMybUhBTWg5TVlyaVlj?=
 =?utf-8?B?WVBKR1RBbXRtSXB2OFYzQlppQ1MvOWdpRlFRN0JUM1ErR093alVHZDFzRllt?=
 =?utf-8?B?enBuNnNsMU1vQ3ZoRlJySmpJa25CUjNsZ29OMjY5RTFPY2o5RFFzdzlXZWlh?=
 =?utf-8?B?VlJ0ekZvWENWd29wOEpTcFhaVzRVc2hJaW5DMUhRakVxUFR5WmtsOEZZM0FW?=
 =?utf-8?B?TmhEWFIwdnR6dGE3ZkU5VnBCaFd3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04d81c6-bdfe-4b97-b746-08db5d2ff54b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 14:54:36.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3aRhzc1YQ+k/Wb32uHFTNWHaxKwgmUsu9H6szYouBi5Hw6AmsF6bQnJefsf9c0nDjzHMIDzHdvUTY58f5hT56F7lJ0blTM+wvVIGRq+ph4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4436
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 04:19:32PM +0200, Eric Dumazet wrote:
> On Thu, May 25, 2023 at 2:55 PM Breno Leitao <leitao@debian.org> wrote:
> >
> > Most of the ioctls to net protocols operates directly on userspace
> > argument (arg). Usually doing get_user()/put_user() directly in the
> > ioctl callback.  This is not flexible, because it is hard to reuse these
> > functions without passing userspace buffers.
> >
> > Change the "struct proto" ioctls to avoid touching userspace memory and
> > operate on kernel buffers, i.e., all protocol's ioctl callbacks is
> > adapted to operate on a kernel memory other than on userspace (so, no
> > more {put,get}_user() and friends being called in the ioctl callback).
> >
> 
>  diff --git a/include/net/phonet/phonet.h b/include/net/phonet/phonet.h
> > index 862f1719b523..93705d99f862 100644
> > --- a/include/net/phonet/phonet.h
> > +++ b/include/net/phonet/phonet.h
> > @@ -109,4 +109,23 @@ void phonet_sysctl_exit(void);
> >  int isi_register(void);
> >  void isi_unregister(void);
> >
> > +#ifdef CONFIG_PHONET
> > +int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg);
> > +
> > +static inline bool phonet_is_sk(struct sock *sk)
> > +{
> > +       return sk->sk_family == PF_PHONET && sk->sk_protocol == PN_PROTO_PHONET;
> > +}
> > +#else
> > +static inline bool phonet_is_sk(struct sock *sk)
> > +{
> > +       return 0;
> > +}
> > +
> > +static inline int phonet_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> > +{
> > +       return 1;
> > +}
> > +#endif
> > +
> >
> 
> PHONET can be built as a module, so I guess the compiler would
> complain if "CONFIG_PHONET=m" ???

Yes, indeed it does.

-- 
pw-bot: cr


