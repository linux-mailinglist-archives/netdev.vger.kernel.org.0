Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD75A271E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245207AbiHZLxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiHZLxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:53:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0776BD6BA2
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:53:13 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m16so1514473wru.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc;
        bh=ot9hnSwxaHzr4FECd2navkBp98W7eDubBbiK0ZxqLOM=;
        b=SaJgrajXRjEMX9eFUNNX1f9q08LgqKduoQXUIf0FVjq67FTfg4Aa2mGsTsk/XgHS/r
         zSES2EFPf4weFBtq4/8V0nt4rpNKmvKwyubr6kcLQwSfc+7FK5MrZ3X4Iq01NNllDVtt
         xZG6eJzTCuUyWpeg11d/78n6ueDNM3qi7RvdPUq+EoJjbPHctu3zSqbtgfETXaZ/bP5l
         XSx4eg9YCP9FlifN+pixTDB1K7D107KBwETtjlVkW1+uvpKKOeWTYtRMef1wgV3mKEGu
         +TLR0+rVvyj9MFxr1abJnrQnToZ+QZu+SmSiSCD1mGZHPxnUwoN03HkRN6jt/SP5AMoc
         PfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc;
        bh=ot9hnSwxaHzr4FECd2navkBp98W7eDubBbiK0ZxqLOM=;
        b=aF+oaznFOYI5JKkbclXF2uWgKK5oY+oqQ71I9k9rJHsGcwKrcMoMgxhOkLDWM9+HjD
         buzThI0vAEwipWykQb/R3yoc1GfCHzGYp4hzg6tY6n1My2UnA7kJg+PaPcuui7xOo7PS
         IUr30UxNco3G07hCoU5edvyGqKj5a1gbLYtrkHKt33x+tYGRiIbg8SH7Vyjp928HY8a1
         OjGGGEmDWLPSE3yt9gJzYxIffREgnKEjUlAdJGUqtFmoPFoXXAwX7PMMl4IfsOQJksF0
         uQ2Dm8cYBz9L5NRsqpaNFf+rZaG74oDUL7DecB20cW2HGXZKjfipeM2Nw1r2aOHtwSnD
         Fywg==
X-Gm-Message-State: ACgBeo2MJe+Aj4TuOREGe0GrDRIf/B5VUcthj2ABGpIN1OKeKrkirg7e
        JHaqejZqIU5yrc+jkLQF+aifKw==
X-Google-Smtp-Source: AA6agR7/AaXLuYaUvDBjjlHITj0RLMOL/rKWE9xC5wFVn7yK/1WrBMN9/jrZlUCjKiFNuda58TEcbw==
X-Received: by 2002:adf:fc87:0:b0:225:545f:b707 with SMTP id g7-20020adffc87000000b00225545fb707mr4731822wrr.260.1661514791559;
        Fri, 26 Aug 2022 04:53:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:5d94:b816:24d3:cd91? ([2a01:e0a:b41:c160:5d94:b816:24d3:cd91])
        by smtp.gmail.com with ESMTPSA id a6-20020a5d5086000000b00225307f43fbsm1689076wrt.44.2022.08.26.04.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 04:53:10 -0700 (PDT)
Message-ID: <8e1ecd42-89c5-ba22-2a97-63548036abfc@6wind.com>
Date:   Fri, 26 Aug 2022 13:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next,v4 1/3] net: allow storing xfrm interface
 metadata in metadata_dst
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        razor@blackwall.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
 <20220826114700.2272645-2-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220826114700.2272645-2-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 26/08/2022 à 13:46, Eyal Birger a écrit :
> XFRM interfaces provide the association of various XFRM transformations
> to a netdevice using an 'if_id' identifier common to both the XFRM data
> structures (polcies, states) and the interface. The if_id is configured by
> the controlling entity (usually the IKE daemon) and can be used by the
> administrator to define logical relations between different connections.
> 
> For example, different connections can share the if_id identifier so
> that they pass through the same interface, . However, currently it is
> not possible for connections using a different if_id to use the same
> interface while retaining the logical separation between them, without
> using additional criteria such as skb marks or different traffic
> selectors.
> 
> When having a large number of connections, it is useful to have a the
> logical separation offered by the if_id identifier but use a single
> network interface. Similar to the way collect_md mode is used in IP
> tunnels.
> 
> This patch attempts to enable different configuration mechanisms - such
> as ebpf programs, LWT encapsulations, and TC - to attach metadata
> to skbs which would carry the if_id. This way a single xfrm interface in
> collect_md mode can demux traffic based on this configuration on tx and
> provide this metadata on rx.
> 
> The XFRM metadata is somewhat similar to ip tunnel metadata in that it
> has an "id", and shares similar configuration entities (bpf, tc, ...),
> however, it does not necessarily represent an IP tunnel or use other
> ip tunnel information, and also has an optional "link" property which
> can be used for affecting underlying routing decisions.
> 
> Additional xfrm related criteria may also be added in the future.
> 
> Therefore, a new metadata type is introduced, to be used in subsequent
> patches in the xfrm interface and configuration entities.
> 
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
