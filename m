Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC957BCCA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiGTRhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 13:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241392AbiGTRhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 13:37:21 -0400
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9FF5D0F3;
        Wed, 20 Jul 2022 10:37:20 -0700 (PDT)
Received: by mail-ot1-f41.google.com with SMTP id g20-20020a9d6a14000000b0061c84e679f5so12002675otn.2;
        Wed, 20 Jul 2022 10:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6J3sgJghVNNrzVGnT5K48UuGJ4l1PbhybPRZEBzs0E=;
        b=3KqcPs8xLw9RVr8PUyvtV2BZDB18UdZi7DJO5dwMB7xlPfXLK++8KO7r7rUp1VZp4y
         P26d2KVGg1lC062cvS8kLuw7gtiiGlYG2OcRrmh3BaxCuhXEeJhnDcvzHybXZIdIbF86
         wp55/cvRZZrAVKxu7VFNT30/YO7vVureOHIrw5oAmV3YKaVqYhejqnJEwxYMqLqmIKEE
         hJclyHhD/90cAjGOKBMSiS4Tn+7O1jcxx1Drcvw4ydbMlStBDZ51hqy+7oE9G8GEEe9o
         E1al7c/nNL23JYS4hZoXo4sr+CG2VOHwTsKcIFTtWHbtFDyejLErNoupPdNMSQ7Cxy59
         td+A==
X-Gm-Message-State: AJIora8R9Z089RLwM8LxcYEf481RIP8kV3qRNgkyPUPGmv/Kyw8RC6aG
        qbQAmHqXSX4WyBaTEDQu3LZoT604SOffBg==
X-Google-Smtp-Source: AGRyM1uWUiRSYgmsaey0YHY1R3UkAoG51F5i1h90Z0ue23FKaAxTTOY2d97DvYFGRIMcfSpuPK62gw==
X-Received: by 2002:a05:6830:268c:b0:618:5cc0:417d with SMTP id l12-20020a056830268c00b006185cc0417dmr15965672otu.196.1658338639544;
        Wed, 20 Jul 2022 10:37:19 -0700 (PDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id j21-20020a4a7515000000b0043565888e72sm7175234ooc.2.2022.07.20.10.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 10:37:19 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id by10-20020a056830608a00b0061c1ac80e1dso14651380otb.13;
        Wed, 20 Jul 2022 10:37:19 -0700 (PDT)
X-Received: by 2002:a05:6902:701:b0:66e:a06d:53d7 with SMTP id
 k1-20020a056902070100b0066ea06d53d7mr36038192ybt.604.1658338272504; Wed, 20
 Jul 2022 10:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com> <20220601070707.3946847-7-saravanak@google.com>
In-Reply-To: <20220601070707.3946847-7-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 20 Jul 2022 19:31:01 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVVgB7KZq7-u-pAC-cZvVLWkv5wM4HC_jW7WK_tz52+cg@mail.gmail.com>
Message-ID: <CAMuHMdVVgB7KZq7-u-pAC-cZvVLWkv5wM4HC_jW7WK_tz52+cg@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] Revert "driver core: Set default
 deferred_probe_timeout back to 0."
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jun 1, 2022 at 9:45 AM Saravana Kannan <saravanak@google.com> wrote:
> This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.
>
> Let's take another shot at getting deferred_probe_timeout=10 to work.
>
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Thanks for your patch, which is now commit f516d01b9df2782b
("Revert "driver core: Set default deferred_probe_timeout
back to 0."") in driver-core/driver-core-next.

Wolfram found an issue on a Renesas board where disabling the IOMMU
driver (CONFIG_IPMMU_VMSA=n) causes the system to fail to boot,
and bisected this to a merge of driver-core/driver-core-next.
After some trials, I managed to reproduce the issue, and bisected it
further to commit f516d01b9df2782b.

The affected config has:
    CONFIG_MODULES=y
    CONFIG_RCAR_DMAC=y
    CONFIG_IPMMU_VMSA=n

In arch/arm64/boot/dts/renesas/r8a77951-salvator-xs.dtb,
e6e88000.serial links to a dmac, and the dmac links to an iommu,
for which no driver is available.

Playing with deferred_probe_timeout values doesn't help.

However, the above options do not seem to be sufficient to trigger
the issue, as I had other configs with those three options that do
boot fine.

After bisecting configs, I found the culprit: CONFIG_IP_PNP.
As Wolfram was using an initramfs, CONFIG_IP_PNP was not needed.
If CONFIG_IP_PNP=n, booting fails.
If CONFIG_IP_PNP=y, booting succeeds.
In fact, just disabling late_initcall(ip_auto_config) makes it fail,
too.
Reducing ip_auto_config(), it turns out the call to
wait_for_init_devices_probe() is what is needed to unblock booting.

So I guess wait_for_init_devices_probe() needs to be called (where?)
if CONFIG_IP_PNP=n, too?

> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -256,7 +256,12 @@ static int deferred_devs_show(struct seq_file *s, void *data)
>  }
>  DEFINE_SHOW_ATTRIBUTE(deferred_devs);
>
> +#ifdef CONFIG_MODULES
> +int driver_deferred_probe_timeout = 10;
> +#else
>  int driver_deferred_probe_timeout;
> +#endif
> +
>  EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
>
>  static int __init deferred_probe_timeout_setup(char *str)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
