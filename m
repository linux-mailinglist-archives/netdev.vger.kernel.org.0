Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5F12AFD18
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgKLBcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgKLAJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:09:28 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC60C0613D6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:09:28 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so4109188ljh.0
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:subject:from:to:cc:date:message-id
         :in-reply-to;
        bh=YpKaaRPsDMRdfM5Oyx4EUX64onvFI11DYWxHG34RLy8=;
        b=u3TiZg73UXAkeXWaq+dvf207SlksHBcYaeU8mVUPBPpJtKql+6/DNMDbpI+CxfXFr2
         izbp0S1PalgSe3RPhjQzABH8vwnWdUJtxQ493Fd01w5VGQeYXIgUtrfhDTKsZUjk1SQm
         KirqYaNoSmRrwZ/KKP3p64ZARaJ74kwrGTVqWA+qXpHD7YCxFTj/J5BIKdDIwCzj7QW3
         5xvZnfuqo4GcAIRfA8yTB3RU6K/N5c0ZFq8aZku+qxLR/1eFfxWtMHSe7b6hPUmRQRTB
         gLBIH1N8ETobkwht8/F6SLsaWAzjKA6+OexGRPPNNdnI9trT9i4PdVNlFyKJNvD+x4jn
         Frig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:subject:from:to:cc
         :date:message-id:in-reply-to;
        bh=YpKaaRPsDMRdfM5Oyx4EUX64onvFI11DYWxHG34RLy8=;
        b=QW6puJ32NtWzrRF3muINVbimj9MJ7w8oJLSRuLGJyRbDGUvEkpXIq4kTaJc92v4BZv
         DZz2UvgfQH4kDPtKUAPOhPFXBJO4kRpEBDiRRCI+6GTVFFqp9ypQK1ECZBHpC5safuGn
         74I3E8I+2Onk9TPUoVWCP8KIltpbDR+usZyG0xxyuBCJWABubgRQPNkMKOYG6aXcn6yy
         IB9Qw29En25rDvAKlPUk3IetD74wiANv4TcA4Wr4YszIrA7nALuN7vaxtqnBIMnKxhlg
         8YoiO5JE5X1ynT5PfLcev2L1yL67EsYsLSmv8+lqC+jfk8nOAL6Wi2InQbef6hyNPUve
         vJew==
X-Gm-Message-State: AOAM531UBFC1HbHk6r+brxg8gSTuCiJYThvBYOJLOPGshCxhh5Qxb4k1
        HAijo63hArObhiAuwNW0mZ/fUURZVvAe0HUu
X-Google-Smtp-Source: ABdhPJyt1uD6nXHZhdZfW+dARr/bcOzruUdtrF2gWUzYJ4OEG4qdqK9AwjOF3Jo8N7+f0aF84B3Icg==
X-Received: by 2002:a05:651c:107:: with SMTP id a7mr6624505ljb.463.1605139766503;
        Wed, 11 Nov 2020 16:09:26 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id l30sm366928lfk.119.2020.11.11.16.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 16:09:25 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: 6352: parse VTU data
 before loading STU data
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <netdev@vger.kernel.org>
Date:   Thu, 12 Nov 2020 00:49:03 +0100
Message-Id: <C70U4J6VK2TJ.208R8QGGUAN47@wkz-x280>
In-Reply-To: <20201111152732.6328f5be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Nov 11, 2020 at 4:27 PM CET, Jakub Kicinski wrote:
> On Sun, 8 Nov 2020 23:38:10 +0100 Tobias Waldekranz wrote:
> > On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
> > will leave you with both the member- and state- data in the VTU/STU
> > data registers. But on the 6097 (which uses the same implementation),
> > the STU GetNext will override the information gathered from the VTU
> > GetNext.
> >=20
> > Separate the two stages, parsing the result of the VTU GetNext before
> > doing the STU GetNext.
> >=20
> > We opt to update the existing implementation for all applicable chips,
> > as opposed to creating a separate callback for 6097. Though the
> > previous implementation did work for (at least) 6352, the datasheet
> > does not mention the masking behavior.
> >=20
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >=20
> > I was not sure if I should have created a separate callback, but I
> > have not found any documentation that suggests that you can expect the
> > STU GetNext op to mask the bits that are used to store VTU membership
> > information in the way that 6352 does. So depending on undocumented
> > behavior felt like something we would want to get rid of anyway.
> >=20
> > Tested on 6097F and 6352.
>
> I'm unclear what this fixes. What functionality is broken on 6097?

VLAN configuration. As soon as you add the second port to a VLAN, all
other port membership configuration is overwritten with zeroes. The HW
interprets this as all ports being "unmodified members" of the VLAN.

I suspect that is why it has not been discovered. In the simple case
when all ports belong to the same VLAN, switching will still work. But
using multiple VLANs or trying to set multiple ports as tagged members
will not work.

At the lowest level, the current implementation assumes that it can
perform two consecutive operations where each op will load half of a
register, and then read out the union of the information. This is true
for some devices (6352), but not for others (6097).

6352 pseudo-hdl-in-c:

stu_get_next()
{
	*data |=3D stu_data & 0xf0f0;
}

vtu_get_next()
{
	*data |=3D vtu_data & 0x0f0f;
}

6097 pseudo-hdl-in-c:

stu_get_next()
{
	*data =3D stu_data;
}

vtu_get_next()
{
	*data =3D vtu_data;
}

> Can we identify the commit for a fixes tag?

I will try to pinpoint it tomorrow. I suppose I should also rebase it
against "net" since it is a bug.
