Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32A51A68AE
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbgDMPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 11:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbgDMPYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 11:24:09 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AC4C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 08:24:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x3so4364951pfp.7
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 08:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pDnsoq+NgG+FfYgtgqI6HdaHlh+P0iQJ6wwVtWLEX/I=;
        b=ijhxBumsU2t0ITEOTIxMJHtLBwFxAav4AEGuBTCGgx7+HL357W/rfDXbiuBoDwr+av
         UMO0KatlizReMg3GWo6+2wxy68kurgjmrFgrlvbVfctWOEmZbaYpwWjcLBkWMdNSgHhs
         PqSA6RkTD0iB7ZHJ5pt47zZDR+vrbtd2T51oqfmvXcZ1XcOlRtAzg4vntXELiX1yxREB
         QYjwEPf7lMARtR7pGlPQ/Toiz7sjgWJ/5/A5PVbh1RBkC4fQI+Uz/obOjpABfr5LSooS
         RLJDkxOVZZcTcXwUvdcg7/lM3+vMMNBbPeJuZKG6cB4kSC9PxuCFFqUhtUw/aiExhYsS
         8EOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pDnsoq+NgG+FfYgtgqI6HdaHlh+P0iQJ6wwVtWLEX/I=;
        b=ZgfCYCAnEiu60PQa2iLyltD+pN8bnF+YWzMHfGgvFlvXoUw04c8pAXZAFZhWmKvAuf
         E2J2blGAIJRT52fxMe+P2jfrieVhgD2HcrGcOZyFxbjzXc4XBLKU7j4nuC/1tNJCmytB
         tlE8tY/5fIN9rDma4TNLrh0RbmCPZWYvCxMrg5OgIQK0FMkBIcLbX2BnoNAQ2LaFsnD7
         2mTm+fhbdlWsg1jwHThELiJwQuKt/msioO/Ulxylgj0JnLoj9lb3wntDGSwUQIk2iQp3
         v+D0NGcmA1b/FM8tl9C/t4BCqR7GrWYD5ZCc83Rse6kuaV9jeR5kP5mi5Y7Kq2l/ySGl
         M8wA==
X-Gm-Message-State: AGi0PuY/7JdWD52yJCuGv1rXhM4l7FU9/N6QcxbnGeJnsGjN39D7ZlP4
        6pD4h9f6/yUgoPlxDL0ej+SC7xv1g5YrPA==
X-Google-Smtp-Source: APiQypIjnj2gpq1OlubcLn1VWGXBbcBWfWSyQ8AFIq0bIiPVV+plwtdo89gwYHD355BrRf1I/4H0JQ==
X-Received: by 2002:a63:d74e:: with SMTP id w14mr17090780pgi.157.1586791448769;
        Mon, 13 Apr 2020 08:24:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o15sm9523885pjp.41.2020.04.13.08.24.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 08:24:08 -0700 (PDT)
Date:   Mon, 13 Apr 2020 08:24:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 207225] New: Malformed headroom in umem request of XDP
 socket could lead to out of bound write
Message-ID: <20200413082405.70164089@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 13 Apr 2020 14:27:36 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 207225] New: Malformed headroom in umem request of XDP socket could lead to out of bound write


https://bugzilla.kernel.org/show_bug.cgi?id=207225

            Bug ID: 207225
           Summary: Malformed headroom in umem request of XDP socket could
                    lead to out of bound write
           Product: Networking
           Version: 2.5
    Kernel Version: 5.5.11, 5.5.17, 5.7-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: minhquangbui99@gmail.com
        Regression: No

Created attachment 288417
  --> https://bugzilla.kernel.org/attachment.cgi?id=288417&action=edit  
POC registers malformed headroom in umem registration

- When user calls setsockopt to register umem ring on XDP socket, the headroom
can be a big unsigned 32 bit number, which leads to
   + This check in xdp_umem_reg function (net/xdp/xdp_umem.c) is bypassed
   size_chk = chunk_size - headroom - XDP_PACKET_HEADROOM;
   if (size_chk < 0)
        return -EINVAL;
   + This initialization in the same function, the chunk_size_nohr becomes
larger than actual size
   umem->chunk_size_nohr = chunk_size - headroom; 

- Consequence: I see that the chunk_size_nohr is used to check that the
xdp_buff can fit into the chunk in xsk receive functions; with this malformed
chunk_size_nohr, we can put a larger than chunk size xdp_buff to chunk, leads
to an out of bound write. However, I research some more and find that to
trigger to receive functions, we must redirect the packets from XDP program
using xskmap which requires CAP_NET_ADMIN capability, which makes this very low
impact.

- Unfortunately, I cannot trigger xsk receive functions (I am new to Linux
kernel) due to some error when binding XDP program to an interface. I can only
prove the register side, the initialization of chunk_size_nohr via debugging. I
attached the POC of malformed headroom umem register below, which I tested on
kernel 5.5.11. The POC needs to be run with root privilege (or a user with
CAP_NET_RAW, this could be achieve with new user namespace on kernel with
CONFIG_USER_NS=y, however, as far as I know, next phases when allocate xskmap,
CAP_NET_ADMIN is required and user namespace is not permitted).

Thank you very much for reviewing this report

-- 
You are receiving this mail because:
You are the assignee for the bug.
