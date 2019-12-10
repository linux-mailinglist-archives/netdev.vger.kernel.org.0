Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F9117C3D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 01:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfLJASk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 19:18:40 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46727 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfLJASj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 19:18:39 -0500
Received: by mail-pf1-f196.google.com with SMTP id y14so8068522pfm.13
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 16:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yR1KySs+qQP0dJ1gc6Y3Ylu4ra2zW/p9kEKFua+/qu4=;
        b=xOuetOzK7jpTSuWGsrj82iBN1wkwIE05VOzQMi0hYWSu4Dt5qQz9XcWGfZdST7Iuwv
         y4caUubRi6zNGl53A9zz0NW2Ci7JjVSPIDKm5YRtt4eFvz828uriCkDxXz04R97bdGuT
         olnJ7OGNyWhguJi2GQHYcYG9Ebbu2342pgGfAamLA9nhmcn9J0dHpBy69JV8YNExxwfh
         sNcZVTT9rZnhds1mR0m2GU4g3KHaun1ODmJfAPwm0Ou/469ZawwNSjxLi6uU6wjR9pzz
         b8349jQEmIxobfOkB+el7XJVdfWjF47LUc5c+urTxhGlSK47JqfBkvL5KL3nZXOgwrTQ
         F8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yR1KySs+qQP0dJ1gc6Y3Ylu4ra2zW/p9kEKFua+/qu4=;
        b=MMgEwfFfzbZZn35gdSusDFRleM9A7g+ZJ3PONwiW/Tw6WL0TSZMh7jpzotXFetstef
         IWlwodiFYh5IWcQsGYhPltwHBm1PNxqEV6+w9SqNAo+V52U4iCZFanqnVDep65tVglRd
         ryYluUUKd8RxQZ3xfYhdqH7RDSP49A63i4Bp/1Gjy6vu8noKvFt0TONghN05LxBP9Pjd
         Z2gocjKulpebrON6nHFPPJv7MY3bwf8lJ7FYif34zmxYAATWBzxRSmBkmcY8yD2OxrLM
         2SwxB8F0gnFlc/SFdOXhWKiy2h5lBJdpJlG9p0O955MAy6lm3RUSFyMcuaxXIcueFO+1
         6hrA==
X-Gm-Message-State: APjAAAXEN85tM6K1B7qpmhDpgMTx6J8GINmF3vq2vhQzO1954VSnpkr1
        JWsgGmH2C5mBN8/9xVrKArXlOQ==
X-Google-Smtp-Source: APXvYqxg7D1dBaCApAPv7fIACWzG+g9WKWTF3nPZnp2Y8FQoJuPpNUulT0HNxVkqcL+FpeHfn+LPYA==
X-Received: by 2002:a65:5bc3:: with SMTP id o3mr21255099pgr.226.1575937119193;
        Mon, 09 Dec 2019 16:18:39 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g8sm617234pfh.43.2019.12.09.16.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 16:18:39 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:18:35 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Message-ID: <20191209161835.7c455fc0@cakuba.netronome.com>
In-Reply-To: <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
        <20191209224530.156283-1-zenczykowski@gmail.com>
        <20191209154216.7e19e0c0@cakuba.netronome.com>
        <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 01:02:08 +0100, Maciej =C5=BBenczykowski wrote:
> > Could you elaborate what protocols and products are in need of this
> > functionality? =20
>=20
> The ones I'm aware of are:
> (a) Google's servers
> (b) Android on at least some chipsets (Qualcomm at the bare minimum,
> but I think it's pretty standard a solution) where there's a complex
> port sharing scheme between the Linux kernel on the Application
> Processor and the Firmware running on the modem (for ipv4 we only get
> one ip address from the cellular carrier).  It's basically required
> for things like wifi calling to work.

Okay, that's what I was suspecting.  It'd be great if the real
motivation for a patch was spelled out in the commit message :/

So some SoCs which run non-vanilla kernels require hacks to steal
ports from the networking stack for use by proprietary firmware.

I don't see how merging this patch benefits the community.

> > Why can't the NIC just get its own IP like it usually does with NCSI? =
=20
>=20
> Because often these nics are deployed as in place upgrades in
> environments where there's a limited number of IPs.
> Say a rack with a /27 ipv4 subnet (2**5 =3D 32 -> 29 usable ips, since
> network/broadcast/gateway are burned) and 15+ pre-existing machines.
> This means there's not enough IPs to assign separate ones for the nics.
> Renumbering the rack, would imply renumbering the datacenter, etc...
> And ipv4 - even RFC1918 - has long run out - so even in new
> deployments there's not enough IPv4 ips to give to nics, and IPv6
> isn't yet deployed *everywhere*.

So the conditions for this are:
 - in-place upgrade of an existing rack
 - IPv4 only
 - the existing servers didn't have NCSI or otherwise IPs for OOB
   control

Unlike the AP one this sounds like a very rare scenario..
