Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9323D5A53ED
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiH2SZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 14:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiH2SZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 14:25:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFFB1EED5
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:25:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id cu2so17477249ejb.0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=cvsvecGLpxG/GkFoAYDrjsnjXLFrvVte7IVApyxgugU=;
        b=KkJWcCi9g2gEPTfqX1BUUGi+M1Gt1ohWTy7+ev0ZH6RhdD3i3wxXKeDcGZBdgM5GZ4
         N77X2RguVKHeJTX3dJO7/nfSGRLmLicKpMffYO605dArw1NxIrFkZ4n71p9QILR8BhRA
         alvtKsS7hEIWDiPJwwxmIhRhnTg4dXhl0pQQ3g6sqKqKaQop/QlQvQ8C7zZ2IHeh5P1L
         GLH9BX95sBKgqu9Q/DrAiieVQSPoW3YqV8WIR34QE9Ap9PL4mzIRnHr6GAHzfCfnlidF
         v4CJx3ZoygEW/6mospAlfcYzS4EBS/xmAQaLl+7j8q8f5Vi/MJaup5cDoQKyCkJRY4it
         wvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=cvsvecGLpxG/GkFoAYDrjsnjXLFrvVte7IVApyxgugU=;
        b=ppeASw6Z7knjAcAnh2EMkMnPygTxX4agQcUXGdrfGUqyWCwQGQvKcmUcA9kPILn5nU
         7IdZyCyHlAgELAPaUXnkB1RWVY/i1YWREKbDzLutFfzHBjJKJksCIbSR0vPHQmYKLaZF
         8aZWn7KLnwgLBcU0iCJbIaO27oT2PjdfM9GGOdjHRv1pYXeCjstAxNr8kVIRv6laMb6i
         X7mOQnxXj4iLROkTT/Nh6HgTCplN544Sg1Fr/ab8tp6L15rqAj3jQsZPMk34vUsHFW8T
         BjPvQBuQo7IlVdoCS5gjelCEanreiMTC8pegp5iAOgYKXkXKM5g8TRmJnr9sktS7PFjE
         mCdg==
X-Gm-Message-State: ACgBeo1+aO86rLc20zqKaOPjqRyneT2Ubu6eTy3w9yGfGQTk9HLEEtr+
        38MoR6vNEYLaYVM+HhNfcyBfRvjkNnU=
X-Google-Smtp-Source: AA6agR54ycNlmZCgd23dmjBv+SRJNmp5IlXl77W0JSmJewO9H9SFr2jD7JNH4OSlf7ukdt/gs+obGA==
X-Received: by 2002:a17:907:1c89:b0:734:d05c:582e with SMTP id nb9-20020a1709071c8900b00734d05c582emr14608455ejc.282.1661797509658;
        Mon, 29 Aug 2022 11:25:09 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bd96:2400:287c:a714:9c3c:aa54? (dynamic-2a01-0c23-bd96-2400-287c-a714-9c3c-aa54.c23.pool.telefonica.de. [2a01:c23:bd96:2400:287c:a714:9c3c:aa54])
        by smtp.googlemail.com with ESMTPSA id j10-20020a17090623ea00b0073cdeedf56fsm1862652ejg.57.2022.08.29.11.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 11:25:09 -0700 (PDT)
Message-ID: <99839201-6c30-b455-2f32-ea0f992427fc@gmail.com>
Date:   Mon, 29 Aug 2022 20:25:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
Content-Language: en-US
To:     Erico Nunes <nunes.erico@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Cc:     Da Xue <da@lessconfused.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
References: <20220707101423.90106-1-jbrunet@baylibre.com>
 <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
 <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
 <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com>
 <1jfshftliz.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL0pWFga4V1jR8B4oHjXmbBm7dU6BB8pdh0Hymd2sAiqiw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <CAK4VdL0pWFga4V1jR8B4oHjXmbBm7dU6BB8pdh0Hymd2sAiqiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.08.2022 12:29, Erico Nunes wrote:
> On Mon, Aug 29, 2022 at 12:02 PM Jerome Brunet <jbrunet@baylibre.com> wrote:
>>>>> Jerome, can you confirm that after this commit the following is no longer needed?
>>>>> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
>>
>> This never had any meaningful impact for me. I have already reverted it
>> for testing.
>>
>> I'm all for reverting it
>>
>>>>>
>>>>> Then I'd revert it, referencing the successor workaround / fix in stmmac.
> If we are considering to revert that, I would like to trigger some
> tests on my S805X CI board farm as well, to ensure it won't regress
> later. That was one of the original reasons for that patch.
> 
> Since there are some more changes referenced in this thread, can
> someone clarify what is the desired state to test? Just revert
> 2c87c6f9fbdd on top of linux-next, or also apply some other patch?

Yes, just revert 2c87c6f9fbdd on top of linux-next.
