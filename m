Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B133C2B0ACA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgKLQzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgKLQzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 11:55:47 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75423C0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:55:47 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id n12so6767307ioc.2
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 08:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ETpWFBd82lx8Kdft4QwKqVKvGr2uK2uAQvv2db2HDz0=;
        b=PCzdlWx9Cp/V9lnWUueHF2VcaCBxb4Ct7aclc20F9rWV1nUkGfprcITXoX35X4qdcd
         U0eh4fzg975MiiUzGan5DjCKHuvngjy48ZN216PpQ4gfBAIBq/0xOuMzlsJVo7G6HjYK
         XKpYlX+gU92JQa0HvUNdrw2IF1As1Muz/AI2pHdl6+Ka9xArHVhhDZ5f4fPVv21ReXNx
         wHd4sNwSdmjIZBPpsNpBviNyZo6m/ZkuGI3inzIpwthAAxQnho12v+ODja3B8NaYgike
         r6/GlEwEvx22TRqBqyEXmIb2N63CY9RQaOhnN16pc2NvDlfBD/8uqYfHIelkkC7lGB1G
         MgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ETpWFBd82lx8Kdft4QwKqVKvGr2uK2uAQvv2db2HDz0=;
        b=EGnRokEqVjQjuTja0OIWnDxaiI6iJ9dBROeF+1944g3XLSgRubo6VkQwmpsKyFgFAK
         o4yvYQwK4c6ZQwULGxdz2HO2034dIvyMpIBG2ZVrItc03lr5Q8wGYuX2Dnzd44o0hXDd
         ueSm9wBA3clJAMuw/nmhGwKUHLV9mo16YGaTVa0IC8gHEtL25Ro5nDRZm2XJMhyqBKYV
         XN2DOYBWq2d7cnjRfbMRQKlpnukzV/fk8Ifxctea7HhcJJltnaOsihE9NzdOmpFvN2z/
         EndfoOB2jIytQYL00i5Y2KyDeVqOhA1dwex8OumD3sTsuwsD5KaHrUjL0Lh8Xi1DFLbF
         lNoQ==
X-Gm-Message-State: AOAM531htackgZDJZk3MThu81l+RzLhNDR/b0K4YmT+4/pq48LntzyUL
        TzPrhqGR8bnGacAhkRwIq7C9TzoxG/m9iyNQUs0KyQ==
X-Google-Smtp-Source: ABdhPJyBEEXMy1YHyTULn3cw+/7ICqSCwPnUns2lDfzQCwq43S928+OMpwpdYpLsJ0+ylUM9bhI+10m9Fpy7H/Wm/rc=
X-Received: by 2002:a6b:8e82:: with SMTP id q124mr611iod.164.1605200146254;
 Thu, 12 Nov 2020 08:55:46 -0800 (PST)
MIME-Version: 1.0
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
In-Reply-To: <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Fri, 13 Nov 2020 01:55:08 +0900
Message-ID: <CAPA1RqDgKfcDqSOM+1TV=EesU1rynt6Z=EqbTur1Q6Xt=YvxpQ@mail.gmail.com>
Subject: Re: [PATCH net-next V3] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     kuba <kuba@kernel.org>, kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2020=E5=B9=B411=E6=9C=8813=E6=97=A5(=E9=87=91) 0:46 Dmytro Shytyi <dmytro@s=
hytyi.net>:
>
> Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (randomly
> generated hostID or stable privacy + privacy extensions).
> The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
> carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
> SLAAC is required so that downstream interfaces can be further subnetted.
> Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
> assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to
> Load-Balancer and /72 to wired connected devices.
> IETF document that defines problem statement:
> draft-mishra-v6ops-variable-slaac-problem-stmt
> IETF document that specifies variable slaac:
> draft-mishra-6man-variable-slaac
>
> Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
> Reported-by: kernel test robot <lkp@intel.com>
> ---

> -       write_lock_bh(&idev->lock);
> +       int ret;
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
> +       __int128 host_id;
> +       __int128 net_prfx;
:

No, this does not help anything.
Please do not rely on __int128.

--yoshfuji
