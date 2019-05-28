Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413052CB97
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfE1QQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:16:46 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:34124 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1QQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:16:46 -0400
Received: by mail-pl1-f174.google.com with SMTP id w7so8542445plz.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=r9v+WNw2DM30jQUaCFeqB7z5ZZP3ToFL4X1h2V6qfIE=;
        b=y3/bOhYZ+kxLTzWu4bxLB5/guvZlsI8GnnxnC4Qu2wtp5ppVANan2QLvXwzx9N5Mk6
         TymerH+l9lyDdIx//2PzqZuPpyJOi12NL81SCAXRnW/aASB8pJATjKPGrtFHMhT7sXkf
         Zn4i8MmRGilQfvaG1OglKI6qUs8D9TwgC/OpICMPUFiNpb5URnIfLC46Sw81ZaSzmEoW
         HAnyfrbCaz7er8kSx8rWzNUQ4+ZMtTbYZJFAgLlXUD2LYQYlaVfLyIfEdOQHTFKuZdF/
         3qtEu8Bbfo0/lo5MvQZqEIItLSk/WMWvute4Ii5fMGJyVGZ766JUlftPGvsLgXovDlv0
         6wIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=r9v+WNw2DM30jQUaCFeqB7z5ZZP3ToFL4X1h2V6qfIE=;
        b=hsMBEqjnFkXXFVq7kDJFBaWnVEVKdHR+t2Yog6S6ExqQB27wqq2QyXx7stWsv3+vLv
         WOqIe6IKlNa1VgwD1mxHXSV/0oHVcmHIqVfahqTPiN2lVVuUA49zHqnA5jtLgxJck+Pd
         A2sS0+PPtxPKd9mkMfQkmFTJp9b6joh6DmZAqq+Qc0+aKZbYxWSkt0Bk/lZrUHOhn0We
         jIlURyktEaEp+LdsxJ1x/zs6V+05XttMjjozm7V064FqXT6X2vZRDAXNv0sEmZdmnYa5
         T6sTz3qrTQgK2THnVHcGs8KP2OOtJVdmsKbV2StrhpvTINedoTHIFiNx38xakYxsfXS2
         ftjg==
X-Gm-Message-State: APjAAAXT3TY7T7OGKXZ3j68+p9upXVXI+nsPXpaDiZqWt97NsUz6vwvr
        Tybn9uuTPF69xWo8wnigldkl9IOpKnY=
X-Google-Smtp-Source: APXvYqz62+iCUJmm2mH0mpJofSeU9z97HTpouAHqiPIhq0odV0wYaEWQhLvhR8/aEyyWzUin+I79MA==
X-Received: by 2002:a17:902:3064:: with SMTP id u91mr27543500plb.244.1559060204824;
        Tue, 28 May 2019 09:16:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v23sm15591534pff.185.2019.05.28.09.16.44
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 09:16:44 -0700 (PDT)
Date:   Tue, 28 May 2019 09:16:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 203743] New: Networking goes down when running Docker and
 receiving fragmented IPv4 packets
Message-ID: <20190528091642.6be8af3e@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 28 May 2019 15:49:52 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203743] New: Networking goes down when running Docker and receiving fragmented IPv4 packets


https://bugzilla.kernel.org/show_bug.cgi?id=203743

            Bug ID: 203743
           Summary: Networking goes down when running Docker and receiving
                    fragmented IPv4 packets
           Product: Networking
           Version: 2.5
    Kernel Version: 4.15.0-1032-aws
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: camden.fullmer@boxcast.com
        Regression: No

We are experiencing an issue where our EC2 instances fail instance status
checks and completely lose networking because of cellular UDP traffic going to
an instance.

It seems that when sending UDP traffic using T-Mobile cellular the packets are
fragmented and causes the system to completely lose networking because of this.
I have attached the source code for the iOS app that can reliabily reproduce
this issue as well as the server code to receive the traffic. The packet
capture of the traffic is attached as well. Also important to note that the
system only drops networking when Docker is running, but the fragmentation also
happens no matter if Docker is installed or not.

It's also worth pointing out that when sending the traffic over Cellular to a
local network at our office that the traffic is not fragmented. This makes me
think that there is an issue with networking between T-Mobile and AWS.

Base AWS AMI: ami-0a313d6098716f372
Instance Types: g3.4xlarge or c5.2xlarge
Docker GitHub Issue: https://github.com/docker/for-linux/issues/672
iOS app: https://github.com/docker/for-linux/files/3192116/LockUpDemo.zip
Server app:https://github.com/docker/for-linux/files/3192118/main.c.zip
tcpdump capture:
https://github.com/docker/for-linux/files/3192155/capture.pcap.zip

-- 
You are receiving this mail because:
You are the assignee for the bug.
