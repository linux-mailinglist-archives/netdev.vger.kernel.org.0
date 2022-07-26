Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD84A5819B0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 20:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiGZS2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 14:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiGZS2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 14:28:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEE414021
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:28:01 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id b11so27613408eju.10
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=chtoAOqBpiW8q4QQoa6M2B1ASOEVDGmzwfV6QbgV7Ic=;
        b=kQSBBX1Gm/CxDR2eZJeOAvYLNvRXOk9giXqNlH1Q/W8pjSpxUoDDv8qM+omgHL2S1Y
         1i04IlFKpdo/B5Sp1X7ntgucBaIHubIf0saCy754WkY38yR/n5TlhbfkxSU9qX1GIc08
         07J9IK2HEjkAoqIvrOOGmDeUKsk2Pubac6nwldInG0Ix6BZ7RfozBmgY1EdzQUHxJe3h
         kHgtmX6HSmx4Ai88GuDyPfVWV2hOi4oP6ERe5ZqFHlVfqcrN0micf/V9ZIkqau0raAp0
         v0BmbIpyLzva/O47DtLn73VOahw9KXm44/qd3qiuuBFhxTF8M4SrwTa18TU5GmlF8dMz
         3TSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=chtoAOqBpiW8q4QQoa6M2B1ASOEVDGmzwfV6QbgV7Ic=;
        b=8HAzkBNDZw1sTsZh84Ub3G08yy7cXfdHuhCwphSfE33SCa5S824f+APwzbo43NDcTA
         pEPKcxHDIXXqwVnODzQHnPcvIkYmojI77iqYmq8HsHb5arYA2ZhUJHEPig7UD3eG8h12
         LwDLLWbuqwLEjmft6YHBcqvFmKR+Fz9C80+V2A8Nu7nrr3Hw8oQqvH2/OwqhMGDXaQH4
         KYHzxRdmdFdlA28TonWo8lRA0YrskDmkW995sme0pH1jJ6ZZi3ApexuzBAL0Q2BoT6mR
         sdjOmHCm0p4tnquOR7Zi3tU8j3oq7jixG0I8VrRr3VnjvFrstoCGZmMuUXZZJIPPhwDQ
         MQDQ==
X-Gm-Message-State: AJIora9WimJJgRQ8gKdR5VOAPKHOzGJ46P+P+rc2eoNxuxjAMoV8dW+3
        7+/TyODYWQ2owfqrvr7vF7TZEw==
X-Google-Smtp-Source: AGRyM1uj7BkcJNTOSpNAx+rpj1S4C+y28WBs6mfI8Q5I0Xi7cCyBoedoORylDA8s8nlMFGmz2NL1lA==
X-Received: by 2002:a17:907:2c74:b0:72b:5ba7:d96f with SMTP id ib20-20020a1709072c7400b0072b5ba7d96fmr15561466ejc.33.1658860080275;
        Tue, 26 Jul 2022 11:28:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id la16-20020a170907781000b0072b92daef1csm6815084ejc.146.2022.07.26.11.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 11:27:59 -0700 (PDT)
Date:   Tue, 26 Jul 2022 20:27:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <YuAyLkSa8R0/+BSu@nanopsycho>
References: <20220726134309.qiloewsgtkojf6yq@skbuf>
 <20220726124105.495652-1-jiri@resnulli.us>
 <20220726134309.qiloewsgtkojf6yq@skbuf>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <Yt/+GKVZi+WtAftm@nanopsycho>
 <20220726152059.bls6gn7ludfutamy@skbuf>
 <YuAPBwaOjjQBTc6V@nanopsycho>
 <YuASl48SzUq/IOrR@nanopsycho>
 <YuASl48SzUq/IOrR@nanopsycho>
 <20220726165520.due75djbddyz4uc4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726165520.due75djbddyz4uc4@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 26, 2022 at 06:55:20PM CEST, olteanv@gmail.com wrote:
>On Tue, Jul 26, 2022 at 06:13:11PM +0200, Jiri Pirko wrote:
>> Here it is:
>
>Thanks, this one does apply.
>
>We have the same problem, except now it's with port->region_list
>(region_create does list_add_tail, port_register does INIT_LIST_HEAD).
>
>I don't think you need to see this anymore, but anyway, here it is.

Thanks, will fix this and send it to you off-list, to avoid spamming
people, sorry.

Thanks!

>
>[    4.949727] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
>[    5.020395] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3397
>[    5.047447] pc : devlink_port_region_create+0x6c/0x150
>[    5.052587] lr : dsa_devlink_port_region_create+0x64/0x90
>[    5.057983] sp : ffff80000c17b8b0
>[    5.132669] Call trace:
>[    5.135109]  devlink_port_region_create+0x6c/0x150
>[    5.139899]  dsa_devlink_port_region_create+0x64/0x90
>[    5.144946]  mv88e6xxx_setup_devlink_regions_port+0x30/0x60
>[    5.150520]  mv88e6xxx_port_setup+0x10/0x20
>[    5.154700]  dsa_port_devlink_setup+0x60/0x150
>[    5.159141]  dsa_register_switch+0x938/0x119c
>[    5.163496]  mv88e6xxx_probe+0x714/0x770
>[    5.167416]  mdio_probe+0x34/0x70
