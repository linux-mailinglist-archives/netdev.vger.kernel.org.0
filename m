Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263C943007E
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 08:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhJPGGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 02:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbhJPGGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 02:06:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2F8C061570;
        Fri, 15 Oct 2021 23:04:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so10813745pjc.3;
        Fri, 15 Oct 2021 23:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=R0JJa/1ThjkR3O7SnjHvGj4ygcnOg0zcj4qAUlh2uGI=;
        b=l8Guiw+W2G9r9hNBrydTSd8I1bKlmqPXnlaq2gx6ivmnBQCdCqSDVYJMnsjkJ3BamF
         ew+ykctB7JYvuge5jv5nyWcK5PmHV4BN6m00m3x4ZYQRe9uupWkv0YsmGUfNPRCcsH1i
         56odw4Wyea1eRMs9ZCzhXg28jzT9fgxXoEl7OnQFn+PD6zqaRVUInjpOBa6MYINdWyfQ
         W+WgM8rGCrXSPcwY9R1l+vDiBC5NppRCacT1VCN4puVehh4pW0Rp17pwjIpF045jVH74
         6K/iSUMBzSZ/1gFfJ7kQTMQBg0FGZmpzHHcPXKUWQgrAc+8Yg2ei1yHCPonnCmRjsi46
         Eapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=R0JJa/1ThjkR3O7SnjHvGj4ygcnOg0zcj4qAUlh2uGI=;
        b=cvtd3qa72vwvD/iiOPp/mlrI6S6sf9YUGccbZmV50eh8B1N+i+IOL69iyElLEjpZ/0
         6AhhuHEZaTR93QqqlQauuP6L+0MWfaf3KpHP1XD94S83V0BVmHkYonhV0UyDaRO38AkR
         Jk4N3ig9uHESz6f8SWtpPvSOTGSBqQGwxhh1MKolwNi+DWLI+3cRgeSoGT+jdadmq4hK
         wYDGBu/IfhmPZ4Q8HaUKd4rZQL1tA+tEgHVxSOgutZ/sl253XWUpiVNOLoQpBJFNofnj
         rzExsSPxLSPOLfIkNgsTWZ24wxAISdsGfnm1zapUBHoIZtY6NsufAs+iZpoAF3VZSCeg
         py7Q==
X-Gm-Message-State: AOAM532e1pYTZm9FZVBX852+cIWg7RG0d+FWnXVzuPhEZ6B7pHWEFHqb
        l2ej6kc4ptrWjbI6j7sP817DCCDGMcheFvkC
X-Google-Smtp-Source: ABdhPJy8ZZW4bMd65QW8xhlffCBlBDgJlIYI1Puxrb+NTQ+P2ilsA1qTeD2MgXzhG3hVvhha7PgwYg==
X-Received: by 2002:a17:903:2451:b0:13e:f1ef:d819 with SMTP id l17-20020a170903245100b0013ef1efd819mr14982949pls.85.1634364279975;
        Fri, 15 Oct 2021 23:04:39 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id d71sm2581069pga.67.2021.10.15.23.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 23:04:39 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 5/7] net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
Date:   Sat, 16 Oct 2021 14:04:29 +0800
Message-Id: <20211016060429.783447-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015171030.2713493-6-alvin@pqrs.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk> <20211015171030.2713493-6-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 07:10:26PM +0200, Alvin Šipraga wrote:
> +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	__be16 *tag;
> +
> +	/* Pad out so the (stripped) packet is at least 64 bytes long
> +	 * (including FCS), otherwise the switch will drop the packet.
> +	 * Then we need an additional 8 bytes for the Realtek tag.
> +	 */
> +	if (unlikely(__skb_put_padto(skb, ETH_ZLEN + RTL8_4_TAG_LEN, false)))
> +		return NULL;

Is this still required if you set rtl8365mb_cpu_rxlen to 64 bytes already?

> +
> +	skb_push(skb, RTL8_4_TAG_LEN);
> +
