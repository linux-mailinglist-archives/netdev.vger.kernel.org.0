Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7CB65BD30
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbjACJa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjACJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:30:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281F5FB0
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 01:30:20 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h16so28789902wrz.12
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 01:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2x3xMxrcdbpRrToss2gqh2VZIlpmlWJMJDIo05fHp8=;
        b=VDtSNftmpX8CCvAEQGnpk9lRISu3QAyI5uvN7HKxAZSAHYHm92DIsIZnWWe04VsPwS
         JOv+AbKNRdGlvFQ3SJ5fUNbReZE2hwO+wZcj0/H+eBgTMmXCm9shmteIV5F1rdulkppp
         75JbwQZCr7ooxfEHr/sByT2y3ISvRZ+ajAHfOpKt5eQSx8HoST0ZPDRPUTHuCGi7bCee
         S8J2sk3WqdaAQ9iq9SDG8LXfyxhZvWqAzKWPlnNo+u9c21rZHPY4nYDBMaTM5bhmEtoN
         NkFgDbowm4ZnHl60kvX0JQqTW1IXmv5kkELcYOpo9F1k2y7PQtDdp8hgDsNoxYV8sL1Z
         Rb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2x3xMxrcdbpRrToss2gqh2VZIlpmlWJMJDIo05fHp8=;
        b=HYtouuM4x0c65MyQQlzewTULwvq8Erl6khkMxNfCPVjbagV6rZK9SXyur4A96e33jd
         5/SjFAGQi//wUGQ6KSO034H17QIQ09P6ZsuNP3tbUCaqlfrfitOXeo9nc9nHqh9kwwzS
         xv0g9crSfBHT4/E60Ua+BlrUggbgIRYvcr89+zJdZlNQ+WKSBgBkgIl2ik4UJafJJA+S
         Q/0h6JCFIwhVxS+3sUv98F6f0uw8QP7ewqOzwGJ3+fcJwCnSnTexDImnyZVbxiqD09C6
         L2qBjW2FevbTHhUzAztBE/yp1R80W6H7WR9FoArl58UfoDJoZ95axouvZDwbNZVPOjEg
         yA2A==
X-Gm-Message-State: AFqh2kq/68tAKlwDWCxJiEIHNkSorQ1VMNgIcWzkUYJk4ZZQfiOyDG7h
        cF21fWzX+A5YR+El9y8soDavh0ZmfHozNZxjwo8=
X-Google-Smtp-Source: AMrXdXvFWbfaSZuqZVdUjMzFo+Yztl5XniGiZ5F1jQj1U5jew1G6CjA/r7WguaYIjVQk0vkIS1mzfw==
X-Received: by 2002:adf:f351:0:b0:291:3f93:b7be with SMTP id e17-20020adff351000000b002913f93b7bemr7788484wrp.54.1672738219588;
        Tue, 03 Jan 2023 01:30:19 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l25-20020adfa399000000b002421ed1d8c8sm31068474wrb.103.2023.01.03.01.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:30:18 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:30:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7P1qY8RV2TMOOa+@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
 <Y7Lw1GSGml1E8SXw@nanopsycho>
 <20230102151630.4aeaef00@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102151630.4aeaef00@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 03, 2023 at 12:16:30AM CET, kuba@kernel.org wrote:
>On Mon, 2 Jan 2023 15:57:24 +0100 Jiri Pirko wrote:
>> Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:
>> >Always check under the instance lock whether the devlink instance
>> >is still / already registered.
>> >
>> >This is a no-op for the most part, as the unregistration path currently
>> >waits for all references. On the init path, however, we may temporarily
>> >open up a race with netdev code, if netdevs are registered before the
>> >devlink instance. This is temporary, the next change fixes it, and this
>> >commit has been split out for the ease of review.
>> >
>> >Note that in case of iterating over sub-objects which have their
>> >own lock (regions and line cards) we assume an implicit dependency
>> >between those objects existing and devlink unregistration.
>
>> >diff --git a/net/devlink/basic.c b/net/devlink/basic.c
>> >index 5f33d74eef83..6b18e70a39fd 100644
>> >--- a/net/devlink/basic.c
>> >+++ b/net/devlink/basic.c
>> >@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>> > 		int idx = 0;
>> > 
>> > 		mutex_lock(&devlink->linecards_lock);
>> >+		if (!devl_is_alive(devlink))
>> >+			goto next_devlink;  
>> 
>> Thinking about this a bit more, things would be cleaner if reporters and
>> linecards are converted to rely on instance lock as well. I don't see a
>> good reason for a separate lock in both cases, really.
>
>We had discussion before, I'm pretty sure.
>IIRC you said that mlx4's locking prevents us from using the instance
>lock for regions.

Yeah, let me check it out again. For the linecards, that could be done.
Let me take care of these.


>
>> Also, we could introduce devlinks_xa_for_each_registered_get_lock()
>> iterator that would lock the instance as well right away to avoid
>> this devl_is_alive() dance on multiple places when you iterate devlinks.
>
>That's what I started with, but the ability to factor our the
>unlock/put on error paths made the callback approach much cleaner.
>And after using the callback for all the dumps there's only a couple
>places which would use devlinks_xa_for_each_registered_get_lock().

I see. Okay.


>
>> >@@ -12218,7 +12232,8 @@ void devlink_compat_running_version(struct devlink *devlink,
>> > 		return;
>> > 
>> > 	devl_lock(devlink);  
>> 
>> How about to have a helper, something like devl_lock_alive() (or
>> devl_lock_registered() with the naming scheme I suggest in the other
>> thread)? Then you can do:
>> 
>> 	if (!devl_lock_alive(devlink))
>> 		return;
>> 	__devlink_compat_running_version(devlink, buf, len);
>> 	devl_unlock(devlink);
>
>I guess aesthetic preference.
>
>If I had the cycles I'd make devlink_try_get() return a wrapped type
>
>struct devlink_ref {
>	struct devlink *devlink;
>};
>
>which one would have to pass to devl_lock_from_ref() or some such:
>
>struct devlink *devl_lock_from_ref(struct devlink_ref dref)
>{
>	if (!dref.devlink)
>		return NULL;
>	devl_lock(dref.devlink);
>	if (devl_lock_alive(dref.devlink))
>		return dref.devlink;
>	devl_unlock(dref.devlink);
>	return NULL;
>}
>
>But the number of calls to devl_is_alive() is quite small after all
>the cleanup, so I don't think the extra helpers are justified at this
>point. "Normal coders" should not be exposed to any of the lifetime
>details, not when coding the drivers, not when adding typical devlink
>features/subobjects.

Fair point.

