Return-Path: <netdev+bounces-7281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0447971F869
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B28B9281985
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888511365;
	Fri,  2 Jun 2023 02:28:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C76E1363
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:28:15 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99119B;
	Thu,  1 Jun 2023 19:28:12 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b038064d97so22502925ad.0;
        Thu, 01 Jun 2023 19:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685672892; x=1688264892;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iH1ysj30mF85sJI8Hu+UweQ/IViEKpx4ySqfGsRzxAs=;
        b=n9hmECaPd+ti6J6O3CLn/hnZa9po4lvtqeG9t7fTWbd6d+18sta9hEaL45qSB+zkh5
         8ZA/GPZH2HTvbxXe0YEj8500pOBEml8Zp3HSPng4Oj7Pl59f6GLyb55gLV4ao6wzfqT3
         tnMcUM2jZiArcSWQGP1seAeIOhtbmO7k1SHOl4kZm2AcTmBnjQMqWv4MqBFcBeEp/NkL
         01ymX7ULoR8wtEItTDxzxIV1jrplntVc/AKf87k4fN2AOOMY+9tUWRzvyNWwIzejLCVy
         jXpBwL287rwNs0q7Uog2OFXH9ZB8Ksd3mgLBjHPGE+p/d6oaRRnGQILxkKYZtg9/vJ9l
         Rwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685672892; x=1688264892;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iH1ysj30mF85sJI8Hu+UweQ/IViEKpx4ySqfGsRzxAs=;
        b=S8irZSA61SUHiyYV7LHQBxznHmkG5fbcjdmbobQD5bNO0/GhYgyo0QtSdr4qBAHVyc
         jS7czVdaUCd1IBkT8l5sGQxhIR2tSCBapamEjUvka8T19F94EhxjmewZBdVECjxMrqZO
         ldF5p5Dsn4uZKnFQhSAc1ct40A97Dl51/TbQ4gNga7OFlvNWQdV3oBFUsN+LaqPoXa1V
         fGCgL1ebNccnsV7gG8eUgMYUxBeFl1m2PSamFxvJ23IB++X5mnRANJeXavOkGi5vYrp4
         6eaCYI9/xfGdT82plX4LqKUUBDaMT3o/sJ09agKHN4msUXkBuAiHpa49VphgEkBgsDfH
         pZhg==
X-Gm-Message-State: AC+VfDym6yzNdSors8W7ZDLK+2CBfYW48ZIIezQLGvSl5EuFrXEmeSIG
	oezdcrGEF9TTLnRNEpBK2wNbP+zGYP0=
X-Google-Smtp-Source: ACHHUZ4e6+vRjrIpsaHlh4EAancrsEHwVNsQVko2QUD7knU+Nwo4iXkRehTnlgoYJZYQRmAB6kY9Vw==
X-Received: by 2002:a17:902:d2c5:b0:1b1:76c2:2966 with SMTP id n5-20020a170902d2c500b001b176c22966mr850675plc.20.1685672891925;
        Thu, 01 Jun 2023 19:28:11 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-49.three.co.id. [116.206.12.49])
        by smtp.gmail.com with ESMTPSA id t21-20020a170902b21500b001ac45598b59sm76827plr.163.2023.06.01.19.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 19:28:11 -0700 (PDT)
Message-ID: <9f12c322-fb62-26f0-46d1-61936a419468@gmail.com>
Date: Fri, 2 Jun 2023 09:27:48 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>,
 Linux Real Time <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Paolo Abeni <pabeni@redhat.com>, SamW <proaudiomanuk@gmail.com>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: commit 6e98b09da931a00bf4e0477d0fa52748bf28fcce suspect causing
 full system lockup
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

> 6e98b09da931a00bf4e0477d0fa52748bf28fcce
> OS slackware64-current fully upto date, on an AMD 990fx motherboard with a 
> Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 09).
> Linux-rt-devel-rc2-rt1 and linux-rt-devel-6.4-rc3-rt2 had same issue, previous linux-rt-devel-6.3.3-rt15 worked with no issue.
> 
> Hello I suspect this series of commits is causing the full system lock im having when using the r8169 driver with linux-rt-devel-6.4-rc3-rt2. With the driver enabled my system locks up with a few mins of booting and logging into desktop. I have to use power off button and reboot to older kernel. With the r8169 driver blacklisted the kernel works perfectly.
> My syslog attachment shows the driver errors and after looking at commits I saw the above numbered as being the most likly cause.
> A member of oftc linux-rt irc channel looked and gave the comment posted below.
> "tell the driver maintainers they must not enable the irq in the napi poll function"
> He said it looked like that could be causing the errors and then full system lockup.
> please contact me if any further information is required.
> 
> My fix has been blacklist r8169 and use the r8168 driver from relatek with a patch to enable builfing with the 6.4 kernel.
> Thank you for your time
> SamW

See Bugzilla for the full thread and attached syslog.

Anyway, I'm adding it to regzbot:

#regzbot introduced: 6e98b09da931a0 https://bugzilla.kernel.org/show_bug.cgi?id=217519
#regzbot title: Networking pull for v6.4 causes full system lockup on RTL8111/8168/8411

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217519

-- 
An old man doll... just what I always wanted! - Clara

