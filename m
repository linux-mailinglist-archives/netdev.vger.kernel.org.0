Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA5F4CE525
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 15:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiCEOMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 09:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiCEOMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 09:12:54 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB8E2067FF;
        Sat,  5 Mar 2022 06:12:04 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id c1so9850747pgk.11;
        Sat, 05 Mar 2022 06:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xFOxDfJvy6Fpu46Gu4Jr5O7h7HL12qBSD8Q83PgJ91U=;
        b=mr1JZLcU2cVjvY7+jLaYZ7C8048f42u6P81+bRTBvJ7GgrcI5TsDwORB2np3KWYcUJ
         afeLu9CvW5lLz0D0XRhcQ8Cs2KFRdjLEL+UdKAQJR/ih6mshmJZBPqb94W348nnDCSgb
         2GfRU6KLdHSyriSd+jLWwMpUG5hodBE3xH+R3Bqvga1j8BDwgFojdTsfg9g//ehEO55c
         bj36mFZYHjJMJH0mCmRI50oA9GNhex/9/VyiiR3nx8DbBBzxVJRzClvlBqikmpyjGpvG
         EeH2oEB8lF4IAsDDhMapXqSFmV9uQD9HeSRmb10aImM/xa8wcyRdqbHRT4s033eEo08A
         AXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xFOxDfJvy6Fpu46Gu4Jr5O7h7HL12qBSD8Q83PgJ91U=;
        b=IUghuBF0ASL8TV1A28CPdcE+XrTqEmxdGIJImBIMpb2mbkR+JpgtGTQmtImuZq51uT
         PC0dRqj92pBOvkoMDTLHZh3YN58HeaU0N7Zyg6WQELk+dUBLhePh24rHcepKDNN/Wfq5
         q5R/f+l76BLZ5vAszwBJj0OpKGzQ7ussHCz5q4kPGwpDY814wH3Nt5w+4/joICIxPCFd
         19CNbmuBF3+chankAgOJt0TWE3bEa8zZj6oEBM+cNoIkWHjth/FzPKLiVTi6rxbfR9tK
         PruIadDtqQx2DcHzqCJGPhKVaEf81a8YCjC2fv3S9wmUKtY2ozn/4A05wThBLgjGvxG1
         7AoQ==
X-Gm-Message-State: AOAM530b7sF75YJQriL/yQhj7Q5oHwKvIJjp5cpNZjk+gbViLeRWcgSY
        6GekkgrYjZBbliNY/mpqps+LV1xJNP+EKv256w==
X-Google-Smtp-Source: ABdhPJwxkXEzW3Wbt9AMZeA8EoAIBljKo8Un5hMC79McXM/gjPX5hhw0FR0DMJMjGCTQ801Udq4JSdx3KkoXC9vkHCA=
X-Received: by 2002:a62:1787:0:b0:4f6:c5d2:1da7 with SMTP id
 129-20020a621787000000b004f6c5d21da7mr3979165pfx.71.1646489524279; Sat, 05
 Mar 2022 06:12:04 -0800 (PST)
MIME-Version: 1.0
References: <CAMhUBjkt1E4gQ5-sgAfPvKqNrfXBFUQ14zRP=MWPwfhZJu3QPA@mail.gmail.com>
 <20220303075738.56a90b79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303075738.56a90b79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sat, 5 Mar 2022 22:11:48 +0800
Message-ID: <CAMhUBjm9+nt8j0JFwHEms2Ra1YjhAXquVyHuDYX0_ZZzJyNuZA@mail.gmail.com>
Subject: Re: [BUG] net: macb: Use-After-Free when removing the module
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 3 Mar 2022 20:24:53 +0800 Zheyu Ma wrote:
> > When removing the macb_pci module, the driver will cause a UAF bug.
> >
> > Commit d82d5303c4c5 ("net: macb: fix use after free on rmmod") moves
> > the platform_device_unregister() after clk_unregister(), but this
> > introduces another UAF bug.
>
> The layering is all weird here. macb_probe() should allocate a private
> structure for the _PCI driver_ which it can then attach to
> struct pci_dev *pdev as driver data. Then free it in remove.
> It shouldn't stuff its information into the platform device.
>
> Are you willing to send a fix like that?

Thanks for your useful suggestion, I'm willing to submit a patch.
But I'm a newbie to kernel and I think I need some time to think about
how to make such changes.

Regards,
Zheyu Ma
