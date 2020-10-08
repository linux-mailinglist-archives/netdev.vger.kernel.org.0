Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C058C287C5D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgJHTSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJHTSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:18:53 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C6BC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:18:52 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id z19so2252103uap.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pyhoRd/U9UMx2e6F6BvsGxpn8YCSRFHgq0uaWSKRCRk=;
        b=IuSKXTiJJpWcbnX+3goFW9+VKx7q7bk5wrhC1Bgl4obNxe5Wyi2Joh+6QhOJMFkE4v
         q8XADhKmk+JrMiSe24AUtISCibeNvR3AODbCS5av+CL4R1YzKZpWBdTn17M1aTcoeqNB
         /xw0g0yfcy9/uLZp5LcY91luOa6+wl43ya/RsYLb03o6QWcUjPCoxXXyYG/WkTfsHjUn
         2fsMdL8RpEifJGM1qWVSg+6ZkPOWXYPVRVgRzpA335t/MrhAvXD5qkjqI4JS0u6EQxsF
         7nEiWY+8KWvSVqhcO4iPzg+aafC42nPYkGPL2LwE+hCrt0LSaDTx8puc4LH7nBGeE1+t
         KdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pyhoRd/U9UMx2e6F6BvsGxpn8YCSRFHgq0uaWSKRCRk=;
        b=dvQiG6fjL+ygx233THX8Xu0XIU7ay9wwIGLuxSUgWhbf7VJHPlN9A20BuEmD8EvH+j
         di+uFZ7z80gR1CesnjAQwk6Cd0Rd4qbtC8HL4uq78DUHf4V+L+ZvI1ZPXlboZnP1pwI2
         pyi4V+V+Bse4cl6PpTXEkFX+CE+Gi1i1zsHYlQod2SSMJFRSZjZLciRk+vRj1e2VPPQl
         V1XnKnATmhLpi0D2oE0bqe3KTqPezE9sSsdEqV1+osD2TC2QvkppZpSYDwurWQ3XLnrY
         R53Y6Y6RTg0LytBeYX8LbcnpKMtsgZN/9vClOhmbjFsDwukhlAHcsSpayWUDYRVOn+fb
         fJ8Q==
X-Gm-Message-State: AOAM532hZhZvXG46fjjy6QioovTxjDsrTIY77/6/C0gV7l95ENh8HXQj
        /kI8BGhyXxGyj/JwLyAEUpMvyHSGi9I=
X-Google-Smtp-Source: ABdhPJzjHlSCaZaFY49L2jGygcd8PelvO3RO+xziJCEzzV7ePpBYRsrwwr6b/eaWwooJHgDZjiP7gw==
X-Received: by 2002:ab0:6914:: with SMTP id b20mr5878399uas.52.1602184731161;
        Thu, 08 Oct 2020 12:18:51 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id r22sm838627vke.5.2020.10.08.12.18.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 12:18:50 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id v23so1095517vsp.6
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:18:50 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr6021160vsr.13.1602184729756;
 Thu, 08 Oct 2020 12:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com> <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
In-Reply-To: <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 15:18:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdp1hfF6BpiPq=HydGB_LCdiKQp6vnjCrdupyR_uZo+Tw@mail.gmail.com>
Message-ID: <CA+FuTSdp1hfF6BpiPq=HydGB_LCdiKQp6vnjCrdupyR_uZo+Tw@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>, Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:04 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 1:34 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Oct 8, 2020 at 4:49 AM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> > > > conditionally. When it is set, it assumes the outer IP header is
> > > > already created before ipgre_xmit().
> > > >
> > > > This is not true when we send packets through a raw packet socket,
> > > > where L2 headers are supposed to be constructed by user. Packet
> > > > socket calls dev_validate_header() to validate the header. But
> > > > GRE tunnel does not set dev->hard_header_len, so that check can
> > > > be simply bypassed, therefore uninit memory could be passed down
> > > > to ipgre_xmit().
> > >
> > > If dev->hard_header_len is zero, the packet socket will not reserve
> > > room for the link layer header, so skb->data points to network_header.
> > > But I don't see any uninitialized packet data?
> >
> > The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
> > is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
> > dev_validate_header() still returns true obviously but only 'len'
> > bytes are copied
> > from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
> > within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.

Oh, do you mean that ipgre_xmit will process undefined data because it
calls skb_pull(skb, tunnel->hlen + sizeof(struct iphdr)) ?
