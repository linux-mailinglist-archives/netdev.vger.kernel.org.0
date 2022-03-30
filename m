Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE01D4EBCFA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244472AbiC3Iyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiC3Iyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:54:37 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475CF6575
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:52:53 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-df0940c4eeso7962995fac.8
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKK8+BP7NtxMv6qMYZH++exm47xoAXQBFDmzLBKFFEk=;
        b=Q/1QqH8fwztO9EvHEkorpaktENhQymoHQzhwzKfgkvf8CAw04OQ3/+/mANcXLhrwfw
         DrHaNXxdbBB5HUea/Fg3Lwauae2/Nqjr8vU7ZE0RqZ3OcE4iV4qZtsl4Jb5Zy1QxohQO
         pfiNmNYa/33X1m0qx52U/9fYqcqrzFVE22TTQ3zZIQoH752l810vWRdjf5eEZDwVWEr9
         93lYgJFoysga5KAupuVq4tgqmUUC7z/wZSce+NxQ3AiI3MNtZwul8m73UTqq4zFd1FL2
         p+/c8X5zgoN0qTROTGUZb0fDrBbSb7Vy7SBi5XHyAJG7tDyjhnQWz73B9KRF+XVYmr0/
         zi6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKK8+BP7NtxMv6qMYZH++exm47xoAXQBFDmzLBKFFEk=;
        b=iI4piIRTXrn164ZVdka4r/CKZr0f0TIvmMrlyHFMrUlZCkUVNfLqaufIKK7Tk6Ch2P
         jOCIQrsOCBbVfrxBAc9LXVrp+8wzPH8JMgwhzTWDszTR6XPezNGDG8dPtYoozJlmoawf
         FxrDgDLJ1Z2FiDVI2A8WbNLyrhTfPY2GdDP0Lqo3pZqAgoKVslISP3tUFgaD5SbVY9Og
         jcqj3eW+bYZXc16x3adAJWMBPfLDdAiQdRrZ/ItcpE9nZwZDvTXzsTi8TsDoOEEk18kp
         qC9MVKp5PubKf7BUQLccTjjYAiw8uKb/QE+MmT8jJan9xc8NouV2ObyHjFi3fqEAWcVs
         iBMw==
X-Gm-Message-State: AOAM532WilT3z0Gley4SVNNxWabkyfAIQiE/pVl+pgiVZRyWjvKW9p8B
        YtNAqOy1pLaZWr9yWjy4C7riq4Rw/TaWerF9IiKwv7JUDEo=
X-Google-Smtp-Source: ABdhPJyoD7mvxWMcFkCd1XozTD5RmNF+aVQJlac3n/hu2/Scsd5osI9K5Mz2gkhtfF4K87i05JGRHOrWlyPQ5hcQy30=
X-Received: by 2002:a05:6870:4789:b0:dd:e6e0:2471 with SMTP id
 c9-20020a056870478900b000dde6e02471mr1617098oaq.195.1648630372658; Wed, 30
 Mar 2022 01:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
 <20220329024921.2739338-5-andy.chiu@sifive.com> <20220329155609.674caa9c@kernel.org>
 <YkOxexKUQqmFVe9l@lunn.ch> <20220329184819.6d4354b6@kernel.org>
In-Reply-To: <20220329184819.6d4354b6@kernel.org>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 30 Mar 2022 16:50:35 +0800
Message-ID: <CABgGipWrV_+AKvmJzNAqcwx34pgTt8OLX-gp342-WfDZAaTWmw@mail.gmail.com>
Subject: Re: [PATCH v7 net 4/4] net: axiemac: use a phandle to reference pcs_phy
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, radhey.shyam.pandey@xilinx.com,
        Robert Hancock <robert.hancock@calian.com>,
        michal.simek@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks for explaining this,

I will make the change accordingly and post it to net-next when available.

Andy
