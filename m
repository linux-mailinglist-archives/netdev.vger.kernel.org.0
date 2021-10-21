Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419A5435D3B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 10:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhJUIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 04:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhJUIrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 04:47:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FF4C061749
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 01:44:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s61-20020a17090a69c300b0019f663cfcd1so2597635pjj.1
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 01:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=NSfOG4pHa+efY4fWKGvQNvn7KP1IkrBtjwZg+u3ax7A=;
        b=NoF5VUMKfXkPBRVSwItawV8gW4gURA0TEcBx1+Xu5bddphrzf7zPzm2fym6nuJVTSG
         fKZCMvvL/FndFiNe+6uXxLEt1Qg5A0ApwzugcRCqDwP12OWK98aTMmmo1d9wXLX4x/dm
         LX7o6Xcd35tt9gqFH1W5X3K1NpWFftvxKloDqUfMuztrOt297Yno70edLhQsPZcE2WMd
         t9a+h1OY7pFayhPP9RfzvkhtIfkOnNmWjrsX56U8cxN/var46tuJOb5SwobP/Z2f1gMp
         /i0+3Qr+tac3E6o0EM7C0E7OQ8rNLhjxa+Q/PtDbFi+MxDLWZxxM+1ifkj41Ni24iPUD
         8Fdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=NSfOG4pHa+efY4fWKGvQNvn7KP1IkrBtjwZg+u3ax7A=;
        b=VQnp6LF+vhsVLXml6CyzU+mDUGbFGv+M88qY1Np8KCrFLLf+yh3kI/PMrk9o47/guK
         h34qdGjEY1d+HOqB/iNoZRB31P5moOeqzucmQLr4KQASNyk6SVK8H74Nn9sYLesbIvU6
         LPfpGUtqzM/uCh5Nu7W+eOjEWm8Vq+i3yVz68kp3pSp2/x6J9dV1kJ0f5FFBAAEhc/2P
         ujrrNuXMqhsETtKKpBUVO3VNaQzt0ABbvxL1wIdroYIdwSU3pKFJxEyaIi70PdS9vaEG
         Xs8dv1Bm90f5hn0MIMR2JMcrXmY/tecDQpem9wW3kEfC/fGoHZjJMRFJ+JM62DqfF6LR
         DmVw==
X-Gm-Message-State: AOAM532a12/I1Mrg+x5hl2xEZBL/170E8OggncuAe9IfxGqb0LM/KkmF
        1zA4jkN9jgnkCjqCN/SSpRUnahq6ml0=
X-Google-Smtp-Source: ABdhPJwB+yraEn/o27yATAW0NbBQTYELQVAduZii23fjKyiCjjQXySe92Z4gdTNN/EIy/cLFrvGtpQ==
X-Received: by 2002:a17:90a:cb92:: with SMTP id a18mr4141006pju.157.1634805888724;
        Thu, 21 Oct 2021 01:44:48 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14sm4797403pgg.92.2021.10.21.01.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 01:44:48 -0700 (PDT)
Date:   Thu, 21 Oct 2021 16:44:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Kevin Cernekee <cernekee@chromium.org>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [IGMP discuss] Should we let the membership report contains 1 or
 multi-group records?
Message-ID: <YXEoekVoLZK7ttUd@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi IGMP experts,

One of our customers reported that when replying to a general query, the
membership report contains multi group records. But they think each
report should only contain 1 group record, based on

RFC 3376, 5.2. Action on Reception of a Query:

   1. If the expired timer is the interface timer (i.e., it is a pending
      response to a General Query), then one Current-State Record is
      sent for each multicast address for which the specified interface
      has reception state, as described in section 3.2.  The Current-
      State Record carries the multicast address and its associated
      filter mode (MODE_IS_INCLUDE or MODE_IS_EXCLUDE) and source list.
      Multiple Current-State Records are packed into individual Report
      messages, to the extent possible.

      This naive algorithm may result in bursts of packets when a system
      is a member of a large number of groups.  Instead of using a
      single interface timer, implementations are recommended to spread
      transmission of such Report messages over the interval (0, [Max
      Resp Time]).  Note that any such implementation MUST avoid the
      "ack-implosion" problem, i.e., MUST NOT send a Report immediately
      on reception of a General Query.

So they think each group state record should be sent separately.
I pointed that in the RFC, it also said

A.2  Host Suppression

...

   4. In IGMPv3, a single membership report now bundles multiple
      multicast group records to decrease the number of packets sent.
      In comparison, the previous versions of IGMP required that each
      multicast group be reported in a separate message.

So this looks like two conflicting goals.

After talking, what customer concerned about is that if there are a thousand groups,
each has like 50 source addresses. The final reports will be a burst of
40 messages, with each has 25 source addresses. The router needs to handle these
records in a few microseconds, which will take a very high resource for router
to process.

If each report only has 1 group record. The 1000 reports could be sent
separately in max response time, say 10s, with each report in 10ms. This will
make router much easier to handle the groups' records.

So what do you think? Do you think if there is a need to implement a way/option
to make group records send separately? Do anyone know if it's a press to let
router handle a thousand groups with each having 25 sources address in a few
microseconds?

Thanks
Hangbin
