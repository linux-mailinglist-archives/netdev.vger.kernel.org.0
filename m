Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3EB6ACB3B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjCFRtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCFRs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:48:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE30E580E7;
        Mon,  6 Mar 2023 09:48:28 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1678124873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8lN0Yg0JRWF9rWx1AIEB0nSa4HfMfBnZ+uCfkhWx3pk=;
        b=PiDvaxw4LGrgfeWFLomToEp8NXOe127xR8zSD3xdD7fGjOODv4sckwrpJAEB88tlBkosFU
        nf6LP5VdmgBHRGVwa1jz51jWwzVGgRZsiIJSvY1nY4W+E0jx6jFLmRjXxndkQdy7f4ToNK
        /2yd6YCMRtQHSbt64qAOF1pjQYgtflD6W12UfgaUVV3pfTxHpY5jpqAMgD3wqJvAmZdNUk
        TDhu7T5Eo+bDYa1HllgrRtMl4Qa1F3FMyklmyhQn4sSPmh8r28NtGZGU7cKnFqGy2qtQiP
        At9OFLPA7Pm2BbHUjdQJpIkZtI8RbdF058x16bISYmOmfb00kzLASOY0WsAbnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1678124873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8lN0Yg0JRWF9rWx1AIEB0nSa4HfMfBnZ+uCfkhWx3pk=;
        b=ejETIPzH+UYpQsQdDQiRzE7D1rokyyVF4y27HoO9uGNVQmgJFYg6wLL2/QhqIOxHbMW615
        kjHmGjANoELoCKDQ==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Gene Chen <gene_chen@richtek.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v4 11/11] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
In-Reply-To: <ZAYMvVR+6eQ9qjAk@smile.fi.intel.com>
References: <20230103131256.33894-1-andriy.shevchenko@linux.intel.com>
 <20230103131256.33894-12-andriy.shevchenko@linux.intel.com>
 <ZAYMvVR+6eQ9qjAk@smile.fi.intel.com>
Date:   Mon, 06 Mar 2023 18:47:51 +0100
Message-ID: <87jzztbwl4.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Mar 06 2023, Andy Shevchenko wrote:
> On Tue, Jan 03, 2023 at 03:12:56PM +0200, Andy Shevchenko wrote:
>> LED core provides a helper to parse default state from firmware node.
>> Use it instead of custom implementation.
>
> Jakub, if you are okay with thi, it may be applied now
> (Lee hadn't taken it in via LEDS subsystem for v6.3-rc1).

I think you have to repost this one separately to netdev, so that it
shows up in patchwork.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJGBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmQGJ0cTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgkrGD/i8jm+ezfthebeBq5NEe2fhRTOQSUEo
J6p8vlFqhXEQi6TP4fF7J+YwDABjyWsB3BuIavKZ4gYzpFYhr/aU8wfa/N1VxA25
XsUALOkexCOua3nBMN3k2M6Kuy3bdzDQpq1SSLQZV/qeC8KWS63vUxU2yf6kLTAn
tTKtX+dMS3UiwiafYX7VH8g7eX+0RnPUgjUnq7pSH6AqJqgmyusUfVt5Iox1KssI
BO/dvy7IJQHZITVrbOdhcLXgXgDbyxuozjhooH+TbfNM8FrD3Z78ag4vClZjiVqY
wzpPMApXSPrZ5uYlRySVxf94CAsvhZGj5jPWPfwV7/A+VVTpdMrqGO/5m+cDbS2q
qGOdebdC68nbZCnQEk1hewMSmTufzv6GnoMKNr62036+WPYFlshf0Ig5aWzm8e7Z
+/U03mXUN+bf5wqhjUqX5mhK7B9MFt85r2A+F45UB2t6wJxIBD6GXxCMd2gvI/95
vwQukHXYMTCOLxcBk8rq0miDM04D81+uXg3Jhr7r+S5cXu34a+jNvl9ENHb61aeD
QA/Ew9HZZ/Y//Ubj5S7It9qpsmb89new/UNDDr2DYYGppoN19b7YSvyibuGH0klC
56Oyvdz8EEkAVIZwXySPp+5l+Tj8oFeqTEMEKm0EGgEUEtwzmmRTTlikureoqkkB
F26RqCvsDG2T
=tkxD
-----END PGP SIGNATURE-----
--=-=-=--
