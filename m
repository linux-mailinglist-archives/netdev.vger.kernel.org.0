Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF62F243D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405485AbhALAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:36 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:33122 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404219AbhALABZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 19:01:25 -0500
Received: by mail-yb1-f181.google.com with SMTP id o144so526977ybc.0;
        Mon, 11 Jan 2021 16:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYFvp4pRAM4I/ettmtAye/8Q4IbY3OpbPnErkgoce1U=;
        b=OAHGanJiW1cArupnEBR8NfBR2WjUwgS3dXjbElol9ZSNHBHL+eBYDVqrFWR22MnERr
         4k4aS7O6nv4zDe5KK/s6jTpxAiS2s7JUGkf8nkaTuG32nMIHCiYz0gA6r5qCeCDPrFw2
         2V0asE6R8OTsCKUepwZeMUldbGEOsEO4QpzFKfLry/JvU/1hNnFotXk++W28UWJzkR1F
         KhE2l4HR64WPTQVMj28TIWyhir/mD9RIoooLFvyWYrF33IrIuwvjl/RvwFcwgdi2UPkQ
         +E9SRppB9DVgD0BF655ylTHsmKtR2fApzKY3Lak5nnx75F0oSZSOeXrNi1tT8tW+ZQwB
         K6DQ==
X-Gm-Message-State: AOAM533mB8I9pPOJLAMux7db2iSO1+w6vVD8VaVp/1AxO+QzDLx++Hc4
        6hrYKcBujH3PIPrvzsIVuxJ7dgt8mN8clMGe08w=
X-Google-Smtp-Source: ABdhPJyZU2BdSQ+kFkk8X57TMyaU2YTJdJxlj5Zf+wUs4Crk+U/tbWoCABMCQIpaDWVbmxIKdlTqvyvx3vtp86RICU4=
X-Received: by 2002:a05:6902:4f4:: with SMTP id w20mr3149495ybs.125.1610409643862;
 Mon, 11 Jan 2021 16:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
 <20210110124903.109773-2-mailhol.vincent@wanadoo.fr> <20210111171152.GB11715@hoboy.vegasvil.org>
In-Reply-To: <20210111171152.GB11715@hoboy.vegasvil.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jan 2021 09:00:33 +0900
Message-ID: <CAMZ6RqJqWOGVb_oAhk+CSZAvsej_xSDR6jqktU_nwLgFpWTb9Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] can: dev: add software tx timestamps
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 12 Jan 2021 at 02:11, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Sun, Jan 10, 2021 at 09:49:03PM +0900, Vincent Mailhol wrote:
> >   * The hardware rx timestamp of a local loopback message is the
> >     hardware tx timestamp. This means that there are no needs to
> >     implement SOF_TIMESTAMPING_TX_HARDWARE for CAN sockets.
>
> I can't agree with that statement.  The local loopback is a special
> "feature" of CAN sockets, and some programs turn it off.  Furthermore,
> requiring user space to handle CAN sockets differently WRT Tx time
> stamps is user-unfriendly.  So I would strongly support adding
> SOF_TIMESTAMPING_TX_HARDWARE to the CAN layer in the future.
>
> (This isn't a criticism of the current patch, though.)

Fair enough. Implementing SOF_TIMESTAMPING_TX_HARDWARE would
result into having the timestamp being duplicated for the
loopback frames but allowing existing programs to work as
with no modifications is a good enough reason.

Out of curiosity, which programs do you use? I guess wireshark
but please let me know if you use any other programs (I just use
to write a small C program to do the stuff).

Mark: do you want me to send a v4 of that patch with above
comment removed or can you directly do the change in your testing
branch?


Yours sincerely,
Vincent
