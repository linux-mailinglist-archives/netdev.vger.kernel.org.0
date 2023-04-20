Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A816E9AB3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDTR1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDTR1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:27:01 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335951FE3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:27:00 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2a8bdcf87f4so6381951fa.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1682011618; x=1684603618;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k45Am+UoebIhryZB06Rxm33p8hZcG66w1x0wAJk1o4c=;
        b=3n4yqbD9jDzVlJEGce4w5Bxx2jgWN7Jk5r7vT9j7o91LZgf8PR16a2oDFhxSxEDgVj
         Ts4QYsHgG+RXM/ywgXN5KC3QmB55oUdpX2jExptDpTzuaTp2eA0PzJMcIji9bYOVoUCg
         cV0Y07TzYVng8y//VqUVRN5oKeHDu2iFIpebi5a59z55GXRb80Utgfx7kwF6lUTsctkl
         IFCUSJeo4VHZfGHuckrCsfjw/z1ImSAdt+jnOzq/99yItB04QWDWgx9s/oJ7f8cjiFiL
         1DbrPoKKWVAO2sw/Rdh5tpjwZ0xcapkV/n0UQsnV9ZoT1X4jiFOlMjFn8p8j0Fz+2o5/
         supw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011618; x=1684603618;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k45Am+UoebIhryZB06Rxm33p8hZcG66w1x0wAJk1o4c=;
        b=Qm/w/7WhWYjh1g07KbVNjA3qc+2o5OgQ46iAXUsVMeKea0VSP8FJWE7l7avQ6giQbD
         TSuSJtFVu3nd9a5cCunmzJPYrLza7taf11hohcMkHVtWw1DGycd/d6HeMXMBEH5W+fsS
         DPzWfGxoeCRXNXqnui6LI4kHM0h/QhWJZbByctHaeTvNWXH5vflWBlIcfbnNWT4tee2o
         Nl2UcvjMLxncQLhUn4mj0G43wLr/fli4hgb5WMFpd8qEzfzYrpR+X7QJfKgRUHz6FVXJ
         TLC35VqS0zjQfNKQiNDQ7+a5Leh6IXD+dYQDwRHHBpK1hkYCGyNlveiZWf3bqwwMEPp0
         ik9g==
X-Gm-Message-State: AAQBX9eQP7+m9qzGVzooko1hJ8qnZWoUy/hkoSDe1kszit9P4eLz2yQx
        3Lhgdj+iXR7So4FSChyXW5UvYg==
X-Google-Smtp-Source: AKy350YJbFzhXURkI4GXJL/W/hIdXtZsmfbw9VSJh3UKhksFP6mm3YAJ/qur88jv9UcubRHQcATYbQ==
X-Received: by 2002:ac2:559a:0:b0:4ee:e10f:8e5f with SMTP id v26-20020ac2559a000000b004eee10f8e5fmr408010lfg.4.1682011618354;
        Thu, 20 Apr 2023 10:26:58 -0700 (PDT)
Received: from debian (c188-148-248-178.bredband.tele2.se. [188.148.248.178])
        by smtp.gmail.com with ESMTPSA id g13-20020a19ee0d000000b004edc3ed050asm283784lfb.170.2023.04.20.10.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:26:58 -0700 (PDT)
Date:   Thu, 20 Apr 2023 19:26:56 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v4] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZEF14CpayXvwPthJ@debian>
References: <ZEFqFg9RO+Vsj8Kv@debian>
 <179e7571-6cfa-4f54-b8aa-0b75600242cb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179e7571-6cfa-4f54-b8aa-0b75600242cb@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 06:49:13PM +0200, Andrew Lunn wrote:
> On Thu, Apr 20, 2023 at 06:36:38PM +0200, Ramón Nordin Rodriguez wrote:
> > This patch adds support for the Microchip LAN867x 10BASE-T1S family
> > (LAN8670/1/2). The driver supports P2MP with PLCA.
> > 
> > Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> > ---
> 
> Hi Ramón
> 
> So the history is in the wrong place. It should be here, under the ---
> I've no idea what 'git am' will make of this patch, if it will
> apply. You should try saving the email and applying the patch yourself
> and see if it works.
> 
> And my Reviewed-by: has not been added.
> 
>     Andrew

Dang it, I thought I had done every misstake already :(
