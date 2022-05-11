Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F67C523593
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbiEKOdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiEKOdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:33:06 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475EF5AEEC
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:33:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c9so2079212plh.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 07:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=i2EByjGZ9HI2c2OzDKOZTrB+hBnpluOldry07PZevUg=;
        b=SmaF9bFKBqMRmF3lhfm0cRxAdhuoAyfQO6hfpBu9aYxYTvKKbQ0GfYFmNNzE7zp/SA
         zMyKxy14VvELOCeLbGJKW186BQCjdLSDB0gLO+mxZ0nMv1ez4IkX3yqfTtZmp+asiCez
         Y8LoFwsv54QZbjJJZ8V59jnhCcGnmk80r7Rqk+dBza1VwNDTySQyKgqode0tr+xlA4h2
         FWa0YgwiFziqcNnGBs/GO1bCAh34y74N1OSgIEfVbyYwXst20FIsQNO3JvDMoxnbHBUe
         +SdzGTHWmLy86vw3ebdCF0sk13Y3YdAmm/PnQ8MsEm8ye56c0f92qLacy1g3v5KmZixC
         6r+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=i2EByjGZ9HI2c2OzDKOZTrB+hBnpluOldry07PZevUg=;
        b=39sifgdUwqpXLbJNMuvDWrbqE38Hv38zixCpEYaS5HwTOTpWDyg5k5LvPI30jjHmJq
         j0wds4BudGCSnRXeap7hIBwGsva6UQCc9jkWOxPOgMC/z+AzlO6nHqLyYaXxfEOK7sCr
         N9Uw7P1JmFzCLZU9ovS1zM3Y6ilx9bNqitchNrCykKAsb6PthiInOBALAnC5Py+68+IW
         UUtTcsEah7Xrb7SrGiGQ1giWWyJzO69SfKEPk8Md5Ux3K89DHzrdAIi7SOdiahXQBEoI
         oYaZgVcucA+Rr7RgIH5Jts0kiy7JansHvjGYq3fS3pr9nqC9I0IjJH1slsepRogo3Rap
         Tn1A==
X-Gm-Message-State: AOAM533qTER77eNwNKgQ1pjD2pnO61TyaWu8QAFuEHhLzC9DX/iS5qTW
        PDxBIeVE1BbZyDrtNxrljmE=
X-Google-Smtp-Source: ABdhPJyWeMZ2KvoN0ZXm05z9fjpBXCpc59SjKzvIi+KH1ZaBXhaAL5UtR8FrN1PwGJ+i4sVwjGplxA==
X-Received: by 2002:a17:90b:3ecb:b0:1dc:5401:bea with SMTP id rm11-20020a17090b3ecb00b001dc54010beamr5680019pjb.20.1652279584581;
        Wed, 11 May 2022 07:33:04 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.30])
        by smtp.googlemail.com with ESMTPSA id o6-20020a17090a420600b001cd498dc153sm2704554pjg.3.2022.05.11.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 07:33:03 -0700 (PDT)
Message-ID: <ad8cf673c8e9e21cb2e7afeb5c7e66cc76a36995.camel@gmail.com>
Subject: Re: [PATCH] =?UTF-8?Q?igb=5Fmain=EF=BC=9AAdded?= invalid mac
 address handling in igb_probe
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     lixue liang <lianglixue@greatwall.com.cn>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org
Date:   Wed, 11 May 2022 07:33:02 -0700
In-Reply-To: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
References: <20220511080716.10054-1-lianglixue@greatwall.com.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-11 at 08:07 +0000, lixue liang wrote:
> In some cases, when the user uses igb_set_eeprom to modify
> the mac address to be invalid, the igb driver will fail to load.
> If there is no network card device, the user must modify it to
> a valid mac address by other means. It is only the invalid
> mac address that causes the driver The fatal problem of
> loading failure will cause most users no choice but to trouble.
> 
> Since the mac address may be changed to be invalid, it must
> also be changed to a valid mac address, then add a random
> valid mac address to replace the invalid mac address in the
> driver, continue to load the igb network card driver,
> and output the relevant log reminder. vital to the user.
> 
> Signed-off-by: lixue liang <lianglixue@greatwall.com.cn>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..a513570c2ad6 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	eth_hw_addr_set(netdev, hw->mac.addr);
>  
>  	if (!is_valid_ether_addr(netdev->dev_addr)) {

It might make sense to look at adding a module parameter to control
this behavior similar to what was done for ixgbe for
"allow_unsupported_sfp". 
Otherwise such a failure is likely to end up causing other issues and
be harder to debug if it is just being automatically worked around as
the user may not see the issue as it is only being reported as 

Basically you could check for it here and either run the old code, or
allow the new code that would assign a random MAC address.

> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		eth_random_addr(netdev->dev_addr);
> +		memcpy(hw->mac.addr, netdev->dev_addr, netdev->addr_len);
> +		dev_info(&pdev->dev,
> +			 "Invalid Mac Address, already got random Mac Address\n");

We would probably want to make this a dev_err instead of just a
dev_info since the MAC address failing is pretty signficant. Also the
message may be better as "Invalid MAC address. Assigned random MAC
address". That way if somebody were to be parsing for the message they
would still find it since "MAC" hasn't been changed.

>  	}
>  
>  	igb_set_default_mac_filter(adapter);



