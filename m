Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4172B14A5D9
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbgA0OQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgA0OQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:16:25 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 041A020720;
        Mon, 27 Jan 2020 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580134584;
        bh=QLGC/g2xFAJN+jsIisFFPeLyrH5w+wY1dxT5ukxBkb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWEntD3rXuODof0e3KbboePBtmXLkbL5G+pAvafXfyQClD4eL5s1liJsLRXMU1fE/
         2YgkDjPK9mhRL5h3pD8pfNiXSTdob9bcyrOYl5a1WGrVDhMy8XLY0tu5I8CdAq9c2D
         UICfprxvg1YkgY5fxzCoTdZNUbzQvioCLhXEeemQ=
Date:   Mon, 27 Jan 2020 06:16:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200127061623.1cf42cd0@cakuba>
In-Reply-To: <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 21:03:15 -0700, David Ahern wrote:
> On 1/26/20 3:11 PM, Jakub Kicinski wrote:
> > I looked through the commit message and the cover letter again, and you
> > never explain why you need the egress hook. Could you please clarify
> > your needs?  =20
>=20
> XDP is about efficient network processing - ie., bypassing the Linux
> stack when it does not make sense for the person deploying some
> solution. XDP right now is Rx centric.

Network hardware is also "Rx centric" and somehow it works..

> I want to run an ebpf program in the Tx path of the NIC regardless of
> how the packet arrived at the device -- as an skb or an xdp_frame. There
> are options for running programs on skb-based packets (e.g., tc). There
> are *zero* options for manipulating/controlling/denying xdp_frames -
> e.g., one REDIRECTED from an ingress device.

Okay - so no precise use case.  You can run the same program at the=20
end of whatever is doing the redirect (especially with Alexei's work=20
on linking) and from cls_bpf =F0=9F=A4=B7=E2=80=8D=E2=99=82=EF=B8=8F

I'm sure all driver authors can't wait to plough through their TX paths
:/
