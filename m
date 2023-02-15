Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419BE6975C1
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBOFTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjBOFTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:19:36 -0500
Received: from out28-77.mail.aliyun.com (out28-77.mail.aliyun.com [115.124.28.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4C32528;
        Tue, 14 Feb 2023 21:19:34 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1662711|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00516174-0.000373739-0.994465;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.RMfZsn3_1676438369;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.RMfZsn3_1676438369)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 13:19:30 +0800
Message-ID: <4c84995c-5546-47aa-d4ed-1db8cc7053c3@motor-comm.com>
Date:   Wed, 15 Feb 2023 13:19:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net-next] net: phy: motorcomm: uninitialized variables
 in yt8531_link_change_notify()
To:     Dan Carpenter <error27@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com
References: <Y+xd2yJet2ImHLoQ@kili>
Content-Language: en-US
From:   Frank Sae <Frank.Sae@motor-comm.com>
In-Reply-To: <Y+xd2yJet2ImHLoQ@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/15 12:21, Dan Carpenter wrote:
> These booleans are never set to false, but are just used without being
> initialized.
> 
> Fixes: 4ac94f728a58 ("net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> v2: reverse Christmas tree.  Also add "motorcomm" to the subject.  It
> really feels like previous patches to this driver should have had
> motorcomm in the subject as well.  It's a common anti-pattern to only
> put the subsystem name and not the driver name when adding a new file.
> 
>  drivers/net/phy/motorcomm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index ee7c37dfdca0..2fa5a90e073b 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -1533,10 +1533,10 @@ static int yt8531_config_init(struct phy_device *phydev)
>  static void yt8531_link_change_notify(struct phy_device *phydev)
>  {
>  	struct device_node *node = phydev->mdio.dev.of_node;
> +	bool tx_clk_1000_inverted = false;
> +	bool tx_clk_100_inverted = false;
> +	bool tx_clk_10_inverted = false;
>  	bool tx_clk_adj_enabled = false;
> -	bool tx_clk_1000_inverted;
> -	bool tx_clk_100_inverted;
> -	bool tx_clk_10_inverted;
>  	u16 val = 0;
>  	int ret;
>  

Reviewed-by: Frank Sae <Frank.Sae@motor-comm.com> 

Add cc.
