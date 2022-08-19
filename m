Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0EE59A536
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349807AbiHSSFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350351AbiHSSF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:05:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F29BA9F1
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:52:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y13so10111010ejp.13
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=4y49X3vIMfVfAun0pYMenuynmQh+tnDcDs8r2lPRk5k=;
        b=GbcjLU0qq3QTxye3b/s9O/RH2RJMUBH0J/AMFDiRgSraFLb8U+ttn5P/elErC7RoZQ
         yrFBatSy4ltxQ76ABhEMUOzmB7uLIrKinKggc/5x0bx/dqK7mUNWmk3MkLoavh6qFPHM
         h1Lpk8M/vx/kpVj+gnnyWULTqsqB1skcsyT+pst+U4qAAYy48xsf/ptYU8dKgdA4vj0P
         eBE2tiea0MTmN8qMOClZh3Rn06ZW5Qm2iJ7sXRXaX0NA5H2yORvEUfwqJa3i/A87Fzgt
         xQtzNsXhkGAsTSVzJ8s9EG/a42oLslXQJFlymoQ18JIqrzy1G8YEzP2d9HBPgGVnCUz6
         N0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4y49X3vIMfVfAun0pYMenuynmQh+tnDcDs8r2lPRk5k=;
        b=Ssvi3rRU5TUK2vKTniHqNnNrE345Y67jQIapDvj7SUT5JDRwr/HdPkEKcuVpBY3RB5
         KhXuy75+AhzlPGenzQi5V9u7KHtmvhHmQHIgAUJbVYCMzn0ximKkX0c7Jizahf7+6DuX
         ZcPjpQZLROFq89NSxiZu/j7xZGriVFgdQs0eBtnnFb4TQpbBHK/oXQYRNt7NKCfnVfFd
         RcgW0ui/aW3oS2vFlVtdo9bTpX5S9PMAD6k/Gx/RP1AiQucKeTCCzUaeU8wgrjAdaopM
         UAXbb7jHRIBL31r0s/0CJjSH8bSCfADvxkRGVdQsDxl8+5PDJ8abygSmLM8D6ZQKwY0D
         qF1A==
X-Gm-Message-State: ACgBeo06AHQMz8GZzaBHLzpgVD4gszsZFkqQb2GsPEAAhu3hqeaB8o+y
        zCFX7F1g+T7nlS1r03m6Moadt8gCHjA=
X-Google-Smtp-Source: AA6agR6klbWaEkZJh0aKg6iu3Gcj4VXdjz+rBBg6Cg369qgTQepfMyYN3nrKHrTyIv5ddwFLwyKFaA==
X-Received: by 2002:a17:907:d88:b0:730:d0bc:977a with SMTP id go8-20020a1709070d8800b00730d0bc977amr5754574ejc.664.1660931537128;
        Fri, 19 Aug 2022 10:52:17 -0700 (PDT)
Received: from skbuf ([188.25.231.48])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b00738795e7d9bsm2624836ejh.2.2022.08.19.10.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 10:52:15 -0700 (PDT)
Date:   Fri, 19 Aug 2022 20:52:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: mv88e6060: NULL dereference in dsa_slave_changeupper()
Message-ID: <20220819175153.d6p7atcmusuyzqvp@skbuf>
References: <CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 06:11:46PM +0300, Sergei Antonov wrote:
> Hello!
> I am using the current netdev/net.git kernel. My DSA is mv88e6060
> (CONFIG_NET_DSA_MV88E6060).
> These two commands cause a crash:
> ~ # brctl addbr mybridge
> ~ # brctl addif mybridge lan2

Thanks for the report. Just to not leave this thread hanging, I've sent:
https://lore.kernel.org/netdev/20220819173925.3581871-1-vladimir.oltean@nxp.com/

FWIW, these days we use:
ip link add br0 type bridge
ip link set lan2 master br0

this is why normally it doesn't crash, extack is a netlink feature,
which brctl doesn't use. But we should keep ioctls working too, though.
