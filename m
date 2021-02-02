Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947B030CBCF
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhBBTgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:36:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239877AbhBBTfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 14:35:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3F3A64E39;
        Tue,  2 Feb 2021 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612294498;
        bh=WC5Lt7FO1YCCTlx62ZrKm1lIJjAacPhiw1YwF3tHUJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HeNWkMoDFzRTV5ILjCtPyxS6/ZeLWABp9ipxmY0mPZ/HqVYwm1x44OnL02CuYAft2
         0EGKzulbkp2NFOKpDhRuaVz3N5g0mFFusjnVHWRRe5jnP/9VDWTNDEqdsGJF8FeBL/
         CyfzeTZumODueoaPmZ0kNC0qooUOGKGecoYVs8/f1AywzzH4vYqfWuw0hPvPkjE5C/
         cW3q5thnzxvZqv3rHYFXaRY0F4oEACAj5kYumtwCT/Q0aIhyMeZ17Xym/ehOtsPNWt
         yQ2Iuum6N1R/+rvPtqIS+2YNkCFjX7MrOuOxcXwGMsC8LaI8YQT03Fk+yP4S/jYq3J
         GVb3sSo1u2gEQ==
Date:   Tue, 2 Feb 2021 11:34:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87bld2smi9.fsf@toke.dk>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
        <20201207135433.41172202@carbon>
        <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
        <20201207230755.GB27205@ranger.igk.intel.com>
        <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
        <20201209095454.GA36812@ranger.igk.intel.com>
        <20201209125223.49096d50@carbon>
        <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
        <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
        <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
        <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
        <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com>
        <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
        <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
        <87h7mvsr0e.fsf@toke.dk>
        <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
        <87bld2smi9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Feb 2021 13:05:34 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Marek Majtyka <alardam@gmail.com> writes:
>=20
> > Thanks Toke,
> >
> > In fact, I was waiting for a single confirmation, disagreement or
> > comment. I have it now. As there are no more comments, I am getting
> > down to work right away. =20
>=20
> Awesome! And sorry for not replying straight away - I hate it when I
> send out something myself and receive no replies, so I suppose I should
> get better at not doing that myself :)
>=20
> As for the inclusion of the XDP_BASE / XDP_LIMITED_BASE sets (which I
> just realised I didn't reply to), I am fine with defining XDP_BASE as a
> shortcut for TX/ABORTED/PASS/DROP, but think we should skip
> XDP_LIMITED_BASE and instead require all new drivers to implement the
> full XDP_BASE set straight away. As long as we're talking about
> features *implemented* by the driver, at least; i.e., it should still be
> possible to *deactivate* XDP_TX if you don't want to use the HW
> resources, but I don't think there's much benefit from defining the
> LIMITED_BASE set as a shortcut for this mode...

I still have mixed feelings about these flags. The first step IMO
should be adding validation tests. I bet^W pray every vendor has
validation tests but since they are not unified we don't know what
level of interoperability we're achieving in practice. That doesn't
matter for trivial feature like base actions, but we'll inevitably=20
move on to defining more advanced capabilities and the question of
"what supporting X actually mean" will come up (3 years later, when
we don't remember ourselves).
