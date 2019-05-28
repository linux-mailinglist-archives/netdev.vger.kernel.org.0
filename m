Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD892BD0C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbfE1BzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:55:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37678 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfE1BzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 21:55:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id a23so10450195pff.4
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 18:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dmKrdSjCNedf8ly7Q9DbnPAxE0qkHaQubycOsdOK2IQ=;
        b=G9oHTQ54+FJA/Tr7HJ2Qw/lRlmHWVYZ6Kr8I1xQspwFMaa7Ws94dmk2XvTPKI/yBX4
         6WV6nbbo0Ki2RNZDnQNfY1qoFzfMycoEnlXcNQXl9B6ncj35ql8Lh6EfyZ2B0uKQWxVh
         /kuHoBgoca97/60y48XEWEA52JTVB+mWMMJN7W49iIbojBshkj1xBkuJkp3sH8hgdXto
         eMBq0jHXmywKlq+KGke9uIfbB63b6+zjZZnrjZ5oWBtDtafz/ofrt6aI2DtmLQA1vFeh
         1Hxcm4CNJq6EaeQGQX1u05OafW42Bo0dtJp/pv1W7gqg0649jteHlVWPZdem9EaZdU5f
         hUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dmKrdSjCNedf8ly7Q9DbnPAxE0qkHaQubycOsdOK2IQ=;
        b=k9PaEHvnqfyILgpplWNH+P4Xhbjz5Q7nf8DHVrBAW6ZRQqC5DlQygvtL3G7/zgNqfP
         H5iKB02RNhX3KhqVqFtqTshVUQ77xp74H3BuP8W8HnrKt2D1NhKdQM4SCam/iQklHgSI
         iEtIrS/R/uq0kqAvhilkDGkwIqsCtem4ToWx5VWWMJT0w0TCJOjFYatRVlENunZgMqGE
         185x14l5ih7RNeMzmErX0luXPojqPvwbpnYFPyCBAjAsDow6NWJlAl7zhXdRawXMqpcA
         K1exHByfNNeX0qlnEDLuDXlmSSEeuuD9hFo6lPCQ7JpUzZ5Jy2X9IvnGHaEwRs1vG3GA
         hBcw==
X-Gm-Message-State: APjAAAVgd8sk6SogXvgR5qodkWmZGYUVtl5xDe8scxrlNeSviZi8tkEt
        ly3af+2nn2A4iddzGvFP1ClL1f8b
X-Google-Smtp-Source: APXvYqziF6Zpv0J0fS7dSeJspAoM8p8MXKD4FuKe1wi6va4w8kLK7sKAxSdfk0wPCTJopayxlfnV8w==
X-Received: by 2002:a17:90a:207:: with SMTP id c7mr2155175pjc.94.1559008505673;
        Mon, 27 May 2019 18:55:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id j97sm672023pje.5.2019.05.27.18.55.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 18:55:05 -0700 (PDT)
Subject: Re: [PATCH 10/11] net: dsa: Use PHYLINK for the CPU/DSA ports
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <abea8843-2e42-c18a-79ef-cef670773b03@gmail.com>
Date:   Mon, 27 May 2019 18:55:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> For DSA switches that do not have an .adjust_link callback, aka those
> who transitioned totally to the PHYLINK-compliant API, use PHYLINK to
> drive the CPU/DSA ports.
> 
> The PHYLIB usage and .adjust_link are kept but deprecated, and users are
> asked to transition from it.  The reason why we can't do anything for
> them is because PHYLINK does not wrap the fixed-link state behind a
> phydev object, so we cannot wrap .phylink_mac_config into .adjust_link
> unless we fabricate a phy_device structure.
> 
> For these ports, the newly introduced PHYLINK_DEV operation type is
> used and the dsa_switch device structure is passed to PHYLINK for
> printing purposes.  The handling of the PHYLINK_NETDEV and PHYLINK_DEV
> PHYLINK instances is common from the perspective of the driver.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
