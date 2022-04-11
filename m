Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267A54FBF6B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346222AbiDKOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiDKOp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:45:26 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A84110FCD
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:43:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bg10so31387864ejb.4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rLx42QyG40r2bBxaDahm2lvYtboASFKhaALZOdYMYXE=;
        b=AyvR+QnKBFPGe5ZnFsb2KQZAakhlHiVVhV5aBmSlxVFKPZBbIzpjPCyysi5U6j3v2W
         rJYaAQsIdQMVJL6J/nT/icvYHDiwEdx9XXRQl0dXh4E2cw1sR2d/E/1UcmJ8R8k4W4Ga
         co7hZa2L2aIe5OId4GCzyHCu8BcMKn9rQMTqKPYxgenEbjbmSIGJ9w6c3lVFKqtPDHqf
         oY2II1VguXFSH3xcR69i/4RJINFXY7PzFv+dEzb4EB9Yd3CbZj0Kqgg6IQjrOqS6jocK
         VWrDHfx5eRV1+qE65heMcgi1H8XShH2aueW4DkiCQdXkhLCtptlf/qh4PFq9D7+yJExa
         DpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rLx42QyG40r2bBxaDahm2lvYtboASFKhaALZOdYMYXE=;
        b=kGIfss/ihGH1e2+sI/kIfBdC3j51dTUVBukQsZt8JuoMy2Debuc1Ly6OotdLMIN41a
         WaCfKtS3j38L8oVVDfsnwwP8Ciy9Er/sigbEHaEhK3Vn1NQLT8f5zM4To4P61XUEhUGZ
         BOtBTZ0iTZC3u/xCJEKc0l22INzmd1hkNTOZ/nLvPaVjPzAItMNKo1CdvpZDQ+mWEJgs
         rZSPMQc6Hj4GuTQ2MwI7eWGVlTUAxLB7dfdJyTr+aQ/lp4PCSlpngzoR/PlQa7JEGm1s
         QNjCyJe2fmJzsA79ib8EJId6EtsdNBnaDMcZEyFxz5EEDRaRDxOO/74iPYbS7n9MYg4E
         c23g==
X-Gm-Message-State: AOAM532fknNGNiBdDxoUtXDTBIucYB8bPNqOqTHyCjVigZK/lJuD3jss
        azyj5eHBmp+dbXUfTz6jivWBuaTifrs=
X-Google-Smtp-Source: ABdhPJzPiikcd2ph+hSeOFggsdnsI9HaYWQ3EyapYuzW3S1am+i9S7yLy7/g69Fkor6e8cE/N/O8CA==
X-Received: by 2002:a17:907:1b1f:b0:6e4:b202:db68 with SMTP id mp31-20020a1709071b1f00b006e4b202db68mr31132992ejc.294.1649688190848;
        Mon, 11 Apr 2022 07:43:10 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id qb21-20020a1709077e9500b006e892b4062dsm1407259ejc.215.2022.04.11.07.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 07:43:10 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:43:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information
Message-ID: <20220411144308.v343ykjkn7eutzbr@skbuf>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <20220411132938.c3iy45lchov7xcko@skbuf>
 <VI1PR10MB2446B3B9EC2441B962691D67ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR10MB2446B3B9EC2441B962691D67ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:23:59PM +0000, Geva, Erez wrote:
> As I mention, I do not own the tag driver code.
> 
> But for example for ETF, is like:
> 
> ... tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +       struct tc_etf_qopt_offload etf;
> ...
> +       etf.queue = skb_get_queue_mapping(skb);
> +       if (dsa_slave_fetch_tc(dev, TC_SETUP_QDISC_ETF, &etf) == 0 && etf.enable) {
> ...
> 
> The port_fetch_tc callback is similar to port_setup_tc, only it reads the configuration instead of setting it.
> 
> I think it is easier to add a generic call back, so we do not need to add a new callback each time we support a new TC.
> 
> Erez

Since kernel v5.17 there exists struct dsa_device_ops :: connect() which
allows tagging protocol drivers to store persistent data for each switch.
Switch drivers also have a struct dsa_switch_ops :: connect_tag_protocol()
through which they can fix up or populate stuff in the tagging protocol
driver's private storage.
What you could do is set up something lockless, or even a function
pointer, to denote whether TX queue X is set up for ETF or not.

In any case, demanding that code with no in-kernel user gets accepted
will get a hard no, no matter how small it is.
