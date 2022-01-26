Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2045A49C24F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiAZDuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiAZDuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:50:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE00C06161C;
        Tue, 25 Jan 2022 19:50:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o11so4884293pjf.0;
        Tue, 25 Jan 2022 19:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=CRmGjJGdnRQ7aXhD9SM9y6H1yrl9hFe1m8htZGxRRRw=;
        b=azZ0eBJz2fcpgMC6nj0CSSmQLZcsITT8AXBMhbTa574YJaQ5qdJMnmKp08luUEsszb
         GkeoK7PenZ3VJQZAW9dDyBjvffUFgIPmLzA8HuTEXCeA/rQziGi2oCTNzpAIDHsAAI1a
         +ktkjz5SYYLPc/P+ODodot7EqTOlLoxoud70slszSO+k3EH5nnQ7wK2mzGg6eMseMlxR
         D9W26ZcbvOdVfhBiFxDTx65CJ+zOtnZSTjCq3BvHlTVeVIYmR4wID7a28qidiIcEHYHs
         jaoV+YbC5EFUpdCSyrUiAIZrCEwqOUCDOM+uGIgWyutE6QhC7grQO3yig37Ltzn8MjXD
         glXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CRmGjJGdnRQ7aXhD9SM9y6H1yrl9hFe1m8htZGxRRRw=;
        b=Q3qCN3MTVOmjdPfAZ9f0933oA7nxOBHl8/PgPDzMI4dH4zX667nZT3Dyhh+tXiS86+
         nLSZLJFZga6j4Th412fd1RXjJVLTbRWBCPDHyhR0vyXWyn5rthZsdJYpiG4PtinmRlHY
         epbgoFpPjpdPt1izLcCgejQXPnMmpqtcWoE9YaPeh6cZ2IaJqKXbvaKN8FAYNZXkq3cC
         YWw3cnqjv8j8A5S6Lz73QPR/+QusNd0e843/oQtdjuyQIKVw+thHd9VHwClPlEcvOsR0
         Han9jEYGAbTwFq7+3Y4KTeKBz1BbwQP1Os5sKUHsNweFym/e+ab4DuxA/0K3iLe7myas
         FK/Q==
X-Gm-Message-State: AOAM53032ih20PyIVWYEIJeQTCI1PxEqnoF2o7ltMt7EN0jm6BQ3+u4y
        InwWYmMvxaZADa+K4KEZUNI=
X-Google-Smtp-Source: ABdhPJzdHHQE18eTClYDo/Qn4RIJ+iR2XjVppkUhSSp7xFwp8SCG4RQYNT3N7tMsdSygBcK/zWnd/Q==
X-Received: by 2002:a17:902:6901:b0:149:4e89:2d45 with SMTP id j1-20020a170902690100b001494e892d45mr20951158plk.22.1643169049808;
        Tue, 25 Jan 2022 19:50:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g18sm325399pju.7.2022.01.25.19.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:50:49 -0800 (PST)
Message-ID: <5571e217-b850-6c50-468b-a226c328f41a@gmail.com>
Date:   Tue, 25 Jan 2022 19:50:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 13/16] net: dsa: qca8k: move page cache to driver
 priv
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-14-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-14-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> There can be multiple qca8k switch on the same system. Move the static
> qca8k_current_page to qca8k_priv and make it specific for each switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 47 +++++++++++++++++++++++------------------
>   drivers/net/dsa/qca8k.h |  9 ++++++++
>   2 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index e7bc0770bae9..c2f5414033d8 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -75,12 +75,6 @@ static const struct qca8k_mib_desc ar8327_mib[] = {
>   	MIB_DESC(1, 0xac, "TXUnicast"),
>   };
>   
> -/* The 32bit switch registers are accessed indirectly. To achieve this we need
> - * to set the page of the register. Track the last page that was set to reduce
> - * mdio writes
> - */
> -static u16 qca8k_current_page = 0xffff;
> -
>   static void
>   qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
>   {
> @@ -134,11 +128,11 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
>   }
>   
>   static int
> -qca8k_set_page(struct mii_bus *bus, u16 page)
> +qca8k_set_page(struct mii_bus *bus, u16 page, u16 *cached_page)
>   {

bus->priv is assigned a qca8k_priv pointer, so we can just de-reference 
it here from bus->priv and avoid changing a whole bunch of function 
signatures that are now getting both a qca8k_priv *and* a 
qca8k_mdio_cache set of pointers when you can just use back pointers to 
those.
-- 
Florian
