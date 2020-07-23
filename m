Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDEB22B207
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgGWO7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgGWO7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:59:15 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4AC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:59:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p205so6538559iod.8
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jspp29kb/rVg0HYdr1cP7s4ghT0ubJXwVDQYt3dFgYA=;
        b=r1bAwMzfI/WIXpxzZsIeak0DtfnVT0FdIAsSsv/29kLnd+EPvJfPwkqEMoYj2CCvXF
         4dRu/tVkiQoM42hWELU18vrWWQKiaRzkBhxDinebWJURRYwL8WYf615jZn8kkNuqplOQ
         YtXIkpLJ0sNTo7S+KqZ3D3uGtcNl/KavcibKuJ1dZBH99jVrctS5ImGh1bBK7y2LoX2a
         JkiFkvy1hVP+pCUTIpSIlDnuF8ubs/ck6h8HLg8yWE3uGJDN3j78U6+XMsUiTeamrI7T
         6rNz8iTf4MDCWZocOz2BHMWjvcAlH29iSFL21/dNw0CrssgS9jal0T39LMjkuREgMOdk
         EbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jspp29kb/rVg0HYdr1cP7s4ghT0ubJXwVDQYt3dFgYA=;
        b=uCzZNToDLir/TmUgabgQNWvnTij1X0aV71ZBDqueH45PEShE++9eI3S2xCybndIJvC
         q5Vss6AtzQMLJKhqBI3zGg4K7OWRKQuxUNT2qr/QxaSOVFx4a3hmy1fu2/8tjXo7v+DS
         HoQ6CNJDDRdGX+nCVnloXI1A+KadL2Rs8GZiVNiAc7AFPT5LhL6dNSUXEYYyLVyooE73
         5y2gj6aDRHsRCTuhVdzMo7eh91nHJ15FbECeL4No24AK8mL5UJZkSX1ChepsGnUCnUIf
         NH/LZ7ZFpCtbNr9gOmBRAOQOXZ/5fTVgmB7L8w+atzTXvFaQycoGYjts2epLHIIylAKl
         hDeA==
X-Gm-Message-State: AOAM5310qyCbKs3Cxq4eoaTxoFDTlBuxbr/sd6KZrLtaNcu/fHBbZDXR
        gtl0HQhSh1cR4HdJwhAKQLl+gCy24w77snaxvL4Ew9Kv
X-Google-Smtp-Source: ABdhPJwlhstfsdqqx/q+z0qGQI0dSwDvQr9Zfh28Vf81DHA6PRP2eQsxAAHtl5U8/Sew+1MB73eQgax0fp4rxm3Q5+M=
X-Received: by 2002:a05:6638:1696:: with SMTP id f22mr5312824jat.60.1595516354210;
 Thu, 23 Jul 2020 07:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
 <20200721.161728.1020067920131361017.davem@davemloft.net> <CALHRZuofbFnE8E-wpdosvKP6m3Ygp=jjcHz9QUn=R3gUbyNmsg@mail.gmail.com>
In-Reply-To: <CALHRZuofbFnE8E-wpdosvKP6m3Ygp=jjcHz9QUn=R3gUbyNmsg@mail.gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 23 Jul 2020 20:29:03 +0530
Message-ID: <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Jul 22, 2020 at 7:34 PM sundeep subbaraya
<sundeep.lkml@gmail.com> wrote:
>
> Hi David,
>
> On Wed, Jul 22, 2020 at 4:47 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: sundeep.lkml@gmail.com
> > Date: Tue, 21 Jul 2020 22:44:05 +0530
> >
> > > Subbaraya Sundeep (3):
> > >   octeontx2-pf: Fix reset_task bugs
> > >   octeontx2-pf: cancel reset_task work
> > >   octeontx2-pf: Unregister netdev at driver remove
> >
> > I think you should shut down all the interrupts and other state
> > before unregistering the vf network device.
>
> Okay will change it and send v2.
>

For our case interrupts need to be ON when unregister_netdev is called.
If driver remove is called when the interface is up then
otx2_stop(called by unregister_netdev)
needs mailbox interrupts to communicate with PF to release its resources.


Thanks,
Sundeep
> Thanks,
> Sundeep
