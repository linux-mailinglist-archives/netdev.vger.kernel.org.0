Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFEA1B3715
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDVGBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDVGBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 02:01:41 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8692C03C1A6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 23:01:40 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id j4so1090650otr.11
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 23:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B4X6Wl2vhyTh+fWJF2DvDT914oag6V4/v305cxg0mr4=;
        b=t1oyVd+RPlx7TXHksyQOzbeuw9x7wi//Ygm83/UevyITpYW3G8N0JCat0TQUYbhi9c
         oL5Q0HsGGQLBkaGG4Rdi/uUpg6zfnRuRdlpVgN0aAqC3PH7iBsE4OKuLtUFIib7fK4eU
         I7tCduulbvFXljrn/6DuAGSJfgckQcbY88WNlR4T0g+XXZvNh77SkjeHG0ldtiuvF+eK
         +3a/f6nKCgCP2qqemkGxJ400cDYsv+WxUtozcZcPp5X+UFNYr9cp8hNBowVg9BxPtgyK
         WKCWCaczNLsF1vXXHpuYRD3XF7g4ysGpgBnlDc2uDS7xyrmYTDfWi76lfZW4W8ZbRZ0q
         mUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4X6Wl2vhyTh+fWJF2DvDT914oag6V4/v305cxg0mr4=;
        b=kWKMBaNYfQhKcxBjFeD5cg4+Cse742Z3foiVtep/P2NOsNbwlgF4GHNynru1/EQRUP
         njzdT386EgnJUHlwWAnk3Nox+EwDeeneTzoagMYXqcnzlu+UQ8AkV5hbqn8ieqqTqBd+
         rilrX88EWmQDpbpzEt02cI6X9zHlZ0sONp/ndT5k8q+Hko8rDl3qX8koVnM606aSO5vx
         FPOEjmjwyqrgorfYq/YcdXNTGisJ/VdStmJ/ZsxzuowLyP7T9vJVSqK8H+Lb9wQ18SNv
         Ki+Y9aVANla4A6YlD26YVlJuxHvazh/gcbcwgF5AMvdicly4qGlptRL4YFv+ifF5a+sF
         OZAg==
X-Gm-Message-State: AGi0PuY+xPz7zYwFvV0dE/vbRUDgqijnMDbyx6HSgpaEio030zB8DV1Z
        vlk8f+SjUBeRAIQo8SK0CFKlPnJOpbS2b6rbXdA=
X-Google-Smtp-Source: APiQypKvUeZB7xUCDrqGfHVWS50bx9VEY4ePxXOLGzjs3wc+vPD674hy9Pwa3Q04bQK/1Z5wDLK6QCupWcVXYuQdgaM=
X-Received: by 2002:a9d:2c61:: with SMTP id f88mr2799730otb.86.1587535300252;
 Tue, 21 Apr 2020 23:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200419161946.19984-1-dqfext@gmail.com> <20200419164251.GM836632@lunn.ch>
 <CALW65jYmcZJoP_i5=bgeWpcibzOmEPne3mHyBngE5bTiOZreDw@mail.gmail.com> <20200420133111.GL785713@lunn.ch>
In-Reply-To: <20200420133111.GL785713@lunn.ch>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Wed, 22 Apr 2020 14:01:28 +0800
Message-ID: <CAJsYDVLZQ=ci1wp1_P0RcwsV8z27zMn4CPHHpueDF7OZ-X9aEg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: bridge: fix client roaming from DSA
 user port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     DENG Qingfang <dqfext@gmail.com>, netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Tue, Apr 21, 2020 at 12:36 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> The MAC address needs to move, no argument there. But what are the
> mechanisms which cause this. Is learning sufficient, or does DSA need
> to take an active role?

cpu port learning will break switch operation if for whatever reason
we want to disable bridge offloading (e.g. ebtables?). In this case
a packet received from cpu port need to be sent back through
cpu port to another switch port, and the switch will learn from this
packet incorrectly.

If we want cpu port learning to kick in, we need to make sure that:
1. When bridge offload is enabled, the switch takes care of packet
    flooding on switch ports itself, instead of flooding with software
    bridge.
2. Software bridge shouldn't forward any packet between ports
    on the same switch.
3. cpu port learning should only be enabled when bridge
    offloading is used.

Otherwise we need to manually sync fdb between software bridge
and switch, specifically we need to take over fdb management
on cpu port and tell the switch what devices are on the software
bridge port side.

I haven't read kernel bridge code thoroughly and have no idea
which one is better/easier.

Some switches (e.g. mt753x) have an option to forward packets
with unknown destination port to cpu port only, instead of flooding.
For this type of switch, the solution proposed in this patch is fine,
because removing fdb entries has the same effect as telling switch
that a device is on cpu port. If there's a switch without this feature,
(which I have no idea if it exists) there will be issues on packet
flooding behavior.

>
> Forget about DSA for the moment. How does this work for two normal
> bridges? Is the flow of unicast packets sufficient? Does it requires a
> broadcast packet from the device after it moves?

It doesn't have to be a broadcast packet but it needs a packet to go
through both bridges.

Say we have bridge A and bridge B, port A1 and B1 are connected
together and a device is on port A2 first:
Bridge A knows that this device is on port A2 and will forward traffic
through A1 to B1 if needed. Bridge B sees these packets and knows
device is on port B1.
When the device move from A2 to B2, B updates its fdb and if a
packet reaches A, A will update its fdb too.

The problem addressed in this patch is that switch doesn't update
its fdb when a device moves from switch to software bridge, because
cpu port learning is disabled.

-- 
Regards,
Chuanhong Guo
