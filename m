Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D6C4048EE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbhIILJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:09:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:48793 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233990AbhIILJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631185707;
        bh=AAIXTUSD2D+UBvM2ZbhnEuK+blZbIXOcoQG3/MEal9c=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LCfkrbakCGoPJrMf8RHEpkgMV5b+E3D09/Pg2P1MUZSFFEMaSSZgltRyTPpxF6h2F
         e+IOd/dFGn50ftH714QpkR44YqrXyQCiELHsslEDH0rjHlOyyxO4KA9VujhYbG7/cH
         cPZ1fgbrnHXxHMb8AY1ALSQDWy2kVfGrr9tDmGDw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MacOQ-1mvgiv1erS-00c9cG; Thu, 09
 Sep 2021 13:08:27 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
Date:   Thu, 9 Sep 2021 13:08:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909101451.jhfk45gitpxzblap@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/wwtckDhDW6OpxHZAWeZEXMWVj4tAjKBl2xYBkDv++je5LVyan9
 o7dniwUh87k9qsx5pemOMg5DwMjmDYlHCYZFoLidJVHF3PDlHY4C5Fk6heaox7MuqKRmJG6
 64JYZHL7q2FoJ/ZehVGnV50+SfDJMBT43Qwmiwi105qRGzoaanLmnC5AZQp6Sqz9/7zZF2e
 2LYfHwQ4ry8REopuR00Vw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:N6VlbDoFWT8=:5hhJqPmPxuzwCWPyL0fWon
 vddAbhotSJBIPWiXLDF86CUJzkTc+yyQ9MhQFtbpUkEiwR87YAjE59YLfaJnMiA/yc37UsNhh
 aPAILjj8A2FoskO2N0oGSP18hpwrTx/MXWUiEZD/OsWWcC3cyDQbjTIy8CevngSwm9DpnarSK
 fORQ9GKPmXFs180y1r4DSd/LbATypPOVDWl0g3nQCB3QAYyUOV2+Pwk3MHpm/yJpYTJ/+Bgl6
 LPu3XfKBkB4IbIUovTFUpdZ22stvNjSREjHoX8TTN/oQzphmT66F+3MUui2pAO2KPhsRoJegX
 X026HXIz4CZJGYVI4syJoyVfjn4S40afBFCpPUwVe0wJtLcDIHShJKwUrbr8plzmGNWpU73Dq
 BxgE59YtSVcr/McecZCrCwE6DbAU3b5tYIq9jQbGyDCoxV1lyapR7KrhAbGrrXUTxZYFDMBzf
 fcAuXXY7JFE769LpPlu5BBql9uF7ww+wp7Jzd4CeUYgsbwkWX3ckZB5ZUQsL91oCt7t8IGyCk
 fRTiejOJVJQnUQr4+OKrcec6KS5gnqOogscdu9JdbH4eVF7kIiw+9ckr3a1HEzM4d79lIWHDI
 Gev0htMlxFfw8nPVvh6E5E+iOzt59C4P0eK/LCajSltFidcCwW1r1vBH9FpXw3+lkVsfF0pug
 sq4xX2UcEk43XxYBW/zvF+HxQTnG8xmRiZFXFfbPU1lwhBBkLbsdxgFDwHt9z3pH3MAP5w1wt
 xbmw0NjxetIhKIitUYaOphCb+ETTrCBaBfRhB7PaSFUfPx2MgkuqERRzKwdRkO5VjFmgPxLyG
 Rm5adkRxOpvtLwk3dAjEBN+KePb/Tq4IjX/Uq4Kos4NAeq8z5SiJhDxeOEva77Ml+jfmi/AkZ
 7nVsepjwD9a3hlEg6dVWxKWNtvzsJrjCnl5LRS67Wfn1UduOvCKvM1aN2cgHPg0JgValsEhAy
 03R07yCaPgY9dMwK1vDLB74lWIi4wzMe0KuJFo6I5mnIqZlDZQVtFqF2hqybbNSEuXxwr3QFn
 9kavCjKNJuhVoFk4i53rz/akAkkWoMY/vnaWIHUGhhP9Amgayvn5xuhCyiGLommHWr9pf14jW
 mdw7WTp1zTpJcg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On 09.09.21 at 12:14, Vladimir Oltean wrote:
>
> Can you try this patch
>
> commit 07b90056cb15ff9877dca0d8f1b6583d1051f724
> Author: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date:   Tue Jan 12 01:09:43 2021 +0200
>
>     net: dsa: unbind all switches from tree when DSA master unbinds
>
>     Currently the following happens when a DSA master driver unbinds whi=
le
>     there are DSA switches attached to it:
>

This patch is already part of the kernel which shows the described shutdow=
n issues.

Regards,
Lino
