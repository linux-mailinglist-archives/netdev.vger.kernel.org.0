Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7F404247
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348662AbhIIA1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbhIIA1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:27:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F36C061575;
        Wed,  8 Sep 2021 17:26:04 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h9so7730481ejs.4;
        Wed, 08 Sep 2021 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wreZB7UBAFy1of4iMTATNheSq7Hzv+fftSvSkGYu5PA=;
        b=NaKPqCa1a34EVinxw/p4SsiPlhjG7b0UoxOOWuczFiH+EKPkscCMJP/bmVE8Hn1bjJ
         0nN8I0g6FsPOIW4wY1dg8l+Np91/SYFWJemkJigU+EvMt2jjuIU98a5Xsqqz828kiXqu
         060TnoBDZs5ipialYBOdGqx4myrWBXb6AaYtDQOtg2gPTJGSpdQIa1/6HPjXsWGaxghO
         9jSiZi0IsYb3s7Ov96EO/tyuvtmC9SIR9pYreHM3XbmJQAtVdp/DcT6CFk4oSvH+wJvD
         R1iNWJyNgxQxDxoNnLPmGPkzBNAiIbwqhoUIZgeuuH2ORIpUjYdVYypuw/URJJnd82lX
         AQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wreZB7UBAFy1of4iMTATNheSq7Hzv+fftSvSkGYu5PA=;
        b=iT9h9+bvRIyNEpl24E6oM1dwO9gbbekcpWLW4yKUOAmuCgOA/uJURVbGmH3ZQ+HvbH
         u1rOADILv5l9kouK0i/9eiWDccj/CtZqDB61KhcM/m7jZxa3OF6YYyHLzejnEGnS7oTb
         qhjprWWRRtua58H1dfozbGJGsjs6MBqFVwcRoy3tSYOn3hccgURPr1R2tH+VnbWeMwEI
         +Bej/M6gAXUk60n/FmEljcvSk/hqPBErFo4k9MNSvJH+UACRnp9jp13ttk9ukoIFnUKJ
         eCK2iRHNPPU7S8QQxSiYDKW8aF6x8uo9IH5/lQx5QCQyIflCo1nKZVTsLenTCb5stFOL
         dpcA==
X-Gm-Message-State: AOAM530bGhJlcpIyRclk7bI1uzwEvkISGwLCh5H3zPwwcdkDjE9tykfH
        YjNlLj6XShxQiMEdFUte0UV+gieiTzgFOg==
X-Google-Smtp-Source: ABdhPJxiLBa4EoztGWPNdflOdhonE8KZGhBCbwnIWa7SGU8sVnHsxkplIjkXM9JNdSoWCiSW+ADl1w==
X-Received: by 2002:a17:906:f1ce:: with SMTP id gx14mr430328ejb.14.1631147162651;
        Wed, 08 Sep 2021 17:26:02 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id s7sm80527edu.23.2021.09.08.17.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 17:26:02 -0700 (PDT)
Date:   Thu, 9 Sep 2021 03:26:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Message-ID: <20210909002601.mtesy27atk7cuyeo@skbuf>
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
> > Where is the problem?
>
> I'd say with 994d2cbb08ca, since the tagger now requires visibility into
> sja1105_switch_ops which is not great, to say the least. You could solve
> this by:
>
> - splitting up the sja1150 between a library that contains
> sja1105_switch_ops and does not contain the driver registration code

I've posted patches which more or less cheat the dependency by creating
a third module, as you suggest. The tagging protocol still depends on
the main module, now sans the call to dsa_register_switch, that is
provided by the third driver, sja1105_probe.ko, which as the name
suggests probes the hardware. The sja1105_probe.ko also depends on
sja1105.ko, so the insmod order needs to be:

insmod sja1105.ko
insmod tag_sja1105.ko
insmod sja1105_probe.ko

I am not really convinced that this change contributes to the overall
code organization and structure.

> - finding a different way to do a dsa_switch_ops pointer comparison, by
> e.g.: maintaining a boolean in dsa_port that tracks whether a particular
> driver is backing that port

Maybe I just don't see how this would scale. So to clarify, are you
suggesting to add a struct dsa_port :: bool is_sja1105, which the
sja1105 driver would set to true in sja1105_setup?

If this was not a driver I would be maintaining, just watching as a
reviewer, I believe "no" is what I would say to that.
