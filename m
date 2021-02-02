Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB7430B7CB
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhBBG0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhBBG0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:26:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692C0C061573;
        Mon,  1 Feb 2021 22:25:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gx20so1723953pjb.1;
        Mon, 01 Feb 2021 22:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdzoXk6LXCL/XJZQ9bhaClEN0pBSjRAU89qkEkTJ1ro=;
        b=WpDctFpAjxQC3G7i/CrGOY5P5vAzYvSQZ1DJ7ug65xvWqMu058k6tQ55kWTe4mNQ1Y
         aCKj73P49pFh1v29gECJjZSHS/0nlD/d5b83Vg6OorIHAAehpDXphlvkfDj+Fikrd0Tn
         f42RIHVu9CBa0Vv2XdIWp/ccMU26TFFY1fpqUtTJS1dkxAHYylOdqHaB2ablpM25HRFh
         d3p4/J451okEOShw7EnNAwSV5RzM5FpXSuI8bI5ZrIEXTc3Y+c/WptQsp60yiPqfg31I
         6mUS5XeILRFn1pz/ZlZmqpEd0vKPe5VRbKNcyQpsBfLt8udkOLDHFthNwM4uqGs//DaV
         HYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdzoXk6LXCL/XJZQ9bhaClEN0pBSjRAU89qkEkTJ1ro=;
        b=nfQShAxai5kCTlkqC0rVu5TtWNRtKe1vKkVp6z8Qpz2JaGcFgJM5dMmCj+83eFJNk8
         sqpV48uIMmv4kb76g0i5nekjcDOnE1qZt/hU+TflaidkTBvERx3vgtITKM7Lcvptj9/l
         Seg/7sQtgAO4rbqyZaiKD79tqwf1XxuEVtU9mycgdI+wEwNsJ/0OUHsp2b0fIBxT42cg
         NfFvTZQ++ktvkvPGTF0Ux+sylqH4h+aaFXgs51OZijHoMtRmvP5ITroBJwP4Z71OErl1
         /qlnBzuRSlNnx5OJOvZyWlTu/llNeN1ua5HMPEBMA/snUEgXZuWMXqAooyiRp43/5JtQ
         dO5A==
X-Gm-Message-State: AOAM532zSAZ5XU1omNEFH3bKlIQq6gopcscFzjcUX3RlA3JljVp2Y1Ki
        e64CKQLbVE9PLwoo5ya1+dOyHWuKUqGXs0MDlO8=
X-Google-Smtp-Source: ABdhPJySMMqpl4MfKIaCMf+k3Y0990M+ZfGxjdajAfm8/0BmkbaWtxLGEK/y1iQK1dEovRVoQh0LtWWlvPHVFaxDZvg=
X-Received: by 2002:a17:90a:5403:: with SMTP id z3mr2763602pjh.198.1612247127962;
 Mon, 01 Feb 2021 22:25:27 -0800 (PST)
MIME-Version: 1.0
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
 <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com> <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
 <20210201204224.4872ce23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201204224.4872ce23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 1 Feb 2021 22:25:17 -0800
Message-ID: <CAJht_ENcz1A+C8=tJ_wP8kQby4OuyWirJC+c+-ngg5D54dpHNg@mail.gmail.com>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 1 Feb 2021 08:14:31 -0800 Xie He wrote:
> > On Mon, Feb 1, 2021 at 6:10 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
> > > This sounds a bit like you want skb_cow_head() ... ?
> >
> > Calling "skb_cow_head" before we call "skb_clone" would indeed solve
> > the problem of writes to our clones affecting clones in other parts of
> > the system. But since we are still writing to the skb after
> > "skb_clone", it'd still be better to replace "skb_clone" with
> > "skb_copy" to avoid interference between our own clones.
>
> Why call skb_cow_head() before skb_clone()? skb_cow_head should be
> called before the data in skb head is modified. I'm assuming you're only
> modifying "front" of the frame, right? skb_cow_head() should do nicely
> in that case.

The modification happens after skb_clone. If we call skb_cow_head
after skb_clone (before the modification), then skb_cow_head would
always see that the skb is a clone and would always copy it. Therefore
skb_clone + skb_cow_head is equivalent to skb_copy.
