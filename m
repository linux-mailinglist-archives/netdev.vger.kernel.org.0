Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7264E748E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 16:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbfJ1PLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 11:11:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38708 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfJ1PLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 11:11:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id c13so7069924pfp.5
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=2UVTq70EIrwv+0TjokqsMuEZXO0xoZF1B3hk5Capc8Q=;
        b=2A/ZK8IMa1Yr3yVhxmIqk/3tCjg1F0cajfoz0VtulmFWRVCkUR2pO+UtbeVyA1eb9+
         eXK9/OUzTguy07cYgmEisu5nPhDIsrc9Gxl3ITFhKxk/3fFwF8dUrXXzMo96624KdrMk
         rX9pLcp3Q4qXBNImpNPjQN11xxikZtiFaq7KRc0sNknLhOc36DWTgvPkuCPZC9V62Dd6
         lSu+vxqTkWczETrYwshh2kVJr9oMnX48BWhAT+SeLkkNbPTrhi5RmpK0gpwmDr9WrQOR
         zdg884BOg1hbDdL/zJtNqEUXYrpMD2FYbzg5yk7NkLbNOjpH59O6aLr7FiGylaL/jz9d
         xBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=2UVTq70EIrwv+0TjokqsMuEZXO0xoZF1B3hk5Capc8Q=;
        b=sxtkFNvonRKdNFmxkw7pERrMz0a2XC09cRcNAYr99aQvTuKl62aFEEgPvUmn8SBjAE
         RQAR3gH7H1r2BT30CKVVnwqgFvzODjKvNgT5STwkwF2eQlKIMoboalO78m7U2auU2zHC
         qaz/egPCgIZAAtPT5V2Ad79Pl5RVrYpOkOsookzSjNIzztJB3lWzs0qZcuO/san3UrOU
         P4qZsZvwiWixCxJZqMLfZ1Ib2Xek0onm7KQOiNy2xjwRU5uPS+tTMPb4potrfsnfIkaS
         rCUn9kXxxhkVgiVaI1MnXjvBS0CkBX49uthdXAWQajGNE3LjMtI1jaZdYkO6oC4Ak7ra
         oUGw==
X-Gm-Message-State: APjAAAVOPRVeKFT4VKtIzZrPuCIbLuKKFlkivXmG7HtoxgDTYjIrAPfN
        Dms4Z36+6DhDu71Fjzaodddtt4D628TlUw==
X-Google-Smtp-Source: APXvYqyraRLa1405dheQi/8Y7HtcemfZwGA/nu2Nz2l+babFG5tEn8pYhPGkfFLlnuYPrYkJ653J5Q==
X-Received: by 2002:a62:5b83:: with SMTP id p125mr1841187pfb.237.1572275476156;
        Mon, 28 Oct 2019 08:11:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r13sm12122577pfg.3.2019.10.28.08.11.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 08:11:15 -0700 (PDT)
Date:   Mon, 28 Oct 2019 08:11:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205339] New: epoll can fail to report a socket readable
 after enabling SO_OOBINLINE
Message-ID: <20191028081107.38b73eb1@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 28 Oct 2019 02:55:44 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205339] New: epoll can fail to report a socket readable after=
 enabling SO_OOBINLINE


https://bugzilla.kernel.org/show_bug.cgi?id=3D205339

            Bug ID: 205339
           Summary: epoll can fail to report a socket readable after
                    enabling SO_OOBINLINE
           Product: Networking
           Version: 2.5
    Kernel Version: 5.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: njs@pobox.com
        Regression: No

Created attachment 285671
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D285671&action=3Dedit =
=20
reproducer

Consider the following sequence of events:

1. OOB data arrives on a socket.
2. The socket is registered with epoll with EPOLLIN
3. The socket has SO_OOBINLINE toggled from False =E2=86=92 True

In this case, the socket is now readable, and select() reports that it's
readable, but epoll does *not* report that it's readable.

This is a pretty minor issue, but it seems like an unambiguous bug so I fig=
ured
I'd report it.

Weirdly, this doesn't appear to be a general problem with SO_OOBINLINE+epol=
l.
For example, this very similar sequence works correctly:

1. The socket is registered with epoll with EPOLLIN
2. OOB data arrives on the socket.
3. The socket has SO_OOBINLINE toggled from False =E2=86=92 True

After step 2, epoll reports the socket as not readable, and then after step=
 3
it reports it as readable, as you'd expect.

In the attached reproducer script, "scenario 4" is the buggy one, and "scen=
ario
3" is the very similar non-buggy one. Output on Ubuntu 19.04, kernel
5.0.0-32-generic, x86-64:

-- Scenario 1: no data --
select() says: sock is NOT readable
epoll says: sock is NOT readable
reality: NOT readable

-- Scenario 2: OOB data arrives --
select() says: sock is NOT readable
epoll says: sock is NOT readable
reality: NOT readable

-- Scenario 3: register -> OOB data arrives -> toggle SO_OOBINLINE=3DTrue --
select() says: sock is readable
epoll says: sock is readable
reality: read succeeded

-- Scenario 4: OOB data arrives -> register -> toggle SO_OOBINLINE=3DTrue --
select() says: sock is readable
epoll says: sock is NOT readable
reality: read succeeded

--=20
You are receiving this mail because:
You are the assignee for the bug.
