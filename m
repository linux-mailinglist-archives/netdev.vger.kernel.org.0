Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F235617AE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiF3KXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiF3KWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:22:46 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33761457B7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:22:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e40so25929671eda.2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y5UsByWLMWEYobec0CN6KDFyOSWUvAwaZ8r1U9iYpCA=;
        b=GSP8LRnEUC3YB9em437uwIQRy41VuAuO8g4G5+rvlN9pk2hRaUTIC7RPWtP+4/iLfX
         NbsuWSaMTClElRWXyedG58ZqOOrY3YChazC5x54rw4O8k7egy1jc2YTFgWJa0c+1ttes
         WDniBrpGY8CGEvQSfn1HIIBiabI/klkG7e0t/6oshc86Mmf1IwxQVWtQIdNQz47n2Wxq
         Ue14QtxdR3M9VfCM5ucJ5Mlfr4QiWIiaFaUzmo4H9QDF7WWHx7EXyIYXWUM/c6ey2xDY
         JLckjeXOeuKccRqfKBHHRBOHdgNiEomFXjbyXjpOSC/DPYhETa51oG8U7CQViQueT1hO
         iA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y5UsByWLMWEYobec0CN6KDFyOSWUvAwaZ8r1U9iYpCA=;
        b=8AtMCMAaNZQy4BV1KLjpSJ1v4WSlFOZuzhzfdAARg7zXcOqaQXWfRy8U84/YFD1c5g
         RRe2M/GYlzaFg76viiB4AhnW3Pbm3dndp0Ox/N6znDDslf6Xd9LqEGnbjG0k9nxH092L
         K8XHWXiw6LmtORxiBCgi/pq7dS/fv3CnqQmWYg3QHdigm8yvlrS4qhzfR7LHVlMFtad9
         pqwTr39HlnT416t5tNaFGUdG+XUFc0J9QMPSE2166zYqlDAUWzF+26l03voWdpPOC4UK
         hTNP045OxwAb0vRxkLF4aZJ0gYt8tj9A0Qwd70qhEtDdOk9NfIkkfGJbAa4bc4QWXleF
         YCUQ==
X-Gm-Message-State: AJIora+L4k6jguyB0CXGEZNNIi11QWOpjSkQr4+zj37AXJoDhPobAKnm
        lEHxn4VESzSPLP0ktO/EHGypxA==
X-Google-Smtp-Source: AGRyM1v/sMpb6LQCI0Xbq3TfjZJdpaj0M12tlJRfujf5QX2IMx+u6M1wnBeddEncbkc3uKPAx1y/Nw==
X-Received: by 2002:aa7:d484:0:b0:435:65b0:e2d8 with SMTP id b4-20020aa7d484000000b0043565b0e2d8mr10622588edr.373.1656584559605;
        Thu, 30 Jun 2022 03:22:39 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u17-20020a056402111100b0042deea0e961sm13022756edv.67.2022.06.30.03.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 03:22:39 -0700 (PDT)
Message-ID: <47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackwall.org>
Date:   Thu, 30 Jun 2022 13:22:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that multicast
 packets cannot unlock a locked port
Content-Language: en-US
To:     Hans Schultz <hans@kapio-technology.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220630100512.604364-1-hans@kapio-technology.com>
 <20220630100512.604364-2-hans@kapio-technology.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220630100512.604364-2-hans@kapio-technology.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2022 13:05, Hans Schultz wrote:
> This makes it possible to use the locked port feature with learning
> turned on which is needed for various driver features.
> 
> Signed-off-by: Hans Schultz <hans@kapio-technology.com>
> ---
>  net/bridge/br_input.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 68b3e850bcb9..a3ce0a151817 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -215,6 +215,7 @@ static void __br_handle_local_finish(struct sk_buff *skb)
>  	if ((p->flags & BR_LEARNING) &&
>  	    nbp_state_should_learn(p) &&
>  	    !br_opt_get(p->br, BROPT_NO_LL_LEARN) &&
> +	    !(p->flags & BR_PORT_LOCKED) &&
>  	    br_should_learn(p, skb, &vid))
>  		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid, 0);
>  }

hmm this is called for link-local traffic (01:80:c2), the title is misleading
please include the real traffic type because it doesn't concern mcast

Also please include the long explanation from the 0 patch in this one
and drop the cover letter, it's good to have the info.

Thanks,
 Nik




