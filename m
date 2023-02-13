Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4CE69447E
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBML35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjBML3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:29:55 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D5B4ECF;
        Mon, 13 Feb 2023 03:29:54 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h16so11790795wrz.12;
        Mon, 13 Feb 2023 03:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=29cotRY8olSt/JYYtGB2s8s028o/PqY0E2+IMOnq410=;
        b=cvTOwHA5P1RuT18R4SMIL8vw8EhPdJMY2nFPsYF9Juc9jCsrHVUZYT6EI0gxh3g89V
         PSkHhkVTSBNYQQF3eRU/LXkGQ6w6QesEug5xP1nWJqBCs3kbcJiE8//4vhF1u20/lTXm
         0hhwf0+faShv2R6QfUyTsepAwQ5e10JXsp59oRUF46UrXKypNI4qkWxW4SURPuYt9d49
         OyKiplh5pbtnT+9WZoGFqz0v0fpDag/6sbMOJ7gEawOkYMt7vZSJHcB7ICMaaGCH0UMs
         i0KXamiGln4vJQ8VPfgXV4fQNY2Zdp1+FRBRTWULFSiPkANa0Gsjo1trCWetyrZ7T9lk
         nyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29cotRY8olSt/JYYtGB2s8s028o/PqY0E2+IMOnq410=;
        b=c5oqNxNZ+8RALH+TXZbNKh17J/aSsao0YFK2HJmMLAME3HX/xmIjB7CFvr71vOHPW/
         /BcLajP5K42C80drRPOn1TM4UZ6Ksplxix7FirLuBDEmJ0A0XLC2KvPFe6DXH6vvz3Cq
         Gki6mrnog8QV4vtPhU8Coc1B+Ia/FUze8KkBkD2SQqqsFOjCdJiYepVtFZdxNJKH+Y2E
         w3beF4IYRkQ2iBan7C3OGyh3I9IPw38fWlJykTiCo5CScCm8+AxWEC8aqiXbjVhE99np
         QS3UR7iRp0BZbll8c9UQWV2YwL1sfDBRh+ZFmCzrUp/1KAVX9MaMUVcl3ctqnAhjfucb
         +GCA==
X-Gm-Message-State: AO0yUKWY26T/OyGZ1RPW13LHMFvnvICMlS4iUXhwb1NTct0ka+VqJkHa
        AnJ2/BFRYdasN/1XKi0pshitX5SvJhUNOWZ5
X-Google-Smtp-Source: AK7set9MGW9s+/74bNo+qw3i8ovXTw0o+d3jQoj/0ee3iNAfxvYbHjil5qIcl45IkAJWWwTN50NAqw==
X-Received: by 2002:adf:d0c2:0:b0:2c3:e7f5:be8c with SMTP id z2-20020adfd0c2000000b002c3e7f5be8cmr20547993wrh.26.1676287793147;
        Mon, 13 Feb 2023 03:29:53 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h12-20020adff4cc000000b002be505ab59asm10418893wrp.97.2023.02.13.03.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:29:52 -0800 (PST)
Date:   Mon, 13 Feb 2023 14:29:40 +0300
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
Message-ID: <Y+ofJK2psEnj9QNh@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213092426.1331379-3-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 10:24:18AM +0100, Steen Hegelund wrote:
> The rule counter must be cleared when creating a new rule, even if the VCAP
> lookup is currently disabled.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>

Is this a bugfix?  If so what are the user visible effects of this bug
and please add a Fixes tag.  If not then could you explain more what
this patch is for?

> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api.c       | 7 +++++--
>  drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> index 6307d59f23da..68e04d47f6fd 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> @@ -2246,6 +2246,11 @@ int vcap_add_rule(struct vcap_rule *rule)
>  	if (move.count > 0)
>  		vcap_move_rules(ri, &move);
>  
> +	/* Set the counter to zero */
> +	ret = vcap_write_counter(ri, &ctr);
> +	if (ret)
> +		goto out;
> +
>  	if (ri->state == VCAP_RS_DISABLED) {
>  		/* Erase the rule area */
>  		ri->vctrl->ops->init(ri->ndev, ri->admin, ri->addr, ri->size);
> @@ -2264,8 +2269,6 @@ int vcap_add_rule(struct vcap_rule *rule)
>  		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
>  		goto out;
>  	}
> -	/* Set the counter to zero */
> -	ret = vcap_write_counter(ri, &ctr);
>  out:
>  	mutex_unlock(&ri->admin->lock);
>  	return ret;
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> index b2753aac8ad2..0a1d4d740567 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> @@ -1337,8 +1337,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
>  	u32 port_mask_rng_mask = 0x0f;
>  	u32 igr_port_mask_value = 0xffabcd01;
>  	u32 igr_port_mask_mask = ~0;
> -	/* counter is written as the last operation */
> -	u32 expwriteaddr[] = {792, 793, 794, 795, 796, 797, 792};
> +	/* counter is written as the first operation */
> +	u32 expwriteaddr[] = {792, 792, 793, 794, 795, 796, 797};

So this moves 792 from the last to the first.  I would have expected
that that would mean that we had to do something like this as well:

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index b2753aac8ad2..4d36fad0acab 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1400,7 +1400,7 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	/* Add rule with write callback */
 	ret = vcap_add_rule(rule);
 	KUNIT_EXPECT_EQ(test, 0, ret);
-	KUNIT_EXPECT_EQ(test, 792, is2_admin.last_used_addr);
+	KUNIT_EXPECT_EQ(test, 797, is2_admin.last_used_addr);
 	for (idx = 0; idx < ARRAY_SIZE(expwriteaddr); ++idx)
 		KUNIT_EXPECT_EQ(test, expwriteaddr[idx], test_updateaddr[idx]);
 

But I couldn't really figure out how the .last_used_addr stuff works.
And presumably fixing this unit test is the point of the patch...

regards,
dan carpenter
