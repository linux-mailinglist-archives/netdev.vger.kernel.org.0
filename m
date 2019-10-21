Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214DFDE22B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfJUCfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:35:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37463 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfJUCfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:35:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so6808505pgi.4;
        Sun, 20 Oct 2019 19:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4dTX5QEeIMl1rHSa77n8K4615s4yY1hd+Bbq0tmT6Iw=;
        b=SbVXqm9R6gVBxOC4iuCx7FtSH2VL4fGpSlu6lIm9eFNs1Bum6ZDzI6powSwnqd0D6/
         NRY86YgDt67SYJqqE334D6Et7203nBFuzWrWgVqlbwOCilnq5/BxR53I1kSyJYCmvRku
         dg0v/D5LUusYdvR5uZVR2IosWWbIobXrzzuqNP3wyYcUaqKKylgBCKdcORL1YW9jXO8X
         P8GyJB2z193Fycc7g+UD9QL65+7PGFXNYwmwZQeOrOe4ZR7OAKTG3ji15e/scSUieFsN
         iovGbhgUJlhPy4QJEv7pBIsix4cq2KnqiKK7wpD8DNr+O9az/EQE/cIPRQDeaG3MZpD+
         S7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4dTX5QEeIMl1rHSa77n8K4615s4yY1hd+Bbq0tmT6Iw=;
        b=Xg3Si0YsaaNXOiNlC+mlszQ6VnHpGw3Yv2zmD2TzsXlznv+txRM8JZVJ2jWVMV12+y
         7+xygjw62xNyJPtfO1NquhJo7ZolaQKRr5u14BRBzMOF3xBfCUuEgw+7Y+Sw5m2Gc94i
         k37mb0Oq9jsFesZiCScq+dP4g9iEAAWilmmCjjj2jDiQBzDMb3PqlwVwZpbo4zjOTMAy
         l5mksU7CXgqVkwJDtHzUfVMDvsbDCdbJq/PcULrtbT/Gxfr8qhZfBtj11a33MMVSI4SW
         moyGQJb28n2dVjrL6HHWkPSchxTJcDS0YTCkMZ627ZCriTlgPUse7BNQAU0AraOc0UvD
         nfjA==
X-Gm-Message-State: APjAAAUGjRQG+iYsUCspw7spOfBPS3511XB9roqYmX9USQwSGLmXTq4B
        Xwp1MLW1baBFpuVmDxM2UiRCDfm3
X-Google-Smtp-Source: APXvYqwFhXqRcW8GJS8bTstm30XBsZCBgB7gzCsRnoYaoaLvOOq0Sj8f9cx0cxfBZl/5fhOurVDRBw==
X-Received: by 2002:a65:6082:: with SMTP id t2mr23332023pgu.363.1571625298770;
        Sun, 20 Oct 2019 19:34:58 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t13sm14441333pfh.12.2019.10.20.19.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:34:58 -0700 (PDT)
Subject: Re: [PATCH net-next 01/16] net: dsa: use dsa_to_port helper
 everywhere
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-2-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f96357d4-4e64-9c8f-073d-7c6ae8d570b3@gmail.com>
Date:   Sun, 20 Oct 2019 19:34:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-2-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Do not let the drivers access the ds->ports static array directly
> while there is a dsa_to_port helper for this purpose.
> 
> At the same time, un-const this helper since the SJA1105 driver
> assigns the priv member of the returned dsa_port structure.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
