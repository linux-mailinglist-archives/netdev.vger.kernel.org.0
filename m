Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A06F4F8A29
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiDGUhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiDGUge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:36:34 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A836E3504BF;
        Thu,  7 Apr 2022 13:22:37 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-deb9295679so7632492fac.6;
        Thu, 07 Apr 2022 13:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GL024EHLCvS8dnozzMQ56WfmDimIW5TcE1qTTBNk/s8=;
        b=hd7GyslZBarUC+ukRuDQjCfp1ExoxfztGgafhX3UBGvCrzBTClTw+qUO2W0kWc2E97
         vOJh2HglV2VQ8i4PnY7Zy3zoHXvetLiBDNbQmUJCIPxvpLg2sqh5MhCIUzUIlmHWPhWQ
         3sXDcZblEmtmPWl8OTVELDuSTt5yh8ut2MI0bKVTWspyVliE4M8MWfQVMgDUWehf9/tL
         zpFK9W1FcmGv4U0Hw/DlL7FBBMpYjS7BocGaVZ3LjgsVZVG/34EJEHjahQ7hJgQQQ6pu
         4E4jPRlg1+jmecqgiUT+jUBk1ldUYwxRtNpjAlKudrKm6WEY4mQaMiRG7lJrYewq8bH0
         7YAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GL024EHLCvS8dnozzMQ56WfmDimIW5TcE1qTTBNk/s8=;
        b=NoedYNQ0hWOJF4u4Z3KRp2cq/KXzmtRyIB2pSpEOnmL59cj2RUbepVmulgY/1DFezg
         xqkZYxY0CFdzPMU+8Qu7AWfBNJyXDQGuKNpbnFhHiRKCQO/OYWlPNWAqbFrxxiDDuFR/
         lE7nZ0YGLJQ4W7n9sSJAHmuAOBDbpAXOs0gK9l9bB6/SbYkOQeOCDmzHq6djdgjkwlni
         g9hvKDiQcWiPKa8UWxMIpet2yZNj8Z/0xbidumC0owZrpmv/vqkq10Y/uQlC4ieH8Fu6
         NsofH0zVRRUtMsU0mnIlCc94qJm+bfpauVXWNkOxACL0i03ySIftjItdbFt6gZTYiExb
         p7ig==
X-Gm-Message-State: AOAM533Am0cyeGF1sa/T0hdBQh6FaXxi7AjwbD8qcm6QCAB1+8T+I4My
        hGE9zqGp0HzxNv2LYKpf+BQGCzawRjc=
X-Google-Smtp-Source: ABdhPJyZsHy1jNxMa0iBVyQSkqlcDamuVAW3MTGeAKFTE0GXUR2s6xDXJJHxvfJMWByG7gIA1S/scg==
X-Received: by 2002:a05:6871:29a:b0:e2:639f:6dfa with SMTP id i26-20020a056871029a00b000e2639f6dfamr2761659oae.234.1649361029344;
        Thu, 07 Apr 2022 12:50:29 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v33-20020a056870b52100b000e1efaa5fecsm5579373oap.19.2022.04.07.12.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:50:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5b361192-6fd4-e84d-d6fc-e552a473c23e@roeck-us.net>
Date:   Thu, 7 Apr 2022 12:50:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
Content-Language: en-US
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Johannes Berg <johannes.berg@intel.com>
References: <20220406153410.1899768-1-linux@roeck-us.net>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220406153410.1899768-1-linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/6/22 08:34, Guenter Roeck wrote:
> In Chrome OS, a large number of crashes is observed due to corrupted timer
> lists. Steven Rostedt pointed out that this usually happens when a timer
> is freed while still active, and that the problem is often triggered
> by code calling del_timer() instead of del_timer_sync() just before
> freeing.
> 
> Steven also identified the iwlwifi driver as one of the possible culprits
> since it does exactly that.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API support")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> RFC:
>      Maybe there was a reason to use del_timer() instead of del_timer_sync().
>      Also, I am not sure if the change is sufficient since I don't see any
>      obvious locking that would prevent timers from being added and then
>      modified in iwl_dbg_tlv_set_periodic_trigs() while being removed in
>      iwl_dbg_tlv_del_timers().
> 

I prepared a new version of this patch, introducing a mutex to protect changes
to periodic_trig_list. I'd like to get some feedback before sending it out,
though, so I'll wait until next week before sending it.

If you have any feedback/thoughts/comments, please let me know.

Thanks,
Guenter

>   drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> index 866a33f49915..3237d4b528b5 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> @@ -371,7 +371,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
>   	struct iwl_dbg_tlv_timer_node *node, *tmp;
>   
>   	list_for_each_entry_safe(node, tmp, timer_list, list) {
> -		del_timer(&node->timer);
> +		del_timer_sync(&node->timer);
>   		list_del(&node->list);
>   		kfree(node);
>   	}

