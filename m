Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860FD3E311E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 23:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbhHFV2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 17:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbhHFV2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 17:28:09 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B8EC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 14:27:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h14so12658684wrx.10
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 14:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upxEuPk0EM2abPlip0wa1r/70ppH0cfyjxhfsiKynDk=;
        b=skrsM0ce+W5RbK1C9obIlItMFodN8e1fOLKoY58z1/DvqT4QBsSUSquHdjXKgueaIC
         FqCRdKjGedg20YjvBnXq57y0P5hRfE7ArFFcHiBx+Adj1cKiv2HoKRAfMfBmAokB5VOH
         XN+bKuAUjkKe9yLqqe/GTiOxSyR1WRZ+b3sxeRNlFcJwtUek77wzdu8yqGArkepZjcgU
         Ohq6KtzveMVWIo68aSBaSWufEuamdBNqtYBOzARtoL/mI9dQ5cTK8WrqIW5YU8umCg+w
         fFCYHah7QVW7NSn3rMTMm0Hb3XfgeC92uTt9kTGDYY9mrTPZ3qpK2l61iPonc+7ToJ/d
         JDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upxEuPk0EM2abPlip0wa1r/70ppH0cfyjxhfsiKynDk=;
        b=JpSIEABQHiNNcrVSLZguq2Xc7UkdIAmOLoCv5OKEmCd8hAk9A1AnpLSpOJaJAR6i9n
         6y4Uf+MtYgK8PGcI1d2wfOnYvZl9Unq89fNCGvnuriilVNmcE8YNPyMQpUuEhf48JuMO
         bgFhg3V1acstbonigEVQ/kh+OdnG+RS7nZRxDBGXJ0DD6gQgn0J2wBMobMuiLP4znoxN
         kuch8/usJpsG5lBcXXFnuDgsAyxLUKwC28xJxYqpGSgQBP7oY5gGwQ6VlNri7ar2tT8n
         SxwAHVV56RwopzPlFrN9R9Hx83AORAcZUtIS2DcaFqeQoEY4tIMgkbteIuz5S7lHYQK6
         gdEQ==
X-Gm-Message-State: AOAM533tkTbjD5Z7PDzpyB7a8QKJ3UDy59A0wCQ0uYQyrxDO+FKbru8U
        PESeGj1cQL2y9MNnADjgG2Y=
X-Google-Smtp-Source: ABdhPJy23twxoc5NmLamMkfXIlOtVM1rWQClNVynq1YcGg6DV97VbGQBSZuVjL6tkjukkghWq15GVQ==
X-Received: by 2002:a5d:49c1:: with SMTP id t1mr12912990wrs.141.1628285271920;
        Fri, 06 Aug 2021 14:27:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:cc6d:4891:c067:bf7b? (p200300ea8f10c200cc6d4891c067bf7b.dip0.t-ipconnect.de. [2003:ea:8f10:c200:cc6d:4891:c067:bf7b])
        by smtp.googlemail.com with ESMTPSA id y24sm8976595wmo.12.2021.08.06.14.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 14:27:51 -0700 (PDT)
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com, koba.ko@canonical.com
References: <20210806091556.1297186-374-nic_swsd@realtek.com>
 <20210806091556.1297186-376-nic_swsd@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/2] r8169: change the L0/L1 entrance latencies
 for RTL8106e
Message-ID: <3cfd64a9-dff2-6e60-1524-ddbd1c388c01@gmail.com>
Date:   Fri, 6 Aug 2021 23:27:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806091556.1297186-376-nic_swsd@realtek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.08.2021 11:15, Hayes Wang wrote:
> The original L0 and L1 entrance latencies of RTL8106e are 4us. And
> they cause the delay of link-up interrupt when enabling ASPM. Change
> the L0 entrance latency to 7us and L1 entrance latency to 32us. Then,
> they could avoid the issue.
> 
> Tested-by: Koba Ko <koba.ko@canonical.com>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index d2647036b1e7..2c643ec36bdf 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3502,6 +3502,9 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
>  	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
>  	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
>  
> +	/* The default value is 0x13. Change it to 0x2f */
> +	rtl_csi_access_enable(tp, 0x2f);

Most chip versions use rtl_set_def_aspm_entry_latency() that sets
the value to 0x27. Does this value also work for RTL8106e?
Then we could simply use the same call here.

Can you explain how the L0 and L1 times in us map to the
register value? Then we could add a function that doesn't work
with a magic value but takes the L0 and L1 times in us as
parameter.

> +
>  	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
>  
>  	/* disable EEE */
> 

