Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C921351F79
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhDATTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbhDATTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:19:06 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB799C031141
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 11:08:38 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h25so2069245pgm.3
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=AeaeW0gJJqRT8WyyV0F6hswwDLgfJWJ0gXV0e+pIdNc=;
        b=wiFoeSYtVRivYIwopt8/3n18zqjlyJQpmITr7jrMJm+weQA+OL86ysLKVhBBSIsr8R
         g+3H1P/Vo671LexJgfyNvJNCBX6CZrOzgWnaIbq0VaNN3Zq+fFWBiUR0mGNiJh70I4s/
         eNm/bTu8mrNq6zFwlbH0PikARw/n7+qvJG5wFwOwPEWtYhuvvicKVdCYBWOkudBNYZci
         Kq60gLDdiuJXdn8HWOWtuwiweivPuPdVYh0yvjZAyc+W67ST7iE3c3blrY/SbtQfMs2T
         xdSzKxag9ZDfVhWFLdJGCQq0ifcbFhFANPq66rUZDLuSN3BeOG1OsSO5tpPrEwBTTFIm
         yOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=AeaeW0gJJqRT8WyyV0F6hswwDLgfJWJ0gXV0e+pIdNc=;
        b=TvTG2U3olXZ51+p73Llv0hHefODB4EqtLyQQQyiRGs1q5NWC1X2fK890TBWNdaNZFR
         OcEz2JJ9yiMCkpyHC2TBB7ItbLDJ7fE9s5GbOwc27AEgFOz092PPRR7yn65o6y1C5Pzm
         XP3lhWmqPImD9A7nPB5cRn4Q1Ce2rk+1+oQVVj3lfrHPe8M8DGSvUtKu//Wmu4rWNMTj
         lUr0IfLZOwCfb52uYxYtLFV0JP4XspkZZ4+MywthHs8MeCMw+ApRFVzei9P+0uneesoI
         HS5A0dBzkzTwpd9Zip7zZ7BbXA1ha0pXJW8TQJz97MshSufpSKVv3/B25UKu1Sz1rHms
         ZhPA==
X-Gm-Message-State: AOAM532REIff+P//c7Ojnaf122s83GOwqrecc0Nr+ar4N16V9L+qVi3k
        xhw2bfQwZ66OwARqY2KasXfvwH8bIGeRGg==
X-Google-Smtp-Source: ABdhPJyNqL+2dlyLOdKW84X8eBgWGYvbTNYv3nqsZQW8p7TlxBbpEISGZaBAI+A1dZUvrlzJ0aFlLg==
X-Received: by 2002:a63:3585:: with SMTP id c127mr8968653pga.92.1617300517945;
        Thu, 01 Apr 2021 11:08:37 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 22sm6158104pjl.31.2021.04.01.11.08.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 11:08:37 -0700 (PDT)
Date:   Thu, 1 Apr 2021 11:08:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212515] New: DoS Attack on Fragment Cache
Message-ID: <20210401110834.3ca4676b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial discussion is that this bug is not easily addressable.
Any fragmentation handler is subject to getting poisoned.

Begin forwarded message:

Date: Wed, 31 Mar 2021 22:39:12 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212515] New: DoS Attack on Fragment Cache


https://bugzilla.kernel.org/show_bug.cgi?id=212515

            Bug ID: 212515
           Summary: DoS Attack on Fragment Cache
           Product: Networking
           Version: 2.5
    Kernel Version: 5.12.0-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: kman001@ucr.edu
        Regression: No

Hi,

    After the kernel receives an IPv4 fragment, it will try to fit it into a
queue by calling function 

    struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key) 
    in
    net/ipv4/inet_fragment.c. 

    However, this function will first check if the existing fragment memory
exceeds the fqdir->high_thresh. If it exceeds, then drop the fragment
regradless it belongs to a new queue or an existing queue. 
    Chances are that an attacker can fill the cache with fragments that will
never be assembled (i.e., only sends the first fragment with new IPIDs every
time) to exceed the threshold so that all future incoming fragmented IPv4
traffic would be blocked and dropped. Since there is GC machanism, the victim
host has to wait for 30s when the fragments are expired to continue receive
incoming fragments normally.
    In pratice, given the 4MB fragment cache, the attacker only needs to send
1766 fragments to exhaust the cache and DoS the victim for 30s, whose cost is
pretty low. Besides, IPv6 would also be affected since the issue resides in
inet part.
    This issue is introduced in commit 
648700f76b03b7e8149d13cc2bdb3355035258a9 (inet: frags: use rhashtables for
reassembly units) which removes fqdir->low_thresh, which is used by GC worker.
I would recommand to bring GC worker back to prevent the DoS attacks. 

    Thanks,
Keyu Man

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
