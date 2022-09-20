Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DF85BE6BE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiITNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiITNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:10:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF3E4056A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:10:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e17so3761098edc.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=cgDnqGK8i4nTSv4BsMCL00HLHApr4hVCq8vHbXMZr1s=;
        b=aFgB0qGVMTFmyP01EEWN15n4Aw8P/xnff1BS3G5MSqdoQTA6ehx9GnWxncoFN9ZzTG
         89nUFiiLOgf3YWZLRch8pNDvuMlFJEAcYg6IhZcatsyB7QXGn14bME11hD8SZH24v1Tq
         iVZJoHv/mg2U9u9iX5oIYqNLNwh4ixt/12jW4Kqbu4Gzw+b0FhXSnqGDZm6QG1hHwxzV
         BdrDgWAswgAHBYATEG8L6Y23Z+IV1/kP+bHRnwcAPoJJQa4AxfrsKUu509o+KIf+us+r
         0NzcPasgoizZ/9QKGNwBYjiggEpiUtXXs0cCyxCC5+tAvWZVRJEq2rSanumsenaQ4Q3X
         aZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=cgDnqGK8i4nTSv4BsMCL00HLHApr4hVCq8vHbXMZr1s=;
        b=lMpmOHZanFlOkLGmV9Jwin7VWRdysl+X14XGbpiR2PRhttK5/WmjJu8YUm7iiC6h2Y
         i1/21K03LA+pzjJy+hyDHPuTfx4DaG8ron7jpt7/8u4fxezRphrV8sxpe2hcf8hSlZpc
         UBOyv2uZylbpBEowb0XeYyMkVpNyr4Fttmk528cgyppl7iyf300djXqvt2NR0HR55mHS
         lu+Qa02kkAlfmE2Uf0QudFonBiKlJf54CF2JxFrLv3Zscexy9AQUOwtivM15yzOVwigs
         +cxxrR7sOtUZGxv6GGuAr9//Muimks/y/lpC4fvSHK8xz6touc8Xe2SKtawy2YixRs8A
         0LCg==
X-Gm-Message-State: ACrzQf2IpAQRsrkIXunbpIOQnga8dlg89sewk4pMC3u3xnk4YGzLOWFF
        8QFsdrilVLDeBDWH2Fx8PpzpjdXc9xePyOCC
X-Google-Smtp-Source: AMsMyM4iexusn2hvv1A3uUc7F4dGofU1xMxKiTeUIgiUvI0n3ydBY+novBt4NQinC6u16MtGWf3MYw==
X-Received: by 2002:a05:6402:11d1:b0:451:964:3af3 with SMTP id j17-20020a05640211d100b0045109643af3mr20506534edw.225.1663679456582;
        Tue, 20 Sep 2022 06:10:56 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906d20e00b0073d218af237sm815400ejz.216.2022.09.20.06.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 06:10:55 -0700 (PDT)
Date:   Tue, 20 Sep 2022 16:10:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 5/7] net: dsa: mv88e6xxx: rmu: Add
 functionality to get RMON
Message-ID: <20220920131053.24kwiy4hxdovlkxo@skbuf>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919110847.744712-6-mattias.forsblad@gmail.com>
 <20220919224924.yt7nzmr722a62rnl@skbuf>
 <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aad1bfa6-e401-2301-2da2-f7d4f9f2798c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 02:26:22PM +0200, Mattias Forsblad wrote:
> This whole shebang was a suggestion from Andrew. I had a solution with
> mv88e6xxx_rmu_available in mv88e6xxx_get_ethtool_stats which he wasn't fond of.
> The mv88e6xxx_bus_ops is declared const and how am I to change the get_rmon
> member? I'm not really sure on how to solve this in a better way?
> Suggestions any? Maybe I've misunderstood his suggestion.

Can you point me to the beginning of that exact suggestion? I've removed
everything older than v10 from my inbox, since the flow of patches was
preventing me from seeing other emails.
