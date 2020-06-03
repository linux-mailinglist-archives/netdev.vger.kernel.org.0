Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92701ED232
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgFCOgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgFCOgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:36:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D46C08C5C1
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 07:36:50 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j10so2625606wrw.8
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 07:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pl3xDnNmt1VQENcPAj+d3FJJVE2TWWyVWxTE2VGNl20=;
        b=ebsBmXcJKaW/yR42AsepxbZW/pr/LYJzRJKFJ0qCvO/qb3T75kr+kuoII+cb0LqWvK
         yTbj0P560zdX1jvYQ3U7/gfSKpOSogASuLAvb6ca8uM2zuAznJGLHw8Q1ZSWud6mrdZS
         2ksKDtiqL07scaq/cyC9aURjOTB0gRp2GWTOOn1EoyTNNmVmM7353iL492ED3Z9fvn31
         5qQrHhGQnEZuodlPNy6qZsuXAnr6kDo0L9F/SXVz9iXMZPFEYP2CE61HxTg+8CZ2ZXIk
         lwDRdnWG5SDpZUMqNPFC0CWISkOUKKYL7BLua0/sixpUAJ7aM/1laR0ZLKjYeejxbBob
         Vi4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pl3xDnNmt1VQENcPAj+d3FJJVE2TWWyVWxTE2VGNl20=;
        b=EFMNNl46O5x1oxaDLTNMAzalYn2qmAXKargjEAnTr5+wIOLgkWpYk5YmouUNI1MLSy
         HTyKRjz+FCbnB5qmcv6VISBZXxEpslw0gw2S/XZxw3QtS76dO1nqxniCkZIUWRs8EFv5
         xyIhb6M/odPOWvhCNGirm0O1OZlr4p9iFsa6dNpUF5AqxHe2zQqNvaL6M4x8naqpZlv8
         mQKxKuChObxekM/06mTwsq2jvnPhBEi7EEeGZuRJZXp/YolpF05bJ55JiqiqmYOZs8sw
         1uBYKi3OlpEE5b4sB/li4r2zvgW5UFYWA0YJXoya9qUCKc3v35EGWUqWXR+s5QHZfR3G
         pOHw==
X-Gm-Message-State: AOAM530hlU0Vo+HzCl4OB6ut/98kCI6cdZDJH7CcQkqQcu1nIivL+LBS
        ARGfkwNxf3PGdSHYx5sHBi7K1Q==
X-Google-Smtp-Source: ABdhPJyMb5U3ggl5KDn66BeTGb2QgmEVbyyru5dmqQeyyCdB/WWCY7uGGgPTbJlL4GItXeBfgSOj+w==
X-Received: by 2002:a5d:608d:: with SMTP id w13mr30920857wrt.298.1591195008863;
        Wed, 03 Jun 2020 07:36:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a81sm3587325wmd.25.2020.06.03.07.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 07:36:48 -0700 (PDT)
Date:   Wed, 3 Jun 2020 16:36:47 +0200
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
Message-ID: <20200603143647.GC2274@nanopsycho.orion>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200603142944.GA5892@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603142944.GA5892@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 03, 2020 at 04:29:44PM CEST, jiri@resnulli.us wrote:
>Thu, May 28, 2020 at 05:12:40PM CEST, vadym.kochan@plvision.eu wrote:
>
>[...]
>
>>+static int prestera_port_create(struct prestera_switch *sw, u32 id)
>>+{
>>+	struct prestera_port *port;
>>+	struct net_device *dev;
>>+	int err;
>>+
>>+	dev = alloc_etherdev(sizeof(*port));
>>+	if (!dev)
>>+		return -ENOMEM;
>>+
>>+	port = netdev_priv(dev);
>>+
>>+	port->dev = dev;
>>+	port->id = id;
>>+	port->sw = sw;
>>+
>>+	err = prestera_hw_port_info_get(port, &port->fp_id,
>>+					&port->hw_id, &port->dev_id);
>>+	if (err) {
>>+		dev_err(prestera_dev(sw), "Failed to get port(%u) info\n", id);
>>+		goto err_port_init;
>>+	}
>>+
>>+	dev->features |= NETIF_F_NETNS_LOCAL;
>>+	dev->netdev_ops = &netdev_ops;
>>+
>>+	netif_carrier_off(dev);
>
>No need.

Actually, it is. Sorry :)

