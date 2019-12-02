Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A9E10E79D
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfLBJZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:25:07 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:42634
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfLBJZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575278705;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=PsbuLqg3PnKHZC8fFLVJ8BSKlIh+aXX3eRcWBfbOHQk=;
        b=T2szKvc/XxMT/ZvGa0HxlsftgkKoplO4jc3Ije5Bt9DUIFfHYlwZz9/c83wKnCEa
        jCicj+RykvK2G+2ZpUW99QF2bzArEe6fgvqdm0MB/pxwn1a9nEIttxWbNf/egYysv+v
        +FygTZ96NhRjG4VJuzv6s36voeJ6nnOv7ZRCvuXk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575278705;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=PsbuLqg3PnKHZC8fFLVJ8BSKlIh+aXX3eRcWBfbOHQk=;
        b=bBsIqyQtxqaJOzQfgUnPNfVvRfUjTSpzldVz+tYN13bdKRO1GMSEkCdv8X8ZN7Bc
        xUK8KyWiIE0BS/ZUEmH6e3Oxnd2Vv7+2dkVNdoHAWwKCVqy7vbghoZ7ID2a1biurDIZ
        1O3AujZnUI1FLvkmDcZ+9+7G7ud7aNrn5w6rP60E=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F829C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pablo Greco <pgreco@centosproject.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mt76: mt7615: Fix build with older compilers
References: <20191201181716.61892-1-pgreco@centosproject.org>
Date:   Mon, 2 Dec 2019 09:25:05 +0000
In-Reply-To: <20191201181716.61892-1-pgreco@centosproject.org> (Pablo Greco's
        message of "Sun, 1 Dec 2019 15:17:10 -0300")
Message-ID: <0101016ec5ed7c43-209a11a1-70b1-4151-bf9c-a2c5ce9f5348-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.02-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Greco <pgreco@centosproject.org> writes:

> Some compilers (tested with 4.8.5 from CentOS 7) fail properly process
> FIELD_GET inside an inline function, which ends up in a BUILD_BUG_ON.
> Convert inline function to a macro.
>
> Fixes commit bf92e7685100 ("mt76: mt7615: add support for per-chain
> signal strength reporting")
> Reported in https://lkml.org/lkml/2019/9/21/146
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Pablo Greco <pgreco@centosproject.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> index c77adc5d2552..77e395ca2c6a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> @@ -13,10 +13,7 @@
>  #include "../dma.h"
>  #include "mac.h"
>  
> -static inline s8 to_rssi(u32 field, u32 rxv)
> -{
> -	return (FIELD_GET(field, rxv) - 220) / 2;
> -}
> +#define to_rssi(field, rxv)		((FIELD_GET(field, rxv) - 220) / 2)

What about u32_get_bits() instead of FIELD_GET(), would that work? I
guess chances for that is slim, but it's always a shame to convert a
function to a macro so we should try other methods first.

Or even better if we could fix FIELD_GET() to work with older compilers.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
