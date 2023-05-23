Return-Path: <netdev+bounces-4793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E105770E4EB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C35C1281362
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BCE20685;
	Tue, 23 May 2023 18:52:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66041F93C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 18:52:59 +0000 (UTC)
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138191;
	Tue, 23 May 2023 11:52:57 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-62382e86f81so32748066d6.2;
        Tue, 23 May 2023 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684867976; x=1687459976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rWn2MIKjUVOy+G+HIOvINhREydSAiCGuFlv2fGYs64o=;
        b=AHu218kDLLmj5B9inD98p0ijdWxsVzotJoiFBu7VYMbOBxwClSKDrm9NIa+Gf/7Yb3
         M9eyEnLGkUac6u+bNwVOFN3szjB9xDIWkdVnwR4+ETtvBp3JkBhn/xV59A3QdlfZeulA
         gJnoNuum4Nn12d+oF5/+XZDnpuwv5CAc2KtPxI+VxUnrhfxO7qKMuy8RKc7/XAHi3rXd
         Pp2ysJftfHMjKaNUFUWlIP66u6tR9/L4iTD7+t06d+Y3Uxhcs53t29mWItjTZJiI08eP
         VAqAHPc0967s5GmblTQfSvu+vWiingIRBNQEWJ/FS2/z/r1UDfJbmwcxKKM0xkTzE2Os
         URsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684867976; x=1687459976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWn2MIKjUVOy+G+HIOvINhREydSAiCGuFlv2fGYs64o=;
        b=e2GMAK3G7LmzldEwUH52F3XASF64KO35wNJ9oU2M0gVI7hy40D/0kpiiZzz0UJNL6m
         1uY4d5jTansoNjohvQhmpti2pP2Fgh64xR7SscoTeYwUAP7Lprt7L7IHVR2pIfoa52ir
         T+/6WRuEamNLrMHZ3VnLdNS0dJCXfhlHZghw7hAxJ+ZGF7q4eNxSCqwD5Y9R0SfPpuwn
         vZEGJGSG9wclBjMtzGmULGoZLIAJtSiVHIwfu/S8APedC75wemldfg6oaO2joPg+DpKE
         /lFzdqnRVS3fGFcyqA8AiEGOB1QVhEjCBZhh753Vzeb1ThxMNwwjLlKaOk7fi6Gvj6un
         DHBA==
X-Gm-Message-State: AC+VfDyuCD78HH9hEu71WPyBxr4WKUeNzbbaeESavhc2X9lXxSyVeJVU
	Gv7dhK5siz2jo1vYV9eIhA==
X-Google-Smtp-Source: ACHHUZ41XhXT0087V4u7c4h9ZtuUk0wwdyR0WPz5F5FFh5ElEJXfHBqz4o9qAwjwBelPkWBPo7ftXA==
X-Received: by 2002:a05:6214:410d:b0:619:ff0c:9246 with SMTP id kc13-20020a056214410d00b00619ff0c9246mr8059323qvb.34.1684867976633;
        Tue, 23 May 2023 11:52:56 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id mm19-20020a0562145e9300b00623927281c2sm2974588qvb.40.2023.05.23.11.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 11:52:56 -0700 (PDT)
Date: Tue, 23 May 2023 11:52:48 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v2 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZG0LgCGLAKOV82YN@C02FL77VMD6R.googleapis.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
 <87sfbnxhg7.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfbnxhg7.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vlad,

On Tue, May 23, 2023 at 05:04:40PM +0300, Vlad Buslov wrote:
> > @@ -1458,6 +1472,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
> >     struct Qdisc *p = NULL;
> >     int err;
> >
> > +replay:
>
> Perhaps also set q and p to NULL here? Even though on cursory look you
> should get the same lookup result since the function is called under
> rtnl_lock, tc_modify_qdisc() does this on replay ("Reinit, just in case
> something touches this.") and tc_new_tfilter() got some non-obvious bugs
> after I introduced replay there without re-setting some of the required
> variables.

Sure, I'll reinitialize tcm, q and p after "replay:" in next version, just
like tc_modify_qdisc().  Thanks for the suggestion!

Peilin Ye


