Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3D4E59AD
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbiCWUPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344578AbiCWUPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:15:42 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B898BF34;
        Wed, 23 Mar 2022 13:14:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b130so645927pga.13;
        Wed, 23 Mar 2022 13:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SqzXBf+oiLlHdlzIQAYBV2rUA1ozqz6S8acZiCgoJgg=;
        b=fDxBnZ4Kc5wIbxD213OjcTAD+QweQLYRkWvnQ+RdrlH5GbL0HpzGsrO5NacSTPf1Uz
         H0CVtiNi5c1Fetgx5OtkedAwyu6Kuy4PZOjIkstj3p/Uj2jRfUV2Z/iZEoZPdW4oKHe4
         B4Pkp/Cwdqn8dUwHsc/n6K1JFrAUXmYjlMDGEsDMA6xWfAtBhjbQzsbeIbIRG7PBspxZ
         uMqZ0NU+3QE5YeaPg5TN0pZKm2j2yWkVQoXMEH9KtmS8GTP1aQmvbao1ymyOCrovz6B9
         F2Os/3vrlmn2hcfNUBVYXiGVmXrPZYGQIKf+mnAYJRDB6Qdmn7CxhXZr3S4mSDr1Y2Se
         GgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SqzXBf+oiLlHdlzIQAYBV2rUA1ozqz6S8acZiCgoJgg=;
        b=0B8WC0R9oxcDG6Y3ADQSkwfZigKBnQww21DLifXCWBCPynpaBo1VAjGfWgZ+Gank5P
         T4xUGLDZTVGUc7GYjCyk9N7lj58eCcmuqtIrhCrBngTdrIh7/FKaqBQs+p0jh0G3sozY
         rtk/1CwXYHhqyJkioUchf2ZTXgtu/kXb1itNmd24EjRdE3W9o+bFYR9GLT82Dmj3aG/D
         dWq7h27CNXQTYrLxXm9RkCoH9JvA0a7ll0nrt4DrfuntwAcpWxIofA+1J+PKIQgwNiKZ
         lEYYwpSvXGUdm9uVYGQ46psIQ/UwjP7YzaR6ghUTAgoJICs3bbnkFLlfumf2fidn/kM9
         jxBg==
X-Gm-Message-State: AOAM531pOIfK4bLrr0oh67EUjrP9p6MRV/0jmlLaJUQ2hh5NuwCS6HXn
        +dw53Ze0TCeYT/MkyxTk7iQ=
X-Google-Smtp-Source: ABdhPJwORPXCVM/tlAyQPyNcwD8oEQ/LjRZnSxlvzo8zHq8yZYnl8R9LbJZESYwcT3vxHtpCAeJqjA==
X-Received: by 2002:a65:6e87:0:b0:380:a1ef:a9be with SMTP id bm7-20020a656e87000000b00380a1efa9bemr1230773pgb.284.1648066446930;
        Wed, 23 Mar 2022 13:14:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id np8-20020a17090b4c4800b001c70aeab380sm7606982pjb.41.2022.03.23.13.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:14:06 -0700 (PDT)
Message-ID: <a3dfb05f-e66a-171e-8dbe-1f32d3a69830@gmail.com>
Date:   Wed, 23 Mar 2022 13:14:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC net-next 1/5] net: phy: mscc-miim: reject clause 45
 register accesses
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-2-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220323183419.2278676-2-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/22 11:34, Michael Walle wrote:
> The driver doesn't support clause 45 register access yet, but doesn't
> check if the access is a c45 one either. This leads to spurious register
> reads and writes. Add the check.
> 
> Fixes: 542671fe4d86 ("net: phy: mscc-miim: Add MDIO driver")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
