Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5244E52985E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 05:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiEQDnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 23:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiEQDnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 23:43:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72BE27B04
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:43:05 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h186so13220178pgc.3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RZLhxx6MlZqNRCdcVJVHbSsteOlQC1pIs7RcktbmMu8=;
        b=NtawI9Ip81UQhVvPQo0Da4dcjHoRoVqAEAwk1UcuOPe1pwJBB/dTVSvYxp2mgjFkor
         gh7k0SHnk9impQHDo0O/5VTwLcMuS8fdbZfkoAIIrw5XQ5d3QsSdKeSW29216syzIlNu
         A5nM1taw+GbvScWxqChasirT4ZdVRL0bgwLRS0KKPzkr4PVxbkr/zQYlORP9I3jAncE0
         0uDcz4UV23ZAcMWd5T86Si051sgG0vUx6XZhWIo7Va/09Vcm474+HeP+JemqcGXI/Rl1
         2ebCtixQRhzUm7OPl7Ph1XIGKfi/49RM2/1l3e/mqBli1a+jK+3Li0Ois3kBsctSNTFA
         VN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZLhxx6MlZqNRCdcVJVHbSsteOlQC1pIs7RcktbmMu8=;
        b=6U8ABMF1EYd+gcTkPpmv7fzNjOvOwmOeRzQJzwB75E8YeVjtScsOKmfereypqq9jol
         l4CRTH3EHR7DXOHZc8Q08BAb3rpqp1UrSed99Dq35gndLejcvwCb5YJIWJGiaGGwRCXS
         v+lc8RSGGVzBiDnf0A4NzfUL0vwMJq9PaEzXcCus43a/GUlACyksM85PrgRuwAPxQNcM
         QFXzVkT2Ohz4/2sKTfvIQtFLrbRk2LvkGPn2UEPJb4lHOQRBqJnqmu+9vPBVPabPWvNo
         DyVz+yOoMnfvp1oI6S4ZQjm1/2qrv3h+tzApxpgoPexz4lFhXnwSz3IfUijdRakCZ39C
         YgQw==
X-Gm-Message-State: AOAM5331zQ5GOT/pXQGxZO6Gl8DrGYK4mUpJiBmU14QA1e9Dsp4YezdN
        9O/OKG2JYlRbaWH8H1rVYlo=
X-Google-Smtp-Source: ABdhPJyS839djlzQlIBO8IF8MxH295znaIXa3/QzcR/aY3RCV5qS4H65coQj2QZFPkh/LYq7eXMIQg==
X-Received: by 2002:a65:694a:0:b0:3db:141c:6db2 with SMTP id w10-20020a65694a000000b003db141c6db2mr17600608pgq.198.1652758985071;
        Mon, 16 May 2022 20:43:05 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1-20020a170903244100b0015ea4173bd6sm7953084pls.195.2022.05.16.20.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 20:43:04 -0700 (PDT)
Date:   Tue, 17 May 2022 11:42:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
Message-ID: <YoMZvrPcgIm8k2b6@Laptop-X1>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
 <20220516181028.7dbbf918@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516181028.7dbbf918@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 06:10:28PM -0700, Jakub Kicinski wrote:
> Can't ->get_ts_info sleep now? It'd be a little sad to force it 
> to be atomic just because of one upper dev trying to be fancy.
> Maybe all we need to do is to take a ref on the real_dev?

Do you mean

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38e152548126..b60450211579 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5591,16 +5591,20 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 	const struct ethtool_ops *ops;
 	struct net_device *real_dev;
 	struct phy_device *phydev;
+	int ret = 0;
 
 	real_dev = bond_option_active_slave_get_rcu(bond);
 	if (real_dev) {
+		dev_hold(real_dev)
 		ops = real_dev->ethtool_ops;
 		phydev = real_dev->phydev;
 
 		if (phy_has_tsinfo(phydev)) {
-			return phy_ts_info(phydev, info);
+			ret = phy_ts_info(phydev, info);
+			goto out;
 		} else if (ops->get_ts_info) {
-			return ops->get_ts_info(real_dev, info);
+			ret = ops->get_ts_info(real_dev, info);
+			goto out;
 		}
 	}
 
@@ -5608,7 +5612,10 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
 				SOF_TIMESTAMPING_SOFTWARE;
 	info->phc_index = -1;
 
-	return 0;
+out:
+	if (real_dev)
+		dev_put(real_dev);
+	return ret;
 }


This look OK to me.

Vladimir, Jay, WDYT?

> 
> Also please add a Link: to the previous discussion, it'd have been
> useful to get the context in which Vladimir suggested this.

OK, I will.

Thanks
Hangbin
