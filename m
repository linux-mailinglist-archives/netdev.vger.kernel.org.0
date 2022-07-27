Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC735829E3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiG0PoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiG0PoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:44:14 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C15148C9A
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:44:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf4so32226984ejc.3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 08:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/3b25UFEUGgtIkGSiZ+/VFPsXw+QryVykEE0VNj8qps=;
        b=ZPM5MoHyakB9Ragxd74gjThkBAaYTvP/zeS76wOmXXDM5oRmLGaUiidf1imBdPFfVR
         WLDmr314MGfbuDGyS3HMypQ8WqGHOCAZxf9j3x2WDWuDGQimjSLgaHr96Z7zB44gsAzB
         ohAasKM7PCNi9o+uRsg08GLEPmFpQB7Nzv8SEUg0BoXbmtTzLMrfPILYlNWUx84/V1GJ
         LHeen/TTCkMcXtn10ge/t0Pm7KT+Cs4lEM/vHgIKE6BcO3nsy8bLL3KzbmIxkda93S/T
         AxhTPQu8pHqZK06hOezfOx4a9owD9X8EUIIpAuvtVE0RAc2YGkKSUxi9KCu61VjTnLyc
         gb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3b25UFEUGgtIkGSiZ+/VFPsXw+QryVykEE0VNj8qps=;
        b=ch6OMY6jkM3WhSxz1meylG+fot4UzLuuDRGdilTumo3ZMI829BOuApmzlhDB7T8tvr
         jClRJX+GlvkZ1vcSCskhDKkhSIcZeQzHNuRXpwLO3e3Gas6QkprMkrELcxjpV4k4y7jS
         SdTHHUm6dg6k76U8bcSUOsEN9+tApKqdlE49kuS54UkfDaZBUiBsKLEdehfyr45CPBh6
         N56zblfSiJWF7oz8t+G6rCVpOdmzTlvURMHQzKbi9JstFmPSHjfQnWoiJLLidJEk1NIk
         47Ln3KLEte6rvG0iX+Ywz5GAhm35v3qNPMbCB+30if73FIK7svlWXJ0OuPjFfhlc+tfD
         i/HQ==
X-Gm-Message-State: AJIora9uYT0UMJc5zSs6b4fe1BYHMNg/O9qDwCtS2JzPdlOqX3bO1LzS
        i4C5S0hx3HOPO+3EL+6Efu3cDQ==
X-Google-Smtp-Source: AGRyM1suDl8y6YxHHY+v4BZFPVGCW60LY9ipe+ux4yBQBWdEFzdHJMcwBcS5HZ1yj5yEezG7iIhHCw==
X-Received: by 2002:a17:907:1608:b0:72e:e254:7baa with SMTP id hb8-20020a170907160800b0072ee2547baamr18799355ejc.672.1658936651857;
        Wed, 27 Jul 2022 08:44:11 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906315400b0072fa1571c9asm7091715eje.104.2022.07.27.08.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 08:44:11 -0700 (PDT)
Date:   Wed, 27 Jul 2022 08:44:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net/sched: make dev_trans_start() have a better
 chance of working with stacked interfaces
Message-ID: <20220727084404.34ebf5e6@hermes.local>
In-Reply-To: <20220727152000.3616086-1-vladimir.oltean@nxp.com>
References: <20220727152000.3616086-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 18:20:00 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> +	do {
> +		have_lowers = false;
> +
> +		netdev_for_each_lower_dev(dev, lower, iter) {
> +			have_lowers = true;
> +			dev = lower;
> +			break;
> +		}
> +	} while (have_lower

Would be clearer if this was a helper function.
Something like dev_leaf_device?
