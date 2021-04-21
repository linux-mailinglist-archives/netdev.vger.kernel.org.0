Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C29367093
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbhDUQtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242056AbhDUQtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:49:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41082C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 09:49:19 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id p2so14985140pgh.4
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 09:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YofVd7h9TTAUtJm02RuQ1uMGb1tLcZYg66RQ0VMaxfY=;
        b=xfSYFpqTi/9rUNUnLj17Pm+oOiO4ZNx/7pIFtcGrpx1QnLk2CLsr2a3NP6gQ5B3hBk
         zun7saLACyQv1gE6VMIGwU8pg6i8est8ZfLgshxAA3A6zhqTMLWLzoaDQUZxL/rUpYrF
         5htV8tVWrOky+0yt2IRuHgKM4vnuC63CtzUej9s8lW1VrSDKk5eVOUSScozPV9/hB9SO
         OZSKOofjF/Ix4gfUiruryNlwEZ5xykppFmIeMpYA2vcBA3b6vJ2NHxAfADqc1aPRFOtv
         DSvlruZgE4lTJ6y0ksqyJaNbHzfkDNPf0cU1hlMhz40tUMYLsQapIJfQy6hDZuCY5AJK
         iviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YofVd7h9TTAUtJm02RuQ1uMGb1tLcZYg66RQ0VMaxfY=;
        b=qXWak1bQ0OffqN5S2Z1xjxhBUCADKnYI1C2q8SBQnRH8IZqUMFR3kxIpP90kMEfVqN
         K/AgRYfBQ18Z3Z4NOx24IeNpvXeAVWVU37ndhMss+crg4MWSU5GxO0AHP38GatpI/if4
         luZg1bw3Ent1XMYj/SDJy/6kvYe50eoMnGKAoQZiBrC6RiG7h+Vvq215B6YEZ7Wdxxxn
         DphvJzWjt0D1SxO4CT4kmNHgueYbBqRtQZD6Ut7h6caOVnzSTI77jsKxA//ZbmAT3fY1
         yjHGF7lZ8Q2CFZPgjCMNgCAotbLk4IM2Q7N5oL5mYPSBfDLNWrtiOfRyn33g70BLuXgd
         KQRw==
X-Gm-Message-State: AOAM533dfg4c9c0ymKEuWpXRsKRDaLzO8BmDY/87rNnkWNjGzMOpa0w9
        IiJeXbRzeOeBkwbJsgsPxP9lPhLfXqTbVA==
X-Google-Smtp-Source: ABdhPJwUTqChCRKwNoPq0hyrTxaRFa9tk2NiLG9lg/Q8Q6NrC1j6MZdQ3Zy7nf64HdqhrvCUbFV//g==
X-Received: by 2002:a17:90a:db15:: with SMTP id g21mr11930635pjv.113.1619023758819;
        Wed, 21 Apr 2021 09:49:18 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id kk7sm2706279pjb.11.2021.04.21.09.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:49:18 -0700 (PDT)
Date:   Wed, 21 Apr 2021 09:49:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Fw: [Bug 212741] New: unregister_netdevice: waiting for enp0s20f0u1
 to become free.
Message-ID: <20210421094910.2ccf58b3@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like a USB driver network device ref count bug.

Begin forwarded message:

Date: Wed, 21 Apr 2021 08:39:38 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212741] New: unregister_netdevice: waiting for enp0s20f0u1 to become free.


https://bugzilla.kernel.org/show_bug.cgi?id=212741

            Bug ID: 212741
           Summary: unregister_netdevice: waiting for enp0s20f0u1 to
                    become free.
           Product: Networking
           Version: 2.5
    Kernel Version: 5.11.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: dexter+kernelbugzilla@beetjevreemd.nl
        Regression: No

This problem exists for years by now, I could work around it until now.
Somewhere around kernel 4.9 ish this problem started to appear.

I have an USB network adapter and whenever the connection is severed (because I
touch the cable, USB reset, sleep, cosmic rays) the kernel starts logging below
message every 10~ish seconds. The usagecount is always different, but increases
with uptime. I can replicate this on all my laptops and workstations.

My setup is quite straigtforward, just (networkmanager)DHCP and a wireguard
VPN. Running Fedora 33 (but exists since like 26 or so).


[  992.787930] unregister_netdevice: waiting for enp0s20f0u1 to become free.
Usage count = 8113

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
