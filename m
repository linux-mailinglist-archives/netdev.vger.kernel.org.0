Return-Path: <netdev+bounces-10567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4436272F175
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:15:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 974A42812B8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB8937E;
	Wed, 14 Jun 2023 01:15:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2AB7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 01:15:31 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CE41BEC;
	Tue, 13 Jun 2023 18:15:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-652d1d3e040so4707108b3a.1;
        Tue, 13 Jun 2023 18:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686705329; x=1689297329;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Qx8m0l5OukQyzZseritYmbm+wBilDwp6PVLNmtxjoI=;
        b=H74dI4jAg+9W8MW9L/inWX8URAO7fqd24702FyhtGOpHb2DJljdLQZjw5evS087UsE
         WNzJIJpTmAmFXj9l0mCNHNIervudP3x4Jr1JCv2vQQTdjwfiFagzaq25CsHbIVvk9MAM
         qlGCX8Hu/933RwtSR/3LJYSFk9RVMzciR+8o7QETLBVLmepXtGwAofv/Hc3APSrdf0Oa
         H/kjV7zykOQzTtOwfhktyXB0QvZTuRBhpiU9kvkQYbt42vyIrAqPyKSqhoowC7mIpqoH
         MpQ+Zh+ExjUJOktFhEZMaBPSkchSH7elhUqCpslJRF8FqoPAhIrDNqHBj9vN7hS3TVKa
         JeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686705329; x=1689297329;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0Qx8m0l5OukQyzZseritYmbm+wBilDwp6PVLNmtxjoI=;
        b=RTkjMO9ZCSIqu1hj9xhxkyOH0XadZqkalMSZddVRDnxc4DVY+DcsIvihTI9CPiFlam
         5+AKegmSc0y/Ojqz53lC/BfhUYoESxj5sXn+Z9rOolKTI6mZIbqGYpCl/PZGc0WAhDWa
         LYDPO0V4aGE0vYFBNN/rPeq2mZiLUWgcqwmXmwAKTFkZbaoRXNDqHw4xS15fADKHRt0s
         Vf7hlY8+EZ6pg7KKwTDAQ1TPfu9y5+TdegeYq0e4xkq+3DBPZIWSrUBCeTTovHrPyk5o
         j5V/9yciRWyjvzVUzlZfcwAejXnvnqKT0SLWXTXfubMQnqZckAz2eVCG80X52sSJGW4Q
         Vfuw==
X-Gm-Message-State: AC+VfDw7BK8+fw7lCFC9kVOzH4+k7sOkgidyui6WrSqZGBLN14F9p5JW
	XI7DMwB0v1gr1PM2cQXOFPw=
X-Google-Smtp-Source: ACHHUZ5DBMu8zSisl8h2f9Kwp+pIiWwmyc4Hge5VKLHTWvYmyBg/a5P6Qgx96/xwdB8jnW9DzMukCw==
X-Received: by 2002:a05:6a20:4426:b0:11a:efaa:eb3e with SMTP id ce38-20020a056a20442600b0011aefaaeb3emr362375pzb.33.1686705328722;
        Tue, 13 Jun 2023 18:15:28 -0700 (PDT)
Received: from [192.168.0.103] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902b58800b001a988a71617sm10837354pls.192.2023.06.13.18.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 18:15:28 -0700 (PDT)
Message-ID: <2db51694-aa57-cbfd-096e-4925b76232b0@gmail.com>
Date: Wed, 14 Jun 2023 08:15:24 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To: Kalle Valo <kvalo@kernel.org>, Thorsten Leemhuis <linux@leemhuis.info>,
 Garry Williams <gtwilliams@gmail.com>
Cc: Linux Atheros 10K <ath10k@lists.infradead.org>,
 Linux Wireless <linux-wireless@vger.kernel.org>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: Dell XPS 13 ath10k_pci firmware crashed!
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> Beginning with kernel 6.2.15-300.fc38.x86_64 and continuing through 6.3.7-200.fc38.x86_64, the wifi connection fails periodically with these log messages:
> 
> ath10k_pci 0000:02:00.0: firmware crashed! (guid 6c545da0-593c-4a0e-b5ad-3ef2b91cdebf)
> ath10k_pci 0000:02:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:143a
> ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 0 testmode 0
> ath10k_pci 0000:02:00.0: firmware ver WLAN.RM.4.4.1-00288- api 6 features wowlan,ignore-otp,mfp crc32 bf907c7c
> ath10k_pci 0000:02:00.0: board_file api 2 bmi_id N/A crc32 d2863f91
> ath10k_pci 0000:02:00.0: htt-ver 3.87 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
> ath10k_pci 0000:02:00.0: failed to get memcpy hi address for firmware address 4: -16
> ath10k_pci 0000:02:00.0: failed to read firmware dump area: -16
> ath10k_pci 0000:02:00.0: Copy Engine register dump:
> ath10k_pci 0000:02:00.0: [00]: 0x00034400  12  12   3   3
> ath10k_pci 0000:02:00.0: [01]: 0x00034800  14  14 347 348
> ath10k_pci 0000:02:00.0: [02]: 0x00034c00   8   2   0   1
> ath10k_pci 0000:02:00.0: [03]: 0x00035000  16  15  16  14
> ath10k_pci 0000:02:00.0: [04]: 0x00035400 2995 2987  22 214
> ath10k_pci 0000:02:00.0: [05]: 0x00035800   0   0  64   0
> ath10k_pci 0000:02:00.0: [06]: 0x00035c00   0   0  18  18
> ath10k_pci 0000:02:00.0: [07]: 0x00036000   1   1   1   0
> ath10k_pci 0000:02:00.0: could not request stats (-108)
> ath10k_pci 0000:02:00.0: could not request peer stats info: -108
> ath10k_pci 0000:02:00.0: failed to read hi_board_data address: -28
> ieee80211 phy0: Hardware restart was requested
> ath10k_pci 0000:02:00.0: could not request stats (-108)
> ath10k_pci 0000:02:00.0: device successfully recovered
> 
> 
> If I disconnect and reconnect using network manager, the connection is restored.  But this same failure recurs over and over after some few minutes to a few hours.
> 
> This is a regression.  The error was not reported with any previous kernel since 6.2.14-300.fc38.x86_64

See Bugzilla for the full thread.

Unfortunately, the reporter can't bisect this regression (he only tries
distribution kernels instead).

Anyway, I'm adding it to regzbot (as mainline regression because v6.2.x
has already EOL):

#regzbot introduced: v6.2..v6.3 https://bugzilla.kernel.org/show_bug.cgi?id=217549
#regzbot title: ath10k_pci firmware crashed on Dell XPS 13

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217549

-- 
An old man doll... just what I always wanted! - Clara

