Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0755D1C2964
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgECC2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726544AbgECC2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:28:25 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDEAC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:28:23 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id k110so1359153otc.2
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VzQSGwgbSEL6PlFMY+q3WxRbzUnUA+8NxKAW5c2yEtU=;
        b=PfAqkvSZoiTYOeN57k4r5z7Gjd67geaqG6Y+sIkSuxbHxBzVDYzpnlpe2YdJFoIiOM
         I3RKYFnBLIu99NEqKnBdFqUxr/92JegNNcNbfPJwOE0gtYSFz7aCUBwhkKYnv/MmSpfz
         SqejOlascnmyeG3mwtMqxUFOzW6S7+5ZyAI28bYBwF+WJNrr4qoYQhLnLCod5l1vsgVe
         M11DVRmlfqjp0/TXSbRQwEuQX/+/gU9a++jvQPeJhJ0zcIw3lXygH6PWY4qzd0ExtriY
         kjE4vYCnjQljU+rgEjEHxHam94MfD4Kytk0ExEFdmwV1+sKJw2YeXagqXJ5K8PWyzSwy
         L1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VzQSGwgbSEL6PlFMY+q3WxRbzUnUA+8NxKAW5c2yEtU=;
        b=oRUjo3xeJfyNHSd2V7WODDdc4p2P8akiNiEvv6WOlW6fqgQAIMdLoRHJMhN1k69D+S
         GatlZdElBHv0HfCVvBQSHwD3XeYESrQ3iqK8n5DdPK2pE8+/cFRrtEnalzMX/3UmhFOe
         VFrbWi0YU5bXHEkzX/CWw0iPFppAN4lCH1uJ9GgfJT1Nbq8bs0Mdw2qhh0wjTvsx0eP3
         3+7flca4ICjHCxWo7qhcAUficWMQsDCNRR0OFYPZdbiGqlFBoCEYerVlS8Sv/fozj/MD
         tkrSTd5FHXfXlcRADyU6G2XeVSKwUPAg1FOT2ucPNlVsgqGUEmi3XGwVpgoEdjCFaPEZ
         X40Q==
X-Gm-Message-State: AGi0Pubg0OEwNy/aQiWG/Fum8VlsL6SSR8rN9Lok31vATloboBZfznHm
        rftNYk3Z6+I9EvpAMlb+wEfdoEfukqMooiplTiLGskLR+fs=
X-Google-Smtp-Source: APiQypIwpvptBwcJJcC/fIok9PIFuNUxP9ZnT0LbhzqWtL0yi+TK90tVOLdack83n/PyvpsM8pZthpgrJS3iGslfCpU=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr9091817otm.319.1588472901838;
 Sat, 02 May 2020 19:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
 <7b3e8f90-0e1e-ff59-2378-c6e59c9c1d9e@mojatatu.com> <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
In-Reply-To: <a18c1d1a-20a1-7346-4835-6163acb4339b@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 May 2020 19:28:10 -0700
Message-ID: <CAM_iQpWi9MA5DEk7933aah3yeOQ+=bHO8H2-xpqTtcXn0k=+0Q@mail.gmail.com>
Subject: Re: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 2, 2020 at 2:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-05-02 4:48 a.m., Jamal Hadi Salim wrote:
> > On 2020-04-30 11:53 p.m., Cong Wang wrote:
>
> [..]
> >> Steps to reproduce this:
> >>   ip li set dev dummy0 up
> >>   tc qd add dev dummy0 ingress
> >>   tc filter add dev dummy0 parent ffff: protocol arp basic action pass
> >>   tc filter show dev dummy0 root
> >>
> >> Before this patch:
> >>   filter protocol arp pref 49152 basic
> >>   filter protocol arp pref 49152 basic handle 0x1
> >>     action order 1: gact action pass
> >>      random type none pass val 0
> >>      index 1 ref 1 bind 1
> >>
> >> After this patch:
> >>   filter parent ffff: protocol arp pref 49152 basic
> >>   filter parent ffff: protocol arp pref 49152 basic handle 0x1
> >>       action order 1: gact action pass
> >>        random type none pass val 0
> >>      index 1 ref 1 bind 1
> >
> > Note:
> > tc filter show dev dummy0 root
> > should not show that filter. OTOH,
> > tc filter show dev dummy0 parent ffff:
> > should.

Hmm, but we use TC_H_MAJ(tcm->tcm_parent) to do the
lookup, 'root' (ffff:ffff) has the same MAJ with ingress
(ffff:0000).

And qdisc_lookup() started to search for ingress since 2008,
commit 8123b421e8ed944671d7241323ed3198cccb4041.

So it is likely too late to change this behavior even if it is not
what we prefer.


> >
> > root and ffff: are distinct/unique installation hooks.
> >
>
> Suprised no one raised this earlier - since it is so
> fundamental (we should add a tdc test for it). I went back
> to the oldest kernel i have from early 2018 and it was broken..
>
> Cong, your patch is good for the case where we
> want to show _all_ filters regardless of where they
> were installed but only if no parent is specified. i.e if i did this:
> tc filter show dev dummy0
> then i am asking to see all the filters for that device.
> I am actually not sure if "tc filter show dev dummy0"
> ever worked that way - but it makes sense since
> no dump-filtering is specified.

If parent is not specified, only egress will be shown, as
we just assign q = dev->qdisc.

I agree, 'root' should mean the root qdisc on egress, matching
ingress with 'root' doesn't make much sense to me either.

But I am afraid it is too late to change ,if this behavior has been
there for 12+ years.

Thanks.
