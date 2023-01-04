Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A574065DD7B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 21:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbjADUPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 15:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240128AbjADUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 15:14:57 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4424085F;
        Wed,  4 Jan 2023 12:14:50 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id d2-20020a4ab202000000b004ae3035538bso6646980ooo.12;
        Wed, 04 Jan 2023 12:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=w9AQXTfhuAvx8mgdmIzoZOuYPRTvbLKo9WZsNGoB5Hg=;
        b=o/D/TyNm+9veGTNVvipVJ3IqUM8STerU01fmrnzymh2MV7w0JU618aNmtP7pMuGKgf
         FS3v6O2cOra9xbs9yHsiw7xzsEejGxB5dE2v/CB6fywQp8OAY4PMGIczMjQatNzcx70D
         zHAziSMv7/6Dybn5o8fMDdGJwYEelEdHvs6s+dtxABQxipRgVOiugHr7XUt4s6CyMjrb
         +ziI8a52cqyb6XMbXoralitaXq6rxLEHEBmvaJ6Xr4uk2v6kEzRfQUnex55WBRXkKAd+
         +Xvuu92szU1cDdsdUTSAuP/MRbwSPpwj1Nfefd8nhgHyNMH+uTpdWHHC4GsIlN5qQAto
         8O/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w9AQXTfhuAvx8mgdmIzoZOuYPRTvbLKo9WZsNGoB5Hg=;
        b=yH/+Yg1eLoc/QemZUpBn2IzEKM01QMaTQvF1+0EiBPzMTOrxd76KUkz9K1v8xdZJvC
         jNzNeg7Np3F7N+fD1Ur0fcXEBRn2tYZRrexSZAPN+69++kBPa+jwTwP8pLLRilI/TakS
         8YnrXd4cis7oWFO6mQg3oQdsyx1UQ6D0wSLArlRhMJniJQV0cPSEqazskQ5u0N18cxDR
         JDoO22/dLdf7BbOY/ibFTKGkmH6fit5IgNWq0jjy3+BL6KUwwJw36FfwcBamW1ZbSlLm
         CZMIG6pdhmEcs/IGId4GfLNfFIwxeh/rEc3gUr09VbQFX5JhW+GCgaJ8znNJ6HJTyGAR
         6BnQ==
X-Gm-Message-State: AFqh2kpj8yUYl1lGP+NrIKV1QZz14wFtcmyKWfJZdwu6SnlVvcuzFFG2
        GAo+oKYE17Ob8QCAy4UB+K8=
X-Google-Smtp-Source: AMrXdXujoac2ceHnoaup8wqKn8Hcexv8hHFl/dakw7O1iaL19zZiJbqWJa2n54IhFnltABU1drifEQ==
X-Received: by 2002:a4a:e79a:0:b0:4a0:72aa:4ca8 with SMTP id x26-20020a4ae79a000000b004a072aa4ca8mr26949003oov.7.1672863289757;
        Wed, 04 Jan 2023 12:14:49 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id w9-20020a4ae4c9000000b0049f9731ae1esm5169107oov.41.2023.01.04.12.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:14:49 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <2b839329-7816-722d-cb57-649fc5bf8816@lwfinger.net>
Date:   Wed, 4 Jan 2023 14:14:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
Content-Language: en-US
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/23 13:59, Bitterblue Smith wrote:
> I tested with https://github.com/lwfinger/rtw88/ which should have the
> same code as wireless-next currently.

I just rechecked. My repo was missing some changes from wireless-next. It now 
matches.

Larry


