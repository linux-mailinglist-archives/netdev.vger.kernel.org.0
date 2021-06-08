Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA37439ED49
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhFHEFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhFHEFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:05 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868F6C061789;
        Mon,  7 Jun 2021 21:02:56 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id s22so4688017ljg.5;
        Mon, 07 Jun 2021 21:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lVnV9bzdy6uuIzlfqAADzTp6JOA579xDrvynPNNeP4g=;
        b=G3CeIgUYoBiBPFOc2fzqb5S8GPmuhTnsNMc+bJOQ9hQ27dg4qluBT2HOH62hO3BHb6
         K2yq0hvG4kb4OsvHCeCGZ3chkFfhv2g1p+zrdq0BdWdfznFfjsy4Ckl++glp38mUASaX
         guKX7VYqIQFGEvFN+4pv7dfbhxxfxprPBLs8rLOVW8ZIcGNSqoGSUvdgY6EOupTs36RZ
         FE+lx2/mrT3ZUytfkHpHmY6nIrsi9FW2EMLGWP7eWDtALSoUcAg4O5T/zlMq+sDMle5e
         UqHHoQ/XYLd1nNnAdPCMvdn48zhcHpMwOVD4O1NIjmxh7gaADMzoZEEjEasJRlocijEj
         ApSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lVnV9bzdy6uuIzlfqAADzTp6JOA579xDrvynPNNeP4g=;
        b=LisP9HE0yNYcZOWRt62OoJmdA8J8ZW28zYhXUh6aoZUMiWRokT4saad3W2jaDxg6e/
         NPwhbMBo7RUINOuHtqQCD0FBQtugXHaGeG+7453HkCCZGRJ91/krJCYMrKsUz2Vb9lH7
         N0cFznDZ150en2adF6XqJEYhZveX7pkJyP+l5xd5zXPdesmjeAKMcO6YIAGaw9f0zNM5
         CViJ6FGycO6Og+UV7gc/OP33TLHRiIg/2ThRfZ2F4WjsLINQ56MrrTop0Rnd1bkRzeBk
         GnAFoT3+hAphKCEGwClEdIRWobdVQI5CR5dukqbij1IiD3MNyCQWMlXqwKHWVHlO9A4U
         3I+w==
X-Gm-Message-State: AOAM531tn9C1kJWNX9TwYTN6LdyAvzuUFaDYNG8WRi8UvXJJgOY/lZA0
        d5oQ0IFOgTqlieMY+KAcMjc=
X-Google-Smtp-Source: ABdhPJxfZhVrT7KLAx9VFuVzf/hRu22kqRSq+2lmO/jC10K3bPeeJp4+qQMrwMuEgouyRND6fsnZAg==
X-Received: by 2002:a05:651c:324:: with SMTP id b4mr16941663ljp.166.1623124974910;
        Mon, 07 Jun 2021 21:02:54 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:54 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/10] net: wwan: core: make port names more user-friendly
Date:   Tue,  8 Jun 2021 07:02:37 +0300
Message-Id: <20210608040241.10658-7-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, the port name is allocated based on the parent device
name, port id and the port type. Where the port id specifies nothing but
the ports registration order and is only used to make the port name
unique.

Most likely, to configure a WWAN device, the user will look for a port
of a specific type (e.g. AT port or MBIM port, etc.). The current naming
scheme can make it difficult to find a port of a specific type.

Consider a WWAN device that has 3 ports: AT port, MBIM port, and another
one AT port. With the global port index, the port names will be:
* wwan0p1at
* wwan0p2mbim
* wwan0p3at

To find the MBIM port, user should know in advance the device ports
composition (i.e. the user should know that the MBIM port is the 2nd
one) or carefully examine the whole ports list. It is not unusual for
USB modems to have a different composition, even if they are build on a
same chipset. Moreover, some modems able to change the ports composition
based on the user's configuration. All this makes port names fully
unpredictable.

To make naming more user-friendly, remove the global port id and
enumerate ports by its type. E.g.:
* wwan0p1at   -> wwan0at0
* wwan0p2mbim -> wwan0mbim0
* wwan0p3at   -> wwan0at1

With this naming scheme, the first AT port name will always be wwanXat0,
the first MBIM port name will always be wwanXmbim0, etc.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 67 ++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index ba4392d71b80..2844b17a724c 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -33,12 +33,10 @@ static int wwan_major;
  *
  * @id: WWAN device unique ID.
  * @dev: Underlying device.
- * @port_id: Current available port ID to pick.
  */
 struct wwan_device {
 	unsigned int id;
 	struct device dev;
-	atomic_t port_id;
 };
 
 /**
@@ -258,6 +256,56 @@ static struct wwan_port *wwan_port_get_by_minor(unsigned int minor)
 	return to_wwan_port(dev);
 }
 
+/* Allocate and set unique name based on passed format
+ *
+ * Name allocation approach is highly inspired by the __dev_alloc_name()
+ * function.
+ *
+ * To avoid names collision, the caller must prevent the new port device
+ * registration as well as concurrent invocation of this function.
+ */
+static int __wwan_port_dev_assign_name(struct wwan_port *port, const char *fmt)
+{
+	struct wwan_device *wwandev = to_wwan_dev(port->dev.parent);
+	const unsigned int max_ports = PAGE_SIZE * 8;
+	struct class_dev_iter iter;
+	unsigned long *idmap;
+	struct device *dev;
+	char buf[0x20];
+	int id;
+
+	idmap = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+	if (!idmap)
+		return -ENOMEM;
+
+	/* Collect ids of same name format ports */
+	class_dev_iter_init(&iter, wwan_class, NULL, &wwan_port_dev_type);
+	while ((dev = class_dev_iter_next(&iter))) {
+		if (dev->parent != &wwandev->dev)
+			continue;
+		if (sscanf(dev_name(dev), fmt, &id) != 1)
+			continue;
+		if (id < 0 || id >= max_ports)
+			continue;
+		set_bit(id, idmap);
+	}
+	class_dev_iter_exit(&iter);
+
+	/* Allocate unique id */
+	id = find_first_zero_bit(idmap, max_ports);
+	free_page((unsigned long)idmap);
+
+	snprintf(buf, sizeof(buf), fmt, id);	/* Name generation */
+
+	dev = device_find_child_by_name(&wwandev->dev, buf);
+	if (dev) {
+		put_device(dev);
+		return -ENFILE;
+	}
+
+	return dev_set_name(&port->dev, buf);
+}
+
 struct wwan_port *wwan_create_port(struct device *parent,
 				   enum wwan_port_type type,
 				   const struct wwan_port_ops *ops,
@@ -266,6 +314,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	struct wwan_device *wwandev;
 	struct wwan_port *port;
 	int minor, err = -ENOMEM;
+	char namefmt[0x20];
 
 	if (type > WWAN_PORT_MAX || !ops)
 		return ERR_PTR(-EINVAL);
@@ -300,12 +349,18 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	port->dev.devt = MKDEV(wwan_major, minor);
 	dev_set_drvdata(&port->dev, drvdata);
 
-	/* create unique name based on wwan device id, port index and type */
-	dev_set_name(&port->dev, "wwan%up%u%s", wwandev->id,
-		     atomic_inc_return(&wwandev->port_id),
-		     wwan_port_types[port->type].devsuf);
+	/* allocate unique name based on wwan device id, port type and number */
+	snprintf(namefmt, sizeof(namefmt), "wwan%u%s%%d", wwandev->id,
+		 wwan_port_types[port->type].devsuf);
 
+	/* Serialize ports registration */
+	mutex_lock(&wwan_register_lock);
+
+	__wwan_port_dev_assign_name(port, namefmt);
 	err = device_register(&port->dev);
+
+	mutex_unlock(&wwan_register_lock);
+
 	if (err)
 		goto error_put_device;
 
-- 
2.26.3

