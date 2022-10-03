Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B455F2E4E
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJCJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 05:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiJCJmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 05:42:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F805D106
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 02:37:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a10so3479456wrm.12
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 02:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=Q8HsbswI3QqKaypIhrCURYuxm++N+iwkePdXUrgZS0g=;
        b=J1hPz6JGKnbPJmfQ/556Ni7Ls2TTgViYmOj1iB4hzJ5mIj1RDK2MOIL7GuGu7AYWnV
         uPrQGubyngwpBepyk8SXbzyvxc6WJpp1BX6iBMrhluSXPPonBe+keRNGt/Q/YePwpvLW
         XDVOC8EdbiEpu9JE2Qfp70cWWaQJlmQ6FZrdw/stV6DPT3QAj7lSWNzW/flqe7D0f0Eq
         IQbT1s5dbjtksdKFCQLstD8ys+nVKxAY/8YW3eHuGxi8Nx2PBbLDV94/LEGBNuZI70zR
         zZvByr2MBfgylAGD2IH9YYRClKRRlwU9n4k+LZQH3D0o+jYntoYcTUL6GOgNkLsKRaCF
         7OGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Q8HsbswI3QqKaypIhrCURYuxm++N+iwkePdXUrgZS0g=;
        b=sU7lpJ6l47ptNkaoNAINeuDuNfMPAYwmzdTjDIl3hcYUvcHvrkgmoy6/y5vAy02HYq
         r0SkuuCujhYTdNNs3vrLD3QVnF4miaTf25o3w0eW3ymEqJCX/J43Q6oFHrduWM4TXJlW
         jzxBvWx442RFSElchk1T6TEl3Zs94A+VEjOF8Rtn5MAyaJhrl2jg1Ep8Oy71/WqOgrir
         b2h2pCFRT2gLhmYpCQQTfLVFtGR1S4t0Uu4ZskDBmTyJ+KWJBdXEE1WA2rQjGHlSzbGJ
         nnuCeZvSPLEZ18AFtdvkA4mbF6x8GItu6mAgzRkL82CU6PObzOqntPxPiquPubExCfYt
         oHAQ==
X-Gm-Message-State: ACrzQf0kvLIZHkxMPgcvKHgnhWc35zQybRPlbZ1PVisaG7hJ2XpYRPOp
        C6mM07uwOaHTM6ZGwo5DgNIfPQ==
X-Google-Smtp-Source: AMsMyM4tXPm55GNY/9hl0jSM45V2OU0LCclf4w8jWcrGtbK1z9coRTEOPEpeH6w16Eh0guS02TN6pA==
X-Received: by 2002:a05:6000:1866:b0:228:e373:ad68 with SMTP id d6-20020a056000186600b00228e373ad68mr11961510wri.605.1664789838976;
        Mon, 03 Oct 2022 02:37:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:14ee:4d35:8c33:e753? ([2a01:e0a:b41:c160:14ee:4d35:8c33:e753])
        by smtp.gmail.com with ESMTPSA id f13-20020a7bc8cd000000b003a62052053csm18769378wml.18.2022.10.03.02.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 02:37:18 -0700 (PDT)
Message-ID: <4c04b1a9-d8e7-169e-d337-c061f6e600c2@6wind.com>
Date:   Mon, 3 Oct 2022 11:37:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH iproute2-next 2/2] ip: xfrm: support adding xfrm metadata
 as lwtunnel info in routes
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        steffen.klassert@secunet.com, razor@blackwall.org
References: <20221003091212.4017603-1-eyal.birger@gmail.com>
 <20221003091212.4017603-3-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20221003091212.4017603-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 03/10/2022 à 11:12, Eyal Birger a écrit :
> Support for xfrm metadata as lwtunnel metadata was added in kernel commit
> 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
> 
> This commit adds the respective support in lwt routes.
> 
> Example use (consider ipsec1 as an xfrm interface in "external" mode):
> 
> ip route add 10.1.0.0/24 dev ipsec1 encap xfrm if_id 1
> 
> Or in the context of vrf, one can also specify the "link" property:
> 
> ip route add 10.1.0.0/24 dev ipsec1 encap xfrm if_id 1 link_dev eth15
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
