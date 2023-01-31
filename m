Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C45682AAF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAaKir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjAaKip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:38:45 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD942B607;
        Tue, 31 Jan 2023 02:38:41 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hx15so20729649ejc.11;
        Tue, 31 Jan 2023 02:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AWfMqhC7t40F0owjKMxsw443nYgYg1pYLsUU0FA6XJM=;
        b=Oh37oXrWrPjyZ4hknOJyAkye9RiAWniJ74hYpeocda1ZVkga32X2jeF/qvMLwLN/JD
         c6eNQoEGVjkCDEJOdmpXC5rhl5xOyT+oHMdHgqreoYA9hw/GTNu/VhDhpUiww4CrMuxo
         MKqUZlXQck1ibcBjJK8wlOUIlgYw6d/DwTXtw0P6aVZiZLWzBuYRsKTXco3MPmbG7++9
         qBpPv/vSq8xxA9ORfaNcZQvNOZSeV6cB3YiOfVRl/wjdhM+O/H7GiwwoF2a63sFD5gpq
         JTNQXwVcmnW5zORYabtmauzlcgu9w+ku/qdtAK0bh8TQ+IcpkxPg3cGk/AnXKVuEUMA7
         r9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AWfMqhC7t40F0owjKMxsw443nYgYg1pYLsUU0FA6XJM=;
        b=yuP7JO22utm6KRfecQ3/FoH18cL54Y1Zn/T/7Pb/+kZHGuormKTIJEY6SILqj+EywQ
         vmoW2jHb1zyyZLbO2m2wXJynGCTf2RWNIpGOKUfE/UiI9pL3QpyywDKe/bbGjGB0Q+FQ
         dX7QWnHMkvJeEPg2IoUEvfooNQ9LAVwaKewI/VK8JEdauo6B+7bFRHlwl/ehi+oGHeov
         brJoSjWVcSqL2uYztQpH3lp5VI4jt1w1pnznC7UP5lP5vkwATlXTsDk5Jcjaon51vPg/
         lGkW+1kmANRa3lvKqtLd6sci3E4n8pwFPo/QPrLnVDKnOLEHR2VQl4JESRVGL5h2UvFM
         CTcQ==
X-Gm-Message-State: AO0yUKUisIgmwx20Dlosh0I7w+Zlil0P8R92l4bF+lvsqRCBOVX22Hy+
        xKHRq7ADxyE18D4U4ey/bHo=
X-Google-Smtp-Source: AK7set9ZbsLLP3Kc0GjQujIrHil9RqC6xXl87N+oWvr8g+PlVmrzTr8pRFad/gUbGo17wMeAWPyfew==
X-Received: by 2002:a17:906:a886:b0:87d:f29:3a16 with SMTP id ha6-20020a170906a88600b0087d0f293a16mr2930786ejb.34.1675161519755;
        Tue, 31 Jan 2023 02:38:39 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8ba:6a00:a5c0:1088:ecf4:92db? (dynamic-2a01-0c23-b8ba-6a00-a5c0-1088-ecf4-92db.c23.pool.telefonica.de. [2a01:c23:b8ba:6a00:a5c0:1088:ecf4:92db])
        by smtp.googlemail.com with ESMTPSA id e22-20020a17090658d600b0085214114218sm8174856ejs.185.2023.01.31.02.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 02:38:39 -0800 (PST)
Message-ID: <671d564e-db1c-ed61-3538-97dd1916714d@gmail.com>
Date:   Tue, 31 Jan 2023 11:38:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] net: phy: meson-gxl: Add generic dummy stubs for MMD
 register access
To:     Jerome Brunet <jbrunet@baylibre.com>, cphealy@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        jeremy.wang@amlogic.com
Cc:     Chris Healy <healych@amazon.com>
References: <20230130231402.471493-1-cphealy@gmail.com>
 <1jbkmf2ewn.fsf@starbuckisacylon.baylibre.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1jbkmf2ewn.fsf@starbuckisacylon.baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.2023 11:05, Jerome Brunet wrote:
> 
> On Mon 30 Jan 2023 at 15:14, Chris Healy <cphealy@gmail.com> wrote:
> 
>> From: Chris Healy <healych@amazon.com>
>>
>> The Meson G12A Internal PHY does not support standard IEEE MMD extended
>> register access, therefore add generic dummy stubs to fail the read and
>> write MMD calls. This is necessary to prevent the core PHY code from
>> erroneously believing that EEE is supported by this PHY even though this
>> PHY does not support EEE, as MMD register access returns all FFFFs.
> 
> This is definitely something that should be done, Thx !
> 
>>
>> Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
> 
> This commit does not seems appropriate, especially since only the GXL ops
> are changed, not the g12a variant.
> 
The diff is a little bit misleading. The patch affects the G12A PHY.

> This brings a 2nd point, any reason for not changing the g12 variant ?
> I'm fairly confident it does support EEE either.
> 
Supposedly it's a typo and you mean "doesn't". Neither Chris nor me
have GXL HW and we didn't want to submit a patch just based on speculation.

>> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
>> Signed-off-by: Chris Healy <healych@amazon.com>
>>
>> ---
>>
>> Changes in v3:
>> * Add reviewed-by
>> Change in v2:
>> * Add fixes tag
>>
>>  drivers/net/phy/meson-gxl.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
>> index c49062ad72c6..5e41658b1e2f 100644
>> --- a/drivers/net/phy/meson-gxl.c
>> +++ b/drivers/net/phy/meson-gxl.c
>> @@ -271,6 +271,8 @@ static struct phy_driver meson_gxl_phy[] = {
>>  		.handle_interrupt = meson_gxl_handle_interrupt,
>>  		.suspend        = genphy_suspend,
>>  		.resume         = genphy_resume,
>> +		.read_mmd	= genphy_read_mmd_unsupported,
>> +		.write_mmd	= genphy_write_mmd_unsupported,
>>  	},
>>  };
> 

