Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E04933C154
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCOQMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhCOQM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:12:27 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4214AC06174A;
        Mon, 15 Mar 2021 09:12:27 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v14so9835919ilj.11;
        Mon, 15 Mar 2021 09:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PkrviP+ymj4BXvLRWNPo/Hu6u+TacA+y9E4nXUh7hgw=;
        b=OOthZe9JfMlV1WJY8Bb70Cb4w9V39LpSxgPvGuuwgCxNCkz5OVYLB1vOnSe8KKs/sI
         /FMUcXKuGGb2A7vANO3AK68II6GzbOG2Ohp6clB4H7aOshMuah5PhiFnxbCt+cr9msyv
         UMsjYNQgWAeoKCpadc0nqg5+3SvXh9gBp6HebiI6x98GLmGG9PMcwKwNbQCCuLMfQYcF
         P/V7QIxYs9Jv/1o1jPcik3WgbX+Q2AdHKF1jXyWn0em+TDBVhOXsR8iXmXqqvVt27PTf
         o294tIxkgNF7OBgwztvp/LFEPwHkafH+rjQ8Y0FmynwMQIDAvtBa0CM4KKmrgvpyPalL
         U9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PkrviP+ymj4BXvLRWNPo/Hu6u+TacA+y9E4nXUh7hgw=;
        b=RT9trbLC+0xUnj5INfXcLH6rUC6uio/XPkHPKBxqFerz2yQuMAYd0A4d1djbXyLo74
         BwnaV9e3VTLRsAy8V9uhosSCBA7sc32fCQSOOU2dHQXAPwNxX7pCuLFwV3tWsSGM/BGu
         Z0VxwNvKzTks0uLfT/G14xHpU9vd+XsFbbThHuccg0tA3zwwPXHq1m+eHGCqdWfqRUTP
         L8jkZLttAAI/p7IILYiV7R36SDh3coUWDv0ucCLtXSM5JrytyflndX4z556Gf1YsWH3f
         /q5JwdvygN/jICfg8+myexV0ewLSUmd1J1U+hzGVI7++xYK7uV+9DuZx6jjRCxjNJF/X
         Wifw==
X-Gm-Message-State: AOAM533Oughd0tf5np53cstBVWg9FVgV26MnkxDEiGkht+W0sWVl+okg
        4+jB1l5IGgs0cTfK1M6ryOCL1LOIkMjKYQ8mZPg=
X-Google-Smtp-Source: ABdhPJydPYyWO1j7mP7alrY4A4Z00lPpwICYMrR5CdL38xawNKBu+D0hACmME2mjpBnKKVrKTuRGWVfT5rfErOQbaGI=
X-Received: by 2002:a92:d18c:: with SMTP id z12mr243957ilz.95.1615824746670;
 Mon, 15 Mar 2021 09:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210315133455.1576188-1-elder@linaro.org>
In-Reply-To: <20210315133455.1576188-1-elder@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 15 Mar 2021 09:12:15 -0700
Message-ID: <CAKgT0UdUuDBRO38h4a0V-0MJg7ONwYTr-nzDgPsEKtmihseDEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/6] net: qualcomm: rmnet: stop using C bit-fields
To:     Alex Elder <elder@linaro.org>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        stranche@codeaurora.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, David Laight <David.Laight@aculab.com>,
        Vladimir Oltean <olteanv@gmail.com>, elder@kernel.org,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 6:36 AM Alex Elder <elder@linaro.org> wrote:
>
> The main reason for version 4 of this series is that a bug was
> introduced in version 3, and that is fixed.
>
> But a nice note from Vladimir Oltean got me thinking about the
> necessity of using accessors defined in <linux/bitfield.h>, and I
> concluded there was no need.  So this version simplifies things
> further, using bitwise AND and OR operators (rather than, e.g.,
> u8_get_bits()) to access all values encoded in bit fields.
>
> This version has been tested using IPv4 with checksum offload
> enabled and disabled.  Traffic over the link included ICMP (ping),
> UDP (iperf), and TCP (wget).
>
> Version 3 of this series used BIT() rather than GENMASK() to define
> single-bit masks, and bitwise AND operators to access them.
>
> Version 2 fixed bugs in the way the value written into the header
> was computed in version 1.
>
> The series was first posted here:
>   https://lore.kernel.org/netdev/20210304223431.15045-1-elder@linaro.org/
>
>                                         -Alex
>
> Alex Elder (6):
>   net: qualcomm: rmnet: mark trailer field endianness
>   net: qualcomm: rmnet: simplify some byte order logic
>   net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
>   net: qualcomm: rmnet: use masks instead of C bit-fields
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
>
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 10 +--
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
>  .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 60 ++++++++---------
>  include/linux/if_rmnet.h                      | 65 +++++++++----------
>  5 files changed, 69 insertions(+), 89 deletions(-)
>

Other than the minor nit I pointed out in patch 2 the set looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
