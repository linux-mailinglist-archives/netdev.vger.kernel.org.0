Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD381B1A20
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgDTX1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgDTX1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:27:12 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D5AC061A0E;
        Mon, 20 Apr 2020 16:27:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t12so5514701edw.3;
        Mon, 20 Apr 2020 16:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3M4SYzoNkYiYC3QIIg1ugPDREve6hEzigXCOJVjW3w=;
        b=T66TwMvMBsWhhNFO6CA/a/AMxMJ+3SQfRi+HMRGu8P1Dp+YibE2g97xu3zFhRZUwPE
         3HrXHxAF23k+s6iwSptcDMfpyMFyMc/qWD0QWGE+crDcKGzxl1GqkAHc9t04AJhJfsKS
         RbYggq2XKWF2/TT9DML1YjmMMbhc1blL5Mf5BtULHJ7BC4lTBXGYmXhqW67sNWMGJ6TU
         Ja7+f3E/mETH/Qj/QGedTFFx6qp5ae8acVYwPAIC+Ak3d9QRxw4jll8RvBhiqhTmR7w6
         IB02//1hXB291OuV/hOUg6z2pbBMRVIDkIOtPwXIwqbe1uGOfGpKohzNGYsVlUGTq33y
         xo1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C3M4SYzoNkYiYC3QIIg1ugPDREve6hEzigXCOJVjW3w=;
        b=TbsIqinbTpYpUtkfXCbRCCW1Pzb9xXvsJ8scR3xBxVakjuUOT4AIOi6npUHfWeBVnj
         t9S11om2tNDCWqNtMpSxKrasJlMPVvkOB/v7vfcIqqJhrEqMKUPHixuhAFT0+aRL3jG3
         lhRXcI7wqJkoViuY8v+v93qBV/rUzRavSC++gjrynXXkGe8NaVtvSuDW24JB/mQVQ6IW
         DKH2LALZ3fvhkTqrMmVMXNpOmyj0XTq/vShD4x2XzrEqNirzmGcSWV5Tj+HgiqJJ4TwE
         FEKqVGwUiGOpQfbDeyxBUvn/tKPVTMg0NeoPdpZVXJ25x2Y38ZqXFVPiVYqK5d491iU5
         ISSA==
X-Gm-Message-State: AGi0PuYTPc8oVRRJn+W8RlzezBU5iC9TjquRDRRENIIgALVd5ieUrejN
        3ZZL6yOa8Bcysv5JHTF568YX64/7t2JeyQMIkoM=
X-Google-Smtp-Source: APiQypJ732tdifHQWDUwWh6Wa0+PNl4WvsjsAuoRbAwtD7HHDsBQDg1JW1PMxqNLNwbwlRGxqp7ludy8IFxOvLU+Tlo=
X-Received: by 2002:aa7:dcd4:: with SMTP id w20mr10621214edu.282.1587425229779;
 Mon, 20 Apr 2020 16:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200420231427.63894-1-zenczykowski@gmail.com>
In-Reply-To: <20200420231427.63894-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 20 Apr 2020 16:26:58 -0700
Message-ID: <CAHo-OowYEW2S-ka4vDxMHp46=esixwdFcBTKGkdzeruQEOwntg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] net: bpf: make __bpf_skb_max_len(skb) an
 skb-independent constant
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is only a semi serious patch.

But, I've spent a long time trying to come up with a solution that works,
and everything seems broken.

I'm hoping someone else has some ideas.

As is, forwarding doesn't work.

Here's an example scenario:

cell0 - 1500 l3 mtu, raw_ip, 0 l2 header
wlan0 - 1500 l3 mtu, ethernet, 14 l2 header

cell0 -> wlan0 forwarding

tc ingress hook on cell0:
  map lookups, other stuff, eventually
  skb_modifications to add ethernet header (via skb_change_head or
bpf_skb_adjust_room)
  bpf_redirect(wlan0, egress)

This fails because adding ethernet header goes above the cell0 ->
mtu+header_len,
even though it would be fine if we tested against wlan0 -> mtu+header_len

Indeed the only solution that would perhaps work is to have 2 bpf programs

tc ingress hook on cell0: redirect to wlan0
tc egress hook on wlan0: actually add the header

but this requires doing the lookups twice - first to determine if
should redirect and where,
and then to actually add the header.  additionally the packet we get
on wlan0 might
not have come from the redirect... and that's hard to detect...

so you actually need to do:

tc ingress hook on cell0: redirect to dummy0, which has larger mtu
tc ingress hook on dummy0: add header, redirect to wlan0

this still requires a double set of bpf programs and lookups...
it's ugly.

Calling bpf_redirect() prior to skb_change_head() isn't enough, since it checks
skb->dev not tgt_index.  Although I guess we could save the redirect device's
mtu in the redirect struct and test against that in preference to
testing against skb->dev...
but that's really a pointless test, because you can call bpf_redirect
multiple times
changing the device, ie...

bpf_redirect(dummy with large mtu)
skb_change_head()
bpf_redirect(wlan0)

so basically this would make the test worthless...

I considered simply removing the mtu check from these skb modifying functions...
it's not like it even does the right thing:
(a) device mtu is only an upper limit - we should really be testing
against path mtu
      and that's probably only something the bpf code knows
(b) it ignores mtu entirely for gso packets: but gso max seg size
should be tested instead...

Or maybe add a bpf uapi visible flag to ignore the mtu check...

Or maybe simply pass in 16-bits of mtu via the currently unused flags field...

... etc ...

- Maciej
