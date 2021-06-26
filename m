Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C473B4F00
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhFZOdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 10:33:20 -0400
Received: from mout.gmx.net ([212.227.15.15]:53779 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFZOdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 10:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1624717836;
        bh=q1xyXqBOrhwD5gZND37RRmGI/O0LWaj0MVp1LAHNDn4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=RjDUK6/aVKCvYOhjUFv7aMo1lVWjjkl5D/8hsweHavk+Sy7yjn6Uc/vUvsW985/Us
         CCcZmOgChG0cUF3wlyhM5SVDwymVLAWSIlLkX9ZuSskqhmgvo7Ct2tEo79Mui0gtkm
         akX5OsLabmN95G/TL2W8QATq+qHchvt4Y3pjCq0o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ubuntu ([83.52.228.41]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MTAFh-1loedI3rVn-00Ua6O; Sat, 26
 Jun 2021 16:30:36 +0200
Date:   Sat, 26 Jun 2021 16:30:10 +0200
From:   John Wood <john.wood@gmx.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>
Cc:     John Wood <john.wood@gmx.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76/mt7915: Fix unsigned compared against zero
Message-ID: <20210626143010.GA2936@ubuntu>
References: <20210612143505.7637-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612143505.7637-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:tQ2f+TzIa4cFuYvRr3c0vPwUbF+5UbFFSq+mpcgXQdaJ2U//YOI
 QOyCOm+E6AURnA+9aCQ31jRi8UiTJl8lE1yyJjyZhckYBRACLhoKYME+3IQn9CCh+ek0WVH
 NSTlQAUrpM90MAeFRndo8hdW8bXh5pS2UXh0CXaE64VlrKCvoj8a9XhB1MAVT1h70Bl8p1R
 Va3BYV6ljtqROkiyeT9IQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d10Rb6Q5FAg=:kA+y8IL3xQ9/OlFRJewcGQ
 p7/uCmxRHhAaqwnaSZqFKwWckGdZJY51F+MwAiaXdbR/OQ4q+X6Xyoha1JJCgmoLG3AJUqUsU
 o2/Io9kSfF19KQ3XGyWqioK3iA9orJNmrmePk+/c7hPSz42JoW+Z+dQOnh4iR/d3zOeN3SwQE
 inrZjvAFA3jr5g9CbK+JzDbhfw9YrxGhfmeYABPMiIq6aAB453dwF8jh0fUIiaSzUDm3xyxZo
 ExgyBLWekuyPy+gYSV5uRXgk3DckvDVrjvphtev5I/EMn4jOd9T/paCfwbIy2Gais9qYApNGQ
 +TJ8tCLtGznnw7iYoBKjbztv2CLv/6w97/s6p8c2FJX1YeJjc/fx1lcfxuyGuJUjlIS0ARNpJ
 DKR433pFX3bUcgSXi8UA8nUZoPDGxjFEGFts0MSIDgY7lPvq6RGwLRUvxkIRmQajzHz1H9CIv
 HX645b1SxR0FC0Pny3wZN0CWYRfnxjXt6s6PaPJCmnAx3D8GnAQcwm0fGaFsvZiFhs1sYrcV5
 yKoInr3F1Etu7EY2tBYKV6CmD+IdHrG1lTUY1IS6qmiiaG79nuyOVBeL66wAPnTyAzJ5wDgDY
 fXvHY0b0NNQg55CHrtZ9aCOGQASkM7IPJp5Ye/em+RAVgB3wzlHfN30kqlp6N6zxdeNdhqJYB
 Rar9hOYq1cK7VVGs+2p0p0b8NOyIi5PlJT4gxOJeraxHleXzUZZ58Fj0e5LADoXs3F+YG7QIQ
 axxKz89rAgEB+cRQgRpXPJS/Ir+dG2sQZT3O2HxHItfzwehqtAagw95QFd6J/Vt918NQbOQRZ
 PUpB2cs594tUX4mv7Jr9BuYCeKHtw2TOICM/+3t3Qu0lykswrmZTD3ffgtMX1rNd41yTVkdNK
 ldiHZOPLHuEzeriwhxNQqoe8I+CwQVsea3O+PL6j4f4mj1xdIJgkhkkw38Un1ksF8sf0j0t1W
 XgxIuvS/czpvBeiI4BQy3Njbuu9nGvPVxuqLvhFjQsXNWFiErxYCID6Ima5DJuAKQQCmPW2yL
 FIdla+obJH26Iep49T/huw3wJpNwbsdTpb4UUfrOkzj9ES3sxJkeExD+HE8XVIRUAM5jlg3EN
 rM/elr9C8s+mU2nnzgCeZM0oFltmMc1FlIP
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 04:35:05PM +0200, John Wood wrote:
> The mt7915_dpd_freq_idx() function can return a negative value but this
> value is assigned to an unsigned variable named idx. Then, the code
> tests if this variable is less than zero. This can never happen with an
> unsigned type.
>
> So, change the idx type to a signed one.
>
> Addresses-Coverity-ID: 1484753 ("Unsigned compared against 0")
> Fixes: 495184ac91bb8 ("mt76: mt7915: add support for applying pre-calibr=
ation data")

Has anyone had time to review this patch?. Any comment on this?

Thanks,
John Wood
