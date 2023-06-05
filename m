Return-Path: <netdev+bounces-8129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4B2722DA6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3FD281301
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F1419BAA;
	Mon,  5 Jun 2023 17:30:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE28BDDC1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:30:14 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1358F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNphJdWywMug3S0FfytzdR6ZrGQtmhIOzftHNS/dHHPz0LK6ZcGZ1yEMGffGRkMls+syYxnw9GsflT5Vw/PeCT+UuZgiHzs53lrBBovcHFjHcC5En+huzpfEe8nWOh6qLBHso/RVgp++2jnDLSXQeQr5Zpk5iB5v2GfkOjz36JXcBywLmpeFxvC9YU4pR1d2OoahzsBeqnFTkqsscZTq2G1YzAsYZ05kWuoOzT/fBTZ35Erk5CVCivwhAT+InK/No4jpwHeawruuOHzl3ik6kbYF5UeEt7e4T8Q1o4cOR8rbLnT8+denjDx2t1MW8V40VG5aalvqRgOyZwhCqh+n9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2WckWjReMRdo92bhNRj6Rt9N0IS3JbIt2tt4cuaArI=;
 b=CGzFuPR303AytJl9ru9bldiktALtcjntmsdH58f9zI79b1T3Mo2vsXwiBBZYWJp5mOgpum14wzG7C8f3R3e6BPOJ1VcLoqJel0Ghfi9WFMXatU1/tzzw6gbwOla6BtDRNOSgM7Xg9qglG43qDyWnv+zlnGBILy14LjoIh7BZ3Cyd/okvv/r6V61NGyt7fc2vqvltKiOMo2R95bjf7rllRasSNNikTlzWEoi1pL1ouj5q7t7koBu3NzSg6bp3RRkH3Ge5kMbkMpyZhNw/UMxMO25xuhUP+h4RDM3WHoXagE+KdFxx+kyLi6xhpXxrd6VgmDVRXKd2VAjX4h5GiyBBNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2WckWjReMRdo92bhNRj6Rt9N0IS3JbIt2tt4cuaArI=;
 b=bkSQxJYUTfUkVJbAfH2w/6LRCb8IJXGpRiTucBzotqRSIKFm/JRo24tE0ihMQB4SmKVl7JvYrQ8b+M3VKx9GM0mVZs2YkGYD0uciYC6QzU3eS9AO/gW6+UncSx8PdtNT/VAgA+9Q9C4+Zc8whAPuWWPqWrVSbmJrV0wGiMQVI7o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5557.namprd13.prod.outlook.com (2603:10b6:303:195::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 17:30:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 17:30:07 +0000
Date: Mon, 5 Jun 2023 19:30:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Eyal Birger <eyal.birger@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Patrick Rohr <prohr@google.com>
Subject: Re: [PATCH] net: revert "align SO_RCVMARK required privileges with
 SO_MARK"
Message-ID: <ZH4bmdrWFx6iGIUy@corigine.com>
References: <20230605081218.113588-1-maze@google.com>
 <ZH3+5E/9f1XmQg+o@lincoln>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZH3+5E/9f1XmQg+o@lincoln>
X-ClientProxiedBy: AM3PR07CA0107.eurprd07.prod.outlook.com
 (2603:10a6:207:7::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5557:EE_
X-MS-Office365-Filtering-Correlation-Id: eb14e4ce-a597-4cee-9d77-08db65ea8190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gyZ012qRkGVg8WgBXWuMokA7CBzth8AGBvkwakwc7CA4Ff3uHrhVLfpBk/4aiExEmWXkJP6FITWtpceiw8njpGHSM6Ms9Cc6CnluCy2VS5IQ6bnbEpTg2O5t84x1Ey9Hl74OUdl3P5PXgD8Xsf1qNb4l087RtQl9od6u1v58cGT/2yHxTQkIrJvbXHoqzCFRXoyMMOoxjyktGokExEDBvo3//WNurXNwMg2mvuexA3bnCe04q2rnqJSiguO+ausdi6P+xLVI2F6kWptOuxJpjCKOItobPFHoHrw25bdogBw85/pEheUmva7FN/RlgkalRljfv1pwI1IoKBo/do5PoAVT4EG9Vu5IGkboe9XljNZmhcjq5d4G9njORBNbJXb6tkl06GtPqgHOYJ7m/Tt1U5dsEC8HszZFPNUcz24YYyKcqcCxUmjVHFR6uXBVhFbIctt/ImXrS4pKfcakfS9sKDLcOd57jeZMctdLNE/M3I9hkI/L+gVDidDj7QR+zydLPM5kFrf7z7XLXEZm8ox3uSiR20vECRy49D+GYE+TgMw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(376002)(346002)(396003)(451199021)(6506007)(6512007)(186003)(84970400001)(2616005)(83380400001)(66574015)(36756003)(6666004)(6486002)(2906002)(8676002)(8936002)(54906003)(44832011)(478600001)(5660300002)(38100700002)(6916009)(4326008)(86362001)(316002)(41300700001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzhLVDI0L0YrcnZhOGdzS3o4RWhNYUpRUlFtWk5waitsVDJvMU00Y0NuUFMx?=
 =?utf-8?B?M0FBUGo2Vmd2bkdUN1BVMGN6Mk93M09NZjFWK3VLcExVM0d4UkpEYmM3OTNO?=
 =?utf-8?B?NUxCaEU1NThNeW5tTmYwNnAxdGRGNjNTcjg2ODg5VTl1YnczNzZCcTJtb09m?=
 =?utf-8?B?WnJWUE5nanN0RWJCak1RaFVIZ2RLTHpSamcyQ3M1dnl0KzZ0OHFsbFRjZDVZ?=
 =?utf-8?B?NCt1cXdGKy96U1NCQkovalc3MGUvdlRXbGxyVlZ5UU1XV3FwRGQxeUpiZVg2?=
 =?utf-8?B?NE5kZ1FnNzdIbjFmeVREL21KYWhrYm5MSkhFL1NibjlUeHlXWHBtYlhEdldG?=
 =?utf-8?B?QWUzU1UzUWdCKzV6S25xZ0IvSGloV3FtYWJpdk5YSXJ6L0cwSnhacVNrSkxr?=
 =?utf-8?B?aE0xMGUzMUFMUy9pQ25MK1ptOXZTc1hzOGVkVE5ZZEhKY2dMcjJzSVVwSXZ0?=
 =?utf-8?B?U1ljMmUvVi8zaWcxQ09aQlAwZEkxVjFTZlBMMThVVkUrRHAzQlhPcTdWYVFs?=
 =?utf-8?B?ZmdHQys4MllSMnVZYUJoMVNTbTVDalBQcFI4YTBvalNlSWozWkRWcFZ6cG9y?=
 =?utf-8?B?MERFVWw5TnpSQ0RVdFNoYjQ1SUZsN2pLd2pqeGZzbERaNnJkcDRXSC9QRTFC?=
 =?utf-8?B?dEUvSW8xNlZtMHlRa2VNbHNBeHd5YnBqTUozbEtHOW1LRjVLNUFLQktCbHhy?=
 =?utf-8?B?MS92V0QxUi9nTEYrWkVTK3hzeHJiK0p4ZVh4d2c5ZTVSN1R0UDd2RlozOWZv?=
 =?utf-8?B?Y0E3YW9QeG9VclhWeXRKL3dldU1vbUFkZklkUU9KSSsrZndrLzQxdEU5Vmpy?=
 =?utf-8?B?OEdJM2FweVZIK2JaQ0VHQkxJZ0lSZlZEYXF6NmRkbGJCWEVwZHZzcnlRZ2Fi?=
 =?utf-8?B?dkxjQWpDMG9oUy8zVmtyNExJdEl2TFJmd1B2bHJhbFZ1cy9iTk5xdHI5OE1i?=
 =?utf-8?B?R082a29VeEFvT3J3T25uN2RyZzZ6eVBGaExCQlhrVE44WlRINHpCbFFubHVl?=
 =?utf-8?B?dFNlWTJSNFFOc2ZHY2dZT3VnQnVYMFI4dnFHOVprN2c2d0VNVExBYm1BUVk4?=
 =?utf-8?B?c3VaRFZ3S3FwRGVrMWxvTFZQdExjYUJHYmFqWk5ENWppVXpvbktGTG1MbzNU?=
 =?utf-8?B?WWdURC9lUzFXU1hoeEtVd0hIWU5iMTZZbmFTaU9JVTkwWmNlOEhYYjQxVHhN?=
 =?utf-8?B?S2VKMTF1TGJqaVhYK0JpK3JiRGxVcFZHRUVGczcrUE1GZms1WXRoVkEzVFRr?=
 =?utf-8?B?c1d6eXNqSE9adXFhUWx6cVlzTkJESG45K1ZuMUh4S1ZHM2NZbWc3YkV5eXdk?=
 =?utf-8?B?ZXVlSDdUVi8ybEhRVitGVDhKQXpMZVJPejB2dFJEeHZNUGdraXhsL3cyZC96?=
 =?utf-8?B?Z285b1NuN00zanZIR2E0cW9Zbzh2WDVCT3BvWHpyU0hUMkY2KzJaMnNkczlq?=
 =?utf-8?B?a0N3OTkraGthaGFGUlVTaXFjV1dSTFI1aFFkM3VzMjZMM1ZOeUJrWW9Fa1kw?=
 =?utf-8?B?RDU4Um96STJnQi9qWk5qdEs5WGtmbnkwQnFTOWh2b0c4ODRoTjRRVllxQVAw?=
 =?utf-8?B?NnZMQlozOXRGZWtmQXVxL1RrTmt0Uk9vdDM0Y1l5TkJoTmhsWC8wZGMrUldx?=
 =?utf-8?B?M3preGlSd0x5MnlUejluQzY5SUI0UGVmN2paT3hKWUJqa2t6ZXZiWnVLOWF5?=
 =?utf-8?B?cm1hbTc3UDFGdzdleXBuaFdBT1pJNjJLN3ZGWlRTNkREOVZSdkJYQXlndGR1?=
 =?utf-8?B?OUtsSWVvbjFsVVhKcldleUUzenpVVXZOWVVDMFZsejRBdzQ2M1lQWVlKeEFs?=
 =?utf-8?B?dkJEYU5KOVpZenJqNG5qUTJuWDcrb1N2L3lpOVVlYlE3VDJBWGpwRnQ5SE9q?=
 =?utf-8?B?dytSblhuaFVaZXgycVdFTkw4RUF5aXZzcHN4VHoyQlpUNWRCOFhIdUZLZ2Jx?=
 =?utf-8?B?L3EvbDgwbDFncWxvWVRaNWRjTjlJcURIM3pxL05mZ0xhR0pyeWVoMERSMUw4?=
 =?utf-8?B?U0pHQVB1MFpuSjVPR01PVmpML1M5cjZ0eXNxOFd1R1labG13OFV3a0ZSVFNT?=
 =?utf-8?B?elFqRXVFdUExcFZlRGZaS0tJMXJRaGsyZFU2cENwaCs0RmVKWiszZjlYb0lX?=
 =?utf-8?B?N0pHQVUrUnBoWk5FQ295TlN0alJSNncvd0lYRE50QmFnWkErZjNhd01xdlZp?=
 =?utf-8?B?UnByN1VkOVE5ZUZleVlYbW9pN2EwV2NWTmtpZnJWczZmTUcvTGpVSFhQU01i?=
 =?utf-8?B?REJBR2VBWmw5L01UQSs4eHRSZkpRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb14e4ce-a597-4cee-9d77-08db65ea8190
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 17:30:07.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5KtELn0d1JqHTFij1rnk5z1GjD8aBjZVTQKJSfjMOvZo8r5f5dmvaWp2aJNSvyKUTKmniYnwBFAyGiyC08zLN4TWKHAwAf5c8T8SsJnt1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5557
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 05:27:32PM +0200, Larysa Zaremba wrote:
> On Mon, Jun 05, 2023 at 01:12:18AM -0700, Maciej Żenczykowski wrote:
> > This reverts:
> >     commit 1f86123b97491cc2b5071d7f9933f0e91890c976
> >     net: align SO_RCVMARK required privileges with SO_MARK
> > 
> >     The commit referenced in the "Fixes" tag added the SO_RCVMARK socket
> >     option for receiving the skb mark in the ancillary data.
> > 
> >     Since this is a new capability, and exposes admin configured details
> >     regarding the underlying network setup to sockets, let's align the
> >     needed capabilities with those of SO_MARK.
> > 
> 
> No need to copy-paste reverted commit in full. Others are supposed to look it up 
> in the log. The proper way to reference another commit is [0]:
> 
> Commit e21d2170f36602ae2708 ("video: remove unnecessary
> platform_set_drvdata()") removed the unnecessary
> platform_set_drvdata(), but left the variable "dev" unused,
> delete it.
> 
> Have you checked your patch with checkpatch? I am quite sure it would not allow 
> copy-pasted commit message.
> 
> [0] kernel.org/doc/html/v4.17/process/submitting-patches.html
> 
> Also, please add patch prefix with tree name specified (net/net-next).

To add some colour to that, assuming 'net', and with a slightly
fixed-up subject:

	[PATCH net]: Revert "net: align SO_RCVMARK required privileges with SO_MARK"

> 
> > This reasoning is not really correct:
> >   SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
> >   it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
> >   and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
> >   sets the socket mark and does require privs.
> > 
> >   Additionally incoming skb->mark may already be visible if
> >   sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.
> > 
> >   Furthermore, it is easier to block the getsockopt via bpf
> >   (either cgroup setsockopt hook, or via syscall filters)
> >   then to unblock it if it requires CAP_NET_RAW/ADMIN.
> > 
> > On Android the socket mark is (among other things) used to store
> > the network identifier a socket is bound to.  Setting it is privileged,
> > but retrieving it is not.  We'd like unprivileged userspace to be able
> > to read the network id of incoming packets (where mark is set via iptables
> > [to be moved to bpf])...
> > 
> > An alternative would be to add another sysctl to control whether
> > setting SO_RCVMARK is privilged or not.
> > (or even a MASK of which bits in the mark can be exposed)
> > But this seems like over-engineering...
> > 
> > Note: This is a non-trivial revert, due to later merged:
> >   commit e42c7beee71d0d84a6193357e3525d0cf2a3e168
> >   bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()
> > which changed both 'ns_capable' into 'sockopt_ns_capable' calls.
> > 
> > Fixes: 1f86123b9749 ("align SO_RCVMARK required privileges with SO_MARK")
> 
> I have never seen a reverted commit referenced with a "Fixes: " tag.

Yes, maybe. Though an example seems to be:

	e7480a44d7c4 ("Revert "net: Remove low_thresh in ip defrag"")

If we do want a fixes tag, then I think it should be:

Fixes: 1f86123b9749 ("net: align SO_RCVMARK required privileges with SO_MARK")

> > Cc: Eyal Birger <eyal.birger@gmail.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Patrick Rohr <prohr@google.com>
> > Signed-off-by: Maciej Żenczykowski <maze@google.com>
> > ---
> >  net/core/sock.c | 6 ------
> >  1 file changed, 6 deletions(-)
> > 
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 24f2761bdb1d..6e5662ca00fe 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
> >  		__sock_set_mark(sk, val);
> >  		break;
> >  	case SO_RCVMARK:
> > -		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
> > -		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> > -			ret = -EPERM;
> > -			break;
> > -		}
> > -
> >  		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
> >  		break;
> >  
> 
> Both code and your reasoning seem fine.

-- 
pw-bot: cr


