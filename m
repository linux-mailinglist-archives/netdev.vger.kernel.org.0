Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3ADA2A368A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgKBW3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKBW3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:29:33 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0B602084C;
        Mon,  2 Nov 2020 22:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604356173;
        bh=vgrwy0iif/zfUH5W0QwiDlRFpUGSrjVFDagmDSNOjTk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KhMDkz4Rm+nHJ7kxJJgwy3rM/BDg0xMRZbw+jzPrroi5aLZzXqPofqhUkjAk+26m9
         wIMOHeZpCsdOVbpt8Zxwiw3DU+rFnqETl8LzDGESn0xtTAJgix6STw1iDsNYjXoeUO
         sLil+xiyxoGCRRwlye7hMWFCwdMtEwKFeANSK0K0=
Received: by mail-wr1-f45.google.com with SMTP id s9so16363213wro.8;
        Mon, 02 Nov 2020 14:29:32 -0800 (PST)
X-Gm-Message-State: AOAM530elnjKg/a2GnNd1Q5qnX9m7rhyOO0Uj2hh6cqyh8iLu2gI9GYo
        MUvElyeOAwtaKMTzZGx6tEETntLFoyZdvS4PnS0=
X-Google-Smtp-Source: ABdhPJzNva6GR+sZYSg7O8WrzaYdrgPHJcMRi6tR4zAYJKbScVeSsRIfBeLJT2A1pExuYy1QE1Ai59H9xNPMMAd7bww=
X-Received: by 2002:a5d:54c8:: with SMTP id x8mr21719103wrv.286.1604356171388;
 Mon, 02 Nov 2020 14:29:31 -0800 (PST)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201026213040.3889546-8-arnd@kernel.org>
 <87tuu7ohbo.fsf@codeaurora.org> <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
In-Reply-To: <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Nov 2020 23:29:15 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0_6zigntTWQs2vhJNwagmYyVHPQE2HggVVTmn+2u8siw@mail.gmail.com>
Message-ID: <CAK8P3a0_6zigntTWQs2vhJNwagmYyVHPQE2HggVVTmn+2u8siw@mail.gmail.com>
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc warning
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 7:01 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2020-11-02 at 18:26 +0200, Kalle Valo wrote:
> > Arnd Bergmann <arnd@kernel.org> writes:
> > > From: Arnd Bergmann <arnd@arndb.de>
> >
> > Isn't there a better way to handle this? I really would not want
> > checking for GCC versions become a common approach in drivers.
> >
> > I even think that using memcpy() always is better than the ugly ifdef.
>
> If you put memcpy() always somebody will surely go and clean it up to
> use ether_addr_copy() soon ...
>
> That said, if there's a gcc issue with ether_addr_copy() then how come
> it's specific to this place?

I have not been able to figure this out, hopefully some gcc developer
eventually looks at the bug in more detail.

Presumably it has something to do with the specific way the five levels
of structures are nested here, and how things get inlined in this driver.
If the bug happened everywhere, it would likely have been found and
fixed earlier.

       Arnd
