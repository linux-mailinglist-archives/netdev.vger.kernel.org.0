Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C1166E75
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 05:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgBUEX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 23:23:26 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:34879 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgBUEX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 23:23:26 -0500
Received: by mail-pf1-f173.google.com with SMTP id i19so539312pfa.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 20:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=v6sQMsvrCgInHKEMWD8iMvxZ8avQGsorvk/oeGxOFQc=;
        b=zfX5v6t2NI7zkfKpDJxMgLXRq3vPqzqNfPhebGYxIimcknLsbGLOEAJhPgqGJBRXy3
         uZXt0Txu9bflgGIBX237ms7XZqwwFVP5hotmFSporLkMZKPJsmEPAQZieBc1nYO8DB+r
         qQjX0rd6aG1CBJHGqMwz03BdkPT9TCFSgRRVwJbUOIiiQIldFZJX1vToDKgpabxH23IZ
         eA3VV9qn8UCVIqp9uCIEq/OYEe85Ye5FDDeWN6VjfRYxQCROUMpa8XImvPui9i+r0DGS
         JMTU5VnQX/ubZ2sXnPcZkwCxD0+g6y+Ym+qkb3N/qLc46ezCQv/jLsAYNNLIBQXMEOyy
         u+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=v6sQMsvrCgInHKEMWD8iMvxZ8avQGsorvk/oeGxOFQc=;
        b=fZp8NzAvmzjU3C0DdbF0/SoGISOo0DpBvzwFGdVE2EbryKuRXQDsWUmM4z2RF+QOVR
         n4qJeICbMfLmi2hR13JyigsDLOE1NtWJ2nLGf8bt0Ljhru53yFm4Sl6Dsy8O499ylyBf
         2l1C9J1WopE96WL7/gtzim1p1Jp9UqiLspoQ9N3AE9P9rnf52fyjQjelLQ8yFJw9AAHO
         4tJNAq+P8f0FFdUVQ5NHLD3LPoDznv5kkznotABbbI65cjG0ye/VJdETy/WfhcSs99wP
         rj0JwbNj/dEEY3vKegP5OVjb8wYwUyD9JOmvMFTMBfESmeI4rmsbKILorgbt6+wx+hrl
         Cdng==
X-Gm-Message-State: APjAAAUM7bR8NsE7capbZ+c50WFeH2IJFtgSE+bAp4qLVFA28xQR3xrY
        C4FTfHS23/I5seRpwPkT8rp1KYanLbY=
X-Google-Smtp-Source: APXvYqzVqDVcTftx0jdafKzf6JScAfhsvhiSH2NEz6wgPR/2tKf7AmKxhVzp1OAMIxzp/trmWEeKlA==
X-Received: by 2002:a63:381a:: with SMTP id f26mr37706248pga.40.1582259005157;
        Thu, 20 Feb 2020 20:23:25 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r3sm1120619pfg.145.2020.02.20.20.23.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 20:23:24 -0800 (PST)
Date:   Thu, 20 Feb 2020 20:23:14 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206615] New: WARNING: CPU: 1 PID: 0 at
 net/sched/sch_generic.c:447 dev_watchdog+0x232/0x240
Message-ID: <20200220202314.32be327f@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks like both a hardware/driver issue and a more generic problem
with the use of warnings in the network stack. The network code has a lot
of warnings that should really be notices, to prevent issues with panic on warn.

Begin forwarded message:

Date: Fri, 21 Feb 2020 01:06:57 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206615] New: WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x232/0x240


https://bugzilla.kernel.org/show_bug.cgi?id=206615

            Bug ID: 206615
           Summary: WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:447
                    dev_watchdog+0x232/0x240
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.19
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: alec@onelabs.com
        Regression: No

Created attachment 287525
  --> https://bugzilla.kernel.org/attachment.cgi?id=287525&action=edit  
kernel panic on warn message

Hi,

After a few hours/minutes/days (incredibly random) one of my servers keeps
crashing (panic_on_warn is enabled for security purposes.)

I have tried adding `acpi=off` `pcie_aspm=off` and `nowatchdog` to the kernel
params but nothing solves it for good. I disabled SMP in the BIOS as well, CPU
is an AMD Athlon II X2 B28.

Panic trace attached, server is a minimal Slackware system, nothing fancy. This
problem just started happening recently, server has been up for the past year
with no issue.

Same problem occurs on kernel version 5.4.20 as well.

Thanks!

Alec

-- 
You are receiving this mail because:
You are the assignee for the bug.
