Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8383F3B7984
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 22:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhF2Urt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 16:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhF2Urs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 16:47:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F383C061760;
        Tue, 29 Jun 2021 13:45:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so11539305edt.12;
        Tue, 29 Jun 2021 13:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SfMnQm3DtGao5johrNoU9SWdQ2/7b5T5k6f5X84peDg=;
        b=nT0oPGuFsx2cLJfwatPNWWDUD0EnREXVQeiXG1xY+yHFL8XlZJaiahus85/VvfUOFR
         F3TzgxxUsHjtf0IE55RhEJiJJQXdy0c8xHosgEe6ePKJU6TuydjobgvaOuN4SB1meFHw
         O0bXVyUfDkGGmDnufQnKuB2EPJJO0kO5l2TRrqk637g6fVseU/ghRsOO6sqS+IYjR2SN
         mNPkv4jkBwCVxaOgFG6zBBrLgJ14j2wxRENTo0h4ycmh2lcXCQyd6vQo17ltHozrVRci
         5rN3IQwws6DyUrksw87u876mQgWMyIBs0uoQ/deDkem4mQONjQtU7Gvs+dSj641PaEz4
         +oxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SfMnQm3DtGao5johrNoU9SWdQ2/7b5T5k6f5X84peDg=;
        b=aoJXte0rdsrgWuUEEq6SnfKL5PpFf/VDw7CEU/wW0dqmZdpoVlJNcF2jQPOWCG+ObH
         LzbiNbCPhvmHXp0lNx1dNw4jcTRL9HtYbLM6Rg2drjXkt7Ovqa7PUJqijbSGjEczzTRi
         x1DUFRlWkz/JE7btDuVyN5LWNssUNBkNNY4c9HCbxIDUO/zhsnSI4FH4pX/fDO/NSO81
         7B72dP6ssZG1GqRb91zvS9RRUYaECmrqynFhFDwzR9DHWVTpYYQdI0ujgtwkyV3Gcjzb
         b+nOOtJmkKZoKzfGmNDXDs078T9+DLg5vIWrz7mGvn090pPB69/UWzB7vOmEc6utI/L3
         G4LQ==
X-Gm-Message-State: AOAM530RHPRaNtR2hR2KxdPYun1w81XlE1Vsw7tsjbLZzKToJVEFtoxq
        ea1YLjI5MWDb/4uRrPTbyfiEh4NWhquJKV7jx2s=
X-Google-Smtp-Source: ABdhPJyUFvDUrS4PvSOg5KKaFX12uA65uQ9gu89JatIa37/P3l1l6uKGEqJVyiBPIKMmsTZwCietIsIvVIzmBMKaRJg=
X-Received: by 2002:a05:6402:358:: with SMTP id r24mr42850846edw.69.1624999518939;
 Tue, 29 Jun 2021 13:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
 <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
 <YNsVyBw5i4hAHRN8@lore-desk> <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
 <20210629113714.6d8e2445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e0b50540-0055-1f5c-af5f-0cd26616693a@redhat.com> <YNtx8aBMM7/8b1lb@lore-desk>
In-Reply-To: <YNtx8aBMM7/8b1lb@lore-desk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 29 Jun 2021 13:45:07 -0700
Message-ID: <CAKgT0Ucazf2_zNoZXuaA_YRExezpT=85pGG2b9_D629FUHj4RQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to skb_shared_info
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 12:18 PM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> >
> > On 29/06/2021 20.37, Jakub Kicinski wrote:
> > > On Tue, 29 Jun 2021 11:18:38 -0700 Alexander Duyck wrote:
> > > > On Tue, Jun 29, 2021 at 10:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > > ack, I agree. I will fix it in v10.
> > > > > Why is XDP mb incompatible with LRO? I thought that was one of the use
> > > > > cases (mentioned by Willem IIRC).
> > > > XDP is meant to be a per packet operation with support for TX and
> > > > REDIRECT, and LRO isn't routable. So we could put together a large LRO
> > > > frame but we wouldn't be able to break it apart again. If we allow
> > > > that then we are going to need a ton more exception handling added to
> > > > the XDP paths.
> > > >
> > > > As far as GSO it would require setting many more fields in order to
> > > > actually make it offloadable by any hardware.
> > > It would require more work, but TSO seems to be explicitly stated
> > > as what the series builds towards (in the cover letter). It's fine
> > > to make choices we'd need to redo later, I guess, I'm just trying
> > > to understand the why.
> >
> > This is also my understanding that LRO and TSO is what this patchset is
> > working towards.
> >
> > Sorry, I don't agree or understand this requested change.
> >
> >
>
> My understanding here is to use gso_size to store paged length of the
> xdp multi-buffer. When converting the xdp_frame to a skb we will need
> to overwrite it to support gro/lro. Is my understanding correct?

Yes, I was thinking just of the xdp_buff, not the xdp_frame. My focus
for right now is mostly around the Rx side of things, xdp_buff to skb,
and around the XDP_TX path. If we want to drop/move where we keep the
data length when doing the conversion I would be fine with that.
