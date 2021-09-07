Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8C8402EC8
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345652AbhIGTMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345447AbhIGTMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:12:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060D7C061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:10:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d5so25616pjx.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 12:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/nPXGPRAfaCXf0nR8/Eng9E9GMZUz3p5fGW1HMdkp4A=;
        b=lljpafn1w1rg990PciwxI7szMCPztUeZNN0S6lur8f5F7qrDsh2H18vsEw4UYwGjxJ
         yf8PQaGqFKXftkDSClnZ8j1I/E0wQ/83ExZXp5D9Oidahpt2LlZoi80GGVmsNCrUiqb/
         MJ0WGSuVBvcllRqVcDA861dtsdhmyEf7X7/r2Zzh4GNve6w/fNyBmlHyDKLgz3EjeaMo
         IrM11JsYg5qxM6eR7zUqJ2zhWxKJbI5S/FEIrTSxDWjEqbzbRs4Pzu4y6NmF9w0ckpny
         M5ZJMtG6qDeSAroq+gXxxCbYONdMy6if/qi0st8J2VxGw1cxovKRCxU7O8QGey8rTnIf
         bMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=/nPXGPRAfaCXf0nR8/Eng9E9GMZUz3p5fGW1HMdkp4A=;
        b=OSLhmBTdGvH57gf1uKv37njKi7ZNk5rzlJw5GY8ZcnaejaP0kNPdbnwAmf3Noww/sT
         97ijIYAT2iKhyx+EH5u+hia2OVtiGPxsOEHwXvcXEkgFPcmdfeP4sB8TTCeTSqiU9TNS
         8R6rwHqyx84xQqIW+foXJpeGUufd6RvfgzDnnTVwYSpfW5wpfFSyGbFbleW6GewXifFN
         j3wOmlBd9K5MAjjlg1eBXUghXvBIy0W9szRbB6bU5DdzL1m6YwdveYZs+VqDeUwvZel4
         7IJjpEb2W1LGWnptoyULoaUcvmyt1wmhjtqWpdNyzIt06FdzGVIf+TjdNQGuFP3CKset
         D2sQ==
X-Gm-Message-State: AOAM531iyKM5TEV4i4zyI+hCCwDo63SoFJpoaotW4jR2oPmuTWj+jNWH
        UDm6LoSkEurgcmaug8zzQsQ+d1LfO51YqA==
X-Google-Smtp-Source: ABdhPJxNrAoFfW7jw8sMIwEfeeNJK0dAu+TdM+GKwFvkSbfRV+6bsDLmUlJFhD3fJTvW1WBBUgytPA==
X-Received: by 2002:a17:90a:f2c4:: with SMTP id gt4mr6119584pjb.219.1631041855025;
        Tue, 07 Sep 2021 12:10:55 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id l14sm3400810pjq.13.2021.09.07.12.10.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 12:10:54 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:10:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214339] New: sendmsg return value may be positive while
 send errors
Message-ID: <20210907121052.75cb416d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 07 Sep 2021 09:23:54 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214339] New: sendmsg return value may be positive while send errors


https://bugzilla.kernel.org/show_bug.cgi?id=214339

            Bug ID: 214339
           Summary: sendmsg return value may be positive while send errors
           Product: Networking
           Version: 2.5
    Kernel Version: 4.9.99
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: 1031265646@qq.com
        Regression: No

in file udp.c, a function named udp_sendmsg has a code like this:

        /* Lockless fast path for the non-corking case. */
        if (!corkreq) {
                skb = ip_make_skb(sk, fl4, getfrag, msg, ulen,
                                  sizeof(struct udphdr), &ipc, &rt,
                                  msg->msg_flags);
                err = PTR_ERR(skb);
                if (!IS_ERR_OR_NULL(skb))
                        err = udp_send_skb(skb, fl4);
                goto out;
        }

but function ip_make_skb may return a null, then err will be set to 0;and out
like this:

out:
        ip_rt_put(rt);
        if (free)
                kfree(ipc.opt);
        if (!err)
                return len;  // return a positive value

actually, because lock of kernel memory or socket_buffer,the ip_make_skb failed
means the send operation failed. but a positive value is returnd here.
finnally, users regard the operation was success, but actually it failed in
kernel.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
