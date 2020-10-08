Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27216287C4F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgJHTQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgJHTQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:16:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C01C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 12:16:35 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y14so4759427pfp.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 12:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pw+M4b/AQkaqKwJm/3jjJPlswpo/O8NJPCQFQX/n7mo=;
        b=HjmrqSNcRNvcfA6VjZsDViXMoeN4Wr32OIMSNhhfvzl/Z9LaDJBjbYah78rv399Ym1
         ljprmEfeh5nFgnFnfNE8/2JHfu8QflNIr5ODSxnLH/r/33tmCEPG0dvvK03gpizP5xZ4
         SHW+PhrnhRdwpp8y2A3ATx+QI/PPKLj5TzINdQOF4lNOiFjlv2vHK0Y6o7zTh5h1Bo1E
         EFA+S6BObOJt7udT6RyYbMgs6HffI5b0RxJzOaBsoNvV3hOLbaMQi77j0+eWSwZW5DnO
         6woRKlro6YshC86LJoMmHqCM8LBBStmXyppcvj81TBdjP59Ux8Qo3MVE5540BNUON7FG
         XbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pw+M4b/AQkaqKwJm/3jjJPlswpo/O8NJPCQFQX/n7mo=;
        b=NLDC5NEWQIHrHLfbmDgCAbkJPJWdI957q7zsY5xgFIB2pGa9+0mia7xDR7j3Hbym+I
         n4xnRWq4IlDXWZB7k2kwBJ0hG6UtX1tMSCjuxxjX3VAnsqRNFsABdJwNqQOPvSvoPy7M
         OmuoYu4wUBW/y0+nxNgL9gNyuRTlJQz+co+E0ffISWSRWo9JYfxYz9xgiGprlRoXDsGi
         flUrxesYaSiKYwJFda/pdknW6Hnn5BhaO3rRDwTIrmimnob9hb7/aLDSvnrKATHte4h/
         cpCu2SK7OKPLSAqAGRspzJ0mu7CC/Zbnwld5bwpCiV8bK5GtoqZ3krsEH1gg2Fxn0TY+
         tVvw==
X-Gm-Message-State: AOAM5337gJ5ghvgET9vwavLmu6aYAsoGbDMkPKgnAJ5OtwVRmBJkH61P
        vQ4aGQ9ojZ/DKDEcez/yl6g0lB+f1cTwdTYCQCQ=
X-Google-Smtp-Source: ABdhPJwYckKHTSWjUj21Bz7DYzXm4vKSL2uaEnlLNdHX9mkpvL0HHYb8PLoSCF7TPQWUOYSZjqgY8ci2DqPSrXDgCMw=
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr395211pjb.66.1602184594734;
 Thu, 08 Oct 2020 12:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com> <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
In-Reply-To: <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 8 Oct 2020 12:16:23 -0700
Message-ID: <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:04 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 1:34 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > The uninit data is allocated by packet_alloc_skb(), if dev->hard_header_len
> > is 0 and 'len' is anything between [0, tunnel->hlen + sizeof(struct iphdr)),
> > dev_validate_header() still returns true obviously but only 'len'
> > bytes are copied
> > from user-space by skb_copy_datagram_from_iter(). Therefore, those bytes
> > within range (len, tunnel->hlen + sizeof(struct iphdr)] are uninitialized.
>
> With dev->hard_header_len of zero, packet_alloc_skb() only allocates len bytes.
>
> With SOCK_RAW, the writer is expected to write the ip and gre header
> and include these in the send len argument. The only difference I see
> is that with hard_header_len the data starts reserve bytes before
> skb_network_header, and an additional tail has been allocated that is
> not used.
>
> But this also fixes a potentially more serious bug. With SOCK_DGRAM,
> dev_hard_header/ipgre_header just assumes that there is enough room in
> the packet to skb_push(skb, t->hlen + sizeof(*iph)). Which may be
> false if this header length had not been reserved.
>
> Though I've mainly looked at packet_snd. Perhaps you are referring to
> tpacket_snd?

I think what Cong means is that hard_header_len has to be set properly
to prevent an AF_PACKET/RAW user from sending a frame that is too
short (shorter than the header length). When an AF_PACKET/RAW user
sends a frame shorter than the header length, and the code on the
sending path still expects a full header, it will read uninitialized
data.

If my understanding is right, I agree on this part.

However, there's something I don't understand in the GRE code. The
ipgre_header function only creates an IP header (20 bytes) + a GRE
base header (4 bytes), but pushes and returns "t->hlen +
sizeof(*iph)". What is t->hlen? It seems to me it is the sum of
t->tun_hlen and t->encap_hlen. What are these two?
