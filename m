Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A959A27D150
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgI2OhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:37:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46452 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgI2OhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:37:07 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601390224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VmCiL2ZmrGBEC6BMl9JAzfcplFXUuQxSEoukFP38Qc=;
        b=V1+jfdupgUDguwQLoSfM1UDKyK97umPBk3RCJPtrXvo3HjkrAv7oZ8d769kr1UDVOiqeTZ
        dYLZ91gc/sIaO50hcs95TdgAz48RhfBSdsMS4DBcFHFsnovSq6VpdWIndCw/TDoShwfw6K
        +9gek94Fbm54gtYRDPDw8mmMw1zu7wsXy4XgCJqs+Ou4lV81QykEgsNo9DjLsy3AKB/AQT
        G576m9HeX1S7jQnyrTObW1HKy1c9vZ/qj50V8IIaFz92XDLpVe1/eK2AHh590q7RBBj8DC
        CNoJkwrvYs+wq1wIIZrzEBqJCA9sxTEj2C2ebwz12LDtKQOxv8zXpvTIG+C0Uw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601390224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VmCiL2ZmrGBEC6BMl9JAzfcplFXUuQxSEoukFP38Qc=;
        b=sPt4IoTcBHRSkKQG9REMY6x9b+3JCLHw6ozsiGzdslM4l4/myrfh7jYnJBRfn53aNiiK7S
        jsmrp6TrTiHQFoDA==
To:     Shannon Nelson <snelson@pensando.io>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [patch 11/35] net: ionic: Replace in_interrupt() usage.
In-Reply-To: <1d0950f8-cab4-9ef2-6cf7-73b71b750a8d@pensando.io>
References: <20200927194846.045411263@linutronix.de> <20200927194920.918550822@linutronix.de> <5e4c3201-9d90-65b1-5c13-e2381445be1d@pensando.io> <1d0950f8-cab4-9ef2-6cf7-73b71b750a8d@pensando.io>
Date:   Tue, 29 Sep 2020 16:37:04 +0200
Message-ID: <87h7rgk5tb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28 2020 at 12:51, Shannon Nelson wrote:
> On 9/28/20 10:24 AM, Shannon Nelson wrote:
>>> ionic_lif_addr() can be called from:
>>>
>>> =C2=A0 1) ->ndo_set_rx_mode() which is under netif_addr_lock_bh()) so i=
t=20
>>> must not
>>> =C2=A0=C2=A0=C2=A0=C2=A0 sleep.
>>>
>>> =C2=A0 2) Init and setup functions which are in fully preemptible task=
=20
>>> context.
>>>
>>> _ionic_lif_rx_mode() has only one call path with BH disabled.
>
> Now that I've had my coffee, let's look at this again - there are=20
> multiple paths that get us to _ionic_lif_rx_mode():
>
> .ndo_set_rx_mode
>  =C2=A0 ionic_set_rx_mode,
>  =C2=A0=C2=A0=C2=A0 _ionic_lif_rx_mode
>
> { ionic_open, ionic_lif_handle_fw_up, ionic_start_queues_reconfig }
>  =C2=A0=C2=A0=C2=A0 ionic_txrx_init
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ionic_set_rx_mode
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _ionic_lif_rx_mode

Hrm. Let me stare at it again...
