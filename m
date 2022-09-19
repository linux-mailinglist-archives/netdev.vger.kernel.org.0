Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3F5BC9CB
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiISKsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiISKsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:48:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED6E2B61D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:36:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaE8d-0008WT-Uw; Mon, 19 Sep 2022 12:36:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1318:547e:856d:5888])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AAC0CE6335;
        Mon, 19 Sep 2022 10:36:29 +0000 (UTC)
Date:   Mon, 19 Sep 2022 12:36:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220919103621.ckcvjuxarpskm4ro@pengutronix.de>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
 <20220914233944.598298-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6lstf7uqibh6a4ff"
Content-Disposition: inline
In-Reply-To: <20220914233944.598298-3-matej.vasilevski@seznam.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6lstf7uqibh6a4ff
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.09.2022 01:39:43, Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts-clk" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.

Looks quite good now. Thanks for your work! Comments inline.

regards,
Marc

>=20
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  drivers/net/can/ctucanfd/Makefile             |   2 +-
>  drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
>  drivers/net/can/ctucanfd/ctucanfd_base.c      | 239 ++++++++++++++++--
>  drivers/net/can/ctucanfd/ctucanfd_pci.c       |   5 +-
>  drivers/net/can/ctucanfd/ctucanfd_platform.c  |   5 +-
>  drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  70 +++++
>  6 files changed, 318 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c
>=20
> diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd=
/Makefile
> index 8078f1f2c30f..a36e66f2cea7 100644
> --- a/drivers/net/can/ctucanfd/Makefile
> +++ b/drivers/net/can/ctucanfd/Makefile
> @@ -4,7 +4,7 @@
>  #
> =20
>  obj-$(CONFIG_CAN_CTUCANFD) :=3D ctucanfd.o
> -ctucanfd-y :=3D ctucanfd_base.o
> +ctucanfd-y :=3D ctucanfd_base.o ctucanfd_timestamp.o
> =20
>  obj-$(CONFIG_CAN_CTUCANFD_PCI) +=3D ctucanfd_pci.o
>  obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) +=3D ctucanfd_platform.o
> diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucan=
fd/ctucanfd.h
> index 0e9904f6a05d..b3ee583234b0 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd.h
> +++ b/drivers/net/can/ctucanfd/ctucanfd.h
> @@ -23,6 +23,10 @@
>  #include <linux/netdevice.h>
>  #include <linux/can/dev.h>
>  #include <linux/list.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>
> +
> +#define CTUCANFD_MAX_WORK_DELAY_SEC 3600U
> =20
>  enum ctu_can_fd_can_registers;
> =20
> @@ -51,6 +55,15 @@ struct ctucan_priv {
>  	u32 rxfrm_first_word;
> =20
>  	struct list_head peers_on_pdev;
> +
> +	struct cyclecounter cc;
> +	struct timecounter tc;
> +	spinlock_t tc_lock; /* spinlock to guard access tc->cycle_last */
> +	struct delayed_work timestamp;
> +	struct clk *timestamp_clk;
> +	unsigned long work_delay_jiffies;
> +	bool timestamp_enabled;
> +	bool timestamp_possible;
>  };
> =20
>  /**
> @@ -78,5 +91,12 @@ int ctucan_probe_common(struct device *dev, void __iom=
em *addr,
> =20
>  int ctucan_suspend(struct device *dev) __maybe_unused;
>  int ctucan_resume(struct device *dev) __maybe_unused;
> +int ctucan_runtime_resume(struct device *dev) __maybe_unused;
> +int ctucan_runtime_suspend(struct device *dev) __maybe_unused;

These functions are exported, so they are always "used".

> +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
> +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *=
skb, u64 timestamp);
> +void ctucan_timestamp_init(struct ctucan_priv *priv);
> +void ctucan_timestamp_stop(struct ctucan_priv *priv);
>  #endif /*__CTUCANFD__*/
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/c=
tucanfd/ctucanfd_base.c
> index 3c18d028bd8c..ba1a27c62ff1 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> @@ -18,6 +18,7 @@
>   ***********************************************************************=
*******/
> =20
>  #include <linux/clk.h>
> +#include <linux/clocksource.h>
>  #include <linux/errno.h>
>  #include <linux/ethtool.h>
>  #include <linux/init.h>
> @@ -25,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
>  #include <linux/string.h>
> @@ -148,6 +150,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv =
*priv, enum ctu_can_fd_can_r
>  	priv->write_reg(priv, buf_base + offset, val);
>  }
> =20
> +static inline u64 ctucan_concat_tstamp(u32 high, u32 low)
> +{
> +	return ((u64)high << 32) | ((u64)low);
> +}
> +
> +u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
> +{
> +	u32 ts_low;
> +	u32 ts_high;
> +	u32 ts_high2;
> +
> +	ts_high =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +	ts_low =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
> +	ts_high2 =3D ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
> +
> +	if (ts_high2 !=3D ts_high)
> +		ts_low =3D priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
> +
> +	return ctucan_concat_tstamp(ts_high2, ts_low) & priv->cc.mask;

I think you don't need to apply the mask. The tc will take care of this.

> +}
> +
>  #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read=
32(priv, CTUCANFD_STATUS)))
>  #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read3=
2(priv, CTUCANFD_MODE)))
> =20
> @@ -640,12 +663,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff=
 *skb, struct net_device *nde
>   * @priv:	Pointer to CTU CAN FD's private data
>   * @cf:		Pointer to CAN frame struct
>   * @ffw:	Previously read frame format word
> + * @skb:	Pointer to buffer to store timestamp
>   *
>   * Note: Frame format word must be read separately and provided in 'ffw'.
>   */
> -static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf, u32 ffw)
> +static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_=
frame *cf,
> +				 u32 ffw, u64 *timestamp)
>  {
>  	u32 idw;
> +	u32 tstamp_high;
> +	u32 tstamp_low;
>  	unsigned int i;
>  	unsigned int wc;
>  	unsigned int len;
> @@ -682,9 +709,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv =
*priv, struct canfd_frame *c
>  	if (unlikely(len > wc * 4))
>  		len =3D wc * 4;
> =20
> -	/* Timestamp - Read and throw away */
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	/* Timestamp */
> +	tstamp_low =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	tstamp_high =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> +	*timestamp =3D ctucan_concat_tstamp(tstamp_high, tstamp_low) & priv->cc=
=2Emask;

same here

> =20
>  	/* Data */
>  	for (i =3D 0; i < len; i +=3D 4) {
> @@ -713,6 +741,7 @@ static int ctucan_rx(struct net_device *ndev)
>  	struct net_device_stats *stats =3D &ndev->stats;
>  	struct canfd_frame *cf;
>  	struct sk_buff *skb;
> +	u64 timestamp;
>  	u32 ffw;
> =20
>  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> @@ -736,7 +765,9 @@ static int ctucan_rx(struct net_device *ndev)
>  		return 0;
>  	}
> =20
> -	ctucan_read_rx_frame(priv, cf, ffw);
> +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> +	if (priv->timestamp_enabled)
> +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> =20
>  	stats->rx_bytes +=3D cf->len;
>  	stats->rx_packets++;
> @@ -906,6 +937,11 @@ static void ctucan_err_interrupt(struct net_device *=
ndev, u32 isr)
>  	if (skb) {
>  		stats->rx_packets++;
>  		stats->rx_bytes +=3D cf->can_dlc;
> +		if (priv->timestamp_enabled) {
> +			u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +			ctucan_skb_set_timestamp(priv, skb, tstamp);
> +		}
>  		netif_rx(skb);
>  	}
>  }
> @@ -951,6 +987,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, =
int quota)
>  			cf->data[1] |=3D CAN_ERR_CRTL_RX_OVERFLOW;
>  			stats->rx_packets++;
>  			stats->rx_bytes +=3D cf->can_dlc;
> +			if (priv->timestamp_enabled) {
> +				u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +				ctucan_skb_set_timestamp(priv, skb, tstamp);
> +			}
>  			netif_rx(skb);
>  		}
> =20
> @@ -1200,9 +1241,9 @@ static int ctucan_open(struct net_device *ndev)
>  	struct ctucan_priv *priv =3D netdev_priv(ndev);
>  	int ret;
> =20
> -	ret =3D pm_runtime_get_sync(priv->dev);
> +	ret =3D pm_runtime_resume_and_get(priv->dev);

Note, the semantics of pm_runtime_get_sync() and pm_runtime_get_sync() chan=
ged!

>  	if (ret < 0) {
> -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> +		netdev_err(ndev, "%s: pm_runtime_resume_and_get failed(%d)\n",
>  			   __func__, ret);
>  		pm_runtime_put_noidle(priv->dev);

=2E..you must not call pm_runtime_put_noidle() if
pm_runtime_resume_and_get() fails.

Maybe it's worth to move the runtime pm handling in a separate patch.

>  		return ret;
> @@ -1231,6 +1272,9 @@ static int ctucan_open(struct net_device *ndev)
>  		goto err_chip_start;
>  	}
> =20
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_init(priv);
> +
>  	netdev_info(ndev, "ctu_can_fd device registered\n");
>  	napi_enable(&priv->napi);
>  	netif_start_queue(ndev);
> @@ -1263,6 +1307,8 @@ static int ctucan_close(struct net_device *ndev)
>  	ctucan_chip_stop(ndev);
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_stop(priv);
> =20
>  	pm_runtime_put(priv->dev);
> =20
> @@ -1282,9 +1328,9 @@ static int ctucan_get_berr_counter(const struct net=
_device *ndev, struct can_ber
>  	struct ctucan_priv *priv =3D netdev_priv(ndev);
>  	int ret;
> =20
> -	ret =3D pm_runtime_get_sync(priv->dev);
> +	ret =3D pm_runtime_resume_and_get(priv->dev);

=2E..same here

>  	if (ret < 0) {
> -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n", __func__, ret);
> +		netdev_err(ndev, "%s: pm_runtime_resume_and_get failed(%d)\n", __func_=
_, ret);
>  		pm_runtime_put_noidle(priv->dev);

=2E.same here

>  		return ret;
>  	}
> @@ -1295,15 +1341,83 @@ static int ctucan_get_berr_counter(const struct n=
et_device *ndev, struct can_ber
>  	return 0;
>  }
> =20
> +static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(dev);
> +	struct hwtstamp_config cfg;
> +
> +	if (!priv->timestamp_possible)
> +		return -EOPNOTSUPP;
> +
> +	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
> +		return -EFAULT;
> +
> +	if (cfg.flags)
> +		return -EINVAL;

Do we have to add this check to the generic can_eth_ioctl_hwts()
function?

> +
> +	if (cfg.rx_filter =3D=3D HWTSTAMP_FILTER_NONE && cfg.tx_type =3D=3D HWT=
STAMP_TX_OFF) {
> +		priv->timestamp_enabled =3D false;
> +		return 0;
> +	} else if (cfg.rx_filter =3D=3D HWTSTAMP_FILTER_ALL && cfg.tx_type =3D=
=3D HWTSTAMP_TX_ON) {

What happens if the user only configures RX _or_ TX timestamping?

> +		priv->timestamp_enabled =3D true;
> +		return 0;
> +	} else {
> +		return -ERANGE;
> +	}

nitpick: please remove else, as they are not needed after the return.
> +}
> +
> +static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(dev);
> +	struct hwtstamp_config cfg;
> +
> +	if (!priv->timestamp_possible)
> +		return -EOPNOTSUPP;
> +
> +	cfg.flags =3D 0;
> +	cfg.tx_type =3D priv->timestamp_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_=
OFF;
> +	cfg.rx_filter =3D priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL : HWTST=
AMP_FILTER_NONE;
> +
> +	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;

nitpick: please don't use the '?' operator.

> +}
> +
> +static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int c=
md)
> +{
> +	switch (cmd) {
> +	case SIOCSHWTSTAMP:
> +		return ctucan_hwtstamp_set(dev, ifr);
> +	case SIOCGHWTSTAMP:
> +		return ctucan_hwtstamp_get(dev, ifr);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int ctucan_ethtool_get_ts_info(struct net_device *ndev,
> +				      struct ethtool_ts_info *info)
> +{
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +	if (!priv->timestamp_possible)
> +		return ethtool_op_get_ts_info(ndev, info);
> +
> +	can_ethtool_op_get_ts_info_hwts(ndev, info);
> +	info->rx_filters |=3D BIT(HWTSTAMP_FILTER_NONE);
> +	info->tx_types |=3D BIT(HWTSTAMP_TX_OFF);
> +
> +	return 0;
> +}
> +
>  static const struct net_device_ops ctucan_netdev_ops =3D {
>  	.ndo_open	=3D ctucan_open,
>  	.ndo_stop	=3D ctucan_close,
>  	.ndo_start_xmit	=3D ctucan_start_xmit,
>  	.ndo_change_mtu	=3D can_change_mtu,
> +	.ndo_eth_ioctl	=3D ctucan_ioctl,
>  };
> =20
>  static const struct ethtool_ops ctucan_ethtool_ops =3D {
> -	.get_ts_info =3D ethtool_op_get_ts_info,
> +	.get_ts_info =3D ctucan_ethtool_get_ts_info,
>  };
> =20
>  int ctucan_suspend(struct device *dev)
> @@ -1338,12 +1452,42 @@ int ctucan_resume(struct device *dev)
>  }
>  EXPORT_SYMBOL(ctucan_resume);
> =20
> +int ctucan_runtime_suspend(struct device *dev)
> +{
> +	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +
> +	if (!IS_ERR_OR_NULL(priv->timestamp_clk))
> +		clk_disable_unprepare(priv->timestamp_clk);

The common clock framework handles NULL pointers, so remove the
IS_ERR_OR_NULL().

> +	return 0;
> +}
> +EXPORT_SYMBOL(ctucan_runtime_suspend);
> +
> +int ctucan_runtime_resume(struct device *dev)
> +{
> +	struct net_device *ndev =3D dev_get_drvdata(dev);
> +	struct ctucan_priv *priv =3D netdev_priv(ndev);
> +	int ret;
> +
> +	if (!IS_ERR_OR_NULL(priv->timestamp_clk)) {

=2E..same here

> +		ret =3D clk_prepare_enable(priv->timestamp_clk);
> +		if (ret) {
> +			dev_err(dev, "Cannot enable timestamping clock: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(ctucan_runtime_resume);
> +
>  int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,=
 unsigned int ntxbufs,
>  			unsigned long can_clk_rate, int pm_enable_call,
>  			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
>  {
>  	struct ctucan_priv *priv;
>  	struct net_device *ndev;
> +	u32 timestamp_freq =3D 0;

nitpick: name this _rate, similar to can_clk_rate.

> +	u32 timestamp_bit_size =3D 0;
>  	int ret;
> =20
>  	/* Create a CAN device instance */
> @@ -1373,6 +1517,7 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
>  					| CAN_CTRLMODE_FD_NON_ISO
>  					| CAN_CTRLMODE_ONE_SHOT;
>  	priv->mem_base =3D addr;
> +	priv->timestamp_possible =3D true;
> =20
>  	/* Get IRQ for the device */
>  	ndev->irq =3D irq;
> @@ -1386,27 +1531,39 @@ int ctucan_probe_common(struct device *dev, void =
__iomem *addr, int irq, unsigne
> =20
>  	/* Getting the can_clk info */
>  	if (!can_clk_rate) {
> -		priv->can_clk =3D devm_clk_get(dev, NULL);
> +		priv->can_clk =3D devm_clk_get_optional(dev, "core-clk");
> +		if (!priv->can_clk)
> +			/* For compatibility with (older) device trees without clock-names */
> +			priv->can_clk =3D devm_clk_get(dev, NULL);
>  		if (IS_ERR(priv->can_clk)) {
> -			dev_err(dev, "Device clock not found.\n");
> +			dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
>  			ret =3D PTR_ERR(priv->can_clk);
>  			goto err_free;
>  		}
>  		can_clk_rate =3D clk_get_rate(priv->can_clk);
>  	}
> =20
> +	/* If it's a platform device - get the timestamping clock */
> +	if (pm_enable_call) {

The variable pm_enable_call feels wrong. As PCI device automatically do
an automatic pm_runtime_enable(), better move the pm_runtime_enable() to
the platform device driver. But that's a separate patch.

Please don't wire more functionality to pm_enable_call. What about:
- if ctucan_probe_common() is called with can_clk_rate set, use it as the
  timestamp_freq, too.
- otherwise get the rate from the ts-clk, or core clock

> +		priv->timestamp_clk =3D devm_clk_get(dev, "ts-clk");
> +		if (IS_ERR(priv->timestamp_clk)) {
> +			/* Take the core clock instead */
> +			dev_info(dev, "Failed to get ts clk\nl");
                                                           ^^^

trailing 'l'

> +			priv->timestamp_clk =3D priv->can_clk;
> +		}
> +		clk_prepare_enable(priv->timestamp_clk);

Later in this function there is a call to pm_runtime_put(dev). Without
runtime PM the clock will not turned off. So you rely on runtime PM,
please adjust your Kconfig accordingly.

> +		timestamp_freq =3D clk_get_rate(priv->timestamp_clk);
> +	} else {
> +		/* PCI device: assume tstamp freq is equal to bus clk rate */
> +		timestamp_freq =3D can_clk_rate;
> +	}
> +
>  	priv->write_reg =3D ctucan_write32_le;
>  	priv->read_reg =3D ctucan_read32_le;
> =20
> +	pm_runtime_get_noresume(dev);

I think you're missing a pm_runtime_set_active() call here.

>  	if (pm_enable_call)
>  		pm_runtime_enable(dev);
> -	ret =3D pm_runtime_get_sync(dev);
> -	if (ret < 0) {
> -		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> -			   __func__, ret);
> -		pm_runtime_put_noidle(priv->dev);
> -		goto err_pmdisable;
> -	}
> =20
>  	/* Check for big-endianity and set according IO-accessors */
>  	if ((ctucan_read32(priv, CTUCANFD_DEVICE_ID) & 0xFFFF) !=3D CTUCANFD_ID=
) {
> @@ -1425,6 +1582,49 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
> =20
>  	priv->can.clock.freq =3D can_clk_rate;
> =20
> +	/* Obtain timestamping counter bit size */
> +	timestamp_bit_size =3D FIELD_GET(REG_ERR_CAPT_TS_BITS,
> +				       ctucan_read32(priv, CTUCANFD_ERR_CAPT));
> +
> +	/* The register value is actually bit_size - 1 */
> +	if (timestamp_bit_size) {
> +		timestamp_bit_size +=3D 1;
> +	} else {
> +		/* For 2.x versions of the IP core, we will assume 64-bit counter
> +		 * if there was a 0 in the register.
> +		 */
> +		u32 version_reg =3D ctucan_read32(priv, CTUCANFD_DEVICE_ID);
> +		u32 major =3D FIELD_GET(REG_DEVICE_ID_VER_MAJOR, version_reg);
> +
> +		if (major =3D=3D 2)
> +			timestamp_bit_size =3D 64;
> +		else
> +			priv->timestamp_possible =3D false;
> +	}
> +
> +	/* Setup conversion constants and work delay */
> +	priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> +	if (priv->timestamp_possible) {
> +		u64 max_cycles;
> +		u64 work_delay_ns;
> +		u32 maxsec =3D min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> +				   div_u64(priv->cc.mask, timestamp_freq));
> +
> +		priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> +				       timestamp_freq, NSEC_PER_SEC, maxsec);
> +
> +		/* shortened copy of clocks_calc_max_nsecs() */
> +		max_cycles =3D div_u64(ULLONG_MAX, priv->cc.mult);
> +		max_cycles =3D min(max_cycles, priv->cc.mask);
> +		work_delay_ns =3D clocksource_cyc2ns(max_cycles, priv->cc.mult,
> +						   priv->cc.shift) >> 1;
> +		priv->work_delay_jiffies =3D nsecs_to_jiffies(work_delay_ns);
> +
> +		if (priv->work_delay_jiffies =3D=3D 0)
> +			priv->timestamp_possible =3D false;
> +	}
> +
>  	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
> =20
>  	ret =3D register_candev(ndev);
> @@ -1442,7 +1642,6 @@ int ctucan_probe_common(struct device *dev, void __=
iomem *addr, int irq, unsigne
> =20
>  err_deviceoff:
>  	pm_runtime_put(priv->dev);
> -err_pmdisable:
>  	if (pm_enable_call)
>  		pm_runtime_disable(dev);
>  err_free:
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_pci.c b/drivers/net/can/ct=
ucanfd/ctucanfd_pci.c
> index 8f2956a8ae43..bdb7cf789776 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
> @@ -271,7 +271,10 @@ static void ctucan_pci_remove(struct pci_dev *pdev)
>  	kfree(bdata);
>  }
> =20
> -static SIMPLE_DEV_PM_OPS(ctucan_pci_pm_ops, ctucan_suspend, ctucan_resum=
e);
> +static const struct dev_pm_ops ctucan_pci_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
> +	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
> +};
> =20
>  static const struct pci_device_id ctucan_pci_tbl[] =3D {
>  	{PCI_DEVICE_DATA(TEDIA, CTUCAN_VER21,
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/c=
an/ctucanfd/ctucanfd_platform.c
> index 89d54c2151e1..1b2052aec2ab 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> @@ -104,7 +104,10 @@ static int ctucan_platform_remove(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20
> -static SIMPLE_DEV_PM_OPS(ctucan_platform_pm_ops, ctucan_suspend, ctucan_=
resume);
> +static const struct dev_pm_ops ctucan_platform_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
> +	SET_RUNTIME_PM_OPS(ctucan_runtime_suspend, ctucan_runtime_resume, NULL)
> +};
> =20
>  /* Match table for OF platform binding */
>  static const struct of_device_id ctucan_of_match[] =3D {
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/=
can/ctucanfd/ctucanfd_timestamp.c
> new file mode 100644
> index 000000000000..77e461d1962d
> --- /dev/null
> +++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/***********************************************************************=
********
> + *
> + * CTU CAN FD IP Core
> + *
> + * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE =
CTU
> + *
> + * Project advisors:
> + *     Jiri Novak <jnovak@fel.cvut.cz>
> + *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
> + *
> + * Department of Measurement         (http://meas.fel.cvut.cz/)
> + * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
> + * Czech Technical University        (http://www.cvut.cz/)
> + ***********************************************************************=
*******/
> +
> +#include "linux/spinlock.h"
> +#include <linux/bitops.h>
> +#include <linux/clocksource.h>
> +#include <linux/math64.h>
> +#include <linux/timecounter.h>
> +#include <linux/workqueue.h>
> +
> +#include "ctucanfd.h"
> +#include "ctucanfd_kregs.h"
> +
> +u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc)
> +{
> +	struct ctucan_priv *priv;

Please add a "lockdep_assert_held(&priv->tc_lock);" and compile your
code with lockdep enabled.

> +
> +	priv =3D container_of(cc, struct ctucan_priv, cc);
> +	return ctucan_read_timestamp_counter(priv);
> +}
> +
> +static void ctucan_timestamp_work(struct work_struct *work)
> +{
> +	struct delayed_work *delayed_work =3D to_delayed_work(work);
> +	struct ctucan_priv *priv =3D container_of(delayed_work, struct ctucan_p=
riv, timestamp);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->tc_lock, flags);
> +	timecounter_read(&priv->tc);
> +	spin_unlock_irqrestore(&priv->tc_lock, flags);
> +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> +}
> +
> +void ctucan_skb_set_timestamp(struct ctucan_priv *priv, struct sk_buff *=
skb, u64 timestamp)
> +{
> +	struct skb_shared_hwtstamps *hwtstamps =3D skb_hwtstamps(skb);
> +	u64 ns;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->tc_lock, flags);
> +	ns =3D timecounter_cyc2time(&priv->tc, timestamp);
> +	spin_unlock_irqrestore(&priv->tc_lock, flags);
> +	hwtstamps->hwtstamp =3D ns_to_ktime(ns);
> +}
> +
> +void ctucan_timestamp_init(struct ctucan_priv *priv)
> +{
> +	spin_lock_init(&priv->tc_lock);

please lock ->tc_lock during timecounter_init(), too. This will keep the
lockdep_assert_held() happy.

> +	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
> +	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
> +	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
> +}
> +
> +void ctucan_timestamp_stop(struct ctucan_priv *priv)
> +{
> +	cancel_delayed_work_sync(&priv->timestamp);
> +}
> --=20
> 2.25.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6lstf7uqibh6a4ff
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMoRiIACgkQrX5LkNig
011A0wf/VKeRirdcwSE+Hck4tl14Zcimwl5tOTx1I1u80A4dRe3IXIgaNIPbHztW
J6+28vCEZZkCDT6/7AOaA00RmfYs3qD28fdGDItrTdTaz5edSe4OAyo4YtalqNsZ
wf+wDm+mV5J6ANiXYscum9QkHa2lT08k+MTMKhym4OjofTLCt0SRs+0REK1705Sr
id6kn8dzJiHFxXJ6ZJHlkwcLWD1n1R0eYSp8fkDT1Ugjxdpmt/JOPOTrRHi+/IKs
V5L81FVW8cLtqQPm/P5waKXxPJAFB+w54AflQsnm1g5+RwU5gZrY4Fs87+wQ6HUu
k7mYCD6izx7RSIEdEUqezxwUdm2Rpw==
=Aa4d
-----END PGP SIGNATURE-----

--6lstf7uqibh6a4ff--
