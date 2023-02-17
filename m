Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07069AFD3
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjBQPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjBQPyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:54:25 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68A368555
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 07:54:23 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id c22so3242097vsk.12
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 07:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676649263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2BGkp9u1Dgw7lXwC7Y7Dhn7In7Avqn4t4WsyHwYehf8=;
        b=FOrMhHbtVZSSnJlZGrKhQH53+kxNIjTHZPL91w9N2g9thnvjCiXMDgTDzinzrWDLJ6
         PUbVrdla7moolXuzoNh4ugkJJIOd9rSFiUHqp2nemgRpXDN/dGBT17B0oIzrZPAyr0cW
         BAIk3JZQcXAIqOe4yRiYOPehsQsPToUKho88hGG4cQ2WZ1kcSukcV0lfLVvEqyyH/zSi
         5I53+hXBpn9++/LcwnY2Fb+Dh0PnSQvkvg89VRStfxd8jSzgSG+XZwVLYkq0BucSPRXU
         g9NtfbUwYGfJTZkmRligkhPAKT10vTdEYdcsLvvy4At84LfYJkw2QPoRnyjuHpVKusTJ
         6TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676649263;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2BGkp9u1Dgw7lXwC7Y7Dhn7In7Avqn4t4WsyHwYehf8=;
        b=em5iDGUY9CmEjKje7yC9uLMnINrKLzlk1oh33CvFSAnJjAlR14HXdCTnkFvP/om/VW
         x+J/ePYNBMUzBnTzr6A22f1vp2GScN87G1G0Cey54E3mI9UlA+bJSevYVYUEwax5OZGE
         3yhR8EpA57DzFQrG2TjUaPcZwKm7eJNg9qpljn9rpXEu84pA5rK5V3tb327Eber/qvEs
         NM5wA+tw4ltN6TM8b4iqnu4682JA1w2RMJpwBhINhD1FbTDtuYvwdHCrEvLDfQz6jm8j
         4hSUMylHWr/0LRrKqhZ+Ru9CMpxRzGZDE4AQeuLwp1UnE46TYV23kRffXGvSpIodsaDr
         6j9w==
X-Gm-Message-State: AO0yUKWALvvyVo2UHNx5Kals04pNv0/tDNGyoD4kQ+MI54gP4VeQye2Q
        dxzrpMK5qX6zfYLhJgqpAitklcdhA+aY4Roz0FAbMw==
X-Google-Smtp-Source: AK7set+jqx6ZUC5r0Cpfg6YmwiC+md1d9vFTc2bo+KnC8T/63yPQku0SierpouAix13rEdb4cipSCdywAxXEXpKkZIU=
X-Received: by 2002:a67:6242:0:b0:412:6a3:3e1d with SMTP id
 w63-20020a676242000000b0041206a33e1dmr63284vsb.25.1676649262889; Fri, 17 Feb
 2023 07:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20230217100606.1234-1-nbd@nbd.name> <CANn89iJXjEWJcFbSMwKOXuupCVr4b-y4Gh+LwOQg+TQwJPQ=eg@mail.gmail.com>
 <acaf1607-412d-3142-1465-8d8439520228@nbd.name> <CANn89iLQa-FruxSUQycawQAHY=wCFP_Q3LHEQfusL1pUbNVxyg@mail.gmail.com>
 <e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.name> <CANn89i+j6==4S4Oyn+NVgm+qRQO_P5dMjxGSEjntPVp=v-HA1A@mail.gmail.com>
 <b163bfe3-0b91-e2cf-f702-8ab08a30db0d@nbd.name>
In-Reply-To: <b163bfe3-0b91-e2cf-f702-8ab08a30db0d@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Feb 2023 16:54:11 +0100
Message-ID: <CANn89i+rCxZgzoM2qJ5yB1NnJoQpovS6_8xdrX5yrxxcC-x9dg@mail.gmail.com>
Subject: Re: [RFC v2] net/core: add optional threading for rps backlog processing
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 4:26 PM Felix Fietkau <nbd@nbd.name> wrote:

>
> > Then, process_backlog() has been designed to run only from the cpu
> > tied to the per-cpu data (softnet_data)
> > There are multiple comments about this assumption, and various things
> > that would need to be changed
> > (eg sd_has_rps_ipi_waiting() would be wrong in its current implementation)
> That's why I added the NAPI_STATE_THREADED check in napi_schedule_rps,
> so that sd_has_rps_ipi_waiting would always return false.
> Or are you worried about a race when enabling threading?
>

Please look at all uses of sd->process_queue, without locking. They do
not care about NAPI_STATE_THREADED

flush_backlog() is one instance, but process_backlog() is also using
__skb_dequeue(&sd->process_queue)

I suspect the following patch would work today, and would show
process_queue lock is not used.

diff --git a/net/core/dev.c b/net/core/dev.c
index 5687b528d4c18ef2960edb6bf3161bbad666aece..bed540b417a1b4cd3e384611a4681b8e2a43fd30
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11396,7 +11396,7 @@ static int __init net_dev_init(void)
                INIT_WORK(flush, flush_backlog);

                skb_queue_head_init(&sd->input_pkt_queue);
-               skb_queue_head_init(&sd->process_queue);
+               __skb_queue_head_init(&sd->process_queue);
 #ifdef CONFIG_XFRM_OFFLOAD
                skb_queue_head_init(&sd->xfrm_backlog);
 #endif
