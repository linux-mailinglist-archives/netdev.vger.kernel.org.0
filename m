Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296E15A984A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiIANRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 09:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiIANQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 09:16:55 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C6861B3F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 06:14:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id fy31so34203849ejc.6
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 06:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4rsybKrQiashqhTnqHlsum4z3X90DA4xs4The9XwdoE=;
        b=JRAKih8Pik2JzsdJLFYkRq3Jhf47Nf3BhT/Jz9HC/snLmtLQLZASzBFCmFM4icPcH8
         lsB1jx11TpSYg1PEcaNwXuXxGLSZIk5YflTcUpk1IcGso7dQ7P97R5XiSjU3hcKh0u0n
         vO3xUyrtpoPnSod+VfB08brO1iTIjQCVO5eGtXn1os6MQt8OhBW21MAmj5TNY25OIop0
         SRTLWX9DwGyXddj9Usa7dn0roLsBULDJb6O38dh7zWSl6nUPjJZUx3YlEIWAWMd4zL9E
         ZAnxqdB98+sIQyO9i7Aw7//3vy4nUxMSp5tOTVl7BHIe2dc/TZn8VKmnKLp9pyOg8HKc
         KWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4rsybKrQiashqhTnqHlsum4z3X90DA4xs4The9XwdoE=;
        b=gu8kcuwSqvhrr1B+n/SjEg3kSfSI+uMXbWYJ59fbFFetlxjqSoIC1sDyWq/Tso8fs5
         L/Ba5gJ481uId5AGp6jthaGt1tSQexyFtoM9v/QpQmbdcq5WvHqTkyiBMcn8RsCzxchR
         uBOZK2ERyC8NEABgb18Cd90QrtwaGvOu3//Yxep5YOSp/ThVqO9q6D0Cu+uvhC+bOmyC
         iT961Uswn2GM0sXRlgptRnHnAQhrKkeIdJiJk8C2JVclbuCKC7NEXOWQ79dgLsSkKQ0z
         lrD1Y25Edv2GVflp76DfP1bNCXU4GYQYnwtcgmnqtDBcOUKpxrZfD2Od76foStMp50t7
         ff8g==
X-Gm-Message-State: ACgBeo2bJFzC5UH+9FTaVyiHh/EKGZa8S2EGRy4EFCVdodRuDc+Uy8ue
        sAL+7Zn8P+urf3IJYnnGCVg=
X-Google-Smtp-Source: AA6agR6yEV8zLDu8tIv6TniBf6P3AjzYXtuUMr9pmejH1e2Hoa0bR3v6ce1yHm6xC5M0k0HiaVJQ0A==
X-Received: by 2002:a17:906:9b09:b0:741:879e:fa with SMTP id eo9-20020a1709069b0900b00741879e00famr13181988ejc.573.1662038067901;
        Thu, 01 Sep 2022 06:14:27 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id bt21-20020a170906b15500b0073dbc35a0desm8484652ejb.100.2022.09.01.06.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:14:26 -0700 (PDT)
Date:   Thu, 1 Sep 2022 16:14:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Message-ID: <20220901131424.ovcsvffyjk7c5jqf@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
 <20220830163515.3d2lzzc55vmko325@skbuf>
 <20220830164226.ohmn6bkwagz6n3pg@skbuf>
 <f30871da-abec-477d-1bab-43cbc9108bec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f30871da-abec-477d-1bab-43cbc9108bec@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 11:05:37AM +0200, Mattias Forsblad wrote:
> Would this work on a system where there are multiple switches? I.e.
> 
> SOC <->port6 SC#1 <->port10 SC#2
> 
> Both have the same master interface (chan0) which gives the same
> cpu_dp->dsa_ptr->index but they have different upstream ports that should 
> be enabled for RMU.

I think the answer to that is dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
