Return-Path: <netdev+bounces-2075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 918CC700355
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD419281A32
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAD9BA2B;
	Fri, 12 May 2023 09:06:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E6AD4D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:06:09 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C08DD96;
	Fri, 12 May 2023 02:06:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64395e741fcso10010587b3a.2;
        Fri, 12 May 2023 02:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683882368; x=1686474368;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BUkwR5dAglmPcY5nHDbrbDUmEm/Czvqol0O0KFuiob8=;
        b=EsOpvrz8oFiaamtTwXnlCFLbdqUpYc15ryzTzPnULkAUJ5PsxIC2FamepHTQ9vxJUo
         7hiFmErMgyPGoSAse+smqWasoWMlfVSh9GD2osKdeABJHg67mA/iS8vuIoGsYTfrBRPr
         5WH6Dw5j5eH+bxMRz4bxS0CwpwjCN4Qqw/CB/ON2fcHX3iht/v64JwKi8JHqb2vltP3z
         LogBmtroPw5FGg3+H9+h0WXdJKJsbQaY6sUo8vQkr+LpWZmk7bZT0gatzGfQFcbJiJo9
         k1j0c1nZZLck2LHRMCfiuE+xDGZtdcpoZubsCR3JCv27zPXiBadfozdQhAc1w7smV2PR
         uBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683882368; x=1686474368;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BUkwR5dAglmPcY5nHDbrbDUmEm/Czvqol0O0KFuiob8=;
        b=AcSi5q0oB/RB7LaAxDD20nksQ1eoG15vksts1oMpPMTIz3d8OmKWcT4x8mUr8/WJVN
         fbM2ud1chLMyZkzPidQCtx3M7Wtrgi+WADUhZitFUNlFwg0YoleCpZ9K/20ImaVXaJpV
         0Rc78uw20q33+uijGfBAXxnELRw+A6zItHAG28dYVeQhZSd6p6LseFSkxoufFKFjlQvV
         /XWfwNYTgF64Dfs4oRT+6L68PyfdGVsvG3XF1XUIvxG+hFcj6WFVSF7KYv2ldcmvIVU+
         Q84bwNLUTeyfWcslWutjhjMqNHdrPC3nOvaj4y1fCtW9QXYUC3jk4C1zhTwwe0j6CcN+
         LLXQ==
X-Gm-Message-State: AC+VfDy9GrhhDrUGt3G+Ob5/GT8/4M7ZKGK+CcMaIzy6XhHVOLF7kGl9
	uPGAn4esmSX3FmliP2T41Jw=
X-Google-Smtp-Source: ACHHUZ4DD4qzlVtl1MATp+SSQ4wN/DopjFHr357B6Org73qjEYGN3SP7rZVm5nzvAwWRUD4DmIZ0jQ==
X-Received: by 2002:a05:6a00:1747:b0:644:ad29:fd5a with SMTP id j7-20020a056a00174700b00644ad29fd5amr27781559pfc.21.1683882367855;
        Fri, 12 May 2023 02:06:07 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-8.three.co.id. [116.206.28.8])
        by smtp.gmail.com with ESMTPSA id a4-20020a62bd04000000b006413d1dc4adsm6584368pff.110.2023.05.12.02.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 02:06:07 -0700 (PDT)
Message-ID: <2883e834-eccd-937e-0f3e-2d787994d4cf@gmail.com>
Date: Fri, 12 May 2023 16:05:52 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 08/10] drivers: watchdog: Replace GPL license notice with
 SPDX identifier
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Networking <netdev@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Linux Staging Drivers <linux-staging@lists.linux.dev>,
 Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
 Linux Kernel Actions <linux-actions@lists.infradead.org>,
 Diederik de Haas <didi.debian@cknow.org>,
 Kate Stewart <kstewart@linuxfoundation.org>,
 David Airlie <airlied@redhat.com>, Karsten Keil <isdn@linux-pingi.de>,
 Jay Vosburgh <j.vosburgh@gmail.com>, Andy Gospodarek <andy@greyhouse.net>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sam Creasey <sammy@sammy.net>, Dominik Brodowski
 <linux@dominikbrodowski.net>, Daniel Mack <daniel@zonque.org>,
 Haojian Zhuang <haojian.zhuang@gmail.com>,
 Robert Jarzmik <robert.jarzmik@free.fr>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Wim Van Sebroeck <wim@linux-watchdog.org>, Jan Kara <jack@suse.com>,
 =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
 Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
 Simon Horman <simon.horman@corigine.com>,
 Yang Yingliang <yangyingliang@huawei.com>,
 "Steven Rostedt (Google)" <rostedt@goodmis.org>, Pavel Machek
 <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
 Kalle Valo <kvalo@kernel.org>,
 =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
 Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Deepak R Varma <drv@mailo.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Thomas Gleixner <tglx@linutronix.de>, Jacob Keller
 <jacob.e.keller@intel.com>, Gaosheng Cui <cuigaosheng1@huawei.com>,
 Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>,
 Ray Lehtiniemi <rayl@mail.com>, Alessandro Zummo <a.zummo@towertech.it>,
 Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>,
 Marc Zyngier <maz@kernel.org>, Jonas Jensen <jonas.jensen@gmail.com>,
 Sylver Bruneau <sylver.bruneau@googlemail.com>,
 Andrew Sharp <andy.sharp@lsi.com>, Denis Turischev <denis@compulab.co.il>,
 Mika Westerberg <mika.westerberg@linux.intel.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-9-bagasdotme@gmail.com>
 <46c263f6-dd9c-408c-b3e0-bfb2676c6505@roeck-us.net>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <46c263f6-dd9c-408c-b3e0-bfb2676c6505@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 22:08, Guenter Roeck wrote:
>> +/* SPDX-License-Identifier: GPL-2.0-only */
> 
> This was supposed to be a C++ style comment for C source files.
> Has the rule changed ?
> 

Oops, I don't see checkpatch. Will fix.

>> +/* SPDX-License-Identifier: GPL-2.0-only */
> 
> The text below suggests that this should be GPL1+.
> 

OK, will fix.

Thanks for review!

-- 
An old man doll... just what I always wanted! - Clara


