Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E825FDD0
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfGDUmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:42:45 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33868 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfGDUmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:42:44 -0400
Received: by mail-vs1-f65.google.com with SMTP id m23so2563965vso.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcJ0C5reJPUPRr282vI9k081OUcgrz+/xcYOLqs9gP0=;
        b=VkvlDok6E4OX5H7Q5JvfdGowsbZDdxUCKC6KLupjDhRgWTZMuK5h1gXLVfPFeU8jXO
         T01nirzQnrayUcnFBKfOk1zYC+tIUntJ8ihjX8+YyZadlCcIztlDkpcBQq4BHTKjTt49
         AzQXmEepycbdGCSNnp2E+39UUQ7YnqzZErGXo8i6cLhWbOW0Wx6rcje/SLN5qDaefkKp
         Oyv69SFa/LFlamy8EiXCVitMuCHydzwc1I1ATCcJw7LIP8YwGSYjGP/BirgPqRIBCLwQ
         2kEaRgD/Up6e97bCHLJchdt4SX827hmBJRvjwsf5icokb+NfaRaUxHLiehNL0tlVBird
         b72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcJ0C5reJPUPRr282vI9k081OUcgrz+/xcYOLqs9gP0=;
        b=oJSY8HEuvUvgKUjxu9O5Pr8et+LWX1RivWJ9qGemXNPu2lAwjSkuJWCpp0riTAX71Q
         WFWExlfw2GuNI7ZVYo5vMzIsvEmpKFEyMdLeg7jf+MjSbP9/alwRq4ZEn+Fiyg19pfPD
         Haz67Sxnws6BKIBSJerA4nRivWKJigVnYll/3trpeCJ8ydhi2Qs22WySCVVdDZeu0yUJ
         epKKVOEP9Y0jrrXdbShOWFbA1ryFWHTBVbMTg9g0CcbSsKPEWqIgiQpngvly05GYFM5g
         zw7mVjyYcX0cdxusqpVJlr02i53Xkqkd6yLdj5Pb/tYBMPwvX2TRpQuxF03YO20GpPmc
         XC/w==
X-Gm-Message-State: APjAAAXOs6V4AzkKz/J+eJAh7BPMKMylQ5UAHxBXSL0qrPR6dXGJMkG9
        iWfwXDREIswcJMHR3Xi5zXIF+hz2tEwaAHEumHoT2ZLL
X-Google-Smtp-Source: APXvYqwXd/B81tX4NOC9TTmvSWzTMjjs8ARqpz+wtD2NqFhfTltyEEUu8d8/9kTn14bdE5bkKc7e63shL2zV4htuJKA=
X-Received: by 2002:a67:eb12:: with SMTP id a18mr75466vso.119.1562272963879;
 Thu, 04 Jul 2019 13:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190704153803.12739-1-bigeasy@linutronix.de> <20190704153803.12739-7-bigeasy@linutronix.de>
In-Reply-To: <20190704153803.12739-7-bigeasy@linutronix.de>
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Thu, 4 Jul 2019 13:42:32 -0700
Message-ID: <CAJpBn1x=s8YLD6B3jY4aT_v=uhjA6gYJJ-DGoyeiqno7+by_kw@mail.gmail.com>
Subject: Re: [PATCH 6/7] nfp: Use spinlock_t instead of struct spinlock
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        OSS Drivers <oss-drivers@netronome.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jul 2019 17:38:02 +0200, Sebastian Andrzej Siewior wrote:
> For spinlocks the type spinlock_t should be used instead of "struct
> spinlock".
>
> Use spinlock_t for spinlock's definition.
>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>


> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: oss-drivers@netronome.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
> index df9aff2684ed0..4690363fc5421 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
> @@ -392,7 +392,7 @@ struct nfp_net_r_vector {
>               struct {
>                       struct tasklet_struct tasklet;
>                       struct sk_buff_head queue;
> -                     struct spinlock lock;
> +                     spinlock_t lock;
>               };
>       };
>
