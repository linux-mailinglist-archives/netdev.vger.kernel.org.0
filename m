Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14801C6CAB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgEFJQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:16:48 -0400
Received: from mailgw2.beijerelectronics.com ([195.67.87.143]:52256 "EHLO
        mailgw2.beijerelectronics.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728385AbgEFJQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:16:47 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2020 05:16:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; d=neratec.com; s=beijerselectorforemail; c=relaxed/simple;
        q=dns/txt; i=@neratec.com; t=1588755702; x=1591347702;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3TUbOYVdwweZmFlQqQ31Wx0F8CjRIHblIgbJu8rAyTk=;
        b=iEMDzzAAIx8x5wwphDW8Ballr12SqcHHMHdoqCNWy5ttwrxgn6BEBYhjiRRCcxBX
        T4wMGcgq1yCvZB4fC8errKwO/gO4/c2MiXGuR0XHfblbv9FBf9GwMEQA5X8BrNrz
        CrUcuWm5KSkE9IbxjIH5i51626xfFAMao/cV++K7wMc=;
X-AuditID: c0a800e1-b41ff70000004d32-e5-5eb27cf63e0f
Received: from mail.beijerelectronics.com (Unknown_Domain [192.168.10.12])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by mailgw2.beijerelectronics.com (Symantec Messaging Gateway) with SMTP id 53.52.19762.6FC72BE5; Wed,  6 May 2020 11:01:42 +0200 (CEST)
Received: from [172.29.101.174] (172.29.101.174) by wsests-s0004.westermo.com
 (192.168.10.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1847.3; Wed, 6 May
 2020 11:01:41 +0200
Subject: Re: [RFC net-next] net: phy: at803x: add cable diagnostics support
To:     Michael Walle <michael@walle.cc>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200503181517.4538-1-michael@walle.cc>
From:   Matthias May <matthias.may@neratec.com>
Message-ID: <00e8202e-1786-27f4-3bfc-accc5a01787d@neratec.com>
Date:   Wed, 6 May 2020 11:01:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503181517.4538-1-michael@walle.cc>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.29.101.174]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 wsests-s0004.westermo.com (192.168.10.12)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIcWRmVeSWpSXmKPExsVyYAUXj+63mk1xBo/uylicv3uI2WLO+RYW
        i1/vjrBbLHo/g9Xi8q45bBaHpu5ltHh7egO7xbEFYg4cHpevXWT22LLyJpPHzll32T127vjM
        5PF5k5zHgb0tbAFsUdw2SYklZcGZ6Xn6dgncGW/XNzMWvPSs2LnoEGMD402rLkZODgkBE4mW
        hk0sXYxcHEIC+5gk3v3+yw7hfGSUmLjgGwtIlbCAt8TxZeeYQGwRgQSJXS2TwYqYBY4yStxc
        f5Gxi5EDqMNEYsmSepAaNgFdiceNjxhBbF4BO4kpC26A9bIIqEj0H7vIDGKLCkRIfD54hA2i
        RlDi5MwnLCBjOAVMJVYdjwAxmQU0Jdbv0gepYBaQl9j+dg4zhC0ucevJfLCJQgKqEh0HDjOD
        lEsIKEm87eOHeCtX4tqZ5+wTGIVnIZk/C2HoLCRDZyEZuoCRZRWjbG5iZk56uZFeUmpmVmpR
        ak5qcklRfl5mcrFecn7uJkZwjDE83MG4uf2t3iFGJg7GQ4zeHExKorwdCZvihPiS8lMqMxKL
        M+KLSnNSi5VEeDXKgcK8cOGk0pxsJSler2qgqDBcNC+1vDgntQSYKg4xSnAwA7Xx/NgI1JaS
        WFmVWpQPMewQozQHi5I478T2VXFCAumJJanZqakFqUUw2RAODiUJ3ltVQJMFi1LTUyvSMnNK
        YNJAfVyRQBkBZBmwY2R5Xd6tixMSQ5ZAdg8TByfIUVxSIsWpeSmpRYmlJUBvAFNXfDEweR1i
        9ODgAbr3B8hDvMUFiblAUaiVwrzdpUBRHpgo2DpJ3oMgpUIwQYRVpxiTOW5vWLKIWYglLz8v
        VUqct34BMBAEQCozSvPgXpES41W0BBrBjyQBMlpKhjcrFCguiiSOMB2U19bIpq57xejKwQh0
        WlENyGnAnIhwrxDv/TKgIDdUEOxcCV5xcIBCxRDmvQJ6nAnoca1/60AeL0ksQfY4h+BGkMeh
        olCPs4EEhWCCCKOkGpj86m8L6P+fy2TSOfl9/9ajayeqtTlurehy/3VFZontoV3fyqQ3R7HX
        fwiXqD/tNNlFbY/+TrWY3IULe6V9+l7Xz4pZsU281Pt99cZPcbFdKf7Jl5muaZX9MlBx3LNB
        zZbB8EjilxPM6565PgtNmlnXY7/v0qf90Tt2/dnzhNG+5kTlU5vt4vdb9F+fyJ2057mlhegz
        T5O/rEeXHVH7vEU2SPWd4aKHQQEt89ezh96cOOXDxA/niyWbHsat3uab8lb7sPKLsjsPcyxS
        uEKey7IJun/8tDFzU8cUhYAFiU06DIIa7R3O29jdstZ3l7w8Ok2i5vJy6w8+kZmBGzZW7OmM
        lzwg3vDnuVsdl7DTRwklluKMREMt5qLiRAA6Nd6AJAUAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2020 20:15, Michael Walle wrote:
> The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
> driver support is straightforward, so lets add it.
>
> The PHY just do one pair at a time, so we have to start the test four
> times. The cable_test_get_status() can block and therefore we can just
> busy polling the test completion and continue with the next pair until
> we are done.
> The time delta counter seems to run with 125MHz which just gives us a
> resolution of about 82.4cm per tick.
>
> This was tested with a 100m ethernet cable, a 1m cable and a broken
> 1m cable where pair 3 was shorted and pair 4 were open. Leaving the
> 100m cable unconnected resulted in a measured fault distance of about
> 114m. For the short cable the result the measured distance is either
> 82cm or 1.64m.
>
> If the cable is connected to an active peer, the results might be
> inconclusive if there are broken cables. I guess this is because
> the remote PHY will disturb the measurement. Using an intact ethernet
> cable the restart of the auto negotiation seem to cause the remote PHY
> to stop sending distrubance signals.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> This is an RFC because the patch requires Andrew's cable test support:
> https://lore.kernel.org/netdev/20200425180621.1140452-1-andrew@lunn.ch/
>
>  drivers/net/phy/at803x.c | 167 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 167 insertions(+)
>
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 76eb5a77fc5c..978f1b2fb931 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -18,6 +18,8 @@
>  #include <linux/regulator/of_regulator.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/ethtool_netlink.h>
> +#include <uapi/linux/ethtool_netlink.h>
>  #include <dt-bindings/net/qca-ar803x.h>
>  
>  #define AT803X_SPECIFIC_STATUS			0x11
> @@ -46,6 +48,16 @@
>  #define AT803X_SMART_SPEED_ENABLE		BIT(5)
>  #define AT803X_SMART_SPEED_RETRY_LIMIT_MASK	GENMASK(4, 2)
>  #define AT803X_SMART_SPEED_BYPASS_TIMER		BIT(1)
> +#define AT803X_CDT				0x16
> +#define AT803X_CDT_MDI_PAIR_MASK		GENMASK(9, 8)
> +#define AT803X_CDT_ENABLE_TEST			BIT(0)
> +#define AT803X_CDT_STATUS			0x1c
> +#define AT803X_CDT_STATUS_STAT_NORMAL		0
> +#define AT803X_CDT_STATUS_STAT_SHORT		1
> +#define AT803X_CDT_STATUS_STAT_OPEN		2
> +#define AT803X_CDT_STATUS_STAT_FAIL		3
> +#define AT803X_CDT_STATUS_STAT_MASK		GENMASK(9, 8)
> +#define AT803X_CDT_STATUS_DELTA_TIME_MASK	GENMASK(7, 0)
>  #define AT803X_LED_CONTROL			0x18
>  
>  #define AT803X_DEVICE_ADDR			0x03
> @@ -110,6 +122,8 @@
>  #define AT803X_MIN_DOWNSHIFT 2
>  #define AT803X_MAX_DOWNSHIFT 9
>  
> +#define AT803X_CDT_DELAY_MS 1500
> +
>  #define ATH9331_PHY_ID 0x004dd041
>  #define ATH8030_PHY_ID 0x004dd076
>  #define ATH8031_PHY_ID 0x004dd074
> @@ -129,6 +143,7 @@ struct at803x_priv {
>  	struct regulator_dev *vddio_rdev;
>  	struct regulator_dev *vddh_rdev;
>  	struct regulator *vddio;
> +	unsigned long cdt_start;
>  };
>  
>  struct at803x_context {
> @@ -794,11 +809,158 @@ static int at803x_set_tunable(struct phy_device *phydev,
>  	}
>  }
>  
> +static int at803x_cdt_test_result(u16 status)
> +{
> +	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
> +	case AT803X_CDT_STATUS_STAT_NORMAL:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	case AT803X_CDT_STATUS_STAT_SHORT:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
> +	case AT803X_CDT_STATUS_STAT_OPEN:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> +	case AT803X_CDT_STATUS_STAT_FAIL:
> +	default:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
> +	}
> +}
> +
> +static bool at803x_cdt_fault_length_valid(u16 status)
> +{
> +	switch (FIELD_GET(AT803X_CDT_STATUS_STAT_MASK, status)) {
> +	case AT803X_CDT_STATUS_STAT_OPEN:
> +	case AT803X_CDT_STATUS_STAT_SHORT:
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static int at803x_cdt_fault_length(u16 status)
> +{
> +	int dt;
> +
> +	/* According to the datasheet the distance to the fault is
> +	 * DELTA_TIME * 0.824 meters.
> +	 *
> +	 * The author suspect the correct formula is:
> +	 *
> +	 *   fault_distance = DELTA_TIME * (c * VF) / 125MHz / 2
> +	 *
> +	 * where c is the speed of light, VF is the velocity factor of
> +	 * the twisted pair cable, 125MHz the counter frequency and
> +	 * we need to divide by 2 because the hardware will measure the
> +	 * round trip time to the fault and back to the PHY.
> +	 *
> +	 * With a VF of 0.69 we get the factor 0.824 mentioned in the
> +	 * datasheet.
> +	 */
> +	dt = FIELD_GET(AT803X_CDT_STATUS_DELTA_TIME_MASK, status);
> +
> +	return (dt * 824) / 10;
> +}
> +
> +static int at803x_cdt_start(struct phy_device *phydev, int pair)
> +{
> +	u16 cdt;
> +
> +	cdt = FIELD_PREP(AT803X_CDT_MDI_PAIR_MASK, pair) |
> +	      AT803X_CDT_ENABLE_TEST;
> +
> +	return phy_write(phydev, AT803X_CDT, cdt);
> +}
> +
> +static int at803x_cdt_wait_for_completion(struct phy_device *phydev)
> +{
> +	int val, ret;
> +
> +	/* One test run takes about 25ms */
> +	ret = phy_read_poll_timeout(phydev, AT803X_CDT, val,
> +				    !(val & AT803X_CDT_ENABLE_TEST),
> +				    30000, 100000, true);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int at803x_cable_test_get_status(struct phy_device *phydev,
> +					bool *finished)
> +{
> +	struct at803x_priv *priv = phydev->priv;
> +	static const int ethtool_pair[] = {
> +		ETHTOOL_A_CABLE_PAIR_0, ETHTOOL_A_CABLE_PAIR_1,
> +		ETHTOOL_A_CABLE_PAIR_2, ETHTOOL_A_CABLE_PAIR_3};
> +	int pair, val, ret;
> +	unsigned int delay_ms;
> +
> +	*finished = false;
> +
> +	if (priv->cdt_start) {
> +		delay_ms = AT803X_CDT_DELAY_MS;
> +		delay_ms -= jiffies_delta_to_msecs(jiffies - priv->cdt_start);
> +		if (delay_ms > 0)
> +			msleep(delay_ms);
> +	}
> +
> +	for (pair = 0; pair < 4; pair++) {
> +		ret = at803x_cdt_start(phydev, pair);
> +		if (ret)
> +			return ret;
> +
> +		ret = at803x_cdt_wait_for_completion(phydev);
> +		if (ret)
> +			return ret;
> +
> +		val = phy_read(phydev, AT803X_CDT_STATUS);
> +		if (val < 0)
> +			return val;
> +
> +		ethnl_cable_test_result(phydev, ethtool_pair[pair],
> +					at803x_cdt_test_result(val));
> +
> +		if (at803x_cdt_fault_length_valid(val))
> +			continue;
> +
> +		ethnl_cable_test_fault_length(phydev, ethtool_pair[pair],
> +					      at803x_cdt_fault_length(val));
> +	}
> +
> +	*finished = true;
> +
> +	return 0;
> +}
> +
> +static int at803x_cable_test_start(struct phy_device *phydev)
> +{
> +	struct at803x_priv *priv = phydev->priv;
> +	int bmsr, ret;
> +
> +	/* According to the datasheet the CDT can be performed when
> +	 * there is no link partner or when the link partner is
> +	 * auto-negotiating. Thus restart the AN before starting the
> +	 * test. Manual tests have shown, that the we have to wait
> +	 * between 1s and 3s after restarting the AN to have reliable
> +	 * results.
> +	 */
> +	bmsr = phy_read(phydev, MII_BMSR);
> +	if (bmsr < 0)
> +		return bmsr;
> +
> +	if (bmsr & BMSR_LSTATUS) {
> +		ret = genphy_restart_aneg(phydev);
> +		if (ret)
> +			return ret;
> +		priv->cdt_start = jiffies;
> +	} else {
> +		priv->cdt_start = 0;
> +	}
> +
> +	return 0;
> +}
> +
>  static struct phy_driver at803x_driver[] = {
>  {
>  	/* Qualcomm Atheros AR8035 */
>  	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
>  	.name			= "Qualcomm Atheros AR8035",
> +	.flags			= PHY_POLL_CABLE_TEST,
>  	.probe			= at803x_probe,
>  	.remove			= at803x_remove,
>  	.config_init		= at803x_config_init,
> @@ -813,6 +975,8 @@ static struct phy_driver at803x_driver[] = {
>  	.config_intr		= at803x_config_intr,
>  	.get_tunable		= at803x_get_tunable,
>  	.set_tunable		= at803x_set_tunable,
> +	.cable_test_start	= at803x_cable_test_start,
> +	.cable_test_get_status	= at803x_cable_test_get_status,
>  }, {
>  	/* Qualcomm Atheros AR8030 */
>  	.phy_id			= ATH8030_PHY_ID,
> @@ -833,6 +997,7 @@ static struct phy_driver at803x_driver[] = {
>  	/* Qualcomm Atheros AR8031/AR8033 */
>  	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
>  	.name			= "Qualcomm Atheros AR8031/AR8033",
> +	.flags			= PHY_POLL_CABLE_TEST,
>  	.probe			= at803x_probe,
>  	.remove			= at803x_remove,
>  	.config_init		= at803x_config_init,
> @@ -848,6 +1013,8 @@ static struct phy_driver at803x_driver[] = {
>  	.config_intr		= &at803x_config_intr,
>  	.get_tunable		= at803x_get_tunable,
>  	.set_tunable		= at803x_set_tunable,
> +	.cable_test_start	= at803x_cable_test_start,
> +	.cable_test_get_status	= at803x_cable_test_get_status,
>  }, {
>  	/* Qualcomm Atheros AR8032 */
>  	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),

Hi
I've worked with this PHY quite often and we've hacked together some support for the CDT in uboot.

Have you done any tests with the cable on the other side being plugged in?

With the cable being plugged in, we something (1 out of 10 or so) observed that the test returns with a failure.
--> AT803X_CDT_STATUS_STAT_FAIL in AT803X_CDT_STATUS

Often you get the correct result if you simply try again. Sometimes however it gets into a "stuck" state where it just
returns FAIL for ~3~10 seconds. After some that it seems to recover and gets the correct result again.

BR
Matthias

