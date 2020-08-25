Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C12E251EA5
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHYRxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYRxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:53:07 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9815CC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:53:07 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m8so7943712pfh.3
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xG9LiyraX6kSIR011215MFt/pkdbgasJf8IEGvTRJvA=;
        b=vCAyf/ycDJhyw1eSNpqL/levluAudu2QolXebrwuednJo0+FIIDMZdYK8/KFqcfUYy
         +qOOqX8v8WJxbaJFv8+OfpPK1bmJTsM+Fi1BKp8oNni+4KO55WC26HxOzdbUYD1+gGrQ
         m8Q+tnXrU4Rnzhgte6rLjUD/P9FvuI2k49K2Wx8cX/qUVR89eZH8m5T2a7Zr0fZ3kAX4
         enFK/GNUPi8oLfNMEgi0ROaHg/1lZg0dsDMfJ4n7wuE3B0ZpozY6olctJ9DrInxAua6f
         Z+Y/h2oCS+H8kXPsU/QdmRCsaIb9nvspAQRU+/uU17I/L0rHsENRtC78pULFE1gQPX2A
         Atjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xG9LiyraX6kSIR011215MFt/pkdbgasJf8IEGvTRJvA=;
        b=YPX/xIXb4v501O86Gy8DKByh+LOq5YiP4Z/gQQz9xdsxZX+pkLsRT2pQFlr1SMAqcC
         JS2L3KEmoC1RmdKzP6Yz2kvRrm/CpJZNyDGYbroWpbULumoFmbEAU3G3BaxDVt9ib8Mk
         0QPWqsiTsuht8oid7T5Y4bzCbEmP+UgSWWt6azmPlAoo+7Z5i3AMTtuol3kA753wO36n
         Kng1MZhM6aREGfcnCqORml07cJHNGINP4G10USH1R+VgC05uAA5CpUIXNA5BQm2U0YMZ
         2c2At93FclLtHO8SF+sSZfNk9CB468FcrF01SgZto8bWLACNq9XqVXX1Wb6FT4JWwl9m
         2yAg==
X-Gm-Message-State: AOAM5325X3iSq1eqPIx069NieE4I6Rq3W9IUwm5q7ilTT7T4awwRrzMC
        dgKJV2KhnllEVb0VbTbQnnM7B+u7k0RGHA==
X-Google-Smtp-Source: ABdhPJxhawMrJNedFL5CoATreU64Im9fqBAsF7BkIqaFwGNNRokkTTOqSg9+LNy2nGGv9ElwWxeWFA==
X-Received: by 2002:a63:e157:: with SMTP id h23mr7925447pgk.239.1598377986297;
        Tue, 25 Aug 2020 10:53:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s24sm3319849pjp.1.2020.08.25.10.53.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 10:53:05 -0700 (PDT)
Date:   Tue, 25 Aug 2020 10:52:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 209037] New: lec_seq_next does not update index position
Message-ID: <20200825105257.1f2b9cf1@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 25 Aug 2020 16:10:37 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209037] New: lec_seq_next does not update index position


https://bugzilla.kernel.org/show_bug.cgi?id=209037

            Bug ID: 209037
           Summary: lec_seq_next does not update index position
           Product: Networking
           Version: 2.5
    Kernel Version: from at least 2.6.12+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: colin.king@canonical.com
        Regression: No

Stress-testing /procfs with stress-ng tripped the following warning when
reading /proc/net/atm/lec:

[ 7236.344619] seq_file: buggy .next function lec_seq_next [lec] did not update
position index
[ 7236.344704] seq_file: buggy .next function lec_seq_next [lec] did not update
position index

can be reproduced by seeking on the proc file and reading:

dd if=/proc/net/atm/lec seek=1 of=/dev/stdout bs=1K

the read() also blocks which is not correct either.

-- 
You are receiving this mail because:
You are the assignee for the bug.
