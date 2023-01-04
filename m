Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF5365D028
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbjADKEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbjADKEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:04:24 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527361EC50
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 02:04:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w1so20290791wrt.8
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 02:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7zIpsKrWNlRxrC2F4/5AH3GK7mnVmd4zCqZ+bpka19Q=;
        b=3zag4DjDY3W3iqvAhb8I09uq6QvJHG0b3inbiTXvcNdDfZjfcca8jSSFYecZIJLOKt
         hMMFDIbRBcSCrDG6PCwlaCgWjKYv60idjkr8mxcks58Io3OdKFHlMtqOpc1XHiL5G1FD
         vmQEPEfoonHE9ddTP0u51Ew2r12rS1dSY1krjIp/AGum1QAQOdk5Zy0WYDVSwzL9F8wY
         NLVoDYTNtN9W6WsaQfTzi3glIHEuxaWk8abglr2btJ2mdkyZxAqurQULh/iifNUWMunj
         WBUY6yjCrDrC0LJ7MfgLJ3YU/APXfg5cG5QeR8L2UnB2kz9cVLrM4IK9UlOwt0vgdgCP
         Q8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zIpsKrWNlRxrC2F4/5AH3GK7mnVmd4zCqZ+bpka19Q=;
        b=wLzwjZSwTMPlZQYsMcnX/F3+k3sJZqk4JookF5MuzJbRSkmtb/VO+rlGJJRH9lQI6r
         dMTk1Inj6PPmbZl836lDVL0c+qfNFjrP2E4Muiv5BuiR4EIGyuzwxsJnLhggpGzZqQpG
         OHqGlyZn/AL4tUYSH3cuwhXZlIx+m5sJimC9pI6LF1CXCf/pN+RvWOYUoUwTqL6wfrQP
         vzps7axEhv94/AFT3CcniG/d4Y3m4lBifdGQwZCY7AYcyIySVP3clLpJPRmjpIB2y90Y
         0zVImTbTsgAxMqy5UknuLAiSIdpLR7ryonRTpfwSVnhMVxyDN7KmwIbNEfubGXI7oLq1
         0twQ==
X-Gm-Message-State: AFqh2koZKujerEHPjDvPdL6XO837Mr1ybuxMJeMuLHzG9IzUAs1XnCZJ
        MhartY69LN7UcecL50N3GeHDiA==
X-Google-Smtp-Source: AMrXdXvxooP+qpExuSbkBxWy9kV8SkmW80By2AoShzzSsudWi3xJMdnS+HgXa3b+8ea+SOXnLkEA6g==
X-Received: by 2002:a05:6000:1c10:b0:25d:9954:3310 with SMTP id ba16-20020a0560001c1000b0025d99543310mr37803585wrb.4.1672826642854;
        Wed, 04 Jan 2023 02:04:02 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g3-20020a5d6983000000b00287da7ee033sm19141276wru.46.2023.01.04.02.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 02:04:02 -0800 (PST)
Date:   Wed, 4 Jan 2023 11:04:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 05/14] devlink: use an explicit structure for
 dump context
Message-ID: <Y7VPES6vqZWEMqwM@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-6-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:27AM CET, kuba@kernel.org wrote:
>Create a dump context structure instead of using cb->args
>as an unsigned long array. This is a pure conversion which
>is intended to be as much of a noop as possible.
>Subsequent changes will use this to simplify the code.
>
>The two non-trivial parts are:
> - devlink_nl_cmd_health_reporter_dump_get_dumpit() checks args[0]
>   to see if devlink_fmsg_dumpit() has already been called (whether
>   this is the first msg), but doesn't use the exact value, so we
>   can drop the local variable there already
> - devlink_nl_cmd_region_read_dumpit() uses args[0] for address
>   but we'll use args[1] now, shouldn't matter

I don't follow this. Where do you use args[1]? you mean
dump->start_offset? If yes, it does not matter at all and I think
mentioning that only confuses reader (as it did for me).


>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/devl_internal.h | 23 +++++++++
> net/devlink/leftover.c      | 98 ++++++++++++++++++++++---------------
> 2 files changed, 81 insertions(+), 40 deletions(-)
>
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index bc7df9b0f775..91059311f18d 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -107,6 +107,21 @@ enum devlink_multicast_groups {
> 	DEVLINK_MCGRP_CONFIG,
> };
> 
>+/* state held across netlink dumps */
>+struct devlink_nl_dump_state {
>+	int idx;
>+	union {
>+		/* DEVLINK_CMD_REGION_READ */
>+		struct {
>+			u64 start_offset;
>+		};
>+		/* DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET */
>+		struct {
>+			u64 dump_ts;
>+		};
>+	};
>+};
>+
> extern const struct genl_small_ops devlink_nl_ops[56];
> 
> struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
>@@ -114,6 +129,14 @@ struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
> void devlink_notify_unregister(struct devlink *devlink);
> void devlink_notify_register(struct devlink *devlink);
> 
>+static inline struct devlink_nl_dump_state *
>+devl_dump_state(struct netlink_callback *cb)

What is the convesion you established again regarding "devl_" and
"devlink_" prefixes? I don't find it written down anywhere and honestly
it confuses me a bit.



>+{
>+	NL_ASSET_DUMP_CTX_FITS(struct devlink_nl_dump_state);
>+
>+	return (struct devlink_nl_dump_state *)cb->ctx;
>+}
>+
> /* Ports */
> int devlink_port_netdevice_event(struct notifier_block *nb,
> 				 unsigned long event, void *ptr);
>diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>index e01ba7999b91..bcc930b7cfcf 100644
>--- a/net/devlink/leftover.c
>+++ b/net/devlink/leftover.c
>@@ -1222,9 +1222,10 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
> static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
> 					  struct netlink_callback *cb)
> {
>+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);

Could this be named "state" or "dump_state"? "dump" is not what it is.



> 	struct devlink_rate *devlink_rate;
> 	struct devlink *devlink;
>-	int start = cb->args[0];
>+	int start = dump->idx;
> 	unsigned long index;
> 	int idx = 0;
> 	int err = 0;

[..]

