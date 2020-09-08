Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833A7261A49
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbgIHSee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731687AbgIHSe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:34:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE882080A;
        Tue,  8 Sep 2020 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599590069;
        bh=Q2aUeWbmIlzFAIQ2g+Em1W7hGUhQ3SdVjRw0XbA9Qjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mz+X30XHvoisG0Te7TqkD0luE9o9NUqKpjRKbe02fUXLCRpPFOC1s1AcGtPTvCqsr
         zvd5u2MFdNMkm0rHdRb80dzIDVHtb8Vd9AoIntUG5pA+WHW8CKX8DSlJZUp7h1z7TH
         xmuhU7/QNb4YE1ekcr+6iF9WceYwVNz94FcqLG7c=
Date:   Tue, 8 Sep 2020 11:34:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
Message-ID: <20200908113426.7af79b5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <12536115-3dae-1efa-5c0d-34fc951fca48@intel.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <20200904162751.632c4443@carbon>
        <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
        <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
        <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8f698ac5-916f-9bb0-cce2-f00fba6ba407@intel.com>
        <20200908102438.28351aab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <12536115-3dae-1efa-5c0d-34fc951fca48@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 20:28:14 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> On 2020-09-08 19:24, Jakub Kicinski wrote:
> >> I'll start playing around a bit, but again, I think this simple series
> >> should go in just to make AF_XDP single core usable*today*. =20
> > No objection from me. =20
>=20
> Thanks Jakub, but as you (probably) noticed in the other thread Maxim=20
> had some valid concerns. Let's drop this for now, and I'll get back=20
> after some experimentation/hacking.

Yeah, I sort of assumed you got the wake-up problem down :S

If it gets complicated it may not be worth pursuing this optimization.
