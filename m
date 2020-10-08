Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7AE287CA5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgJHTvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729220AbgJHTvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:51:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A75C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:51:07 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t7so5724503ilf.10
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t862/pr94GpGlMSTZmLBgUeLS/6qJ97qyskg97Z8oAw=;
        b=geu/7Ho6gFRQ8jjSBewnHqNk0uX9rYXKLrOqdl/WXlxVzRF9bvyj3ocRb7hWAnA80z
         JFas7Vp+T7bWoMRSGUC6sSNV33fn61189GgPUGGEqXyl1Ipb3RvHEhTaNDpCaSJ4LOPE
         cNLma9u+oT0tIZMJW5NBU7ZnDOYijO08kVzY/VjyQAlngd4Qk8TR27o8ZG+cKm53FmUB
         Wo9oJCNKb4+tq4nL5NhDtm2T1I4RoIinAXnOpO8dLN/gJg4CkvJZxSE50lmgAKs9l4VO
         4ueGz+viKB/1ustK+FJSEX+tbq3mdyYja5eos7qRbadI0ANCqJAcLfRhCUpaeCcMyrG6
         QQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t862/pr94GpGlMSTZmLBgUeLS/6qJ97qyskg97Z8oAw=;
        b=TJfwKiDy/9eBZOci882z+P35s8EHeF96TEdLO57W9uq4mN/Vc2LsuKByQAv8ZrklcQ
         uQC6JGRaFr8QV1VV59LvgoYdQ5jIRGAZdoeiH/90hcyeRzNLdQxZTzph5wSu04VsuOtX
         pEKclTSyA5c2+j7OAr8kdfTVvoFSFJXIUKiXqzb4WRG5nRCcpBpBUcNUQI31qIcSfAFx
         V2ny6R9wcgZmpQp8NazcIaqyTelk5IitI7DDQLpVnLzNIA64ewQQE9tI9RUyMSKtNRtb
         xXd6nSFfoTfsUgxcbrxkowFFpWsrL1xZuUF9t0+BTiDvkj8pd2NabOAsmXqbsEL+RAp0
         8XoA==
X-Gm-Message-State: AOAM532CNi8B1pavz91SF3piWOHm5FB/SfRrmY7vPisk4EIAeXYKKgV8
        WtAVOvaxyMVgGp5hdVQ2Rd7nEhmYrgAQHxiPr2biJcSxSKp3ow==
X-Google-Smtp-Source: ABdhPJwA4f6HNLEwlBUEvEgyNC/dfBy6GfchjXJNXn/7CKSoEkxW1natQafAHUL903S+4UBeuLo2H4WaFnEmQFKd/7I=
X-Received: by 2002:a92:d28a:: with SMTP id p10mr8113402ilp.22.1602186666834;
 Thu, 08 Oct 2020 12:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com> <CA+FuTSdp1hfF6BpiPq=HydGB_LCdiKQp6vnjCrdupyR_uZo+Tw@mail.gmail.com>
In-Reply-To: <CA+FuTSdp1hfF6BpiPq=HydGB_LCdiKQp6vnjCrdupyR_uZo+Tw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Oct 2020 12:50:55 -0700
Message-ID: <CAM_iQpVgpbw3bKOA=4YkRcrs8jf7iJSH_b-N62uP4HfYghB6Rw@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>, Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:18 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 3:04 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 1:34 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Oct 8, 2020 at 4:49 AM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> > > > > conditionally. When it is set, it assumes the outer IP header is
> > > > > already created before ipgre_xmit().
> > > > >
> > > > > This is not true when we send packets through a raw packet socket,
> > > > > where L2 headers are supposed to be constructed by user. Packet
> > > > > socket calls dev_validate_header() to validate the header. But
> > > > > GRE tunnel does not set dev->hard_header_len, so that check can
> > > > > be simply bypassed, therefore uninit memory could be passed down
> > > > > to ipgre_xmit().
> > > >
> > > > If dev->hard_header_len is zero, the packet socket will not reserve
> > > > room for the link layer header, so skb->data points to network_header.
> > > > But I don't see any uninitialized packet data?
> > >
> > > The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
> > > is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
> > > dev_validate_header() still returns true obviously but only 'len'
> > > bytes are copied
> > > from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
> > > within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.
>
> Oh, do you mean that ipgre_xmit will process undefined data because it
> calls skb_pull(skb, tunnel->hlen + sizeof(struct iphdr)) ?

The syzbot report has the information for both of your questions:
https://syzkaller.appspot.com/text?tag=CrashReport&x=11845568500000

It clearly shows packet_snd() and ipgre_xmit().

Thanks.
