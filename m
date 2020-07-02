Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1E212537
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgGBNvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:51:23 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39031 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgGBNvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593697882; x=1625233882;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=cc8l3e6t3w7Fnm6NpfUfd3gTNmzkaJ44p8OlfIYexmg=;
  b=0EXNx9PBYsCTM8oiZgbKaV3k2bsX3Uzgpj2ufcwnWU63BheoM+PJfynt
   ykILMWfTu55DJX6BhGIzacnmKO0sJKysry+Llw3/36QAuPj+dR8TMh8N/
   hT6fslt7/b6iuu+q5mdq93Hhwl4bBqCPs+Es+Sr1GkKjcmb9iK3+cXJ7w
   gfX1tY56pU5wKX9rypMitrfP4GDgoVfbopA8HnD1KHRyGX/Ki2s11XSZt
   WSbZtZ3LqHdE1iLDmIF4Og8lUYoX0jJCm6PuBXnnAfS9jP2+KVuojf6aO
   yG+QlGqpqTvTmtXQQYxtsO1flqouCsYrfdbqqAFTp6CT3tGrEYzL8zdYI
   g==;
IronPort-SDR: JUfC97s1Ylnw1pe1BaOL8f1FC7cq2SZbjn2ZHdo3U+gV6NuTFCg82FOlFQPxzdQyN0WzAH+UIr
 XHRosIXoZMiA9mxt52IGV6BaupN674wakQqM2F4EMRkswSdvDVEDg7+iZ4/F7FrqCI9G0OuQLv
 n2YttJYaiYl/3UfMmATZD3YXCSS+NVqHFM4ZE2z1piLsmhyOKSxiBu96HJdkFYjwrqEYbZLYuz
 i+9x06RIWW9hlo8VuwuqAwnFP3DMIsTveRSy/6bWQOZUutKN/wj+83c3UR32sVHOz+hYe1vPaR
 CbE=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="86000751"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 06:51:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 06:51:01 -0700
Received: from [10.171.246.36] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 2 Jul 2020 06:51:19 -0700
Subject: Re: [PATCH net-next v2 0/4] net: macb: few code cleanups
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <5c3b7121-159b-94f6-c362-79a11a8ae062@microchip.com>
Date:   Thu, 2 Jul 2020 15:51:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 at 11:05, Claudiu Beznea wrote:
> Hi,
> 
> Patches in this series cleanup a bit macb code.
> 
> Thank you,
> Claudiu Beznea
> 
> Changes in v2:
> - in patch 2/4 use hweight32() instead of hweight_long()
> 
> Claudiu Beznea (4):
>    net: macb: do not set again bit 0 of queue_mask
>    net: macb: use hweight32() to count set bits in queue_mask
>    net: macb: do not initialize queue variable
>    net: macb: remove is_udp variable
> 
>   drivers/net/ethernet/cadence/macb_main.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)

You can add my:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

For the whole series.

Best regards,
   Nicolas

-- 
Nicolas Ferre
