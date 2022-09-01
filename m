Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0985C5A96B4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiIAM0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbiIAM0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:26:22 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE4125EB5
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:26:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id se27so26579341ejb.8
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 05:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=vLXr10YnjmAF0CPrKfnalsYFIuobDVCy3G1W3hn4LdE=;
        b=Nl15FIzomR321fIAAvkkHLHpMk4eFUxIrEdR/JFTVb95Bu75N/qWsXN7EO3uKhxFUA
         EMFG31wXdd5gMwifgjNOOaNRCiKrrNL1ZPPmolSAAud9Dq8VpAYNNDyYAFOMKB/n3D9l
         JSwOtbih37uhnw9ZVHwOVl87lSSEBhoSBcXMlQ8wwUs4X10GwQBajAgSurEuCw+1JLNb
         kfCfIg483NReo9hhOS2irlE5dudHOos6dHxr0/7FcBk06PWUo/tZ9Y5iOQE9bVmfWhno
         IqlyP2NK6hThyMWvKeM0tWeeHIn4YRI5mWmtl6gOUk6B/Td7ZAnehrNUm2ZIAc+lQb2M
         yT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vLXr10YnjmAF0CPrKfnalsYFIuobDVCy3G1W3hn4LdE=;
        b=xN+4CCuY8ec1j86ZiZKzkGaiMVSNO9FHdKFgnqKGdoTfemCLvaMkcPL48Nuyuo/MTl
         oS+cGG0RlqlvDnYLWiqYxaejaTcLFRI9yai8A78U+ujH7hFeYhMwXsYklPAtANqcNFJX
         XRXXctG3S7cUP/EWdnQIYxN2Vk+wfC7U8zydcnkTLvY+uS67Yadf3SHvn5S2AQGpi0wH
         zZXjiwmSk7j2Nasny/umJ++ktT/GRtpe+ISa3aEI7STd7gUKCDLATpy6ChAZ+P3HCcsE
         gNVETc/rxK3oc4Mmf/OC5xyM0ZtVGLVu4/ba1hT1BbACiuyNWZ3JjpPRynpk3gd3BkAd
         hXSw==
X-Gm-Message-State: ACgBeo1+7V1aiYRB42gKkXGtVaP7h59I3U0Jm679VvPC5sdlYY/XNBam
        MKsFnw7Y4Ujc4xucRIxzx/M=
X-Google-Smtp-Source: AA6agR7Dq6AVh8ZqPZlT6YJFoGjW8wJA921D89K3oPfXyhdZmgot/FTcC4JFQJveBXXGdfqutc2i/Q==
X-Received: by 2002:a17:907:9495:b0:734:e049:3d15 with SMTP id dm21-20020a170907949500b00734e0493d15mr24449633ejc.187.1662035179299;
        Thu, 01 Sep 2022 05:26:19 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906293200b007262a1c8d20sm7449525ejd.19.2022.09.01.05.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:26:18 -0700 (PDT)
Date:   Thu, 1 Sep 2022 15:26:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <20220901122616.tbux3hp2oyej4wcq@skbuf>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
 <20220831153804.mqkbw2ln6n67m6jf@skbuf>
 <e7ba61d7-de75-3cfe-ee92-3f234dd36289@smile.fr>
 <20220831155103.2v7lfzierdji3p3e@skbuf>
 <e72786ef-68ec-52c5-f5a8-6a5e131db2ca@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72786ef-68ec-52c5-f5a8-6a5e131db2ca@smile.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 12:25:03AM +0200, Romain Naour wrote:
> The gap between the kernel 6.0 and the kernel vendor (5.10) used initially is
> huge. Initially the 6.0 kernel didn't boot at all on the custom board I'm using
> with the KSZ9896. The 6.0-rc2 kernel seemed bleeding-edge enough for upstream.

If you don't plan to remain forever on a BSP based on 5.10, this is why
it is preferable to have the changes required for your platform to work
submitted upstream. It should make uprevs easier, and when there are
breakages, git bisect is at your disposal.

> > If you keep formatting development patches against the plain 6.0 release
> > candidates, you may eventually run into a conflict with some other new
> > development, and you may never even know.
> 
> Actually there was no conflict until the merge of the series "net: dsa:
> microchip: add error handling and register access validation"
> 
> At least I need to add the .gbit_capable entry in ksz_switch_chips[].
> 
> I'm not sure about the new register validation for KSZ9896.

So there's another reason to retest on net-next.
