Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D4A342547
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhCSSuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhCSSum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:50:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4493BC06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 11:50:42 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f8so865648pgi.9
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6pOFYk2WAqSs2z2QkgB8UJEp0rKmYY0L3UJjWNMKXVk=;
        b=AHE1PpzjY0JAMQ2tO6W9VFeq/t2DucfvDVMPZ6m3/HKEJRVNMnzuO0cfFO7VDj4KWe
         yspxPGJWkhy00fcjrqQ52uKOxGM/N9NokdenSqIvnaOn7/zOFq0LXKosy8/6WqdC5pyU
         4IKqSbBNdmecH/wLzlNbYmaF7LjfPKyDMXL7mlajEYdtkcYRUc6hpFibQnbDFu7t8Slu
         cNseHzxKT7nU2+sgtD5FkSJhC53muok1MdqID/4uB5GNLhVNqWNfC3+g8m8jtACLrrrr
         OE+MbEWNvzonRq+n8uQFUtgv+dc0ipWwnd/FO123j07VUrKTsVc11gBByzWN0dEEH6th
         Rmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6pOFYk2WAqSs2z2QkgB8UJEp0rKmYY0L3UJjWNMKXVk=;
        b=Ni3cuOgPHeoH0qkdT7Lav4SSAI6uKWZ0sIsLjCHw9xS2V9bASJsL3cNQsyC4S5J3bu
         0p9Honp5n0lQEyz65UCJt0c8S+WOuK08ZL9t544Y4opIqZ3ItM4zYKnMeK12RDiroM7m
         9L08rRgE+ERGyfo+idHuzASv46TBNF3YcLhW32yW+QYfRrItgoYqp2TtVVkQlphOIv7/
         Q9y0INxkB9q94RmM/TrFfxdgFVLwOb6+MkDoXuR6K7FMd4spUSl69LK/8ghjZ24dVY10
         xq4hk+GDSfxcMlqTNfgJQIKTZGv9VbuBpP8WO0NrmMIKmssQESOGZfu8LDeR54ZTbjq7
         XhrQ==
X-Gm-Message-State: AOAM530aFnPonZyLKHLdhY0GBaIhnYAxz+JJHLju6H8kLyOK1wgdGVEs
        sJdJd93g3208Jlzyed0aJfjoWCpGcp+diQ==
X-Google-Smtp-Source: ABdhPJypbn1Or5A5X9hNIM8W/Ck2VbH8g55ea7ZiqxfMBRb5ConHVqOXICSgkXhRtEjlsa3XEMQDTw==
X-Received: by 2002:a65:6a4b:: with SMTP id o11mr12700384pgu.138.1616179838828;
        Fri, 19 Mar 2021 11:50:38 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id q5sm5929246pfk.219.2021.03.19.11.50.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 11:50:38 -0700 (PDT)
Date:   Fri, 19 Mar 2021 11:50:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212353] New: Requesting IP_RECVTTL via setsockopt returns
 IP_TTL via recvmsg()'s cmsghdr
Message-ID: <20210319115035.11272a9c@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 19 Mar 2021 07:04:12 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212353] New: Requesting IP_RECVTTL via setsockopt returns IP_TTL via recvmsg()'s cmsghdr


https://bugzilla.kernel.org/show_bug.cgi?id=212353

            Bug ID: 212353
           Summary: Requesting IP_RECVTTL via setsockopt returns IP_TTL
                    via recvmsg()'s cmsghdr
           Product: Networking
           Version: 2.5
    Kernel Version: 4.12.14-122.63-default (SLES12 SP5)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: Ulrich.Windl@rz.uni-regensburg.de
        Regression: No

Trying to get IP_RECVTTL, I noticed that recvmsg() returns IP_TTL, not
IP_RECVTTL in struct cmsghdr.
Example xode being used was similar to
https://stackoverflow.com/a/49308499/6607497 that checks for IP_RECVTTL in
struct cmsghdr:

...
int yes = 1;
setsockopt(soc, IPPROTO_IP, IP_RECVTTL, &yes, sizeof(yes));
...
int ttl = -1;
struct cmsghdr * cmsg = CMSG_FIRSTHDR(&hdr); 
for (; cmsg; cmsg = CMSG_NXTHDR(&hdr, cmsg)) {
    if (cmsg->cmsg_level == IPPROTO_IP
        && cmsg->cmsg_type == IP_RECVTTL
    ) {
        uint8_t * ttlPtr = (uint8_t *)CMSG_DATA(cmsg);
        ttl = *ttlPtr;
        break;
    }
}
// ttl is now either the real ttl or -1 if something went wrong

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
