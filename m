Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39A1AFE75
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgDSVye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSVye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:54:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93016C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:54:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j1so4362962wrt.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9WEhQJ09dNJ8szTyoqkNwAUOvXIi8GaAFDYNKEsSM3A=;
        b=r3LpBhaAvkUuahNtnCyxKIlYQ2utKOf7lXkXDQQxZ7m5LGglXE3jHo29vXPOyxIBgh
         PV/Tq4XBOX3vxWb6yNQ8CetdbjKq3ZM/+uOtfB+cSkaEC7hNLLzAKstzGKbD/NFCwx04
         H64cwP2Ne9DCF0GCftzefXyGpZv9JYY9dJ2l7LzH7GJuAok4TSheUfjpnoM1rPILePp9
         PODaCZmGxx+IeFVvkuX/vKPVZ1j0ndQXoV2RDB4nMLlu4r5ay5BY4Hx291FWHX6lzpHW
         MKAlno3vKCZnONSKQpNTdHACnSin/BVTpLDGzPOaJByTz6P+V9cHxt/XBKP2b4nHilFn
         2T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9WEhQJ09dNJ8szTyoqkNwAUOvXIi8GaAFDYNKEsSM3A=;
        b=IzhVbSabQgBpvPBVBggiq4xI2bD6HAdZT2zxFa59Wr95C83pZVP6aIkmX1sKBeNbnR
         VWVC0qNHJUUDuLs+cuwq++1JzwuZv3Qg94xCbL3F2zPLuIGIXSSDTQqmV93tVTRBzoOz
         6BpY8nuW4/u9wtDQDyAeKHMNj/y/ERckPVUgir+oKFaRNEtbWVz37mxpliZ2V+VRAris
         jnIH2OVOglN1oNmYMpg4hIq4VX6tptpgMUSti68fcWx4VG5JjuWwfLDTL+ts0I/qbN7G
         7uDBpWQmRuWcN16mYWBYowhr7a81VIkBmUGEzLeQItOOB8GjrXTpgMifFGrnxsjCm/Y4
         aojQ==
X-Gm-Message-State: AGi0PubxfO/sH2JXUzuIjRXFZLpQy4AYF79aGIGvPyksviIA0tm5W8R7
        QrVALlGyDp6taA18SQQu4A7MZxah
X-Google-Smtp-Source: APiQypLfQnFnfa34ztaAH2WORaXafyebrnGu5UnRiIU8PxHoiJBp+ufIwoCQ08Ip21OMZ2vRsELQvQ==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr13275510wrc.20.1587333271001;
        Sun, 19 Apr 2020 14:54:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id x18sm16690541wmi.29.2020.04.19.14.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 14:54:30 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] r8169: improve memory barriers
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Message-ID: <82bd0c81-143b-f399-86f4-663b6ef6901a@gmail.com>
Date:   Sun, 19 Apr 2020 23:54:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 20:13, Heiner Kallweit wrote:
> This series includes improvements for (too heavy) memory barriers.
> Tested on x86-64 with RTL8168g chip version.
> 
A recent conversation convinced me that few of these change are
not safe on platforms with weakly-ordered memory.
Therefore please disregard the series.

> v2:
> - drop patch 2 from the series
> 
> Heiner Kallweit (3):
>   r8169: use smp_store_mb in rtl_tx
>   r8169: replace dma_rmb with READ_ONCE in rtl_rx
>   r8169: use WRITE_ONCE instead of dma_wmb in rtl8169_mark_to_asic
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 24 ++++++++---------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 

