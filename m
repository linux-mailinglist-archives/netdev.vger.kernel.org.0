Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D652B672241
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjARP6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjARP6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:58:12 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADA554112;
        Wed, 18 Jan 2023 07:54:49 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s3so12045337edd.4;
        Wed, 18 Jan 2023 07:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZHx1W6Im0AAVrkt1vkJpP0bt8cH6ZQdLH1hoiDQ5cU=;
        b=BKu4SUbECbChv/wm5R6hS5kLxwlEgMGCUddf+ydxofEh8HabYezUxk4+ntsN50/W8/
         GjdLjdqXd55eLxstmYEUEGbrkHRBjzBDALv7uVmHqv3h4CrXyMbqN/TmnKjbpUKA5Vjm
         6xNYfMEjekxtlj/BEQvgVrqn43pSH5JBpC7ewxvM2n7CpReJSJNJm4P7qcOCcQaILyyU
         KajCsXK/aaoG8B8c41KRvmX+KvZHNVJrAL1/AX3U82cdeIE05ZHQx4dSeEbhDgIPnQ1U
         cuOHRrIJrIHWaTQUtFc5rr8EojRgPG/jKrCK2CmIfUAC5za59nSJsKnenJvZmJ3TrxF5
         xsNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZHx1W6Im0AAVrkt1vkJpP0bt8cH6ZQdLH1hoiDQ5cU=;
        b=oBEyH1hhuDG3nXiQeMe8vmpaAZlOnp1TEY1lLQKuJFRFZ3L9c0kg4kntN2Au5Cc6Cq
         UX8+01OtIQQW6bnmdosGkKzd4EnycpXOGuyDmFyCMTHFaKW7NItBM/+IG/jVHO7E+i1e
         61Hx/CDzvdiWY50j+VACx0+8q/XwZuSuTmbC4M8jXZ4HQD4PzrO4EIg4fC6MalezSARA
         W7YvBo0Gcgyg38vhA6KYkekea7fvOf56UqOH5Char9XN5ilFTfzKQPXQBSV0Zn1xU/bF
         8uwozuizCZPLFAbCBOsIzSNJrDofbr3HERFQ3VdQwB+QIuDEnOVxrBz/9JJqfWpwwN+b
         vkeQ==
X-Gm-Message-State: AFqh2kpZiNoQxeQ8zqCy/FB8UJPGfaOlFCRQrqHysVlkvSpT/tIj4nu9
        oVrukQT5CyhuxypYsiOlWhoJTgc29YRyAQmv
X-Google-Smtp-Source: AMrXdXsRLugV4KTmD0ylnJVOcnTheCZMkeqJfEiPoLRM/pCshlheOIB/3K/3l3XjIYL0arjiPvHWAQ==
X-Received: by 2002:a05:6402:2055:b0:479:6c4f:40df with SMTP id bc21-20020a056402205500b004796c4f40dfmr7035191edb.18.1674057287918;
        Wed, 18 Jan 2023 07:54:47 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id dk1-20020a0564021d8100b0049be07c9ff5sm7145943edb.4.2023.01.18.07.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:54:47 -0800 (PST)
Date:   Wed, 18 Jan 2023 16:54:49 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH net-next 1/1] drivers/phylib: fix coverity issue
Message-ID: <Y8gWSZr5XL3r02rm@gvm01>
References: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
 <20230117192604.77a16822@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117192604.77a16822@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:26:04PM -0800, Jakub Kicinski wrote:
> On Tue, 17 Jan 2023 22:47:53 +0100 Piergiorgio Beruto wrote:
> > Subject: [PATCH net-next 1/1] drivers/phylib: fix coverity issue
> 
> The title of the patch should refer to the bug rather than which tool
> found it.
> 
> here, for eaxmple:
> 
>   net: phy: fix use of uninit variable when setting PLCA config
> 
> > Coverity reported the following:
> > 
> > *** CID 1530573:    (UNINIT)
> > drivers/net/phy/phy-c45.c:1036 in genphy_c45_plca_set_cfg()
> > 1030     				return ret;
> > 1031
> > 1032     			val = ret;
> > 1033     		}
> > 1034
> > 1035     		if (plca_cfg->node_cnt >= 0)
> [snip]
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> > Addresses-Coverity-ID: 1530573 ("UNINIT")
> > Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
> 
> nit: the tags are in somewhat unnatural order. Since you'll need to
> respin for the subject change, this would be better:
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> 
> (Yes, the custom coverity tag can go meet its friends in the bin)
Thanks Jakub,
I just fixed that.

Kind Regards,
Piergiorgio
