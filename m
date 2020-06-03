Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D861ED214
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgFCO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCO3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:29:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAD0C08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 07:29:46 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so2602985wrc.7
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 07:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GHOI3hCq0wQbV5uWu698h1xL8vD8BAsADvtP/YAEZbY=;
        b=K3SjXSpb5L8l4YP9xtBId4+HzVpdbm6fhCiZ/5+kS5ESbrxo3dVjsqqPwtXM7X4bHk
         gT6D6Ox4RZjNjk9mD11ZHIF0TYsDYYS/VBM3kTr/TA0igf8xYMZWOluYylJh4EOaP7sY
         scfunH4GqH4dwKwcCan2OWfau1mLe6zjh9NTKYUf/SAHKAwY2MXHxEk1qMOiP0QH/ZHm
         FPIMx5+tj2BnzCQ2W0FAP/vLLYerOQ/TJa0aJTOu+BH71S395YnzjUCp6ioHpUmVkIjQ
         /ScputRXvPrmjTt6QNcXVPsBTWKgblPZ8EAiPj8RpqdSltoPoRfoco/wRW91Hm8peCMu
         UN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GHOI3hCq0wQbV5uWu698h1xL8vD8BAsADvtP/YAEZbY=;
        b=SMMFTHxbQsMyNTVKtp0o4GzUnREcsxP7axzH0JwFyc+yXy9Tkf+Lgi1ICbd1Mcxv0n
         +s6zxBR90XAzzYwgevIJdeuwQ73WH3IRf0MGynbCAz6FolIqSp8ipDkGN9jxhZnJSZ2E
         oNkBGpT3oKjy2m2PBUugkkjgYdxFzddUgrrphFtxReulT09Rg9g5P7/XM6ODutFdcj65
         dPPSMj4jOyQ8qR3/yGU+2abw/Kgv/j/+McmlwyTdiMvdld4Km1BKQX/n8kwi65uSyhzv
         ibdZJn3hkXzR4egeV0ZkuLEB949om5AV5A4djh5/DInYDcz+PW2i1RPiTrP2H3uVBnb/
         vFzw==
X-Gm-Message-State: AOAM533TflRCgQotpqKenIUwc0QL/dnBlVjjnxN8KIqDQGKl+rCOIz9l
        7aDNHp/1QBy700iqiPAeiElLTg==
X-Google-Smtp-Source: ABdhPJzdS2IsuE71otq0TIhWvAuDdtVc0MbnYqWh+BBsP1ENSHdsYb//XredkWAlgwzhoJd7cr+qDw==
X-Received: by 2002:a5d:604b:: with SMTP id j11mr31054657wrt.193.1591194585511;
        Wed, 03 Jun 2020 07:29:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o6sm3732960wrp.3.2020.06.03.07.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 07:29:44 -0700 (PDT)
Date:   Wed, 3 Jun 2020 16:29:44 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200603142944.GA5892@nanopsycho.orion>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528151245.7592-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 28, 2020 at 05:12:40PM CEST, vadym.kochan@plvision.eu wrote:

[...]

>+static int prestera_port_create(struct prestera_switch *sw, u32 id)
>+{
>+	struct prestera_port *port;
>+	struct net_device *dev;
>+	int err;
>+
>+	dev = alloc_etherdev(sizeof(*port));
>+	if (!dev)
>+		return -ENOMEM;
>+
>+	port = netdev_priv(dev);
>+
>+	port->dev = dev;
>+	port->id = id;
>+	port->sw = sw;
>+
>+	err = prestera_hw_port_info_get(port, &port->fp_id,
>+					&port->hw_id, &port->dev_id);
>+	if (err) {
>+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
>+		goto err_port_init;
>+	}
>+
>+	dev->features |= NETIF_F_NETNS_LOCAL;
>+	dev->netdev_ops = &netdev_ops;
>+
>+	netif_carrier_off(dev);

No need.
