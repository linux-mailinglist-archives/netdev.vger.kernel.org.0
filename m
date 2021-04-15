Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD336134C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhDOUHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbhDOUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:07:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969C1C061574;
        Thu, 15 Apr 2021 13:06:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n10so1567088plc.0;
        Thu, 15 Apr 2021 13:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hbkiMSiKidRorb2FvgVX++i0ISPpZNRMdVyX5qA+jH8=;
        b=S0VN6CrtAk7OyDcJBpc9jww/TfUKRygibF6cW467NPzSOoUwbikl6OPJ5heSYSlWLn
         PUwAaKWlDU646C8WnT4Cy2ctbmoFnrzcGOUf/m+rAEZKEyvYJYY1KJORboOmemQ5K7w8
         Q90GTyOPIY5dgD+shPX1nEkIuTJzNpvGsW0g35vkHvJLcyhsYEpUD83PzQ8rMlEpbVIg
         YsQKqCiPXxBTjBSw/ykgFWoZiZrQo+uEjNahi/pbEZ6FliGAdW3v2zgSamfUZHI1c0KO
         l6UrWWHx+OmQ2pXFrSxJfefL7Z+1I4TTod7fYvj+eGSBjZFa5lY8mje/SMdRYqHLn6RC
         4Gxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hbkiMSiKidRorb2FvgVX++i0ISPpZNRMdVyX5qA+jH8=;
        b=nuvLva5wJRpjXFxMrhQ0uxsapA3gyRy15bA+vGgEm437f4UAGPeXbhmvBzBHInkxgR
         DzMaWCr2nXRfdupYlkWu63sVf3NDyzehH1OzA5iDY/e6JklBcZSDxsEbO05EdUFq7GT6
         3xxpcHy5RxBUdLmFjCM6L9D9kpbfm23z4uUzuAXKUURIZYT/Wi6NOH4cDVKwNdlXFheM
         e4813J19LL6FjwwW4D3XNV3gZfBYcwb29qf6yLhFD+knxNbFnJiuG/UToJ6u5VRe1un1
         Umbpy5vKC9ZPwuDnj2d8CRtYOblUZpyMJEABtgoR/WSEZaNqr/bQrT4foALyGIiJT+f4
         Xp0Q==
X-Gm-Message-State: AOAM530sbKvmh2BSMWQBMtSMviuX/rGP2twCtU5aJlV6MLsH1irco0ls
        ZiXp58t1gj2zvDgo5EPVVdU=
X-Google-Smtp-Source: ABdhPJxY/0xR0eDSiqfYHIhgyTp3GsDZolQqbtNxmu/LVayR3JSlItfY/ykJTqwPieOr4JaMHQJt9g==
X-Received: by 2002:a17:90a:bb86:: with SMTP id v6mr5828987pjr.37.1618517208079;
        Thu, 15 Apr 2021 13:06:48 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j26sm2803889pfn.47.2021.04.15.13.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 13:06:47 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] net: add generic selftest support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
References: <20210415130738.19603-1-o.rempel@pengutronix.de>
 <20210415130738.19603-5-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <347139c5-d7be-04c0-8857-3bb4891522cf@gmail.com>
Date:   Thu, 15 Apr 2021 13:06:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415130738.19603-5-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 6:07 AM, Oleksij Rempel wrote:
> Port some parts of the stmmac selftest and reuse it as basic generic selftest
> library. This patch was tested with following combinations:
> - iMX6DL FEC -> AT8035
> - iMX6DL FEC -> SJA1105Q switch -> KSZ8081
> - iMX6DL FEC -> SJA1105Q switch -> KSZ9031
> - AR9331 ag71xx -> AR9331 PHY
> - AR9331 ag71xx -> AR9331 switch -> AR9331 PHY
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

[snip]

> +
> +struct net_packet_attrs {
> +	unsigned char *src;
> +	unsigned char *dst;
> +	u32 ip_src;
> +	u32 ip_dst;
> +	int tcp;

This can be an u8 and named proto maybe?

> +	int sport;
> +	int dport;

These two can be u16

> +	int timeout;
> +	int size;
> +	int max_size;
> +	u8 id;
> +	u16 queue_mapping;
> +};

[snip]

> +static const struct net_test {
> +	char name[ETH_GSTRING_LEN];
> +	int (*fn)(struct net_device *ndev);
> +} net_selftests[] = {
> +	{
> +		.name = "PHY Loopback, UDP          ",

This should be "PHY internal loopback, UDP"

> +		.fn = net_test_phy_loopback_udp,
> +	}, {
> +		.name = "PHY Loopback, TCP          ",
> +		.fn = net_test_phy_loopback_tcp,

and "PHY internal loopback, TCP"

to make it clear that the loopback is internal, as opposed to external.
Or if you prefer to use the line-side or MAC-side that works too.

> +	},
> +};
> +
> +void net_selftest(struct net_device *ndev, struct ethtool_test *etest, u64 *buf)
> +{
> +	int count = net_selftest_get_count();
> +	int i;
> +
> +	memset(buf, 0, sizeof(*buf) * count);
> +	net_test_next_id = 0;
> +
> +	if (etest->flags != ETH_TEST_FL_OFFLINE) {
> +		netdev_err(ndev, "Only offline tests are supported\n");
> +		etest->flags |= ETH_TEST_FL_FAILED;
> +		return;
> +	} else if (!netif_carrier_ok(ndev)) {
> +		netdev_err(ndev, "You need valid Link to execute tests\n");
> +		etest->flags |= ETH_TEST_FL_FAILED;
> +		return;
> +	}
> +
> +	if (!ndev->phydev)
> +		return;

Can you move that as the first test and return -EOPNOTSUPP instead?

> +
> +	/* PHY loopback tests should be combined to avoid delays on each PHY
> +	 * reconfiguration
> +	 */
> +	phy_loopback(ndev->phydev, true);
> +
> +	/* give PHYs some time to establish the loopback link */
> +	msleep(100);

Cannot you poll for LSTATUS instead?

> +
> +	for (i = 0; i < count; i++) {
> +		buf[i] = net_selftests[i].fn(ndev);
> +		if (buf[i] && (buf[i] != -EOPNOTSUPP))
> +			etest->flags |= ETH_TEST_FL_FAILED;
> +	}
> +
> +	phy_loopback(ndev->phydev, false);

Can you propagate the return value here?

As spotted by the test robot please export all of these symbols as
EXPORT_SYMBOL_GPL().
-- 
Florian
