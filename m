Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06968674D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjBANo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBANo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:44:26 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2364A1EE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:44:24 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qw12so35608563ejc.2
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 05:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asW5eFRDLXHELloHZttR3BTVlJuiJbmqB3xm7+kiUd4=;
        b=PuyLyhbaQlhUvf+w/J1ar1FqLVod/C3jU3jtAA9byr/v1yQeLV8Lb09x+R2pjDNv6a
         dXPNT4L5ox+4ziCEQ6XjAUB1IebZ+jOirdlcPh08k8QRagcbY6P9HEqwD1n0Mt1G9lRC
         Uo5VcfVavl+k2dvERd3YFbQzSXCQhSmJh6Fj9ImWG6AS7TqLlaKUMQawYrXcCWVO1Bji
         gbskVZ3CqG02Wza+BoN3Sr9uQpSLjBpwZLRyLjCOOLNvt2qnh55NkCc0AIAq8cZaQ1UZ
         /yl1w8O1EtbJCr/Hg99cOOP/ZWGJpS/7iGr+dVHqBiNQtPP56F9KL+QIrpTOLy+TTp4A
         lkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asW5eFRDLXHELloHZttR3BTVlJuiJbmqB3xm7+kiUd4=;
        b=hVleh7hXga0aSHVNVOq6T5AmqRaN9ZMrenCP4ggpCXXRU7Fxj3Fhbnd7nEfPCY2aMV
         wDgYb9+xz2VxCHUujRlznvpDLv7XqgebLJ7+xwgGroGmAl07kFdFGVSjzO40BHb+m8T5
         Lv6abyKrN0cTT9V/1Jcxa0m7wTnPnT+eYvi2JqmV/dYt/K2Vx5kgXiu5qK62YpI1S3tG
         4iGhl+LyeuE1ppAtXuabSxP9eDff/9YQHg4MJqVPMpVK76PzLGSZ+Warrka6AdqcgSit
         Pewacw4bqV5TFq6FsLfcSecVgClj5InpA3k1vtTIqr80zaOHcyPsRpB0K2FPpVoT1MIO
         Uxrg==
X-Gm-Message-State: AO0yUKU2LQsb25YQfu+mQfqsk6LvhV2nMgKr/6fcrMiT44prtEGuTDqJ
        BPLmOCDm7lzEPb88AZDIP8DGcA==
X-Google-Smtp-Source: AK7set9t21FQGrY3W3kzIuO4GG1ya+OKDDZ1egka2se57hr+Od2BhV1cCId99ypum9vJypivHR0qSg==
X-Received: by 2002:a17:906:fc09:b0:88d:ba89:1854 with SMTP id ov9-20020a170906fc0900b0088dba891854mr1304826ejb.37.1675259062555;
        Wed, 01 Feb 2023 05:44:22 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y9-20020aa7d509000000b004a2569f6ba0sm3722028edq.82.2023.02.01.05.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 05:44:21 -0800 (PST)
Date:   Wed, 1 Feb 2023 14:44:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     taoyuan_eddy@hotmail.com
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net: openvswitch: reduce cpu_used_mask memory
Message-ID: <Y9pstLgirSaKz9qh@nanopsycho>
References: <OS3P286MB22954422E3DD09FF5FD6B091F5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB22954422E3DD09FF5FD6B091F5D19@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 01, 2023 at 02:24:39PM CET, taoyuan_eddy@hotmail.com wrote:
>From: Eddy Tao <taoyuan_eddy@hotmail.com>
>
>'struct cpumask cpu_used_mask' is embedded in struct sw_flow.
>However, its size is hardcoded to CONFIG_NR_CPUS bits, which can be
>8192 by default, it costs memory and slows down ovs_flow_alloc.
>This fix uses actual CPU number instead
>
>Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>

Eddy, looks like you missed my second comment to v1. Could you please
check again?

Thanks!
