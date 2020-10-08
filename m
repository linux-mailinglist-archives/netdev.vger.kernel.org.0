Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C0287C63
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgJHTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJHTUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:20:25 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82BDC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:20:25 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id n7so1574645vkq.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNfZ4H6Lz9LwzXfn+KRxqIgR00UEx8NUt3mUhPB+t8w=;
        b=Cv5Qf+up3+THLyqNY2T/y2CTt/Btc8nx1gh1wXsQ/ZXatU+oukV0/hv3cBH1QF61A3
         XzdLGUuW48+xCdNIJ2bv1LNKCVqEgNOGTjK3ce6iZsCR/dBzp8H4QS0giZKlbuop1WOq
         JYAJdn4Oykhw4bVmFrAJD72hf+L39kQpj7p5fuAH0uI/du4NT1kULoklK7tE6NyngOy6
         4HKOmEuEzK4S3DwWlIyQvgLlgexhXd4PqKE9l9OPvg/l/7ruc+zy8ny1eCRVYU33NOY5
         ciHpnSDOuAe6zPgjlhAXklENMWvrE3gQEN2Nqapmp97bQZZqCALF86U2uy/WQ7LPMj8X
         vrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNfZ4H6Lz9LwzXfn+KRxqIgR00UEx8NUt3mUhPB+t8w=;
        b=Duv5PXKs+kIrzn0EILmNgmNRApsDCQ4GccOalcZyp01z+NmzJgUCzE73SHWEGsSlkQ
         UoR5n8PWbgI5pgntZ+Rfpf24xNduxr5pyVYidxr94QIsJ/ExQT4LT16jWVkrESeu4U8W
         jNkWmlneX2DmIGeuj5dOBd9L8dq8EpewSgXAVyuaRicyKHuEss9lEyc45g6oWGpHwkuz
         P/fyBu6entitkFRsFi+orq6LPPAsqC/70l6LGl892Zi3Aki250DZFM5bWVL8VutbGKX4
         lgWErrB+7f+NQENriAo6pS56Cu4NBROY/uoRjr5uYJ15GAp5vR0RsEUV8RVoEYFcDsoZ
         xjuw==
X-Gm-Message-State: AOAM533Djgf6/QixuFQFtmWhfIZRGHefAAxe7HFNoRcTcXRJtPgtKzbp
        eiboV93v/kD/xHG7XnnKc/gkEAjWLoM=
X-Google-Smtp-Source: ABdhPJwBwWSs6u4RQvd5PZsbMs1bdx2onee42xU6Z+EzO45rley6cAf2ahpoi1h0j7GJBxCz/IgrmA==
X-Received: by 2002:a1f:5a1d:: with SMTP id o29mr5831149vkb.13.1602184824413;
        Thu, 08 Oct 2020 12:20:24 -0700 (PDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id r17sm793923vsf.25.2020.10.08.12.20.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 12:20:23 -0700 (PDT)
Received: by mail-ua1-f43.google.com with SMTP id x11so916892uav.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:20:23 -0700 (PDT)
X-Received: by 2002:ab0:6495:: with SMTP id p21mr5824488uam.108.1602184823096;
 Thu, 08 Oct 2020 12:20:23 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com> <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
In-Reply-To: <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 15:19:48 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
Message-ID: <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:17 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 12:04 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 1:34 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
> > > is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
> > > dev_validate_header() still returns true obviously but only 'len'
> > > bytes are copied
> > > from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
> > > within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.
> >
> > With dev->hard_header_len of zero, packet_alloc_skb() only allocates len bytes.
> >
> > With SOCK_RAW, the writer is expected to write the ip and gre header
> > and include these in the send len argument. The only difference I see
> > is that with hard_header_len the data starts reserve bytes before
> > skb_network_header, and an additional tail has been allocated that is
> > not used.
> >
> > But this also fixes a potentially more serious bug. With SOCK_DGRAM,
> > dev_hard_header/ipgre_header just assumes that there is enough room in
> > the packet to skb_push(skb, t->hlen + sizeof(*iph)). Which may be
> > false if this header length had not been reserved.
> >
> > Though I've mainly looked at packet_snd. Perhaps you are referring to
> > tpacket_snd?
>
> I think what Cong means is that hard_header_len has to be set properly
> to prevent an AF_PACKET/RAW user from sending a frame that is too
> short (shorter than the header length). When an AF_PACKET/RAW user
> sends a frame shorter than the header length, and the code on the
> sending path still expects a full header, it will read uninitialized
> data.

Yes, that makes sense, thanks. Our message crossed :)

> If my understanding is right, I agree on this part.
>
> However, there's something I don't understand in the GRE code. The
> ipgre_header function only creates an IP header (20 bytes) + a GRE
> base header (4 bytes), but pushes and returns "t->hlen +
> sizeof(*iph)". What is t->hlen?

GRE is variable length depending on flags:

        tunnel->tun_hlen = gre_calc_hlen(tunnel->parms.o_flags);


> It seems to me it is the sum of
> t->tun_hlen and t->encap_hlen. What are these two?
