Return-Path: <netdev+bounces-1984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8D06FFD76
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 235CD1C2103A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649DD18C17;
	Thu, 11 May 2023 23:46:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C71AD50
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:46:42 +0000 (UTC)
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0069530C3;
	Thu, 11 May 2023 16:46:40 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-61aecee26feso42403156d6.2;
        Thu, 11 May 2023 16:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683848800; x=1686440800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWYVMicQIGCwGUbuMq24kkfpiIJJVDGbM9ZlLCUcgg4=;
        b=Y6GFuCB4A8uAl4TFv4+ubLWysOkiBqCPJXiQ3cU1Upx49ayKrsVkjbgq1Ysk3nstYB
         kB83K/DsfBX+e91d10rv7GVyJ5GIPNh/uiIqgFPazkTz1nIjZMffH/ZhyaTkDZL8U99Q
         LuEBz/ETHCr4jzTVwJdHGHEnM7rDjox83vNioTt+bAT4etacgFaEyXcf8HEy4o5kP5RX
         9fjkBIW0tmUwvF1L6QlroyOk0EP5lebT953AFZkZV0jbnqouSWCWZKYK6SlZhw5/QiOc
         6n/qd6ckO0rEjc9hQVqlZteq2mR4iDF6iTqC8fOVBcBhwbxmsz5KvX8K17ElVJehFpr7
         UfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848800; x=1686440800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWYVMicQIGCwGUbuMq24kkfpiIJJVDGbM9ZlLCUcgg4=;
        b=RrN5LFF2M9fmmzB1CuSVj4zUjF5EpHNuJ/uKAH3UVQ9peEUZ6wg67+a6/j5YjaGXTC
         6tmhUUrxy1gPRAtjhajI3HuaTt/wulcDfWVQKXUHR3iRtLBlSVZiz4RaHcxLi+6Gq724
         KCsMWep+leL/5zNi9qnJVY6KECqKSVEKFLf2WJPs6P6U/vMpLnirupKWZR57YSbdmqoh
         fNysF9L7eIVyltcGtK6H1/PRScbLqY29a9iCIOrNpJsuXMYS6SMsCmurCHxMhq+NHTCj
         FU5qzFcn+CYJW7d+oToISohFHOXTPiKpwvBx0cUjCgDgNHZRsR3EN78/G1seJZ3iBDtC
         F9WA==
X-Gm-Message-State: AC+VfDxo4CtaZVH8CFh2y9lyijMzDfjwf+bC3SwnK73LzV1B2qKPlIv9
	IhcKs3DspHHktnn1QYA1jA==
X-Google-Smtp-Source: ACHHUZ6PAbBGLwyRsRceV6yIgPNwuDhds2K8wJqj3lYkE+Ns6349FZxmntaKk0+CdKzdnIBsCeav0A==
X-Received: by 2002:ad4:5aa1:0:b0:61b:5d38:b736 with SMTP id u1-20020ad45aa1000000b0061b5d38b736mr36766219qvg.35.1683848800018;
        Thu, 11 May 2023 16:46:40 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:8d4a:f604:7849:d619])
        by smtp.gmail.com with ESMTPSA id w18-20020a0cb552000000b006216ff88b27sm416141qvd.79.2023.05.11.16.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 16:46:39 -0700 (PDT)
Date: Thu, 11 May 2023 16:46:33 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZF1+WTqIXfcPAD9Q@C02FL77VMD6R.googleapis.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230508183324.020f3ec7@kernel.org>
 <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
 <20230510161559.2767b27a@kernel.org>
 <ZF1SqomxfPNfccrt@C02FL77VMD6R.googleapis.com>
 <20230511162023.3651970b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511162023.3651970b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 04:20:23PM -0700, Jakub Kicinski wrote:
> > But I see your point, thanks for the suggestion!  I'll try ->init() and
> > create v2.
>
> ->init() may be too early, aren't there any error points which could
> prevent the Qdisc from binding after ->init() was called?

You're right, it's in qdisc_create(), argh...

On Thu, May 11, 2023 at 04:20:23PM -0700, Jakub Kicinski wrote:
> > > > Looking at the code, I think there is no guarantee that (1st) cannot
> > > > happen after (2nd), although unlikely?  Can RTNL-lockless RTM_NEWTFILTER
> > > > handlers get preempted?
> > >
> > > Right, we need qdisc_graft(B) to update the appropriate dev pointer
> > > to point to b1. With that the ordering should not matter. Probably
> > > using the ->attach() callback?
> >
> > ->attach() is later than dev_graft_qdisc().  We should get ready for
> > concurrent filter requests (i.e. have dev pointer pointing to b1) before
> > grafting (publishing) B.
>
> I thought even for "unlocked" filter operations the start of it is
> under the lock, but the lock gets dropped after qdisc/block are found.
> I could be misremembering, I haven't looked at the code.

No, f.e. RTM_NEWTFILTER is registered as RTNL_FLAG_DOIT_UNLOCKED, so
tc_new_tfilter() starts and calls __tcf_qdisc_find() without RTNL mutex,
at least in latest code.

Thinking,
Peilin Ye


