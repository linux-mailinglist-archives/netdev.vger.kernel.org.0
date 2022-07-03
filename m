Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A365643B5
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 05:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiGCD0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 23:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGCD02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 23:26:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF1B9FC3;
        Sat,  2 Jul 2022 20:26:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fz10so139247pjb.2;
        Sat, 02 Jul 2022 20:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/LE3/OvnxwC10hHaqp2JoOJSN7rfZOpUu2WCyCiyCz4=;
        b=Augt3VIV/iWcoU+DHx6Yl7vroOm9Hwz+XtZe2jvyXkhsx95p/JLAo0xcEd6ix1ZIVf
         qIfg68MUyw+xLjl2gBsPYsbv6l3jY94RzOJD92gb6rxdLTyy5Av/dXPYvA/EXIhLOtLz
         svOqPB75mbgpDTnbuNTXc8rdS2DrehpRBgIiYcfLEACt56jQqPD4OYEXOr+iSon97xBH
         KYxD4XfgTiHC/xmDNEPOFfPpT2EHhts4G6H0Pm0fJr3aoQ7VOuwkBeKtFwd1B4K1k9D/
         GdNdQLrWNIKMTC9YgyvhuIjL+GirhGz9Rbn2DEPjhAWabLVNFd+wt0MxRzds1x2rF4/L
         8aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/LE3/OvnxwC10hHaqp2JoOJSN7rfZOpUu2WCyCiyCz4=;
        b=hSqHn4/XX/P/1YE7EvPtr7Y+Gdsa1DIREWmnADK9NoQy99dUPWRtADeOmp8jV5NVib
         WBnRteh9EbmYjsDyBRgK8MiOR/LL3MxloBDohF3ox6rX4Ywo29ftvJkN0cTn84sWVVP4
         evQ/7KuPFaoOm6FTu1uGu6I4xfvA0YhJzAftMKvnnOMhvyMr+B+rSXsMCAuMHgDTUq0a
         D60ZfydIqmFzEmlgQ99aOyFFJ66m35ObaZ2GcAZoDMLIiTzcRoL06Qy/4yrpQ0pkevKi
         OrInWrB1W2JRoNrczCaKDgYwbnqHFMS7bK1d1RvhMkjJURkI2ulbJ1mbG3IgRfR4mwHX
         tBtA==
X-Gm-Message-State: AJIora9XIOW8cd/kwEIuBr8xZHO3SqObbMGFfCEDNVp09OqOPg7BXXUf
        ScwRSq1f3RsApXnEAA2R9+hy4tQUFJpMcg==
X-Google-Smtp-Source: AGRyM1v/qGK0NX2/G7uiSvuhmywhBxQ+rRzGPCB7tQOWN8p4Gfx3qW4Qvkfllc0ImMReMYjkXPk5jA==
X-Received: by 2002:a17:903:2c6:b0:16a:276a:ad81 with SMTP id s6-20020a17090302c600b0016a276aad81mr29074812plk.65.1656818782428;
        Sat, 02 Jul 2022 20:26:22 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-33.three.co.id. [116.206.28.33])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e81100b0016a0db8c5b4sm1866809plg.156.2022.07.02.20.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 20:26:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EA78810390C; Sun,  3 Jul 2022 10:26:16 +0700 (WIB)
Date:   Sun, 3 Jul 2022 10:26:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Alasdair Kergon <agk@redhat.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Brendan Higgins <brendanhiggins@google.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mike Snitzer <snitzer@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Takashi Iwai <tiwai@suse.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        alsa-devel@alsa-project.org, dm-devel@redhat.com,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/12] Fix several documentation build warnings with
 Sphinx 2.4.4
Message-ID: <YsEMWDYCdjxiUZ1P@debian.me>
References: <cover.1656759988.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1656759988.git.mchehab@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 12:07:32PM +0100, Mauro Carvalho Chehab wrote:
> This series is against next-20220701. It fixes several warnings
> that are currently produced while building html docs.
> 
> Each patch in this series is independent from the others, as
> each one touches a different file.
> 
> Mauro Carvalho Chehab (12):
>   docs: ext4: blockmap.rst: fix a broken table
>   docs: tegra194-hte.rst: don't include gpiolib.c twice
>   docs: device-mapper: add a blank line at writecache.rst
>   docs: PCI: pci-vntb-function.rst: Properly include ascii artwork
>   docs: PCI: pci-vntb-howto.rst: fix a title markup
>   docs: virt: kvm: fix a title markup at api.rst
>   docs: ABI: sysfs-bus-nvdimm
>   kunit: test.h: fix a kernel-doc markup
>   net: mac80211: fix a kernel-doc markup
>   docs: alsa: alsa-driver-api.rst: remove a kernel-doc file
>   docs: arm: index.rst: add google/chromebook-boot-flow
>   docs: leds: index.rst: add leds-qcom-lpg to it
> 

Hi Mauro,

Thanks for cleaning up these warning above. However, I have already
submitted some of these cleanups (pending reviews or integration):

[1]: https://lore.kernel.org/linux-doc/20220702042350.23187-1-bagasdotme@gmail.com/
[2]: https://lore.kernel.org/linux-doc/20220612000125.9777-1-bagasdotme@gmail.com/
[3]: https://lore.kernel.org/linux-doc/20220627095151.19339-1-bagasdotme@gmail.com/
[4]: https://lore.kernel.org/linux-doc/20220627082928.11239-1-bagasdotme@gmail.com/

There's still a warning left:

Documentation/ABI/testing/sysfs-bus-iio-sx9324:2: WARNING: Unexpected indentation.

But I think the Date: field that triggered the warning above looks OK.

Regardless of that, the build successed.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
