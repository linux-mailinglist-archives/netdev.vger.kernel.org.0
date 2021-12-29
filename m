Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD0A481676
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhL2Txt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhL2Txs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:53:48 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91348C06173E
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 11:53:48 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id o63so39093440uao.5
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 11:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1QQXB5NMfTnekeDLJGGA6zJ11Nn8nyuGQX8tb9YWGw=;
        b=YtDaC6Shnz7T/74O0ipqKBpmYPowLS9vCnSjiWvoHYN/1RFLCCZFzUkT26TXW19bA3
         1gjIfzUceXFgVCQAQTnFs263Fq0RxEctD5VI6Yco62HSq/RHhtAzDsCJxP06hBesLNZV
         em4s08aQY4gNeQ7zzBaV5NtjUEyhRdnWySLtZXnZoqd1ZZvfJ7RTSjt3kHPWd0+MZbBI
         VFjc1z/Acxcpv9ZbH7ICejTvJQlzCw92EiHFtlmk2apoop6hwYG9oRHEFYOewflalVVJ
         5A9heDO+dj/H7irHedJ++5G4CyDI5rUc0TbjaBWy6kfsN8bfrtZfHQkae8YZ1ekJ9EPm
         9uOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z1QQXB5NMfTnekeDLJGGA6zJ11Nn8nyuGQX8tb9YWGw=;
        b=meOLOoLu8YcxDYdPKkL0DENVr//JE+Dp3Pvar57CwL9TjzX8RwUSXOtpDjEoezpS5K
         ZqYdTzBOO2P4nWUI2ogp3LgtmCAWNj/ddMCj6gMdzzBL8Gd92DCtQAuFrnq+HOhNzlR+
         0kYsZO64KSwzXRfbDQXrmad/Nq5R35hFIpGAqxunKkzgdmCKOKvv9UZ6qASC7Qbtt7Um
         X2hSmhr4e/nRqiq1lTKazD/OORqtxFDn499vvqSs4yiE2Vh15+ptmZq1iZqXtaW0LSFV
         R8aYMXf0xn1YfKtVx2VBtqFsaW+RaaI1RHHhjNO3Q8ecX+5AAyKNycdgj/fIZSJ0+WZW
         5LEw==
X-Gm-Message-State: AOAM530hxqFI89Q7w4uXT6PoL6iqeBnqLFuayHnkVFdjN10/x7MwjDQX
        yPZxfPjMFOexLG/H25WqhMVivmcl4tY=
X-Google-Smtp-Source: ABdhPJwPBvZjZotjYuC5iQV0BfkBWRho/FrjpXm7VUY+AjdBJdPj+6oVjdby2flYFF2kYZYIb3+tMg==
X-Received: by 2002:a05:6102:c4:: with SMTP id u4mr4267842vsp.71.1640807627770;
        Wed, 29 Dec 2021 11:53:47 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id v4sm4345590vkf.15.2021.12.29.11.53.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Dec 2021 11:53:47 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id u6so31709046uaq.0
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 11:53:47 -0800 (PST)
X-Received: by 2002:a05:6102:31b3:: with SMTP id d19mr8227138vsh.79.1640807626985;
 Wed, 29 Dec 2021 11:53:46 -0800 (PST)
MIME-Version: 1.0
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
 <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
 <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com> <CAJ-ks9=3o+rVJd5ztYbkgpcYiWjV+3qajCgOmM7AfjhoZvuOHw@mail.gmail.com>
In-Reply-To: <CAJ-ks9=3o+rVJd5ztYbkgpcYiWjV+3qajCgOmM7AfjhoZvuOHw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 29 Dec 2021 14:53:10 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe0yPhca+2ZdyJD4FZumLPd85sChGhZPpXhu=ADuwtYrQ@mail.gmail.com>
Message-ID: <CA+FuTSe0yPhca+2ZdyJD4FZumLPd85sChGhZPpXhu=ADuwtYrQ@mail.gmail.com>
Subject: Re: [PATCH] net: check passed optlen before reading
To:     Tamir Duberstein <tamird@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 2:50 PM Tamir Duberstein <tamird@gmail.com> wrote:
>
> I'm having some trouble sending this using git send-email because of
> the firewall I'm behind.
>
> Please pull from
>   git://github.com/tamird/linux raw-check-optlen
> to get these changes:
>   280c5742aab2 ipv6: raw: check passed optlen before reading
>
> If this is not acceptable, I'll send the patch again when I'm outside
> the firewall. Apologies.

I can send it on your behalf, Tamir.
