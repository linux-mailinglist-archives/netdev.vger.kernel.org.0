Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4191B162C6B
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgBRRRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:17:30 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35896 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBRRR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:17:29 -0500
Received: by mail-qt1-f195.google.com with SMTP id t13so15055834qto.3
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gf3c27UM5Ss99iOzIT8w47DwlJSXAKjh3PFBJKCwLF8=;
        b=i2cLEZaaF6HR38mH2Pyvl/hTYo9IfVYR14E1PXZBXeRc07Cnhj7S6+qyAPFZ4qjlPM
         OMAiBx1OKmZs+14ZsZJFu0EbZEfnwVCejtDro9AgG9JKUzqA9WDvlyY7gXZaeTqhDsEq
         +fDds6HpRa6S4n3G2ncdujfbfIEL9iYEYKtsVA0O1p1UXNY4YJl8AiZnlZTA2bq0D6I7
         GfUR++1Nt74X7OoSKB8QBytoXtSLHFeMYTLW11giL6zkRFVXpukPdaWwyNETJ8hVrNY8
         nUmGd/KTchLtPdeuvk1PaxUslK0qkJb/LCa4ZxHjRBYmNV4dFj7Xbi6cuI1vX6KQBPGo
         FGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gf3c27UM5Ss99iOzIT8w47DwlJSXAKjh3PFBJKCwLF8=;
        b=oPUh8qWGo5BBIYicJlaAkcu1RT6qvn4BsCtxOqdLFRRIyrQBNW00JMX+cpmyOwhXwr
         zG+R0POa+An4bftPFl63HySPRPgx1bjemWugQ1sVQI4dFCTjRNZKtlYMtEkibkB6h4le
         PKOmsuPxtJdsqpVlCf+RNFARftb1ngl+nonISJtAeLk6vGShO5k3uGc53d0rKnVHU7bc
         eBjD/rmtdxLajqfIQNLEcDe60bLLZYVhZhETA7FnKKgkGsDY5Fr38Ia4yMfiGt7p8k1V
         cax9ogahoQQNBVqAndgwfZqOr3aP8HJ2lFAgw3Qh/86+Pa5Fvg7178hOn9fWxbOuIGpB
         O3fw==
X-Gm-Message-State: APjAAAX4D2u1cxESMHmOKm+X7SAr+98PLznJINpLBw4cvjBDPJ1ws8N2
        wzZDE/TgG4WyCce9eGcGNZRiD2e52+o30OYKxNc=
X-Google-Smtp-Source: APXvYqxU9sPwZYqxv/WedrtF2uq6yqW92T/+kIFyC+xHyFkryKRTaVQEXLJSoU3QEyxJcPGDJl7t/smas0uJ9X9IfKo=
X-Received: by 2002:ac8:538e:: with SMTP id x14mr18382952qtp.301.1582046248750;
 Tue, 18 Feb 2020 09:17:28 -0800 (PST)
MIME-Version: 1.0
References: <0719e2437448261ef83bf5d4e902481cad1a8e46.1581997820.git.lucien.xin@gmail.com>
In-Reply-To: <0719e2437448261ef83bf5d4e902481cad1a8e46.1581997820.git.lucien.xin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 18 Feb 2020 09:16:46 -0800
Message-ID: <CALDO+SYFG63tqPmuyQ9gq7e2gs2uPv6zPZz7so4iYyvTxWVvhQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2] erspan: set erspan_ver to 1 by default
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 7:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Commit 289763626721 ("erspan: add erspan version II support")
> breaks the command:
>
>  # ip link add erspan1 type erspan key 1 seq erspan 123 \
>     local 10.1.0.2 remote 10.1.0.1
>
> as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
> won't be set in gre_parse_opt().
>
>   # ip -d link show erspan1
>     ...
>     erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
>                                               ^^^^^^^^^^^^^^
>
> This patch is to change to set erspan_ver to 1 by default.
>
> v1->v2:
>   - no change.
> v2->v3:
>   - add the same fix for v6.
>
> Fixes: 289763626721 ("erspan: add erspan version II support")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

LGTM. Thanks!
Acked-by: William Tu <u9012063@gmail.com>

> ---
>  ip/link_gre.c  | 2 +-
>  ip/link_gre6.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ip/link_gre.c b/ip/link_gre.c
> index 15beb73..e42f21a 100644
> --- a/ip/link_gre.c
> +++ b/ip/link_gre.c
> @@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
>         __u8 metadata = 0;
>         __u32 fwmark = 0;
>         __u32 erspan_idx = 0;
> -       __u8 erspan_ver = 0;
> +       __u8 erspan_ver = 1;
>         __u8 erspan_dir = 0;
>         __u16 erspan_hwid = 0;
>
> diff --git a/ip/link_gre6.c b/ip/link_gre6.c
> index 9d1741b..94a4ee7 100644
> --- a/ip/link_gre6.c
> +++ b/ip/link_gre6.c
> @@ -106,7 +106,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
>         __u8 metadata = 0;
>         __u32 fwmark = 0;
>         __u32 erspan_idx = 0;
> -       __u8 erspan_ver = 0;
> +       __u8 erspan_ver = 1;
>         __u8 erspan_dir = 0;
>         __u16 erspan_hwid = 0;
>
> --
> 2.1.0
>
