Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C167315FD5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhBJHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhBJHD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:03:59 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C469C06174A;
        Tue,  9 Feb 2021 23:03:19 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id u14so1267952wri.3;
        Tue, 09 Feb 2021 23:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LBNzGpjovJdmRTyJP+nTC+xvg8GW871RV/9xcC5rQDI=;
        b=FqK5GGpwnIknffo5W5qv8ABGIuwGLerReoXG1M1L9cMFIUWx/poY4vmbqMwoxO21U/
         fwFwneaEZ1K5OjjP73KBXjnqrdGXrthRtUdvpEvEJgNjplP7UeX6nseZ4qKXMCfKZx6s
         JKzBuJ1gSDixo6gxmbsKnKwogkhmGzWthhNT/3mVYOLBI/mMabgpFSPmekVp+XHXTefG
         pWyV46/BYdm2bBkTs3TQi+B/W0R4Rd+VcZ8qia1qGa/GyPKWXpa9CfU/Xv9yJ0Uxy1Gr
         tpVzMkNjHxJyzMMNvHUD8x9zsUpFHBJhCwMqsb30YJriQO+Sj4yqbdOjbKXG5v6quovo
         qnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBNzGpjovJdmRTyJP+nTC+xvg8GW871RV/9xcC5rQDI=;
        b=QSx8Bl3Q3zUgy1gNhWdBmG6UJGK5kjnolbf5Kp7ZfAfegeenlV+2sVtDoZ5qeSnPPe
         JJUiVYLiNmtsfuxZcR//4CeH+Lppi9XdT2wejjbM6320MunOn9KS5/9iGiYxWwe9Y1ie
         2HTzDa2F27yayT3aew/xCdcZyXiQZqa5PWalk5UKLEwF/Nul9XWLyUhZiZEKRu+y+Rf4
         plh6dupMM3oLeP1XkZ7wrJm6+mvcJi2d1HmKaRG41wN4oA84mqDI9DI3AiiBPyM4CvYD
         msWFUR7NuiIYjzY93x4s+/eOG1NWx+1gtxBflLhW5UXJPyUGtwtqLukTddW7774Ls4x3
         a1lw==
X-Gm-Message-State: AOAM530PGmRSlxKkNXxiZ1VzHCYN65tnmLpdZJTPpiIEgwzgGcNHiALi
        ynCwV0DndEEo5UXM/7hduGA=
X-Google-Smtp-Source: ABdhPJxQtDoTHO5G6iFs2FvzMzpR8PjSz/sPLH5W+rUxE8mtOeiNhP5CQYvXUY83iJebpiwQvRC1VA==
X-Received: by 2002:adf:b64f:: with SMTP id i15mr1833176wre.279.1612940597877;
        Tue, 09 Feb 2021 23:03:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id t7sm1582362wrv.75.2021.02.09.23.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 23:03:17 -0800 (PST)
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
Date:   Wed, 10 Feb 2021 08:03:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209164051.18156-8-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 17:40, Michael Walle wrote:
> Registers >= 16 are paged. Be sure to set the page. It seems this was
> working for now, because the default is correct for the registers used
> in the driver at the moment. But this will also assume, nobody will
> change the page select register before linux is started. The page select
> register is _not_ reset with a soft reset of the PHY.
> 
> Add read_page()/write_page() support for the IP101G and use it
> accordingly.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/icplus.c | 50 +++++++++++++++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
> index a6e1c7611f15..858b9326a72d 100644
> --- a/drivers/net/phy/icplus.c
> +++ b/drivers/net/phy/icplus.c
> @@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
>  #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
>  #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
>  
> +#define IP101G_DEFAULT_PAGE			16
> +
>  #define IP175C_PHY_ID 0x02430d80
>  #define IP1001_PHY_ID 0x02430d90
>  #define IP101A_PHY_ID 0x02430c54
> @@ -250,23 +252,25 @@ static int ip101a_g_probe(struct phy_device *phydev)
>  static int ip101a_g_config_init(struct phy_device *phydev)
>  {
>  	struct ip101a_g_phy_priv *priv = phydev->priv;
> -	int err;
> +	int oldpage, err;
> +
> +	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>  
>  	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
>  	switch (priv->sel_intr32) {
>  	case IP101GR_SEL_INTR32_RXER:
> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>  		if (err < 0)
> -			return err;
> +			goto out;
>  		break;
>  
>  	case IP101GR_SEL_INTR32_INTR:
> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>  		if (err < 0)
> -			return err;
> +			goto out;
>  		break;
>  
>  	default:
> @@ -284,12 +288,14 @@ static int ip101a_g_config_init(struct phy_device *phydev)
>  	 * reserved as 'write-one'.
>  	 */
>  	if (priv->model == IP101A) {
> -		err = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, IP101A_G_APS_ON);
> +		err = __phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS,
> +				     IP101A_G_APS_ON);
>  		if (err)
> -			return err;
> +			goto out;
>  	}
>  
> -	return 0;
> +out:
> +	return phy_restore_page(phydev, oldpage, err);

If a random page was set before entering config_init, do we actually want
to restore it? Or wouldn't it be better to set the default page as part
of initialization?

>  }
>  
>  static int ip101a_g_ack_interrupt(struct phy_device *phydev)
> @@ -347,6 +353,26 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
>  
> +static int ip101a_g_read_page(struct phy_device *phydev)
> +{
> +	struct ip101a_g_phy_priv *priv = phydev->priv;
> +
> +	if (priv->model == IP101A)
> +		return 0;
> +
> +	return __phy_read(phydev, IP101G_PAGE_CONTROL);
> +}
> +
> +static int ip101a_g_write_page(struct phy_device *phydev, int page)
> +{
> +	struct ip101a_g_phy_priv *priv = phydev->priv;
> +
> +	if (priv->model == IP101A)
> +		return 0;
> +
> +	return __phy_write(phydev, IP101G_PAGE_CONTROL, page);
> +}
> +
>  static struct phy_driver icplus_driver[] = {
>  {
>  	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
> @@ -373,6 +399,8 @@ static struct phy_driver icplus_driver[] = {
>  	.config_intr	= ip101a_g_config_intr,
>  	.handle_interrupt = ip101a_g_handle_interrupt,
>  	.config_init	= ip101a_g_config_init,
> +	.read_page	= ip101a_g_read_page,
> +	.write_page	= ip101a_g_write_page,
>  	.soft_reset	= genphy_soft_reset,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
> 

