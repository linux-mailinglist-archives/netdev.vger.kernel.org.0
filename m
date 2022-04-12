Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E064FE576
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbiDLP7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbiDLP7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:59:24 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ADB2980D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:57:06 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e21so11872412wrc.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=tQAKufzYrZIiW7UDSGtuejMEpxHokTnftOGoQHPMHYA=;
        b=MYlDlRgEES5S8Ugj6W+7R6VGP890P6G6h8OZkRuv9+1oRUu9qJGSPM47wEXijIuWtH
         BWEOz9O4udSk2OooKSxURpJfYMJZdLPmKt9qhZnkQbfcCpEjYzSjCsnNEO7BKBFtfz6c
         YHTspdVOLe+cfP/0ailL8G8tjbwq6TD+UpHIfzwFXHQetv8Vxeh9Ho9ZIu/93fc8TjYg
         mT03/wgEXShwE7CnQ4YtFFYysi2k+M6BXyxbJy7acBPbJCa6QPtpWXt6OYHxGDGwyhZm
         Kps/3G5dGFiUBWfqx4jh/sIMkW/RkuUul47D/QO67B62pcqc0YPv9qPZkhssyKgynfeH
         nt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=tQAKufzYrZIiW7UDSGtuejMEpxHokTnftOGoQHPMHYA=;
        b=jobbJufibNX32LyyrGaUy8kbOdbAmtZY5i6At2iO3K0laVbmPvw3MQJ4IgqgWTttTU
         Re/6dqMzRpoFlEhO3o/ZVWn+HohzgGbp6VWT0PyItvHe1CTJ0Bvu7WLKOW8lU0JnhrZa
         Ma1GM7afYYb483vGzFrHffccVIwnfoNhkq2PqmzAjwi7gvJZ/3zUgIwdD2R5uZybzM2O
         AnlzFLc+SUj7IJUyVLT+tDTS+FfkQMr2Ke/FgwNH55PzduxMw0oyNel2YLFgcibdfL1D
         yoUapMGEIDHJJ7z+MI4HvNGNm2uX21J8moXWmQdNrUkqQuW3nhtAbtIhyfNMeg5EJvGF
         BWug==
X-Gm-Message-State: AOAM531UulgT7ENCLreHypLzV9RnMG3cbP8l/JPtdOThhZQh/kZLLiW8
        irNDrWwZsUf8rTzcQL8w6fc2t04M4ncP9pDi
X-Google-Smtp-Source: ABdhPJyabxq/zs7jNe3alkH/MB5niruJuZwp5eevNXf1164mCSYUp6NtuqrvfaPMduOegQ/I5ly24g==
X-Received: by 2002:a05:6000:797:b0:207:a48e:f24d with SMTP id bu23-20020a056000079700b00207a48ef24dmr9915939wrb.270.1649779024588;
        Tue, 12 Apr 2022 08:57:04 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:8c7d:f6d7:e9d9:8eff? ([2a01:e0a:b41:c160:8c7d:f6d7:e9d9:8eff])
        by smtp.gmail.com with ESMTPSA id w7-20020a1cf607000000b00389a5390180sm2662110wmc.25.2022.04.12.08.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:57:03 -0700 (PDT)
Message-ID: <b53c5aa5-68fd-e54f-847a-74aaf6f7c049@6wind.com>
Date:   Tue, 12 Apr 2022 17:57:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: What is the purpose of dev->gflags?
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220408183045.wpyx7tqcgcimfudu@skbuf>
 <20220408115054.7471233b@kernel.org> <20220408191757.dllq7ztaefdyb4i6@skbuf>
 <797f525b-9b85-9f86-2927-6dfb34e61c31@6wind.com>
 <20220411153334.lpzilb57wddxlzml@skbuf>
 <cb3e862f-ad39-d739-d594-a5634c29cdb3@6wind.com>
 <20220411154911.3mjcprftqt6dpqou@skbuf>
 <41a58ead-9a14-c061-ee12-42050605deff@6wind.com>
 <20220411162016.sau3gertosgr6mtu@skbuf>
 <686bf021-e6a4-c77a-33c9-5b01481e12f4@6wind.com>
 <20220411165030.f65ztltftgxkltmr@skbuf>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220411165030.f65ztltftgxkltmr@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 11/04/2022 à 18:50, Vladimir Oltean a écrit :
> On Mon, Apr 11, 2022 at 06:27:54PM +0200, Nicolas Dichtel wrote:
>> Same here. Some complex path are called (eg. dev_change_rx_flags =>
>> ops->ndo_change_rx_flags() => vlan_dev_change_rx_flags => dev_set_allmulti =>
>> __dev_set_allmulti => etc).
>> Maybe you made an audit to check that other flags cannot be changed. But, if it
>> changes in the future, we will miss them here.
> 
> I guess I just don't see what other dev->flags that aren't masked out
> from netdev notifier calls may or should change during the call to
> __dev_set_allmulti(), regardless of the complexity or depth of the
> call path.
> 
> And the commit that added the __dev_notify_flags() call said "dev:
> always advertise rx_flags changes via netlink" (i.e. the function was
> called for its rtmsg_ifinfo() part, not for its call_netdevice_notifiers()
> part).
> 
> There *was* no call to dev_notify_flags prior to that commit, and it
> didn't give a reason for voluntarily going through the netdev notifiers,
> either.
Yes.

> 
>> Did you see a bug? What is the issue?
> 
> I didn't see any bug, as mentioned I was trying to follow how
> dev->gflags is used (see title) and stumbled upon this strange pattern
> while doing so. dev->gflags is not updated from dev_set_allmulti()
> almost by definition, otherwise in-kernel drivers wouldn't have a way to
> update IFF_ALLMULTI without user space becoming aware of it.
FWIW, here is the patch that has introduced the gflags field:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=c7a329628f395

> 
> The reason for emailing you to was to understand the intention, I do
> understand that the code has went through changes since 2013 and that
> a more in-depth audit is still needed before making any change.
Yep, because notifiers are called since this patch and maybe some modules expect
this now.
