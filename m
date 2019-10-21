Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A1DE256
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfJUCrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:47:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33103 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfJUCrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:47:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so6834673pgc.0;
        Sun, 20 Oct 2019 19:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+g8dbmU0gwK2qHEhGcyEjLWgi+qoJCaA2Aftx1wjA6s=;
        b=slvxP8RerMUtvj1Jc+4t7+Wpf099PvxRFAVdalfEcVEuXpe0esCCbR8OgIaH8rImbs
         s6XLyAgRuZlcfMpRAbzPzwja7oOoBeSs1A/S2P++csla8o26e5/4yCcg8M0o/fEmrK4K
         KUzgmZGtoy2t44S7CytSuIQ1oPVY6q32fdBeqfrScS92BoyhQKhtoaADXYYyWz260Rti
         Vbms8/vi+xy6r9AyD8edc4hNcCyXcKngeROwNE/5RcwX9urgB9aU6xWHo37O3yMN2wLB
         F4s1G/sOw/25AwP+H0jIqrBLxy6+J6whqgnblEv2cjMvpM7wXDupLygvxIjjV9UA74AU
         cAWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+g8dbmU0gwK2qHEhGcyEjLWgi+qoJCaA2Aftx1wjA6s=;
        b=ANLRlNlq9L9PXlNCYAqMc+k3vZcvL/vuoe5g0r9Nmk7/3o8oFrom2M/PZJzsDbJnRg
         1wY3tRTPHy1n54HO6+9I5cYd7sAyZZ79jvjiiLDdWOM/RT4tJDdJkV0xJ8QXJDB2dRc5
         BAjWWRxHQTc1LomMSad6HZ9YVCkNKYf6O9K0r8jspsGmFWfuwiVa5ubPc8evI5TWJImy
         m1I8evw+A+7/YQAcSb3jdkndlQogOfTid7yTR5ltLxwgFPPSCH4ppznePswCMFT4d5qh
         hfDzuAPhAx9+kOMvwvGyeZfA8SSsUpia+2D9YnJk9i90ZgfP46fiwmAx005cSNlPevb5
         aSBw==
X-Gm-Message-State: APjAAAW5zEjTGWziHAD2MfT8h5hXrgYBiLRxM4AoBf7zoywXoagD3YA6
        ekPqqbCnm/IWlcxker4X1sMxKY8M
X-Google-Smtp-Source: APXvYqz4OLsbiIDw7+z+X0v7/ITWZabMcb8k2b6WLjmcwM8fNjvbgm5KnC2+w+yWMkVDkwR5huaClQ==
X-Received: by 2002:a63:f40e:: with SMTP id g14mr11381805pgi.62.1571626038445;
        Sun, 20 Oct 2019 19:47:18 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id w11sm15204603pfd.116.2019.10.20.19.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:47:17 -0700 (PDT)
Subject: Re: [PATCH net-next 10/16] net: dsa: use ports list to setup default
 CPU port
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-11-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2e1dbdc0-d1c3-cf9d-d495-fa9d52a3534b@gmail.com>
Date:   Sun, 20 Oct 2019 19:47:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-11-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Use the new ports list instead of iterating over switches and their
> ports when setting up the default CPU port. Unassign it on teardown.
> 
> Now that we can iterate over multiple CPU ports, remove dst->cpu_dp.
> 
> At the same time, provide a better error message for CPU-less tree.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
