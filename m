Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBAD98918B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 13:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfHKLf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 07:35:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41895 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfHKLf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 07:35:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so1620209wrr.8
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 04:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QMIuARm10JkhWQ14TW6KLz8Mt89/qAloGbfciO1m5Xw=;
        b=VW1uweestFGOOOXV0fEQKUY7gzuOXfTysXARtcmWq8HZxy+tsGpmHTOAbi7czntKa2
         QxCvipF2li+zAhkCz7FhbgdWjNLGsU8v6hMsQsSu1WsnhorpIerfqKPUJE3sxPuk/1IN
         QAWqXr4+BjUL4Tc1wTKC58goPf3d6d4oexebizfV08s+gIJnABUl0MPIaOAds0xZAmiS
         ywRdnLXNMwsSGOsy5lv+v0+QXoZ1bxTHMEPEDfcDdOEb3Ai0u/2iebKZfJYXi4Susej3
         /+jrfV0yJKHStx1dszthxO+lfji2wevD+BU+MCNxUgMIZ53bQORlIVxMnSxtwpidUVSG
         CuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QMIuARm10JkhWQ14TW6KLz8Mt89/qAloGbfciO1m5Xw=;
        b=YCfqf6jJ3Y1mHnfZhEjSrbKGWpsibdt6pA4n14fRmWlbOiKtgUDYTviK5fC9rwgETs
         itbJi3aXBDJ+pShD2ln9vEgomf4EHjPgmQCNj86wjuVnenCyfg4jzzpKbsMlEL+X3fzh
         tOyto1+5yVg8dwBlEbTXg6a82vG5O69K8JrA4ECY+y/GN/uFBAdx2sQaHwl5F5E3pxo0
         3KtLMup6L2HG3s+RSmoUVpfUcCutVLfXaHM2utqZPEjPNTsubqdpfe4y2XlpE9K9f7Ht
         85NzDVcZNI/qKbKA12vwns/gjioEPln86tvzGE01sInTv35l12jSuvB+j1ufHVSVCR7o
         Qbjg==
X-Gm-Message-State: APjAAAX3zCRbHqnGmou0+p06cmjOGQYtTEktHfM5FtpgbmkWXRvNND1X
        3nXEQBhEU9uU+TcJnjpJ4hk=
X-Google-Smtp-Source: APXvYqwW/PT0PZe0fWaqSkDCECHcdMHhzGYJGbs4c7Dfo63p/Wi7NCreEr4eGdYfwlE0XW6Mi2OjOA==
X-Received: by 2002:adf:e504:: with SMTP id j4mr34311321wrm.222.1565523324651;
        Sun, 11 Aug 2019 04:35:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:d862:102b:b1a6:862d? (p200300EA8F2F3200D862102BB1A6862D.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:d862:102b:b1a6:862d])
        by smtp.googlemail.com with ESMTPSA id u130sm22179937wmg.28.2019.08.11.04.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 04:35:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190811031857.2899-1-marek.behun@nic.cz>
 <20190811033910.GL30120@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
Date:   Sun, 11 Aug 2019 13:35:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811033910.GL30120@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2019 05:39, Andrew Lunn wrote:
> On Sun, Aug 11, 2019 at 05:18:57AM +0200, Marek Behún wrote:
>> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
>> genphy_read_status") broke fixed link DSA port registration in
>> dsa_port_fixed_link_register_of: the genphy_read_status does not do what
>> it is supposed to and the following adjust_link is given wrong
>> parameters.
> 
> Hi Marek
> 
> Which parameters are incorrect?
> 
> In fixed_phy.c, __fixed_phy_register() there is:
> 
>         /* propagate the fixed link values to struct phy_device */
>         phy->link = status->link;
>         if (status->link) {
>                 phy->speed = status->speed;
>                 phy->duplex = status->duplex;
>                 phy->pause = status->pause;
>                 phy->asym_pause = status->asym_pause;
>         }
> 
> Are we not initialising something? Or is the initialisation done here
> getting reset sometime afterwards?
> 
In addition to Andrew's question:
We talk about this DT config: armada-385-turris-omnia.dts ?
Which kernel version are you using?

> Thanks
> 	Andrew
> 
Heiner
