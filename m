Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A079A595919
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiHPK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiHPK6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5F1115D;
        Tue, 16 Aug 2022 02:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0A0A612E3;
        Tue, 16 Aug 2022 09:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF857C433D6;
        Tue, 16 Aug 2022 09:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660643766;
        bh=KGqgRjj65GzNWEZUhJwJm7+5polHXyIxiGSPcOuQRjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIf/NI4ULSh98+TOqcXriM7JA2oIsOuY3hLIjdeGxg+z9y+kV4xvqU6tThMDhmUiT
         Z7vGlizuLvL1MSMsYVivFqGKFhuKD6TnpxaA0abJzbmwuc0d1zNoXE1f0S5Rt7kbti
         +jolnZdOAxgCGmQx9uFd3p1TYv9oDsHKeOnybtbLe4vhS40Amn6XQGUJM5h4JE3d0F
         5O2qD74OasBr978tN9YEkAOOrrAjr+3duFVzyAEO7PE0WLR0OGmKe+yf8P19brK3Kf
         4NrWg1R49iL4qWN5byVnKdvjfU+urGFummhOv4e1X/SQEFlnzh5eDkkAyIOAn377X0
         JDbdh5AhsYAhA==
Date:   Tue, 16 Aug 2022 11:56:02 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next] xdp: report rx queue index in xdp_frame
Message-ID: <Yvtpsqv7xv2g7I6N@lore-desk>
References: <181f994e13c816116fa69a1e92c2f69e6330f749.1658746417.git.lorenzo@kernel.org>
 <YvtnOloObaUxpR1O@lore-desk>
 <4e717cbe-17a2-dbae-d557-0b29eaa28dae@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ypv4yLEnqsdTPUmt"
Content-Disposition: inline
In-Reply-To: <4e717cbe-17a2-dbae-d557-0b29eaa28dae@iogearbox.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ypv4yLEnqsdTPUmt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 8/16/22 11:45 AM, Lorenzo Bianconi wrote:
> > > Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_=
info
> > > pointer. xdp_frame queue_index is currently used in cpumap code to co=
vert
> > > the xdp_frame into a xdp_buff.
> > > xdp_frame size is not increased adding queue_index since an alignment=
 padding
> > > in the structure is used to insert queue_index field.
> > >=20
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >   include/net/xdp.h   | 2 ++
> > >   kernel/bpf/cpumap.c | 2 +-
> > >   2 files changed, 3 insertions(+), 1 deletion(-)
> >=20
> >=20
> > Hi Alexei and Daniel,
> >=20
> > this patch is marked as 'new, archived' in patchwork.
> > Do I need to rebase and repost it?
>=20
> Yes, please rebase and resend. Perhaps also improve the commit description
> a bit in terms of what it fixes, it's a bit terse to the reader above on
> what effect it has.

ack thx, will do.

Regards,
Lorenzo

>=20
> Thanks,
> Daniel

--Ypv4yLEnqsdTPUmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYvtpsgAKCRA6cBh0uS2t
rM0zAQCWjPHCV7ZN1i6SdcYCLrJHpccIYg2ywQJQedZmDJxdfQD7BZ8joralZAfs
Gbxs8cC5IA/GvgFcaNqwsxftNFS+wAQ=
=yg7J
-----END PGP SIGNATURE-----

--Ypv4yLEnqsdTPUmt--
