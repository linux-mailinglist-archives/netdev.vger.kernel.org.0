Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598DE4AC4FA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiBGQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386922AbiBGQCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:02:17 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC5C0401CE;
        Mon,  7 Feb 2022 08:02:16 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d187so13693608pfa.10;
        Mon, 07 Feb 2022 08:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=IDP7xcaBu/BjbI3M/dHvzrRQkC76UiHakyHIGFZDn0w=;
        b=f5mnubI/HXS3OW7L+u1hGknGy03vHcdyrktKYxn4h3XZdEvkISPsdzwnab+lZjRONE
         J3sSmU6SH5rGMI4xurcPCRmp+1DqaOpM4XPgfpti04/12ZSMmVpTlYUhEBZUl+UUf7M9
         Lfy1W/vlTmA+e12dl3/zpxIfNo/GOsGXCv5lOkKImX34px3bv5uaJ2iqGcPVsaSip69R
         HjzRUS9ytP1b2LqE2kBBo+RtFGAzJWqCshtGk6gdXWgZmUP7TmgirpHA2Of5yOBaGfqe
         GsHRxtj5b2XsWXJVpUkYbWOWoFGlUozSeidhRjqGEH3Z7wTZzP34goYJDkCqaxJqiZnD
         c+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=IDP7xcaBu/BjbI3M/dHvzrRQkC76UiHakyHIGFZDn0w=;
        b=HiIefofHCBNr2lWITjjxPvcod7mk/V0YAq3Xq9B01n8GnuLLbqD7OqLHNHj1FOe5Mk
         rxhlIlnk/P3X30eqt9JfPz6MGCZHCgKMcC5e5plGx7TLilv2IZZvXAjCHTXUj+dwLZVm
         Lw65sdRU2M+hCM78jIdmQDlQ++RdkjWF5R8Yqb+FPbWxyknizmj+3IpfeUh23da23R1L
         LCfykfOEVgtqhI0k+0rD9fx0Yl+izk6pI7TFETjyXOq7Hhn4XxFI4duJN0SGlMGoYOpu
         yUj2Lt4Kni/B8cUHH7RIY+dbTMLVPJ6V/npjy4rOPPA5R0CzIv3ZVNSLzbHoDXSJVr3K
         VXSA==
X-Gm-Message-State: AOAM530yZpkFO78Xw3UcHAtp5BpG1euVZ3Cj1S7EBC9iF/jl6I329anQ
        22Rx6WdNs8ExK2NijBhPj/HphGZSHeb0LQ==
X-Google-Smtp-Source: ABdhPJwt9sCEmVWex/KrxVf6HDJS+EckYkCgKOO6id3rD2Q2rqB1kPGQSF8ejjauek6IViTtbD8uPw==
X-Received: by 2002:a05:6a00:1a16:: with SMTP id g22mr53263pfv.81.1644249736462;
        Mon, 07 Feb 2022 08:02:16 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id a3sm12221624pfk.73.2022.02.07.08.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:02:15 -0800 (PST)
Message-ID: <cf81c699-77ef-651d-18d0-7d8182452ff4@gmail.com>
Date:   Tue, 8 Feb 2022 00:02:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     pizza@shaftnet.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] cw1200: possible deadlock involving three functions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports a possible deadlock in the cw1200 driver 
in Linux 5.16:

cw1200_probe_work()
   mutex_lock(&priv->conf_mutex); --> Line 384 (Lock A)
   wsm_flush_tx()
     wait_event_timeout(priv->bh_evt_wq, ...) --> Line 1208 (Wait X)

cw1200_bh()
   wait_event_interruptible(priv->bh_wq, ...) --> Line 524 (Wait Y)
   wake_up(&priv->bh_evt_wq); --> Line 534 (Wake X)

cw1200_do_join()
   mutex_lock(&priv->conf_mutex); --> Line 1238 (Lock A)
   wsm_unlock_tx()
     cw1200_bh_wakeup()
       wake_up(&priv->bh_wq); --> Line 119 (Wake Y)

When cw1200_probe_work() is executed, "Wait X" is performed by holding 
"Lock A". If cw1200_bh() is executed at this time, because "Wait Y" is 
performed, "Wake X" cannot be performed to wake up "Wait X". If 
cw1200_do_join() is executed at this time, because "Lock A" has already 
been hold, "Wake Y" cannot be performed to wake up "Wait Y".
I find that "Wait X" is performed with a timeout, to relieve the 
possible deadlock; but I think this timeout can cause inefficient execution.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)

Best wishes,
Jia-Ju Bai

