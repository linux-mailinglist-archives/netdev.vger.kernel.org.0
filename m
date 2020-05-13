Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B131D1F4B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390662AbgEMTee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389392AbgEMTed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:34:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B030C061A0E;
        Wed, 13 May 2020 12:34:32 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so225793plt.5;
        Wed, 13 May 2020 12:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x4IVpUQZAKqFxBsGMx7knF3FrBnYiY/uTE2x43zJk7g=;
        b=jmYrsHPVouqDrQYBHnc97cyc0e0ODGyl2HNK1XN5tmqgUoXmzNVIJfWn/DFHi+yuTM
         qvpNBOG4IZDODj/jBAOQ4oSWfAb5Q1C4ZXfA9rZA00FYkOiLvz8XaCgh48OGeDCUNwio
         II1nob2MKhsGuIJAD1+TkvSVgR3tsi72QeCNY2tJz3VuXd/MSLM4eIym3PGUq5els/JJ
         NqO42lFrPZXBUVH7c5InCFvqFdAC7uqEhMvn6+8/FTzUElKyP1FOcknXV2/Q/ttIee1j
         g4e6O9FFjfzIdU16z8otYSwAVBAHPsqput83eZezM5lWBGmAilDP4XTDGiDagzciYG88
         uOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x4IVpUQZAKqFxBsGMx7knF3FrBnYiY/uTE2x43zJk7g=;
        b=kB2oM+UnbP56nH2YYkLeMD/kB+nWt0l7XtLNc7vI8POrXaniBo/QpYgHqcDqvXq8nh
         8zhFx4zoEv3vyaGZGlNUMM4QxiSzvYsv9HQUA65iAbvQ9bUkPmYLyGGKptASFVttcsle
         nQz1O6BRGY+QPwDbNyN8xYZRrqvNH1lw9t32BRUJYmQ+q9gWlvIlMhUgC2WmSjRk53Zf
         9wUe+M07PDqcGXN/AqO9jjxFMuQ++xaPPOqbVgFYV/FO99DMySUp3oJ7t3gJkmmVduXY
         Ce8BAVXQADIj1o2FdMsAMjAPSXL332+kha3I+mGwIinl3H8O7YL9185OmK2JlWQ/Lsga
         eK8Q==
X-Gm-Message-State: AGi0PuYRvjgl5xn+6xEuOw0WsDAWorIrvver54ih+G1loMG32QnzXyxj
        NlZGvekGj4aPFL+t/vTk+V+6JFAa
X-Google-Smtp-Source: APiQypJ7Zvt8D9yc9MBg3FQyn/C7CGksYuTCjk10gyKh8bkYo3zX7OKS+BHRYWg0bEBPzidqzYE+KQ==
X-Received: by 2002:a17:90a:9f92:: with SMTP id o18mr36384670pjp.180.1589398471222;
        Wed, 13 May 2020 12:34:31 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o11sm282631pfd.195.2020.05.13.12.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:34:30 -0700 (PDT)
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        devicetree@vger.kernel.org
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <92fddcd0-7764-9d9e-8bd3-9fd6cdaba2f0@gmail.com>
Date:   Wed, 13 May 2020 12:34:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513123440.19580-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 5:34 AM, Oleksij Rempel wrote:
> Add initial cable testing support.
> This PHY needs only 100usec for this test and it is recommended to run it
> before the link is up. For now, provide at least ethtool support, so it
> can be tested by more developers.
> 
> This patch was tested with TJA1102 PHY with following results:
> - No cable, is detected as open
> - 1m cable, with no connected other end and detected as open
> - a 40m cable (out of spec, max lenght should be 15m) is detected as OK.
> 
> Current patch do not provide polarity test support. This test would
> indicate not proper wire connection, where "+" wire of main phy is
> connected to the "-" wire of the link partner.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
