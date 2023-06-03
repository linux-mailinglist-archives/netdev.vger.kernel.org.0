Return-Path: <netdev+bounces-7678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C18721099
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F0E61C20A14
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1FDD518;
	Sat,  3 Jun 2023 14:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6D98BE8
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:51:43 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2110.outbound.protection.outlook.com [40.107.95.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641E7CE;
	Sat,  3 Jun 2023 07:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2b/Xsef337i0V3+0vEj3K0BvcwONhvni+6TqXGydb3ZlQBWEZGRljDcWlwIq1lvnWuaFL9+q0hhjDne2LzJrm4jt154Z/ISJ2u6y1CiNYIuHh6OqDdpS772oDlAuzjsrcpg7TVesr9AX4d1/b3GvouMl6XQbhH8JqelI2bi3V3Tz+l+qhaSzP/GZwKzTy4xtPQPzn5STODp+W4jeyLbXnyH+KbxjXKhbSMsadpUENJZeKJgR03WPhWiirEdHfdYvDhTypmWHa31MoU2hyJcF3gc0+XR2Y0C2B1DCtc2XWwUvLyBqxuw6//XuTQyk23NE94CByS+IJ1AlXoGAqrn3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kF6Nh9WnCeuMj838Yky8Q7UuKhApodT0gs079WiwVvo=;
 b=lMdPrFd0PqEkowOSGs3bRI/6AoDMXANnZRsoDN9WKB7EI7WXBzB28l8YKBD3nZzh0q+sBW2Jh+WL18AtFXltlDWvilZT/YyaNGsW3apJs/oGcLYLSruxQoQPzAOOFNi6c/KOhEdeWchNqGlgQFsrqnBQcl3VrylZzUvAu6d+aougdyfIWNdNpAumqoSabUk2oUA2loAvFQIor8Pipo7gZkSJYM6m/y71Fjc4PW1D6YgjwJVnDrE46eBlh3jO5pRN7Zy1ZOXeQpp+Qv64sdmBSBN0F36TmbjXfj0oJn+whV/+1vwLsThBSthHSQ98ufa4jgVcAcPnT/C/G41juS9Aow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kF6Nh9WnCeuMj838Yky8Q7UuKhApodT0gs079WiwVvo=;
 b=uRn8+Tjf0fyLvK6UYTZc+h59APqfofI6vQb0pgy8hVrUZhHdkG9jU5jbsATZIB0B2pJ6IzblVbZ4rIvDX2V7rrA7t4FIVv1GwEbHrvostHptbL9sQH1s764EaG4GIoYjrtgwOSH+I37cweGG8oE6bxlNGQ+vsp0MhfpmsE2FgFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6118.namprd13.prod.outlook.com (2603:10b6:a03:4f5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Sat, 3 Jun
 2023 14:51:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:51:40 +0000
Date: Sat, 3 Jun 2023 16:51:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 03/11] tls/sw: Use zero-length sendmsg()
 without MSG_MORE to flush
Message-ID: <ZHtTdEyIjtgg3nAo@corigine.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
 <20230602150752.1306532-4-dhowells@redhat.com>
 <ZHo0rNlhJCRE4msb@corigine.com>
 <ee50e4ec-5df7-4342-885d-9e6c52da7407@kadam.mountain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee50e4ec-5df7-4342-885d-9e6c52da7407@kadam.mountain>
X-ClientProxiedBy: AM0PR06CA0122.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de1b892-99f1-4216-7653-08db64420a03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/mEDGIXNv/iN+4ZnqP7yf3yeUd3hSjWCJaze2zRsIsBZ9cwxZcTUlFijm2B+VUPJ+l+UBdpycrECFkQ90OjNdr0/CWOcMPWuiSm2WvvHz/yrAc7DQ3pDqEatwMh7IosToKDdkOJG6Ken8wFkxZjTQlH4dBc184RWGdi0BR3iP+9BnHlBKJNvlVuEdO9U/mX14ZH6zKlXa9V+N0qEvleSHJp8+VVP0fpAgS7HoEj1aKulmKjzp6gi7FMQ0Od1xIxaj/F1IWPrLSncy/4m2/2rLW/88bUlaT8h3nPoxNa/FyrbDB5H0rOXRrh81MSlE0dAIc03FlnxdndE74gKcqpTc0XEPosL7Y/YcBx4Ayqij1gojLPjl9Z9xitRFL2wdGLKhhCGz/mzhkeLUPGhdnVfogGAWs+yt/bUAUPTKfY/H6AZcLepahMTEsXC+lkAXwQ14v85yC6NuvossRmFERlkLXMQrP26VPXZfbiFsWacYtfyuPfz98nfl+GcJpBVFe/wf3+ZFTHKKM5dNqUTHTGR/Yd23pbVWxGBwTNBoDsO6yf9qFdXgkvEKfkBxRrLejSQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(396003)(366004)(346002)(451199021)(6666004)(478600001)(38100700002)(186003)(2616005)(6506007)(36756003)(6512007)(83380400001)(6486002)(316002)(66556008)(66476007)(66946007)(4326008)(44832011)(8936002)(7416002)(8676002)(6916009)(2906002)(5660300002)(41300700001)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D/+oPmpAFR+yfJlPGNLI/ZRoT/XgwqAz3rIPETbyuyIiLCBtg9wHrL16s8DH?=
 =?us-ascii?Q?imCjdbEoRvynIc3X+MhJ1s0a8XGTyYCeWqRdsSH6EDzxFdCuT2WW0BCRpm8Z?=
 =?us-ascii?Q?Z7bvR9bnzhUuwa+kM++PyDs2n1ySWNhQwoNFWRbqtlvNcecKWCKlo2hGjPDU?=
 =?us-ascii?Q?TGnxPvEFH+YudbWJ8PPQo3Ltr8nIYwEvdF17WNvfGATt6yIBsIZpt061mLjq?=
 =?us-ascii?Q?B2gA7wBbGAlHCTgv/9RWGQ4c9iMHHGqiRuSo9dIZpnVKBLEjX+f8EQ6gArCc?=
 =?us-ascii?Q?OSng3ge5EyLyZbEU6K3nBsZ1Uma+PdJWMRzCeXiDTJPz18RtsADQ9+mQ96wz?=
 =?us-ascii?Q?KHW+jBUZ+S/kMMXDsqrqPYRHqonI5cyD49ilFl8VkuTKUNWIK0+NWz/cd0V9?=
 =?us-ascii?Q?z1xEU6xku2WDSyF1zxvZtxN51IGDJKR3Oms3SexoecakJlvyH1JMxRdCmoBg?=
 =?us-ascii?Q?qe/1lPIuHzfsSmWXHif9ECxGHjx8NAeQW8kGCe5+phjFr1jFQyJl7Yv+bfib?=
 =?us-ascii?Q?fJ/PHfKmJLZIgAqZL6ZsxoXw2X5loSlNPAov90HchisVSiWiaXvxojs32pac?=
 =?us-ascii?Q?dfuCvifuhyxnsCiar7rTc4rzzXFDVkLynO4N57X8TGEHqt6JOOILi7BBjMy2?=
 =?us-ascii?Q?pXqdQ844xpHflmt8/ZB64jGxLuPzHQN3TclwLQIHLN/j4fxsvR/F3T7fuSgB?=
 =?us-ascii?Q?SSNyMLI/Ir3uOgRyxeihWa2zm7ue/nsWztIoYMjxgOcC3NshUe4hykEoZXh1?=
 =?us-ascii?Q?tCWJNShbDMNIfVbYP52cvCFZW+p5LI5XBz1AE7RNs0ayfqz5M7V2Z0kqZ+QJ?=
 =?us-ascii?Q?aVwGJRhkBoppyw5BpN82VWdRY5NqwGRspzs/BcjnI5MMZC7XsyCIk7TdMoJg?=
 =?us-ascii?Q?/7dVdV8EyRTxwzWj+A/z3s0VCZnc4ROkWEEg52xC6QWiC6aczFedxJ5rmrog?=
 =?us-ascii?Q?+xiIonU4swSawXHTwncB6anKpUOlFAsn0UdGCzsM1bKI0fhjAOa5LTlUNJds?=
 =?us-ascii?Q?1/A5zqZvLiQok0Xt4Thsdapyk7obHIGWfEBjV4LqkOSRBz6VpzG4g3bwOjvp?=
 =?us-ascii?Q?+d33D23TikmVvAsnrXvpWdjK43G3zJkyM33iQVeX96HZGIwm/4DMMbF0SrnA?=
 =?us-ascii?Q?K07hncScCxqq7SdUXWmsx6VUZme1rEfF6L+dQMkAxMaxCu9W6Z6imvLrqOGw?=
 =?us-ascii?Q?LyQ7ZsQiJFNdqX4vg7+UxuY142rVthW6oEmh2uWngHUi1H5lsb8SMXtYiDCL?=
 =?us-ascii?Q?T7qTwje2cPYJDm8EnSgDk/1woB0M78EGBLUsmcE0Nm+Q3duiqoGusszGKts+?=
 =?us-ascii?Q?zX1PGBdzJkFhTdT8aciYVMPOnutzic0Uo+BD++e2Mle4ZSZ0lHKqYr3UHXaW?=
 =?us-ascii?Q?7MN3dzFWdq3wrpgqJ/vn6GGBncoDvD2GKPhHjHOeD7eUXZNkrhRWk71RZwGj?=
 =?us-ascii?Q?bp4K+ZyGuFLyMml4hMDXR3b8P/05yzUHngHQQuMM/C2w45tquAf9DBnzt2Mo?=
 =?us-ascii?Q?hfh3PH46OA8O36J7e5KkapCmX+JXmlxItiOmF3YXoqTuivkp62XREFZCiDqn?=
 =?us-ascii?Q?dZYJNkwJOTCWhJa7TzpT2c0J+TBNpdZRGlxn0bXKXLtbTFrOq6z9Ci5J5lif?=
 =?us-ascii?Q?ED+BlEeAUSdJ1rXQX8b8OpDq2+Qo3xSlTYo841SSjQCdiJbup5p4dVgtwUz0?=
 =?us-ascii?Q?LDBlAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de1b892-99f1-4216-7653-08db64420a03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:51:40.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jAVZ5v3Xm3fs6by006kMm40ftyAnEFtlcFtgLErhh6ym2NGD97Riyfnl/03WfdnqlZIPL2+xhhgHFcO9TqoGvkR+1kNB5j8gOOsJTs5/j6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6118
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:00:45PM +0300, Dan Carpenter wrote:
> On Fri, Jun 02, 2023 at 08:27:56PM +0200, Simon Horman wrote:
> > + dan Carpenter
> > 
> > On Fri, Jun 02, 2023 at 04:07:44PM +0100, David Howells wrote:
> > > Allow userspace to end a TLS record without supplying any data by calling
> > > send()/sendto()/sendmsg() with no data and no MSG_MORE flag.  This can be
> > > used to flush a previous send/splice that had MSG_MORE or SPLICE_F_MORE set
> > > or a sendfile() that was incomplete.
> > > 
> > > Without this, a zero-length send to tls-sw is just ignored.  I think
> > > tls-device will do the right thing without modification.
> > > 
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > cc: Chuck Lever <chuck.lever@oracle.com>
> > > cc: Boris Pismenny <borisp@nvidia.com>
> > > cc: John Fastabend <john.fastabend@gmail.com>
> > > cc: Jakub Kicinski <kuba@kernel.org>
> > > cc: Eric Dumazet <edumazet@google.com>
> > > cc: "David S. Miller" <davem@davemloft.net>
> > > cc: Paolo Abeni <pabeni@redhat.com>
> > > cc: Jens Axboe <axboe@kernel.dk>
> > > cc: Matthew Wilcox <willy@infradead.org>
> > > cc: netdev@vger.kernel.org
> > > ---
> > >  net/tls/tls_sw.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > > index cac1adc968e8..6aa6d17888f5 100644
> > > --- a/net/tls/tls_sw.c
> > > +++ b/net/tls/tls_sw.c
> > > @@ -945,7 +945,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > >  	struct tls_rec *rec;
> > >  	int required_size;
> > >  	int num_async = 0;
> > > -	bool full_record;
> > > +	bool full_record = false;
> > >  	int record_room;
> > >  	int num_zc = 0;
> > >  	int orig_size;
> > > @@ -971,6 +971,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > >  		}
> > >  	}
> > >  
> > > +	if (!msg_data_left(msg) && eor)
> > > +		goto just_flush;
> > > +
> > 
> > Hi David,
> > 
> > the flow of this function is not entirely simple, so it is not easy for me
> > to manually verify this. But in combination gcc-12 -Wmaybe-uninitialized
> > and Smatch report that the following may be used uninitialised as a result
> > of this change:
> > 
> >  * msg_pl
> 
> This warning seems correct to me.
> 
> >  * orig_size
> 
> This warning assumes we hit the first warning and then hit the goto
> wait_for_memory;
> 
> >  * msg_en
> 
> I don't get this warning on my system but it's the same thing.  Hit the
> first warning then the goto wait_for_memory.
> 
> >  * required_size
> 
> Same.
> 
> >  * try_to_copy
> 
> I don't really understand this warning and I can't reproduce it.
> Strange.

Thanks Dan.

Of the above I think only the last one was flagged
by GCC but not Smatch. I can try investigating further if it is useful.


