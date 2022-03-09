Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB144D3A36
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiCIT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiCIT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:26:15 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC2F21A8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:25:16 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id x26-20020a4a621a000000b00320d7d4af22so4118278ooc.4
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZdhFaJEobLHUcXbgZ55Zl3n5c/STYpZoXh4bxvyXeo=;
        b=K51U7US/nV+BkVPmQJmjXEiv9gUhg6nSo1hKROyXZYMeYcrcBATR+1DdDO0+ZayScD
         TxGgiZCJDoAA75Plrcw5ly8nWEZBGWTWM0xSheapUbyXSF/xI3/rrPEYxyZVNiaHURW6
         KjlZNtHvOi41YlJktKdkgPhCMM7WJDRdUhtkY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZdhFaJEobLHUcXbgZ55Zl3n5c/STYpZoXh4bxvyXeo=;
        b=LP/Ud1nVnFpTk/OPWZ9Gmm7AvQEFT6K+rfiAgdDS4wmWOeYJyXK1rBtLwYDBNydQo6
         AJwB450zT3DSeLhbSFFIq8Am+Hl1ED8nZiK4MbBa6zjvbjnS/xifP8eIOSG0s/ZIj4Kc
         cNx3PjuvdZdOJdn1Tssq3TqYedvPKKAMWtIE0cVPhOSYnFq6378/3891ltCadWrg2foZ
         jpRHcUFux1kMdC56aRJMzezJTJVkvtCvbyPrg7LZO+cfqrrtU+C8aXkUTR2bIsujfR0G
         oMvoNmCfPOqfhgAMThdkyiK0or1GS/bZzRmi/Jw5rJ5XRIhdeTVycs90px8e9J8OeUtk
         dRTg==
X-Gm-Message-State: AOAM530bsn0Qta9AV4IE57ZAnl0ZFG1xvsfEEt0SqpnVSFXo74ROYGgd
        BKbUjkvn+urizxlUdbgapVV77HDZM4qWPDyWOPM=
X-Google-Smtp-Source: ABdhPJwj1tMDRTZsgOqFS9bSzI191tFcwy3HNhu772SuenZ7uFFTgAYE35XjWSsfXjUMpxY8Tes88A==
X-Received: by 2002:a05:6870:4251:b0:d9:b7ee:f0ab with SMTP id v17-20020a056870425100b000d9b7eef0abmr6323734oac.56.1646853915243;
        Wed, 09 Mar 2022 11:25:15 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com. [209.85.167.169])
        by smtp.gmail.com with ESMTPSA id b188-20020aca34c5000000b002da579c994dsm205978oia.31.2022.03.09.11.25.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 11:25:14 -0800 (PST)
Received: by mail-oi1-f169.google.com with SMTP id 12so3659775oix.12
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:25:14 -0800 (PST)
X-Received: by 2002:a05:6808:2209:b0:2d5:1bb4:bb37 with SMTP id
 bd9-20020a056808220900b002d51bb4bb37mr710633oib.53.1646853913865; Wed, 09 Mar
 2022 11:25:13 -0800 (PST)
MIME-Version: 1.0
References: <20211217165552.746-1-manishc@marvell.com> <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de> <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
In-Reply-To: <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Mar 2022 11:24:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
Message-ID: <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
To:     Manish Chopra <manishc@marvell.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 11:22 AM Manish Chopra <manishc@marvell.com> wrote:
>
> This move was intentional, as follow up driver flow [bnx2x_compare_fw_ver()] needs to know which exact FW version (newer or older fw version which will be decided at run time now)
> the function is supposed to be run with in order to compare against already loaded FW on the adapter to decide on function probe/init failure (as opposed to earlier where driver was
> always stick to the one specific/fixed firmware version). So for that reason I chose the right place to invoke the bnx2x_init_firmware() during the probe early instead of later stage.

.. but since that fundamentally DOES NOT WORK, we'll clearly have to
revert that change.

Firmware loading cannot happen early in boot. End of story. You need
to delay firmware loading until the device is actually opened.

                                 Linus
