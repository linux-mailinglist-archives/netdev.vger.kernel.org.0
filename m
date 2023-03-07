Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034226AE73D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCGQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjCGQuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:50:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A39A1C7C3;
        Tue,  7 Mar 2023 08:46:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x3so54783514edb.10;
        Tue, 07 Mar 2023 08:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678207577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lCQLafUFpzWLJx8KexQbZ8Qy7pPXK3DUhwYLkEaM5eg=;
        b=c7y39P3Jo0qiiNOCoF5i7KloIinPyZze3nzQTUbD/BPgcesZmIRtu1WlQ9Fy/5gil4
         Wq1WtZd/mZ/FL6bCVnT3KYHAtmqIAxFzn2NE1ttUkjEoAh+JCQHvnL0vLLNiNWBk0z9G
         ioggTb3e3g08WJjb6fSXu7tnqQxjDtlBXZ2p8hjvShXYlRUsF5gKWpOFKmw2AE5U912r
         ss8FYDvrHNfADL/PjiGRCDEAN3Ltsex3Y2UvUFww6GY1iboQPTYOqEuLaaeffBxKlNtz
         /bPJJMSKCcQHAburvk3He3ZCP0xu/QrsRkEawO1356DS5FXVxgGyCivP/HFYcGJt0Die
         ialw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678207577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCQLafUFpzWLJx8KexQbZ8Qy7pPXK3DUhwYLkEaM5eg=;
        b=lUMq4Pcj7RGK8DVs3jB9pshsfluE2W/paqegG6SXwBEwABSZ8SUXx2GRQFtEb2rJA3
         yv882I/g7DrN8xtgc4QN9Swwn+gpneKWpdCoOGh7Z+5DvOH2882FKEebR3FW4t17VMZ/
         JsN3EObnS0U8ltpjWrIRQF3XntgWoDd+hSjS82Wl/wY37+tSPb9ptGTIh9eWYiCOUMIB
         lv0MueTKERGJdTGRfPcBuUy3NyosEM1qtetmA8qKNuSFocObJ/J75puNFNuiW1IdkRoo
         it5vGS/jug5XLMHG02AfGNIt1z1mYfzQOn2llIDFHde8kaglEnnnqmpbRNkFxYdxuRcg
         qTqg==
X-Gm-Message-State: AO0yUKX5OFz5aSpVMeUDH0eqYPjoOzqzbtpwxfxyxNYL/wP4MeZrHTji
        P2jp8m5vh2+mz2ZBHodOib0=
X-Google-Smtp-Source: AK7set88xB0AHfoC6FlCb9wG7FkCaQJ3eCIm+eIoGVQpzsTabFALtHa6izr9b1rLQhog/iNugXd5+Q==
X-Received: by 2002:a17:906:9744:b0:885:fee4:69ee with SMTP id o4-20020a170906974400b00885fee469eemr17339261ejy.59.1678207576708;
        Tue, 07 Mar 2023 08:46:16 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id v5-20020a1709063bc500b008c327bef167sm6311004ejf.7.2023.03.07.08.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 08:46:16 -0800 (PST)
Date:   Tue, 7 Mar 2023 18:46:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306163542.GB11936@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 05:35:42PM +0100, Oleksij Rempel wrote:
> > So what does the user gain using tc-ets over tc-mqprio? That has a way
> > to set up strict prioritization and prio:tc maps as well, and to my
> > knowledge mqprio is vastly more popular in non-DCB setups than tc-ets.
> > The only thing is that with mqprio, AFAIK, the round robin between TXQs
> > belonging to the same traffic class is not weighted.
> 
> Do mqprio already supports strict prio mode? net-next was not supporting
> this back for two weeks. I do not care what to use, my motivation was based on
> following points:
> - tc-ets supports strict prio. mqprio need to be extended to do this
> - tc-ets refers to IEEE 802.1Q specification, so i feel safe
>   and do not need to invent new things.
> - mqprio automatically creates software queues, but it seems to not
>   provide any advantage for a typical bridged DSA setup. For example
>   i can use queue mapping only for traffic from CPU to external DSA port
>   but can't use multi queue advantages of CPU MAC for same traffic  (do I'm
>   missing something). For bridged traffic i'll need to use HW offloading any
>   way.

Sorry, my inbox is a mess and I forgot to respond to this.
What do you mean tc-mqprio doesn't support strict priority? Strict
priority between traffic classes is what it *does* (the "prio" in the name),
although without hardware offload, the prioritization isn't enforced anywhere.
Perhaps I'm misunderstanding what you mean?

For strict prioritization using multi-queue on the DSA master you should
be able to set up a separate Qdisc.
