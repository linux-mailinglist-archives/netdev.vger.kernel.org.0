Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F6762A037
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiKORYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbiKORPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:15:11 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A49201A8;
        Tue, 15 Nov 2022 09:15:10 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id f27so37783243eje.1;
        Tue, 15 Nov 2022 09:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Im2il6wc9BflovIe/aH1N9vgxr8n3TsZYaH+KY9UDA4=;
        b=pIhjLUU32YfsyNVXjXTZ6nX+4F6D6JJOJW5yP2Eqod8OMQp9HwTgzaFviHUnRya05K
         CZkUiCg3a9CktHmLMnmNevBZvOOhXl6RkAgBu/6JZnllaUXiGfd5Sv8PTDLI7w8dUzuD
         WL8qx6ka6X3R/8UsemBpENzJ5nlkHFQfel1hpgBtm2CsnfY+mnJAhz6DBfO3s/1uZIMJ
         7stvI1fNMFlzOrFu0IzOHR11bY9TfZX4h/1d8U/rAXw4N9ibGOFRc62bJJ6LWUlpaJn0
         aDfLyOHoY6tv7pPKRWKUqkaJ7UB7dtJeL+7RJlrYAB002jxYjFmo4/oZiD2rZoHH/+Gg
         giWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Im2il6wc9BflovIe/aH1N9vgxr8n3TsZYaH+KY9UDA4=;
        b=btfJJF86ljO5UY5VIUd8kVOKMUost07KmUwM4tFkopRTiA+HXLxHlum2iuEcKc51MS
         wOxropb/WB1BXDyQId5CIhvbChjyFE2efjq+01Kxxc0W9z/VGxjfRW2vNM3xVB7vuNcF
         mbj6DbZ/2pspBw+DRCrl54vqDioREqXvQREENKK43XIsWT5Ru85vd0I8yUpqxPdu9VWK
         QCcHMMbaAnCnjE9O8SLE7FexMspWdDvm+xsG3kGWHUcPkLeLTtZ/etgyWS0ypPz/ljRY
         vv7xgKDNShkN7O/MwR5kbbr/oTOhusMoEUoj5G992Tbjq4RIVhJI3Eu1Pj02/sru40eA
         WIMg==
X-Gm-Message-State: ANoB5pllrjRup/od2HHxRVxKnxjYZoUmQ3ndtpiCbyxykN3mQu61Y/L9
        9eTA8OKDOIvUldW8i/gDDv1nUuNS7zcP4A==
X-Google-Smtp-Source: AA0mqf7PKtZ1bQXNlA+kqCp9KC9S1CyIuyftTYgR4SCBTuYxTQRtILCjzr1HfgBjc/Mc+sa7IKcqlw==
X-Received: by 2002:a17:907:206e:b0:78d:3c82:a875 with SMTP id qp14-20020a170907206e00b0078d3c82a875mr15170708ejb.465.1668532509461;
        Tue, 15 Nov 2022 09:15:09 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id rn5-20020a170906d92500b0078dd4c89781sm5781331ejb.35.2022.11.15.09.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:15:09 -0800 (PST)
Date:   Tue, 15 Nov 2022 19:15:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115171506.74yztkivdqggelh6@skbuf>
References: <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <551b958d6df4ee608a5da6064a2843db@kapio-technology.com>
 <20221115161528.nlshuexccymfkree@skbuf>
 <5cec856c6a1e1721dc75a74815dad4a7@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cec856c6a1e1721dc75a74815dad4a7@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 06:11:08PM +0100, netdev@kapio-technology.com wrote:
> On 2022-11-15 17:15, Vladimir Oltean wrote:
> > On Tue, Nov 15, 2022 at 04:14:05PM +0100, netdev@kapio-technology.com
> > wrote:
> > > I think the violation log issue should be handled in a seperate
> > > patch(set)?
> > 
> > idk, what do you plan to do about it?
> 
> When I think about it, I think that the messages should be disabled by default
> and like one enables NO_LL_LEARN (echo 1 >/sys/class...), they can be activated
> if one needs it. And of course the ethtool stats will still be there anyhow...
> 
> How does that sound?

Just make them trace points...
If you don't know how to do that, just search for who has "#define TRACE_SYSTEM"
in drivers/net/ethernet/ and steal from them...
