Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36EA2F6E84
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbhANWqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbhANWqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 17:46:05 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B172C061575
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 14:45:25 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id a188so4241902pfa.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 14:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=nQe2N+VoeVYtpu1Dp+8T8TkhRoAjia9a97fFrvbWLcE=;
        b=aMG8Tpz6L4h59JsM/09H81/4s6ay1lIYiRxrYvHRn3IGeJvVBfijLspHUJChKoWDt6
         uyWO9mYf3+JbdIWwfX22oDLuAZOCT3XnhRf/cA8F6B9ZFXRK+zwYKVOTpeJ4jsk0CfCA
         4dDQFB6IQxwecN0LR/x7FIpoYcLVWVA0iOFeq4L1dlZaTe4KxWBqUr8odnBkDGlDfiV2
         YbUT847pXbjxBrjC6va+1EzwOikhrsAx/F9kXIS+7KOD0+CVMeGJrY2T64y3WdLzdCt5
         W4kq8iJLDjYu+ZO07AakxoNgA4jBWQjQalAapppw8RTnbCBUXq7ThGJXyOBlDCtROO3n
         oUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=nQe2N+VoeVYtpu1Dp+8T8TkhRoAjia9a97fFrvbWLcE=;
        b=ltnK2tyrtv9h59HCR5+MQiqoKA6hBNv3Lg4EfuKRu+J+uRsNRniU/+eBMRvLC4pxkM
         1zXsZjaENqjKaDF4h0KZDmrKBaMnyGKacHQEUeFdD+zVJnd8cS/YCxG1W2QVfB+1pCcM
         IJYD8GTz2lU2Cjp1ZXS5zz+ZpumslVEP4kHK7q3BVKUUCw9rcUe/sabaI26/iGR8ZDL2
         a93XAaVxI1l0IEIHmOpaSrO56TW6uwsD1TDlLWqkE1t09zBMqK0J63Kn41OJr0vveu48
         tsSMxk+n9PHZnvKmiIhg+Hv9E9ZPlKnswZTuwLfvx8IhTBfYm+Z7+oeuidKnjaROhzTo
         VPcQ==
X-Gm-Message-State: AOAM533JIUlQI8hsfU3TBeH0IH7mFetpzEizsRuwcKJsQQ8T+H36J2aK
        ADZhqtq0+X0ddO/B3nDKZqCKSch1lMFceg==
X-Google-Smtp-Source: ABdhPJwb7870C9rf31lAHLjvgM9Vm12pdkBRYtLG5Pq+4RWCjxks8yHdL/kg0ikaMc72SEXsHc0d5A==
X-Received: by 2002:a65:689a:: with SMTP id e26mr9682234pgt.413.1610664324443;
        Thu, 14 Jan 2021 14:45:24 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p8sm6121241pjo.21.2021.01.14.14.45.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 14:45:24 -0800 (PST)
Date:   Thu, 14 Jan 2021 14:45:21 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 211175] New: gretap does not fragment packets regardless
 of the DF flag
Message-ID: <20210114144521.7c44b632@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 13 Jan 2021 13:37:33 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 211175] New: gretap does not fragment packets regardless of the DF flag


https://bugzilla.kernel.org/show_bug.cgi?id=211175

            Bug ID: 211175
           Summary: gretap does not fragment packets regardless of the DF
                    flag
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: pupilla@hotmail.com
        Regression: No

Hello everyone,

I'm running linux 5.10.4 with iproute-5.10 on Slackware (64bit).

When I try to configure a gretap device with the "ignore-df" I getting this
error: 

ip link add testgre type gretap remote 10.42.44.6 local 10.86.44.6 ignore-df
RTNETLINK answers: Invalid argument

Instead, if I try to run the following command it is going to be executed:
ip link add testgre type gretap remote 10.42.44.6 local 10.86.44.6 noignore-df

Also I have noticed that the icmp datagrams with the DF=none are not fragmented
anyway.
For example this is a tcpdump capture showing a 1459 bytes lenght icmp packet
that is not going to be fragmented and delivered to the other remote gretap
linux box (running the same kernel version).

ethertype 802.1Q (0x8100), length 1477: vlan 802, p 0, ethertype IPv4, (flags
[none], proto ICMP (1), length 1459)
    192.168.1.247 > 192.168.1.1: ICMP echo request, id 10287, seq 0, length
1439


Is this expected?


This is my full gretap setup: eth0 mtu is 1500 bytes.

ip link add testgre type gretap remote 10.42.44.6 local 10.86.44.6
ip link set testgre up
ip link set eth0 up


ip link add name br0 type bridge
ip link set br0 up

ip link set testgre master br0
ip link set eth0 master br0


and this my 'ip a s' output:

13: testgre@NONE: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1462 qdisc pfifo_fast
master br0 state UNKNOWN group default qlen 1000
    link/ether 5e:56:0a:0c:12:f0 brd ff:ff:ff:ff:ff:ff
14: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1462 qdisc noqueue state UP
group default qlen 1000
    link/ether 5e:56:0a:0c:12:f0 brd ff:ff:ff:ff:ff:ff

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
