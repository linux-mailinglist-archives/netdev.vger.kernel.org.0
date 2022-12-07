Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B181645A2B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiLGMvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGMvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:51:17 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ECF4E685;
        Wed,  7 Dec 2022 04:51:15 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r65-20020a1c4444000000b003d1e906ca23so952421wma.3;
        Wed, 07 Dec 2022 04:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EmAGgUk46Zi0pbhWz1FAYyEwTM+DUAARY75FlGYPEKA=;
        b=IrKI+AlPoS/A7wUwucc/bLt1re4BAK1qtUe3AvvRmws7olKgOZnpx8tHf1JxgY9ltz
         xwnn4A6iy1cygRdGmI/vFZjrp8mDeMz82wDgxVtS79t87wIAUp8He1ZD1zgcIgApBGIY
         0XUbn83S2OI18uESyVaYsWvideuJY6CB5EhWPxES7uFJ53xWdie+ntzOrzBgDb49JU6p
         z4iE2lVwPQliKQAIwaK9smHDgWdwGCoWn5OVq5+eg032CkhTIl0odxOdtxuHOlefQzRI
         0MJsKEHsB0s14U4yUyTugZTzWbfiQrYDmYz0HgPyMxLlsV5YUh8BCoT4ZsCURHwwISQo
         H8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmAGgUk46Zi0pbhWz1FAYyEwTM+DUAARY75FlGYPEKA=;
        b=5E204OxyQgoSmKO99cZuSG2MDkAinH2FJaDuPkY2rgpihvsR1KCOkTWthl/fQ4Qz8e
         F8ngMhI+f3JoO/+09BsY0PL/kV/PBgRMblYxW2MtamLmeGfa7VcB9lJQRsQ5nAcW0YDC
         DlKhdWjSopY5sgBRtMBsFKvSDVx9YvdoZwWXIFedu7+pOSMMJcBCW9GMXO6ich1eiiO3
         tWkkaqr5XK2x9eIN8HQ8QjvLFnHyDodtoEIobT2tF2Ojmgl21vC1D3N2Hq0TOAGS1wr+
         wzS8fEju0CfM6mTmXqL3nq8IQFRy3jxSMz4D38SiUlDJYMMERWxhLPMxPRUHPVcaWiQg
         e4YQ==
X-Gm-Message-State: ANoB5pnBIGsZAAyFvf0Ii5Y4XQ3SetjmGSwXBF30/NqNUVJXKEZc/mCo
        EhFQ0NH/6gM3m9Md8tQiO5Y=
X-Google-Smtp-Source: AA0mqf5piDfabNZVMyogT+kODxjUb4BeltVpq1Fo4ZxMkEtn2MGFVPyF1AxS7JnFRT8xTyPodClcFw==
X-Received: by 2002:a05:600c:3b24:b0:3cf:88df:d355 with SMTP id m36-20020a05600c3b2400b003cf88dfd355mr65800211wms.141.1670417473643;
        Wed, 07 Dec 2022 04:51:13 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g8-20020a5d46c8000000b0023662d97130sm19456173wrs.20.2022.12.07.04.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 04:51:13 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:51:08 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <Y5CMPGrSuP+0ptdP@kadam>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
 <Y5CFMIGsZmB1TRni@kadam>
 <20221207122254.otq7biekqz2nzhgl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207122254.otq7biekqz2nzhgl@skbuf>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 02:22:54PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 07, 2022 at 03:21:04PM +0300, Dan Carpenter wrote:
> > On Wed, Dec 07, 2022 at 02:19:36PM +0200, Vladimir Oltean wrote:
> > > On Wed, Dec 07, 2022 at 02:23:28PM +0300, Dan Carpenter wrote:
> > > > The bit_reverse() function is clearly supposed to be able to handle
> > > > 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> > > > are not enough to handle more than 32 bits.
> > > > 
> > > > Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> > > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > > ---
> > > >  lib/packing.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/lib/packing.c b/lib/packing.c
> > > > index 9a72f4bbf0e2..9d7418052f5a 100644
> > > > --- a/lib/packing.c
> > > > +++ b/lib/packing.c
> > > > @@ -32,12 +32,11 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
> > > >  static u64 bit_reverse(u64 val, unsigned int width)
> > > >  {
> > > >  	u64 new_val = 0;
> > > > -	unsigned int bit;
> > > >  	unsigned int i;
> > > >  
> > > >  	for (i = 0; i < width; i++) {
> > > > -		bit = (val & (1 << i)) != 0;
> > > > -		new_val |= (bit << (width - i - 1));
> > > > +		if (val & BIT_ULL(1))
> > > 
> > > hmm, why 1 and not i?
> > 
> > Because I'm a moron.  Let me resend.
> 
> Wait a second, I deliberately wrote the code without conditionals.
> Let me look at the code disassembly before and after the patch and see
> what they look like.

My crappy benchmark says that the if statement is faster.  22 vs 26
seconds.

regards,
dan carpenter

#include <stdio.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>

#define BIT(n) (1 << (n))
#define BIT_ULL(n) (1ULL << (n))

#define u64 unsigned long long
#define u32 unsigned int
#define u16 unsigned short
#define u8  unsigned char

static u64 bit_reverse1(u64 val, unsigned int width)
{
	u64 new_val = 0;
	unsigned int i;

	for (i = 0; i < width; i++) {
		if (val & BIT_ULL(i))
			new_val |= BIT_ULL(width - i - 1);
	}
	return new_val;
}

static u64 bit_reverse2(u64 val, unsigned int width)
{
	u64 new_val = 0;
	u64 bit;
	unsigned int i;

	for (i = 0; i < width; i++) {
		bit = (val & BIT_ULL(i)) != 0;
		new_val |= (bit << (width - i - 1));
	}
	return new_val;
}

int main(void)
{
	unsigned long long val;

	for (val = ULLONG_MAX - INT_MAX; val; val++)
		bit_reverse1(val, 2);

	return 0;
}

