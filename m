Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBAA6E4871
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDQM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjDQM5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:57:19 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE21493F2;
        Mon, 17 Apr 2023 05:57:02 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id ej15so13072277qtb.7;
        Mon, 17 Apr 2023 05:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736221; x=1684328221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c04Z4NXpAIeTEwDDTm4BcfYvupzlt3zgjEjnDctDkEI=;
        b=U/kjTj9RQcayRHKQxDi3hI56i5xGma0SrEZQuYKgmPEfDko7jLKYHxPhqvWjTwbGqp
         kAE6I7v/rjIsLgkKb8zC8YijTfD3js2dP1uJe20P3U8bM6BdkjxMpf0UGHcfk/635MPw
         noHFOIy4OjKRxQEYIaExjZK1WcGK1b+H8nDuA/9/7I5eCHzgtw23D9hYUW7baKyKucrn
         X+xhuXXHi83rz3UfgcGiO3cvokAlZ3uWwUizKHgGC0gOlO2W8WniWZwrEktrPzpJLJD4
         OJX51vZYizilG5qPupZrIOVOxnQed2rdTCMUG6VqsS4BiaKh2yR9PqRtaf0uoXWtGUE6
         hrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736221; x=1684328221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c04Z4NXpAIeTEwDDTm4BcfYvupzlt3zgjEjnDctDkEI=;
        b=e/TH/aOuU+Ve+ZWQfGphiEm+nWBGmFBMpvI8w41cClQXggRnhZQU4PFd2SRozT5cXb
         caqbTG9UTnUoYx+K6m9rUmDtaU4c5SBpNL5j/rvNogNi6v+67aCefs88Tx/wRS+N/3Z+
         kYWPYliWCrcdbWkR+qz/EqRCGE51b8S4JSCD+HG6PO4gHp2f179BAAcOldWvreWnIsGp
         0Y+PSvz+dBsD6k1AGYB/ricLBi5Auu01jDdKpKIirjv2CkjwavADQO4UQMKylWqcfPDe
         Cl51JWG0zvEtElLUccMY74kCSToyAxBjPIeAHHwl3UMXt3m5V2hdciGKG4cNI8ct1FM1
         xBXg==
X-Gm-Message-State: AAQBX9cMqgfI1qMVwmqwXy1+e+aIxJ/1zUvZeJGaBIvJAdpRiIu0aJhG
        m49cdMnmMszTMDTwyIXMpSQ=
X-Google-Smtp-Source: AKy350a+AcHnoKevzLaRdLy6pCM+8pPbQzqUa/rgOk4mWtZNecjWY/INbPYHtDmzxQlkB1fko8bIGA==
X-Received: by 2002:a05:622a:1b9f:b0:3e4:e4c7:586a with SMTP id bp31-20020a05622a1b9f00b003e4e4c7586amr23504210qtb.4.1681736221478;
        Mon, 17 Apr 2023 05:57:01 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d6-20020ac80606000000b003b635a5d56csm3286265qth.30.2023.04.17.05.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 05:57:01 -0700 (PDT)
Message-ID: <dceab485-1d51-0340-e5cc-8929901c64ad@gmail.com>
Date:   Mon, 17 Apr 2023 05:56:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/7] net: mscc: ocelot: remove struct
 ocelot_mm_state :: lock
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2023 10:05 AM, Vladimir Oltean wrote:
> Unfortunately, the workarounds for the hardware bugs make it pointless
> to keep fine-grained locking for the MAC Merge state of each port.
> 
> Our vsc9959_cut_through_fwd() implementation requires
> ocelot->fwd_domain_lock to be held, in order to serialize with changes
> to the bridging domains and to port speed changes (which affect which
> ports can be cut-through). Simultaneously, the traffic classes which can
> be cut-through cannot be preemptible at the same time, and this will
> depend on the MAC Merge layer state (which changes from threaded
> interrupt context).
> 
> Since vsc9959_cut_through_fwd() would have to hold the mm->lock of all
> ports for a correct and race-free implementation with respect to
> ocelot_mm_irq(), in practice it means that any time a port's mm->lock is
> held, it would potentially block holders of ocelot->fwd_domain_lock.
> 
> In the interest of simple locking rules, make all MAC Merge layer state
> changes (and preemptible traffic class changes) be serialized by the
> ocelot->fwd_domain_lock.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
