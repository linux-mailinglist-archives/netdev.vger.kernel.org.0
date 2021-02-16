Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31F931C6D3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhBPHbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhBPHbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 02:31:17 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1576C061574;
        Mon, 15 Feb 2021 23:30:36 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q20so5612766pfu.8;
        Mon, 15 Feb 2021 23:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I88mIFMB9J2IjxEmhlo7Ogv3+ByccYZjbXSfnh+qCAo=;
        b=inCIuvpsW79NR8No86bgtL4mLS7lagd8bQP6x3nnSkpxtUisZdPgrT68h8fWS7bPLX
         8ezbegLMDwjPhj6+wcKUSGn5AQXOwj+MTumkPed1GriSqofM7Pt2ubNa3ZbVlgZeoNxQ
         QGv0uRA2IFaTZY0xGCiWc822HH8LOpSZ1Og73iBFxaP3CBm2Giq1q9AnsTkhQrhZJBR1
         amVo/UZ8cUrh+iwX8zFts+8v9XhxQdBynQ24Hr68ztRIh0XqtLLPu8YH2CnqCQMXPjqz
         H+Aap0G08Jr8TI0+1ifGYG8zQchXV2mYzre9paiFBcxDEya6WZ5QTpnxxr5Ot5ckRy6o
         /Ttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I88mIFMB9J2IjxEmhlo7Ogv3+ByccYZjbXSfnh+qCAo=;
        b=lUqsGWA4ycMxusi6L6ANYwK701DPZQtGOayWBLB9gx3u/D/Tbnbica6jjft0o/afn7
         XUmhOumTzT1/8xarjox82ro+QQlfYInbeJNFJxmIfKKfzmlAGpFO+224QPOD8Dyz7RMY
         anwjZNmSTziwjVRFx4/UTn45XfyftGeQ8gxCjbUD85ys2R2ri9b9ykIKiSaaREqo7SZ1
         4/sxu9ENShCv47qKRems94BkrC4FNTvIxnOEQce4e6oImPeFBZ6T8WHzJZ/mcDEVR84B
         vVv2AkcWQ2bTLze0QU6yjMKzS1ujNyXBXQRzgO2sy5xWMNMz+bEUpjd6lqg+hDFCu588
         f9HA==
X-Gm-Message-State: AOAM531ep+0bWuOHJNHJ1hqG6hNbxgDap41kRvd376jFhrminkV1YNTy
        0dd1Ng2NNF2EbVwWiDZc32oY7cJm8hcAdzCe/84=
X-Google-Smtp-Source: ABdhPJxY+0V/rCSIK7dFXJCOaj5odB8OHaoE4fukgexUI8E0GXsrcfraQCBA2IHQkmuacjw2LTjO1YAzj+3B32d4Gzs=
X-Received: by 2002:a63:7f09:: with SMTP id a9mr17973656pgd.63.1613460636184;
 Mon, 15 Feb 2021 23:30:36 -0800 (PST)
MIME-Version: 1.0
References: <20210215072703.43952-1-xie.he.0141@gmail.com> <YCo96zjXHyvKpbUM@unreal>
 <CAJht_EOQBDdwa0keS9XTKZgXE44_b5cHJt=fFaKy-wFDpe6iaw@mail.gmail.com>
 <YCrDcMYgSgdKp4eX@unreal> <CAJht_EPy1Us72YGMune2G3s1TLB4TOCBFJpZt+KbVUV8uoFbfA@mail.gmail.com>
 <YCtgTBvR6TD8sPpe@unreal>
In-Reply-To: <YCtgTBvR6TD8sPpe@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 15 Feb 2021 23:30:25 -0800
Message-ID: <CAJht_ENDJ-T_9-V04YUP-Qp+PnZnAcOeV+6eUXkTX4pmm5Vrag@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v3] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 10:04 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Feb 15, 2021 at 11:08:02AM -0800, Xie He wrote:
> > On Mon, Feb 15, 2021 at 10:54 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Mon, Feb 15, 2021 at 09:23:32AM -0800, Xie He wrote:
> > > > On Mon, Feb 15, 2021 at 1:25 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > > +     /* When transmitting data:
> > > > > > +      * first we'll remove a pseudo header of 1 byte,
> > > > > > +      * then the LAPB module will prepend an LAPB header of at most 3 bytes.
> > > > > > +      */
> > > > > > +     dev->needed_headroom = 3 - 1;
> > > > >
> > > > > 3 - 1 = 2
> > > > >
> > > > > Thanks
> > > >
> > > > Actually this is intentional. It makes the numbers more meaningful.
> > > >
> > > > The compiler should automatically generate the "2" so there would be
> > > > no runtime penalty.
> > >
> > > If you want it intentional, write it in the comment.
> > >
> > > /* When transmitting data, we will need extra 2 bytes headroom,
> > >  * which are 3 bytes of LAPB header minus one byte of pseudo header.
> > >  */
> > >  dev->needed_headroom = 2;
> >
> > I think this is unnecessary. The current comment already explains the
> > meaning of the "1" and the "3". There's no need for a reader of this
> > code to understand what a "2" is. That is the job of the compiler, not
> > the human reader.
>
> It is not related to compiler/human format. If you need to write "3 - 1"
> to make it easy for users, it means that your comment above is not
> full/correct/e.t.c.

My point is: there is no need for human programmers / code readers to
understand what this "2" is. There is no need to explain what this "2"
means in the comment. There is no need to write this "2" in the code.
There is no need for this "2" to appear anywhere. That is just an
intermediate result generated by the compiler. It is similar to
assembly or machine code. It is generated by the compiler. Human
programmers just don't care about this intermediate result.

My point could be more apparent if you consider a more complex
situation: "3 - 1 + 2 + 4 + 2". No human would want to see a
meaningless "10" in the code. We want to see the meaning of the
numbers, not a meaningless intermediate calculation result.
