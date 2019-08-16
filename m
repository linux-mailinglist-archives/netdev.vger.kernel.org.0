Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E952A8FF04
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHPJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:27:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38145 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfHPJ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:27:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so904045wrr.5;
        Fri, 16 Aug 2019 02:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oYkbotweVRb4ftV2/uVHHZIFS0AoWMqkCv8uwUS+oiE=;
        b=FfyHhKNNxm1mI2D+JurEucOuQV6fl3XUDy/copih67qITK5WZoaDNfy7tTGTwIyXdN
         tmy0wK7NlDtAX14x2LTN2Q/rjsZZ6bq+loYe8gB+x4UHD4QVCVL39Ky8n5ptAV/GYclT
         3BCnvxW3Z/o3N0XvzN093O/VAjRHPSGW7Hhp2rLB0DRRAMWGkeIntEdiNOIKUucHEEjb
         ohDCqgCdjBHnNOB6hOzGibQh70o3cYkX0DZRJ+DXK5HAHnvmkwF43Y9iKtjSrpTKtUtl
         FVJxpnGIVHXVF9LjODRtO0koMfDsJFLFjl3hWOWuU6BpqBNhQAcxzr8t2Ust40iZ56qd
         pK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oYkbotweVRb4ftV2/uVHHZIFS0AoWMqkCv8uwUS+oiE=;
        b=iRpniliuz+Tmq5hZaTzpnpXN7b1vMJ0Uqfu+kqE/L9H2wNBAeB4CyPVRNUjPIdk455
         htyZLLzCY0a775X1WVTxiy1PRLAAhiTiws6I/d+dr88rBZdGVEKLy4PWQbqiOdwFXOKD
         ZJuajVZB7Xdnkx4P64jI1mxZqFdEZKxJJrOpF1olgtEua8/2F7Pgjt9lFqyviN4fSY4f
         ycQvJrOUDyxeB2GxlkqMmHr4gffs3HUDYxQ86qXtBsbMM4cmnDw14AFUek3B+kQFOe5g
         WWnPTJ/DBVZM17/vZkBkthAUAcc4bjSox/mKdiRwUWSbKxaWrOSJgWOrPZPuRJITsgjl
         JZxg==
X-Gm-Message-State: APjAAAXwjTmsyxdUnP6eZMW+nsohjZhwx9v5EIhyR7RS0D0LzKPTz0ni
        CqCBjlZk/ZbHxLfzxGZzKZv893ec
X-Google-Smtp-Source: APXvYqzme0ZdMBuRNkscCYPjra4vTBGVPnWgnx/112Hd7r/aL2wtFNDa0RKTjrpUuuruE0emLP6c2g==
X-Received: by 2002:adf:dcc6:: with SMTP id x6mr9719759wrm.322.1565947633523;
        Fri, 16 Aug 2019 02:27:13 -0700 (PDT)
Received: from [192.168.8.147] (187.170.185.81.rev.sfr.net. [81.185.170.187])
        by smtp.gmail.com with ESMTPSA id t19sm3826386wmi.29.2019.08.16.02.27.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 02:27:12 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: divide the tx and rx bottom functions
To:     Hayes Wang <hayeswang@realtek.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
 <68015004-fb60-f6c6-05b0-610466223cf5@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D47C8@RTITMBSVM03.realtek.com.tw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a262d73b-0e91-7610-c88f-9670cc6fd18d@gmail.com>
Date:   Fri, 16 Aug 2019 11:27:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D47C8@RTITMBSVM03.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/19 11:08 AM, Hayes Wang wrote:
> Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> Sent: Friday, August 16, 2019 4:20 PM
> [...]
>> Which callback ?
> 
> The USB device has two endpoints for Tx and Rx.
> If I submit tx or rx URB to the USB host controller,
> the relative callback functions would be called, when
> they are finished. For rx, it is read_bulk_callback.
> For tx, it is write_bulk_callback.
> 
>> After an idle period (no activity, no prior packets being tx-completed ...),
>> a packet is sent by the upper stack, enters the ndo_start_xmit() of a network
>> driver.
>>
>> This driver ndo_start_xmit() simply adds an skb to a local list, and returns.
> 
> Base on the current method (without tasklet), when
> ndo_start_xmit() is called, napi_schedule is called only
> if there is at least one free buffer (!list_empty(&tp->tx_free))
> to transmit the packet. Then, the flow would be as following.

Very uncommon naming conventions really :/


Maybe you would avoid messing with a tasklet (we really try to get rid
of tasklets in general) using two NAPI, one for TX, one for RX.

Some drivers already use two NAPI, it is fine.

This might avoid the ugly dance in r8152_poll(),
calling napi_schedule(napi) after napi_complete_done() !

