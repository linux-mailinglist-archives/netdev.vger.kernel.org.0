Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FAF627C94
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiKNLnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236229AbiKNLnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:43:31 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5044A247;
        Mon, 14 Nov 2022 03:43:26 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id k19so12809706lji.2;
        Mon, 14 Nov 2022 03:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xnVkVYt6NjXq2U10H+GjcZriFeppA49EKxZL4u1ETg=;
        b=DJYPWegol9Mp+1bBiyC6kheikgEvnJnOVLlM56Ma2GdT+L4kHpqtLxdqoJS24ZT5Kx
         9PIQgwfK5ZVi/V2CUpvBZb6Ga0zgQK2ABH7cFZ5/LdW56zYq8oUfgPdxwSOOgzbvkO14
         ufmIiDp2SBsuSqL6co4532zebqLlkVNfFhMWESDA5YFBGq8pWuFzDtHtaIYkM7vB2fCd
         UeZZ4jaghHRxjxVxe+mt5YHjOgTYqN11bjGoo5erCApseMko7oXuhj3Rt2PpsCtyzqcy
         KZ8tBKEUXljtyf9SMCUC12kBv4/scKdLuINUKdA6ZdnCzJ62N2+1vgo4h+pimP2A7aVS
         wvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xnVkVYt6NjXq2U10H+GjcZriFeppA49EKxZL4u1ETg=;
        b=FmDt9yH75d7d/yF2Senm3kR6LxpM7oGa/gzAYD6lOZ6+PcYWDfcZvNyYiC0pXdaONl
         zbQAzYv/x3focnQFQBJQcztZdPuAzcZXbEViTt2FKv+pGJcsD213OeKxvlvxrjd3Ic4V
         ZQtkwOLbh0+2WOqbpewmOwMFpCPjCrxcHuanBJEwg9lXKT4LWguau/PG+RlDmjV+zjzy
         r3drI3xTSKere6c/GDZobvG3oaSmruLejR+g8SG4V2WkLt/sqLuzSnFVVTDLQ0NZ88eX
         67flCVfwSszOk0VVYEUYOJmxpAunan8kWrIBeMRUOF34UO97OB9+5W9HFhxDj+YGnhqh
         ExhA==
X-Gm-Message-State: ANoB5pnWgqdAWpeG8pdys4u/AomVDUKBw+MmU0C1hMEkZTTSqD/yjVdN
        H4tR9b7AlrtL6j+8Qrq6eOZtH+kUzsE=
X-Google-Smtp-Source: AA0mqf4dfqmYZ1FjH1UgobSbvCvX8bwQXhiu0h+VQoHba7Wk2f0YpqJTU83M4MTmIQhSNHpV9VVXVw==
X-Received: by 2002:a05:651c:88a:b0:277:2:1efc with SMTP id d10-20020a05651c088a00b0027700021efcmr4389600ljq.77.1668426204721;
        Mon, 14 Nov 2022 03:43:24 -0800 (PST)
Received: from [192.168.1.103] ([178.176.74.221])
        by smtp.gmail.com with ESMTPSA id v26-20020ac2593a000000b00492b494c4e8sm1793818lfi.298.2022.11.14.03.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 03:43:24 -0800 (PST)
Subject: Re: [net] net: usb: smsc95xx: fix external PHY reset
To:     Alexandru Tachici <alexandru.tachici@analog.com>,
        linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, andre.edich@microchip.com,
        linux-usb@vger.kernel.org
References: <20221114131643.19450-1-alexandru.tachici@analog.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <adb2dc3c-fd1e-53ea-ca64-5c1600058890@gmail.com>
Date:   Mon, 14 Nov 2022 14:43:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221114131643.19450-1-alexandru.tachici@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 11/14/22 4:16 PM, Alexandru Tachici wrote:

> An external PHY needs settling time after power up or reser.

   Reset? :-)

> In the bind() function an mdio bus is registered. If at this point
> the external PHY is still initialising, no valid PHY ID will be
> read and on phy_find_first() the bind() function will fail.
> 
> If an external PHY is present, wait the maximum time specified
> in 802.3 45.2.7.1.1.
> 
> Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

[...]

MBR, Sergey
