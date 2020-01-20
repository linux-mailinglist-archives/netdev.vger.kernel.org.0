Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC5143005
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgATQgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 11:36:12 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:40002 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgATQgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 11:36:11 -0500
Received: by mail-yb1-f196.google.com with SMTP id l197so8233851ybf.7
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 08:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lDcWJWD6orD5RLXJ735+RhOtwzP7LDJ06KqFK7Wh48=;
        b=pMxgMTzKo8v6cvbkPsu/MbC+tm/dMv+Yv7bcOr3/nzvk+k+9nnYnBRjywY8QJShP80
         fGC26LEMTKpArJ7V2Uvs21oIbjzN55Hdg9yPaWBd7s0mA96GU3mCEdSAWU2+jUNMGIIN
         TP3kTkvi1tOibE9ZErB0CBUvm4rt9J/JO8/r0nzeryiU/XqqsTEwfEoVPEBgU2TBZB3W
         RpmTSJPcxwbCqvN/Wvu3oQA64jd2KZhZCyEouBanfILT5OpHIb+DMar3DF19e6OuXdlA
         Z5Q4HX9bKeiCJLx83cuTDiaKLAUZMvBtt83WrF3qIwS5U37oHE7SI70N4xi9YkQm9kp+
         kxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lDcWJWD6orD5RLXJ735+RhOtwzP7LDJ06KqFK7Wh48=;
        b=bVjENTQKMQMYLYsDrE2B/ljbNnkyq+K/5Fv7FevyDh5/JVCMF/MzzQEznfgLj22oNk
         5uXQwFXbtGReM6HR4/g0uJx1lJkE0Kg1OmFza+v6QwBzBf4oEy5hcoa0KL/GyKUBIIi3
         xmrTq+18AGgUckYSuixNjBIvI+Np5Nt3hpGUDdaVDn11/BkzqCOZyjqUR/Ir7jm/CYpf
         Y1Xc8Tjsq+e9P2nDHRWG6IF2l3qAZylzpf7HqtBtiXAmtytfaGxKFA2rEudQY8B6bFAy
         26M2X99XstaXgUxh7g2L4p0hlatlmTK+38aF6nVe+SKOH1SyBlCE3G3LGjd/5YWYcGAU
         o9/Q==
X-Gm-Message-State: APjAAAVSrOOozcXiK8DiiZ9m2Vb1D/1GvxuzVUuIKueb+fNyeaqu/FAa
        AkuyetaviVQbtF5sFkZVex+De3e/
X-Google-Smtp-Source: APXvYqz0bxFOyogIh3HfLlEuthW7vE+VTSaBXvEXXdicnf2fmYQc7OMez/5xapk/lx8eNOHmnK1Yaw==
X-Received: by 2002:a25:53c4:: with SMTP id h187mr505967ybb.402.1579538170133;
        Mon, 20 Jan 2020 08:36:10 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id p1sm16598611ywh.74.2020.01.20.08.36.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 08:36:09 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id q190so7208ybq.2
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 08:36:08 -0800 (PST)
X-Received: by 2002:a25:5889:: with SMTP id m131mr416600ybb.89.1579538168358;
 Mon, 20 Jan 2020 08:36:08 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com> <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de> <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
 <20200113085128.GH8621@gauss3.secunet.de> <CA+FuTSc3sOuPsQ3sJSCudCwZky4FcGF5CopejURmGZUSjXEn3Q@mail.gmail.com>
 <20200115094733.GP8621@gauss3.secunet.de> <CA+FuTSeF06hJstQBH4eL4L3=yGdiizw_38BUheYyircW8E3cXg@mail.gmail.com>
 <20200120083518.GL23018@gauss3.secunet.de>
In-Reply-To: <20200120083518.GL23018@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 20 Jan 2020 11:35:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTScDxBCUtMzfOyuTa3ZjBHJsg7c1QOL1rrTUDeTL5UvOTQ@mail.gmail.com>
Message-ID: <CA+FuTScDxBCUtMzfOyuTa3ZjBHJsg7c1QOL1rrTUDeTL5UvOTQ@mail.gmail.com>
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

On Mon, Jan 20, 2020 at 3:36 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, Jan 15, 2020 at 10:43:08AM -0500, Willem de Bruijn wrote:
> > > > > Maybe we can be conservative here and do a full
> > > > > __copy_skb_header for now. The initial version
> > > > > does not necessarily need to be the most performant
> > > > > version. We could try to identify the correct subset
> > > > > of header fields later then.
> > > >
> > > > We should probably aim for the right set from the start. If you think
> > > > this set is it, let's keep it.
> > >
> > > I'd prefer to do a full __copy_skb_header for now and think a bit
> > > longer if that what I chose is really the correct subset.
> >
> > Ok
> >
> > > > > > > I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> > > > > > > make sure the noone touches the checksum of the head
> > > > > > > skb. Otherise netfilter etc. tries to touch the csum.
> > > > > > >
> > > > > > > Before chaining I make sure that ip_summed and csum_level is
> > > > > > > the same for all chained skbs and here I restore the original
> > > > > > > value from nskb.
> > > > > >
> > > > > > This is safe because the skb_gro_checksum_validate will have validated
> > > > > > already on CHECKSUM_PARTIAL? What happens if there is decap or encap
> > > > > > in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
> > > > > > imagine.
> > > > >
> > > > > Yes, the checksum is validated with skb_gro_checksum_validate. If the
> > > > > packets are UDP encapsulated, they are segmented before decapsulation.
> > > > > Original values are already restored. If an additional encapsulation
> > > > > happens, the encap checksum will be calculated after segmentation.
> > > > > Original values are restored before that.
> > > >
> > > > I was wondering more about additional other encapsulation protocols.
> > > >
> > > > >From a quick read, it seems like csum_level is associated only with
> > > > CHECKSUM_UNNECESSARY.
> > > >
> > > > What if a device returns CHECKSUM_COMPLETE for packets with a tunnel
> > > > that is decapsulated before forwarding. Say, just VLAN. That gets
> > > > untagged in __netif_receive_skb_core with skb_vlan_untag calling
> > > > skb_pull_rcsum. After segmentation the ip_summed is restored, with
> > > > skb->csum still containing the unmodified csum that includes the VLAN
> > > > tag?
> > >
> > > Hm, that could be really a problem. So setting CHECKSUM_UNNECESSARY
> > > should be ok, but restoring the old values are not. Our checksum
> > > magic is rather complex, it's hard to get it right for all possible
> > > cases. Maybe we can just set CHECKSUM_UNNECESSARY for all packets
> > > and keep this value after segmentation.
> >
> > Note that I'm not 100% sure that the issue can occur. But it seems likely.
> >
> > Yes, inverse CHECKSUM_UNNECESSARY conversion after verifying the checksum is
> > probably the way to go. Inverse, because it is the opposite of
> > __skb_gro_checksum_convert.
>
> I'm not sure if I understand what you mean here.

I mean that I agree that it's okay to convert from CHECKSUM_COMPLETE
to CHECKSUM_UNNECESSARY if the UDP checksum has been validated.

> I'd do the following
> for fraglist GRO in udp4_gro_complete:
>
>         if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
>                 if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
>                         skb->csum_level++;
>         } else {
>                 skb->ip_summed = CHECKSUM_UNNECESSARY;
>                 skb->csum_level = 0;
>         }

Akin to __skb_incr_checksum_unnecessary, but applying conversion both
in the case of CHECKSUM_NONE and CHECKSUM_COMPLETE. Makes sense.


> and then copy these values to the segments after segmentation.
