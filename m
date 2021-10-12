Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A5A42A0F1
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 11:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhJLJ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 05:26:58 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:33411 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbhJLJ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 05:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634030696; x=1665566696;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=bs0INR+2JmXVTJ0eYNOx0JcEiYZsgHULLhhgulKJJuk=;
  b=az9AqVnGPRu+yLNechF2XW9RIGya0WG3uSUBrQiQHIAjVIomNjom+/sG
   qXG6Fj3fdfxf/2F/vxNWU1ArnJ3DUNmt/mFukHN+GXS4DbdtourX8uZSb
   u+WyuztCYF+LiiVGwl77Z2VP9QtdvORfAENAuQhs+YhN1Z8Og4gH7JrgR
   QocM/lMQZQzKrBpzoXwI94QRxIB7gQwmg7+zyKrAiZMVvEHwlj9YIvHgk
   3UIl1bxF/1WcVoU5jU88PUNA2du747q0z134vxtndrqrDLDZgrcb8G+si
   hPGmCGiUivMN26J8gDHdRbvN6uAG5hIsHtmsVD7xRp0KsWFzBn7CXBZsY
   A==;
IronPort-SDR: e1Isv2EWPKycAYKggO5asr82+fS1ujSR1JJfo+UrvPlPggxHzbkfXIJELqDj6d0vTnNEw89Hfm
 2RDoR1LJch0jeiAIXNK5bQvCNe/JTN5BLF7DwSNnTDW7fVfoZ9IGVHyjB123WeRHCcUyOxcYu2
 eO6sbmEi1l0YzokQUNjt33CtjnugQoG6fWgxPZ/S4hFBIwAdM5Y0ONZwSHoG0m9RKAlWMuh4Rf
 yKqGTy+kV9yzBwpds2KkmOiA/WWi/F00pnVtcFVin06PryHSpZrsNkahaYzIxS7M3IsHjEt6iv
 8CFCCUjE3cbCQUzaimNLPHjl
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="132686877"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2021 02:24:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 12 Oct 2021 02:24:55 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 12 Oct 2021 02:24:53 -0700
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <af60dfb1-9e7d-e9ce-3ee9-ce3ef8efae9c@microchip.com>
Date:   Tue, 12 Oct 2021 11:24:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <163402758460.4280.9175185858026827934@kwain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2021 at 10:33, Antoine Tenart wrote:
> Hello Sean,
> 
> Quoting Sean Anderson (2021-10-11 18:55:16)
>> As the number of interfaces grows, the number of if statements grows
>> ever more unweildy. Clean everything up a bit by using a switch
>> statement. No functional change intended.
> 
> I'm not 100% convinced this makes macb_validate more readable: there are
> lots of conditions, and jumps, in the switch.

I agree with Antoine that the result is not much more readable.

Regards,
   Nicolas

> Maybe you could try a mixed approach; keeping the invalid modes checks
> (bitmap_zero) at the beginning and once we know the mode is valid using
> a switch statement. That might make it easier to read as this should
> remove lots of conditionals. (We'll still have the one/_NA checks
> though).
> 
> (Also having patch 1 first will improve things).
> 
> Thanks,
> Antoine
> 


-- 
Nicolas Ferre
