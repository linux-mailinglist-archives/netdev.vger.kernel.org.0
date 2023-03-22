Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A276C515C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjCVQ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCVQ50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:57:26 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAF64C30;
        Wed, 22 Mar 2023 09:57:23 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id w133so14193718oib.1;
        Wed, 22 Mar 2023 09:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679504243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=x/LJCDUUS8dZkIDhRYPerCJh3arSRw693tQiddUd1Gc=;
        b=lhOgE0WLpLCyeW2JRuHpeM0ES4VPFrguHRervL89zb2YhFiWtLu5LDmNN+owybtoY6
         e+SkAx6T9str8YnN3WTFmLJpiHlejSiBGrVucbVnmQz1e5Y+hTWakGT2B5IWenBZKLld
         3RcSTUNOhDUDeA4uhY8+abqCvCuLPe1qiKgCTS9MegLAegsEnECmUGVY/nIo2Mtez38r
         j3sKiFmvmYYPgUbqlXe7G0RsL6GS4Fb1wch6gYt8FbIFuQfaVo6CK04uz/jLG/odHXJv
         WnpGYBp/rcKyyzUxfHrBE+u5EfCULP5/pjhvlpQ7rNSEO07UD9slqdNVcBttimIQfmSf
         Z9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679504243;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/LJCDUUS8dZkIDhRYPerCJh3arSRw693tQiddUd1Gc=;
        b=8PIFlRuo9cY+n8DAC6DHMa4i7hqp4R9ZubDZMeDmYmgY6d5itfGwp5BnmRfeaNMPS8
         krhQZPEeJ/EdBMyB4XQOOetWLaVeURxAtHiIse6FSPdoXZa8Ut0sxHqUrs9Les8DOHi2
         Abo36+0CI2sMWFaWInEOJWdW9HwrfHlU34BSwwPpWUwcWgfPoPQ6X3BZwC2NGM7tUif9
         R/i/+ONvCsV2YL9FlVViA2UWO3H/8MxPD4dkkjJiU75CeRmAQrRtUGEksIL8PoEUceEa
         0/rAgrAeIUFOP8Zgkgs3P/6ylonE8xfj5fn+4GT+zsm7lrdXpTTuNHcOWIxN/c32eMph
         hKXw==
X-Gm-Message-State: AO0yUKUO+IFzBx62cFimhHM1LmaZwaPD9kbZblnfd/CAx9qNYRz8wT94
        /iHLWZvUVL+mBivBGsmcpB0=
X-Google-Smtp-Source: AK7set/v5X61vo/FnOG/xCUP7LSwyMpXQZ0uRP+g37npUXiO/gOwIPDgls8z1zVTWV6HmZomu8TuKw==
X-Received: by 2002:a54:4105:0:b0:386:9bfc:d04f with SMTP id l5-20020a544105000000b003869bfcd04fmr1421847oic.45.1679504242916;
        Wed, 22 Mar 2023 09:57:22 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id o187-20020acaf0c4000000b0038476262f65sm6153526oih.33.2023.03.22.09.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 09:57:22 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <55057734-9913-8288-ad88-85c189cbe045@lwfinger.net>
Date:   Wed, 22 Mar 2023 11:57:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [BUG v6.2.7] Hitting BUG_ON() on rtw89 wireless driver startup
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
References: <ZBskz06HJdLzhFl5@hyeyoo>
Content-Language: en-US
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <ZBskz06HJdLzhFl5@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 10:54, Hyeonggon Yoo wrote:
> 
> Hello folks,
> I've just encountered weird bug when booting Linux v6.2.7
> 
> config: attached
> dmesg: attached
> 
> I'm not sure exactly how to trigger this issue yet because it's not
> stably reproducible. (just have encountered randomly when logging in)
> 
> At quick look it seems to be related to rtw89 wireless driver or network subsystem.

Your bug is weird indeed, and it does come from rtw89_8852be. My distro has not 
yet released kernel 6.2.7, but I have not seen this problem with mainline 
kernels throughout the 6.2 or 6.3 development series.

One thing that would have been helpful is to include any rtw89 entries in the 
dmesg log that appeared BEFORE the BUG. For instance, I have no idea what 
firmware level you are running, etc.

If you are willing, I would like you to 'git clone 
https://github.com/lwfinger/rtw89.git'. You would likely need to install the 
packages needed to build an out-of-kernel driver as shown in README.md in the 
repo. You would also need to blacklist rtw89_8852be, which would interfere with 
rtw_8852be coming from the new repo. The code in the repo matches what will be 
in kernel 6.3+, and it would be instructive if there is something in your system 
that triggers this problem. I have never seen anything like this.

Larry

