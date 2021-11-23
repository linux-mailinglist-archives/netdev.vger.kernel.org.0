Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC8F45B043
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbhKWXi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:38:29 -0500
Received: from mail-yb1-f173.google.com ([209.85.219.173]:33445 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbhKWXiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 18:38:24 -0500
Received: by mail-yb1-f173.google.com with SMTP id v7so2027930ybq.0;
        Tue, 23 Nov 2021 15:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5HVBVN9+sTrLodgeig4D1EWIc9RQ5SNWBFmWu98vXL0=;
        b=f6kvHWRyM1JdQRC8Kmh9zPO+ZORff5Td+7YonaI/Q7uHsGt8z7iJ6w6S/DTMTPv2bh
         Mc5eidWUAlcvPoZcsH/W0pURMeBgWh9uZ8tO/CRsiP3UZX1QQRhMdlFeXSLpEhiD+FlI
         9Jenj1j00ZMv4CI6Id3dr3129EwDWugT0XU1Sp+g+9kUAZqQ27vZboRYWd/+PZiLtCpM
         iQ80AL+T0MRuvyK8DY/jW5g7DHn7yRypjWKeOM/1GZNDYjUrjl6kiaSD9zNzMfKwpKxz
         a+Iu1fUX2nd5dD8/y4dPbYqRA0mSEajH1eiQKyKuYbd/LuItiPLDVfd4lHjd1RCqPwRF
         h4dQ==
X-Gm-Message-State: AOAM530N9fkHw9Qn+aHZkaELGCY/MICwcYWp+Arg6TeotNYyhkC8cdu+
        bCn3j/CRho2BvkYw09bygcxHdN5xefV3Kch+CSU=
X-Google-Smtp-Source: ABdhPJw/S8b+4DBi3I9No3zeqKoBNlDBHhzozk6T4jzYhC+n6oU4VdXxRo1GxJXjZxWTLDQlmooFebwqfimrYkzrznk=
X-Received: by 2002:a25:d214:: with SMTP id j20mr10478211ybg.536.1637710515640;
 Tue, 23 Nov 2021 15:35:15 -0800 (PST)
MIME-Version: 1.0
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr> <bc682dbe-c74e-cd8a-ab05-78a6b4079ebf@hartkopp.net>
In-Reply-To: <bc682dbe-c74e-cd8a-ab05-78a6b4079ebf@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 24 Nov 2021 08:35:04 +0900
Message-ID: <CAMZ6RqJ_Kj48Zuv=zzPawcQw4qkgxa=u9aHgH8Ggq9MQZosS_Q@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] fix statistics for CAN RTR and Error frames
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 24 Nov. 2021 at 06:10, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 23.11.21 12:53, Vincent Mailhol wrote:
> > There are two common errors which are made when reporting the CAN RX
> > statistics:
> >
> >    1. Incrementing the "normal" RX stats when receiving an Error
> >    frame. Error frames is an abstraction of Socket CAN and does not
> >    exist on the wire.
> >
> >    2. Counting the length of the Remote Transmission Frames (RTR). The
> >    length of an RTR frame is the length of the requested frame not the
> >    actual payload. In reality the payload of an RTR frame is always 0
> >    bytes long.
> >
> > This patch series fix those two issues for all CAN drivers.
> >
> > Vincent Mailhol (2):
> >    can: do not increase rx statistics when receiving CAN error frames
> >    can: do not increase rx_bytes statistics for RTR frames
>
> I would suggest to upstream this change without bringing it to older
> (stable) trees.
>
> It doesn't fix any substantial flaw which needs to be backported IMHO.

I fully agree. Bringing it to the stable trees would be a
considerable effort and was not my intent either (thus the
absence of "Fixes" tags).

> Btw. can you please change 'error frames' to 'error message frames'?
>
> We had a discussion some years ago that the 'error frames' are used as
> term inside the CAN protocol.

ACK. Thanks for the clarification on the vocabulary.

Yours sincerely,
Vincent Mailhol
