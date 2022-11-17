Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC2862DD8A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiKQOIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKQOIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:08:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975B2339A;
        Thu, 17 Nov 2022 06:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zl6vDHK5lKkg1Jtxz5YOTlp7d4oAdqSycBm87+KayEM=; b=aNrcs+DAcnw62Li03+/U0OF33Y
        ombDLu03bhJM/J12bNnADscp058uDd87hTKHsNvNSwrlMJ32fXuZw/HQ8QJl8eWN5zvaK+wOfFOk5
        panOMYbUsDlniK9SmKTVNfOysvnmzaeXNtF6bgwviRfqbqBAu43/Sp0Ica1wzJw3N/+s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovfYk-002hD3-0v; Thu, 17 Nov 2022 15:08:06 +0100
Date:   Thu, 17 Nov 2022 15:08:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Message-ID: <Y3ZARsVC14JUa9i8@lunn.ch>
References: <20221117145820.2898968-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117145820.2898968-1-luwei32@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:58:20PM +0800, Lu Wei wrote:
> There is no need to define variable ret, so remove it
> and return sparx5_leak_groups_init() directly.
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_qos.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> index 1e79d0ef0cb8..2f39300d52cc 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> @@ -383,13 +383,7 @@ static int sparx5_leak_groups_init(struct sparx5 *sparx5)
>  
>  int sparx5_qos_init(struct sparx5 *sparx5)
>  {
> -	int ret;
> -
> -	ret = sparx5_leak_groups_init(sparx5);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return sparx5_leak_groups_init(sparx5);
>  }

Does sparx5_qos_init() even make sense given that all it does it call
a function?

Please don't do the minimum needed to make your robot happy. Think
about the code, the change, is this the best fix?

      Andrew
