Return-Path: <netdev+bounces-11405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0259732FD8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C83E31C20EF1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922E01427C;
	Fri, 16 Jun 2023 11:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DA113AC1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:29:26 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB602130;
	Fri, 16 Jun 2023 04:29:24 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30c55d2b9f3so389259f8f.2;
        Fri, 16 Jun 2023 04:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686914963; x=1689506963;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQYl/X7cVGReKQi5TZlRt9DYXVaMgcFNStYfbfHB4wo=;
        b=PAE35ImSBw40YhqoVA4tYR8BrFDnWzfowMD4fVGXnhCdBKoNoN/76o2dMxWMbzEjxK
         2Cq6CmEmZe2ie4/+QzNo8zbfL7fTYilVXLEP2mGi4waAO6AZXhN8/fmYVyTErdjBayLT
         PaHhp2K5pM+H1dDmloOcio9Gn/swU3RFTu87wzF8ydwVz2frqrHysKeVSk7aaEW7aYnp
         K5QTAithGF3NiUw4tzTQme703vnzrSbDvXL558IZkmIyp296TUg9zNprzwfpHSEBM+2T
         JS1mEMnKce6Vjl6wfOaWCcx1UZ20FOsjE5ArLtaHzVy6Tfui37dgvaZ9pE6dFQZMK+Z3
         B7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686914963; x=1689506963;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQYl/X7cVGReKQi5TZlRt9DYXVaMgcFNStYfbfHB4wo=;
        b=JfNR1djV6kybozNFi6bb1A9F947Q3FVF6HHqlOogXEUasccxhg9kKNoiZTErZQweNk
         OCrQ+CIMCd81wEPJku7dgGRvK9pibdrGKb2HyKVmw8w5adUuqWyGE/l6NyHcREbd3xFd
         em+BNRCd3L8k1lsDoMKNHXC1gvveqtTh5LCmVQeUKykEmBem3p+ymCZup+GQOw0RWgfP
         R5NTkt38pWBQzReR45yzR5bXHo0hLruzPDAHHl6BxYBAG6SgOBN+oE22oSOSV8nt6rF5
         KVzoDaaBTY4LvJM3wZDG1PRfegnCou/d6WMma7NpwkGOEbchRlOXCZMK4FTsYBVzoE3n
         6lRw==
X-Gm-Message-State: AC+VfDwH1rKXefDR0TmXCmaYvlNp/mzYciYxVOOSrfigXLGWvDYurn3h
	EncVrKuXd92pQ3n0K1Gfie8969DUbCU=
X-Google-Smtp-Source: ACHHUZ5vIInpoRudDeijycYLzQsH+fgdl2bAO5KX5gFXk1Xgs1slBF2/QhAbcvFg/iKXciYVC9IVug==
X-Received: by 2002:a5d:660f:0:b0:311:e41:d71d with SMTP id n15-20020a5d660f000000b003110e41d71dmr1098747wru.28.1686914962810;
        Fri, 16 Jun 2023 04:29:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n16-20020adfe350000000b0030e5b1fffc3sm23470853wrj.9.2023.06.16.04.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 04:29:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] sfc: fix uninitialized variable use
To: Arnd Bergmann <arnd@kernel.org>, Martin Habets
 <habetsm.xilinx@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <simon.horman@corigine.com>,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 netdev@vger.kernel.org, linux-net-drivers@amd.com,
 linux-kernel@vger.kernel.org
References: <20230616090844.2677815-1-arnd@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a1ec4273-caa4-5a25-dc1f-f05bbfb907b9@gmail.com>
Date: Fri, 16 Jun 2023 12:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230616090844.2677815-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/06/2023 10:08, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new efx_bind_neigh() function contains a broken code path when IPV6 is
> disabled:
> 
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:7: error: variable 'n' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:184:8: note: uninitialized use occurs here
>                 if (!n) {
>                      ^
> drivers/net/ethernet/sfc/tc_encap_actions.c:144:3: note: remove the 'if' if its condition is always false
>                 if (encap->type & EFX_ENCAP_FLAG_IPV6) {
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/sfc/tc_encap_actions.c:141:22: note: initialize the variable 'n' to silence this warning
>                 struct neighbour *n;
>                                    ^
>                                     = NULL
> 
> Change it to use the existing error handling path here.
> 
> Fixes: 7e5e7d800011a ("sfc: neighbour lookup for TC encap action offload")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/sfc/tc_encap_actions.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
> index aac259528e73e..cfd76d5bbdd48 100644
> --- a/drivers/net/ethernet/sfc/tc_encap_actions.c
> +++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
> @@ -163,6 +163,7 @@ static int efx_bind_neigh(struct efx_nic *efx,
>  			 * enabled how did someone create an IPv6 tunnel_key?
>  			 */
>  			rc = -EOPNOTSUPP;
> +			n = NULL;
>  			NL_SET_ERR_MSG_MOD(extack, "No IPv6 support (neigh bind)");
>  #endif
>  		} else {
> 

Nack.  There is a bug here, as you've identified, but the right fix
 is to add a 'goto out_free;' after setting the rc and extack msg.
Setting n to NULL and relying on the subsequent error path will not
 only produce the wrong rc and error message, it will also attempt
 to drop a reference on neigh->egdev that was never taken.

-ed

