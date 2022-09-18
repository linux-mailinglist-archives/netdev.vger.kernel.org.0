Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7D5BBEBD
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 17:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIRPsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 11:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIRPsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 11:48:06 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1C2219E
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 08:48:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id n81so20687863iod.6
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 08:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=alKaJeFUirn/GS0sxz9rF9sOMRImHjlQaIjBcCvM/Uc=;
        b=NGgOHXIXQIilG9xywqXVUKmTnvtHJ9ahVprG9PmiMNnk00HR138sMnQeEj5D/4JMrA
         YGUGMEp5Z1S5uMAFdE2lcxOHLFXLRL2/ABxAtiPtDOb8soFf4vfsOfLtCOLP/HkoPnzj
         jheKbcxFq6gf9rFTIV/SrLrALLOTgQ4ICPu2OUMkZh+AUSzuqUD/DlGOZPLjLBZOMI7D
         a3DQV9j7j31g0sVEiOhqV5c0mnNbpNHCGqRKQqAxOLiGbE9NoZ5j31iksGQIDLYv24d5
         ghxBrIjcwLCeSCqb5Vcs4+L30VhFKvE/HMiTg922SgeDEPJy+a9WPXQXQq2McOVHfDzV
         kRSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=alKaJeFUirn/GS0sxz9rF9sOMRImHjlQaIjBcCvM/Uc=;
        b=n8DVe73/uFqh6pyB6mTgrryCY3kASAAiFSB/xETJAvKNNfc84sGmSH9OZa6OAF/trm
         /gfsocyezjlur4KvdqqC1kfbnvWWOG9pUDfKckJ6APK6NESya3S7WhXMFFnmi5cTOtHl
         TAYXNI93FAJbrzUP+PQvAJF9G3Ef+7VgDqdDpWsPoAE2I5MNNSTw9L4BCu86s1RaRMqG
         Kn94tlqKwJn9YWOpExu79XFlEanNVU17CcNXCy/VI8EddrJVyZIzq8meG5AMKbKzn13A
         7nz7Z0EsSR4+THQDbYJXmGJmZCkEV8/PoA311QYy90c8BWGARJV0X4BbsiPynd9QPLkS
         fEsg==
X-Gm-Message-State: ACrzQf08QoCGOYv0KwRi4QHKyaKUWQlAHcqvBE/AVU9Y/4N4+QgkU0uB
        RRS5N1S+6oJHnmxE6R+bXum6Vp82ahoE2w==
X-Google-Smtp-Source: AMsMyM6ZPoNbzvhM9OMi9BabeXStdhUEOw23inAvjLr3eOa7YsVGgiN50tV2FS5MBiHmglTNuMh+hA==
X-Received: by 2002:a05:6638:1487:b0:35a:ba3d:ba16 with SMTP id j7-20020a056638148700b0035aba3dba16mr2006274jak.188.1663516084774;
        Sun, 18 Sep 2022 08:48:04 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:c55c:7867:c653:4c0e? ([2601:282:800:dc80:c55c:7867:c653:4c0e])
        by smtp.googlemail.com with ESMTPSA id m29-20020a02a15d000000b0035671c2e249sm4559797jah.146.2022.09.18.08.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 08:48:04 -0700 (PDT)
Message-ID: <f1e4b8c6-84bd-5746-b89b-02dc781f23c9@gmail.com>
Date:   Sun, 18 Sep 2022 09:48:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RESEND net-next PATCH] net: rtnetlink: Enslave device before
 bringing it up
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20220914150623.24152-1-phil@nwl.cc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220914150623.24152-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/22 9:06 AM, Phil Sutter wrote:
> Unlike with bridges, one can't add an interface to a bond and set it up
> at the same time:
> 
> | # ip link set dummy0 down
> | # ip link set dummy0 master bond0 up
> | Error: Device can not be enslaved while up.
> 
> Of all drivers with ndo_add_slave callback, bond and team decline if
> IFF_UP flag is set, vrf cycles the interface (i.e., sets it down and
> immediately up again) and the others just don't care.
> 
> Support the common notion of setting the interface up after enslaving it
> by sorting the operations accordingly.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Resubmitting this after review, concerns uttered in original discussion
> three years ago do not apply: Any flag changes happening during
> do_set_master() call are preserved, unless user space intended to change
> them. I verified that a team device in promisc mode still correctly
> propagates the flag to a new slave after applying this patch.
> ---
>  net/core/rtnetlink.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


