Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A75559889
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 13:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiFXLXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 07:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiFXLXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 07:23:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7615C17E17;
        Fri, 24 Jun 2022 04:23:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z11so2976261edp.9;
        Fri, 24 Jun 2022 04:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=97l5C7KYjI62mLTEaSBvh8q8hin604D+5jLnZw8o8Hs=;
        b=gGsd16xApVKpT/QOG6PyUQzbcvKy4PkecAqb4plJuQMkKESiQd5Snhy6ig8Cv4wtfT
         hY8GVKO1cVP4LQPxMSKIOy/z3+HW5AqITfde0UU2CqxbPt8kpAUBJEgMJmhwOPKpK/wz
         iGTEpMNFcvgFEwLihX+vyh9vVD86SJMUgB09evZoZKaA+p8/mS01MDXrt08srEsIKob7
         FujT9R0RRWXDIQuSBYh7/clCHQO8jCvPN3dCglBALhWbqoKzQTQBoF6bW9raBMyy22Ra
         xi2DH7HwV8hP7KvsVM9fzUQRQULr/0y1I7EKQS2mu4eiNEBzJLsE4uwcRsIt6ocqgJZt
         KgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=97l5C7KYjI62mLTEaSBvh8q8hin604D+5jLnZw8o8Hs=;
        b=vtPlWci1vRjzzDsY3TOir9IPJEu8rGokszu2wjK8OU1p4wDVMVEjxc1YHJ24UoFhll
         vDsstXbXL4+VCM7KQjbagQ8l/jABN3PqjpL49py8ETfRm7oomzQO05qTm4kRVl5aqNg9
         S34mQflS/LiMqpZ5mcvbTql0UWxQezjO2qtbRnHwwwxIQyS3OrOQM/jHLb9uo4PVMiqT
         +HunMhuS1Ar9lolLLxQvHj6Xf4oV2v1cctlMyITrHJNuvxUM+yEmdjtZ2esZnEE9eL6J
         EsvOwXI91mq9C/433Tbnhka+jfgnL8figIWxSJP2rmnqpad9XYF5MLYrrQkcFXEt3mcP
         bqPA==
X-Gm-Message-State: AJIora8lhHHvvFFoMQGd6lK3LdoKjayqajGZraC4DFhaZhVMETdDy5ah
        WeL7os/FubQivWkGvu/yWJ0Yhl4gBDg=
X-Google-Smtp-Source: AGRyM1sp0z4XwfeMfTfnogDy8QZgeG5xuxDpxgASKZ3PAEsgPyjKdlX2fKg+NZZqIXQhQtCPdlB7+g==
X-Received: by 2002:a05:6402:4144:b0:431:6ef0:bef7 with SMTP id x4-20020a056402414400b004316ef0bef7mr17147768eda.151.1656069787952;
        Fri, 24 Jun 2022 04:23:07 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id d18-20020a05640208d200b00435bfcad6d1sm1757991edz.74.2022.06.24.04.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 04:23:06 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:23:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch net-next 00/13] net: dsa: microchip: common spi probe for
 the ksz series switches - part 2
Message-ID: <20220624112304.zg5qypzwervonsvc@skbuf>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 02:34:12PM +0530, Arun Ramadoss wrote:
> This patch series aims to refactor the ksz_switch_register routine to have the
> common flow for the ksz series switch. And this is the follow up patch series.
> 
> First, it tries moves the common implementation in the setup from individual
> files to ksz_setup. Then implements the common dsa_switch_ops structure instead
> of independent registration. And then moves the ksz_dev_ops to ksz_common.c,
> it allows the dynamic detection of which ksz_dev_ops to be used based on
> the switch detection function.
> 
> Finally, the patch updates the ksz_spi probe function to be same for all the
> ksz_switches.

Sorry for being late to the party again. I've looked over the resulting
code and it appears that there is still some cleanup to do.

We now have a stray struct ksz8 pointer being allocated by the common
ksz_spi_probe(), and passed as dev->priv to ksz_switch_alloc() by this
generic code.

Only ksz8 accesses dev->priv, although it is interesting to note that
ksz9477_i2c_probe() calls ksz_switch_alloc() with a type-incompatible
struct i2c_client *i2c that is unused but bogus.

The concept of struct ksz8 was added by commit 9f73e11250fb ("net: dsa:
microchip: ksz8795: move register offsets and shifts to separate
struct"), and in essence it isn't a bad idea, it's just that I wasn't
aware of it, and only ksz8 makes use of it.

You've added some register offsets yourself to ksz_chip_data
(stp_ctrl_reg, broadcast_ctrl_reg, multicast_ctrl_reg, start_ctrl_reg),
and it looks like struct ksz8 shares more or less the same purpose -
regs, masks, shifts etc. Would you mind doing some more consolidation
work and trying to figure out if we could eliminate a data structure
unique for ksz8 and integrate that information into struct ksz_chip_data
(and perhaps use it in more places)?
