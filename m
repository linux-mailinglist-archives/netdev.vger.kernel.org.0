Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3765FD9A5
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJMMzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJMMzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:55:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912C3CBFEA
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:55:45 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ot12so3752595ejb.1
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMWOE/B2P528ciGVVHpF2amlrABhWjrV37Br7IC9ksk=;
        b=cKCXip4zc9PiggRR3AdqCax7sW5IHLSGvV30rOA71jlkJs9vuYvZZ8dZkocXrBIFyr
         1RYoUN4Yj5HGkDG3P8jUtXUp46givGH3xcGmwpHucDPV5UAnQEepo0X39GUVO7eME86l
         rh+0MFQQegvv9cJRR/vaauZJZ+kHgaj4S5mucykfYp6sK85Z82VPXAXOuxt+PvKODAq7
         sJ7G5EaxgWsNIhPNiP69OsFr1vPGkTqqgg+Fj0bzC5yyHD7mKQjny3l0eZAY4fS34Vwz
         /6Py6zYgzRU1/G2olSKPAxRUPD6hPq90GLQ5iXOG2rRo524mPHgi/fydP0qdHaTfzJnn
         6uLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMWOE/B2P528ciGVVHpF2amlrABhWjrV37Br7IC9ksk=;
        b=J1eGi4E2Q8wxHgFPoPAsGHrgU+/MBrqCInAo2RY69IOemQa1QnQ3KK5le8Z+qD/cym
         sM/07Lc03UxlBrkiySl90TzhHu5WLZwgsdzdmRFoQsUNncTuT1vZFbSxgdai1gEApf8X
         GqNw/Cx3PI+nk/pQAjpjJCsmMgutgzSMMfUIqGMzvQCfWpcrik5fvq1KXAN7iDHRydj6
         hnnlh3RG5dJpEzEAGs28tz0Pmrp3Ik+cHZhxO7G8ootbBic9dNxowxTZzMtcooR9x1Aj
         mcIVso6wSiYt2VcviDArWjS0WmfPv+cOTyr0mV9H8p4p0f54IRA4VDaoLWL+6qtDvGD9
         ahLg==
X-Gm-Message-State: ACrzQf3/FlV1Ra9nsjUl4btoScK0N58YHDE/jd8/9A9ufSnU0BAUQgLL
        ZIuPNh86vrwKjU/YoKDtgny5N9ERm0KNHbel
X-Google-Smtp-Source: AMsMyM5k8j6eZi+6ecU3DDlcqjkdxwbUuQFPElCB6hpEMIlRPli+0QZuSSyrdoG+dEzDXHmzdK5UaQ==
X-Received: by 2002:a17:907:80a:b0:783:2585:5d73 with SMTP id wv10-20020a170907080a00b0078325855d73mr26106714ejb.642.1665665743975;
        Thu, 13 Oct 2022 05:55:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b18-20020a17090630d200b0073dbaeb50f6sm2959177ejb.169.2022.10.13.05.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 05:55:43 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:55:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     ecree@xilinx.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        johannes@sipsolutions.net, marcelo.leitner@gmail.com,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <Y0gKzgmWSgw/+4Oc@nanopsycho>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
 <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 07, 2022 at 03:25:12PM CEST, ecree@xilinx.com wrote:
>From: Edward Cree <ecree.xilinx@gmail.com>
>
>Include an 80-byte buffer in struct netlink_ext_ack that can be used
> for scnprintf()ed messages.  This does mean that the resulting string
> can't be enumerated, translated etc. in the way NL_SET_ERR_MSG() was
> designed to allow.
>
>Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
>---
> include/linux/netlink.h | 21 +++++++++++++++++++--
> 1 file changed, 19 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/netlink.h b/include/linux/netlink.h
>index d51e041d2242..bfab9dbd64fa 100644
>--- a/include/linux/netlink.h
>+++ b/include/linux/netlink.h
>@@ -64,6 +64,7 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
> 
> /* this can be increased when necessary - don't expose to userland */
> #define NETLINK_MAX_COOKIE_LEN	20
>+#define NETLINK_MAX_FMTMSG_LEN	80
> 
> /**
>  * struct netlink_ext_ack - netlink extended ACK report struct
>@@ -75,6 +76,8 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>  * @miss_nest: nest missing an attribute (%NULL if missing top level attr)
>  * @cookie: cookie data to return to userspace (for success)
>  * @cookie_len: actual cookie data length
>+ * @_msg_buf: output buffer for formatted message strings - don't access
>+ *	directly, use %NL_SET_ERR_MSG_FMT
>  */
> struct netlink_ext_ack {
> 	const char *_msg;
>@@ -84,13 +87,13 @@ struct netlink_ext_ack {
> 	u16 miss_type;
> 	u8 cookie[NETLINK_MAX_COOKIE_LEN];
> 	u8 cookie_len;
>+	char _msg_buf[NETLINK_MAX_FMTMSG_LEN];
> };
> 
> /* Always use this macro, this allows later putting the
>  * message into a separate section or such for things
>  * like translation or listing all possible messages.
>- * Currently string formatting is not supported (due
>- * to the lack of an output buffer.)
>+ * If string formatting is needed use NL_SET_ERR_MSG_FMT.
>  */
> #define NL_SET_ERR_MSG(extack, msg) do {		\
> 	static const char __msg[] = msg;		\
>@@ -102,9 +105,23 @@ struct netlink_ext_ack {
> 		__extack->_msg = __msg;			\
> } while (0)
> 
>+#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
>+	struct netlink_ext_ack *__extack = (extack);		\
>+								\
>+	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
>+		  (fmt), ##args);				\
>+	do_trace_netlink_extack(__extack->_msg_buf);		\
>+								\
>+	if (__extack)						\
>+		__extack->_msg = __extack->_msg_buf;		\
>+} while (0)
>+
> #define NL_SET_ERR_MSG_MOD(extack, msg)			\
> 	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
> 
>+#define NL_SET_ERR_MSG_FMT_MOD(extack, fmt, args...)	\

I wonder, wouldn't it be better to just have NL_SET_ERR_MSG_MOD which
accepts format string and that's it. I understand there is an extra
overhead for the messages that don't use formatting, but do we care?
This is no fastpath and usually happens only seldom. The API towards
the driver would be more simple.

I like this a lot!


>+	NL_SET_ERR_MSG_FMT((extack), KBUILD_MODNAME ": " fmt, ##args)
>+
> #define NL_SET_BAD_ATTR_POLICY(extack, attr, pol) do {	\
> 	if ((extack)) {					\
> 		(extack)->bad_attr = (attr);		\
