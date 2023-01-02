Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE265B3E6
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbjABPMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjABPMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:12:08 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0C02AB
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 07:12:05 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ja17so20511601wmb.3
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 07:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JCErQ8dhucjzTuAPrx7jisgvJBoQW3plh3cEPHh8Q3Q=;
        b=25/Dywu1vz7CpDqZgchF4U86KZcWOc8P+25rD781AstDwR0HN0Y0aXpUCHgtE/oTFY
         g6mhethredxaUZxhTcPh14HE7rCFOrOght0y5ZkvzsmWXf9wUiDIHOgZsJ7YK7JUty/w
         89hoGW6m9ABJRMU4NyivHydHdoZ01tHrw+yEC2gt2hJyd43D8oIHWbR6P2Dff9UZElqa
         SK/zHnKqVtPkkcPANiIoZtrTTRk1RYGVFkM8f+ErnBfE+obugdGqG5v1mQtgnKKVExKU
         8QvIw87jjUSVAq5srNrE/2gQ7ulodF27+5hO/tbMCq9LJi8mfouHZuKX/jRC5xrAkaoN
         c2nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCErQ8dhucjzTuAPrx7jisgvJBoQW3plh3cEPHh8Q3Q=;
        b=0NTABH8l7OL+f+CXwJiiIZGu+Qgp/RREjaTzkagNdukvn9P986fdx6wpZEEPIIPrIB
         9rzKSYvYw1QApAoT7QMwE0I9dAmnQJISeR6UYIo5oDZTjzkPsjqR+X4dRgOqzJm7zDlk
         ZdOXFeZe3/aDycFTW+Uxl+rOvNqMLDJKJn5rhuptQmHEu08NdoAasxolMgIA1RgYwSxJ
         Y6ttsAD+10q5taPSXT4bsFXqTr72CzwLvtz1f9KFr4BB9dk94b9Z4B5DhLQJM0WmKPse
         fAUQ0X02KEW0Q9QANDdTCkMklWU6hEGJoJ8Byy6P/rcMwBaO9ak4ksYTtaUV+TTq46bs
         6Ksg==
X-Gm-Message-State: AFqh2kq3AgLl1GQ0IE/2x/nOJe7PXbqUuH7+6CcM9VwE/x83m/eNfSny
        4UT15VbXuiIoqOmr2DXX9J0swQ==
X-Google-Smtp-Source: AMrXdXvpgyn8jv6VKUtJgBEzJTuldxNpkTNRbERwGW1p8klRdKk0H8CJD10eTqzu1HocG6IQGRMv/g==
X-Received: by 2002:a7b:c3d2:0:b0:3c6:e62e:2e72 with SMTP id t18-20020a7bc3d2000000b003c6e62e2e72mr29493388wmj.13.1672672324284;
        Mon, 02 Jan 2023 07:12:04 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m185-20020a1c26c2000000b003c6f1732f65sm43085293wmm.38.2023.01.02.07.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 07:12:03 -0800 (PST)
Date:   Mon, 2 Jan 2023 16:12:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 04/10] devlink: always check if the devlink
 instance is registered
Message-ID: <Y7L0Qu/fy2QbTFpw@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-5-kuba@kernel.org>
 <Y7Lw1GSGml1E8SXw@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7Lw1GSGml1E8SXw@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 02, 2023 at 03:57:24PM CET, jiri@resnulli.us wrote:
>Sat, Dec 17, 2022 at 02:19:47AM CET, kuba@kernel.org wrote:
>>Always check under the instance lock whether the devlink instance
>>is still / already registered.
>>
>>This is a no-op for the most part, as the unregistration path currently
>>waits for all references. On the init path, however, we may temporarily
>>open up a race with netdev code, if netdevs are registered before the
>>devlink instance. This is temporary, the next change fixes it, and this
>>commit has been split out for the ease of review.
>>
>>Note that in case of iterating over sub-objects which have their
>>own lock (regions and line cards) we assume an implicit dependency
>>between those objects existing and devlink unregistration.
>>
>>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>---
>> include/net/devlink.h |  1 +
>> net/devlink/basic.c   | 35 +++++++++++++++++++++++++++++------
>> net/devlink/core.c    | 25 +++++++++++++++++++++----
>> net/devlink/netlink.c | 10 ++++++++--
>> 4 files changed, 59 insertions(+), 12 deletions(-)
>>
>>diff --git a/include/net/devlink.h b/include/net/devlink.h
>>index 6a2e4f21779f..36e013d3aa52 100644
>>--- a/include/net/devlink.h
>>+++ b/include/net/devlink.h
>>@@ -1626,6 +1626,7 @@ struct device *devlink_to_dev(const struct devlink *devlink);
>> void devl_lock(struct devlink *devlink);
>> int devl_trylock(struct devlink *devlink);
>> void devl_unlock(struct devlink *devlink);
>>+bool devl_is_alive(struct devlink *devlink);
>> void devl_assert_locked(struct devlink *devlink);
>> bool devl_lock_is_held(struct devlink *devlink);
>> 
>>diff --git a/net/devlink/basic.c b/net/devlink/basic.c
>>index 5f33d74eef83..6b18e70a39fd 100644
>>--- a/net/devlink/basic.c
>>+++ b/net/devlink/basic.c
>>@@ -2130,6 +2130,9 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>> 		int idx = 0;
>> 
>> 		mutex_lock(&devlink->linecards_lock);
>>+		if (!devl_is_alive(devlink))
>>+			goto next_devlink;
>
>
>Thinking about this a bit more, things would be cleaner if reporters and
>linecards are converted to rely on instance lock as well. I don't see a
>good reason for a separate lock in both cases, really.
>
>Also, we could introduce devlinks_xa_for_each_registered_get_lock()
>iterator that would lock the instance as well right away to avoid
>this devl_is_alive() dance on multiple places when you iterate devlinks.

devlinks_xa_find_get_locked()
would do the check&lock at the end.



>
>
>>+
>> 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
>> 			if (idx < dump->idx) {
>> 				idx++;

[...]
