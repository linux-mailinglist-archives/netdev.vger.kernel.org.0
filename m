Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF1C439D72
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhJYRZK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Oct 2021 13:25:10 -0400
Received: from mail-yb1-f169.google.com ([209.85.219.169]:37566 "EHLO
        mail-yb1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhJYRZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:25:10 -0400
Received: by mail-yb1-f169.google.com with SMTP id d204so12433300ybb.4;
        Mon, 25 Oct 2021 10:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sSSeHmsaBBlZpqQyuRz9odgeuyaHFZ1YcP2UvLwb0kU=;
        b=ykVbArbUalx8iOt31JnJSOrT4s+J1/l8KWkJuvXeE7sFBcUgMqlGAw42TXgenyknnE
         2mbuqicvWh9kAPj35Ufypr2MMypRpXzpOSvafzob68W/LzOWcB1WsRQ+dHVSE/iBSeLF
         J1LsIh18f7QVtEZnYuomYQL/Z2Edec7ng3vcnlpjDsIO2AgeozehFSVtLutw20FsL+XB
         5CD91nAfCRfNhfsJkc3kWXwLo9+ANWLZIgYB5U5O+JzJxRSYnN3V0PNbmtWrLHQAIEtH
         o/fnnsj4D9Yu9u45bO2JRikLyAIaSG99wvkcTSYFqA8JQlQpeqA+cifAUqmc3PtHdLj6
         x9iA==
X-Gm-Message-State: AOAM532XFjwvsi0I9q1pQgd0SHyX+v/SFkKiMLVUUbTDu8tgn1Yxx9zU
        qBrl4rjrrq5UdQ/1+vH/upSAWVinPparaSsXP2Kk5cA7vnI=
X-Google-Smtp-Source: ABdhPJyAfZpUnzupj2frXcFWueXXJV5ryHvw0+Md4TxROgRA4RUeA8DPWzUsqXiMFraWANAzMWKrGyyLwuKinVT6YSc=
X-Received: by 2002:a25:3412:: with SMTP id b18mr17851186yba.131.1635182567037;
 Mon, 25 Oct 2021 10:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
 <20211009131304.19729-2-mailhol.vincent@wanadoo.fr> <20211024183007.u5pvfnlawhf36lfn@pengutronix.de>
In-Reply-To: <20211024183007.u5pvfnlawhf36lfn@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 26 Oct 2021 02:22:36 +0900
Message-ID: <CAMZ6RqLw+B8ZioOyMFzha67Om3c8eKEK4P53U9xHiVxB4NBhkA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Welcome back on the mailing list, hope you had some nice
holidays! And also thanks a lot for your support over the last
few months on my other series to introduce the TDC netlink
interface :)

Le lun. 25 oct. 2021 à 03:30, Marc Kleine-Budde <mkl@pengutronix.de> a écrit :
>
> On 09.10.2021 22:13:02, Vincent Mailhol wrote:
> > The statically enabled features of a CAN controller can be retrieved
> > using below formula:
> >
> > | u32 ctrlmode_static = priv->ctrlmode & ~priv->ctrlmode_supported;
> >
> > As such, there is no need to store this information. This patch remove
> > the field ctrlmode_static of struct can_priv and provides, in
> > replacement, the inline function can_get_static_ctrlmode() which
> > returns the same value.
> >
> > A condition sine qua non for this to work is that the controller
> > static modes should never be set in can_priv::ctrlmode_supported. This
> > is already the case for existing drivers, however, we added a warning
> > message in can_set_static_ctrlmode() to check that.
>
> Please make the can_set_static_ctrlmode to return an error in case of a
> problem. Adjust the drivers using the function is this patch, too.

I didn't do so initially because this is more a static
configuration issue that should only occur during
development. Nonetheless, what you suggest is really simple.

I will just split the patch in two: one of the setter and one for
the getter and address your comments.


Yours sincerely,
Vincent Mailhol
