Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853C63817B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfFFXBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:01:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37491 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfFFXBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:01:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so84161ljf.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJOLd98V7h/41gN0sd3RAlbzT+EcPfSEwsbzsru+d7w=;
        b=qcl6DD2Xr2ncM+YUbi5/tExqEvuiyK0QXg6d+yIJGD9Z2nRPawOVEigwJxCf8xl+nx
         zPUMBSuw4DU4IuXODyQE20QA++GTfTHTs5kBmeEo4TsVDE4j2QDQWsiEhVcmcfaj9v5q
         Xf7hnRlN/+KbfxLbO5xRoLCHBO1/Ov2+VoeK1fRZ8bhmjp6JRfTLlVM0oPUItrbQg+od
         1+qGfWvFcKP52h0OGqRe+AVCLOEDVvupATTQ8mNO7vwqKC0QhqT0Fkqv7JIEBqPujqPd
         SnuqlYwCcD5DVIH3sgL/aRCLuak3a1q8fPgwIopcKlMAIisf87uLsXURgs74xJiEw7rm
         MVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FJOLd98V7h/41gN0sd3RAlbzT+EcPfSEwsbzsru+d7w=;
        b=WGHND26vblpXnGqAyEYWfgxtycxheuwgXoGHuEG+ldEt5Dc6SEcSg6LQ5eBo87b585
         m80NHaxm++vfB2DFiCQIoCj5/lY707jmGQf0HMlBP1YYso6u6jzt8ZLmtt7JBrNTsFub
         dhSH/9Xaq2hX61DkUVqr8CGcbk+6SKbBwi/wHgCN/1HIgjkOLd6doCd/TP3kY6C/oFh0
         DyROG21f/+gBI1CwRgGh2LbL5vfRgZs4g2sbo8/v51BgKKl5fiYqzTbbnQH5lmnKi+AL
         RxeXH+JduZpe/5Fy2ZEmsMPKe6HuUX+22wPX+CdZpKY08ceAMni7on5KQWDASmzNfCBG
         z30g==
X-Gm-Message-State: APjAAAWCpdI0Q4PUK7+PHWhOx7U4GvudLFUML2r5NkEBG8UatVgJ5ZE+
        AXG8/cP71gbG1RXhtGvdwpsBqCQ/KSf1a0tgIm8=
X-Google-Smtp-Source: APXvYqxOZHEHTKF/M2T0kQmHHIWizTZkzqOgmKzcHF0/bg4tPSJ0D40Zuh5yoLZVTgFBuIhGLFTjnwIpm8zO0zLLtHM=
X-Received: by 2002:a2e:9a13:: with SMTP id o19mr2485613lji.102.1559862106237;
 Thu, 06 Jun 2019 16:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com> <eef3b598-2590-5c62-e79d-76eb46fae5ff@cumulusnetworks.com>
 <CAKD1Yr30Wj+Kk-ao2tFLU5apNjAVNYKeYJ+jZsb=5HTtd3+5-Q@mail.gmail.com> <d8022629-0359-34b7-ccae-bb12b190e43b@gmail.com>
In-Reply-To: <d8022629-0359-34b7-ccae-bb12b190e43b@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 6 Jun 2019 16:01:34 -0700
Message-ID: <CAHo-OowgWNicSEmvatfk-D6Xwo-gGphCt34CLxaPOHu4VE6Law@mail.gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     David Ahern <dsahern@gmail.com>
Cc:     Lorenzo Colitti <lorenzo@google.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Mateusz Bajorski <mateusz.bajorski@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(side note: change was reverted in net stable)

On Wed, Jun 5, 2019 at 8:33 AM David Ahern <dsahern@gmail.com> wrote:
> On 6/4/19 10:58 PM, Lorenzo Colitti wrote:
> > As for making this change in 5.3: we might be able to structure the
> > code differently in a future Android release, assuming the same
> > userspace code can work on kernels back to 4.4 (not sure it can, since
> > the semantics changed in 4.8). But even if we can fix this in Android,
> > this change is still breaking compatibility with existing other
> > userspace code. Are there concrete performance optimizations that
> > you'd like to make that can't be made unless you change the semantics
> > here? Are those optimizations worth breaking the backwards
> > compatibility guarantees for?
>
> The list of fib rules is walked looking for a match. more rules = more
> overhead. Given the flexibility of the rules, I have not come up with
> any changes that have a real improvement in that overhead. VRF, which
> uses policy routing, was changed to have a single l3mdev rule for all
> VRFs for this reason.

Instead of keeping duplicates there could be a counter on the singleton rule.
And then adding/removing is just inc/dec on the counter (and only
actually delete when counter drops to 0).
Would require some extra effort to make it look the same when dumping
I guess (to expand it out).

---

I'm not sure this is worth optimizing for.  In Android these states
with dupes are temporary.
And really, if you complain about performance it is perfectly
reasonable to say "then don't create duplicate rules".

---

Note though that from a multithreaded perspective, you'd never want
the 'ignore it and return 0' behaviour.
It's fundamentally a bad api.  It's better to return an error and
userspace can decide that EEXIST is acceptable and treat it as 0.

Imagine two threads doing 'add ip rule foo; blah blah; remove ip rule foo'

You either want the create dupes, or the 'return EEXIST' behaviour (so
the second thread can fail, or wait until it succeeds or whatever).

This way if two threads both run the same operation, either both of
them succeed,
or one succeeds and the other gets notified of dup.

Otherwise you get a spurious failure in one of the threads and bad
behaviour in the other (since rule vanishes before it should).
