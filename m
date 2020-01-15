Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9730A13C83D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOPns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 10:43:48 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41060 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgAOPns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 10:43:48 -0500
Received: by mail-yb1-f194.google.com with SMTP id z15so3071776ybm.8
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRacpxn3WSP8qw75gELoYRldETM6kBb4Jb9sC1zqQrc=;
        b=ma0CavwiF8k4FyYwZ9Ca65oJTYUL/SeXSyplB6tr2rjHQIvtjlaI1H8AS+XleYoYA5
         VJq+lUevqQTBt4kubnkWh54jGzmwtCmjI0i06hc03z2vVjcLntUHRMT0k5lDnRxuE92x
         HOfqEq4d1bRBSQDw57givelBSxsrI+HB7rMP/Zhb3v4jpkh5TJBlDYVY/CAtsntHEOof
         TTgWl/1VmrXuEJ5rWsPx2X0A8/hfweL7c/DnyMpykKQV6Vrr9Z2uRtmSfR7+tCfTgPsY
         3dL/C9mUVcAl+iU95SrZY2VrqbO3iE4HWd9aXlvcwUlR2c3pT0Xzc0UUcfQj/b59X+j7
         nNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRacpxn3WSP8qw75gELoYRldETM6kBb4Jb9sC1zqQrc=;
        b=W0uFlTo+VKNMFeqk8vgeleF80rLKo5R9NFJUklHx8Veikd1jUjAYVlRqwlL4xY2Xom
         R0SmpWAeoLqdiVt/lsUMpbCZakt6aMfqQgY+sdNeMm1j65gMXXqJHwjwlvZJuPtSMMD1
         DTrv4vTTnKAPpQffyvHxxH3m9lea8m/EJzx2pjeCA+/NleE6+xKq/a3bt8e5XPrN1DJd
         b6RAn7dqxD9QDRjotiAH5t/T8o9CKCZ5PHs6RO/VU8s0bIPk7Ptq+dbc8r4tVyTJYmKl
         pRm8UP4I7H8wczoi4w9Rv9kozBFSraoNaGyH5074GDRwgI8LKmmndlEhzUgmqU8BfS9D
         lshA==
X-Gm-Message-State: APjAAAWvjljbMh3EfEvwF+UvKsVq4PVh7ACFtMxYNPnykMPYho3R9MIS
        VNbhdExM1tH8kdyznLpyipKRFcDw
X-Google-Smtp-Source: APXvYqyASjGoc5FKBy/JpqWqIOLa4O+HmvhLPbtGYm8YPhWIgrpI/Mjv9Ignt2KIbem0ORDWhukpww==
X-Received: by 2002:a25:840c:: with SMTP id u12mr18122434ybk.1.1579103026422;
        Wed, 15 Jan 2020 07:43:46 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id n1sm8358059ywe.78.2020.01.15.07.43.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 07:43:45 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id u139so11162510ywf.13
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 07:43:44 -0800 (PST)
X-Received: by 2002:a0d:dcc7:: with SMTP id f190mr23514583ywe.193.1579103024339;
 Wed, 15 Jan 2020 07:43:44 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com> <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de> <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
 <20200113085128.GH8621@gauss3.secunet.de> <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
 <20200115094733.GP8621@gauss3.secunet.de>
In-Reply-To: <20200115094733.GP8621@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 15 Jan 2020 10:43:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeF06hJstQBH4eL4L3=yGdiizw_38BUheYyircW8E3cXg@mail.gmail.com>
Message-ID: <CA+FuTSeF06hJstQBH4eL4L3=yGdiizw_38BUheYyircW8E3cXg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Maybe we can be conservative here and do a full
> > > __copy_skb_header for now. The initial version
> > > does not necessarily need to be the most performant
> > > version. We could try to identify the correct subset
> > > of header fields later then.
> >
> > We should probably aim for the right set from the start. If you think
> > this set is it, let's keep it.
>
> I'd prefer to do a full __copy_skb_header for now and think a bit
> longer if that what I chose is really the correct subset.

Ok

> > > > > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > > > > make sure the noone touches the checksum of the head
> > > > > skb. Otherise netfilter etc. tries to touch the csum.
> > > > >
> > > > > Before chaining I make sure that ip_summed and csum_level is
> > > > > the same for all chained skbs and here I restore the original
> > > > > value from nskb.
> > > >
> > > > This is safe because the skb_gro_checksum_validate will have validated
> > > > already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> > > > in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> > > > imagine.
> > >
> > > Yes, the checksum is validated with skb_gro_checksum_validate. If the
> > > packets are UDP encapsulated, they are segmented before decapsulation.
> > > Original values are already restored. If an additional encapsulation
> > > happens, the encap checksum will be calculated after segmentation.
> > > Original values are restored before that.
> >
> > I was wondering more about additional other encapsulation protocols.
> >
> > >From a quick read, it seems like csum_level is associated only with
> > CHECKSUM_UNNECESSARY.
> >
> > What if a device returns CHECKSUM_COMPLETE for packets with a tunnel
> > that is decapsulated before forwarding. Say, just VLAN. That gets
> > untagged in __netif_receive_skb_core with skb_vlan_untag calling
> > skb_pull_rcsum. After segmentation the ip_summed is restored, with
> > skb->csum still containing the unmodified csum that includes the VLAN
> > tag?
>
> Hm, that could be really a problem. So setting CHECKSUM_UNNECESSARY
> should be ok, but restoring the old values are not. Our checksum
> magic is rather complex, it's hard to get it right for all possible
> cases. Maybe we can just set CHECKSUM_UNNECESSARY for all packets
> and keep this value after segmentation.

Note that I'm not 100% sure that the issue can occur. But it seems likely.

Yes, inverse CHECKSUM_UNNECESSARY conversion after verifying the checksum is
probably the way to go. Inverse, because it is the opposite of
__skb_gro_checksum_convert.

Or forgo (this variant of) GRO when encountering unexpected outer encap headers?
