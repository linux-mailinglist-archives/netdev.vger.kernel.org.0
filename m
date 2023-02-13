Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA888694A51
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjBMPGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjBMPGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:06:20 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9B1CF4B;
        Mon, 13 Feb 2023 07:06:17 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id z13so8928018wmp.2;
        Mon, 13 Feb 2023 07:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R1rzLgzvsB9BwR77x6O/DdOBbqC4srqcO9LCeAj7ObI=;
        b=OIoJn5QWJ08in7vWs819eTUEIgI2Qlwl+Uo+uIFfA1n9JHF3paUQfpuVcYvUA47DP9
         d2uP+Dc7CdbLqqfGjBLZydjuyJEnhYml30qWO2T13/0E4LRj2Rb+NVpNflrZoaIFtim8
         L7+HbN906IRn8c+z+1Kl8taWjmJnWCeuQG2YlzG5rLquRzl5jn0wogRY+SPzzP9KdpjE
         QzlN5vRc7+jDJpmLU99Dh9fQIHri4Ov85Y4e13tGW2CLvxRqiSsoj27yNiE6ZyNxxRgf
         bicq1wTUpW+ZG1kjwHV6fz9u1Wu0YK8xdeGZsziDPm8zm6UjASAvQVGAns0aFh9x0gmw
         GBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R1rzLgzvsB9BwR77x6O/DdOBbqC4srqcO9LCeAj7ObI=;
        b=CI5siN8BKvPq2XnG2HW5P0XJeHdYgYsKZcWcDlhN6aI5gapmPGRUrewEK2BLHUeGjc
         6cx6FzGxe6zoQSpweifEEElkhdzCo6M0pjG8CKAhXDt6ScQjux/ywMD0g/NC2P773Un6
         6dxdJWmg/Vk4jMa3yxinwiCc4ZmuSBv5KXO3bLg+FP2WDmqszPxrxyUcCU8pSli2RDDR
         OGUZ9lJrqGTEQOouObGodu1zXN28UQkR/ExHLWlw3MpIr3Yju+WN7mQ/1afBOh5A5EUl
         23DWf+0IUYT6zRX8sXqGMTZZTB/d6fhN8jLdROW+pQyKbrUDRXqckVlT2BGA0ONeDv2E
         glYA==
X-Gm-Message-State: AO0yUKXZmIYP7RM2bdQ2zuS6KxeRiEom4BlMzI3KSHH5wMR1yZ68qg14
        2FhZiuZnCJecBPy+xvcf/6E=
X-Google-Smtp-Source: AK7set9IGCVLfth33G9aV0RyaLjZaENmQqa7AvYWqD5xtHua8kxL+G7V9b2JeCwdQUCU4tKIkRnguw==
X-Received: by 2002:a05:600c:319e:b0:3dc:5dd4:7d3f with SMTP id s30-20020a05600c319e00b003dc5dd47d3fmr18726223wmp.24.1676300776344;
        Mon, 13 Feb 2023 07:06:16 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e1-20020a05600c4e4100b003dc49e0132asm17779341wmq.1.2023.02.13.07.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 07:06:15 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:06:09 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 02/10] net: microchip: sparx5: Clear rule
 counter even if lookup is disabled
Message-ID: <Y+pR4RZ8wJYFgSHL@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-3-steen.hegelund@microchip.com>
 <Y+ofJK2psEnj9QNh@kadam>
 <c5920cb1f3db053c705a988cf484bbbaa5c3dcfa.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5920cb1f3db053c705a988cf484bbbaa5c3dcfa.camel@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 01:44:35PM +0100, Steen Hegelund wrote:
> > > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > index b2753aac8ad2..0a1d4d740567 100644
> > > --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > > @@ -1337,8 +1337,8 @@ static void vcap_api_encode_rule_test(struct kunit
> > > *test)
> > >       u32 port_mask_rng_mask = 0x0f;
> > >       u32 igr_port_mask_value = 0xffabcd01;
> > >       u32 igr_port_mask_mask = ~0;
> > > -     /* counter is written as the last operation */
> > > -     u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 792};
> > > +     /* counter is written as the first operation */
> > > +     u32 expwriteaddr[] = {792, 792, 793, 794, 795, 796, 797};
> > 
> > So this moves 792 from the last to the first.  I would have expected
> > that that would mean that we had to do something like this as well:
> > 
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > index b2753aac8ad2..4d36fad0acab 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> > @@ -1400,7 +1400,7 @@ static void vcap_api_encode_rule_test(struct kunit
> > *test)
> >         /* Add rule with write callback */
> >         ret = vcap_add_rule(rule);
> >         KUNIT_EXPECT_EQ(test, 0, ret);
> > -       KUNIT_EXPECT_EQ(test, 792, is2_admin.last_used_addr);
> > +       KUNIT_EXPECT_EQ(test, 797, is2_admin.last_used_addr);
> >         for (idx = 0; idx < ARRAY_SIZE(expwriteaddr); ++idx)
> >                 KUNIT_EXPECT_EQ(test, expwriteaddr[idx],
> > test_updateaddr[idx]);
> > 
> > 
> > But I couldn't really figure out how the .last_used_addr stuff works.
> > And presumably fixing this unit test is the point of the patch...
> 
> It is just the array of addresses written to in the order that they are written,
> so for the visibility I would like to keep it as an array.
> 

My question was likely noise to begin with, but it's not clear that I
phrased it well.  I'm asking that since 797 is now the last element in
the array, I expected that the KUNIT_EXPECT_EQ() test for last_used_addr
would have to be changed to 797 as well.

regards,
dan carpenter

