Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C2165D56B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbjADOTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbjADOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:19:00 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDDE17434
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 06:18:58 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso20016013wms.5
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 06:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aBC+vzMix1vwzgMala+1EFIy7Z/TD/5lo9mag2BqUo8=;
        b=ljkWTKIuu7aD9RVdV0HooIWjQMakPXWxeIVk7T9Oq4iXF7keGxTpRZhKVSMV/UldXI
         lJpyCw/rE3c0BgvRsgrEy8JsAnrrC+rE2mz27v4wqhI4zyyD1Kr8c5cZtrae2DM9/3tc
         T+vp3uhgya7ipPZUSOWBsRBx4+QQWJx66IHuOfHPFVS6akhEHnhMjXvKJd4vzUiZtiSw
         2A1sfEtGUTva6DOhzy8aM4vvQZmnBRYWu7Pt40lsWFFv96Bfi3vUibzdBMDMgPOAHdjn
         2i4dkYMe7Xu0+hDlRWIZtjn9hb8LLNdsy09xykTdWlZIUwRLpmKwzKYx+O0JXp3atVnF
         lnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBC+vzMix1vwzgMala+1EFIy7Z/TD/5lo9mag2BqUo8=;
        b=XdDEQdFhG7h/ZXQ1MYdP3faigU/yJmuEEZ5P1BirRN+eQ8HGTykJprI8gDudjUklk7
         MMqzqtHRdtCxvrQetaOdx3mfch1/aAVbM9mL4bfKMXwNAjftjVaHLtv5irdxMi84hmr/
         MWWFC4MjznYGgnCf70DfP3JUxdrq9mTF1krvLWgDwaw7SybGgztJhwOms6wvpAd9g3pN
         6xqk1LaCEgM0nbefl9YtYp+C6OOw864H9lPvvFjVVcK5wr/7h61K1SMhpprBDuk5C3M8
         z424DuNuLDOPW7Me1yYd/HH2hxwRAWQD9szvXNC2tlLl4IGMSy4aBVgZ8YFwfAQy8bTx
         HXQA==
X-Gm-Message-State: AFqh2krk9hlBctApPnEVDgFUwF3lNz0kjtWln88+GazTzgGwe14Bl51p
        vPxtImnQDIIHNE+WX0WPKjynbg==
X-Google-Smtp-Source: AMrXdXvNAkBby7YLw6WlrFLxUhNnjYhH4LZeU9r5aZjCMlpIg75j9G2BamNODryJLbCtmxAW8yBKLA==
X-Received: by 2002:a05:600c:246:b0:3d3:3deb:d91f with SMTP id 6-20020a05600c024600b003d33debd91fmr36180422wmj.5.1672841936991;
        Wed, 04 Jan 2023 06:18:56 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g7-20020a05600c4ec700b003d978f8f255sm49663029wmq.27.2023.01.04.06.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:18:55 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:18:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 09/14] devlink: restart dump based on devlink
 instance ids (simple)
Message-ID: <Y7WKzkKe69TDfKEM@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-10-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104041636.226398-10-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 04, 2023 at 05:16:31AM CET, kuba@kernel.org wrote:
>xarray gives each devlink instance an id and allows us to restart
>walk based on that id quite neatly. This is nice both from the
>perspective of code brevity and from the stability of the dump
>(devlink instances disappearing from before the resumption point
>will not cause inconsistent dumps).
>
>This patch takes care of simple cases where dump->idx counts
>devlink instances only.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/core.c          |  2 +-
> net/devlink/devl_internal.h | 14 ++++++++++++++
> net/devlink/leftover.c      | 36 ++++++++----------------------------
> 3 files changed, 23 insertions(+), 29 deletions(-)
>
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index 3a99bf84632e..371d6821315d 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -91,7 +91,7 @@ void devlink_put(struct devlink *devlink)
> 		call_rcu(&devlink->rcu, __devlink_put_rcu);
> }
> 
>-static struct devlink *
>+struct devlink *
> devlinks_xa_find_get(struct net *net, unsigned long *indexp,
> 		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
> 					  unsigned long, xa_mark_t))
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index ee98f3bdcd33..a567ff77601d 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -87,6 +87,10 @@ extern struct genl_family devlink_nl_family;
> 	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
> 
> struct devlink *
>+devlinks_xa_find_get(struct net *net, unsigned long *indexp,
>+		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
>+					  unsigned long, xa_mark_t));
>+struct devlink *
> devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
> struct devlink *
> devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
>@@ -104,6 +108,7 @@ enum devlink_multicast_groups {
> 
> /* state held across netlink dumps */
> struct devlink_nl_dump_state {
>+	unsigned long instance;
> 	int idx;
> 	union {
> 		/* DEVLINK_CMD_REGION_READ */
>@@ -117,6 +122,15 @@ struct devlink_nl_dump_state {
> 	};
> };
> 
>+/* Iterate over devlink pointers which were possible to get reference to.
>+ * devlink_put() needs to be called for each iterated devlink pointer
>+ * in loop body in order to release the reference.
>+ */
>+#define devlink_dump_for_each_instance_get(msg, dump, devlink)		\
>+	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\

I undestand that the "dump" is zeroed at the beginning of dumpit call,
however, if you call this helper multiple times, the second iteration
would't not work.

Perhaps better to initialize instance=0 at the beginning of the loop to
make this helper calls behaviour independent on context.


>+					       &dump->instance, xa_find)); \
>+	     dump->instance++)
>+
> extern const struct genl_small_ops devlink_nl_ops[56];
> 
> struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
>diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
>index e3cfb64990b4..0f24b321b0bb 100644
>--- a/net/devlink/leftover.c
>+++ b/net/devlink/leftover.c
>@@ -1319,17 +1319,9 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
> {
> 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
> 	struct devlink *devlink;
>-	unsigned long index;
>-	int idx = 0;
> 	int err;
> 
>-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
>-		if (idx < dump->idx) {
>-			idx++;
>-			devlink_put(devlink);
>-			continue;
>-		}
>-
>+	devlink_dump_for_each_instance_get(msg, dump, devlink) {

The name suggests on the first sight that you are iterating some dump,
which is slightly confusing. Perhaps better to have
"devlinks_xa_for_each_" in the prefix somehow?

	devlinks_xa_for_each_registered_get_dumping()

I know it is long :)


> 		devl_lock(devlink);
> 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
> 				      NETLINK_CB(cb->skb).portid,
>@@ -1339,10 +1331,8 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
> 
> 		if (err)
> 			goto out;
>-		idx++;
> 	}
> out:
>-	dump->idx = idx;
> 	return msg->len;
> }
> 
>@@ -4872,13 +4862,13 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
> {
> 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
> 	struct devlink *devlink;
>-	unsigned long index;
>-	int idx = 0;
> 	int err = 0;
> 
>-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
>-		if (idx < dump->idx || !devlink->ops->selftest_check)
>-			goto inc;
>+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
>+		if (!devlink->ops->selftest_check) {
>+			devlink_put(devlink);
>+			continue;
>+		}
> 
> 		devl_lock(devlink);
> 		err = devlink_nl_selftests_fill(msg, devlink,
>@@ -4890,15 +4880,13 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
> 			devlink_put(devlink);
> 			break;
> 		}
>-inc:
>-		idx++;
>+
> 		devlink_put(devlink);
> 	}
> 
> 	if (err != -EMSGSIZE)
> 		return err;
> 
>-	dump->idx = idx;
> 	return msg->len;
> }
> 
>@@ -6747,14 +6735,9 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
> {
> 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
> 	struct devlink *devlink;
>-	unsigned long index;
>-	int idx = 0;
> 	int err = 0;
> 
>-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
>-		if (idx < dump->idx)
>-			goto inc;
>-
>+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
> 		devl_lock(devlink);
> 		err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
> 					   NETLINK_CB(cb->skb).portid,
>@@ -6767,15 +6750,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
> 			devlink_put(devlink);
> 			break;
> 		}
>-inc:
>-		idx++;
> 		devlink_put(devlink);
> 	}
> 
> 	if (err != -EMSGSIZE)
> 		return err;
> 
>-	dump->idx = idx;
> 	return msg->len;
> }
> 
>-- 
>2.38.1
>
