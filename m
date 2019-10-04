Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24CCC61C
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbfJDWy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:54:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43560 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbfJDWy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:54:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so7316041qke.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qiOxBsrNkkWuzAgDryKeqbCBWoSM41fm60c6tImIZqI=;
        b=sq+TI79mrnr2qpDYq3CF9NUjDxljX7hLzhB+YwKJS1lWMJecq8wHZfwqEjW/tpBpGo
         akYYnmhDQL0VY7vkRcKiV9agOTB2bLQbDXn1Vi/qpVQA0haeJQQVKwxR0MWHXP87krFk
         lJ4n7rc8kQ9kv2EcEZU+iEDvISvyXWCjMrqco156qKfadfHyLHq84lYWI9bjo28POxMo
         1qlCU0zLennLE+Bm9RDs+Sxu2AIL/VqWnyhZ0V06pq22vj+BAZ1wJwbFsogPx171roIV
         DkM9iRZSzW2LpyNSNp6Pa4muAdh0T9mxeQIHsnYRG3NnixJaq+eDgPOP7Mjlh93Er+UA
         OxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qiOxBsrNkkWuzAgDryKeqbCBWoSM41fm60c6tImIZqI=;
        b=EmF10e5CTX0Bh0uoM524m11VIyG3sQSUMaj8oCC/P6xkq+TS1zxq6gOjO0MzKLme5U
         udKDEkJiG051/QuueUTJR8m3PBqdF351Y4NPUyTHyL5Xa5OqhfMpJ2L/oKQM+0d/f6sj
         iVVapJjdCsEqLt+NdakqrrorgaoterAvrdVDiYSo6YsLmGGLSGLhsp5eV74nxRvV9AuH
         wk3uT16VxZqLmd5zL72PKvjG/L/A7IXw6Okst0IoJmGHaGxr6bx1wzvbzrZs+SYmmfXa
         QTR8InywWj2igBFkB4vjf0QnvEOHDvI7LpgyBRW6TTUhvajFsjTMa8BNGmUFOiiEkY+c
         oNuw==
X-Gm-Message-State: APjAAAVasr+3oFwuLxzAm+V9gxwNX09vQkq7UQZthL9yw3PYcUWlGXtB
        tS0B8GfB2HG3oYINQo5T8YM2PT7KPA0=
X-Google-Smtp-Source: APXvYqwlA+KR/BBv3t9qn0p06ra1lugJRYm7gLe5EUjQTKKtOEKiBSvsCDoKpSCVNmBXMbXGJyVZCQ==
X-Received: by 2002:a37:713:: with SMTP id 19mr13073331qkh.490.1570229666010;
        Fri, 04 Oct 2019 15:54:26 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l189sm3352154qke.69.2019.10.04.15.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 15:54:25 -0700 (PDT)
Date:   Fri, 4 Oct 2019 15:54:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add max len check for TCA_KIND
Message-ID: <20191004155420.19bd68d2@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003194525.GD3498@localhost.localdomain>
References: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
        <36471b0d-cc83-40aa-3ded-39e864dcceb0@gmail.com>
        <CAM_iQpXa=Kru2tXKwrErM9VsO40coBf9gKLRfwC3e8owKZG+0w@mail.gmail.com>
        <20190921192434.765d7604@cakuba.netronome.com>
        <20191003194525.GD3498@localhost.localdomain>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 16:45:25 -0300, Marcelo Ricardo Leitner wrote:
> On Sat, Sep 21, 2019 at 07:24:34PM -0700, Jakub Kicinski wrote:
> > Applied, queued for 4.14+, thanks!  
> 
> Ahm, this breaks some user applications.
> 
> I'm getting "Attribute failed policy validation" extack error while
> adding ingress qdisc on an app using libmnl, because it just doesn't
> pack the null byte there if it uses mnl_attr_put_str():
> https://git.netfilter.org/libmnl/tree/src/attr.c#n481
> Unless it uses mnl_attr_put_strz() instead.
> 
> Though not sure who's to blame here, as one could argue that the
> app should have been using the latter in the first place, but well..
> it worked and produced the right results.
> 
> Ditto for 199ce850ce11 ("net_sched: add policy validation for action
> attributes") on TCA_ACT_KIND.

Thanks for the report Marcelo! This netlink validation stuff is always
super risky I figured better find out if something breaks sooner than
later, hence the backport.

So if I'm understanding this would be the fix?

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00f6b3e..bcc1178ce50d 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -832,8 +832,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 }
 
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
-       [TCA_ACT_KIND]          = { .type = NLA_NUL_STRING,
-                                   .len = IFNAMSIZ - 1 },
+       [TCA_ACT_KIND]          = { .type = NLA_STRING },
        [TCA_ACT_INDEX]         = { .type = NLA_U32 },
        [TCA_ACT_COOKIE]        = { .type = NLA_BINARY,
                                    .len = TC_COOKIE_MAX_SIZE },
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 81d58b280612..1047825d9f48 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1390,8 +1390,7 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
 }
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-       [TCA_KIND]              = { .type = NLA_NUL_STRING,
-                                   .len = IFNAMSIZ - 1 },
+       [TCA_KIND]              = { .type = NLA_STRING },
        [TCA_RATE]              = { .type = NLA_BINARY,
                                    .len = sizeof(struct tc_estimator) },
        [TCA_STAB]              = { .type = NLA_NESTED },


Cong, are you planning to take a look? With this we have to find a
different way to deal with the KMSAN report you mentioned :(
