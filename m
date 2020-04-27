Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792121BB221
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD0Xp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:45:26 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:45175 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgD0Xp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 19:45:26 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d7ce4485
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 23:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=apczle9y4c4v
        WfYNc3qDKN+zuY0=; b=hD1SIDIdVBZyLO93Lm90aN+/yCgCollcgVGiEtGR3Zt9
        2uXOUFxoRKvlOCuRc7BhmLa0qiL5NIBazVVsQAbdikoLLGx8StL5jh9S3PQV4Fxz
        IknutOXpPQIFD0iRhICuD4teBXVUtknzpk4Em/H8oXHLADNJ1kW77crQPgDEQSqe
        dSIXyIfO01wM02UrOl7IbxXVnvVJySQayzUK1EErd0SSsbzsSO2ESn/F/Nfkg9TJ
        8Lx19YS6tB6bTUPtHKvsl1txIi4wILQQ06RirsUvrERLqnnOm1YWqyMt+l0Is+p1
        ML1K/DZTRpnll/NrJkTia2toAzD3Dgqt7HtU7f9u+w==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dd8d3eb1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 23:33:49 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id q10so18532340ile.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:45:23 -0700 (PDT)
X-Gm-Message-State: AGi0PubN8T/rMt+s3Z28F5V9u6x2N8z88PKn1cj8Bvmai3xPrk1lO4GP
        PAM7vM0RGuEMcKv/RDHETKciVsyPNWUsNCYLo50=
X-Google-Smtp-Source: APiQypIXYN3dmyTMOOBNU3DKjrDxepCtf78Eemfc0mBGrbH5VmMFgZ8puN8u6DqK4zqymBVUlEg42gXSrlMKoMhDBgQ=
X-Received: by 2002:a92:d98c:: with SMTP id r12mr24274739iln.224.1588031122998;
 Mon, 27 Apr 2020 16:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com> <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <877dy0y6le.fsf@toke.dk> <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
In-Reply-To: <CAHmME9r7G6f5y-_SPs64guH9PrG8CKBhLDZZK6jpiOhgHBps8g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 17:45:12 -0600
X-Gmail-Original-Message-ID: <CAHmME9r6Vb7yBxBsLY75zsqROUnHeoRAjmSSfAyTwZtzcs_=kg@mail.gmail.com>
Message-ID: <CAHmME9r6Vb7yBxBsLY75zsqROUnHeoRAjmSSfAyTwZtzcs_=kg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 5:00 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Mon, Apr 27, 2020 at 3:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 27 Apr 2020 23:14:05 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> > > Jakub Kicinski <kuba@kernel.org> writes:
> > > > On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote:
> > > >> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote:
> > > >> > A user reported that packets from wireguard were possibly ignore=
d by XDP
> > > >> > [1]. Apparently, the generic skb xdp handler path seems to assum=
e that
> > > >> > packets will always have an ethernet header, which really isn't =
always
> > > >> > the case for layer 3 packets, which are produced by multiple dri=
vers.
> > > >> > This patch fixes the oversight. If the mac_len is 0, then we ass=
ume
> > > >> > that it's a layer 3 packet, and in that case prepend a pseudo et=
hhdr to
> > > >> > the packet whose h_proto is copied from skb->protocol, which wil=
l have
> > > >> > the appropriate v4 or v6 ethertype. This allows us to keep XDP p=
rograms'
> > > >> > assumption correct about packets always having that ethernet hea=
der, so
> > > >> > that existing code doesn't break, while still allowing layer 3 d=
evices
> > > >> > to use the generic XDP handler.
> > > >>
> > > >> Is this going to work correctly with XDP_TX? presumably wireguard
> > > >> doesn't want the ethernet L2 on egress, either? And what about
> > > >> redirects?
> > > >>
> > > >> I'm not sure we can paper over the L2 differences between interfac=
es.
> > > >> Isn't user supposed to know what interface the program is attached=
 to?
> > > >> I believe that's the case for cls_bpf ingress, right?
> > > >
> > > > In general we should also ask ourselves if supporting XDPgeneric on
> > > > software interfaces isn't just pointless code bloat, and it wouldn'=
t
> > > > be better to let XDP remain clearly tied to the in-driver native us=
e
> > > > case.
> > >
> > > I was mostly ignoring generic XDP for a long time for this reason. Bu=
t
> > > it seems to me that people find generic XDP quite useful, so I'm no
> > > longer so sure this is the right thing to do...
> >
> > I wonder, maybe our documentation is not clear. IOW we were saying that
> > XDP is a faster cls_bpf, which leaves out the part that XDP only makes
> > sense for HW/virt devices.
> >
> > Kinda same story as XDP egress, folks may be asking for it but that
> > doesn't mean it makes sense.
> >
> > Perhaps the original reporter realized this and that's why they
> > disappeared?
> >
> > My understanding is that XDP generic is aimed at testing and stop gap
> > for drivers which don't implement native. Defining behavior based on
> > XDP generic's needs seems a little backwards, and risky.
> >
> > That said, I don't feel particularly strongly about this.
>
> Okay, well, I'll continue developing the v3 approach a little further
> -- making sure I have tx path handled too and whatnot. Then at least
> something viable will be available, and you can take or leave it
> depending on what you all decide.

Actually, it looks like egress XDP still hasn't been merged. So I
think this patch should be good to go in terms of what it is.
