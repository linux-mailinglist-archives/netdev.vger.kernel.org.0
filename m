Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741BC6459BB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLGMVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLGMVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:21:14 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A54C265;
        Wed,  7 Dec 2022 04:21:09 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u12so26875675wrr.11;
        Wed, 07 Dec 2022 04:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUj61DdS53bau6yW/e52WrW7NaFKUXNHm1+hhxD6do4=;
        b=ncNhFYLh1vam6J0Brgif4hTvH5bRVaW4TcnkFLTIE2giOPlvKB6HH7gNxnYl5O+dB/
         gl5skH8DaAw8O5J/wQ0nVHRx4u48Cp6qPzpTlX2AmYBJjabhQOVZqz8WSNK5n/reoiFq
         27q01qXXc1tcLu8LIiv7dLYy/etczVlpO1+sVNQD4NHe5d+5h2yFsT1wngNDDAaq+Sem
         jAmjAYmmBbEHrr4UlBG8hVhVhOAIuCH+MzkP3UdAgZi0nBuBLFBDep7ns5QRxyUFofWU
         ZnlWYb7Mw1YAn5TXJ4H/hy1wzTOIrJmRZFt8RUvaQPIfIU8MhH+6wLjbnZV1DkvQc89p
         ub0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUj61DdS53bau6yW/e52WrW7NaFKUXNHm1+hhxD6do4=;
        b=7jqXFbsjTmVwW/5PLRIYAGTK7y72cAI7pr4deoM9wO8sOiTyS6APUOFHBXp/kD84p/
         Ncv6Fzw0y8NyXRExeTG28KM/ibLlU3ch1DZ7YV33x1Pmd0cMywiim8sbqRMi1RjY+vYd
         EoDpBllwWKznN+GqwQ0DoiyGD6kAbsTBuYrBXuOaWlV6AAmddBqz2iNpA/2sPAXPRoIh
         cR/W/xUB7Cw3oMR6AxI22jKJnhi0yyR00Mm8R43W3tVJfwKVYlf1FEKcbt0ieIuPbx3U
         BNzuEgKKylAGZJx2A+jVoQdRt87bZhnIee6G7S+MrgSxzMO6SGOJo7nsgieuUcOrrKFf
         LHWQ==
X-Gm-Message-State: ANoB5plK1x/r+gR0LjKVBop8ZD1sQQT+zPCszxGJqipEEOJCsjvAN0yY
        xPwEE9CdGPgrN/QYDWYIjv8=
X-Google-Smtp-Source: AA0mqf7f0B+1FCT7D6yFWKPF49aQa2dE932U4W/aRJuaHZLSIxaR0hJuxOiIXpPPlYw3XxolkpOfhw==
X-Received: by 2002:a5d:4107:0:b0:242:48c3:7746 with SMTP id l7-20020a5d4107000000b0024248c37746mr13007843wrp.457.1670415668252;
        Wed, 07 Dec 2022 04:21:08 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r2-20020a056000014200b002422bc69111sm24045366wrx.9.2022.12.07.04.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 04:21:07 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:21:04 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <Y5CFMIGsZmB1TRni@kadam>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207121936.bajyi5igz2kum4v3@skbuf>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 02:19:36PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 07, 2022 at 02:23:28PM +0300, Dan Carpenter wrote:
> > The bit_reverse() function is clearly supposed to be able to handle
> > 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> > are not enough to handle more than 32 bits.
> > 
> > Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> >  lib/packing.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/packing.c b/lib/packing.c
> > index 9a72f4bbf0e2..9d7418052f5a 100644
> > --- a/lib/packing.c
> > +++ b/lib/packing.c
> > @@ -32,12 +32,11 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
> >  static u64 bit_reverse(u64 val, unsigned int width)
> >  {
> >  	u64 new_val = 0;
> > -	unsigned int bit;
> >  	unsigned int i;
> >  
> >  	for (i = 0; i < width; i++) {
> > -		bit = (val & (1 << i)) != 0;
> > -		new_val |= (bit << (width - i - 1));
> > +		if (val & BIT_ULL(1))
> 
> hmm, why 1 and not i?

Because I'm a moron.  Let me resend.

regards,
dan carpenter

