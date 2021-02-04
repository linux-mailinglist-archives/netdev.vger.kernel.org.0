Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB230F3F4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhBDNgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhBDNgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:36:09 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D1C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 05:35:26 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id t15so944756ual.6
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 05:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CtWa9V5mHEO82DWc3u9rkkUP5GTxWVzLicj/3IRXKak=;
        b=EHF4M3N3rGeKJlKQ4Bsj+zpTC/mzOQU7X3PSe1KcHuXX2npPL4iYTmcjZun9GqWJnO
         sQ+mqwBg0iRURNogWVa5fydMKNa6z/GkrZ8dFE/CENt5q88b2tNBrHvy6e4njNzTghOx
         0khpLLRq5w5AwZ3GEBbTd1cBHei2Oz/ibYyuA61WY2tyAUSikyEV81+Fr3yXoV/gJgjy
         sPxH4DeuuBTkiAAmR+dIO2m2FsUUTiJzE0nQE19OTvNdGYPG/CY6uXt5UwDSfSugHfsE
         SivRPsDb3IiPIEA0LUHRgG4U1WucmzUyreKVcwy5XwyCsdxe3idfB6BYVmf6nr57vRuN
         W5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CtWa9V5mHEO82DWc3u9rkkUP5GTxWVzLicj/3IRXKak=;
        b=HnRGAOuKWuoGhr3gy68fTeUZnXbWoxALKNY2sr3FJ34Yx/92dUM8NvX3hel5MhR7M2
         UhyUUIaoBQ4tFDMF22ws1cI0IHXqBqWR3ZggGPIx1iywzxBCywb/8hCIt1aR29LaX/rP
         0JOR/yi7JMsFTZ+h6LbVaklKnIceJ89+IYkluVCJ3YUU2oTS6wcZ0Tj2RJGqN/XPZuzV
         9Z9pdj8kvqc2qz2SXitx/rsB/EWyd8zaQlNyHGbc+CZgZgw1cEl6TrseJ5fmxO9E3Aws
         PCOtzrBWcVmoMq9t1nIejK9tbJrRGPnDyIUM5kF0cOSZA44SofhJ0ZCsj1i2T7WQYfcQ
         QPRA==
X-Gm-Message-State: AOAM532QXSLQnbc179ZXm2HRuhveo3nkE7OWe1HuwcqcbEAwJaSuYFHF
        BI0FPchKAHsTXasCfdvXXXZCKA+kdjM=
X-Google-Smtp-Source: ABdhPJyP0qctsXf5WUyQ4dPdyE2PCuOk4DczjSjFrWGMF6S5nrxn2M8YTGT7Zrb7WluZHUhARn9zag==
X-Received: by 2002:ab0:6e91:: with SMTP id b17mr5653365uav.50.1612445725397;
        Thu, 04 Feb 2021 05:35:25 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id u18sm678529vkb.26.2021.02.04.05.35.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 05:35:24 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id d3so946130uap.4
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 05:35:24 -0800 (PST)
X-Received: by 2002:ab0:5fd0:: with SMTP id g16mr4755275uaj.92.1612445723737;
 Thu, 04 Feb 2021 05:35:23 -0800 (PST)
MIME-Version: 1.0
References: <1612385537-9076-1-git-send-email-vfedorenko@novek.ru>
In-Reply-To: <1612385537-9076-1-git-send-email-vfedorenko@novek.ru>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 4 Feb 2021 08:34:46 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf4mrJG48od153gec9-xtpAPwx_-OTkD=cMRCJMXnupjg@mail.gmail.com>
Message-ID: <CA+FuTSf4mrJG48od153gec9-xtpAPwx_-OTkD=cMRCJMXnupjg@mail.gmail.com>
Subject: Re: [net] selftests: txtimestamp: fix compilation issue
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 4:11 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> PACKET_TX_TIMESTAMP is defined in if_packet.h but it is not included in
> test. But we cannot include it because we have definitions of struct and
> including leads to redefinition error. So define PACKET_TX_TIMESTAMP too.

The conflicts are with <netpacket/packet.h>. I think it will build if
you remove that.

> Fixes: 5ef5c90e3cb3 (selftests: move timestamping selftests to net folder=
)

This commit only moved the file. The file was moved twice. Even though
it cannot really be applied easily before the move, this goes back to
commit 8fe2f761cae9 ("net-timestamp: expand documentation").

> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>

Do you also get the compiler warning about ambiguous control flow?

  tools/testing/selftests/net/txtimestamp.c:498:6: warning: suggest
explicit braces to avoid ambiguous =E2=80=98else=E2=80=99 [-Wdangling-else]

When touching this file, might be good to also fix that up:

-               if (cfg_use_pf_packet || cfg_ipproto =3D=3D IPPROTO_RAW)
+               if (cfg_use_pf_packet || cfg_ipproto =3D=3D IPPROTO_RAW) {
                        if (family =3D=3D PF_INET)
                                total_len +=3D sizeof(struct iphdr);
                        else
                                total_len +=3D sizeof(struct ipv6hdr);
+               }
