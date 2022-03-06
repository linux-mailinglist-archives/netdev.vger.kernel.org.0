Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902664CEC45
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 17:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiCFQnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 11:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiCFQnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 11:43:17 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B973F31D
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 08:42:23 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d17so2941435pfv.6
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 08:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+M0blLyI3MoclwWcRikU3qaX1kGhiuiBwTcP1Xv60zA=;
        b=V+dOGz16y0tZMfWw/AJXomc3suumS6eeZwXfQL3QI4250OCBALJRG1A6rZm5tI0w5g
         01rAgiZ0UGpXcHfu8azl1k7F3KBXtFqnLGwK+JCOFWn9b3JCWGBh/jes0LPwR0/IvrvQ
         QWfJFelQbYVPnYCyeFAmeKbJpHZnOUeX+IeyY9iQuNuFyh7ZU7Wvg6hoGqcMWQzCK5dd
         avZEkLVxFIYDKbxhIB5GlzSZ6XuE6UV25UZAKWy4/amzw6gzEUsvzBXZW7j5mkKu2z9t
         5cu3xhcUH0VCXewpZw5/n7qgVn/Dn9EMasbpgkmY5q5oWudcDHJwW7wGwi8/cVSeASUF
         BL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+M0blLyI3MoclwWcRikU3qaX1kGhiuiBwTcP1Xv60zA=;
        b=BMr4+T9v5i5CPmBcNp1YGztUQME3il4J7MdQCH1ZInhYYA4x8malclrDbBkqRl/csc
         BkknMucFUHNsFdDbMbWt5KIZrRl7witFV4V5AuCm/tR3yyNlO6kN6GTCh2HoeYoiFs6+
         BYKh3naiE9ipFcZ1YslTBreMrJrtb8h/AkAnkrTNVL/dzFysKNh1fHI+cl7zsNVkMRP4
         YCjK7RifEHbpSFJ/zvc/N0FXMoKHZLwWW56Ts01JV4k+tYd0yv2EsiWPWwkUQpwxalI6
         f2ghkMESekPuiA/UD1/xS9S2kYSRKNl103V+I+3CEdgT/uxU796kiyuKMqZeT1maPzmQ
         nwBw==
X-Gm-Message-State: AOAM533IZP6xjAYJQAL9eOM8de1B06EhZy7ewFwzSaagHvSTtBTRXUfg
        QbEoD9zqZaWFDqq+Q9E79BgFfxTo83k=
X-Google-Smtp-Source: ABdhPJzGdiSSTn851rehUzuUSGR4vMhEOlzz0iuDaZMSsDx+QrDM+XRycSfOCj6Dsngxwt4KUeAYXw==
X-Received: by 2002:a05:6a00:26e2:b0:4e1:296b:f24e with SMTP id p34-20020a056a0026e200b004e1296bf24emr8766233pfw.49.1646584943096;
        Sun, 06 Mar 2022 08:42:23 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id bh3-20020a056a02020300b00378b62df320sm9334194pgb.73.2022.03.06.08.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 08:42:22 -0800 (PST)
Date:   Sun, 6 Mar 2022 08:42:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/6] ptp: Support time stamps based on free
 running time
Message-ID: <20220306164220.GB6290@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220306085658.1943-5-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306085658.1943-5-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 09:56:56AM +0100, Gerhard Engleder wrote:

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 2be263184d1e..2ec8d944a557 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -521,6 +521,8 @@ static inline bool skb_frag_must_loop(struct page *p)
>   * struct skb_shared_hwtstamps - hardware time stamps
>   * @hwtstamp:	hardware time stamp transformed into duration
>   *		since arbitrary point in time
> + * @hwfreeruntstamp:	hardware time stamp based on free running time
> + *			transformed into duration since arbitrary point in time
>   *
>   * Software time stamps generated by ktime_get_real() are stored in
>   * skb->tstamp.
> @@ -533,6 +535,7 @@ static inline bool skb_frag_must_loop(struct page *p)
>   */
>  struct skb_shared_hwtstamps {
>  	ktime_t	hwtstamp;
> +	ktime_t	hwfreeruntstamp;

You are adding eight bytes per frame for what is arguably an extreme
niche case.  I personally wouldn't mind, but expect push back from the
rest of the world!

Maybe this should hide behind a Kconfig option with default off.

@davem, @kuba, what do you think?

>  };
>  
>  /* Definitions for tx_flags in struct skb_shared_info */
> -- 
> 2.20.1
> 

Thanks,
Richard
