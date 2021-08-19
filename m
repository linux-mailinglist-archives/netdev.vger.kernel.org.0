Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0CE3F1A2C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbhHSNSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhHSNSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:18:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C45CC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:18:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x10so9079254wrt.8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=uZBbRZ+KKC2xzTbSnl2sSazP2JG5bxY8f1y2TyEWlk4=;
        b=WAqQDndqctVywrG5ySro28T4DGm44S0PvwIXTnJHmODEBXbsOe1UHyBCD8pLd0Geqs
         xkaLNXJKLdpIA+cbr8KhMCiwrKSsS8oFynmrMZbF+or2a/uATFeTqe/tK4TfQ7OyasOp
         h14s+K7KeFWSPf1336EukWwM1DdHKCmI2oTXKIvi/axVoS1P77Hv8iJrACD3aokURM47
         jKZIVDPbi66K/73ubzES9pT2ex73+fjNgqyHmTsHMHqjLvp+gkPR9ZOaxgL6/X2itO16
         aPcfhZncx0sFfBldmnNGx7NA82fwLNGgJh7M6POD9ibGA+HemIHK62XDnQ+poSLfHuRz
         sXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=uZBbRZ+KKC2xzTbSnl2sSazP2JG5bxY8f1y2TyEWlk4=;
        b=RWcXCF4wuHjrpz7JFHngsFJuQmbvwGjBAb+kVdM0vpodwYpHFKvFoQhQhL+Y35CwbM
         Bdm22OnxPeiD2MX18hEWRDDrYXzMcExBSN99YMUqoJRINugZLIML6uT2FVkjj+w6SL02
         OD1tf4MshltKzPNOlXZlUnafaI2fAhgnjYvioUp4MNvZfge5IQcgcJUEoLE15J82GEPS
         rgiF52L2QVRtfNAW8uKQoV0f1fa9Ry8TXpedkBVv29Tw7ICCf/lMaH18T7Zt63tlVzcy
         a4QJX1VyxqvWaiG45Pdl8n8C9Z1AVh897KOx9gDzdYnYmOq2N0gjcvk3PYOXIqhISoO+
         ICvQ==
X-Gm-Message-State: AOAM5305f6pmAZj/+UOMtd8u3rKFz8O8fz1fdDSJw6uvjsglLLjzj+4P
        dNVFOzb8jLQuQg6gFeIsgBB419Z9en5QxQ==
X-Google-Smtp-Source: ABdhPJzRaYzxIWT6Njuo7TEioIKVYqse39MBGrqT95Bo/6cyfnRQy/MckbGxpsEGWEtR5/ganh6Drg==
X-Received: by 2002:adf:8102:: with SMTP id 2mr3722370wrm.89.1629379086891;
        Thu, 19 Aug 2021 06:18:06 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w9sm2480359wmc.19.2021.08.19.06.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:18:06 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     m-karicheri2@ti.com, ap420073@gmail.com, Arvid.Brodin@xdin.com,
        xiyou.wangcong@gmail.com, george.mccollister@gmail.com,
        marco.wenzel@a-eberle.de
Cc:     netdev@vger.kernel.org
Subject: HSR Addressing
Date:   Thu, 19 Aug 2021 15:18:04 +0200
Message-ID: <877dghmv3n.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

TL;DR: I am having a hard time squaring the kernel's implementation of
HSR with the spec (IEC 62439-3). Has anyone actually deployed this
successfully? Especially in rings containing RedBoxes.

The spec (5.6) says that:

    For the purpose of Duplicate Discard, a frame shall be identified
    by:

    - its source MAC address;
    - its sequence number.

And yet, the kernel seems to match HSR nodes using a {MAC_A, MAC_B}
tuple on ingress, and conversely sends each replicated HSR tagged frame
with the underlying port's MAC address as the SA (instead of the HSR
interface's ditto) on egress.

In a setup with only "DAN-H" nodes (~end-devices) the kernel can be made
to mostly behave, by manually configuring the MAC address of port A and
B to match that of the HSR interface.

But if you connect a "RedBox" (~HSR-to-80's-Ethernet-bridge) to the
ring, the kernel will associate a station behind that RedBox with a
tuple containing {station's real MAC, RedBox's MAC}, leading to
intermittent periods of (1) no traffic, (2) traffic, or (3) duplicated
traffic. This issue seems to stem from the kernel interpreting the
"RedBox TLV" in the supervision frame as the MAC used by the station to
send the replicated frames in the opposite direction.

It seems to me that...

- On egress, both HSR tagged replicas should be identical - with the
  exception of the PathId field.

- Supervision frames could use either the port MAC or the HSR
  interface's MAC in the Ethernet header, but the payload (TLV type 23)
  should always specify the HSR interface's MAC.

- Nodes should be identified by a single source address, no tuple
  matching. (But we should still record the RedBox MAC for debug
  purposes).

... OTOH, it seems highly unlikely that the implementation is this
broken and much more likely that I am mistaken. :)

Hoping someone can shed some light on this. Thanks!
