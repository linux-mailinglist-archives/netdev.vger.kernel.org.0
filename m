Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B11CEB43
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgELDQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728564AbgELDQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:16:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13C8C061A0E;
        Mon, 11 May 2020 20:16:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q24so8705477pjd.1;
        Mon, 11 May 2020 20:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TMTWD2AEyTJvNKmDbcm7IQuSKi2QY0etChP/BpKXe0Q=;
        b=F89vVYAiesAXDj1ZMHZrzG6bGF08aVe6u9c9mIiR2uqM6D41RNRi0BccSiG7dj/PVT
         yhh8VhuzouUV7xbY2PPE9/BHwh1ehR7NBsx86mhbds96z9M4gjC4I20Z1vHAHX4LbfOn
         2zkXxI1u/KaZKrOYqUZZGwX4Z5ZkAOtRxUzM5a65fi8KR5VUOMCqTYi1uHg5+D5obpRv
         L/CIbeKOzuVrir/s6gRFePiAIkd/ohblJ2OJtQXTzay9RZ8/MlKElE1PVONJycnTFlWQ
         Gu+Ph+KYm5VDHUl9ehIT1BXZ0BkOoG/OiZHfnEpBBh5vObyttX5d57Am4+AeJwkmMrzu
         8LdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMTWD2AEyTJvNKmDbcm7IQuSKi2QY0etChP/BpKXe0Q=;
        b=O4KTl6fKtzr3IThvj4CC5efihExg0flhjcLplUckfU/mjpR+T5d1kvrmtEFHRXs3B5
         nf93s/u8UtaNDyyxZa9ui/Xxq8aPZeOFO5h6t/x5X9yLxjG/8QM6EshNTYmw/iZe6CMq
         cNDmXlICffQJmwmgx1SrZUYvcFhHApq4EW7yutFqfPchT7UTJL7r/uYTwLA8Upy/Zp9F
         wIHCwcCz+nKztmo+8RzIetO8YiDdnntU8DgmoF8ts+4xfnI0GLLQN+SZHCWSLjV+ritz
         FhPOykaSCFQ//HGtpC3hh1oKllFoZqS3dkhFwviJPInb2fP4R5Bu5d+VfY+HmsZ/UXm5
         iYhQ==
X-Gm-Message-State: AGi0PubEwJyoPMWLWFoXPKmHwe18G8hhYRaxymoOrdsqpbS81IiTQgH7
        82aW+DHWL749M7DuAX4SZTKMkQd3
X-Google-Smtp-Source: APiQypIjkdBluToqMWAYZfwoXkyHBB3/YZZNVujMHtl3WhuyPDh6qm36TvXC2Cr3muURSDTXAD/VBw==
X-Received: by 2002:a17:90b:4c88:: with SMTP id my8mr27001635pjb.199.1589253377745;
        Mon, 11 May 2020 20:16:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v9sm11206720pju.3.2020.05.11.20.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:16:16 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7810cf09-0dac-638b-6ec0-e8a5002ae7bf@gmail.com>
Date:   Mon, 11 May 2020 20:16:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589243050-18217-2-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 5:24 PM, Doug Berger wrote:
> A comment in uapi/linux/ethtool.h states "Drivers should reject a
> non-zero setting of @autoneg when autoneogotiation is disabled (or
> not supported) for the link".
> 
> That check should be added to phy_validate_pause() to consolidate
> the code where possible.
> 
> Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
