Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530096BEF2C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCQRHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCQRHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:07:08 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C313BC42;
        Fri, 17 Mar 2023 10:06:52 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id hf2so2171690qtb.3;
        Fri, 17 Mar 2023 10:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072811;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7slRHzySkFpcs5sLGs5rs/Zo/tii5Gf2oRkxqfYc3ME=;
        b=Kek04f79WnaIcT+dOUXzrQKuP0dZR/Hy+AiojA/r63kjHTdvE/Cmir3cvlHv7XTfwN
         /Y4TC0PngTzR69ghb8F5YuioSN1SS0rxw8yNKQ4dD1531Sm5wGSPMVISCLz3umafy20R
         rduGwvliVdc7QiQaP9r0lPcYkPQWj5LEvCj/IaYihkr7QPQv2NofTj4kV1RSz22D0xI7
         Wws32N4FMhHSwHqcqzstQt9/qf73rZyjskLuwxsIez6ttoNqhiQGS5XwyNdmj0s3Lhvy
         M+EVCwgYjLtl6TvqF5fTYUzDU1hPaYolekGiGHaO7towujgh0+COmfh4b07Aymva98mW
         n5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072811;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7slRHzySkFpcs5sLGs5rs/Zo/tii5Gf2oRkxqfYc3ME=;
        b=8GDms6pAFg7ObAgzO4qwNks05991qWn0bndJApGY/zZDPOfkhtBkeHvFMlfZ8x6nKL
         5lSYWhEtsRdqDB8eN8phSGc26ftu1KPOFlUf2L8XFc2ZYG6Q0CkSOh8rfHdFBPKqBgtv
         hjwN904Qxoety9YkHq1zCdDEKNP15WCdvOwXrPe7BxP9DIQwVRPo2yQuqQu6NhdGXhc3
         mw7EQkyBeKIWJBFg1OapjAm5I0fXcOjr7d06TWF24zhnehErr5pQ8OGkMwLBQ4TDNhJt
         92YJs0m81g6axy0pPWI0UVboNU8p26SwxRiAb2rCQa98krtnI3oxD8SOCFn0cZGZsEQX
         umcQ==
X-Gm-Message-State: AO0yUKWZIrZqu/F9jO7CdyMOc5HrbDYC5VHu8NUPmAgRIolOmSnvR6zb
        u3RxSc8C/+WtnjXgEE/ftSc=
X-Google-Smtp-Source: AK7set9tbs+OBNF02rY6nczH2fMQnZFsgV7XWhxNUpRTYF8aKuOHUUvYQAq5a/s9/aYuF+xxgbOpng==
X-Received: by 2002:a05:622a:87:b0:3d8:8d4b:c7cb with SMTP id o7-20020a05622a008700b003d88d4bc7cbmr9944778qtw.40.1679072811617;
        Fri, 17 Mar 2023 10:06:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v15-20020ac8728f000000b003d872f97722sm1584977qto.78.2023.03.17.10.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:06:50 -0700 (PDT)
Message-ID: <2fa5e5ce-3198-fd38-a0cd-88698282338c@gmail.com>
Date:   Fri, 17 Mar 2023 10:06:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 1/4] net: dsa: mv88e6xxx: don't dispose of
 Global2 IRQ mappings from mdiobus code
Content-Language: en-US
To:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-2-klaus.kudielka@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315163846.3114-2-klaus.kudielka@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 09:38, Klaus Kudielka wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> irq_find_mapping() does not need irq_dispose_mapping(), only
> irq_create_mapping() does.
> 
> Calling irq_dispose_mapping() from mv88e6xxx_g2_irq_mdio_free() and from
> the error path of mv88e6xxx_g2_irq_mdio_setup() effectively means that
> the mdiobus logic (for internal PHY interrupts) is disposing of a
> hwirq->virq mapping which it is not responsible of (but instead, the
> function pair mv88e6xxx_g2_irq_setup() + mv88e6xxx_g2_irq_free() is).
> 
> With the current code structure, this isn't such a huge problem, because
> mv88e6xxx_g2_irq_mdio_free() is called relatively close to the real
> owner of the IRQ mappings:
> 
> mv88e6xxx_remove()
> -> mv88e6xxx_unregister_switch()
> -> mv88e6xxx_mdios_unregister()
>     -> mv88e6xxx_g2_irq_mdio_free()
> -> mv88e6xxx_g2_irq_free()
> 
> and the switch isn't 'live' in any way such that it would be able of
> generating interrupts at this point (mv88e6xxx_unregister_switch() has
> been called).
> 
> However, there is a desire to split mv88e6xxx_mdios_unregister() and
> mv88e6xxx_g2_irq_free() such that mv88e6xxx_mdios_unregister() only gets
> called from mv88e6xxx_teardown(). This is much more problematic, as can
> be seen below.
> 
> In a cross-chip scenario (say 3 switches d0032004.mdio-mii:10,
> d0032004.mdio-mii:11 and d0032004.mdio-mii:12 which form a single DSA
> tree), it is possible to unbind the device driver from a single switch
> (say d0032004.mdio-mii:10).
> 
> When that happens, mv88e6xxx_remove() will be called for just that one
> switch, and this will call mv88e6xxx_unregister_switch() which will tear
> down the entire tree (calling mv88e6xxx_teardown() for all 3 switches).
> 
> Assuming mv88e6xxx_mdios_unregister() was moved to mv88e6xxx_teardown(),
> at this stage, all 3 switches will have called irq_dispose_mapping() on
> their mdiobus virqs.
> 
> When we bind again the device driver to d0032004.mdio-mii:10,
> mv88e6xxx_probe() is called for it, which calls dsa_register_switch().
> The DSA tree is now complete again, and mv88e6xxx_setup() is called for
> all 3 switches.
> 
> Also assuming that mv88e6xxx_mdios_register() is moved to
> mv88e6xxx_setup() (the 2 assumptions go together), at this point,
> d0032004.mdio-mii:11 and d0032004.mdio-mii:12 don't have an IRQ mapping
> for the internal PHYs anymore, as they've disposed of it in
> mv88e6xxx_teardown(). Whereas switch d0032004.mdio-mii:10 has re-created
> it, because its code path comes from mv88e6xxx_probe().
> 
> Simply put, this change prepares the driver to handle the movement of
> mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.
> 
> Also, the code being deleted was partially wrong anyway (in a way which
> may have hidden this other issue). mv88e6xxx_g2_irq_mdio_setup()
> populates bus->irq[] starting with offset chip->info->phy_base_addr, but
> the teardown path doesn't apply that offset too. So it disposes of virq
> 0 for phy = [ 0, phy_base_addr ).
> 
> All switch families have phy_base_addr = 0, except for MV88E6141 and
> MV88E6341 which have it as 0x10. I guess those families would have
> happened to work by mistake in cross-chip scenarios too.
> 
> I'm deleting the body of mv88e6xxx_g2_irq_mdio_free() but leaving its
> call sites and prototype in place. This is because, if we ever need to
> add back some teardown procedure in the future, it will be perhaps
> error-prone to deduce the proper call sites again. Whereas like this,
> no extra code should get generated, it shouldn't bother anybody.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

