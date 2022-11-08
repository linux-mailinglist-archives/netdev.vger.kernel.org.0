Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AAF6211FA
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiKHNIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiKHNID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:08:03 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74D1BD3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:08:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id 13so38515042ejn.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YgGAxT2dN/rtYfkynXxG3S3gwoXR7pGRQb0UFL/LREs=;
        b=iSPMTgL2KOxWP0nJNepfg2jez8l5YLPh81QvTy5e0HyWyBKvYlci4gwat5DsjZW+Gp
         rA1to0EZuP2zaDPJoEVmx0NdOlFupS6Gv+uv+CiJF7d+4HmItoBoh1+MUH8RH53FTR0y
         Wcw1V/n/ygOt5Z87FrWFxAcBy6qOekDVBhjfZgjcG7CA57fSKNV8tShfRZHHUIAO1ft2
         Fxn2m6B/dhKoPpviZmCCOzXbb/kobpbAS+lgo6uYqx4MgZiUQf4bIEeALeTXMKXfzKdB
         GQRO0nPzPZN1nLiSd9P5OeC/4UY0/6wp7n8S2SJEkS1gHabZ0Ar4xtWWJ+2JczO8cRbv
         GBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgGAxT2dN/rtYfkynXxG3S3gwoXR7pGRQb0UFL/LREs=;
        b=WsGf03C5wpMB1WLyS7cSoqxo815fNu9nz1IX0Tiso9rzrJoQzeQ14WMTeuVmP43HLW
         xbCkZJckolsZSgx6EUBiVQLmYg9gb1ELARRcQ2Shxfgxj50r3ZD+yHsycL/v17B2WKRG
         tthLPJNL5/R04/KV8buKnC+weZo2UvTpT7MpzTurm5ic6LJ5JXgbMMuSwMk1qILzAjR7
         C0Sqs0qi4D+QW7C7BLqFxzbcWKLWvKWvUwuJPtiKQwBCLt+8iyCqF9eybrUnggH4qgC+
         iaYPahU+k0WkupWYgj+9aO8PFnXx2ZHfFXWIQaubnwvRq0CFxHsjO1qPrcjxw3vhyVOL
         SAEQ==
X-Gm-Message-State: ACrzQf0Sz+UehytPYe/uLYz4MLe3hb+s72G1y97JqFXmrUJJWpyisRU7
        NQ/Q+KgcRrGFMAe1JJq/juBjjw==
X-Google-Smtp-Source: AMsMyM6NG9hx12ILE9szF89mNHRHCrVN9QOuSJs0JldXK1hP1H2EjzW5WYJtfbIeQO0JxbGd/niM5Q==
X-Received: by 2002:a17:907:728f:b0:7ad:dcbb:3e7f with SMTP id dt15-20020a170907728f00b007addcbb3e7fmr40568241ejc.535.1667912880327;
        Tue, 08 Nov 2022 05:08:00 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709061db100b007789e7b47besm4619959ejh.25.2022.11.08.05.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 05:07:59 -0800 (PST)
Date:   Tue, 8 Nov 2022 14:07:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, bigeasy@linutronix.de,
        imagedong@tencent.com, kuniyu@amazon.com, petrm@nvidia.com
Subject: Re: [patch net-next 2/2] net: devlink: move netdev notifier block to
 dest namespace during reload
Message-ID: <Y2pUrs44U4LkZsHs@nanopsycho>
References: <20221107145213.913178-1-jiri@resnulli.us>
 <20221107145213.913178-3-jiri@resnulli.us>
 <Y2oPRR+P2ecMLPMl@shredder>
 <Y2pSxnZjdrsSjW2j@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2pSxnZjdrsSjW2j@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 08, 2022 at 01:59:50PM CET, jiri@resnulli.us wrote:
>Tue, Nov 08, 2022 at 09:11:49AM CET, idosch@idosch.org wrote:
>>On Mon, Nov 07, 2022 at 03:52:13PM +0100, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@nvidia.com>
>>> 
>>> The notifier block tracking netdev changes in devlink is registered
>>> during devlink_alloc() per-net, it is then unregistered
>>> in devlink_free(). When devlink moves from net namespace to another one,
>>> the notifier block needs to move along.
>>> 
>>> Fix this by adding forgotten call to move the block.
>>> 
>>> Reported-by: Ido Schimmel <idosch@idosch.org>
>>> Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
>>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>>
>>Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>>Tested-by: Ido Schimmel <idosch@nvidia.com>
>
>Sending v2 with cosmetical changes. Please put your tags there again.

Actually, this patch stays untouched. So I'll add it.

>Thanks!
>
>>
>>Thanks!
