Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ABE3FCB14
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbhHaP4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239276AbhHaP4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 11:56:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DF2C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 08:55:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x16so15322716pfh.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 08:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLTcvlQou8xvitLyMD6afxeteIY+EDj9pvqSXQclrqU=;
        b=dNYnYheksGtwqaWXhYMF3nOfyhEtRvMlZ+JuLZ5u+raz1vc2m3nqfx34XqtNpEjyBR
         Roe3xI2iGsq8pBDnufbGANfpvv/LSPS1bRAtW61p1WCADlv7ThIFE1t1DO7YQAwooP15
         ePb3Fyi41Xt5Ak+V+USomKP6Xziu+gM5g9j/uOs8+EE9duvgsdM9mxEKH5lBm7FPrHs1
         taWQH0FI7Te19hs/EEt8lqkmGNLMWsMvmxfTZJuE+bh9BbK8Z/9PovIfPnzdAbfcRjDH
         K7VbsoKw00PxIVuVzf5wW0nMImEqbk0BqdId1SSAmPz9SxoaitqxLXaPMJVXE8GDdL+i
         i3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLTcvlQou8xvitLyMD6afxeteIY+EDj9pvqSXQclrqU=;
        b=sPcQLPsGPLpUZb126KAtnh3Bl9al9UQW7l2aztIuYokFvPQV7BI+NsK9jcX4j38zbN
         idbvYx2lEnVPghyKGJqm9NR5RxkVjADHKd0E5fizjZsKmzq3gf4+B/HqIkXsWlGnRdMZ
         aeh+oGsj0rVqBb20aqfuKRo6RmWJWO1nCpC8VTKcZ42w0kWk0AeoaLInI4pdNAV7fC97
         D6j8Ig3QlXq2ALbn8oBIkQULRQbrUJg7mbnmDqvtJ8BEnFJ5d+T5DZ+SQmpr69O/2NHw
         50fsTZx7BU2LSUH6zCBK1PswqaoA76kNVl5J8nKYZXcnrc1QrkgcuRPNQ1WQxYn4plmn
         /0pA==
X-Gm-Message-State: AOAM530RkbkTIApFzwpLvlMV6LV3iO6suTEypZASErbMA3luTyoV5Ylb
        h40g3rjzBqwugl7IqYPXoBwjLLJXuDl1yQ==
X-Google-Smtp-Source: ABdhPJwZJGg4pLkLvgt1f84ifATlCZx815iLI64PGsLkMffMXQIbH2xhuH8R9IVdgW1Oae+66YgKDw==
X-Received: by 2002:a65:6799:: with SMTP id e25mr27647664pgr.59.1630425305133;
        Tue, 31 Aug 2021 08:55:05 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id p9sm23302488pgn.36.2021.08.31.08.55.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 08:55:04 -0700 (PDT)
Date:   Tue, 31 Aug 2021 08:55:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214241] New: System freezes after redirect traffic from
 bridge interface
Message-ID: <20210831085501.4f7d6c3b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks like a user error. Since bridge takes Ethernet packets
and PPP use different header encapsulation. Perhaps kernel could check for this?

Begin forwarded message:

Date: Tue, 31 Aug 2021 14:01:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214241] New: System freezes after redirect traffic from bridge interface


https://bugzilla.kernel.org/show_bug.cgi?id=214241

            Bug ID: 214241
           Summary: System freezes after redirect traffic from bridge
                    interface
           Product: Networking
           Version: 2.5
    Kernel Version: 5.13.13
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

If redirecting traffic on bridge interface to ppp interface, system it's
freezes.

tc qdisc add dev bridge0 handle 1: root htb default 1

tc filter add dev bridge0 parent 1: flower src_mac 88:00:42:42:00:aa dst_mac
88:00:42:42:00:ab action vlan eth_pop action mirred egress redirect dev ppp0



after send traffic, system it's freezes.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
