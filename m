Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEE19A29E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390342AbfHVWJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:09:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33147 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390304AbfHVWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:09:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id u16so6829578wrr.0
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M+oIdnD3jm/q0FEoEMnIGzoD27Ik3dMH4NYQUO8iSBo=;
        b=ZI42VLIf3XR0ok5i+0x5WISOnHyGwIZxT87RAf5JOkT72TxGxOM5SLOZYlrOMK2Lz0
         /pMXLKJ9Bp6o+JdDPyTNehpyrMiXLKq/THe45t1S8Y9iG0NX2rg/tiUPjo6oBHCdZUgS
         H9MYSXYdU+sMDcOmye0Qxn0PQG2F3X8yS+ekQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M+oIdnD3jm/q0FEoEMnIGzoD27Ik3dMH4NYQUO8iSBo=;
        b=ine9GIslak0VrWPd2uCrj0MG1IKgpGSRpCBNR60PJnxsSi+5FfW8OIiTCXHQhmIShP
         1MMEPpDq+6r/HS2hQo2yHlMU2GVlN0N0F94aK+ZCOOneBdxHB7wb2NNwAW03UlbRkTkg
         rf7RE3pzjt+t+RxoJo08C5UKxk5IlWu8n7l96+MIp+ErUzPbcutUsgU59ju8FdBcr6Ny
         vdXLsBFOUYZ+EqJU+2N0bODYqffh4RWFUeL28h12KE/qKWOJA7nm/UgJrmrM4Er0hnJO
         1LqaqOtFdU30U89KXnVbbTHd4a4dI62o6oc4ZRPCGfRkCvjP2tY8ldaS8k3C1r0qzeDh
         Vn4w==
X-Gm-Message-State: APjAAAUkI95WA4voxwsffCsClxFX9jnkTpCDiQpjuFT13lYwXUCb+Mr0
        pCgToGMdTkjqYj6uRN64ddtiKw==
X-Google-Smtp-Source: APXvYqwhFYLuDgxoml+DLuSpfZTqsK4iafwdRNx6hqMwddGuTcDHWBVBaZxAq1227fwR/ulvrWIyEw==
X-Received: by 2002:adf:e504:: with SMTP id j4mr1064839wrm.222.1566511792353;
        Thu, 22 Aug 2019 15:09:52 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c11sm590230wrs.86.2019.08.22.15.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2019 15:09:51 -0700 (PDT)
Subject: Re: [PATCH 0/3] Add NETIF_F_HW_BRIDGE feature
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1e16da88-08c5-abd5-0a3e-b8e6c3db134a@cumulusnetworks.com>
Date:   Fri, 23 Aug 2019 01:09:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/08/2019 22:07, Horatiu Vultur wrote:
> Current implementation of the SW bridge is setting the interfaces in
> promisc mode when they are added to bridge if learning of the frames is
> enabled.
> In case of Ocelot which has HW capabilities to switch frames, it is not
> needed to set the ports in promisc mode because the HW already capable of
> doing that. Therefore add NETIF_F_HW_BRIDGE feature to indicate that the
> HW has bridge capabilities. Therefore the SW bridge doesn't need to set
> the ports in promisc mode to do the switching.
> This optimization takes places only if all the interfaces that are part
> of the bridge have this flag and have the same network driver.
> 
> If the bridge interfaces is added in promisc mode then also the ports part
> of the bridge are set in promisc mode.
> 
> Horatiu Vultur (3):
>   net: Add HW_BRIDGE offload feature
>   net: mscc: Use NETIF_F_HW_BRIDGE
>   net: mscc: Implement promisc mode.
> 
>  drivers/net/ethernet/mscc/ocelot.c | 26 ++++++++++++++++++++++++--
>  include/linux/netdev_features.h    |  3 +++
>  net/bridge/br_if.c                 | 29 ++++++++++++++++++++++++++++-
>  net/core/ethtool.c                 |  1 +
>  4 files changed, 56 insertions(+), 3 deletions(-)
> 

IMO the name is misleading.
Why do the devices have to be from the same driver ? This is too specific targeting some
devices. The bridge should not care what's the port device, it should be the other way
around, so adding device-specific code to the bridge is not ok. Isn't there a solution
where you can use NETDEV_JOIN and handle it all from your driver ?
Would all HW-learned entries be hidden from user-space in this case ?



