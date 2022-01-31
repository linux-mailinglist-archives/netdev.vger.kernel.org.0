Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75404A5297
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 23:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiAaWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 17:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiAaWsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 17:48:53 -0500
X-Greylist: delayed 485 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Jan 2022 14:48:53 PST
Received: from mail.maslowski.xyz (maslowski.xyz [IPv6:2001:19f0:5:5b98:5400:3ff:fe59:951d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D4C061714;
        Mon, 31 Jan 2022 14:48:53 -0800 (PST)
Received: from [127.0.0.1] (public-gprs393678.centertel.pl [37.47.169.15])
        by mail.maslowski.xyz (Postfix) with ESMTPSA id 5337580D85;
        Mon, 31 Jan 2022 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=maslowski.xyz;
        s=mail; t=1643668846;
        bh=TVxdwUFTFyZUGl5grFYYrubbq4iOCQK2FORp//gZCWQ=;
        h=Date:From:To:CC:Subject:In-Reply-To:From;
        b=ZHN9iu0VBNRr4GAmTWjz1PzN+9N5/KhB2v75W9esIAXrtOE3mLJf9LcSyjbd9W402
         j9TufTpzHeFhr1C5JWNIwuwhGvp7FCiDQ1NJMA4Ojqh2OvIzfpF2ZGhAuX/SuRzgGc
         BuaUrvUABoxKRvIDZrlfl+vDiPdPLixB1j7PK2JCQ0NUV0TU0zCUijnLLsPNNE7cO6
         joiQE+SnKdJwHDxzyo5tZI0+/ggte9qpOL2uWAfps04OBo3hjuBw6nY9OMi4ExKpnl
         0J4d49RUVHTpq0JmYo1m6yzAlqxbSw1rvuurnBo5FTrPESszvzFlX4IxF2lpvlxp/e
         aB0TwWroU9nqA==
Date:   Mon, 31 Jan 2022 23:33:49 +0100
From:   =?UTF-8?Q?Piotr_Mas=C5=82owski?= <piotr@maslowski.xyz>
To:     marcan@marcan.st
CC:     SHA-cyfmac-dev-list@infineon.com, alyssa@rosenzweig.io,
        andy.shevchenko@gmail.com, arend.vanspriel@broadcom.com,
        aspriel@gmail.com, brcm80211-dev-list.pdl@broadcom.com,
        davem@davemloft.net, devicetree@vger.kernel.org, digetx@gmail.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        hdegoede@redhat.com, kettenis@openbsd.org, kuba@kernel.org,
        kvalo@codeaurora.org, lenb@kernel.org, linus.walleij@linaro.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linville@tuxdriver.com,
        netdev@vger.kernel.org, pieter-paul.giesberts@broadcom.com,
        rafael@kernel.org, robh+dt@kernel.org,
        sandals@crustytoothpaste.net, sven@svenpeter.dev,
        wright.feng@infineon.com, zajec5@gmail.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_7/9=5D_brcmfmac=3A_of=3A_Use_devm?= =?US-ASCII?Q?=5Fkstrdup_for_board=5Ftype_=26_check_for_errors?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20220131160713.245637-8-marcan@marcan.st>
Message-ID: <5E81748D-C6A8-4904-9A03-F61512AF22E5@maslowski.xyz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 5:07 PM Hector Martin <marcan@marcan=2Est> wrote:
>
>This was missing a NULL check, and we can collapse the strlen/alloc/copy
>into a devm_kstrdup()=2E

=2E=2E=2E
=20
> 		/* get rid of '/' in the compatible string to be able to find the FW *=
/
> 		len =3D strlen(tmp) + 1;
>-		board_type =3D devm_kzalloc(dev, len, >GFP_KERNEL);
>-		strscpy(board_type, tmp, len);
>+		board_type =3D devm_kstrdup(dev, tmp, GFP_KERNEL);

Also `len` can be dropped, since it is now unused=2E

--
Best regards,
Piotr Mas=C5=82owski
