Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8476C930F
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 10:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCZIKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 04:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZIKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 04:10:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091AB5FC2;
        Sun, 26 Mar 2023 01:10:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f22so1607781plr.0;
        Sun, 26 Mar 2023 01:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679818213;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J1/B+9iVvI5dzcNRBNyfENWdpUqP//bX1siwDilnCMQ=;
        b=qcPvHm8nga+RfdbuzKxuEXi3xRtekVEOGjsv60y0VG42t1/ElEGbaCBVC4oVgaDFT5
         UesD2Z/cVtxV7ImrXKUMoHptPCyfzqPw5PZ/kR5VvZzBY8ndykQIOZz4FGMBxbVPmJ8t
         9ILCylZuQbeIktCiccpRFSaR8pAlBTGUOGF9WDlYb3p8rODb39CeSrYiWWhmpv8Xzlzy
         HhOAaO2gXvZ0rzesTal/Od0v8VmDTrEBMI4UY3Iurmc1FLeyHVLCeaN3BWMMVc1JLCFM
         x25MWrZ4UoBzvpD7qoVIW0uSDl0EQ2V2AbgweQCSIMCNiJCyPR3LSeMyyuLNVuYSWWdI
         tKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679818213;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1/B+9iVvI5dzcNRBNyfENWdpUqP//bX1siwDilnCMQ=;
        b=SJLRzME+ii72yRD8Zds6dIFXRiKFo1ozBSvMiEw+6W3iCLjhVNL/Lg8sEnXWKWRsh7
         hREdet/FiYw/3OZuiDxjunPslyXKJX0tIOzN0C/+zEmh4oUDoQ0v/Cvq9Uih7fTU4XIt
         2ap3pPWdqu2Q+dQRa+hUUxqltJthmiWBNUAqqtCU6QKFuXChsgQ7i4IhcGEP6vrZ4uUZ
         djapN2PjLtQIOo+J2yXupU1vyfJypLB9wcXJ/IC2E/1BRW74Jq7menzNxyhSlZDoc6vz
         cODqGYLsV3j2Ylgs2hGDE8yVjv3xhuZOl9lNaCUfHspe0bE2mE631rTnQ2dKBEyGGWoT
         0KLA==
X-Gm-Message-State: AO0yUKWNe3VG8dbm724N+3p0yOJ/jWBOjnmHb64Z0nFCYC4E7vM+UY/x
        kJLsusWLLyHmYKTnucUbebo=
X-Google-Smtp-Source: AK7set8ySV+myqe2AQZuOsybwlNOJW4KrrPUt7tGNYbn1piaXcfX/9pMeDEesOfhSi8xzpw4XQTe6Q==
X-Received: by 2002:a05:6a20:2a08:b0:da:5e10:799b with SMTP id e8-20020a056a202a0800b000da5e10799bmr7552372pzh.10.1679818213198;
        Sun, 26 Mar 2023 01:10:13 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id j4-20020aa783c4000000b006281f4a54bdsm8667870pfn.154.2023.03.26.01.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 01:10:12 -0700 (PDT)
Date:   Sun, 26 Mar 2023 17:10:07 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
Message-ID: <ZB/93xJxq/BUqAgG@dragonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am curious about the error handling logic in isotp_sendmsg() which
looks a bit unclear to me.

I was looking the `WARNING in isotp_tx_timer_handler` warning [1],
which was firstly addressed by a commit [2] but reoccured even after
the commit.
[1]: https://syzkaller.appspot.com/bug?id=4f492d593461a5e44d76dd9322e179d13191a8ef
[2]: c6adf659a8ba can: isotp: check CAN address family in isotp_bind()

I thought that the warning is caused by the concurrent execution of
two isotp_sendmsg() as described below (I'm not 100% sure though).

CPU1                             CPU2
isotp_sendmsg()                  isotp_sendmsg()
-----                            -----
old_state = so->tx.state; // ISOTP_IDLE

                                 cmpxchg(&so->tx.state, ISTOP_IDLE, ISOTP_SENDING) // success
							     ...
							     so->tx.state = ISTOP_WAIT_FIRST_FC;
							     hrtimer_start(&so->txtimer);

cmpxchg(&so->tx.state, ISTOP_IDLE, ISOTP_SENDING) // failed
// if MSG_DONTWAIT is set in msg->msg_flags or
// a signal is delivered during wait_event_interruptible()
goto err_out;
err_out:
    so->tx.state = old_state; // ISTOP_IDLE

                                 isotp_tx_timer_handler()
								 -----
								 switch (so->tx.state) {
								 default:
								     WARN_ONCE();
								 }

Then, a commit [3] changed the logic of tx timer, and removed the
WARN_ONCE() statement. So I thought that the issue is completely
handled.
[3]: 4f027cba8216 can: isotp: split tx timer into transmission and timeout

But even after [3] is applied, I found a warning that seems related
occurred [4] (in the kernel commit: 478a351ce0d6).
[4]: https://syzkaller.appspot.com/bug?id=11d0e5f6fef53a0ea486bbd07ddd3cba66132150

So I wonder whether the `err_out` logic in isotp_sendmsg() is safe.
For me, it looks like isotp_sendmsg() can change so->tx.state to
ISTOP_IDLE at any time. It may not be a problem if all other locations
are aware of this. Is this an intended behavior?

Thank you in advance.


Best regards,
Dae R. Jeong
