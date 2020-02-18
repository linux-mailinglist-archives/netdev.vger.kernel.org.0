Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0A1623B9
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgBRJoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:44:03 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38417 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgBRJoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:44:03 -0500
Received: by mail-lj1-f195.google.com with SMTP id w1so22150971ljh.5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 01:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xXmwuNNnN+ad/dmuTuvRQ+NXZYB3cMUttaegMQhBnLU=;
        b=nb2tVAWLGloVhrpcH+1tLLiB1wzYyd5PrnuKYSwfGIdCBQNrmv9uI2ZrAvA4wZVjpU
         SSxyAr06sl8/jK8zW/oG4PLIlfCYQOk/t8Nn6tvNfew/hTMauMaLR+YMi8SFuJpUoB46
         Oqiuy2m61WvrpYCRi+pN+1gl4aSw175LMi4EOVTrYZhbt6qNpFIsIHQEQSN+I857ePEq
         PeTDiYtnfaBL+sPYUF4sNHLPl0nUj7WT9JdynT53iVUtxIZH0/kXu/fZFwtAzVCXYTAd
         zpgEYQ/vI6toc+GdL9NHnPm8wFCUL9XsFTgnDfGz3e8YHF7CDgZJyBfbT0TzsOUieDDn
         iKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xXmwuNNnN+ad/dmuTuvRQ+NXZYB3cMUttaegMQhBnLU=;
        b=sUv98kVx8QlFR9D9mSDjsPbV1WAMjY3sQy6bf6KFYjnTa3qt2ixPtyUxl2lw5AahPt
         U0Ky8h6K1NsygRbCNer88V/pSJLpVoyaBUW7FiTNyLIC4IObUIN7Dfhie7TKGq0Dhxmz
         +3kgTz00FlD2146hyVQLRAhZgM711scfR5kbq2+DTsZnORyFkiiovSzfZAGH2ChVLhs6
         Tyy+LHr3l29EsI2zDfdKO8Vp7IikUussBA4pIk61euKn4VXV8FQkhp/6sMGA8I+Md0FG
         TQavxMZM0tDs4vDTdIcRFe0BjtJHKQOfjOpruCfodE18aeR+1XfS44WoR1GODCi0U0a0
         D3Nw==
X-Gm-Message-State: APjAAAUyqugc2W8EV7DyfIASJ2J7s1dwis9gZ4iC/iyG33aOZlY0mRNq
        07IVcBg8dT8nhymv4CB9E8xlqg==
X-Google-Smtp-Source: APXvYqy9dc9FHnjzy5R+4aUwrOjgQtHVjzWJ8LXwZVezAgnc/Hdx0Gz871eIYbtqAZPAwGJGrWKCFg==
X-Received: by 2002:a2e:88c4:: with SMTP id a4mr12634394ljk.174.1582019041456;
        Tue, 18 Feb 2020 01:44:01 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4ca:678e:4969:cd4e:2383:27e8? ([2a00:1fa0:4ca:678e:4969:cd4e:2383:27e8])
        by smtp.gmail.com with ESMTPSA id f29sm2016567ljo.76.2020.02.18.01.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 01:44:00 -0800 (PST)
Subject: Re: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net,
        linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com
References: <20200217233518.3159-1-hauke@hauke-m.de>
 <20200217233518.3159-3-hauke@hauke-m.de>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <2a6b9908-44d8-3c81-4b44-be1e5568a567@cogentembedded.com>
Date:   Tue, 18 Feb 2020 12:43:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200217233518.3159-3-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 18.02.2020 2:35, Hauke Mehrtens wrote:

> My system printed this line every second:
>    ag71xx 19000000.eth eth0: Link is Up - 1Gbps/Full - flow control off
> The function ag71xx_phy_link_adjust() was called by the PHY layer every
> second even when nothing changed.
> 
> With this patch the old status is stored and the real the
> ag71xx_link_adjust() function is only called when something really
> changed. This way the update and also this print is only done once any
> more.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> ---
>   drivers/net/ethernet/atheros/ag71xx.c | 24 +++++++++++++++++++++++-
>   1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 7d3fec009030..12eaf6d2518d 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -307,6 +307,10 @@ struct ag71xx {
>   	u32 msg_enable;
>   	const struct ag71xx_dcfg *dcfg;
>   
> +	unsigned int		link;
> +	unsigned int		speed;
> +	int			duplex;
> +
>   	/* From this point onwards we're not looking at per-packet fields. */
>   	void __iomem *mac_base;
>   
> @@ -854,6 +858,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>   
>   	if (!phydev->link && update) {
>   		ag71xx_hw_stop(ag);
> +		phy_print_status(phydev);
>   		return;
>   	}
>   
> @@ -907,8 +912,25 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>   static void ag71xx_phy_link_adjust(struct net_device *ndev)
>   {
>   	struct ag71xx *ag = netdev_priv(ndev);
> +	struct phy_device *phydev = ndev->phydev;
> +	int status_change = 0;
> +
> +	if (phydev->link) {
> +		if (ag->duplex != phydev->duplex ||
> +		    ag->speed != phydev->speed) {
> +			status_change = 1;
> +		}

    Do we really need {} here? There's only 1 statement enclosed...

> +	}
> +
> +	if (phydev->link != ag->link)
> +		status_change = 1;
> +
> +	ag->link = phydev->link;
> +	ag->duplex = phydev->duplex;
> +	ag->speed = phydev->speed;
>   
> -	ag71xx_link_adjust(ag, true);
> +	if (status_change)
> +		ag71xx_link_adjust(ag, true);
>   }
>   
>   static int ag71xx_phy_connect(struct ag71xx *ag)

MBR, Sergei
