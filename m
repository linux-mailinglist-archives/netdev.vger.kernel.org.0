Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3013631B09
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 11:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfFAJqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 05:46:20 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42983 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfFAJqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 05:46:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id g24so9016146eds.9
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 02:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tSsKXdWyr9956QXBLc6FC40QH+hW74E8BR8lfXDZYqg=;
        b=N/xCIA8JrsOYscAw+s5WXhu2fm1sb7FSTevQ2el7meloaEC/qKXQjaFGOmqiyvfC0E
         vAKFjFLsa5b7wSZ1JYvQikWU/2sqwV4AkxgmfhD6k9g4WnXVfeZnAvVBGgHxKHHLwGCI
         2EzbzZ4YsgCE2MgA+wVGrtLXi7Eicr6To7eYp3hcqnl3DybkMh68rYa7ZINKgktVdce8
         VfX6OnCT/U/lhVD4Tt4Cxjl3jOadsrZIuek9IaqKasFaoYBAAhaUpB0pqQKxNbM3nFvp
         cGInKJcpjVIdd7xXS3pKkERGc51pm59NAJDYqecMrfT21jxfUjYtUwSiZn9CM83kDr6f
         MVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tSsKXdWyr9956QXBLc6FC40QH+hW74E8BR8lfXDZYqg=;
        b=Ts5POzP6NiwrUupssUT1F63DGH5TS6ivCI2rmxElFiXtf1KyCajcdpWXVB9Z2ticby
         fE7LLAVvWvvSkOZ8psme0WuXrkqJA1eqpVlwK+GTvVS3MbDAep2Qsop6Llu7/NKPIRAI
         VgMrmNWPH7M9pQNdsuY5ZHIkso8+kp70TqSrvqhhGOASLp9kKTMkDTICwMGHFIRzHskd
         OIMVB/vgz5ZEEpYtXPDCAixSHS0l5RZFYTvp4G7ndL3hyArl9Np6tppGcFYcKCfQPLIi
         lCSwwuqTLY+ZXeUS7N7yBw8LiZvrghmcmpAjo/jpJmezU0OUx+XtxvS7yFDjcsxswpLi
         jULw==
X-Gm-Message-State: APjAAAXVSSW3GZLsC4x8Sp7dtgtV+5eac/HTEAN7XYOaALHzBGxXq7KY
        lQm/qRJH3Ne+HmfvWpudd4BpuxeDAc+pXMvoy6w=
X-Google-Smtp-Source: APXvYqwFbmZjFhA46NshM+CUw08gHUVZIUhRd+5nG+T/djJNqLG9pWIR507V3I69cZoj5N7pYYc5rA==
X-Received: by 2002:a50:fa99:: with SMTP id w25mr1767917edr.231.1559382378530;
        Sat, 01 Jun 2019 02:46:18 -0700 (PDT)
Received: from [10.104.24.142] ([78.31.204.6])
        by smtp.gmail.com with ESMTPSA id m9sm1843776edr.7.2019.06.01.02.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Jun 2019 02:46:17 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: phylink: add fallback from SGMII to
 1000BaseX
To:     Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3e14a072-07c7-d7e0-a6ef-26643b0bb21b@cogentembedded.com>
Date:   Sat, 1 Jun 2019 12:46:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559330285-30246-4-git-send-email-hancock@sedsystems.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 31.05.2019 22:18, Robert Hancock wrote:

> Some copper SFP modules support both SGMII and 1000BaseX, but some
> drivers/devices only support the 1000BaseX mode. Currently SGMII mode is
> always being selected as the desired mode for such modules, and this
> fails if the controller doesn't support SGMII. Add a fallback for this
> case by trying 1000BaseX instead if the controller rejects SGMII mode.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>   drivers/net/phy/phylink.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 68d0a89..4fd72c2 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
[...]
> @@ -1663,6 +1665,25 @@ static int phylink_sfp_module_insert(void *upstream,
>   
>   	config.interface = iface;
>   	ret = phylink_validate(pl, support, &config);
> +
> +	if (ret && iface == PHY_INTERFACE_MODE_SGMII &&
> +	    phylink_test(orig_support, 1000baseX_Full)) {
> +		/* Copper modules may select SGMII but the interface may not
> +		 * support that mode, try 1000BaseX if supported.
> +		 */
> +
> +		netdev_warn(pl->netdev, "validation of %s/%s with support %*pb "
> +			    "failed: %d, trying 1000BaseX\n",

    Don't break the messages like this, scripts/checkpatch.pl shouldn't 
complain about too long lines in this case.

[...]

MBR, Sergei
