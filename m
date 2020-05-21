Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C011DCFB1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgEUO2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgEUO2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:28:17 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8735BC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 07:28:17 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n11so1890580qkn.8
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 07:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJY0Ep267ouSAsUGL+ry/Av1nT7Mp2t1Mda3g0C6rV8=;
        b=FpDavvqmhyH4TVpicJ5DzY7zQZsoMuzIrMNXmgE8gmzuiJO21+n4dcBsTqUKWLgS9U
         JPuhtdzwLRQp/Ev48KcLWMiFgNr5j/IpYv5qH7HqqAeyVcwimI7EL0L0p/fpzD9HObuG
         nDbu6X2nt0Ud3Ue2hrhuy0coZEfZbsV8D++7u5huuMy7NrNfv1d4ioZWnSEvvS14SRh7
         emHV+Wk8FllyGlC/poviNGagE9to53QAWhXuNKSbfqUmlJOE15J1+AlXo6se+ti5sOTG
         8OFACe2YHqXk19jTeypQrb5GmoowUVZFULiC0iCI1SFerw8AF9YtNeeYb/q7cq2KmUr1
         xkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJY0Ep267ouSAsUGL+ry/Av1nT7Mp2t1Mda3g0C6rV8=;
        b=foJ9KWdgITpEYB4U+VSAlKVvAOocFfqoOUekk/gEmeRsuvoB/TauwLrMrzGl4KRD7a
         pDTUeeFeqxD2HA9kQ8427tBX01OGkdP9trHFBSNMoFYNX3ZaiEUtFREsCHVYQCD5zaB3
         ETuJnQaV3nepmkJ5HbphhzPnac2pw8QabVVa4Dg4pxvcyhcTAK0myRwgsuIy4PF4IXXK
         4NNQ7eL+uLzBMJ2U66+esKs33kQRJvxeMbucTqcDXCNZ1GFOGaUTrAkKXnPrP/9tjQU1
         AWrgb2Z3dTm12gLakI1wdjRYL9yEyNerKXN633IIwveGOy3+sKQJMVr2oplNykS7+PF/
         Jk+A==
X-Gm-Message-State: AOAM531HlkFdqoWc5g/XrmsLnRptJ2/KFDsqeZDJpVHXiK9v74lLB0N1
        KllQUzeWphFd04mQ/LnzpVF6OFjWLvFU+aIFQpPiBg==
X-Google-Smtp-Source: ABdhPJxrgUvL9r2CtDZP+Dx+xHoFfqIlq1qblS0fwHc9+D/mKy8J+gNQB+Y3hIT2EVRIyQ3hiWL5XITfNJ94tr3Hynk=
X-Received: by 2002:a37:797:: with SMTP id 145mr7147025qkh.8.1590071296446;
 Thu, 21 May 2020 07:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007b211005a6187dc9@google.com> <20200521140803.GI30374@kadam>
In-Reply-To: <20200521140803.GI30374@kadam>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 21 May 2020 16:28:05 +0200
Message-ID: <CACT4Y+bzz-h5vNGH0rDMUiuGZVX01oXawXAPbjtnNHb1KVWSvg@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in br_mrp_parse
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     syzbot <syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 4:08 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Wed, May 20, 2020 at 11:23:18AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    dda18a5c selftests/bpf: Convert bpf_iter_test_kern{3, 4}.c..
> > git tree:       bpf-next
>                   ^^^^^^^^
>
> I can figure out what this is from reading Next/Trees but it would be
> more useful if it were easier to script.

Hi Dan,

Is there a canonical way to refer to a particular branch of a particular tree?
From what I observed on mailing lists people seem to say "linux-next"
or "upstream tree" and that seems to mean specific things that
everybody understands.

What do you want to script? Note syzbot is not promising a specific
stable API wrt these plain text emails. These are flattened into text
format for human consumption and sent over unreliable media.

> > console output: https://syzkaller.appspot.com/x/log.txt?x=10c4e63c100000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=668983fd3dd1087e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9c6f0f1f8e32223df9a4
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eaba3c100000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128598f6100000
> >
>
> regards,
> dan carpenter
>
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20200521140803.GI30374%40kadam.
