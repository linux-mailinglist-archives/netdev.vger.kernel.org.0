Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448A7319773
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 01:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhBLA2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 19:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhBLA2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 19:28:33 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F584C061574;
        Thu, 11 Feb 2021 16:27:53 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so7108337wmz.0;
        Thu, 11 Feb 2021 16:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xbSl/xGg58ZBD5pRxnszpjsqBx7cHU2bgXK6gnmXsrA=;
        b=G8FTeWBzXj0b7XZBn+HRWNbtCZZtKeAW4lUMwf00IoihI/3lsZqxALa8VU2p+y8Q30
         hZNsgihi6g8ptNUF4Wu/S25QQlKHYVg1TvVg0THdqYKXPJ7f/vve1tAqr5zKl1EFiGqk
         DbLio2LgAf7C+MhpFYsAb9SNpm46httcpRj/6MSMxEusueG0miawFyr5Gzxng3ozXtxt
         LhqFsLFkLsDO6M70XEfDbah4bePfkKyxYJpO1KfSqKN4jHZT0oug2TXDykvNfcY7OjlV
         OpSHYrE5XjZbdLGk18FU38DLzTUdu3rPoxSFU81gpAbsQtd8U2uiw8t9zAZ3q2xkiemB
         Eh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xbSl/xGg58ZBD5pRxnszpjsqBx7cHU2bgXK6gnmXsrA=;
        b=eEQVCZMnKPa6BsVfgauPDaAHqInjzd5JaOfUyxX/KVRkeqdhf3guR2w0nGOXVhhVIg
         tCS1xWNmfzNOMnTKNHkr4VlLV9Gk5OBC8rH4ngxu8puB0lO4ZGY3niZdS8JdBO3cKC6o
         5sabNFclWhnD794O1rsokfsK7hcFmgMwlTYsMdS8J2DT9ANdusQkXDklyScnqhn4GzUV
         DFTxImhds9qytLG9l80KiAK0ocmLHLYMYybG173xtrgpqho0tnCteo+ETV0YaNxMDafd
         RXl2KX9izd3XV1d6p4M92dosCDtdUK0zpQcsNJQQ5tH05kgOab2b7g8+7IiawE+G2dOs
         1+PQ==
X-Gm-Message-State: AOAM531BdaITIV6Jq5JF9f1viUOY7VUu+6x82Hr/43gLl3awTqlORtY2
        IrHKTbWGMDQc7GyDpOCpC6YUN1RCaMLT8dO5jfo=
X-Google-Smtp-Source: ABdhPJyp42zDkLl4xmy4F0Xkc/tX0had4TJnT8UHnPx+uW+OV4vsERw20E5dQ6ka1eG4MFIsw0KL5OMKwbffK8BYv5Q=
X-Received: by 2002:a1c:4e:: with SMTP id 75mr437690wma.150.1613089671769;
 Thu, 11 Feb 2021 16:27:51 -0800 (PST)
MIME-Version: 1.0
References: <20210211161830.17366-2-TheSven73@gmail.com> <20210212001852.18042-1-sbauer@blackbox.su>
In-Reply-To: <20210212001852.18042-1-sbauer@blackbox.su>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 11 Feb 2021 19:27:40 -0500
Message-ID: <CAGngYiUx78x1nj4Kr0m6sn4-yJnVYcuHGOGVfHgQZ11+8SVo+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Andrew Lunn <andrew@lunn.ch>, Markus.Elfring@web.de,
        Alexey Denisov <rtgbnm@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "maintainer:MICROCHIP LAN743X ETHERNET DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:MICROCHIP LAN743X ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergej, thank you for testing this !

On Thu, Feb 11, 2021 at 7:18 PM Sergej Bauer <sbauer@blackbox.su> wrote:
>
> although whole set of tests might be an overly extensive, but after applying patch v2 [1/5]
> tests are:

I am unfamiliar with the test_ber tool. Does this patch improve things?
