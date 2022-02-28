Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B44C65CF
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiB1Jl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiB1Jl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:41:57 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45956692BF
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:41:19 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2d6d0cb5da4so100768667b3.10
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBZFE9+NPOqbUZo7ZoxU8DCcVT91V7sOKzdj5OK18eY=;
        b=HioR+cf5lwxgZ8Du6XQPysiXBeg+hBgC49Usnzh3pFimUQ3NMls9IqOH8QhhhZLm0P
         0I9MmFAAZ5WSEeFPPqq83a3EAEYz/kImnEvXOaIDl+Wke2aL+hrw/tYtHiSUp/bTcAEK
         /MAitugycDTR1VxVU5aE+8pjiaOqkryoetQsIZWPI0/g7cMfc0Kkq7lPeWealD4hxjOa
         KYAVTNXyOwx2luxY81K1htkE7obge5S9qVJit7a0juBonB0A4lOZ/GaKo9VuW5rCD4r0
         u4PSKql5kHL3Aly0R4yiBr6IiURKs2QDQo2HVOavvoAypON7mtBjkG8st69GiszbA1KL
         3aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBZFE9+NPOqbUZo7ZoxU8DCcVT91V7sOKzdj5OK18eY=;
        b=Pd9fGe0z83YUlRSlzqPJuY8nc4wUq4vmPYOVRWv/HI/Orv9FoREDQ4LkIQvj7URe4/
         jntc+OcUTUSeLTeN1IMfPfgxq644xEqDDakfiCWFf+nMlIe134aAhytLbEZ8yMVuQADi
         VCnC/AWu15OhMNjVxMjbfcVAOhktltq+Pa1pivNBUzoMD2sFjxf2+EynzVXeXmotXE9Q
         LxIbUD56lYxmbhw+UxhmFtKRvNcfG2P3sQrqs+bvQ9fd+GWl+LfHh+swKC/OVFrEN907
         jUEhXKll1qmk1mrR8NileXeL6GSuWJjjzVp676TFz7UoAys117DaFU3IjqTOQN4junFG
         79+w==
X-Gm-Message-State: AOAM531yBiMFANObTwfflH2k8QZfzJa3HPtppaG3Wukmyxw5gL38Mmob
        a6YCYHiu2FadsavNzNjm8OeQpNtMKP+ktvzqYurMApiCydbL4Q==
X-Google-Smtp-Source: ABdhPJydUQ6Po4C2Mv12eY4WoXHL+h2WBLk4X/mKS5hG4XlQ+FaZAhbY1EUtCrGsTIbqt2ebZCdKPhp4/szzeF/GJLc=
X-Received: by 2002:a81:8044:0:b0:2db:2d8b:154f with SMTP id
 q65-20020a818044000000b002db2d8b154fmr12078008ywf.191.1646041278523; Mon, 28
 Feb 2022 01:41:18 -0800 (PST)
MIME-Version: 1.0
References: <89abfd9e920d9ee4bc396a6bf94ad4c61d4ef3af.1645802768.git.lorenzo@kernel.org>
In-Reply-To: <89abfd9e920d9ee4bc396a6bf94ad4c61d4ef3af.1645802768.git.lorenzo@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 28 Feb 2022 11:40:42 +0200
Message-ID: <CAC_iWjL7bTq6XQg9YoAo+BCUzA0Ha0DC7M4Jqe7R+_qJE9XR7w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: netsec: enable pp skb recycling
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 at 17:30, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Similar to mvneta or mvpp2, enable page_pool skb recycling for netsec
> dirver.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 556bd353dd42..b0c5a44785fa 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -1044,7 +1044,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>                                   "rx failed to build skb\n");
>                         break;
>                 }
> -               page_pool_release_page(dring->page_pool, page);
> +               skb_mark_for_recycle(skb);
>
>                 skb_reserve(skb, xdp.data - xdp.data_hard_start);
>                 skb_put(skb, xdp.data_end - xdp.data);
> --
> 2.35.1
>
I'll test it at some point just to make sure everything,  but this is
a standard change to enable recycling. So

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
