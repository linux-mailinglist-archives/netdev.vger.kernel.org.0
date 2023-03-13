Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7C6B6D87
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 03:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCMCb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 22:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCMCb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 22:31:57 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6FB35262;
        Sun, 12 Mar 2023 19:31:55 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y11so11396778plg.1;
        Sun, 12 Mar 2023 19:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678674715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nhk8CDnvFJowXUaawtA4ox8iWppQhZxwvraniyd/+/I=;
        b=GUAXoo4VoUxWv7bheTd/LJlepollsacgqv7Re8/zBhvAzwA2k3j6N6Qc/lEHw2ih3M
         4wWUjqCda9kynG3DQvwZYOGbecjyiNNMmZo0LRZ+nZFmSM2lCYWx/YoftJ5xfn7Eqcbl
         b4EeTopqBKYUsQOMcP3+QmsA7irq4xQA+Fg9YMxUO0T7rDitfQxiUag2lcAhh417f9dK
         lwpqMwilQGNIf8K5tpNlauoNusOz9YkNqLr1RKx03YdRJPC9VkkHjZ5ZDCxAYe+BbUsi
         zav1tglt6588X2VQ3O4pecBpjIttUw5UP5kvIE8phNgsVQxso9Kg1OKysn31EEajjrwA
         z7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678674715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nhk8CDnvFJowXUaawtA4ox8iWppQhZxwvraniyd/+/I=;
        b=79EdW8ReH7i3u21T7pFqcIr2kzS9A9nSw9FTh7d9NrPS79IqQjwHrtrLuAHRszWBD3
         B3R2pyb9xVvCeN0klFeDlilcNcTeEPsx6tuliIhtAaa+/FbrMW6B/kdb/Sdy3coF7Hky
         FZO/j1UhYutTooIdJJr2JqqFJeuXrcgQn8gegvJzaKMEcbLt2slKQ+eSfRfomxLdC9n7
         QG4uZ38Bllln92EnWvNsM9k1Aol01FBfjjThIBG7Dd+6UV0et0Wi8JssXUPwpqO3Qb/8
         fm7yskWcNmlY1VybkG5Zc/WPdSEkfTPd6MWCaBEgOa9bKGcYaWVwsDO4wDTn3Zvsi268
         pHzw==
X-Gm-Message-State: AO0yUKVRdYkMsmasqMrRCNyZvf6uNf4g5I3TWHDq+XCklN/A9+gUdRlA
        Um+DD1UKTCcEvhbk93aTZiM=
X-Google-Smtp-Source: AK7set8369YUlrTWQ7AtUKu+42FTgKAB0mZaSQ+CyfrdFWmRljDQipHRKfOjetLIBEg6K9O9LUqBFw==
X-Received: by 2002:a17:903:84e:b0:19d:1e21:7f59 with SMTP id ks14-20020a170903084e00b0019d1e217f59mr12377779plb.0.1678674715446;
        Sun, 12 Mar 2023 19:31:55 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902ee4600b0019a6d3851afsm3451076plo.141.2023.03.12.19.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 19:31:55 -0700 (PDT)
Date:   Sun, 12 Mar 2023 19:31:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v3] net: phy: micrel: Add support for
 PTP_PF_PEROUT for lan8841
Message-ID: <ZA6LGJZ2nWunT1xE@hoboy.vegasvil.org>
References: <20230307214402.793057-1-horatiu.vultur@microchip.com>
 <20230310163824.5f5f653e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310163824.5f5f653e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 04:38:24PM -0800, Jakub Kicinski wrote:

> AFAICT enabling a new output will steal the event from the previous one.
> Is this normal / expected? Should you be checking if any output is
> active and refuse to enable another GPIO if so?

The PTP class layer takes care of enabling and switching of functions
among the pins.  The functions (like periodic output) and the pins are
independent.  The user may free assign functions to pins, and
re-assign them at will.

When switching, class layer ensures that the pin support the function,
and it also takes care of disabling functions to avoid weird behavior.

See ptp_disable_pinfunc and ptp_set_pinfunc in drivers/ptp/ptp_chardev.c
 
> Richard, does the patch look good to you?

Yes, looks reasonable, mostly hardware specific.

Thanks,
Richard
