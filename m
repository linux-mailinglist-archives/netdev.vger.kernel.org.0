Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945474AEA95
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiBIGs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiBIGsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:48:55 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A3EC05CB82;
        Tue,  8 Feb 2022 22:48:58 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id p14so1128562qtx.0;
        Tue, 08 Feb 2022 22:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lAqaRsXwc1gC7GE6i8m+gUTSpQepPCDhRGq27De/nR4=;
        b=c0XyOtHiSSfBQbMnR+HRZSb2cSonct9adQm13eUu8KxhJXJPcfkk5TS2By/aaT0O5Y
         TBSGT1oB9UvByZ7RJVghm5sreKSrRt59pWR1MD5LP8y3LOrfUMzsUreojm3Wr8VK7bXE
         i37pfRf6y2l+qe7Hb84RSH8SD2JeCOvCmnoDfLQO8bIka23E2uwQP6LiKNQftDuvYTPV
         Pps5jqP2cEOkSjgxHDqw23XeAyeowtMUm7TyPS4wJJ9NbBg9MOHZORpXxzP7ihYBBvwB
         nyMvPrw3EO+wyutH3hfqBuHFnmeNZhN4+eV0effOXS4RwKYv2liuTm4G04vd5K+9ZP3j
         LLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lAqaRsXwc1gC7GE6i8m+gUTSpQepPCDhRGq27De/nR4=;
        b=eOxI4gkIRrrG2ywyXfYgQ0VQnquwvWKgXMVQPqjeAPbwIz2DL5EvsNG2uQgRediz+Y
         Uv8c9KNai5MGWgGT+78HJ97v0wfmDr6kMKgZYllECCjhL4C6gv4g9whvb2JVNXhTUMhU
         Z9bCUBFHJPuZDxgr/SAI19bGFpwhUbk5iyAF2/IvauaSc9WjFmuwiy7TErZh5x0oY7yp
         c61f68Rak55RGpfevT6RQVWChweTsQrzTIiuk11GWt+YC98K8274cFvRVe3/8O8IApyo
         /yVbAQLXMhwk/qRo1wg+TDpoL93vE0ThKqVUHyftoPyjEJ/fWv/KFA/Tg7hXUSy9T/3j
         TJNw==
X-Gm-Message-State: AOAM530E6les5BnzGcBy2+v5HIDddWe8FPbjLLsdwVkMwBrgSf14RdLz
        Qo3gO6btXFsJj0V/TKVYnqk=
X-Google-Smtp-Source: ABdhPJwS7iqr+j+AfMft9VVVJSRtIo7OX0GKoilYOF/xr3gGHIUyem5hRghiHScRdJi62rNfE1mkVw==
X-Received: by 2002:ac8:5a54:: with SMTP id o20mr439830qta.670.1644389337016;
        Tue, 08 Feb 2022 22:48:57 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id e9sm9036736qtx.37.2022.02.08.22.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 22:48:56 -0800 (PST)
Date:   Tue, 8 Feb 2022 22:46:43 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 33/54] net: ethernet: replace bitmap_weight with
 bitmap_weight_{eq,gt,ge,lt,le} for mellanox
Message-ID: <YgNjU8iXJ8WIyh/P@yury-laptop>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-34-yury.norov@gmail.com>
 <Ye6gDK2MA+cshctS@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye6gDK2MA+cshctS@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 02:48:12PM +0200, Andy Shevchenko wrote:
> On Sun, Jan 23, 2022 at 10:39:04AM -0800, Yury Norov wrote:
> > Mellanox code uses bitmap_weight() to compare the weight of bitmap with
> > a given number. We can do it more efficiently with bitmap_weight_{eq, ...}
> > because conditional bitmap_weight may stop traversing the bitmap earlier,
> > as soon as condition is met.
> 
> > -	if (port <= 0 || port > m)
> > +	if (port <= 0 || bitmap_weight_lt(actv_ports.ports, dev->caps.num_ports, port))
> >  		return -EINVAL;
> 
> Can we eliminate now the port <= 0 check? Or at least make it port == 0?

The port is a parameter of exported function. I'd rather not take this risk.
Even if it makes sense, it should be a separate patch anyways.
