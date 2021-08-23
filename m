Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4F53F4509
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 08:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhHWGjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 02:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhHWGju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 02:39:50 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31F9C061575;
        Sun, 22 Aug 2021 23:39:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so150524wms.4;
        Sun, 22 Aug 2021 23:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Aqx6TrlbZceHPQbmc0/vVBBjQ3l0UdYj3Xf1scJT9g=;
        b=Zwogo5FVzcC7NwjXJqrHozJwSSJT6SkwkkRaLGmVuXXsEwjPid23+cAr+HYJbZxXcP
         KlcYdH8AGH1bMMdOb/wxt0SeNbbtTil9jwllHagrbP1q5tXaxzVtjnF678nqODGQLOwA
         cUOgqaBt6Dg/NmcIu83IFsY3WfJTr5GxoMGcjrCldAZcGf91eKZXpr4fV1axoGsWnEad
         7FfIp/drEXmvltW6Tb1ci6OyOObW0chzEcKcqJv+Hooz4VLcg9EelG55xiNM3RK+s+YP
         WF/eySEYI4DeTBveMaQze2s8KrvVPV24+fYTgLCHXjw2ofixBDFiFAp0omSl7xW77OqL
         5leg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Aqx6TrlbZceHPQbmc0/vVBBjQ3l0UdYj3Xf1scJT9g=;
        b=SZLbz9gRdsXO1rsbW3ZPBUyx3ZItBVwGQzYFlGRApgltP5hc7cTVxZxj1qfXKowDG9
         ynaNUWnyytbzCidR7m3dYBsGXh+PpyVB8H8T/5FO+T+aFv1549uFXVkVhkd6shlpm86e
         eTutRk7FofOLt9AVrWlx6Ii8LkTPSZLWRb/6oa6lFEKnxAhOtWPJdFvnrmglmXsr3xdz
         YunsCJZjOZpTvtDeWdncpoKAJQismYEVNy3Z3eTYrfPv3/3WOlNx5LNMAt/KWjMLMHQR
         ByUtYYNH7Gn0DGxY+z7rX0y7Eqpa+CLecRUU66bRmPcQCaV5T4on2tjCd671i12mzv2S
         cVEA==
X-Gm-Message-State: AOAM531gcm0IyuK99HmE0IBteZoQq6cHx6DGhb4VKHHcJL0dtwsHXfBR
        2d5nc4coLJhAq4CAdyZZCvg=
X-Google-Smtp-Source: ABdhPJxMDl5C5Iu83116CuHInV6lPElsLuPvoM9TmHB5RgepZKEne1VQji9BlkhaP8jrwX7mJv97Jw==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr14939054wma.94.1629700746294;
        Sun, 22 Aug 2021 23:39:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:ed43:740c:fec5:7f46? (p200300ea8f084500ed43740cfec57f46.dip0.t-ipconnect.de. [2003:ea:8f08:4500:ed43:740c:fec5:7f46])
        by smtp.googlemail.com with ESMTPSA id u16sm13947028wmc.41.2021.08.22.23.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 23:39:05 -0700 (PDT)
Subject: Re: [net-next][bisected da41788] modules fails to build
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12199
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Brian King <brking@linux.vnet.ibm.com>, kuba@kernel.org
References: <16a5465e-2357-3277-e2eb-dc0668e6cb01@linux.vnet.ibm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6c87b191-13c3-c52d-34ad-79e23b5d71a6@gmail.com>
Date:   Mon, 23 Aug 2021 08:38:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <16a5465e-2357-3277-e2eb-dc0668e6cb01@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.08.2021 08:00, Abdul Haleem wrote:
> Greeting's
> 
> Todays net-next branch fails to build on my powerpc box with below error
> 
>   CC [M]  drivers/gpu/drm/virtio/virtgpu_trace_points.o
>   CC [M]  drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.o
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: In function ‘bnx2x_read_fwinfo’:
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12199:13: error: implicit declaration of function ‘pci_vpd_alloc’; did you mean ‘pci_pool_alloc’? [-Werror=implicit-function-declaration]
>   vpd_data = pci_vpd_alloc(bp->pdev, &vpd_len);
>              ^~~~~~~~~~~~~
>              pci_pool_alloc
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12199:11: warning: assignment to ‘u8 *’ {aka ‘unsigned char *’} from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>   vpd_data = pci_vpd_alloc(bp->pdev, &vpd_len);
>            ^
>   CC [M]  drivers/scsi/qla2xxx/qla_nx.o
>   CC [M]  net/netfilter/xt_MASQUERADE.o
>   CC [M]  net/bluetooth/ecdh_helper.o
>   CC [M]  drivers/gpu/drm/amd/amdgpu/uvd_v5_0.o
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:12203:9: error: implicit declaration of function ‘pci_vpd_find_ro_info_keyword’; did you mean ‘pci_vpd_find_info_keyword’? [-Werror=implicit-function-declaration]
>   rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
>          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>          pci_vpd_find_info_keyword
>   CC [M]  net/netfilter/xt_SECMARK.o
>   CC [M]  net/netfilter/xt_TPROXY.o
>   CC [M]  net/mac80211/driver-ops.o
> 
> 
> The recent changes to the code causing build fail is
> 
> commit da417885a99d36036cc7d2778f94b846e6582434
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Sun Aug 22 15:54:23 2021 +0200
> 
>     bnx2x: Search VPD with pci_vpd_find_ro_info_keyword()
>         Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
>     simplify the code.
>         str_id_reg and str_id_cap hold the same string and are used in the same
>     comparison. This doesn't make sense, use one string str_id instead.
>         Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> @Heiner, Could you please have a look, I am attaching the kernel config
> 
This series was supposed to go via the PCI tree because it builds on patches
that are in the PCI tree but not in linux-next and net-next yet.
