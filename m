Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2915D461
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgBNJLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:11:39 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:43559 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbgBNJLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 04:11:39 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f123aaca
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 09:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ctm3oNlrDT04NhfoVgAtFza8J1w=; b=HPQWmE
        RfIWZgX1SOQ1kZ0Csr5YXsG0yeRD8Ea5IHbDuqf23gd6VFNI8Nr3GdNLu+/ogDuK
        xIJRH1BboxfRjaa7eUbWE7raw0poJjNClR1wWV7aVB0CpFbOKPN0yTRqn+cHgnnD
        WPD+kYUQdbQPatItqKTHHfre+IPKITZXc61hkHkkISVY+lGQIfBA3kVvT+xq4Y7x
        +s0g2bDbLost6Jp6MoBzjmZaNB7akaE/daeS5xrFYYcUE1OFLr4/E6NaXxrXDj4S
        ttk5Zd2j6kag0tnIS3Mk1plFkAhKRVWPmCmYJAEyjHQIgHWuCCJvH1P9nvaD2x4Z
        UV15vT4mKDU5TY1w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ea614ca2 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 09:09:31 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id l9so8775018oii.5
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 01:11:36 -0800 (PST)
X-Gm-Message-State: APjAAAU1OkQ/JbR4CxacePiGSdo4ChQPMUAyJX0vD7J3o/L/zV+VvUSI
        iRRQs6jO1PyJurKRC44O7lhvegKc28iU9lfvANA=
X-Google-Smtp-Source: APXvYqxb/Gz9M1koGGg1S9zkNnmPyN6mTIW7DwTncPwuPJR2Ygt78gVltctKGNRm3wrgz2vdbkDd4Dp7wPX0+OkbtM4=
X-Received: by 2002:aca:2109:: with SMTP id 9mr1113753oiz.119.1581671495579;
 Fri, 14 Feb 2020 01:11:35 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:dd10:0:0:0:0:0 with HTTP; Fri, 14 Feb 2020 01:11:34
 -0800 (PST)
In-Reply-To: <20200214063814.229451-1-edumazet@google.com>
References: <20200214063814.229451-1-edumazet@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 10:11:34 +0100
X-Gmail-Original-Message-ID: <CAHmME9oMyauDtVaOSfmeVAKmCr_QBoqC1Vmh+aprtO=Z57PGxw@mail.gmail.com>
Message-ID: <CAHmME9oMyauDtVaOSfmeVAKmCr_QBoqC1Vmh+aprtO=Z57PGxw@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: device: provide sane limits for mtu setting
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 2/14/20, Eric Dumazet <edumazet@google.com> wrote:
> If wireguard device mtu is set to zero, a divide by zero
> crash happens in calculate_skb_padding().
>
> This patch provides dev->min_mtu and dev->max_mtu bounds.

Thanks for the patch. However, I solved this slightly differently
yesterday afternoon already:
https://git.zx2c4.com/wireguard-linux/commit/?h=stable&id=06e79ab0d545a20dec1b179fa26841eb0afb1f07
. I've got some additional testing of this to do this afternoon, and
then I'll submit it to the list.

Jason
