Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5681DA49D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgESWeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:34:18 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1CBC061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:34:18 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id w18so1063065ilm.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CaRkP3UVco1eYbOb45iy0pcdh5Erm+X91QUxytna5s4=;
        b=J9li/2OB6UhQK1xc7DMK2x+uy8xwowCv2GGmWr04NYiul+JA9KnET0HXz6Mh5YvMFu
         x0yd9vMXhjpbTr3BlKemle/c/gzzZtv7RrLjj2AvzSVxwHUpiwrv/vbQkFRyocSIM0BD
         kUoVenQgz/d4X8wbGAzSu2w3tNfYwGd37o7wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CaRkP3UVco1eYbOb45iy0pcdh5Erm+X91QUxytna5s4=;
        b=cUx3klrzYc0OJi/cKEwDhruF0rMPZMs/FIg9GX34f+Diw2g3ZCUyt6Iz4st0510Bce
         7ModwpMFGilnOeBaU0yv0GiyZl2ychOKgxf5l+ycvd3K9HpcrLGP95JLoGWIViCAUg/L
         2UDsSEh3rcI2iVpL2/pv2NElelMIZwpm2KDoHT54caK4Dut84DaHfvhnTWjy+RiC86Cx
         RPYTMTu0SFS/HyDXkeZ9Hy1EVzb9LcPCVzAWG7cjzWta9qB0Qbuh/N+c9qFdetF86Wi0
         8bDIZImZcIWJZDWiS+NMNIE3t5mQL7H0dQLZQ/Fq0v2hdd5ZLYAZixSFKKeDFlRIskSJ
         OPEA==
X-Gm-Message-State: AOAM532Uw/g2zRmgfb3T37bPBKZkqp9zQwEMqq+cz0PjRHdyhvhkVAid
        WfpIgjUAHH5mAfGUQLYQRTxYFg==
X-Google-Smtp-Source: ABdhPJyP9BOtiskavMevb/CA6I//GtbaO2XggYmKi6uXXaGEDsOqr7X/QlDrScJtyOVGhCnywIPB3A==
X-Received: by 2002:a92:1906:: with SMTP id 6mr1336361ilz.144.1589927658051;
        Tue, 19 May 2020 15:34:18 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id j90sm366254ilg.70.2020.05.19.15.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 15:34:16 -0700 (PDT)
Subject: Re: [PATCH v2 10/15] soc: qcom: ipa: use new
 module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Elder <elder@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-11-mcgrof@kernel.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <0b159c53-57a6-b771-04ab-2a76c45d0ef4@ieee.org>
Date:   Tue, 19 May 2020 17:34:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515212846.1347-11-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/20 4:28 PM, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.

I don't fully understand what this is meant to do, so I can't
fully assess whether it's the right thing to do.

But in this particular place in the IPA code, the *modem* has
crashed.  And the IPA driver is not responsible for modem
firmware, remoteproc is.

The IPA driver *can* be responsible for loading some other
firmware, but even in that case, it only happens on initial
boot, and it's basically assumed to never crash.

So regardless of whether this module_firmware_crashed() call is
appropriate in some places, I believe it should not be used here.

					-Alex

> 
> Cc: Alex Elder <elder@kernel.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/net/ipa/ipa_modem.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
> index ed10818dd99f..1790b87446ed 100644
> --- a/drivers/net/ipa/ipa_modem.c
> +++ b/drivers/net/ipa/ipa_modem.c
> @@ -285,6 +285,7 @@ static void ipa_modem_crashed(struct ipa *ipa)
>   	struct device *dev = &ipa->pdev->dev;
>   	int ret;
>   
> +	module_firmware_crashed();
>   	ipa_endpoint_modem_pause_all(ipa, true);
>   
>   	ipa_endpoint_modem_hol_block_clear_all(ipa);
> 

