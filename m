Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF91CD3AD
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgEKIUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:20:45 -0400
Received: from mout.web.de ([212.227.15.4]:47581 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728556AbgEKIUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 04:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589185230;
        bh=3y2G1yVpBuGXndYc8M5o8p9u3GOYWTFXQ4LaWMQUhsA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=q3ORAHPGCU+CY6EErWtcqvFn6Hz8QaiZChqrH9YHZR61M76ZLcjpmpQlQbN8cQ2gC
         yofPpIEe9Brum8uDa7jEsEExElY5KSt78p32gMnBJ9Qd+99o3XDLvEe1vVb1f4sARl
         +IOGMxiBR+uZmrAWPr1GU8fg9v3ikHpS/zUX0MRI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.185.130]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MC0PR-1jNunj1s1V-00CTbF; Mon, 11
 May 2020 10:20:30 +0200
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
To:     Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
 <9d279f21-6172-5318-4e29-061277e82157@web.de>
 <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
 <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <00a5237c-13b4-07b5-99ee-8f63d4276fb4@web.de>
Date:   Mon, 11 May 2020 10:20:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FcCYv6jfu0c0+k+4KEQ+qlVkkWGxC0hIDrjL1SvyRQhMaw3FHZo
 nVGi1rqsJuPlWoirMErPCn75VV1ZSdyGsCKJ6V9lm3s4xRpBMTiIdXfhr4FDR5laMt3eZeq
 4gPeC6MXBhQgmA98jsgWXkTDC6asKiXEaqzLD6krs/1/9A9kT/7D6BMMcrD+vLjB6x74OxS
 ULSvBvfRYj4E0ww3tKtHw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dGLVDhFnwyw=:kEv6jVJS7ZcOONvXu2SzN4
 Thsgdpw3hyFvJIcCxhavm4cXKOZ21CCOSUdi4w9HrKeifB7aI4GsngZAwKU2oJcZ6unqhrBe2
 uLaIA+mymtiknM+ILy25dV8pqrs/eHjPdmZ/gEMRXGHkxn7KxcafesjEagj+lkDZCI9LftmUA
 xg1Gy/wyuOP0Xkduy2U1br0aTlePDlrqJczxyTQTsOLWMJ7aFP16Dc9zNYij0rewjV7CkPox9
 AxxOJjZUBX9Ad6nqzO4xJQl4GjlDq2bmUYbZtxiL3fNnOUDB6kXURQt4DR6cMLhrQZFGSqOPI
 7gjfit/pyeYqXIptmJlCf9vYU2TVcworYC+WhfpDD1Go0iolSTnEsuC6HysGvdYmNtOa5cVKy
 M7fycQcewO1yDl8/l+G5FGxTt+OO09PZdvOBRFl5b4FjfP1qOcRkczSVAndGFCfCxLT+MrrBG
 1Dci/QHBhgmNiBnhdrnNuuAAdH0tB8c1X1/Pf+Zmj7oHD3biYt/Do02EqHgUO4L1seQ6X21gg
 p8jE2PC7Gg1n9sao9di5RzSJXv29WoNlDASWNU+/Wx5ByFAP73iZzOmy/IuxW083Bxq5o5r4u
 3aogwfYLgFwwtCVJpa2OeqhP0AKWkuhvGYFybu6ukMtV2DohR/+kATqR23iqUEzNs1MJfeAUD
 +RkfAU4RlCryG9L+Vzz3r6670t9jT2kpJ6br1/TBvGbduGKLVNJNtANwBUFeXl79rdeZHHNz0
 2W/KhdC5VNwQAi5RXthG4huKUroFgRuNtQhU/5PFaVsgKVZ45U6YMR6txuj7tASMzbQOTH3vM
 v+C/Co4ZD0VrZs36Ni2BBXT86hHLQRBY89/uQRjsnQh50WQ/DL+YjmFrjabJvtRkUR4Vc47l7
 tXWlB9czvFz230O7/Qv08VxswhwAGp3VP0N2NU4bLFA/LEhWrXHhQ3/7p873X+DMY7fzIlwMk
 jXHbSVPAVMnPbi7BQojd1NkolIOON0Jw1j/lS/9mFzrCzwey8esal1jlG/IwTv+OavsGJB1lb
 G/KaQbqgTrmtCGcr7ZoblmvLgV9TNY6RFDS+B7+BUDRkFcKEFV4afZUmiU4Jr/KK2VA7bKqGg
 e7A/K9HQbE0pgw/+EFqHpyVivvt7q8kYoUhh6cLAZ1BX3ZqMcYTRMFKD3Dl97NIVuC8/AL9e8
 eKIcm2wYBz+BtN1RaT7GsKc1PZ9vzdYnq4x9oisGRMYbJmW3wD/On/EhvJMVgbhKXQv/CBNJs
 Wy2wNJGTLDFBeeXLY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> To which commit would you like to refer to for the proposed adjustment
>> of the function =E2=80=9Cmac_sonic_platform_probe=E2=80=9D?
>
> That was my question to you. We seem to be talking past each other.

I have needed a moment to notice your patch as another constructive respon=
se
for this code review.

[PATCH v2] net/sonic: Fix some resource leaks in error handling paths
https://lore.kernel.org/r/3eaa58c16dcf313ff7cb873dcff21659b0ea037d.1589158=
098.git.fthain@telegraphics.com.au/

Regards,
Markus
