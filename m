Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8353FDED8
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343814AbhIAPl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbhIAPl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:41:27 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E534C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 08:40:30 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u9so195272wrg.8
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 08:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v0L51FGB1W7SONvzxRvRyF7MrC+G1mrwzWyYrez1a2s=;
        b=L2oGi0DtsF7pYo5FDHHlX00T5ji6/+2Ql1TWAkKQ9PlFiZKONDJES8/FgVklHVd9lP
         IZKwHk7mtuHFwzZTRKMUoJy09ZwZZt0U9JZdbOjNf3Iuhpm2A1dOfYMv2ej7FDX+q/tK
         xvbxSROkLdeObLQGbpBaAcUx48ES3xIT+bt27YLyw33sLPq9pdX838WuLkSDT8WNazyG
         JRYIaPCQ5DoscAWMS8uJM64JglL2Y1LwynjJKWxnV+eS3W/mwWCAtTLp4Be2oLpn3Ohl
         2im8qgxWqg960uLTDKMltGFpb5EAMYQ+WY1ehPa9R7J1oTCtHUCMdAOBcRon6m6HwF/t
         GPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v0L51FGB1W7SONvzxRvRyF7MrC+G1mrwzWyYrez1a2s=;
        b=n0RlYXzqbVFRIz+U+CM+9bdOmcZylUnA8i7MQuStDeiXJPa26v1z3/WclqxWtuY1PC
         Rky1Jv39xO6nHBu7lijxC1LcSxAjdmDQYD3Fmj8H8rTP/fNunJfxV5Q+xM+nCZfp0K5a
         zYNXMq5yINOB39pafIzpBIs06SdVWoyTi6IJvuWEit51xE46/ZEtntiPfELcA2Zh/wia
         Ncygfe+EqNt4k3hwsyFJPGs0/0iuLe0BtOI0cnSXcksF5SnwT2zchuFEr7wJ+bx1CmOo
         Fv9FquEApArD5+KHmUMCHay3POL86pfOnZtbqnGETngO9HX+oQAMLgP8dEBW0pgRCGUK
         BbhQ==
X-Gm-Message-State: AOAM531Y8WacHClQT3knBlTL4YB2aze+J3/dlg/l1VUOeWdaicQ+Su3i
        bPpUGhUhH5sOUDDmaA+CBTM=
X-Google-Smtp-Source: ABdhPJyZZ/ZY8w0BAE3TPj98nbXgpaPrMfjWP4VG0FHGaevZurQd7D4EjOgxUJs1/N/kjNReCuZ2+g==
X-Received: by 2002:a5d:4991:: with SMTP id r17mr40019751wrq.247.1630510828593;
        Wed, 01 Sep 2021 08:40:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:644a:cd2e:d110:5f24? (p200300ea8f084500644acd2ed1105f24.dip0.t-ipconnect.de. [2003:ea:8f08:4500:644a:cd2e:d110:5f24])
        by smtp.googlemail.com with ESMTPSA id m186sm5824946wme.48.2021.09.01.08.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 08:40:28 -0700 (PDT)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901091332.GZ22278@shell.armlinux.org.uk>
 <DB8PR04MB67959C4B1D1AFEC5AEEB73F3E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <ce36eb26-a304-9dd8-3bee-4117929a5546@gmail.com>
Date:   Wed, 1 Sep 2021 17:40:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67959C4B1D1AFEC5AEEB73F3E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.2021 12:21, Joakim Zhang wrote:
> 
> Hi Russell,
> 
>> -----Original Message-----
>> From: Russell King <linux@armlinux.org.uk>
>> Sent: 2021Äê9ÔÂ1ÈÕ 17:14
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
>> joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
>> mcoquelin.stm32@gmail.com; netdev@vger.kernel.org; andrew@lunn.ch;
>> f.fainelli@gmail.com; hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
>> Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
>> back with WoL enabled
>>
>> On Wed, Sep 01, 2021 at 05:02:28PM +0800, Joakim Zhang wrote:
>>> We can reproduce this issue with below steps:
>>> 1) enable WoL on the host
>>> 2) host system suspended
>>> 3) remote client send out wakeup packets We can see that host system
>>> resume back, but can't work, such as ping failed.
>>>
>>> After a bit digging, this issue is introduced by the commit
>>> 46f69ded988d
>>> ("net: stmmac: Use resolved link config in mac_link_up()"), which use
>>> the finalised link parameters in mac_link_up() rather than the
>>> parameters in mac_config().
>>>
>>> There are two scenarios for MAC suspend/resume:
>>>
>>> 1) MAC suspend with WoL disabled, stmmac_suspend() call
>>> phylink_mac_change() to notify phylink machine that a change in MAC
>>> state, then .mac_link_down callback would be invoked. Further, it will
>>> call phylink_stop() to stop the phylink instance. When MAC resume
>>> back, firstly phylink_start() is called to start the phylink instance,
>>> then call phylink_mac_change() which will finally trigger phylink
>>> machine to invoke .mac_config and .mac_link_up callback. All is fine
>>> since configuration in these two callbacks will be initialized.
>>>
>>> 2) MAC suspend with WoL enabled, phylink_mac_change() will put link
>>> down, but there is no phylink_stop() to stop the phylink instance, so
>>> it will link up again, that means .mac_config and .mac_link_up would
>>> be invoked before system suspended. After system resume back, it will
>>> do DMA initialization and SW reset which let MAC lost the hardware
>>> setting (i.e MAC_Configuration register(offset 0x0) is reset). Since
>>> link is up before system suspended, so .mac_link_up would not be
>>> invoked after system resume back, lead to there is no chance to
>>> initialize the configuration in .mac_link_up callback, as a result,
>>> MAC can't work any longer.
>>>
>>> Above description is what I found when debug this issue, this patch is
>>> just revert broken patch to workaround it, at least make MAC work when
>>> system resume back with WoL enabled.
>>>
>>> Said this is a workaround, since it has not resolve the issue completely.
>>> I just move the speed/duplex/pause etc into .mac_config callback,
>>> there are other configurations in .mac_link_up callback which also
>>> need to be initialized to work for specific functions.
>>
>> NAK. Please read the phylink documentation. speed/duplex/pause is undefined
>> in .mac_config.
> 
> Speed/duplex/pause also the field of " struct phylink_link_state", so these can be refered in .mac_config, please
> see the link which stmmac did before:
> https://elixir.bootlin.com/linux/v5.4.143/source/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c#L852
> 
> 
>> I think the problem here is that you're not calling phylink_stop() when WoL is
>> enabled, which means phylink will continue to maintain the state as per the
>> hardware state, and phylib will continue to run its state machine reporting the
>> link state to phylink.
> 
> Yes, I also tried do below code change, but the host would not be wakeup, phylink_stop() would
> call phy_stop(), phylib would call phy_suspend() finally, it will not suspend phy if it detect WoL enabled,
> so now I don't know why system can't be wakeup with this code change.
> 
Follow-up question would be whether link breaks accidentally on suspend, or whether
something fails on resume.When suspending, does the link break and link LEDs go off?
Depending on LED configuration you may also see whether link speed is reduced
on suspend.
struct net_device has a member wol_enabled, does it make a difference if set it?

> @@ -5374,7 +5374,6 @@ int stmmac_suspend(struct device *dev)
>                 rtnl_lock();
>                 if (device_may_wakeup(priv->device))
>                         phylink_speed_down(priv->phylink, false);
> -               phylink_stop(priv->phylink);
>                 rtnl_unlock();
>                 mutex_lock(&priv->lock);
> 
> @@ -5385,6 +5384,10 @@ int stmmac_suspend(struct device *dev)
>         }
>         mutex_unlock(&priv->lock);
> 
> +       rtnl_lock();
> +       phylink_stop(priv->phylink);
> +       rtnl_unlock();
> +
>         priv->speed = SPEED_UNKNOWN;
>         return 0;
>  }
> @@ -5448,6 +5451,12 @@ int stmmac_resume(struct device *dev)
>                 pinctrl_pm_select_default_state(priv->device);
>                 if (priv->plat->clk_ptp_ref)
>                         clk_prepare_enable(priv->plat->clk_ptp_ref);
> +
> +               rtnl_lock();
> +               /* We may have called phylink_speed_down before */
> +               phylink_speed_up(priv->phylink);
> +               rtnl_unlock();
> +
>                 /* reset the phy so that it's ready */
>                 if (priv->mii && priv->mdio_rst_after_resume)
>                         stmmac_mdio_reset(priv->mii);
> @@ -5461,13 +5470,9 @@ int stmmac_resume(struct device *dev)
>                         return ret;
>         }
> 
> -       if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> -               rtnl_lock();
> -               phylink_start(priv->phylink);
> -               /* We may have called phylink_speed_down before */
> -               phylink_speed_up(priv->phylink);
> -               rtnl_unlock();
> -       }
> +       rtnl_lock();
> +       phylink_start(priv->phylink);
> +       rtnl_unlock();
> 
>         rtnl_lock();
>         mutex_lock(&priv->lock);
> 
> 
>> phylink_stop() (and therefore phy_stop()) should be called even if WoL is active
>> to shut down this state reporting, as other network drivers do.
> 
> Ok, you mean that phylink_stop() also should be called even if WoL is active, I would look in this direction since
> you are a professional.
> 
> Thanks.
> 
> Best Regards,
> Joakim Zhang
> 

