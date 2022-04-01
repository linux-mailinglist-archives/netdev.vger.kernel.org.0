Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22244EEC01
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345369AbiDALIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345335AbiDALIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:08:00 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA23226FA;
        Fri,  1 Apr 2022 04:06:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p26-20020a05600c1d9a00b0038ccbff1951so3178244wms.1;
        Fri, 01 Apr 2022 04:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wImnV8rTdUbT+D4vFE47rEe27B+UpCvY+mZ1m0Esjpw=;
        b=SGRTN4hQcmzee66KzYgXLOXEaj1FTFXG6HIDWSLepMIAPz7BkPD+hYMXBfb8YpeKf+
         RTY3K6ZSHCJv9YDtJm4IHqotp0+FVAjkB5fnC3FjHrdIHjJ1e86QmCXuztqAhZsdq+dY
         q7BvS73d9J++UH2r5HF/FR88RGLwDIwPF+ZS2cl5G/vhiuFw5ewI5zYkYv2pxuJ1uV28
         non3US7tD64QzAnuUnjBNRyifIcCyCHItav150T58irYBDYwVQAb5grkCgBDSRsMfD9+
         3+Ffl5AMuN2vl7VW312/nNLxEYEcFJu7WlKw44f94+xbmWOXa7BXsAF7ECuCjDkFKcwD
         IZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=wImnV8rTdUbT+D4vFE47rEe27B+UpCvY+mZ1m0Esjpw=;
        b=B+3mmWWPIULt5ifVZ6bBwj+XLPsq9lmnFq7PRDefLGtflcGojWbG7CB9mefRIn21FT
         DBr7QRgt/NK8wTataeGmxQKh5rTMAGgE1NNZKKqGxB2buuRe9MIMNba0hx2N2qwsGDW3
         6HYd6cRpdxzs+DVlUDEZj+yqJ34lcY+ln33MK1ywTLRVLcXIxQ5VMv7vC2LlwiusLyXF
         XA2gWTs6idl7roLrR6NX5oFvdW2YqxppxA3rdoC30L3otRbFoDT8TRLNavG5MGcUnGLP
         Rh/mSKaUaDjWjnZRpbdySrVPyztbA+rGrRrNfVKJPu1MCyGL9pE2XIJj7Qg5z3N6qf/U
         GfkQ==
X-Gm-Message-State: AOAM532hTPdnBlqr5ssFLQ945Wtc+SBvw/UFr9OHtiz/bgnjcb+2yd1m
        KXXiZpVx6lD25wn4FSMC2sA=
X-Google-Smtp-Source: ABdhPJx8XEBs4xl1nwghvJKsDKaG5UrHLt5e+PVdTit6UZP2JqHDc6JWsZvsHE5Euw38Uqx/7Lo6QA==
X-Received: by 2002:a05:600c:4110:b0:38c:ba41:9fb with SMTP id j16-20020a05600c411000b0038cba4109fbmr8277399wmi.47.1648811169186;
        Fri, 01 Apr 2022 04:06:09 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d4e08000000b002054b5437f2sm1743650wrt.115.2022.04.01.04.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Apr 2022 04:06:08 -0700 (PDT)
Date:   Fri, 1 Apr 2022 12:06:06 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ecree.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net v2] net: sfc: add missing xdp queue reinitialization
Message-ID: <20220401110606.whyr5hnesb4ya67q@gmail.com>
Mail-Followup-To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ecree.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
References: <20220330163703.25086-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330163703.25086-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

Thanks for looking into this. Unfortunately efx_realloc_channels()
has turned out to be quite fragile over the years, so I'm
keen to remove it in stead of patching it up all the time.

Could you try the patch below please?
If it works ok for you as well we'll be able to remove
efx_realloc_channels(). The added advantage of this approach
is that the netdev notifiers get informed of the change.

Regards,
Martin Habets <habetsm.xilinx@gmail.com>

---
 drivers/net/ethernet/sfc/ethtool.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 48506373721a..8cfbe61737bb 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -179,6 +179,7 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	u32 txq_entries;
+	int rc = 0;
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 	    ring->rx_pending > EFX_MAX_DMAQ_SIZE ||
@@ -198,7 +199,17 @@ efx_ethtool_set_ringparam(struct net_device *net_dev,
 			   "increasing TX queue size to minimum of %u\n",
 			   txq_entries);
 
-	return efx_realloc_channels(efx, ring->rx_pending, txq_entries);
+	/* Apply the new settings */
+	efx->rxq_entries = ring->rx_pending;
+	efx->txq_entries = ring->tx_pending;
+
+	/* Update the datapath with the new settings if the interface is up */
+	if (!efx_check_disabled(efx) && netif_running(efx->net_dev)) {
+		dev_close(net_dev);
+		rc = dev_open(net_dev, NULL);
+	}
+
+	return rc;
 }
 
 static void efx_ethtool_get_wol(struct net_device *net_dev,
