Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0419B3E9961
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhHKUJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKUJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:09:09 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29101C061765;
        Wed, 11 Aug 2021 13:08:45 -0700 (PDT)
Received: from [192.168.178.156] (unknown [80.156.89.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6D6ABC028E;
        Wed, 11 Aug 2021 22:08:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1628712522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PVzr+AKnU0TDCUnsw7r28VS4KgC9/neTogcSFZCDwyo=;
        b=rrg+/npCAfebx+ScgG4wr6eelaF29kdK2FWSQf8rk60T2vPpQAkIi4F88kXu7DZ66iLWW0
        Sx/zsp4K5OWruqibWkz6eByLcs6Su8IU3ItV3eRhDvP83KO/yfTpJCTZ8LV+1RhwjrwuA5
        D6r45M9tcf7AoSbiU25ri1KMRGuF03pkab0IZf34Lpx5DKFAkJ0H0jNK5tIHae71uWHlRn
        hS5wHtC6SoxZICtPK1FedGMWG5lfYG1zeD+JyNh6hbgoaxNnpH2LDFxFX01jFNiVQ/jOCQ
        AniLUhL3HprwdjzcYFeHXEXkB73lxUfmUp7pMX3SrcW0DtEKxwdtTeGKuXl91Q==
Subject: Re: [PATCH] ieee802154: hwsim: fix possible null-pointer dereference
 in mac802154_hwsim.c
To:     Tuo Li <islituo@gmail.com>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20210811023654.2971-1-islituo@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <7f799a83-0709-d81a-6b45-88f8fafa3b3a@datenfreihafen.org>
Date:   Wed, 11 Aug 2021 22:08:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210811023654.2971-1-islituo@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 11.08.21 04:36, Tuo Li wrote:
> In hwsim_new_edge_nl() and hwsim_set_edge_lqi(), if only one of the two
> info->attrs is NULL, the functions will not return.
>    if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
>        !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
> 	  return -EINVAL;
> 
> However, both of them may be dereferenced in the function
> nla_parse_nested_deprecated(), causing a null-pointer dereference.
> To fix this possible null-pointer dereference, the function returns
> -EINVAL if any info_attr is NULL.
> 
> Similarly, in hwsim_set_edge_lqi(), if only one of the two edge_attrs is
> NULL, both nla_get_u32() and nla_get_u8() will be called, causing a
> null-pointer dereference.
> Also, to fix this possible null-pointer dereference, the function returns
> -EINVAL if any edge_attr is NULL.
> 
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>

Thanks for your patch. This has already been fixed with patches in the 
wpan tree.
https://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git/

I just sent a pull request including them to get pulled into net.

regards
Stefan Schmidt
