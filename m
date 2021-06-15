Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670623A8036
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhFONgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:36:50 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:23551 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhFONgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623764035; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Az8I2skoM/PMnAivJi0Ks5e3gq9CK8dM4y/j65HKfvgOrrYqZphy7v9F9VY7t+YpnL
    AnghJybqsm/e4mG2NSovusuWrK8E/CMVVmfBVtpFKDF8MoUnej7XqxPhI5nudbecWI+E
    OYrgqHMR4gyvpeDpqWmxhOPRqe6e0F3PrdYwalnNDotAboWDG5vK3gUktYxH5v6UXybR
    BvGjoIFGHS/eOu6ZzTC+0IPgbDBvTftlNB8Ef+DkiQ9GPpWOI6URUO7+aXNbWawdWgcr
    BzB7w7L6hFkZaNlJm08O/KCmj9JiaXFZJ+LL29CujL5TNhAdcOlVSwqTi+qgUGxrZXa+
    e/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764035;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=nhxArcJV1va0qk3MTwRAlKFvcDP7levnGMMkdG7ueQM=;
    b=j79XMDDG4JvbyMGQFGRxCENyCkWZJ1HLwKzrplBQrzJlp+9+JFT4/FPnOBJl2PYVxk
    1WL9n+QUv+cNVUN+f0ktIywk81UPQnbwfHywnRR4V0U0PPEtxGKirJX2VBJx1mecfoN5
    WTvJP9TB5fm63d/E7Ce5sJP4MmzWDDn3GaI9zzXT6wh2Xa4rRXvwMamoyqOEZqavm8i8
    eZ+ABOZSNGsszHeYw6UUGmVzYNi5baYuSHVz6BB1ziEf7fNncOyOhdS6khUCOqAp5zmM
    Sv/OdT6I6IwujJXAvYFJ0hNB2lR2TPk1l8tkx007ApHrRgJvGbN2AxKmcHxf+xGb8XF2
    7v4g==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764035;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=nhxArcJV1va0qk3MTwRAlKFvcDP7levnGMMkdG7ueQM=;
    b=FIDdwjvkgEluOmq8r49KjrdhHU2rg+jmjrHc1VL0YKIliuBEBxbpHtKxCHoUr3sYpL
    +DC6+cu3Nt14TqsLb+TWYj26OAfgcR70r2wY15k7kSR7s0uLeoYjjWKwNnhGQFEYXqhQ
    aCc4zHoyuwsPSzwTRMPnOOBcKHe8C2hptgHFjCfrfSY5jRIuNeRVP9XGvirpFZiekmmu
    HejUTmtHQ0irEM8j9ub19UjojJ2iCtszIWfWUnsTnto8qI+DUhGwSPdKRteaJyjgEBe0
    tosgG96Z8hDgdO52ISvPOw1fzLxXKZ1S5+PSGntGvSJDaRsg+qPaa8/LxSjPcxLrU1YZ
    f0Wg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxA6m6NutzT"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x5FDXsOsp
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Jun 2021 15:33:54 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next 3/3] net: wwan: Allow WWAN drivers to provide blocking tx and poll function
Date:   Tue, 15 Jun 2021 15:32:29 +0200
Message-Id: <20210615133229.213064-4-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210615133229.213064-1-stephan@gerhold.net>
References: <20210615133229.213064-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, the WWAN core provides wwan_port_txon/off() to implement
blocking writes. The tx() port operation should not block, instead
wwan_port_txon/off() should be called when the TX queue is full or has
free space again.

However, in some cases it is not straightforward to make use of that
functionality. For example, the RPMSG API used by rpmsg_wwan_ctrl.c
does not provide any way to be notified when the TX queue has space
again. Instead, it only provides the following operations:

  - rpmsg_send(): blocking write (wait until there is space)
  - rpmsg_trysend(): non-blocking write (return error if no space)
  - rpmsg_poll(): set poll flags depending on TX queue state

Generally that's totally sufficient for implementing a char device,
but it does not fit well to the currently provided WWAN port ops.

Most of the time, using the non-blocking rpmsg_trysend() in the
WWAN tx() port operation works just fine. However, with high-frequent
writes to the char device it is possible to trigger a situation
where this causes issues. For example, consider the following
(somewhat unrealistic) example:

 # dd if=/dev/zero bs=1000 of=/dev/wwan0p2QMI
 dd: error writing '/dev/wwan0p2QMI': Resource temporarily unavailable
 1+0 records out

This fails immediately after writing the first record. It's likely
only a matter of time until this triggers issues for some real application
(e.g. ModemManager sending a lot of large QMI packets).

The rpmsg_char device does not have this problem, because it uses
rpmsg_trysend() and rpmsg_poll() to support non-blocking operations.
Make it possible to use the same in the RPMSG WWAN driver by extending
the tx() operation with a "nonblock" parameter and adding an optional
poll() callback. This integrates nicely with the RPMSG API and does
not break other WWAN drivers.

With these changes, the dd example above blocks instead of exiting
with an error.

Cc: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Note that rpmsg_poll() is an optional callback currently only implemented
by the qcom_smd RPMSG provider. However, it should be easy to implement
this for other RPMSG providers when needed.

Another potential solution suggested by Loic Poulain in [1] is to always
use the blocking rpmsg_send() from a workqueue/kthread and disable TX
until it is done. I think this could also work (perhaps a bit more
difficult to implement) but the main disadvantage is that I don't see
a way to return any kind of error to the client with this approach.
I assume we return immediately from the write() to the char device
after scheduling the rpmsg_send(), so we already reported success
when rpmsg_send() returns.

At the end all that matters to me is that it works properly, so I'm
open for any other suggestions. :)

[1]: https://lore.kernel.org/linux-arm-msm/CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com/
---
 drivers/net/wwan/iosm/iosm_ipc_port.c |  3 ++-
 drivers/net/wwan/mhi_wwan_ctrl.c      |  3 ++-
 drivers/net/wwan/rpmsg_wwan_ctrl.c    | 17 +++++++++++++++--
 drivers/net/wwan/wwan_core.c          |  9 ++++++---
 drivers/net/wwan/wwan_hwsim.c         |  3 ++-
 include/linux/wwan.h                  | 13 +++++++++----
 6 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
index beb944847398..2f874e41ceff 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_port.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
@@ -31,7 +31,8 @@ static void ipc_port_ctrl_stop(struct wwan_port *port)
 }
 
 /* transfer control data to modem */
-static int ipc_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+static int ipc_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
+			    bool nonblock)
 {
 	struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
 
diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index 1bc6b69aa530..9754f014d348 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -139,7 +139,8 @@ static void mhi_wwan_ctrl_stop(struct wwan_port *port)
 	mhi_unprepare_from_transfer(mhiwwan->mhi_dev);
 }
 
-static int mhi_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+static int mhi_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
+			    bool nonblock)
 {
 	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
 	int ret;
diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
index de226cdb69fd..63f431eada39 100644
--- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
+++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
@@ -54,12 +54,16 @@ static void rpmsg_wwan_ctrl_stop(struct wwan_port *port)
 	rpwwan->ept = NULL;
 }
 
-static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
+static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
+			      bool nonblock)
 {
 	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
 	int ret;
 
-	ret = rpmsg_trysend(rpwwan->ept, skb->data, skb->len);
+	if (nonblock)
+		ret = rpmsg_trysend(rpwwan->ept, skb->data, skb->len);
+	else
+		ret = rpmsg_send(rpwwan->ept, skb->data, skb->len);
 	if (ret)
 		return ret;
 
@@ -67,10 +71,19 @@ static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 	return 0;
 }
 
+static __poll_t rpmsg_wwan_ctrl_poll(struct wwan_port *port, struct file *filp,
+				     poll_table *wait)
+{
+	struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
+
+	return rpmsg_poll(rpwwan->ept, filp, wait);
+}
+
 static const struct wwan_port_ops rpmsg_wwan_pops = {
 	.start = rpmsg_wwan_ctrl_start,
 	.stop = rpmsg_wwan_ctrl_stop,
 	.tx = rpmsg_wwan_ctrl_tx,
+	.poll = rpmsg_wwan_ctrl_poll,
 };
 
 static struct device *rpmsg_wwan_find_parent(struct device *dev)
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 7e728042fc41..c7fd0b897f87 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -500,7 +500,8 @@ static void wwan_port_op_stop(struct wwan_port *port)
 	mutex_unlock(&port->ops_lock);
 }
 
-static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
+static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb,
+			   bool nonblock)
 {
 	int ret;
 
@@ -510,7 +511,7 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
 		goto out_unlock;
 	}
 
-	ret = port->ops->tx(port, skb);
+	ret = port->ops->tx(port, skb, nonblock);
 
 out_unlock:
 	mutex_unlock(&port->ops_lock);
@@ -637,7 +638,7 @@ static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 	}
 
-	ret = wwan_port_op_tx(port, skb);
+	ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
 	if (ret) {
 		kfree_skb(skb);
 		return ret;
@@ -659,6 +660,8 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 		mask |= EPOLLIN | EPOLLRDNORM;
 	if (!port->ops)
 		mask |= EPOLLHUP | EPOLLERR;
+	else if (port->ops->poll)
+		mask |= port->ops->poll(port, filp, wait);
 
 	return mask;
 }
diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index 472cae544a2b..e5ecbc70658d 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -83,7 +83,8 @@ static void wwan_hwsim_port_stop(struct wwan_port *wport)
  *
  * Be aware that this processor is not fully V.250 compliant.
  */
-static int wwan_hwsim_port_tx(struct wwan_port *wport, struct sk_buff *in)
+static int wwan_hwsim_port_tx(struct wwan_port *wport, struct sk_buff *in,
+			      bool nonblock)
 {
 	struct wwan_hwsim_port *port = wwan_port_get_drvdata(wport);
 	struct sk_buff *out;
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 430a3a0817de..d7c8c6ac7594 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -6,6 +6,7 @@
 
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/poll.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 
@@ -38,17 +39,21 @@ enum wwan_port_type {
 struct wwan_port;
 
 /** struct wwan_port_ops - The WWAN port operations
- * @start: The routine for starting the WWAN port device.
- * @stop: The routine for stopping the WWAN port device.
+ * @start: The routine for starting the WWAN port device. Required.
+ * @stop: The routine for stopping the WWAN port device. Required.
  * @tx: The routine that sends WWAN port protocol data to the device.
+ *      May only block if nonblock is false. Required.
+ * @poll: A routine to set additional poll flags. Optional.
  *
  * The wwan_port_ops structure contains a list of low-level operations
- * that control a WWAN port device. All functions are mandatory.
+ * that control a WWAN port device.
  */
 struct wwan_port_ops {
 	int (*start)(struct wwan_port *port);
 	void (*stop)(struct wwan_port *port);
-	int (*tx)(struct wwan_port *port, struct sk_buff *skb);
+	int (*tx)(struct wwan_port *port, struct sk_buff *skb, bool nonblock);
+	__poll_t (*poll)(struct wwan_port *port, struct file *filp,
+			 poll_table *wait);
 };
 
 /**
-- 
2.32.0

