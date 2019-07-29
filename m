Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2A7918C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbfG2Qzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:55:37 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36967 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfG2Qzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:55:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id i70so17813104pgd.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VCrgU88KkMCvWVoIPrZGlh3p115cO9rxPu95giiojSo=;
        b=f3bMHMCebuKfdXiogzFAjHwa2nvD4c8UFEoKLrQZupRU29fHVVc/OPS8zj9yQkoX+r
         lXLNqfqRHY8xphwre9/+yVbf/u0zuQFkygnXx81vNqyRwz/KRNgnWVNhLxPPIEroCCt3
         e8zYj1gKTBfLqgWk0RqvTymVV4duxgPVpJRVwwCwbcGMv9KryhgqFkBeesgWGhTy0Itz
         ZRX1sO/sAYdqa788HLD33wmgsbfEP+zuZ9JDN7xFHRJsgkcMVKczWiGi4Y7SNuJYR/oE
         MK8uZ4kgZoAmtnrNi0LWNulMaQsHNkzwlGePQxwrxf/JtawHbqZO+WcGu1pBlhmoBad/
         z0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VCrgU88KkMCvWVoIPrZGlh3p115cO9rxPu95giiojSo=;
        b=JhZWbiR8zQDg0OPvl3LocxY2sLZBZjmf6W4FGPplOAKiLbJFjSLL2y5YCSb8k5rY5I
         tyJhb8NjrOUIUpsC3ND5160aS1uUwDh9Ymt0YYIZfddVpATpNTWV1mzd+TsgevEyzUfU
         t0mzglR9bbjcYn6sB2TzOyFwe26Sh1GfAl2gnIwo9ssp2RdhX6JdXgMNuOrs5kV27Uw5
         Fa+lSDzOtRtvsrim3Tgiyv5iRqzbG5EJsVpneFwGU+H6vy0eaEklFokAws+cgmLPwcoX
         VUYmU76W+/vyZk5I11tZtKV9lhvylqMI0pWxQDcb9xP2Onz/yKDbEHH6GYwcf5TFvYGP
         UL+w==
X-Gm-Message-State: APjAAAV8yAyzfZVPOFllRidrDn3ojy8eEsDPthaLF+PtcxoTeVpmox6w
        JQkQgHgLxClO/KlEkpxPry5J+kB4k/E=
X-Google-Smtp-Source: APXvYqy4wVBZFW0RYGWkFo9QNdQThI6p5AIOevfYSFs+kP8gszKvYgxytXbtWwzMT64za+MUQsR61w==
X-Received: by 2002:a63:5c7:: with SMTP id 190mr103117049pgf.67.1564419336162;
        Mon, 29 Jul 2019 09:55:36 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y11sm64902766pfb.119.2019.07.29.09.55.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:55:35 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:55:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190729095526.17214c4d@cakuba.netronome.com>
In-Reply-To: <449a5603-80e9-ad7d-5c02-bf57558f9603@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
        <20190728131653.6af72a87@cakuba.netronome.com>
        <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
        <20190728214237.2c0687db@cakuba.netronome.com>
        <449a5603-80e9-ad7d-5c02-bf57558f9603@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 15:18:03 +0800, wenxu wrote:
> On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
> > On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote: =20
> >> On 7/29/2019 4:16 AM, Jakub Kicinski wrote: =20
> >>> I don't know the nft code, but it seems unlikely it wouldn't have the
> >>> same problem/need..   =20
> >> nft don't have the same problem.=C2=A0 The offload rule can only attac=
hed
> >> to offload base chain.
> >>
> >> Th=C2=A0 offload base chain is created after the device driver loaded =
(the
> >> device exist). =20
> > For indirect blocks the block is on the tunnel device and the offload
> > target is another device. E.g. you offload rules from a VXLAN device
> > onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
> > device is created.
> >
> > So I feel like either the chain somehow directly references the offload
> > target (in which case the indirect infrastructure with hash lookup etc
> > is not needed for nft), or indirect infra is needed, and we need to take
> > care of replays. =20
>=20
> I think the nft is different with tc.=C2=A0
>=20
> In tc case we can create vxlan device add a ingress qdisc with a block su=
ccess
>=20
> Then the ASIC driver loaded,=C2=A0 then register the vxlan indr-dev and g=
et the block
> adn replay it to hardware
>=20
> But in the nft case,=C2=A0 The base chain flags with offload. Create an o=
ffload netdev
> base chain on vxlan device will fail if there is no indr-device to offloa=
d.

Can you show us the offload chain spec? Does it specify offload to the
vxlan device or the ASIC device?

Indir-devs can come and go, how do you handle a situation where offload
chain was installed with indir listener present, but then the ASIC
driver got removed?
