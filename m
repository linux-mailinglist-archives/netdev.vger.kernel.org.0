Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E4628E2DF
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 17:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgJNPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgJNPM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 11:12:58 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FFBC061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 08:12:58 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id u74so2298099vsc.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFIbDFfhlQ9q1N8ZoJ5cFJGs3F+p1uVY2r1hmo3Aqm8=;
        b=a25ecWdAmu9ZdEWzHY6qqvmbx/ZET1YfxJv+Z1WdeuSbUdrgJ34roiJGgCv/OmPo1V
         thZhOgNPV0UK2zQEOf0zCL8CtQUBjZyZtZNTuXhMMyAUg+SSTo1Ru9AH2ewRJsldgCpE
         HikTsLob5i0h/yh9yR40nUb08exeZJOSDm2OP0f0kuAtmHsy1cwk82YvAglzzVckTg9r
         YQVis3zxnbwQQ+vFLEN2PWsq5GG/c+TLt720sgN95rJTyfmGS/opTSb5j8kPlywpPwIh
         LRzazOane/SK1vk884xFf8WEDtmKKwUjGgSQLZ1TiR1drLo2gZcSe0gH8nDIhd9oC7Sy
         B8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFIbDFfhlQ9q1N8ZoJ5cFJGs3F+p1uVY2r1hmo3Aqm8=;
        b=bYHseJG28SaQJb7oUJBUfXvbT69V9KXW8jAWLOVJMauCqxZMaORDs+4K3oOXg21x9e
         hIr8o7uou8K50M8mDxtur+CEdiCtmvia55DNQhaAS8w0PJB7oZ6FIT7IxAobqPQOm2OF
         2jEFmMe0HF+rT7mXDa+3BCZrlSUWQfvD6thR39XADfHUD6HOJ8XipSz7W+QkbVrRjDrU
         ArgQ6vLaiAd6GNaX0jWTNkKq4NhAvU48dI26Fdx1hhbmTb0fa8DlFZkVY/KYeTxBwxyv
         tkT/FN3Kujs9aITn23wX1TPrw3B3UR5f8a44b4CVNP7LcrYAYCz/Fk/N64QQrHH/epmh
         cUkA==
X-Gm-Message-State: AOAM533ltXMS0K+MbIoNCWUGvPML+OLxFM7UIcBa7Lv45tN60gKgdnFo
        G7JpccMjprLbqJg04C/3dMYWm9shUOo=
X-Google-Smtp-Source: ABdhPJyaM6JeAjvNyRmfSVTl3MCRRdfTAVMLIJc52QNl5xAeBwXM2vokN5AkgMyvGx85V8RVJYDBWg==
X-Received: by 2002:a67:6c86:: with SMTP id h128mr3518696vsc.42.1602688376973;
        Wed, 14 Oct 2020 08:12:56 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id b13sm697683vkf.49.2020.10.14.08.12.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 08:12:55 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id d19so2262524vso.10
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 08:12:55 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr3554868vsr.13.1602688374719;
 Wed, 14 Oct 2020 08:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com> <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
In-Reply-To: <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 14 Oct 2020 11:12:17 -0400
X-Gmail-Original-Message-ID: <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
Message-ID: <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 4:52 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 2:01 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > There is agreement that hard_header_len should be the length of link
> > layer headers visible to the upper layers, needed_headroom the
> > additional room required for headers that are not exposed, i.e., those
> > pushed inside ndo_start_xmit.
> >
> > The link layer header length also has to agree with the interface
> > hardware type (ARPHRD_..).
> >
> > Tunnel devices have not always been consistent in this, but today
> > "bare" ip tunnel devices without additional headers (ipip, sit, ..) do
> > match this and advertise 0 byte hard_header_len. Bareudp, vxlan and
> > geneve also conform to this. Known exception that probably needs to be
> > addressed is sit, which still advertises LL_MAX_HEADER and so has
> > exposed quite a few syzkaller issues. Side note, it is not entirely
> > clear to me what sets ARPHRD_TUNNEL et al apart from ARPHRD_NONE and
> > why they are needed.
> >
> > GRE devices advertise ARPHRD_IPGRE and GRETAP advertise ARPHRD_ETHER.
> > The second makes sense, as it appears as an Ethernet device. The first
> > should match "bare" ip tunnel devices, if following the above logic.
> > Indeed, this is what commit e271c7b4420d ("gre: do not keep the GRE
> > header around in collect medata mode") implements. It changes
> > dev->type to ARPHRD_NONE in collect_md mode.
> >
> > Some of the inconsistency comes from the various modes of the GRE
> > driver. Which brings us to ipgre_header_ops. It is set only in two
> > special cases.
> >
> > Commit 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address")
> > added ipgre_header_ops.parse to be able to receive the inner ip source
> > address with PF_PACKET recvfrom. And apparently relies on
> > ipgre_header_ops.create to be able to set an address, which implies
> > SOCK_DGRAM.
> >
> > The other special case, CONFIG_NET_IPGRE_BROADCAST, predates git. Its
> > implementation starts with the beautiful comment "/* Nice toy.
> > Unfortunately, useless in real life :-)". From the rest of that
> > detailed comment, it is not clear to me why it would need to expose
> > the headers. The example does not use packet sockets.
> >
> > A packet socket cannot know devices details such as which configurable
> > mode a device may be in. And different modes conflict with the basic
> > rule that for a given well defined link layer type, i.e., dev->type,
> > header length can be expected to be consistent. In an ideal world
> > these exceptions would not exist, therefore.
> >
> > Unfortunately, this is legacy behavior that will have to continue to
> > be supported.
>
> Thanks for your explanation. So header_ops for GRE devices is only
> used in 2 special situations. In normal situations, header_ops is not
> used for GRE devices. And we consider not using header_ops should be
> the ideal arrangement for GRE devices.
>
> Can we create a new dev->type (like ARPHRD_IPGRE_SPECIAL) for GRE
> devices that use header_ops? I guess changing dev->type will not
> affect the interface to the user space? This way we can solve the
> problem of the same dev->type having different hard_header_len values.

But does that address any real issue?

If anything, it would make sense to keep ARHPHRD_IPGRE for tunnels
that expect headers and switch to ARPHRD_NONE for those that do not.
As the collect_md commit I mentioned above does.

> Also, for the second special situation, if there's no obvious reason
> to use header_ops, maybe we can consider removing header_ops for this
> situation.

Unfortunately, there's no knowing if some application is using this
broadcast mode *with* a process using packet sockets.
