Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D38E4FF181
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiDMIOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiDMIOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:14:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CCE4B1C2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:11:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so5542928pjb.2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PHmIfsKpyOoCL52uX8L68Y1ZbP4QPJHGyQKb4cedGLI=;
        b=D9WLPLsG3XMf8GM10Lcgc1oa9A4LTq7F47xsLFpo5aH7HKqHqQg2OL7YHvN0BadZRm
         LK64dC00STMRLwwrVzTHcrChmIXurnZ4cIXgQbWEqxnTOWmJikhskqIyNLdVQpBPjAuN
         s9mE/Ku6g97WGVfVS3O2pWHYX/Nct1f2ieA4EzwnxidIkG2ppQUIj0ZzsQ4Yi7/v/1xN
         GLKykH22JIUySd7J+TBwWxUKWU5DOpmgs9xSxrDa0rvf8UOHwGUj9yB3YqBht5dAnB6T
         Zjo8QeuRAHSrU1BHJNEYeULvHk5HTTFR8v1BX9r8zIciGVb6+JeEs9duOjr1JvuEVfQg
         rCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PHmIfsKpyOoCL52uX8L68Y1ZbP4QPJHGyQKb4cedGLI=;
        b=R9UbOOfRo3fPrrLp02QyMES6dJuXBibwSniW2VNyesc04GsiK0ZXvhpdgWhjRx7Frx
         8sxOT9kpOVe5f+MGb0F+6WnWt2+Dum2A7txHpI77RbWcrjwhnlNsVyc5L75BKAFNJPCC
         eIXYEEBdmJSn48yF+YxzYnJmN57o5BC+JSyOd0MbwX+0KoeSnbefVB8mH1SR2FUoiIhf
         tgVZFHwVJp1m/VEpjhNh0kRvD7M5Egc89lAgonQkyA5kqNJav8a+lBKWf/nW3rSXP+3D
         Sl5GF5XfaTsTaZBwdKpDJ5s2lD0UGjca5vWpljXcfqy42pvLy20COCgYuzPWKnS11Jbe
         nhSQ==
X-Gm-Message-State: AOAM5330dMlgl3+Sn+9yOoDrlIwFspWB1D/3/2T+3jbCR37VoANTG4vk
        6F76o3iANi8XifS0I/2vJ22RyHSRpm4=
X-Google-Smtp-Source: ABdhPJwEF9A6qtcPRZJInMCHtCUdPbG7WI/7bkQUqoxNV6rTggH2Z/m198dmDx7dnLhfOKWnRM4jKg==
X-Received: by 2002:a17:90a:8b8b:b0:1ca:6007:36e5 with SMTP id z11-20020a17090a8b8b00b001ca600736e5mr9458084pjn.128.1649837510245;
        Wed, 13 Apr 2022 01:11:50 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b0050566040330sm23148881pfl.126.2022.04.13.01.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:11:49 -0700 (PDT)
Date:   Wed, 13 Apr 2022 16:11:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <YlaFvqh+Fo4R2Rnt@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
 <7f230c69-dc15-ebaa-ff80-d4bde98488d3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f230c69-dc15-ebaa-ff80-d4bde98488d3@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 01:04:46PM -0400, Jonathan Toppins wrote:
> > 	Presuming that you mean creating a sub-struct here and moving
> > some set of members of struct slave into it, I'm not sure I see the
> > benefit, as it would only exist here and not really be an independent
> > object.  Am I misunderstanding?
> 
> You are understanding correctly. The goal of this work is to eventually port
> the majority of the per-port parameters that exist in teaming to bonding, we
> have not determined the entire set that make sense. Thus there will be more

Hi Jay,

As Jon said, I'm working to implement/import teaming specific features to
bonding, so users could have more choice. One import feature teaming has is
per-port parameters/configurations. A part of the per-port configs are
queue_id, prio, lacp_prio, lacp_key, etc. Most of the configs are link_watch
parameters. Which means each port/slave has it's own delay up, delay down,
interval, arp targets, etc. We are still discussing if bonding need all of
them or just a part.

Do you see if it's valuable to add all the per-port link watch configurations
to bonding?

Thanks
Hangbin
> than just port priority as a userspace configurable option. So I was
> attempting to ask if modeling the initial setting of these parameters like
> how `bonding_defaults` is used, made sense.
> 
> file: drivers/net/bonding/bond_main.c:
> 	void bond_setup(struct net_device *bond_dev)
> 	{
> 		struct bonding *bond = netdev_priv(bond_dev);
> 
> 		spin_lock_init(&bond->mode_lock);
> 		bond->params = bonding_defaults;
> 	...
> 
> 
> We can always refactor this area when there is another option that needs
> setting.
> 
> -Jon
> 
