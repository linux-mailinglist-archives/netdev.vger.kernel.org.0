Return-Path: <netdev+bounces-9228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A304728166
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:32:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 640851C20F08
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6DFA12B7F;
	Thu,  8 Jun 2023 13:32:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC1BA3A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:32:30 +0000 (UTC)
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10055268E;
	Thu,  8 Jun 2023 06:32:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-53f7bef98b7so385418a12.3;
        Thu, 08 Jun 2023 06:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686231148; x=1688823148;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKuPQbcDXEDTbQg5IlNEBVSbNApnUsiE30Zl4xCvysE=;
        b=a3ihC8Jb7VSgDNtee2BzJlhd02bP9qLThPAty1R/pUygyUp287UJWvu92ojdkZG+Pt
         hax6IUF7dkDqB2y3L+/YwEC/gjoy1YjXEeSttEZTcGgUt9K6MxDebjHmut6eYj1JThCK
         B7xvAlga9Ms+AKQD0aZIzSHPYtruGC1W1FYbXamdmjQZkj2AmNwmSimhDsJ3j19FxL7R
         8CkPX+tIouZbj1XvySlYvhZEgxyN3YdsbQumztVJysdxwLAo5VuntQmV+6/4nhMhGKZP
         Jfwhd9iO9ZEeKbshNwgSW/Tm9kDec4qP6d9wtYWJ0WV7i1rewZxBoyfIGdikdW9hzITR
         fB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686231148; x=1688823148;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mKuPQbcDXEDTbQg5IlNEBVSbNApnUsiE30Zl4xCvysE=;
        b=UcD1cmkyx9VdVcNTX/M03vpIhBu+XPkySWPhbhAPba3ySRhLoGmiy2eCj3wFt/vhz0
         foFLfzJBoiXmfzXc7Q9YjJnWlLg5i0hOMONAQ9Hi2T3h2MtXKukafyf8jRFVVpzFkh6G
         DQFNbBQ0EEkNAR4SRosW8sbJKuoIPYAK6sL15DmKfRccHSQDTTG8LdOKp0ygJuFIPtz3
         oFceow79MJkrC99s8p03gCm2+wEi9JTFLkKrb9F7NEzWMJsuB7ioz7fC9rhQVoI/1OtW
         sufqRIBSrP4q/DJJlNkoEI/6VZZoMFeG9iBgywArNeeX1ifi6rrZaBk+rmveH1ATocSl
         OZeA==
X-Gm-Message-State: AC+VfDxobuOE/ANH5szsbwX/mL0PTvK8nGG0E0Snn5rki5VkumSaKA6e
	uqPr2i+eMhwQGofUdiRLgXo=
X-Google-Smtp-Source: ACHHUZ7PHGRSAoYcpZ8O6w/mA3Ym2Zk5KMOPorRkI6kVX3bVOimkaVaG+sK9sm4Vo/S2Imo6sPIBew==
X-Received: by 2002:a17:90a:8417:b0:256:c632:9848 with SMTP id j23-20020a17090a841700b00256c6329848mr7532847pjn.29.1686231148298;
        Thu, 08 Jun 2023 06:32:28 -0700 (PDT)
Received: from [192.168.43.80] (subs09a-223-255-225-66.three.co.id. [223.255.225.66])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a191e00b0025632363477sm1379148pjg.14.2023.06.08.06.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 06:32:27 -0700 (PDT)
Message-ID: <31ab2156-e93e-4e0d-73a7-313d9d24ee6b@gmail.com>
Date: Thu, 8 Jun 2023 20:32:22 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Content-Language: en-US
To: Jes Sorensen <Jes.Sorensen@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 dbnusr495 <se6gtm+8fyzh7983xt40@guerrillamail.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: rtl8xxxu kernel module deauthenticate session from public open
 Wifi AP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I notice a bug report on Bugzilla [1]. Quoting from it:

> With Debian Sid, trying to use two different Realtek USB Wifi Adapters (with
> Antenna).
> 
> Using kernels including various Liquorix 6.2.x, 6.3.x , and the most recent
> 
>     linux-image-6.3.4-1-liquorix-amd64
> 
> also, Debian experimental
> 
>     Debian (experimental) linux-image-6.3.0-0-amd64-unsigned
> 6.3.5-1~exp1
> 
>     Debian's linux-image-6.3.0-0-amd64 (Linux  6.3.0-0-amd64 #1 SMP
> PREEMPT_DYNAMIC Debian 6.3.2-1~exp1 (2023-05-15) x86_64 GNU/Linux)
> 
> same problem.
> 
> At local library's public open wifi, no password required.  Using either
> 
>     0bda:0179 (rtl8188eu) USB Wifi adapter,
> 
> or
> 
>     0bda:f179 (rtl8188fu) USB Wifi adapter
> 
> Both adapters are loading
> 
>     rtl8xxxu kernel module
> 
> Using ( manual Wifi connection ) script , the system was able to obtain DHCP IP
> address.  Normally, all HTTP(S) requests get redirected to a public usage
> policy web page, where users have to click on "I agree" to continue.  Which
> works fine with another USB adapter (mt7601 kernel module).
> 
> However, with both Realtek adapters above, web browser will just time out, will
> NOT even get redirect to a "Public Use Notice" web page.
> 
> The relevant error message from system log shows
> 
>     2023-05-15T16:57:48.491567-04:00 usrhostname kernel: wlan1: deauthenticated
> from 7a:83:c2:8a:f1:13 (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> 
> Apparently, the rtl8xxxu driver assumes an error condition, and immediately
> deauthenticates and drops the Wifi connection, will not complete the
> redirection to the "Public Use Notice" web page.
> 
> Try to connect again, same problem, repeating itself, not allowing any
> additional wifi traffic at all.

See Bugzilla for the full thread.

The reporter said that this is known rtl8xxxu issue (unusable on public,
open WiFi access points [no WPA authentication?]). From his analysis:

> Let me know if I need to do anything else.  I looek at the code briefly, I belive the rtl8xxxu called a function from 802.11 layer to handle the return code (Reason code 6), which promptly call a function to deauthenticate the session, thus disconnected the device from further wifi traffic.
> 
> I believe the 802.11 level handling is too harsh for public open AP.  However, i think the Realtek level code is too lazy.  Realtek driver code should check for reasonable return codes for situations like this and allow paasing at least a few of these before considering these as hacking attempts, which require deauthenticating, or disconnecting.  But then again, this would also be too strict for monitor mode handling of traffic.
> 
> Don't know if 802.11 level specs even have considerations for situations like these at all, or they simply handle lower level logic and leave these things for the device drivers to cooperate with application layers to handle these.

Jes and Kalle, would you like to take a look on checking return codes
(as reporter demands)?

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217531

-- 
An old man doll... just what I always wanted! - Clara

