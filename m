Return-Path: <netdev+bounces-9083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5ED7271B5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F28F11C20F71
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50E918C19;
	Wed,  7 Jun 2023 22:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D333C08E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 22:30:26 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB2E11F;
	Wed,  7 Jun 2023 15:29:52 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-256531ad335so6434621a91.0;
        Wed, 07 Jun 2023 15:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686176992; x=1688768992;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=grsDBqe7yk4jc/jPIZgFmp/seq5dvq91MXFPyPq76NY=;
        b=lZmdyXvhkL+I/p0/O5+c9fSc4znjTE9ZWooBILdYmG30DmpVQBSgtnyVVoIQA+jUWk
         /d1utBBXUki1G9+pNAgRfKyUCSD+o9RwQEeL1kyiJ7JUSlVxFWT7wIUKkEbzOsLqr8xb
         tuTMTAQLxwYeQzTFO3W8zxr0C2OQs/nAlb1/7rPHyP/9Mpv9thdWPHfCkVR22pDUWQQo
         w/f2lp8NVu6IHQTxQ2qpz9lUJozFCxNJxGkSf9urbp/FBhCAUnv4lwybLWgjx91Satvy
         ZTfVkzDC/D6CvweBv0DI1zMCYiGKZ74+qp8dDD2ya6VpOytxQsT/iiGtrgedG+hoBook
         aRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686176992; x=1688768992;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=grsDBqe7yk4jc/jPIZgFmp/seq5dvq91MXFPyPq76NY=;
        b=VNmdtxwMlJKY8+jYA8DabWTkFN5gdtXUdEu5FyuhMJoQKoFVFuwgTl6M/GGVEoIHLy
         LmhWrT+Sjlp1vOcABFh0oj3cnXHNbz/ivCogfE3f02BJWqoj8Yi6r3q6aISc8wAYSIhP
         CsOD4Pszwf02E9ospJ9LKZQD/oVa/iS/NbjHDk0INbcOT/VBLjLKnYWbCDFyed6cokhE
         IVMli4egH1F2Hu5xIlcb7odcUqUXneoehZk27+e+fluIDboJYGBoBjE5jM+PDW6Zh8JX
         x20/5JTXmNjEjQjwrrBlngtGW/lcxFeXWDD8cqQ1QFppsRWfPnSuJXnGER8CJ9SlMzCI
         fDeg==
X-Gm-Message-State: AC+VfDwN1MtTPIsqewwpRWJ3Y0g4+cI5fQ9FtWodfyAf3QhbzmmJVw5O
	v6d7n2atQyUOKIZ6hiBFzBc=
X-Google-Smtp-Source: ACHHUZ4aO/KMCktl3HA8PmmtvGB3Vk+MESjxfD+vbAvX8bKgKrv+R/F45XqGTlTZX6wNEnCUvlHRXQ==
X-Received: by 2002:a17:90a:ea86:b0:256:845f:333a with SMTP id h6-20020a17090aea8600b00256845f333amr6169247pjz.19.1686176992196;
        Wed, 07 Jun 2023 15:29:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q34-20020a17090a1b2500b00250ad795d72sm5151pjq.44.2023.06.07.15.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 15:29:51 -0700 (PDT)
Message-ID: <11182cf6-eb35-273e-da17-6ca901ac06d3@gmail.com>
Date: Wed, 7 Jun 2023 15:29:46 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: NPD in phy_led_set_brightness+0x3c
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Heiner Kallweit <hkallweit1@gmail.com>,
 Christian Marangi <ansuelsmth@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, Pavel Machek <pavel@ucw.cz>, Lee Jones
 <lee@kernel.org>, "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <9e6da1b3-3749-90e9-6a6a-4775463f5942@gmail.com>
 <c8fb4ca8-f6ef-461c-975b-09a15a43e408@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <c8fb4ca8-f6ef-461c-975b-09a15a43e408@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 14:32, Andrew Lunn wrote:
>> There is no trigger being configured for either LED therefore it is not
>> clear to me why the workqueue is being kicked in the first place?
> 
> Since setting LEDs is a sleepable action, it gets offloaded to a
> workqueue.
> 
> My guess is, something in led_classdev_unregister() is triggering it,
> maybe to put the LED into a known state before pulling the
> plug. However, i don't see what.
> 
> I'm also wondering about ordering. The LED is registered with
> devm_led_classdev_register_ext(). So maybe led_classdev_unregister()
> is getting called too late? So maybe we need to replace devm_ with
> manual cleanup.
> 
> However, i've done lots of reboots while developing this code, so its
> interesting you can trigger this, and i've not seen it.

led_brightness_set is the member of phydev->drv which has become NULL:

(gdb) print /x (int)&((struct phy_driver *)0)->led_brightness_set
$1 = 0x1f0

so this would indeed look like an use-after-free here. If you tested 
with a PHYLINK enabled driver you might have no seen due to 
phylink_disconnect_phy() being called with RTNL held?
-- 
Florian


