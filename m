Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894421B066E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTKV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725775AbgDTKV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 06:21:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D82C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 03:21:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z6so10728130wml.2
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 03:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xP7s9vcEbHDrLgPOLOc0yPuuzUfEWMrRlJt6+CvzmS4=;
        b=J03T5qL+HPFkNiy+ye+45rUCOIWjwC2BS4MSSM6KnKT7d3GeJjBLjwIgGi2v/91PbC
         xaNxBHykScrfk+vJ0ewOern/wEqROeZmDkdlZy/Nm0XYx+KXD8HTe75HNjt3OHWrj+nQ
         9uUBaTzRKzA3H7DfEkhdZWyKOaNyxJOLNdbf54eiHIJPzcJzHAkpKIrGdOigZV8Qh4Ee
         1BuhiYmbPhlFHSBpjq8UhvkKd+Lhm3nksBEr49HDAgcRAzzPMTQo72AW52z7o2EMTan4
         UumocX/2O5o8ZpUNNwkBmS6r8QpKTWc+GOOVlJraAlaEU82Klo0mxn2wmPB3Bi/84r/9
         PxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xP7s9vcEbHDrLgPOLOc0yPuuzUfEWMrRlJt6+CvzmS4=;
        b=Sb3UMwzlA0PaBBKcxxirh9qxXTqbJ/Tl9ytN+lixfN7S0B4HsUR9MCNKTyY4tZiESR
         lKpRXoSERwZ9cRfhXBkPis2St41a1xn7+ME7luwcjYqREt9G34O1fu6KASgHZs5TI0C5
         ZVH0v17UNZSr7d2GXa+nNOzH217/ItCVt20NSQH2SjP6xj/tPeMgBu0p2ZRPuom4Efaj
         HMC7TFWkOiG3+BULDE9s4/0TBmw8xLxZ1ooHQMRIVu63LiucY3rJIaBAzJoimErz9k+8
         cEONYPci/rjAtweEKcEIV9hvRY7W8ZfSJmE5yHiar6o7ZpUxueUbLAchK6zwIfG/ndfx
         OM5w==
X-Gm-Message-State: AGi0PuYCOm3iTll0oIgEzcRc5qN18967u+PFGM7x3htPk78a9Wf8c1jt
        Emdlc1XoeqCD8yTXARA3jTBkWAXLz8U=
X-Google-Smtp-Source: APiQypKukWYMc59NdZisrx9cG22Rqm5MMAv3ea6WUu4t4yxHY1ueLPWkbm8m21LsqqgIdceibHgN9Q==
X-Received: by 2002:a1c:abc3:: with SMTP id u186mr14331852wme.42.1587378084303;
        Mon, 20 Apr 2020 03:21:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u7sm794386wmg.41.2020.04.20.03.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 03:21:23 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:21:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] team: fix hang in team_mode_get()
Message-ID: <20200420102123.GD6581@nanopsycho.orion>
References: <20200418161729.14422-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418161729.14422-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Apr 18, 2020 at 06:17:29PM CEST, ap420073@gmail.com wrote:
>When team mode is changed or set, the team_mode_get() is called to check
>whether the mode module is inserted or not. If the mode module is not
>inserted, it calls the request_module().
>In the request_module(), it creates a child process, which is
>the "modprobe" process and waits for the done of the child process.
>At this point, the following locks were used.
>down_read(&cb_lock()); by genl_rcv()
>    genl_lock(); by genl_rcv_msc()
>        rtnl_lock(); by team_nl_cmd_options_set()
>            mutex_lock(&team->lock); by team_nl_team_get()
>
>Concurrently, the team module could be removed by rmmod or "modprobe -r"
>The __exit function of team module is team_module_exit(), which calls
>team_nl_fini() and it tries to acquire following locks.
>down_write(&cb_lock);
>    genl_lock();
>Because of the genl_lock() and cb_lock, this process can't be finished
>earlier than request_module() routine.
>
>The problem secenario.
>CPU0                                     CPU1
>team_mode_get
>    request_module()
>                                         modprobe -r team_mode_roundrobin
>                                                     team <--(B)
>        modprobe team <--(A)
>                 team_mode_roundrobin
>
>By request_module(), the "modprobe team_mode_roundrobin" command
>will be executed. At this point, the modprobe process will decide
>that the team module should be inserted before team_mode_roundrobin.
>Because the team module is being removed.
>
>By the module infrastructure, the same module insert/remove operations
>can't be executed concurrently.
>So, (A) waits for (B) but (B) also waits for (A) because of locks.
>So that the hang occurs at this point.
>
>Test commands:
>    while :
>    do
>        teamd -d &
>	killall teamd &
>	modprobe -rv team_mode_roundrobin &
>    done
>
>The approach of this patch is to hold the reference count of the team
>module if the team module is compiled as a module. If the reference count
>of the team module is not zero while request_module() is being called,
>the team module will not be removed at that moment.
>So that the above scenario could not occur.
>
>Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>---
> drivers/net/team/team.c | 10 +++++++++-
> 1 file changed, 9 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>index 4004f98e50d9..21702bc23705 100644
>--- a/drivers/net/team/team.c
>+++ b/drivers/net/team/team.c
>@@ -465,9 +465,15 @@ EXPORT_SYMBOL(team_mode_unregister);
> 
> static const struct team_mode *team_mode_get(const char *kind)
> {
>-	struct team_mode_item *mitem;
> 	const struct team_mode *mode = NULL;
>+	struct team_mode_item *mitem;
>+	bool put = false;
> 
>+#if IS_MODULE(CONFIG_NET_TEAM)
>+	if (!try_module_get(THIS_MODULE))

Can't you call this in case this is not a module? Wouldn't THIS_MODULE
be NULL then? try_module_get() handles that correctly.


>+		return NULL;
>+	put = true;
>+#endif
> 	spin_lock(&mode_list_lock);
> 	mitem = __find_mode(kind);
> 	if (!mitem) {
>@@ -483,6 +489,8 @@ static const struct team_mode *team_mode_get(const char *kind)
> 	}
> 
> 	spin_unlock(&mode_list_lock);
>+	if (put)
>+		module_put(THIS_MODULE);

Can't you just put this under the same "if IS_MODULE" statement and
avoid the "put" variable? Or in case the statement is not needed, just
do plain module_put call.

Otherwise, the patch looks fine.



> 	return mode;
> }
> 
>-- 
>2.17.1
>
