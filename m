Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344E3503398
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiDPCHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 22:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiDPCGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 22:06:01 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185726E36D;
        Fri, 15 Apr 2022 18:59:30 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-dacc470e03so9422768fac.5;
        Fri, 15 Apr 2022 18:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZl1G0yOWcHR+4w7BioZbnZEDnrT5AWLArVFooO2o4c=;
        b=D5xuKdFnExTDBQqGU6R+W9iBOJpgg5vTWz80N32DLEL+l8fWuCwxG0MVcgkEwFH7RW
         YvkGiShTxKYq2hXm+RWPdnsD6DLANCncDhkkitJ9shRjRuHTzU8q6hyWi1WbXnZAR2TZ
         evkw8KDtAyW9Zr3GMDBwD7RLvmc2Y9f7bznv649G1+oIzcWr/WP3E4T96M8KiNQ9Tqan
         CusSHAAqLghyE6N8VPTqmRNKvIGPefCOr2mLmjhUs1uUG0N/faddOvgUzzHSOJXBwzNi
         c0t0wfXtojBK6O41quttPCM+v96WGPpztgmcEjzGZ2JQwXccwOo8vK/sellCw3CigLCn
         pthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZl1G0yOWcHR+4w7BioZbnZEDnrT5AWLArVFooO2o4c=;
        b=1NqdEKfQx/IwrlFeIrHhcnYcTpCZuYN1uM1kptxfGIR0vOW2i5YtK02mUVDoyYuktI
         iRA1PxkwumuLKUetCixjumbY0Js5RpbMS6Am1Jcn7wJplXdVh4IUDbuUZXNpao0zE3I8
         sqoWeMeMq7vWzq/4Rav6Au9RhJlOgunkfGp6bdgRIAuYrK2jB88uanG8xAGbGqg0Ivet
         Pa7cQdFyxPEbHKaMRuyAmuNuG6bJ1FuVWQ2p/aPBs8YGtL2G5HRgPd67XTl4ajIVnkYn
         k7z8sNTLG1S2KcnKsmeW7JUkXwurBsbZ8A90cEnb9KJmDdKR6Xv4Y4wKllvAfadmVKcA
         IYOg==
X-Gm-Message-State: AOAM532dEyrt3i81XfDq67YdJfu6NYzkDKcU0HD+bsXaiJkbKNHcqo8i
        0FVpBa6Smi0+9e8eLFu9kgabAIBtteDtTA==
X-Google-Smtp-Source: ABdhPJyxSVABo8qkGB7Wudcok21+GD2dj2PEU388i7rw/ixuqjyPAXobglCig6MbNKyzeogfnUBjzA==
X-Received: by 2002:a17:90a:8581:b0:1b2:7541:af6c with SMTP id m1-20020a17090a858100b001b27541af6cmr1747571pjn.48.1650073848590;
        Fri, 15 Apr 2022 18:50:48 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id v18-20020a17090a899200b001d22f3fe3e2sm205313pjn.35.2022.04.15.18.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 18:50:48 -0700 (PDT)
Date:   Sat, 16 Apr 2022 10:50:42 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Yihao Han <hanyihao@vivo.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH v2] ath11k: simplify if-if to if-else
Message-ID: <Ylog8qhT6X/bYiZZ@d3>
References: <20220415125853.86418-1-hanyihao@vivo.com>
 <ca2944bd-e80e-e0ff-0804-c8439f54b28a@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca2944bd-e80e-e0ff-0804-c8439f54b28a@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-15 16:02 -0700, Jeff Johnson wrote:
> On 4/15/2022 5:58 AM, Yihao Han wrote:
> > Replace `if (!ab->is_reset)` with `else` for simplification
> > according to the kernel coding style:
> > 
> > "Do not unnecessarily use braces where a single statement will do."
> > 
> > ...
> > 
> > "This does not apply if only one branch of a conditional statement is
> > a single statement; in the latter case use braces in both branches"
> > 
> > Please refer to:
> > https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html
> 
> why are you referring to braces when your patch has nothing to do with
> braces?
> 
> changing if (foo) X;if (!foo) Y; to if (foo) X else Y; is not a design
> pattern referenced in the coding style
> 
> > 
> > Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>

I did not suggest this change. Please remove this tag.

> > Signed-off-by: Yihao Han <hanyihao@vivo.com>
> > ---
> > v2:edit commit message
> > ---
> >   drivers/net/wireless/ath/ath11k/core.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
> > index cbac1919867f..80009482165a 100644
> > --- a/drivers/net/wireless/ath/ath11k/core.c
> > +++ b/drivers/net/wireless/ath/ath11k/core.c
> > @@ -1532,8 +1532,7 @@ static void ath11k_core_restart(struct work_struct *work)
> >   	if (ab->is_reset)
> >   		complete_all(&ab->reconfigure_complete);
> > -
> > -	if (!ab->is_reset)
> > +	else
> >   		ath11k_core_post_reconfigure_recovery(ab);
> >   }
> 
