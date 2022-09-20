Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3265BE018
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 10:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiITIac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 04:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiITIaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 04:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68BCEE39
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663662588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=da3EKRUU/aX+F/G8AcfIVmp7slwdPcDC7pD7Lc1k6T8=;
        b=EeoJxzZu1eLiyqfYJkboP1hdyvaIAYKUfek8/XzWzpeYkugioewbYvdzT9/GiOVocnnlgu
        OHSamqh7kTui2+vdJ2sRw81CHVMEICWhu8l+E3ed0f1BL77Qm29pNwR1mMiOue/mIRFMW5
        2wqmSwh/RnE1lfIwvJ2tKK9D7ko2fo0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-427-Mr3KMGQONgmEC43ZzW01_A-1; Tue, 20 Sep 2022 04:29:42 -0400
X-MC-Unique: Mr3KMGQONgmEC43ZzW01_A-1
Received: by mail-wr1-f70.google.com with SMTP id v7-20020adfa1c7000000b0022ae7d7313eso836195wrv.19
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=da3EKRUU/aX+F/G8AcfIVmp7slwdPcDC7pD7Lc1k6T8=;
        b=RGHPUSngUD47uND8jafFfFFZ4LpUrV7RAFyWr/fjRBRZI9PZqmy5eLGiodYaFxZSUH
         XAUmXkwZJz5tzlhZTVX4iegoEDvjIHFXPiASQ3OwhV9190P6WnHO8EIdRooTxUXvZQfh
         o2BzDHW81GKM0RXFBQsnWFwlD8pB488fMmDxHSnB9GjbgnmQvvMXJA8LgVOfVzp9h18o
         ipRxZpcQozKTS8XuaxvWuokag/P8FrR9CACSrsrmUdvnpm/RmbgD4AekmuDr3Oahiw/f
         MeQkUM/Hccg5+joFnDWDG8imjpHc4ovFjJiTIj5OLUA84wTe9COnRqpKFyN6fMvWe1FU
         5vOw==
X-Gm-Message-State: ACrzQf0NEB+fxLOcMTJW/xPfh3EHD0Wwlz0of4UseNdnJCQqMcbcxWe1
        eHcaoV+kCEaEfzhNTAudmi33Yw9F6YynlOzQlbis33EQLnW8k1ROSlrbnMKrbdpPmwC15MJGh/c
        5wGy3ecEfxfcPRt5Z
X-Received: by 2002:adf:eb02:0:b0:225:2b94:d14c with SMTP id s2-20020adfeb02000000b002252b94d14cmr13848126wrn.291.1663662581323;
        Tue, 20 Sep 2022 01:29:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4XGXRZ5NH9x0iBE08TdJin8BZiQnDIHLSZamFKo6wSEPBM382Wr2hx4MknpmLHULGj3V7/oA==
X-Received: by 2002:adf:eb02:0:b0:225:2b94:d14c with SMTP id s2-20020adfeb02000000b002252b94d14cmr13848101wrn.291.1663662581078;
        Tue, 20 Sep 2022 01:29:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-90.dyn.eolo.it. [146.241.114.90])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b49ab8ff53sm1518774wmr.8.2022.09.20.01.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 01:29:40 -0700 (PDT)
Message-ID: <d98d439ef5ee8a1744481bf1f076fbed918c3cef.camel@redhat.com>
Subject: Re: [PATCH net-next 3/6] net: ipa: move and redefine
 ipa_version_valid()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 20 Sep 2022 10:29:39 +0200
In-Reply-To: <20220910011131.1431934-4-elder@linaro.org>
References: <20220910011131.1431934-1-elder@linaro.org>
         <20220910011131.1431934-4-elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-09 at 20:11 -0500, Alex Elder wrote:
> Move the definition of ipa_version_valid(), making it a static
> inline function defined together with the enumerated type in
> "ipa_version.h".  Define a new count value in the type.
> 
> Rename the function to be ipa_version_supported(), and have it
> return true only if the IPA version supplied is explicitly supported
> by the driver.

I'm wondering if the above is going to cause regressions with some IPA
versions suddenly not probed anymore by the module?

Additionally there are a few places checking for the now unsupported
version[s], I guess that check could/should be removed? e.g.
ipa_reg_irq_suspend_en_ee_n_offset(),
ipa_reg_irq_suspend_info_ee_n_offset()
...

Thanks,

Paolo

