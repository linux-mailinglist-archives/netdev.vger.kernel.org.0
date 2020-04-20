Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10621B073A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgDTLS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgDTLS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 07:18:26 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE89C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 04:18:26 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g10so7129902lfj.13
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 04:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOPTCUjPnYOCdtJ/iE6dIiKGDQ6q8xcBPtT/0PMmhkg=;
        b=mAa8b6Owr2vmOCeaEmHAyydQFD5Mj5exeOW7qmQL91x4nxjzJAWXFg5akSJXV3o7Sg
         OetAvd4ALgqCVuRUBmUhlzgjtYwCFYN0T+U/Zh1ZbKpsMH15Y20ZMpXoYvvXDVQ24Zb/
         hl8/1jXdY/k7ObmTQKtcqlFU9ak2ZEFovZFXT1HqeuVIE6AD4cggBuWuvzkPcb8nYgEQ
         MpXPDLTedpfwP8PbmQRFNzcxMQzMI2W0RebzNT0hDVOiNlMlLtwITljm4PTg9vvbx60U
         yLHKdjg6BzQv5bRZXGfVBLO/WU1Gc5Be4RV9YqpJiCyVF/AOYq068xseLU7HGPlG3cjJ
         kJWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOPTCUjPnYOCdtJ/iE6dIiKGDQ6q8xcBPtT/0PMmhkg=;
        b=o0ykkgsqP41ZgQwjbY73HYi+a5qONqocDTBhStBmcyBtRXWpj8zqKGe8ctGGgGA7X8
         DxnfRH3KSmsQe1pyt0cWYDIcwAoRyivxN1P48KuTj39k7MI9WFmCjdH9yccFZsE4CjNk
         lQI2W4bppqaXSUmQmK04MJ01a/EeBfAD92v5KDhTkqjksguWbGNsdHBg0Jn4rPopatty
         +LidGQmG4CQ0sEISJqrBcES1ATMyEWeKeywk56Cghz0+/Mmt6eKXTFTve3hL/NC89gG1
         HpGCh6vQKNj28ERafaKcNtuVkUyDYwnWr9MH2woCNzwUnTNrhaOeaCSDw72mtjHomA3Z
         1+lg==
X-Gm-Message-State: AGi0PuYM1m6ZO+4XIr8RM3WAQgLy0vFw6jKxcZjnBnj9QMs0N815tX81
        7skkys/iiIVdFZZpqPz5lO89gKr68Eq3XHYdcO0kQAGv
X-Google-Smtp-Source: APiQypKjiZhncTfaSLILSgs+Z9Cz9OCnU7arbnqwjccDycwv0DhP5JlMgEZ/nlg5cQ/4Q+ABxSLHlVY4oJFFxKbhSfI=
X-Received: by 2002:ac2:58d7:: with SMTP id u23mr10368029lfo.182.1587381504527;
 Mon, 20 Apr 2020 04:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200418161729.14422-1-ap420073@gmail.com> <20200420102123.GD6581@nanopsycho.orion>
In-Reply-To: <20200420102123.GD6581@nanopsycho.orion>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 20 Apr 2020 20:18:13 +0900
Message-ID: <CAMArcTXBb5oKt07wqCHQ1Uo6KDJj8SzqeYvh7LFRgjzY9eiHHA@mail.gmail.com>
Subject: Re: [PATCH net] team: fix hang in team_mode_get()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 at 19:21, Jiri Pirko <jiri@resnulli.us> wrote:
>

Hi Jiri,
Thank you for your review!

> Sat, Apr 18, 2020 at 06:17:29PM CEST, ap420073@gmail.com wrote:
> >When team mode is changed or set, the team_mode_get() is called to check
> >whether the mode module is inserted or not. If the mode module is not
> >inserted, it calls the request_module().
> >In the request_module(), it creates a child process, which is
> >the "modprobe" process and waits for the done of the child process.
> >At this point, the following locks were used.
> >down_read(&cb_lock()); by genl_rcv()
> >    genl_lock(); by genl_rcv_msc()
> >        rtnl_lock(); by team_nl_cmd_options_set()
> >            mutex_lock(&team->lock); by team_nl_team_get()
> >
> >Concurrently, the team module could be removed by rmmod or "modprobe -r"
> >The __exit function of team module is team_module_exit(), which calls
> >team_nl_fini() and it tries to acquire following locks.
> >down_write(&cb_lock);
> >    genl_lock();
> >Because of the genl_lock() and cb_lock, this process can't be finished
> >earlier than request_module() routine.
> >
> >The problem secenario.
> >CPU0                                     CPU1
> >team_mode_get
> >    request_module()
> >                                         modprobe -r team_mode_roundrobin
> >                                                     team <--(B)
> >        modprobe team <--(A)
> >                 team_mode_roundrobin
> >
> >By request_module(), the "modprobe team_mode_roundrobin" command
> >will be executed. At this point, the modprobe process will decide
> >that the team module should be inserted before team_mode_roundrobin.
> >Because the team module is being removed.
> >
> >By the module infrastructure, the same module insert/remove operations
> >can't be executed concurrently.
> >So, (A) waits for (B) but (B) also waits for (A) because of locks.
> >So that the hang occurs at this point.
> >
> >Test commands:
> >    while :
> >    do
> >        teamd -d &
> >       killall teamd &
> >       modprobe -rv team_mode_roundrobin &
> >    done
> >
> >The approach of this patch is to hold the reference count of the team
> >module if the team module is compiled as a module. If the reference count
> >of the team module is not zero while request_module() is being called,
> >the team module will not be removed at that moment.
> >So that the above scenario could not occur.
> >
> >Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> >Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> >---
> > drivers/net/team/team.c | 10 +++++++++-
> > 1 file changed, 9 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> >index 4004f98e50d9..21702bc23705 100644
> >--- a/drivers/net/team/team.c
> >+++ b/drivers/net/team/team.c
> >@@ -465,9 +465,15 @@ EXPORT_SYMBOL(team_mode_unregister);
> >
> > static const struct team_mode *team_mode_get(const char *kind)
> > {
> >-      struct team_mode_item *mitem;
> >       const struct team_mode *mode = NULL;
> >+      struct team_mode_item *mitem;
> >+      bool put = false;
> >
> >+#if IS_MODULE(CONFIG_NET_TEAM)
> >+      if (!try_module_get(THIS_MODULE))
>
> Can't you call this in case this is not a module? Wouldn't THIS_MODULE
> be NULL then? try_module_get() handles that correctly.
>
>
> >+              return NULL;
> >+      put = true;
> >+#endif
> >       spin_lock(&mode_list_lock);
> >       mitem = __find_mode(kind);
> >       if (!mitem) {
> >@@ -483,6 +489,8 @@ static const struct team_mode *team_mode_get(const char *kind)
> >       }
> >
> >       spin_unlock(&mode_list_lock);
> >+      if (put)
> >+              module_put(THIS_MODULE);
>
> Can't you just put this under the same "if IS_MODULE" statement and
> avoid the "put" variable? Or in case the statement is not needed, just
> do plain module_put call.
>
> Otherwise, the patch looks fine.
>

You're right, If the team is not a module, THIS_MODULE will be null.
try_module_get() and module_put() deal with NULL well.
So, I will send a v2 patch that will remove the #if statement and
the put variable.

Thanks a lot!
Taehee Yoo
