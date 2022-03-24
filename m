Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61B4E6A53
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 22:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354221AbiCXVlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 17:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiCXVlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 17:41:31 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063AF6517C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 14:39:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qx21so11741382ejb.13
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 14:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=vAv++6Ka2pHCMdt2V4TKWEdbarlaFc2/zhh4e1HEnfs=;
        b=jr9qqQhv2SSJOCMShSG33diffvDR4DjQ4qEOM9Bces5kuL+TpV+st0BkID8Vik/1iY
         99D8XzX+vN1SmM7dvDE0r0Y6abLWXNa1dyA4idYTKiPL7WE96jNe3La8dPSY4V6ru4df
         To//r7jC5hk5qWePIV7HInKfVlxk4vR7de82CX0eFeHPrl737aYT+EZU6KfjzMbxH6op
         +nDHMU2w/UIzUWJbNbwT1996LXsBJu+nFtIYfRhHZrlFfHCmyWcB5Ijie9h9MfRWPky6
         NysYOH94KkfREUxpoXdMS4T0HP+ydtFabzg8tzkwf9zXVJQanGlro2XjhlgRTe2QX6WL
         S7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=vAv++6Ka2pHCMdt2V4TKWEdbarlaFc2/zhh4e1HEnfs=;
        b=RpCzk67KUfS8DdckzgvApU5zgQsniwtLLegg2LxNF8duncnBxyj5K/xXCKfLETTult
         16vFg6cpmO8T4sSEv34PspnxzlqcWDfT0NzKgeer6GyrbsdzlWmqRiOq+/heIeUJY4KU
         Y81S9ivlEa3oEim7ukqJGuGxIFN7pVUu/lgcvqM5jnctaouNJzKx+v/si0xeax+bD2YB
         pvVDgA4+ozfPBzSkUjLHDLZM1X9g7BYoPicVqbdZexD8rwnFcKwKCDXkkGl5mB9LwEkZ
         3Bu2ILmUEDlXN0gqSYr/KdP1642IsVivXMFRe0daq/lLOcmZecaA12NjOWeLQprcSyEg
         SDaQ==
X-Gm-Message-State: AOAM533vm685gNRjvjCrORnXMtV2iccDxKCt8kfdtFLQ29DuEHWHUgNU
        EBxUztXmLWlq34n4N3ApN/CkteheEYw=
X-Google-Smtp-Source: ABdhPJzcD+x9c98PnCyKsJpNnJxfdvc8Zukx9DfrDgGx4GLoYOv4fHWnkm7RkJ88qStFp80CtZVM7g==
X-Received: by 2002:a17:907:6d8f:b0:6e0:1512:913b with SMTP id sb15-20020a1709076d8f00b006e01512913bmr8262183ejc.491.1648157996489;
        Thu, 24 Mar 2022 14:39:56 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id by4-20020a0564021b0400b00418fc410299sm1910258edb.62.2022.03.24.14.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 14:39:56 -0700 (PDT)
Date:   Thu, 24 Mar 2022 23:39:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier stable
 branches
Message-ID: <20220324213954.3ln7kvl5utadnux6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Willem,

I have an application which makes use of SOF_TIMESTAMPING_OPT_ID, and I
received reports from multiple users that all timestamps are delivered
with a tskey of 0 for all stable kernel branches earlier than, and
including, 4.19.

I bisected this issue down to:

| commit 8f932f762e7928d250e21006b00ff9b7718b0a64 (HEAD)
| Author: Willem de Bruijn <willemb@google.com>
| Date:   Mon Dec 17 12:24:00 2018 -0500
| 
|     net: add missing SOF_TIMESTAMPING_OPT_ID support
| 
|     SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
|     But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
| 
|     Add skb_setup_tx_timestamp that configures both tx_flags and tskey
|     for these paths that do not need corking or use bytestream keys.
| 
|     Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
|     Signed-off-by: Willem de Bruijn <willemb@google.com>
|     Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
|     Signed-off-by: David S. Miller <davem@davemloft.net>

and, interestingly, I found this discussion on the topic:
https://www.spinics.net/lists/netdev/msg540752.html
(copied here in case the link rots in the future)

| > Series applied.
| >
| > What is your opinion about -stable for this?
| 
| Thanks David. Since these are just missing features that no one has
| reported as actually having been missing a whole lot, I don't think
| that they are worth the effort or risk.

So I have 2 questions:

Is there a way for user space to validate functional kernel support for
SOF_TIMESTAMPING_OPT_ID? What I'm noticing is that (at least with
AF_PACKET sockets) the "level == SOL_PACKET && type == PACKET_TX_TIMESTAMP"
cmsg is _not_ missing, but instead contains a valid sock_err->ee_data
(tskey) of 0.

If it's not possible, could you please consider sending these fixes as
patches to linux-stable?
