Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B558B23ABC0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHCRkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCRkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:40:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F714C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 10:40:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w17so21141197ply.11
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 10:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IWOg7ZveDbnAGKuLkMI5jxOeWbrwKJyVxz9y0vV2fa4=;
        b=QIALCFXR6o+BPgwrw7U4+BwG6hf2hE31fpreeV5dZFbTCOlh4Muw0S6Ibgr3TgTY7m
         s7VjR8pKYxAbD6FB9yE94vOTOhVsDhKSGFwlT9MhDc+DDME+/zE1wN7r13OYmrnk9V8D
         91fP2D42lYRXAPtbtgxUksEdi4DIAHcBAcSGcreAzg8kSYMEgz15XmVvFmmZjZDbRsza
         XB5PQ4RJU6EthfWHGfJHlhuWWk075Vy/SuzUEOZ4ETZm15aaXg0jOW7FZL4z+9TXJwk+
         GRta5wJS8H7S5WssSVafo50AdsV7X/3s4l82/BIYoR8W3qYM5Q/pde5Msk6eeKBYRiXA
         kSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWOg7ZveDbnAGKuLkMI5jxOeWbrwKJyVxz9y0vV2fa4=;
        b=fA4Go4DUm10ePW1EmQq8P0ZIklxD2G99TG+LE8K1w+7BjU14uzZ4o9gzM9pnZQx6ET
         LzPL4xAOX1/Ql+a4+msv8i0PFnleRoqo/Ll0Oi8PhCiSCc5+9hbA9w4/UvR5EExbOOlV
         GMu1j6R6413YjDurNTJ940qgDTo2weda+qppsvNd09704Gwsv4wYFvBgw9gPwXLwTsm7
         TQ0B3wEbAWLz20wdOvLQdwiigEJ9/VHkO2i0jX8k9sXUdKZYplEWhVo9Vjt65d77dDc9
         mdm/ojSpH+NGjjI2neyxr2cIULDIIzlNwpP5TCurpubUCZgFZnPLCkIaDf153NBJGcYJ
         av2w==
X-Gm-Message-State: AOAM533mSeDQUV3jMOCvu5eHRSGujo8yiJ0KX/ROlp5JqaexYC0mLZnM
        +oVLvPoRuhK5W8i7NacuTuyMnrb4
X-Google-Smtp-Source: ABdhPJyUpeQubsmkCxAnpPDhSF6ZZa2LTxZG9Fqg1gM+0Chg9EQNnTy9ZreaVAjYuGYyRPJdQV1Xrg==
X-Received: by 2002:a17:90a:3268:: with SMTP id k95mr380148pjb.153.1596476408789;
        Mon, 03 Aug 2020 10:40:08 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e9sm20490706pfh.151.2020.08.03.10.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 10:40:08 -0700 (PDT)
Subject: Re: [PATCH v4 04/11] net: dsa: microchip: ksz8795: use port_cnt where
 possible
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-5-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <07467628-bd2d-46e3-ca3f-74c2687110b9@gmail.com>
Date:   Mon, 3 Aug 2020 10:40:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-5-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> Since the driver can be used on more switches it needs
> to use flexible port count whereever possible.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Since you appear to have access to a dsa_switch instance in most cases,
maybe consider using ds->num_ports directly? Not necessarily a big deal
and the current change is an improvement anyway.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
