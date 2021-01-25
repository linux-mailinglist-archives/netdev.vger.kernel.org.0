Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F6302E77
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733009AbhAYVsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:48:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732516AbhAYVsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:48:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9506221BE5;
        Mon, 25 Jan 2021 21:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611611248;
        bh=Ug/ElM38L42IzubaVCeBZBfXvpsf2+R6dss30pWwU4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N3p0U2wrhSEvPf7lmq7IYeRVR80V7B+Y3WnSG2CdcnvMNG8W9fj/9qLAdUqYwPPqw
         keb6n/S/qUu+xNQC422wZA6tJOjQHPnctHQwlf67GuTm+SfFbWnWT0AJwr2tHVzLz5
         ePsUfoUlt+BsYts1mfPfDL7GfEGo6CHkAuff3KuuCd3Stjx3hDnPU4JYSba7S3LOlZ
         nbt0DEvj0vMLikRNWUcpCvld1AaQJT+nKrsgQPVicdT1dkwMP4uDBV4SZJznNAr29z
         u6i2X8+pxS2l2t1AkhV+GJglITqDEMVQfu3BnDvf51aeQN5wPZxAYdITWPxPvfqYn+
         90NQQZy/+aR1A==
Date:   Mon, 25 Jan 2021 13:47:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, alex aring <alex.aring@gmail.com>
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of
 ipv6_rpl_sr_hdr
Message-ID: <20210125134725.5495f5b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6FEDA1B9-14CC-4EC5-A41D-A38599C8CDBD@uliege.be>
References: <20210121220044.22361-1-justin.iurman@uliege.be>
        <20210121220044.22361-2-justin.iurman@uliege.be>
        <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be>
        <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com>
        <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6FEDA1B9-14CC-4EC5-A41D-A38599C8CDBD@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 22:11:35 +0100 (CET) Justin Iurman wrote:
> >>> If you meant the old/current one, well, I don't understand why the bi=
g endian definition would look like this:
> >>>=20
> >>> #elif defined(__BIG_ENDIAN_BITFIELD)
> >>>    __u32    reserved:20,
> >>>        pad:4,
> >>>        cmpri:4,
> >>>        cmpre:4;
> >>>=20
> >>> When the RFC defines the header as follows:
> >>>=20
> >>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>> | CmprI | CmprE |  Pad  |               Reserved                |
> >>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >>>=20
> >>> The little endian definition looks fine. But, when it comes to big en=
dian, you define fields as you see them on the wire with the same order, ri=
ght? So the current big endian definition makes no sense. It looks like it =
was a wrong mix with the little endian conversion. =20
> >=20
> > Well, you don't list the bit positions in the quote from the RFC, and
> > I'm not familiar with the IETF parlor. I'm only =20
>=20
> Indeed, sorry for that. Bit positions are available if you follow the lin=
k to the RFC I referenced in the patch. It is always defined as network byt=
e order by default (=3DBE).
>=20
> > comparing the LE
> > definition with the BE. If you claim the BE is wrong, then the LE is
> > wrong, too. =20
>=20
> Actually, no, it=E2=80=99s not. If you have a look at the header definiti=
on from the RFC, you can see that the LE is correct (valid translation from=
 BE, the *new* BE in this patch).

Sigh, I see it now. Thanks!
