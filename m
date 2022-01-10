Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023EB488EEE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 04:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbiAJDca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 22:32:30 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:53726
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232880AbiAJDca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 22:32:30 -0500
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D8CF33F1AA
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 03:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641785548;
        bh=4sug0dLhRhcPGEjEeFGRdc9CkJbDLY5TT2Xgy/Zq/m4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=T7DWKxwchN+fWZUJ+Tfjk/Smw4rzudIc1H3vMcBBE37SVwYfdvvLswq+b5pKULZyU
         s2mZbgKvxKuG+HoYPuWTcdcrFt0/nksi+0TWkmDnSbLOOxZ1otOCR4NdwVjqxxBTkY
         rYWsVGUFFT5Bu6y7tcccmwAauRs+BMY+V+Fp4/zO47/BgQoXlyy41lCcVOpxUEzzMQ
         Q1zhQAuB00eKoQHo43Xn1KELlYdldnMGDTTZafDChjOFQUZOqBSnSAmdH+0QdRlUc0
         jlxhFaddkAN8hjtYwb8NMJ60feY3iRVk2aD5iejlt+JeCnMfTbkEbk2vBEc3OLew8D
         rbwFDhvcQ/1jA==
Received: by mail-oi1-f199.google.com with SMTP id s131-20020acac289000000b002c6a61fd43fso9177774oif.23
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 19:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4sug0dLhRhcPGEjEeFGRdc9CkJbDLY5TT2Xgy/Zq/m4=;
        b=CTq/W2a3hPRKxLz7ktF7NAOQQR0k2JKwWDQNuuzJNSDnFDTEfvO8W91pSrAKyrXImM
         iw6NEb0fq+2rdlPGMEDLQ0ALtCQ3kRHEy3SXZo0IIEgtMfV4qYf6BsB+KH1XRbIpBDZf
         xM9c0dWJrgpPHuaqYR/3XQgZo+hxfSoVU83gCKQV5i3wFOgS8SysE7yvQAXrtRMPkLyU
         k/gdaMTZPVcFgW1GXW+wT9ninw3aAcuCDvpR1Q3kmvckWi6nKn6WGFEsNQWDBaaJkrRb
         3woKvhgBagDczY/drS5J8u8yyo6LMi3p+JVqLeuANot3s3N6YncYwh9/rD1N6KaFNRjR
         mF2g==
X-Gm-Message-State: AOAM531c7cwGG1lLmtaq3Wdbp7nI+8k9z8gUAwlKRbTM5ERlML+sD1uK
        MxY/sDtqomJstuC2o0gta6K8qDrtxQ6Rw0Rr+sLCh8Ws2QCZV0QGfW3Wwh3pk+gMmHBf2zWjXD+
        zD3zk9pvXEBw8s60/AeeRz1Y1JXC0nTXio1B8tbVBcV02iI57LA==
X-Received: by 2002:a9d:6e8d:: with SMTP id a13mr11378718otr.269.1641785547703;
        Sun, 09 Jan 2022 19:32:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLsdsJgmKlmkubtw3Jj4nKMO1cuhmE8OAxmOip+T3/N5VsHQVKtOjqbMPVWPa+DqXrazfyUdGQ3mHzqHAwjIk=
X-Received: by 2002:a9d:6e8d:: with SMTP id a13mr11378703otr.269.1641785547443;
 Sun, 09 Jan 2022 19:32:27 -0800 (PST)
MIME-Version: 1.0
References: <20220105151427.8373-1-aaron.ma@canonical.com> <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com> <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch> <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 10 Jan 2022 11:32:16 +0800
Message-ID: <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 10:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 7 Jan 2022 10:01:33 +0800 Kai-Heng Feng wrote:
> > > On device creation, udev can check if it now has both interfaces? If
> > > the internal interface is up, it is probably in use. Otherwise, take
> > > its MAC address and assign it to the dock interface, and give the
> > > internal interface a random MAC address, just in case.
> > >
> > > You probably need to delay NetworkManager, systemd-networkkd,
> > > /etc/network/interfaces etc, so that they don't do anything until
> > > after udevd has settled, indicating all devices have probably been
> > > found.
> >
> > I don't think it's a good idea. On my laptop,
> > systemd-udev-settle.service can add extra 5~10 seconds boot time
> > delay.
> > Furthermore, the external NIC in question is in a USB/Thunderbolt
> > dock, it can present pre-boot, or it can be hotplugged at any time.
>
> IIUC our guess is that this feature used for NAC and IEEE 802.1X.
> In that case someone is already provisioning certificates to all
> the machines, and must provide a config for all its interfaces.
> It should be pretty simple to also put the right MAC address override
> in the NetworkManager/systemd-networkd/whatever config, no?

If that's really the case, why do major OEMs came up with MAC
pass-through? Stupid may it be, I don't think it's a solution looking
for problem.

Kai-Heng
