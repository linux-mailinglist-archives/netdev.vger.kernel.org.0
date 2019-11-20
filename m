Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC72F103D08
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfKTOOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:14:46 -0500
Received: from mail-yb1-f181.google.com ([209.85.219.181]:45444 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbfKTOOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 09:14:46 -0500
Received: by mail-yb1-f181.google.com with SMTP id i3so5405431ybe.12
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 06:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2UDmGEazRzqVtYbIxqCFln3SsijfpyFXVxgcc1E0qU=;
        b=D+L7D9D1RSu8VCBXuc5ZgSzBSEZQyB3qHGmvN2f/NYWFHzQjM+He4nX5410BItlAvR
         n5xCLGLS+YOHuphnpo1Mq8MCVh1JF5dRAiMlQ8C7xXSITB6vuVIdion4Y/1MuJ46n1fc
         rhKVFB48YSyNHB3Wkbh8UBeqoTzwZEZgZ8JvkAfc/LXRzmHEbk3BUxCqD9ATBuKcY+G1
         0AAtcnXHMf7YiXDuCMbKUCNhfWFjsebL+L4eGzzhe1kF6/Pcs47h8BBxJDhSsuK1zpXX
         Cxx47Op/tVUo7eMYJ6Ddu9Frws5T+yoKlbmxB5LjPKjTuWbzMtv42nQFNTYWyvHLa4pw
         zVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2UDmGEazRzqVtYbIxqCFln3SsijfpyFXVxgcc1E0qU=;
        b=k97PE1YPi/DBjA/TplSU7Icmc320+RflA93cOwkL5zT6rw7asHwOzHelSDSE6jrt3I
         Uj+OACMaKh+RUbm/Guimrvd3zDHEYO9ms/yLvjwFaDEt/AQ/7YGltSiLBSdAatMsvcxb
         q+Yy1u4kuTz+0qbCwxir2zAueQh3VqX30fI3tBAXzAmNsi4xqS9DBQkDz9cWQaURPcCx
         nqFrhMGaEvkb03r5geonKpncW7xyYtfUAXK0Pr3bmkfIziJuQbGY+zD7x5kjOV/oa6dH
         /u6Ml1fkA87NhJE4pjYqS0TS1UHhRVI3rbPRJ+7l3AZC1Q3f0+BAyNxAYMWfvSHVAjIC
         b/Lw==
X-Gm-Message-State: APjAAAXJB1F8LZwRqVISvRLsL4YDBgfo+VeNutpe7NAJkM++xlZ83pef
        QVcw5x4qubO4JWJ6eBIHaibwXFo4
X-Google-Smtp-Source: APXvYqzeZefuczDJLRNqeeSxiyRrHLgV5jZPtnsyz7eSfJKZw/8+xSlszc30xTTcw4M3PcCXwph0AA==
X-Received: by 2002:a25:cb05:: with SMTP id b5mr2147100ybg.191.1574259284759;
        Wed, 20 Nov 2019 06:14:44 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id v125sm10786634ywd.37.2019.11.20.06.14.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 06:14:42 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id g77so8674741ywb.10
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 06:14:42 -0800 (PST)
X-Received: by 2002:a81:53d5:: with SMTP id h204mr1633399ywb.411.1574259281698;
 Wed, 20 Nov 2019 06:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20191120205009.188c2394@canb.auug.org.au>
In-Reply-To: <20191120205009.188c2394@canb.auug.org.au>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 20 Nov 2019 09:14:04 -0500
X-Gmail-Original-Message-ID: <CA+FuTScVjG_jWH-O-57Q+gTcx0v+Qm5TR4WxsWrQUTEajS_wkQ@mail.gmail.com>
Message-ID: <CA+FuTScVjG_jWH-O-57Q+gTcx0v+Qm5TR4WxsWrQUTEajS_wkQ@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 4:50 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> n commit
>
>   d4ffb02dee2f ("net/tls: enable sk_msg redirect to tls socket egress")
>
> Fixes tag
>
>   Fixes: f3de19af0f5b ("Revert \"net/tls: remove unused function tls_sw_sendpage_locked\"")
>
> has these problem(s):
>
>   - Subject does not match target commit subject
>     Just use
>         git log -1 --format='Fixes: %h ("%s")'
>
> Did you mean:
>
> Fixes: f3de19af0f5b ("net/tls: remove unused function tls_sw_sendpage_locked")

Indeed. I messed up the subject line, sorry. That is what it should
have looked line.
