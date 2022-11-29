Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68B863BB3A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiK2IHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiK2IHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:07:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2034B55AB1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:07:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d18so1858186pls.4
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qMU6Z/F2GilMgVZv48JQwIuQ+lonm0JHu17r+Jj0mj8=;
        b=nHD/LYRjqHoRv+yKLi/LgO6Y41jxbBSjhs9EusArSGlpdYq5ZwwB2J+CEX63iGGfrm
         AIvYn3RyugiStW3c6+peuVLLS8AvjGbA8uU7LTLI8SaRrGgfXohwdTwfQF/XMZRURhV+
         BusRkmUKtSFoOhH4mAtheg+m/ES3DspRfFkJg9Ooe880ypUCRIvmX5ETLMxUjs1uYY/w
         3dJ3Zu/r3JjEz5MZi+TUjoqXDx2M00y08AD7FW8xPKDnJGrsHFN8n+LnIeMU2SMlyuwg
         ucrFsDz6Hk9JPT5diLeoyYnOoYhDJo054hXQDmIu0yhMttEsxMpaZ8OxYjgM9y5Vn7gY
         KmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMU6Z/F2GilMgVZv48JQwIuQ+lonm0JHu17r+Jj0mj8=;
        b=tLL8qaTy+h16zAN8u39NNhLE0Pnu99j3L/55l7HhwssWGE8qxx7l3YaU3tvl+0lWup
         vTFNpFTIn2L88awYHXs69Jm/aP3u+KaviNr0GGaiF6u0jOTWmVaF2Vrn4Yh4oSxrr7RB
         KXsBpAyv+LaZrMkTCLl8y05uxVTHANBq/e5ErolImdmcrZ7mdYVyzuXq0oJEfRjmGHOe
         qbVjQJTKTJghKTwPrNAnb4JCo0tNG1FhNEsWgzyoSlYix23pwBTnWqw5kgS5jrUuRLA4
         JaInKi0ZPuF3UWLzEpXo3xxWz1bi9AbB1t6NJzQ0GnYhkAtA2EWdoTgYiLoXr46zZ62e
         MCkg==
X-Gm-Message-State: ANoB5pla/IemFrgtEMQSQ2v9+v3TixZV+/b+wo9Uo0lLerbHeKpA34km
        aTqlQXybnfqdP74dJSWUJvw=
X-Google-Smtp-Source: AA0mqf7IGpvWtqEgdfCNBF2o9idnNtpBSY1weIHLwoIFjww2uetlzfb4YEBbhsGXs06yZ+lKFFE/fg==
X-Received: by 2002:a17:902:a616:b0:189:46b1:fe0b with SMTP id u22-20020a170902a61600b0018946b1fe0bmr29718654plq.117.1669709230552;
        Tue, 29 Nov 2022 00:07:10 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b17-20020a170902ed1100b00186fa988a13sm10176063pld.166.2022.11.29.00.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:07:09 -0800 (PST)
Date:   Tue, 29 Nov 2022 16:07:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y4W9qEHzg5h9n/od@Laptop-X1>
References: <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
 <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
 <20221110092709.06859da9@kernel.org>
 <Y3MCaaHoMeG7crg5@Laptop-X1>
 <20221114205143.717fd03f@kernel.org>
 <Y3OJucOnuGrBvwYM@Laptop-X1>
 <CAM0EoMmiGBb1B=mYyG1FEvX7RRh+UvTFwguuEy9UwBPg2Jd0KA@mail.gmail.com>
 <Y3Oa1NRF9frEiiZ3@Laptop-X1>
 <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMk_LdcSLAeQ8kLTaWNDXFe7HgBcOxZpDPtk68+TdER-Zg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On Tue, Nov 15, 2022 at 11:26:54AM -0500, Jamal Hadi Salim wrote:
> How were you thinking of storing the extack info into the message?
> Note: I wouldnt touch netlink_ack() - maybe write a separate helper for events.

It looks a separate helper is just duplicated codes. Send the notify from
the netlink_ack() is much easy. e.g.

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a662e8a5ff84..79a1586e8eb0 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2463,6 +2463,33 @@ netlink_ack_tlv_fill(struct sk_buff *in_skb, struct sk_buff *skb,
 				    (u8 *)extack->miss_nest - (u8 *)nlh));
 }
 
+/**
+ * get_nlgroup - get netlink group id based on nlmsg_type
+ * @nlmsg_type: netlink message type
+ *
+ * Right now, we only support net tc sched. Please add other types if the
+ * sub maintainers feel needed.
+ */
+unsigned int get_nlgroup(__u16 nlmsg_type)
+{
+	switch (nlmsg_type) {
+	case RTM_NEWTFILTER:
+	case RTM_DELTFILTER:
+	case RTM_NEWCHAIN:
+	case RTM_DELCHAIN:
+	case RTM_NEWTCLASS:
+	case RTM_DELTCLASS:
+	case RTM_NEWQDISC:
+	case RTM_DELQDISC:
+	case RTM_GETACTION:
+	case RTM_NEWACTION:
+	case RTM_DELACTION:
+		return RTNLGRP_TC;
+	}
+
+	return 0;
+}
+
 void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		 const struct netlink_ext_ack *extack)
 {
@@ -2471,7 +2498,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	struct nlmsgerr *errmsg;
 	size_t payload = sizeof(*errmsg);
 	struct netlink_sock *nlk = nlk_sk(NETLINK_CB(in_skb).sk);
-	unsigned int flags = 0;
+	unsigned int group, flags = 0;
 	size_t tlvlen;
 
 	/* Error messages get the original request appened, unless the user
@@ -2507,7 +2534,9 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	nlmsg_end(skb, rep);
 
-	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
+	group = get_nlgroup(nlh->nlmsg_type);
+	/* Multicast the error message if we can get group if from nlmsg_type */
+	nlmsg_notify(in_skb->sk, skb, NETLINK_CB(in_skb).portid, group, 1, GFP_KERNEL);
 }
 EXPORT_SYMBOL(netlink_ack);
 

What do you think?

Thanks
Hangbin
