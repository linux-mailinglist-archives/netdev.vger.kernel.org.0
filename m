Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D8630FB14
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhBDSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbhBDSO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:14:57 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4494C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:14:16 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id b9so6947940ejy.12
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kr+c2JAhieRh3lTHlPicZCQErqUE2biE3BOKG7V3nDg=;
        b=TajnI1d6xBPGJBjQ8Lh8bXkt/7pDIbOmf/c1pRayeODLG9RHXe5cR7ePB1xlaBZpwc
         Ze2QRm0j60uI6ATmdyjXE6mB5L2gECji0foPaYXZs6f2XIqpooskxBvGh8Iso8NStqY4
         CuAWpA2vpvuafLNPM0qGWMp2ABaxNHPlJ75+JfryDnfnQW9qjyCtsn8yS2sI+bpz+m4T
         3KOB+CJzehfkQnhZrb7UOn0Ov3xZLNBHW364Genmle7N2u39lANL1P/fgiY7/pEzIHit
         wGUYcD24LloMk/ykKap40fd9EN7sLSL/jsk/aPt778FcvYtHgWlNRLf6VbMqscooH5YF
         jd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kr+c2JAhieRh3lTHlPicZCQErqUE2biE3BOKG7V3nDg=;
        b=Exdyuzxtv1opVnIXouYfsgxe+rzn2HT1FvyLxwWRQp1b9qhYwOjCXITT6ofz/8m8tg
         v6pf8kxhMrNGWkyLbQY+CKxwbwSPXGGbUEysdIh56pamPe6B7f44+h4yHPidmACowmZm
         m2Ab7NWSjsa0tryr2G3dhIeEXVm1gUQrJbzeRssfyiJLmQ8I4wNWc0sAqORlzif3u6uf
         0TlLooskZ2Io5SejAHgWt2pATk14ivfsrb0CR8mE+E76CF9bZLbTZg9t62UMvV1DaYDg
         89bASoHTKDh8irBF1fsdIlXx6adcdEi3xjI5Ulmo9VmQr6QOwxLs0N8C3j4jmXILwPNO
         i2yw==
X-Gm-Message-State: AOAM531xfiKN0r3IP4/Y2GtZ1jV/QchmsTwsl8g/u+giicZpnBDLq3TH
        o+LG+vcOaJ+Ae5sO9MMmbMueczorz5JGADaBcqFGTA==
X-Google-Smtp-Source: ABdhPJwYth+XiqPEqqDfcczcj6Zfr7FLuWlYgtMs608flfjmR0cYg37z3k75VwW+nvA/Y1DlKvmEFpujC5jNG/ArJVs=
X-Received: by 2002:a17:906:c00c:: with SMTP id e12mr333978ejz.103.1612462455429;
 Thu, 04 Feb 2021 10:14:15 -0800 (PST)
MIME-Version: 1.0
References: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1612462661-23045-1-git-send-email-loic.poulain@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 4 Feb 2021 19:21:23 +0100
Message-ID: <CAMZdPi_m8F83yWwamj7Os2pctYmDMRKbwKEi7CpQoH5CCSJMLg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/5] Add MBIM over MHI support
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>,
        mpearson@lenovo.com, cchen50@lenovo.com, jwjiang@lenovo.com,
        ivan.zhang@quectel.com, Naveen Kumar <naveen.kumar@quectel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, 4 Feb 2021 at 19:09, Loic Poulain <loic.poulain@linaro.org> wrote:
>
> This patch adds MBIM decoding/encoding support to mhi-net, using
> mhi-net rx and tx_fixup 'proto' callbacks introduced in the series.

This series has been rebased on top of the recently submitted:
    [PATCH net-next v5 1/2] net: mhi-net: Add re-aggregation of
fragmented packets
Since I assumed it would be merged first, but let me know if it's not fine.

Regards,
Loic


>
> v2:
>    - net.c: mhi_net_dev as rx/tx_fixup parameter
>    - mbim: Check nth size/sequence in nth16_verify
>    - mbim: Add netif_dbg message for verbose error
>    - mbim: Add inline comment for MHI MBIM limitation (no DSS)
>    - mbim: Fix copyright issue
>    - mbim: Reword commit message
>
> v3:
>    - net: dedicated commit for mhi.h
>    - net: add rx_length_errors stat change
>    - net: rename rx_fixup to rx
>    - net: proto rx returns void
>    - mbim: remove all unecessary parenthesis
>    - mbim: report errors and rx_length_errors
>    - mbim: rate_limited errors in rx/tx path
>    - mbim: create define for NDP signature mask
>    - mbim: switch-case to if for signature check
>    - mbim: skb_cow_head() to fix headroom if necessary
>
> Loic Poulain (5):
>   net: mhi: Add protocol support
>   net: mhi: Add dedicated folder
>   net: mhi: Create mhi.h
>   net: mhi: Add rx_length_errors stat
>   net: mhi: Add mbim proto
>
>  drivers/net/Makefile         |   2 +-
>  drivers/net/mhi/Makefile     |   3 +
>  drivers/net/mhi/mhi.h        |  40 +++++
>  drivers/net/mhi/net.c        | 408 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/mhi/proto_mbim.c | 294 +++++++++++++++++++++++++++++++
>  drivers/net/mhi_net.c        | 384 ----------------------------------------
>  6 files changed, 746 insertions(+), 385 deletions(-)
>  create mode 100644 drivers/net/mhi/Makefile
>  create mode 100644 drivers/net/mhi/mhi.h
>  create mode 100644 drivers/net/mhi/net.c
>  create mode 100644 drivers/net/mhi/proto_mbim.c
>  delete mode 100644 drivers/net/mhi_net.c
>
> --
> 2.7.4
>
