Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA80269A57
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIOAS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgIOASv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:18:51 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456AC06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:18:51 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id cy2so942751qvb.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SS1s2bcIajdOhzJNcG34pKsTgSXmi5SyNe45Z5KeOU=;
        b=D3/Laad26nWG0jVuJqRDskVeoKxWhem3DThdqPc68YY9ZtuXSag6flsVMFn+pq/ZUj
         AETchVxjh/tZTUPFl4mxxCVvdk0rbThkdFxM3mH/XPoMTf9yEmqe1VdWNH2oLjieIiNM
         w7RRpvIJGBz6Zd9gy8P1Cqu1vTwH5r7q4EJdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3SS1s2bcIajdOhzJNcG34pKsTgSXmi5SyNe45Z5KeOU=;
        b=K8W9crc5cjIdQmAoLCO+uvA8nDL0E5sr6xMeRF+R16gEjBgDWncJ92QqSB8SRVNuSu
         laK94+pGjkol8b03d4cLjI0zaeCz84qG6/2Fq+V5ni//QRRlY7OkUPQMfBEAvZIKo7vs
         cdzYq0WlmwcuEQTJm4wc3V+KYV0OuYqoSNzBNORoFudngooS03SxV6rD8AKp/beCejJ/
         6luFsOtyzJWlZ8AgKYdjfJkQxQktcuTfI69kn/0o7tD8n2nLAYwAg0/kk9nmd0y27n/U
         GloMezJdE+JD8SEpuwKIx/vAGpAWH+2ZqgEwMiy13miL1RCkzU65g5ybx/Y9/p0mRsg+
         XRWA==
X-Gm-Message-State: AOAM533N5uENtg52lQsD/YD1Q/4oq5sZOqzP/QibWs1sGAsQBCzDsiCt
        J5V8h3cMuRai7Nyk3kHLzP7F1cXvEAh+DK/nzsZytg==
X-Google-Smtp-Source: ABdhPJzCVTZfTr21R4NObFPIVPYKnbJtf4w/G45xjFZAvEk1ALJXz0J/9CQwkBJrLZpAN/NjVLXrkyfS9I0YvWDyv30=
X-Received: by 2002:a0c:d689:: with SMTP id k9mr15938559qvi.58.1600129130302;
 Mon, 14 Sep 2020 17:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200915001159.346469-1-kuba@kernel.org> <20200915001159.346469-6-kuba@kernel.org>
In-Reply-To: <20200915001159.346469-6-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 14 Sep 2020 17:18:39 -0700
Message-ID: <CACKFLikL_urC8KY4ONZs=UtrQmUmcjS1sKv8HptdNpLT4EskWQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/8] bnxt: add pause frame stats
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, mkubecek@suse.cz,
        saeedm@nvidia.com, tariqt@nvidia.com, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 5:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> These stats are already reported in ethtool -S.
> Michael confirms they are equivalent to standard stats.
>
> v2: - fix sparse warning about endian by using the macro
>     - use u64 for pointer type
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
