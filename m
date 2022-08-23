Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5329359EE56
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiHWVm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiHWVm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:42:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABD34AD64
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:42:57 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id kk26so272695ejc.11
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+IQDPJCVrTy3qBydTYvTJ5kQEbZSDwO5iBJyjcCqOkQ=;
        b=ByY3y4wszmuuZ/CXg7+7F+P4yBPsThQ3tU5Yrb74X68H8WL0a/vUX2xO6CjAQhIuKT
         R98t+gs7jtGQHDKq6L/UVpvHlgs7/27RxcIgz9WcmXLe0pKGpR9Au5rwEXRtCc+IpIYi
         ZnoS6kvsUemxwCwLyALGDmfybtcqW2VRMs6Y4g9edf4gOJTkMXY4b+w4ap/jRyX1tYi6
         GBYuEkyXNU6E+NihaInR5WHXQzXid0il/X7+CatsfEjB6Dr2OPJa2yUUD4K//2NuCat3
         JrxOb+RiRbWlsAjC4jZor2MOG4hLrliOJ3S1Pu9YJVF4pAEgxkU0ek/7F/UtUO0t1CRT
         2fug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+IQDPJCVrTy3qBydTYvTJ5kQEbZSDwO5iBJyjcCqOkQ=;
        b=zZUs7Rojt3a8iTMcuP8ZQAOfETjPwsMGAvM/SrrKqXIwjNvHq4Kb4FHcBep/9xz6fL
         pfa+hQu9hmQb2flcaqm8I5R8LdmM2CCz5J8+fjVcvbQ3VcBBqND2kT39xPHg2zYMIkC6
         sbKTKp1xdcMD/K8dvaKXbDuyqcAHx7joc+05yUg3v4gyMmZKbjtOe94tL0D0vZ4nwhHn
         hLT9jBaDM+hk1v9908m1fpAhK6n+7S+EZ5ifOfXgo2oYwHBzMDYoh9x48LGcCTX28ctK
         CGGsRW4fcLLtxHVqR2qmTSBZyIKBLchW8HDbFZzUYlqRaldpfX/du+5w2JnFHBgPu+wC
         E76A==
X-Gm-Message-State: ACgBeo21bKXl1NNxcrZMgIQ5TYC/uXcL5FTKofg9neeCB0bWV1+rrc/k
        oZuIEqySeJYXCeku/ypg3N4=
X-Google-Smtp-Source: AA6agR5RgUJTqm0qKWra3aQU6cvRedOgekHseIejQ9CCCzfI/0svZX0Nj5nGzpFzWuLwvShwB0V1tg==
X-Received: by 2002:a17:906:7e43:b0:738:6395:8d94 with SMTP id z3-20020a1709067e4300b0073863958d94mr1005500ejr.54.1661290976274;
        Tue, 23 Aug 2022 14:42:56 -0700 (PDT)
Received: from skbuf ([188.26.185.16])
        by smtp.gmail.com with ESMTPSA id g21-20020a50ec15000000b0043ba7df7a42sm1990362edr.26.2022.08.23.14.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 14:42:55 -0700 (PDT)
Date:   Wed, 24 Aug 2022 00:42:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable
 and keep it off while standalone
Message-ID: <20220823214253.wbzjdxgforuryxqp@skbuf>
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
 <20220823143831.2b98886b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823143831.2b98886b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 02:38:31PM -0700, Jakub Kicinski wrote:
> > @maintainers: when should I submit the backports to "stable", for older
> > trees?
> 
> "when" as is how long after Thu PR or "when" as in under what
> conditions?

how long after the "net" pull request, yes.
I'm a bit confused as to how patches from "net" reach the stable queue.
If they do get there, I'm pretty confident that Greg or Sasha will send
out an email about patches failing to apply to this and that stable
branch, and I can reply to those with backports.
