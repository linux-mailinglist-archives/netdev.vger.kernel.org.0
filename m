Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67413B46BA
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFYPjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhFYPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:38:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773CDC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:36:36 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v7so7890018pgl.2
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Q48+8/zBPx4T9aYN64WgheNQyajMIdAuDo9+C5se/CU=;
        b=O7+1sH7/ZQp7rnBKEChvHh2n5H092A5QHvhOd/umYQeDgMPQBdkYrXCaeoooZgdcfb
         ct3Q3a8t9un70yOp67sliKFSTQe5JjSqi3M0MPy9Ku5SiihrKGm/Rm9dy3r4djHmLTN9
         sQ0klPnWVNV8MOD2uh7v+N1RkLFy3Ig+A+Jbmsh4O1pAQhUauSGpF5VWkD7eeSvJB8yt
         iVBbY/uE8h0RF2C/92Fna+U1qmayGhhO7xDpwwrqOaSWWofwhRcWu4cbpjmuB8wT54KN
         LcZMk/OXkTWKoRj2lhb/of74KRokcOHy4FPHbS2PdIlCTVACG90fT0KTSFWC7WLQ4Rni
         C2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Q48+8/zBPx4T9aYN64WgheNQyajMIdAuDo9+C5se/CU=;
        b=OoxSmQ3cJ8vvXYdtT6qVh8ppxDMMKh5Fai4R/MuZ1VgKIdNgGjtGSwod5SNKmiFj+x
         RE2gmV+YOfXgnKnqkvzyO3zPXLOCwMI8m3pYs906eNg8eiA/S+VGmYyCCa9jTDAReUJl
         QHe+a5x7GiKmqONeb3oZe40f9ragC9oSzUE4DpS4BM7ufINyRJWnFu1cMnHbONCjjnWH
         FOpk9hDSj1l93YdO5UCu3w7sOYdVNRO61SD42joiElUZAJoEyeVAvEcIhFyrFdmCDoAU
         4ZJ5DP147pKDTOQERsf2pcne/VLZNCMQn9NAqzY8z+Dt21ScAojIWAPB+V3dVTbvrs4I
         X26Q==
X-Gm-Message-State: AOAM53282FGLvWXgQXavRkGcEI3f/gfwPUX5RdahOSC+vtQlDDx7PbXO
        aHSHIJLkcCboObviN2BQ9tHb/nFvqlihzA==
X-Google-Smtp-Source: ABdhPJz09pc0jv6fdVlaWb8ryuJ7tvxGIBpLqrxqoerjYXtFVtmzIJoN41jg4ylmxrvsY06n4gvYYw==
X-Received: by 2002:a62:7d81:0:b029:2f1:b41b:21cd with SMTP id y123-20020a627d810000b02902f1b41b21cdmr6498594pfc.41.1624635395482;
        Fri, 25 Jun 2021 08:36:35 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id p1sm5963891pfp.137.2021.06.25.08.36.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:36:35 -0700 (PDT)
Date:   Fri, 25 Jun 2021 08:36:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213581] New: Change in ip_dst_mtu_maybe_forward() breaks
 WebRTC connections
Message-ID: <20210625083632.5a321cef@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 25 Jun 2021 11:54:19 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213581] New: Change in ip_dst_mtu_maybe_forward() breaks WebRTC connections


https://bugzilla.kernel.org/show_bug.cgi?id=213581

            Bug ID: 213581
           Summary: Change in ip_dst_mtu_maybe_forward() breaks WebRTC
                    connections
           Product: Networking
           Version: 2.5
    Kernel Version: 5.13.0-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: godlike64@gmail.com
        Regression: No

Recent Linux kernel versions (>=5.9 if my calculations are correct), when used
as a gateway on a LAN (or a similar setup) will break WebRTC protocols such as
Google Meet, Discord, etc. (have not done extensive testing but would gather
that most similar protocols are affected). In the case of Meet, no video for
any participant is ever shown (other than my own), and nobody can see my video,
although audio does work. In the case of Discord, no audio/video for other
participants is ever shown. Note that every meeting is initiated or joined from
inside the LAN, not on the gateway itself.

Using plain iptables, firewalld+iptables or firewalld+nftables makes no
difference (it was the first thing I tried). I discovered this a few months ago
when updating the kernel, and found that reverting to the previous kernel made
this work again. I didn't look further into it until now, when I can no longer
stay on that old of a kernel :).

Using git-bisect I was able to identify the offending commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0

This patch was backported to linux-stable shortly after 5.4.72 released. It
appears to still be there in vanilla upstream. I can confirm that reverting
this patch in 5.4.109 fixes the issue and webrtc works again.

I have also reverted this patch in 5.13.0-rc7 and WebRTC works with the patch
reverted. Without reverting the patch, it's broken.

No other protocol/connection seems to be affected.

Reproducible: Always

Steps to Reproduce:
1. Install any kernel >5.4.9 on a gateway device.
2. Try to use a conferencing application that uses WebRTC (Meet, Discord, etc).
Either start or join a meeting from a device that sits in the LAN.
Actual Results:  
Audio and/or video does not work when a meeting is initiated/joined from within
the LAN

Expected Results:  
Both audio and video should work when inside the meeting.

My C is quite limited, but it appears that this function, from wherever it gets
called, returns a different value after the mentioned commit. It used to
return:

return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);

Now it returns:

mtu = dst_metric_raw(dst, RTAX_MTU);
if (mtu)
    return mtu;

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
