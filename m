Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CFF6047F2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiJSNq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiJSNpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:45:55 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E707C1DED79;
        Wed, 19 Oct 2022 06:32:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sc25so39919322ejc.12;
        Wed, 19 Oct 2022 06:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZylPyPfQIWs4leHwvCITnpMHAMYHfcyaJCBhFssNed8=;
        b=dBWIamckSyKVgv12Q/0OqFY33+RIvM4HMSJN16dFJZX8IikQvOkStRNLracwBaVP12
         uQJ/IqiwiMhSS0YS9lQMDKaDuviA2A3K+4+ylNKri2m0sAQIA8ZDzU2m3uy86ipVRhy8
         /YydQb7S5Y/20bt/zHkRtZqD0CPmEqS8iz0G/bsMvnLSDr491LVmPc5Ti1XXloOcYPnH
         +PC2zabQq5D0v1h6HbnIFb2Zjghop1jw2YYXDJlJQY3hBI+QUB4pwIWAEHpAG0m9NRib
         aLGTFGPQl7ogTYbyWV2ZDZfKrxYxusZgC7ZaOqRgRL+kiFU5pHAzCzyBiJMRPqwYotvO
         mLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZylPyPfQIWs4leHwvCITnpMHAMYHfcyaJCBhFssNed8=;
        b=ZHux4EUgtntbN3Ovr/ft5DqAUYwaE1t3h5BubEl4OzWtg6swgL+82v8XcKK86fvqFa
         S4VHZc/8eW1c6Ee12TmwsxoohEhNEUOPnysSGRA2HVO2fDH5XIT+M8FrhlFesU6H5wbC
         HEc9xnEp0FK+/dj1Lu+HSp6JTIiMCZTsWzVkERhklWRyn4pDzZ+RCbQzmAWs00D5PDSU
         6bLxJWJ0TfHwhg6iz3brM5Z6/JBlmRZcgLtMZozXRCPz8OGBdo6g5pnyLwqIm0dZxku4
         MFVQ55NK+PfDo5gb9xHcNd5+WrAxQhh9GwmJwm3tm3jgKFexa5WjhvhqLVUNyUmMRlSu
         lx4w==
X-Gm-Message-State: ACrzQf1cmnDtZsGr7v4YtbP2GrBJe7zlobrJpjWwgdMaKiZgG98XTila
        y+9kjdvFZwC5fsqLpM2d8Ri/j6CgxpxUOw==
X-Google-Smtp-Source: AMsMyM7zrE4ffeBRiu7f7+dLtPmH9eCpTqaFaMVWJfm/EiDl/deGDKe0ejA0XS9H6hXQ6IfQffcrHw==
X-Received: by 2002:a17:907:3c81:b0:77a:327a:815f with SMTP id gl1-20020a1709073c8100b0077a327a815fmr6872518ejc.422.1666186301725;
        Wed, 19 Oct 2022 06:31:41 -0700 (PDT)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906768e00b0077a8fa8ba55sm8894792ejm.210.2022.10.19.06.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:31:41 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 1/2] net: usb: qmi_wwan: implement qmap uplink tx aggregation
Date:   Wed, 19 Oct 2022 15:25:02 +0200
Message-Id: <20221019132503.6783-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221019132503.6783-1-dnlplm@gmail.com>
References: <20221019132503.6783-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qmap uplink tx packets aggregation.

Bidirectional TCP throughput tests through iperf with low-cat
Thread-x based modems showed performance issues both in tx
and rx.

The Windows driver does not show this issue: inspecting USB
packets revealed that the only notable change is the driver
enabling tx packets aggregation.

Tx packets aggregation, by default disabled, requires configuring
the maximum number of aggregated packets and the maximum aggregated
size: this information is provided by the modem and available in
userspace through wda set data format response, so two new
sysfs files are created for driver configuration according
to those values.

This implementation is based on the cdc_ncm code developed by
Bjørn Mork.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 242 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 238 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 26c34a7c21bd..304f8126026d 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -54,6 +54,20 @@ struct qmi_wwan_state {
 	struct usb_interface *data;
 };
 
+struct qmi_wwan_priv {
+	struct sk_buff *qmimux_tx_curr_aggr_skb;
+	struct hrtimer qmimux_tx_timer;
+	struct tasklet_struct bh;
+	/* spinlock for tx packets aggregation */
+	spinlock_t qmimux_tx_mtx;
+	atomic_t stop;
+	u32 timer_interval;
+	u32 qmimux_tx_timer_pending;
+	u32 qmimux_tx_max_datagrams;
+	u32 qmimux_tx_max_size;
+	u32 qmimux_tx_current_datagrams_n;
+};
+
 enum qmi_wwan_flags {
 	QMI_WWAN_FLAG_RAWIP = 1 << 0,
 	QMI_WWAN_FLAG_MUX = 1 << 1,
@@ -94,24 +108,126 @@ static int qmimux_stop(struct net_device *dev)
 	return 0;
 }
 
+static void qmimux_tx_timeout_start(struct qmi_wwan_priv *priv)
+{
+	/* start timer, if not already started */
+	if (!(hrtimer_active(&priv->qmimux_tx_timer) || atomic_read(&priv->stop)))
+		hrtimer_start(&priv->qmimux_tx_timer,
+			      400UL * NSEC_PER_USEC,
+			      HRTIMER_MODE_REL);
+}
+
+static struct sk_buff *
+qmimux_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb,
+		     unsigned int *n, unsigned int *len)
+{
+	struct qmi_wwan_priv *priv = dev->driver_priv;
+	struct sk_buff *skb_current = NULL;
+
+	if (!priv->qmimux_tx_curr_aggr_skb) {
+		/* The incoming skb size should be less than max ul packet aggregated size
+		 * otherwise it is dropped.
+		 */
+		if (skb->len > priv->qmimux_tx_max_size) {
+			*n = 0;
+			goto exit_skb;
+		}
+
+		priv->qmimux_tx_curr_aggr_skb = alloc_skb(priv->qmimux_tx_max_size, GFP_ATOMIC);
+		if (!priv->qmimux_tx_curr_aggr_skb) {
+			/* If memory allocation fails we simply return the skb in input */
+			skb_current = skb;
+		} else {
+			priv->qmimux_tx_curr_aggr_skb->dev = dev->net;
+			priv->qmimux_tx_current_datagrams_n = 1;
+			skb_put_data(priv->qmimux_tx_curr_aggr_skb, skb->data, skb->len);
+			priv->qmimux_tx_timer_pending = 2;
+			dev_kfree_skb_any(skb);
+		}
+	} else {
+		/* Queue the incoming skb */
+		if (skb->len + priv->qmimux_tx_curr_aggr_skb->len > priv->qmimux_tx_max_size) {
+			/* Send the current skb and copy the incoming one in a new buffer */
+			skb_current = priv->qmimux_tx_curr_aggr_skb;
+			*n = priv->qmimux_tx_current_datagrams_n;
+			*len = skb_current->len - priv->qmimux_tx_current_datagrams_n * 4;
+			priv->qmimux_tx_curr_aggr_skb =
+					alloc_skb(priv->qmimux_tx_max_size, GFP_ATOMIC);
+			if (priv->qmimux_tx_curr_aggr_skb) {
+				priv->qmimux_tx_curr_aggr_skb->dev = dev->net;
+				skb_put_data(priv->qmimux_tx_curr_aggr_skb, skb->data, skb->len);
+				dev_kfree_skb_any(skb);
+				priv->qmimux_tx_current_datagrams_n = 1;
+				priv->qmimux_tx_timer_pending = 2;
+				/* Start the timer, since we already have something to send */
+				qmimux_tx_timeout_start(priv);
+			}
+		} else {
+			/* Copy to current skb */
+			skb_put_data(priv->qmimux_tx_curr_aggr_skb, skb->data, skb->len);
+			dev_kfree_skb_any(skb);
+			priv->qmimux_tx_current_datagrams_n++;
+			if (priv->qmimux_tx_current_datagrams_n == priv->qmimux_tx_max_datagrams) {
+				/* Maximum number of datagrams reached, send them */
+				skb_current = priv->qmimux_tx_curr_aggr_skb;
+				*n = priv->qmimux_tx_current_datagrams_n;
+				*len = skb_current->len - priv->qmimux_tx_current_datagrams_n * 4;
+				priv->qmimux_tx_curr_aggr_skb = NULL;
+			} else {
+				priv->qmimux_tx_timer_pending = 2;
+			}
+		}
+	}
+
+exit_skb:
+	if (!skb_current)
+		qmimux_tx_timeout_start(priv);
+
+	return skb_current;
+}
+
 static netdev_tx_t qmimux_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct qmimux_priv *priv = netdev_priv(dev);
+	struct qmi_wwan_priv *usbdev_priv;
 	unsigned int len = skb->len;
+	struct sk_buff *skb_current;
 	struct qmimux_hdr *hdr;
+	struct usbnet *usbdev;
+	unsigned int n = 1;
 	netdev_tx_t ret;
 
+	usbdev = netdev_priv(priv->real_dev);
+	usbdev_priv = usbdev->driver_priv;
+
 	hdr = skb_push(skb, sizeof(struct qmimux_hdr));
 	hdr->pad = 0;
 	hdr->mux_id = priv->mux_id;
 	hdr->pkt_len = cpu_to_be16(len);
 	skb->dev = priv->real_dev;
-	ret = dev_queue_xmit(skb);
 
-	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN))
-		dev_sw_netstats_tx_add(dev, 1, len);
-	else
+	if (usbdev_priv->qmimux_tx_max_datagrams == 1) {
+		/* No tx aggregation requested */
+		skb_current = skb;
+	} else {
+		spin_lock_bh(&usbdev_priv->qmimux_tx_mtx);
+		skb_current = qmimux_fill_tx_frame(usbdev, skb, &n, &len);
+		spin_unlock_bh(&usbdev_priv->qmimux_tx_mtx);
+	}
+
+	if (skb_current) {
+		ret = dev_queue_xmit(skb_current);
+
+		if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN))
+			dev_sw_netstats_tx_add(dev, n, len);
+		else
+			dev->stats.tx_dropped++;
+	} else if (n == 0) {
 		dev->stats.tx_dropped++;
+		ret = NET_XMIT_DROP;
+	} else {
+		ret = NET_XMIT_SUCCESS;
+	}
 
 	return ret;
 }
@@ -240,6 +356,39 @@ static struct attribute_group qmi_wwan_sysfs_qmimux_attr_group = {
 	.attrs = qmi_wwan_sysfs_qmimux_attrs,
 };
 
+static void qmimux_txpath_bh(struct tasklet_struct *t)
+{
+	struct qmi_wwan_priv *priv = from_tasklet(priv, t, bh);
+
+	if (!priv)
+		return;
+
+	spin_lock(&priv->qmimux_tx_mtx);
+	if (priv->qmimux_tx_timer_pending != 0) {
+		priv->qmimux_tx_timer_pending--;
+		qmimux_tx_timeout_start(priv);
+		spin_unlock(&priv->qmimux_tx_mtx);
+	} else if (priv->qmimux_tx_curr_aggr_skb) {
+		struct sk_buff *skb = priv->qmimux_tx_curr_aggr_skb;
+
+		priv->qmimux_tx_curr_aggr_skb = NULL;
+		spin_unlock(&priv->qmimux_tx_mtx);
+		dev_queue_xmit(skb);
+	} else {
+		spin_unlock(&priv->qmimux_tx_mtx);
+	}
+}
+
+static enum hrtimer_restart qmimux_tx_timer_cb(struct hrtimer *timer)
+{
+	struct qmi_wwan_priv *priv =
+				container_of(timer, struct qmi_wwan_priv, qmimux_tx_timer);
+
+	if (!atomic_read(&priv->stop))
+		tasklet_schedule(&priv->bh);
+	return HRTIMER_NORESTART;
+}
+
 static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 {
 	struct net_device *new_dev;
@@ -516,16 +665,79 @@ static ssize_t pass_through_store(struct device *d,
 	return len;
 }
 
+static ssize_t tx_max_datagrams_mux_store(struct device *d,  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_priv *priv = dev->driver_priv;
+	u8 qmimux_tx_max_datagrams;
+
+	if (netif_running(dev->net)) {
+		netdev_err(dev->net, "Cannot change a running device\n");
+		return -EBUSY;
+	}
+
+	if (kstrtou8(buf, 0, &qmimux_tx_max_datagrams))
+		return -EINVAL;
+
+	if (qmimux_tx_max_datagrams < 1)
+		return -EINVAL;
+
+	priv->qmimux_tx_max_datagrams = qmimux_tx_max_datagrams;
+
+	return len;
+}
+
+static ssize_t tx_max_datagrams_mux_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_priv *priv = dev->driver_priv;
+
+	return sysfs_emit(buf, "%u\n", priv->qmimux_tx_max_datagrams);
+}
+
+static ssize_t tx_max_size_mux_store(struct device *d,  struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_priv *priv = dev->driver_priv;
+	unsigned long qmimux_tx_max_size;
+
+	if (netif_running(dev->net)) {
+		netdev_err(dev->net, "Cannot change a running device\n");
+		return -EBUSY;
+	}
+
+	if (kstrtoul(buf, 0, &qmimux_tx_max_size))
+		return -EINVAL;
+
+	priv->qmimux_tx_max_size = qmimux_tx_max_size;
+
+	return len;
+}
+
+static ssize_t tx_max_size_mux_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_priv *priv = dev->driver_priv;
+
+	return sysfs_emit(buf, "%u\n", priv->qmimux_tx_max_size);
+}
+
 static DEVICE_ATTR_RW(raw_ip);
 static DEVICE_ATTR_RW(add_mux);
 static DEVICE_ATTR_RW(del_mux);
 static DEVICE_ATTR_RW(pass_through);
+static DEVICE_ATTR_RW(tx_max_datagrams_mux);
+static DEVICE_ATTR_RW(tx_max_size_mux);
 
 static struct attribute *qmi_wwan_sysfs_attrs[] = {
 	&dev_attr_raw_ip.attr,
 	&dev_attr_add_mux.attr,
 	&dev_attr_del_mux.attr,
 	&dev_attr_pass_through.attr,
+	&dev_attr_tx_max_datagrams_mux.attr,
+	&dev_attr_tx_max_size_mux.attr,
 	NULL,
 };
 
@@ -752,10 +964,16 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct usb_driver *driver = driver_of(intf);
 	struct qmi_wwan_state *info = (void *)&dev->data;
 	struct usb_cdc_parsed_header hdr;
+	struct qmi_wwan_priv *priv;
 
 	BUILD_BUG_ON((sizeof(((struct usbnet *)0)->data) <
 		      sizeof(struct qmi_wwan_state)));
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	dev->driver_priv = priv;
+
 	/* set up initial state */
 	info->control = intf;
 	info->data = intf;
@@ -824,6 +1042,16 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 		qmi_wwan_change_dtr(dev, true);
 	}
 
+	/* QMAP tx packets aggregation info */
+	hrtimer_init(&priv->qmimux_tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	priv->qmimux_tx_timer.function = &qmimux_tx_timer_cb;
+	tasklet_setup(&priv->bh, qmimux_txpath_bh);
+	atomic_set(&priv->stop, 0);
+	spin_lock_init(&priv->qmimux_tx_mtx);
+	/* tx packets aggregation disabled by default and max size set to default MTU */
+	priv->qmimux_tx_max_datagrams = 1;
+	priv->qmimux_tx_max_size = dev->net->mtu;
+
 	/* Never use the same address on both ends of the link, even if the
 	 * buggy firmware told us to. Or, if device is assigned the well-known
 	 * buggy firmware MAC address, replace it with a random address,
@@ -849,9 +1077,15 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 static void qmi_wwan_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct qmi_wwan_state *info = (void *)&dev->data;
+	struct qmi_wwan_priv *priv = dev->driver_priv;
 	struct usb_driver *driver = driver_of(intf);
 	struct usb_interface *other;
 
+	atomic_set(&priv->stop, 1);
+	hrtimer_cancel(&priv->qmimux_tx_timer);
+	tasklet_kill(&priv->bh);
+	kfree(priv);
+
 	if (info->subdriver && info->subdriver->disconnect)
 		info->subdriver->disconnect(info->control);
 
-- 
2.37.1

