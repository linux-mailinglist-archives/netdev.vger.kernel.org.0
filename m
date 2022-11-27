Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE04639CCD
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 21:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiK0Uay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 15:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiK0Uar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 15:30:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD6DFBF;
        Sun, 27 Nov 2022 12:30:47 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w23so8340376ply.12;
        Sun, 27 Nov 2022 12:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXP9NyVB0jK9tvTLJNw5mHBADpQQ+Nn51zHZ2LgGCbI=;
        b=XgjuUdMJtS0ogJ8ceH1VzzzVDUFIOj+fTW8ql2/OV9h4AHaSlWyti4ayi0KQTni9D+
         unEuTle2z/GsXuSqECpZIsfnpapICJuHOveWA+ezYR5GH7mRCPp1VyN6SS9NfVgkIOG7
         f5xguaqoHRQ3Whaqk47Umlx6KN8CDipbWjzYVduUp73MW2fhQRuby13MqfY9h6QfsKMz
         6MnqZX5TbcMiE4OiajyLGdA0PnuBHL2EigC/7s406/l31fgsi1I1D29CAoxZuAzp3mIH
         Lm3WuwqsLNFrRe9lkZy6VYIgJA1pQ/Wfho15b0hep1GW2BpRstXz8qzjWV+UItnU+kzV
         NWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXP9NyVB0jK9tvTLJNw5mHBADpQQ+Nn51zHZ2LgGCbI=;
        b=UfjHwvstumqEeCbgB7acLLLtV1e05VAB7MAyox6EQo1N6iPkQea+EpYggFB/niDkn2
         Dgh4YJ2aOT7Mwy99nP0QUiQILn+BP5XMRoP2rk9I++kHLIw07yNTTzYciDT/0581wHsT
         ZjS+vFE1oWYpOLkFEQNPc+Lmu1hWjCYn99rswV2byBPKnKux1dgfvzHj60XICyJOZ4dU
         Kgu/OSTzMryTCEws/i8DZtaLSv+VwhXq2iiCMxRkYH9uYPgGQTu2gBcSdCA+gtj8DRmJ
         sOpuvuLUkSbRacH7LcY9GYBHFUQ4dC71iFTeOFO+9uDFrcB2vodcXixyPt/a88FzwbiG
         evPQ==
X-Gm-Message-State: ANoB5pm+6oEEFysIFr4lcaiZZg3t5/PacSfZPwGbiQ6LdX/XHNNeWwHP
        WvwY8p6y9XZBsacGYac8Ugs=
X-Google-Smtp-Source: AA0mqf5HTnDNNmB61ogSzEsXrSWoHexcFhFkNkg3wSOWawDsPo3Whgrh/vWg5yLwaqSoFT9JKFNhcg==
X-Received: by 2002:a17:903:22c4:b0:187:4ace:e1fd with SMTP id y4-20020a17090322c400b001874acee1fdmr29045460plg.54.1669581046433;
        Sun, 27 Nov 2022 12:30:46 -0800 (PST)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cp5-20020a170902e78500b00187022627d8sm7188869plb.62.2022.11.27.12.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 12:30:45 -0800 (PST)
Message-ID: <45a8283b-64ee-599d-3ec6-abe2b2f96920@gmail.com>
Date:   Sun, 27 Nov 2022 12:30:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     "Wang, Xiaolei" <xiaolei.wang@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
 <Y4E3EOTXTE0PuY6B@lunn.ch>
 <6b50524f-4f24-d14e-9d3f-f03f25ca549b@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6b50524f-4f24-d14e-9d3f-f03f25ca549b@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2022 5:41 PM, Wang, Xiaolei wrote:
> add Florian
> 
> thanks
> 
> xiaolei
> 
> On 11/26/2022 5:43 AM, Andrew Lunn wrote:
>> CAUTION: This email comes from a non Wind River email account!
>> Do not click links or open attachments unless you recognize the sender 
>> and know the content is safe.
>>
>> On Fri, Nov 25, 2022 at 12:12:06PM +0800, Xiaolei Wang wrote:
>>> If the external phy used by current mac interface is
>>> managed by another mac interface, it means that this
>>> network port cannot work independently, especially
>>> when the system suspend and resume, the following
>>> trace may appear, so we should create a device link
>>> between phy dev and mac dev.
>>>
>>>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 
>>> phy_error+0x20/0x68
>>>    Modules linked in:
>>>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 
>>> 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>>>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>>>    Workqueue: events_power_efficient phy_state_machine
>>>    unwind_backtrace from show_stack+0x10/0x14
>>>    show_stack from dump_stack_lvl+0x68/0x90
>>>    dump_stack_lvl from __warn+0xb4/0x24c
>>>    __warn from warn_slowpath_fmt+0x5c/0xd8
>>>    warn_slowpath_fmt from phy_error+0x20/0x68
>>>    phy_error from phy_state_machine+0x22c/0x23c
>>>    phy_state_machine from process_one_work+0x288/0x744
>>>    process_one_work from worker_thread+0x3c/0x500
>>>    worker_thread from kthread+0xf0/0x114
>>>    kthread from ret_from_fork+0x14/0x28
>>>    Exception stack(0xf0951fb0 to 0xf0951ff8)
>>>
>>> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
>> This needs Florians review, since for v1 he thinks it will cause
>> regressions.

Please give me until Tuesday to give this patch some proper testing, thanks!
-- 
Florian
