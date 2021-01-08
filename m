Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925812EF569
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbhAHQC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbhAHQC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:02:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1FEC0612A9
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:01:01 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b8so5892917plx.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=M8Rv9xIHHWQZiSRsl9kSCfZ8Wa1cX8tGRJiAZxK09IA=;
        b=sxSW2CXel8F4f8/uDFD2qZ6qrAD2AzKnh0Jq5YPJxQm3s/FIg73tdfNMTAzt/NCJaw
         06kjjx2AvT98AKvUTVy/aLVzLCUTW7dDwdTWv/wTLKaKHDq0Ztsj+TgCa6J5j17zzVXF
         WsidZU6EWkZAm/HVaqvvzGaru47vaPViVwIjVM+2qokXlRJ4iPeRC5EZ77UD0Vi8gy7y
         bfLQ5GJQ4OGIpWcOlOvu+yF189Ra/ufj6yg4123nTRmQnPS6zMf+sM5ICB0TMgrOosUe
         5/AfUCB/XXbYYa7eiBmi1mnBa2fEoU7oOv6MD/I0PfH8E5vn4s4Wrx8BUShE5YXEp2nd
         pZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=M8Rv9xIHHWQZiSRsl9kSCfZ8Wa1cX8tGRJiAZxK09IA=;
        b=XgWrJb5mLw1fsC4+dE0A5Znq+aYy26oWxow3n3itSPvkPpgnjFGtXjgEBns0rjB5mx
         csph9X1T+Nsra3XjBMagV0ChMCKRTQQWhkruhehtG+2djzTnMwanRVFi1egWzNmLUmBr
         k2YH3wqipUhgR5KTOpyIrzf870d6yTUiVN6Zr5m+X4zvELFoCP8ZAe/zITaWOBRD8+hy
         SzfqX3Alm9l5SlVBdsZKQdHbl71NdCF3whHqtlC/xxtMABdAqa51GPK6hUaJj4bU7tq1
         WO0sdEKP3pJevqK044mZ323zQZh6zQZOEo0rTI2DWaEjKpcgJg8nkCI5NDXDj4z3ABDP
         i02w==
X-Gm-Message-State: AOAM531rvoaHuYXewiZq3ZEJsTfdaMBmIqgK/lVbqmobZv5daPQR2BNB
        +t2uP4ycQr2IoEVOGRU30Ejzbm7dfwYHfQ==
X-Google-Smtp-Source: ABdhPJz4u9kM4KD6KTnkYe5sKUGdKAZsjn2Yz2FEjZ5dEeIVMAv0cCy9HoHZ+IzRrNlsUnkEoUySeg==
X-Received: by 2002:a17:90a:a394:: with SMTP id x20mr4264886pjp.24.1610121660582;
        Fri, 08 Jan 2021 08:01:00 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c23sm10722475pgc.72.2021.01.08.08.00.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:01:00 -0800 (PST)
Date:   Fri, 8 Jan 2021 08:00:46 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 211085] New: No response from TCP connection in ESTALISHED
 state if sending data segment with unacceptable ACK
Message-ID: <20210108080046.014d6924@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks like a case where some conformance test is testing a corner case in
the standard where the Linux TCP stack is not following the standard for valid reasons.
Linux behavior of silently dropping the packet would reduce DoS changes and information
leakage for MiTM attacks.

Begin forwarded message:

Date: Fri, 08 Jan 2021 08:17:40 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 211085] New: No response from TCP connection in ESTALISHED state if sending data segment with unacceptable ACK


https://bugzilla.kernel.org/show_bug.cgi?id=211085

            Bug ID: 211085
           Summary: No response from TCP connection in ESTALISHED state if
                    sending data segment with unacceptable ACK
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.24 and upstream
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: alex.thresher@googlemail.com
        Regression: No

We're currently failing to pass the TCP_UNACCEPTABLE_04 test from TCP/IP tests
of TC8 ECU and Network Test specification (Open Alliance). The Test
specification is freely available on the Internet.
TCP_UNACCEPTABLE_04 validates the behavior of RFC793 'Chapter 3.4. 
Establishing a connection / Reset Generation (3)' (Page 36) and 'Chapter 9 -
Event Processing / SEGMENT ARRIVES / Otherwise / Check ACK field' (Page 71) 
which pointed out that sending an unacceptable ACK in ESTALISHED state for
example ACK acks a data segment not yet sent should be answered with an ACK
(from RFC793 - '...must elicit only an empty acknowledgment segment containing 
the current send-sequence number and an acknowledgment indicating the next
sequence number expected to be received...'). After that the segment needs to
be discarded. 
Unfortunately the segment is only discarded and not confirmed by ACK. I did
some research in the TCP/IP stack and found the code which is responsible for
discarding the ACK. 
It's in 'net/ipv4/tcp_input.c' in function tcp_ack currently on line 3727 of
upstream kernel.

>>/* If the ack includes data we haven't sent yet, discard
>> * this segment (RFC793 Section 3.9).
>> */
>>if (after(ack, tp->snd_nxt))
>>        return -1;  

Validation was done on DUT target with Kernel 5.4.24.

Let me if you need further informations.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
