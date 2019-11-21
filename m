Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F710507E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUK3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:29:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUK3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9X1E0mPwcgFWQfrAV192xVl6AHfJK9mk2N8XSWyhdc=;
        b=ZvdyQwI2V93Yu8VyL705J5xLpRx3iOBcdD9wDvWrAuRDf0Ixa+R47CxzSYfaaDlnDVO0V5
        1kfRNnnZ+KdXa4TD6CdVq38k4mkt7zRpvVScoZv2IiZnMoLSzwOUSCPmM5sE2Be+B8UIrI
        TcjYovt4k0nJntc/BIhz+Ncum3kOCCo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-pM7R5WUrOQG6VrBTAePhMg-1; Thu, 21 Nov 2019 05:29:20 -0500
Received: by mail-lj1-f198.google.com with SMTP id e12so461293ljk.19
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ucqBuN/GyC2pdnb4QcrvifWl2PtH/4rDjAh47h8mEbo=;
        b=WLkm3MsYEEPii7Ix2oyFuVEVeLMl32BOhpo2QEnzuHIoUWuabevEsI0IUv85lqf7IF
         bAqOa4iouZF++wFU0QGX5DessxkeOyx4zX/xod5yAMgsohplF5jgYs56iOt9ch9aTiO8
         /qkey9ts/p+8gY00zmkXeS3T+I1E+VZQD1YlXPe92MoSdNVCgCnGJsaJvgvnAtuEG3z5
         XabWudpN1pVBL5PgNaVxTiNKcWXrGckuyNQqAW+Sh0A2o9VCVd4z1FCBDzagY3gJq2dI
         zFuxuK7aBEwIDq7F++XMXTaFYEBEYY7PjIZI07MSG+JhbyggY+xgUg3KCbpFOoFty6kz
         GB8g==
X-Gm-Message-State: APjAAAVhquJg4M9WCDdlNWvAwrGB890ZvCosTKK0bk/37fzGUjX50kLR
        Z/fPsGyXulrusk91xAMceG1oZ0xvPXUJfodJIpA88O1D0ifw4pvA6lJuzDUYKec1lJ1+kzXQHWF
        YD39drkSClTmAg186
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr6751317ljp.196.1574332158697;
        Thu, 21 Nov 2019 02:29:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwad1vM01fCMQKOMxvi3SDsPF4W318bJWsoMeOqcAfg1It54CDiNRVixFQOF/1CZYdfjRHvyw==
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr6751297ljp.196.1574332158521;
        Thu, 21 Nov 2019 02:29:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 141sm1013079ljj.37.2019.11.21.02.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 02:29:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE1A11818B9; Thu, 21 Nov 2019 11:29:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <thoiland@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
In-Reply-To: <20191120203538.199367-1-Jason@zx2c4.com>
References: <20191120203538.199367-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Nov 2019 11:29:16 +0100
Message-ID: <877e3t8qv7.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: pM7R5WUrOQG6VrBTAePhMg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> RFC Note:
>   This is a RFC for folks who want to play with this early, because
>   Herbert's cryptodev-2.6 tree hasn't yet made it into net-next. I'll
>   repost this as a v1 (possibly with feedback incorporated) once the
>   various trees are in the right place. This compiles on top of the
>   Frankenzinc patchset from Ard, though it hasn't yet received suitable
>   testing there for me to call it v1 just yet. Preliminary testing with
>   the usual netns.sh test suite on x86 indicates it's at least mostly
>   functional, but I'll be giving things further scrutiny in the days to
>   come.

Hi Jason

Great to see this! Just a few small comments for now:

> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rig=
hts Reserved.
> + */

Could you please get rid of the "All Rights Reserved" (here, and
everywhere else)? All rights are *not* reserved: this is licensed under
the GPL. Besides, that phrase is in general dubious at best:
https://en.wikipedia.org/wiki/All_rights_reserved

> +=09MAX_QUEUED_INCOMING_HANDSHAKES =3D 4096, /* TODO: replace this with D=
QL */
> +=09MAX_STAGED_PACKETS =3D 128,
> +=09MAX_QUEUED_PACKETS =3D 1024 /* TODO: replace this with DQL */

Yes, please (on the TODO) :)

FWIW, since you're using pointer rings I think the way to do this is
probably to just keep the limits in place as a maximum size, and then
use DQL (or CoDel) to throttle enqueue to those pointer rings instead of
just letting them fill.

Happy to work with you on this (as I believe I've already promised), but
we might as well do that after the initial version is merged...

-Toke

