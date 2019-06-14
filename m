Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9F545907
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFNJnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:43:07 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44284 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfFNJnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:43:06 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so1685359ljc.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JPxBfDG20FU9CqI51n1357gs3Z2Yy4u9KLpOGzScF4I=;
        b=guEX7RPm4dNVjkrnL0euryYs6K0RiV87XT8kWFh7vdk0qQ4D/sW0cXE7C2faPR8aEh
         PQajMR26RkClfMB/sUKJD635o70Bp2ysCY2SeMKcKWrRWn/rJYYVA49uAQP0Mu/dMCCM
         /LPtnVg/TrAnocViqcjHCPniJrvmz1weDT36CW1+Z+E+Oyx6+VRQGxceWft+3aTy6YZL
         L+1cSIyltQyXCCK1ijWa827Fa2aoNSSo95Th3IBp4oskItIV5m5mGUOZS3NsuKT9oHDa
         XhjGk0L24YXZEOzGvCQt8Pco0iLj889f3+sjeckm6HbuEJQxiTxugiTJPzRnyXZCcoiQ
         2qBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JPxBfDG20FU9CqI51n1357gs3Z2Yy4u9KLpOGzScF4I=;
        b=Ff1VX3COnvXYf5tfuuPzJsQoDhElFATZ63XqiA83Y2b2dvk9UGjaALdifHruF9yjB5
         KEmIPEpkVb7BNBufPhmGVst9/Gp6ZhC4uHnN5PoFntOnISStuFgUynjO13wWhC7AYrfb
         843CKlzZDv62ZceAWmeRqh0ltvx+ACmmGjbjZQCHOTM43U74wHKJ96r9YN0cWBfyNcrs
         Hsw3EGQa0vwJ8o/LeNQT5Nq87AiQcGrPWcGXx0VJzr0HVWMvQR1n1q9Zyc9r45u1U98U
         i5/VxtDhtMIsDprm1Cy9HTf1L+qVPGDCXcMyLEu3jJP4pxkB89B46AogRndW66TUrS+k
         h60g==
X-Gm-Message-State: APjAAAUQ56IfebudU/F7nQhTGKt9FME4u+Jd8heEeoMsNtGHhXkBK9Mz
        1gYP4rACYR+yTerGSSc/Vey41g==
X-Google-Smtp-Source: APXvYqyPjoKYZc7D7OtfeEj8NDO4IEUq1/77X1lFRq0bKCZ20/Y7r5P4s1W79ajD/9mYxiOPafK4WA==
X-Received: by 2002:a2e:8741:: with SMTP id q1mr22349489ljj.144.1560505384714;
        Fri, 14 Jun 2019 02:43:04 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.84.143])
        by smtp.gmail.com with ESMTPSA id p27sm400771lfh.8.2019.06.14.02.43.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:43:04 -0700 (PDT)
Subject: Re: [net-next 08/12] i40e: Missing response checks in driver when
 starting/stopping FW LLDP
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Piotr Marczak <piotr.marczak@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
 <20190613185347.16361-9-jeffrey.t.kirsher@intel.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <4157b306-b663-e20a-8c24-2d91a049e7fb@cogentembedded.com>
Date:   Fri, 14 Jun 2019 12:42:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613185347.16361-9-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 13.06.2019 21:53, Jeff Kirsher wrote:

> From: Piotr Marczak <piotr.marczak@intel.com>
> 
> Driver did not check response on LLDP flag change and always returned
> SUCCESS.
> 
> This patch now checks for an error and returns an error code and has
> additional information in the log.
> 
> Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>   .../net/ethernet/intel/i40e/i40e_ethtool.c    | 27 +++++++++++++++++--
>   1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> index 7f7d04ab1515..0837c6b3e15e 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
[...]
> @@ -5013,7 +5015,28 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
>   			dcbcfg->pfc.willing = 1;
>   			dcbcfg->pfc.pfccap = I40E_MAX_TRAFFIC_CLASS;
>   		} else {
> -			i40e_aq_start_lldp(&pf->hw, false, NULL);
> +			status = i40e_aq_start_lldp(&pf->hw, false, NULL);
> +			if (status) {
> +				adq_err = pf->hw.aq.asq_last_status;
> +				switch (adq_err) {
> +				case I40E_AQ_RC_EEXIST:
> +					dev_warn(&pf->pdev->dev,
> +						 "FW LLDP agent is already running\n");
> +					return 0;
> +				case I40E_AQ_RC_EPERM:
> +					dev_warn(&pf->pdev->dev,
> +						 "Device configuration forbids SW from starting the LLDP agent.\n");
> +					return (-EINVAL);

    () not needed. None was used above, so why have them here?

> +				default:
> +					dev_warn(&pf->pdev->dev,
> +						 "Starting FW LLDP agent failed: error: %s, %s\n",
> +						 i40e_stat_str(&pf->hw,
> +							       status),
> +						 i40e_aq_str(&pf->hw,
> +							     adq_err));
> +					return (-EINVAL);

    Neither they are needed here...

[...]

MBR, Sergei
