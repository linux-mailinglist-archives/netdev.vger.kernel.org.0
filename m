Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8854AD83DD
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389978AbfJOWkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:40:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50325 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732775AbfJOWkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:40:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so733869wmg.0
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iZRsPQdHp9SLgaak0uCg5zZVvF+bpajXIslG7GktzEQ=;
        b=1zG6JhapAFrNl9H/G9haIjwOSPhXxIzgd+JP8SxRf8dnolCqxWD1w6CO7HDJsTyypi
         +A6EfO2IJXDbdIdoYxIX3WO8yav7uD01sSFSZUD2HUCArC6u28MFvlqLS4IgjbGTLoFS
         O0kqSq6o1QnhEFkfh3asOqJLit5Dq6ibvv06O9x6Lut3VGsWFCT7vANBNOU1XDozmgtE
         rJWRhQwVKSRSCs1W2UVQrvoFSr0xaGywDweOnuNMkbJ07BLg+1sU37WWQqaMd6AZtSAJ
         otPBO3uDRRWfdhwm41enVEbzlXHiFNc5PhpDwEAMA/SMlOpClNF/+KO9a61XGhW9oBI6
         PP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iZRsPQdHp9SLgaak0uCg5zZVvF+bpajXIslG7GktzEQ=;
        b=OJSxBxXxd3qR+Qrvr88vMygmSUW7/dWGgxYZW8yqb2hmCEHWOedZiHqmjg76IaP0On
         8sAW98XFlggcZHfwnKXe151/cpw0V/X4cizGtFfhfgEQyJ7mfiKDkn9dUtyvJVZPEdNq
         gubLsJY352C1MaH878Mn/2DItZQv6sEMtrJWBbbo0cGVAmlbNjS3s+rttH1jiDmSKoW/
         AyHvQi7ZnJVwpsvIMq0+p4EZCVpHytm/W92pzrYlFN1ahNpqI53denURimbtANaBXr3V
         MUSowuMWXvcJg2PwrBWJchwAe365XNK9UqmUbg+l5CODcJY/bFiv9V4p0pCw9IkwbZEy
         AuBQ==
X-Gm-Message-State: APjAAAVKGVD6h7rlfd9j/Sz4wXczyoGUZuGXQjbFU+VdrDE23BLfkHWW
        FojIN+Uh/ZUSv8hpnqmxeKjqVQ==
X-Google-Smtp-Source: APXvYqxcr2ndTUnfFqjZeUrSWhp8vJGQEpy/4ricJO83dIPWdZTjkTrWK4vpO8W2+oYAH/slWJDg+g==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr711493wmc.78.1571179206429;
        Tue, 15 Oct 2019 15:40:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x5sm41120834wrg.69.2019.10.15.15.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 15:40:06 -0700 (PDT)
Date:   Tue, 15 Oct 2019 15:39:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Scott Branden <scott.branden@broadcom.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if
 none is valid
Message-ID: <20191015153955.2e602903@cakuba.netronome.com>
In-Reply-To: <dda8587a-0734-d294-5b50-0f5f35c27918@broadcom.com>
References: <20191014212000.27712-1-f.fainelli@gmail.com>
        <dda8587a-0734-d294-5b50-0f5f35c27918@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 15:32:28 -0700, Scott Branden wrote:
> > @@ -3482,7 +3476,12 @@ static int bcmgenet_probe(struct platform_device=
 *pdev)
> >  =20
> >   	SET_NETDEV_DEV(dev, &pdev->dev);
> >   	dev_set_drvdata(&pdev->dev, dev);
> > -	ether_addr_copy(dev->dev_addr, macaddr);
> > +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
> > +		dev_warn(&pdev->dev, "using random Ethernet MAC\n"); =20
>=20
> I would still consider this warrants a dev_err as you should not be=20
> using the device with a random MAC address assigned to it.=C2=A0 But I'll=
=20
> leave it to the "experts" to decide on the print level here.

FWIW I'd stick to warn for this message since this is no longer a hard
failure.
