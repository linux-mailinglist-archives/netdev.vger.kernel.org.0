Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9060648F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJTPbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJTPbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:31:44 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057A848EB2;
        Thu, 20 Oct 2022 08:31:44 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id u7so1860958qvn.13;
        Thu, 20 Oct 2022 08:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMEEkfNqRh8ZrYvB+uPHk5TnIhRPMJ6BnXMyDFFyJRs=;
        b=Doc7aWT/JckZD9zcjcP+tN8PnkFC+b55w+Bpt497B/zLlAABqCa687nUaye01+UGxp
         ew0ZfSroEhbzUGTSEAVRIqaJPlEsFjACJygG8hnjClZDvQRefhOoDN2dNw++UYY0FFZZ
         e7QIEbx2C3U0IcJ31Xh0sCVdz5de8NoCyaoowJOxgiaHiQ3ZNcTKRmshXx9ZqhTKe1Yw
         BYIvKnxw3EkpegchqpxzxJ0zvMR5Fosp3+w2v9SzB/zNb14LoiT7a0zCut8rHK1GHyaI
         mJPrHsNoMc9yuxRHW2nbfFqpJrj6mCTlZVPu2KIQvtaT0vIfgMJUUo7ld4VBMiwNY7e6
         UW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMEEkfNqRh8ZrYvB+uPHk5TnIhRPMJ6BnXMyDFFyJRs=;
        b=eLqIsaTuYFxt0mNPcGQGIj+OZsgG+OgbngMiOq07+hTqnnfutcgBD7rB4otiBhpT5o
         yIOVzAgFX5PZ2Wu3EOjaBWPs3KE1EfXZTlzOislrXXM9fZi7iUqOaZbC8LsZQzeFss6O
         aecyntq2/a+BhO/Kb830AgsqnW8XoxJbgMjUpXjY3k1DxKlKWV4lBC+OlcLG7+fsKDRL
         KI4oAbtsAy66LRwaZg3qoSy8pN79+PFIfo023qOOB+hDwnI3TwlBXNpZSbUpZSmjgGKN
         fnFG6XUam98W29rgk5efdOblVFcN924uW4y51KksouADTELBstHlkF2pRcgk4X+WGRXk
         BgjA==
X-Gm-Message-State: ACrzQf2QmIjclEA9IrfICZVD3m5l/XPppby9QDNhUbb2S13Mk5mmD8Ah
        aefbslxY1A1+LdAJ7kb1dFA=
X-Google-Smtp-Source: AMsMyM6DJe6DKkGUuRpF1D9s/9sYos5QPtpr/tJ1bCqi53hQU/Q7L1vsdlKvhxLO3TDH30Gu4VwmSQ==
X-Received: by 2002:a0c:f30e:0:b0:4b1:8eaf:a222 with SMTP id j14-20020a0cf30e000000b004b18eafa222mr12030424qvl.41.1666279902674;
        Thu, 20 Oct 2022 08:31:42 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2ddd:3518:c7e:dcca])
        by smtp.gmail.com with ESMTPSA id m21-20020ac866d5000000b0039cbd3e4ed1sm6232501qtp.6.2022.10.20.08.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 08:31:42 -0700 (PDT)
Date:   Thu, 20 Oct 2022 08:31:42 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/6] bitmap: add a couple more helpers to
 work with arrays of u32s
Message-ID: <Y1Fp3oiUvmm8K1Ab@yury-laptop>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
 <20221018140027.48086-3-alexandr.lobakin@intel.com>
 <Y1CUbRA6hC6PO3IH@yury-laptop>
 <Y1FKkHEtc80wVWw3@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1FKkHEtc80wVWw3@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:18:08PM +0300, Andy Shevchenko wrote:
> On Wed, Oct 19, 2022 at 05:21:01PM -0700, Yury Norov wrote:
> > On Tue, Oct 18, 2022 at 04:00:23PM +0200, Alexander Lobakin wrote:
> 
> ...
> 
> > > +static inline size_t bitmap_arr32_size(size_t nbits)
> > > +{
> > > +	return array_size(BITS_TO_U32(nbits), sizeof(u32));
> > 
> > To me this looks simpler: round_up(nbits, 32) / BITS_PER_BYTE.
> > Can you check which generates better code?
> 
> It's not only about better code, but also about overflow protection, which your
> proposal is missing.

Can you explain how this may overflow?

  #define __round_mask(x, y) ((__typeof__(x))((y)-1))
  #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)

Thanks,
Yury
