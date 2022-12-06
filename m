Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228F16444AD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiLFNff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiLFNfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:35:30 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7C525EB2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 05:35:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d1so23447997wrs.12
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 05:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9xwVOTAYpGb0BgYtRUwe5NfJ2iUdS8LM9rIfOZm+pk=;
        b=LTfmUOoXz31VqYHf1vqOug6OF5ojsYHK8Qj0G0E4jV7muimMdKSjk4odCvGzacYUSo
         bR+0JTH8/4SV/p0hRkcR+PgDd64tDycnvStl1C5ruKOtfsm1SPrPHtl7oDcyGcxMEatV
         RDiSa6mUCRzuqkF1NqqKgSUk4UWz70ktip22SSfdcazhM1hRfvso5GNNXpLDvWYABSRa
         oKoYn+g3E2rOctJ2TVK5JfVEtFIeespVWkKWgAJLXYuOJ4/wwFBtyzphUzDIXy6klX1O
         lJrpOnmqOyLJnlClChslM5If120Q9ky07q8HYLL+YKN/JCwPdGc3mr1yzbKpPSBwK8Yz
         dtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9xwVOTAYpGb0BgYtRUwe5NfJ2iUdS8LM9rIfOZm+pk=;
        b=IwC7LlWOVbBqYsYyc11iqlPM7fzDbxeQCBHC2CDZqtk3GmMzcCRTZPrpms8fstR6Ch
         HCh16J2GCTlEbUuTw5Tb3pngPKOHYJBP61cXQvwO8jabR9zlG9xwBDu4Jkq+iHxxSLG0
         JMpoNZu/4SqmEUDofFIBk0sWHZPte65uxdfDsUhEuwHHOQmyeZpMQnb05X+kG9Ndtkpm
         H1dUbeid+g13R78QG3kailFrEDfwfc7eZiHt3JOs0aaOF++F6quELoA6TWBkKeoqBHya
         WpWRdQbA8gaSfYZIbhai0B3QY3prGIyjX0QKUPTQ3OmV54VZM5T2JRtauu1SXQh3nQY0
         Fhtg==
X-Gm-Message-State: ANoB5pklMpcPEt6x1a4sfLHb8IJ3MG2Z31vcIqr+9mR4xBCK4PfLKU8g
        irYDn2ZO0X1LrPAgdl+HnuJMbg==
X-Google-Smtp-Source: AA0mqf7oca2bYxnqcQHEBTMsP6PiDTE558RTGrdoaRf2atejx4TyBT6FwDCSRYsiqKINcCdioOJPXg==
X-Received: by 2002:a5d:4344:0:b0:22e:3430:475d with SMTP id u4-20020a5d4344000000b0022e3430475dmr53828566wrr.65.1670333725389;
        Tue, 06 Dec 2022 05:35:25 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g13-20020a5d554d000000b002365cd93d05sm16781071wrw.102.2022.12.06.05.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:35:24 -0800 (PST)
Date:   Tue, 6 Dec 2022 14:35:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Subject: Re: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD
 in the netlink layer
Message-ID: <Y49FGzwBdyC/xHxH@nanopsycho>
References: <20221206085757.5816-1-ehakim@nvidia.com>
 <Y48IVReEUBmQza81@nanopsycho>
 <IA1PR12MB6353D358E112EE09C4DD770CAB1B9@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA1PR12MB6353D358E112EE09C4DD770CAB1B9@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 01:31:54PM CET, ehakim@nvidia.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: Tuesday, 6 December 2022 11:16
>> To: Emeel Hakim <ehakim@nvidia.com>
>> Cc: linux-kernel@vger.kernel.org; Raed Salem <raeds@nvidia.com>;
>> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>> pabeni@redhat.com; netdev@vger.kernel.org; sd@queasysnail.net
>> Subject: Re: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD
>> in the netlink layer
>> 
>> External email: Use caution opening links or attachments
>> 
>> 
>> Tue, Dec 06, 2022 at 09:57:57AM CET, ehakim@nvidia.com wrote:
>> >From: Emeel Hakim <ehakim@nvidia.com>
>> >
>> >This adds support for configuring Macsec offload through the
>> 
>> Tell the codebase what to do. Be imperative in your patch descriptions so it is clear
>> what are the intensions of the patch.
>
>Ack
>
>> 
>> 
>> >netlink layer by:
>> >- Considering IFLA_MACSEC_OFFLOAD in macsec_fill_info.
>> >- Handling IFLA_MACSEC_OFFLOAD in macsec_changelink.
>> >- Adding IFLA_MACSEC_OFFLOAD to the netlink policy.
>> >- Adjusting macsec_get_size.
>> 
>> 4 patches then?
>
>Ack, I will change the commit message to be imperative and will replace the list with a good description.
>I still believe it should be a one patch since splitting this could break a bisect process.

Well, when you split, you have to make sure you don't break bisection,
always. Please try to figure that out.


>
>> I mean really, not a macsec person, but I should be able to follow what are your
>> intensions looking and description&code right away.
>> 
>> >
>> >The handling in macsec_changlink is similar to
>> 
>> s/macsec_changlink/macsec_changelink/
>
>Ack
>
>> >macsec_upd_offload.
>> >Update macsec_upd_offload to use a common helper function to avoid
>> >duplication.
>> >
>> >Example for setting offload for a macsec device
>> >    ip link set macsec0 type macsec offload mac
>> >
>> >Reviewed-by: Raed Salem <raeds@nvidia.com>
>> >Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
>> >---
>> >V1 -> V2: Add common helper to avoid duplicating code
>> >drivers/net/macsec.c | 114 ++++++++++++++++++++++++++++---------------
>> > 1 file changed, 74 insertions(+), 40 deletions(-)
>> >
>> >diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c index
>> >d73b9d535b7a..afd6ff47ba56 100644
>> >--- a/drivers/net/macsec.c
>> >+++ b/drivers/net/macsec.c
>> >@@ -2583,16 +2583,45 @@ static bool macsec_is_configured(struct macsec_dev
>> *macsec)
>> >       return false;
>> > }
>> >
>> >+static int macsec_update_offload(struct macsec_dev *macsec, enum
>> >+macsec_offload offload) {
>> >+      enum macsec_offload prev_offload;
>> >+      const struct macsec_ops *ops;
>> >+      struct macsec_context ctx;
>> >+      int ret = 0;
>> >+
>> >+      prev_offload = macsec->offload;
>> >+
>> >+      /* Check if the device already has rules configured: we do not support
>> >+       * rules migration.
>> >+       */
>> >+      if (macsec_is_configured(macsec))
>> >+              return -EBUSY;
>> >+
>> >+      ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload :
>> offload,
>> >+                             macsec, &ctx);
>> >+      if (!ops)
>> >+              return -EOPNOTSUPP;
>> >+
>> >+      macsec->offload = offload;
>> >+
>> >+      ctx.secy = &macsec->secy;
>> >+      ret = (offload == MACSEC_OFFLOAD_OFF) ? macsec_offload(ops-
>> >mdo_del_secy, &ctx) :
>> >+                    macsec_offload(ops->mdo_add_secy, &ctx);
>> >+
>> >+      if (ret)
>> >+              macsec->offload = prev_offload;
>> >+
>> >+      return ret;
>> >+}
>> >+
>> > static int macsec_upd_offload(struct sk_buff *skb, struct genl_info
>> >*info)  {
>> >       struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
>> >-      enum macsec_offload offload, prev_offload;
>> >-      int (*func)(struct macsec_context *ctx);
>> >       struct nlattr **attrs = info->attrs;
>> >-      struct net_device *dev;
>> >-      const struct macsec_ops *ops;
>> >-      struct macsec_context ctx;
>> >+      enum macsec_offload offload;
>> >       struct macsec_dev *macsec;
>> >+      struct net_device *dev;
>> >       int ret;
>> >
>> >       if (!attrs[MACSEC_ATTR_IFINDEX]) @@ -2629,39 +2658,7 @@ static
>> >int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
>> >
>> >       rtnl_lock();
>> >
>> >-      prev_offload = macsec->offload;
>> >-      macsec->offload = offload;
>> >-
>> >-      /* Check if the device already has rules configured: we do not support
>> >-       * rules migration.
>> >-       */
>> >-      if (macsec_is_configured(macsec)) {
>> >-              ret = -EBUSY;
>> >-              goto rollback;
>> >-      }
>> >-
>> >-      ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload :
>> offload,
>> >-                             macsec, &ctx);
>> >-      if (!ops) {
>> >-              ret = -EOPNOTSUPP;
>> >-              goto rollback;
>> >-      }
>> >-
>> >-      if (prev_offload == MACSEC_OFFLOAD_OFF)
>> >-              func = ops->mdo_add_secy;
>> >-      else
>> >-              func = ops->mdo_del_secy;
>> >-
>> >-      ctx.secy = &macsec->secy;
>> >-      ret = macsec_offload(func, &ctx);
>> >-      if (ret)
>> >-              goto rollback;
>> >-
>> >-      rtnl_unlock();
>> >-      return 0;
>> >-
>> >-rollback:
>> >-      macsec->offload = prev_offload;
>> >+      ret = macsec_update_offload(macsec, offload);
>> >
>> >       rtnl_unlock();
>> >       return ret;
>> >@@ -3698,6 +3695,7 @@ static const struct nla_policy
>> macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
>> >       [IFLA_MACSEC_SCB] = { .type = NLA_U8 },
>> >       [IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
>> >       [IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
>> >+      [IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
>> > };
>> >
>> > static void macsec_free_netdev(struct net_device *dev) @@ -3803,6
>> >+3801,29 @@ static int macsec_changelink_common(struct net_device *dev,
>> >       return 0;
>> > }
>> >
>> >+static int macsec_changelink_upd_offload(struct net_device *dev,
>> >+struct nlattr *data[]) {
>> >+      enum macsec_offload offload;
>> >+      struct macsec_dev *macsec;
>> >+
>> >+      macsec = macsec_priv(dev);
>> >+      offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
>> >+
>> >+      if (macsec->offload == offload)
>> >+              return 0;
>> >+
>> >+      /* Check if the offloading mode is supported by the underlying layers */
>> >+      if (offload != MACSEC_OFFLOAD_OFF &&
>> >+          !macsec_check_offload(offload, macsec))
>> >+              return -EOPNOTSUPP;
>> >+
>> >+      /* Check if the net device is busy. */
>> >+      if (netif_running(dev))
>> >+              return -EBUSY;
>> >+
>> >+      return macsec_update_offload(macsec, offload); }
>> >+
>> > static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
>> >                            struct nlattr *data[],
>> >                            struct netlink_ext_ack *extack) @@ -3831,6
>> >+3852,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr
>> *tb[],
>> >       if (ret)
>> >               goto cleanup;
>> >
>> >+      if (data[IFLA_MACSEC_OFFLOAD]) {
>> >+              ret = macsec_changelink_upd_offload(dev, data);
>> >+              if (ret)
>> >+                      goto cleanup;
>> >+      }
>> >+
>> >       /* If h/w offloading is available, propagate to the device */
>> >       if (macsec_is_offloaded(macsec)) {
>> >               const struct macsec_ops *ops; @@ -4231,16 +4258,22 @@
>> >static size_t macsec_get_size(const struct net_device *dev)
>> >               nla_total_size(1) + /* IFLA_MACSEC_SCB */
>> >               nla_total_size(1) + /* IFLA_MACSEC_REPLAY_PROTECT */
>> >               nla_total_size(1) + /* IFLA_MACSEC_VALIDATION */
>> >+              nla_total_size(1) + /* IFLA_MACSEC_OFFLOAD */
>> >               0;
>> > }
>> >
>> > static int macsec_fill_info(struct sk_buff *skb,
>> >                           const struct net_device *dev)  {
>> >-      struct macsec_secy *secy = &macsec_priv(dev)->secy;
>> >-      struct macsec_tx_sc *tx_sc = &secy->tx_sc;
>> >+      struct macsec_tx_sc *tx_sc;
>> >+      struct macsec_dev *macsec;
>> >+      struct macsec_secy *secy;
>> >       u64 csid;
>> >
>> >+      macsec = macsec_priv(dev);
>> >+      secy = &macsec->secy;
>> >+      tx_sc = &secy->tx_sc;
>> >+
>> >       switch (secy->key_len) {
>> >       case MACSEC_GCM_AES_128_SAK_LEN:
>> >               csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_128 :
>> >MACSEC_DEFAULT_CIPHER_ID; @@ -4265,6 +4298,7 @@ static int
>> macsec_fill_info(struct sk_buff *skb,
>> >           nla_put_u8(skb, IFLA_MACSEC_SCB, tx_sc->scb) ||
>> >           nla_put_u8(skb, IFLA_MACSEC_REPLAY_PROTECT, secy->replay_protect) ||
>> >           nla_put_u8(skb, IFLA_MACSEC_VALIDATION,
>> >secy->validate_frames) ||
>> >+          nla_put_u8(skb, IFLA_MACSEC_OFFLOAD, macsec->offload) ||
>> >           0)
>> >               goto nla_put_failure;
>> >
>> >--
>> >2.21.3
>> >
