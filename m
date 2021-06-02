Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806E8397E32
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhFBBoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhFBBog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:44:36 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190A6C061574;
        Tue,  1 Jun 2021 18:42:53 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id x6so1516470ybl.9;
        Tue, 01 Jun 2021 18:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fNWp9/rN38E/C2OofAUlt+GU6ZGGQ1oJlQzk0xa0JZ8=;
        b=H+TDw2dW8cTYgZIXRcip+fFoUwIam48rb5Sk1Z20gBoXBigas3nnZBwim6XPTf2Fx7
         5KHHCVKBitj1PlZsljC1YEtI7FB87eDI13Pt6tedK3NSRZSEaQfuuO16cUwFO3PIzTZW
         1RS80swbCIYHi/AA9VsiMN/9clzzsMh9HFzVPaU7kJkRLjanJUVLc3Ii5poa2S4D/TZ2
         4X6qPa0VtmKqQHnNZ1QftJervhRfSGsS1MVMvpDUlY+OjXZPGWoLRKrHWFOu5I+HG/DQ
         DtqW5kCogp/ZX9uW4rJ1DyBuGmkXMq7C9VMtlfoV1Pq1cvCYISwAUjfPSANSgDidlDuj
         E3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fNWp9/rN38E/C2OofAUlt+GU6ZGGQ1oJlQzk0xa0JZ8=;
        b=SHRLLLPu2gfvb8BiOU5cb9m0vcoN1bHdqvvkLENtVtRyd4eAQN/oXz00POY/rE6Za9
         RxJ9bGIIxIVtoAIJ85Li1R3xVdbGL9LsuqzF2MWah81wZTmMabzTuPjTXC8OVYBFGx+c
         aLAVbyXP65o6YpttXxrZksleNxnB3jMMy9KvsOxbRUmQ//iNkDL6Dma2eLc/wFUPnA/X
         UZJIlaTLG/WMONjZDzosWJO/tCRiGHhNhI5ZCVHScDkSalMMFHYCA+qouFrAlyCewwmE
         IsJVJZeSovl6ys/wr2SYQSxTCdJzlvBD0hUPFgkAxrnH7sTMO9HO5PZuepbainl7ofZx
         X9tQ==
X-Gm-Message-State: AOAM532njjUBQ7fsShpt6H+oZHWVbFu8enVxJUZPNv5DRhFgn/ST2qve
        AF2LOD9G4IWYmSZKKW8dnRV+7+2R1kVR4YGsUJI=
X-Google-Smtp-Source: ABdhPJxLBl75Zu8Q9Cbj35joIKtd8NkdymJ7r6HtohGG6YT/qn+H0rHjHlncHewERnQBNqTLEO5f3oGDnOLUjPyj5CQ=
X-Received: by 2002:a25:ced4:: with SMTP id x203mr6401940ybe.354.1622598172279;
 Tue, 01 Jun 2021 18:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210601080538.71036-1-johannes@sipsolutions.net> <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
In-Reply-To: <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 2 Jun 2021 04:42:41 +0300
Message-ID: <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com>
Subject: Re: [RFC 3/4] wwan: add interface creation support
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com, Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Johannes and Loic,

On Tue, Jun 1, 2021 at 11:07 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> Add support to create (and destroy) interfaces via a new
> rtnetlink kind "wwan". The responsible driver has to use
> the new wwan_register_ops() to make this possible.

Wow, this is a perfect solution! I just could not help but praise this
proposal :)

When researching the latest WWAN device drivers and related
discussions, I began to assume that implementing the netdev management
API without the dummy (no-op) netdev is only possible using genetlink.
But this usage of a regular device specified by its name as a parent
for netdev creation is so natural and clear that I believe in RTNL
again.

Let me place my 2 cents. Maybe the parent device attribute should be
made generic? E.g. call it IFLA_PARENT_DEV_NAME, with usage semantics
similar to the IFLA_LINK attribute for VLAN interfaces. The case when
a user needs to create a netdev on behalf of a regular device is not
WWAN specific, IMHO. So, other drivers could benefit from such
attribute too. To be honest, I can not recall any driver that could
immediately start using such attribute, but the situation with the
need for such attribute seems to be quite common.

-- 
Sergey
