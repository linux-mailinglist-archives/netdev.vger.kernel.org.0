Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519DAFE2A0
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKOQVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:21:44 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36042 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfKOQVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:21:44 -0500
Received: by mail-pl1-f195.google.com with SMTP id d7so4987909pls.3
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 08:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=OYmFxajnZL2hCQB5jhZNhHYe7yih/5jmWTVHtfnmcOE=;
        b=KziJPBmcyB5fcJZDzkdonjvGFuRjrNt9q6fzs2iG3PH81kF6TimNNvRJZXdlnvQCCI
         zhmQuY/Gq5oVBJi5QX4iAW+5JKPUxBLBZpNNktfMFaPcFasoWE5sVZTvngK2LZB/59wZ
         TVwBFxH9HT4e2am4wRdq/PsxRjz65m2xcG26pxtVJ3hf/PqbgPaZPacqLAyKSmVvipf0
         3LB0pmh7vutiK2nzAdDe7mn7qYCMmrYbOdIpZUffLOSw8NLpiUcahW0p4fEVKmHRmvCa
         QR7OD4Gi8OHzcoxKSZgEq33t/OvvGNWIAunleSMiOFzL54czaCILh+yCZU5hnoWXeasy
         mkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=OYmFxajnZL2hCQB5jhZNhHYe7yih/5jmWTVHtfnmcOE=;
        b=khJ8wl/WG+AOvyB069kd3raF8UjU7VdOUK/jXTl0nHUhH422QHDhDozeh54H8hV47s
         t+zTe8sg+400sNfIvpRcMxYv2y2jApz33OqomvBDpjO0ToNjXGoSqVOSUugQjBOdmXja
         XbXuvSPFbs963mbqGcYqjTd5MRBWWbAuMokQbhb0DOMPHxlornXo+yZS1u8gRiCATceE
         lhypbMKlPi9QwkN110PAtoUroGjSeNJtTC02BlwCeM7E3bNLV1dNRKTv65Z/P+XGm632
         bYdOJFhUrXXA/UgoY53BqXrFYcE9qIT4Fz+WpXmi3sDxY8xuhDVEGG9X5fo05KKyqZgE
         xlNw==
X-Gm-Message-State: APjAAAVK7PZKUCjonvD+NWWIYvU5dX0iy+V4QCsEOCaQslRJHaT+XT4w
        04j11UOyaUY+68ckwwC7WYFVF70ILcH5qQ==
X-Google-Smtp-Source: APXvYqxbyuO89iBr7b1tevBdFYES+pUOSxexW+UlzNDHSnmCXDZo+GQ9+3an45yobIcq2i/FlAdFOA==
X-Received: by 2002:a17:902:7292:: with SMTP id d18mr5798126pll.206.1573834901593;
        Fri, 15 Nov 2019 08:21:41 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u24sm9811884pgf.6.2019.11.15.08.21.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 08:21:41 -0800 (PST)
Date:   Fri, 15 Nov 2019 08:21:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205533] New: The flexcan/socketcan driver does not block
 and returns an error if all buffers are in use on transmit.
Message-ID: <20191115082136.70074fd0@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 14 Nov 2019 17:10:29 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205533] New: The flexcan/socketcan driver does not block and returns an error if all buffers are in use on transmit.


https://bugzilla.kernel.org/show_bug.cgi?id=205533

            Bug ID: 205533
           Summary: The flexcan/socketcan driver does not block and
                    returns an error if all buffers are in use on
                    transmit.
           Product: Networking
           Version: 2.5
    Kernel Version: 4.14.149
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: brian.j.cody@gmail.com
        Regression: No

When the output buffer is saturated, even if the socket is set up for blocking
use, a "write" to the CAN socket may result in a -1 return value with errno set
to 105 (ENOBUFS).

The socket is created using socket(PF_CAN, SOCK_RAW, CAN_RAW). SO_SNDBUF is set
to 2240. fcntl is used to disable O_NONBLOCK.

I see the error case after "many" sends. In this situation three separate
processes are sharing the CAN bus on the local processor. The error only occurs
when all processes are heavily using the bus (set at 1 MHz), and there does not
appear to be a normal re-entrancy issue with the driver.

-- 
You are receiving this mail because:
You are the assignee for the bug.
