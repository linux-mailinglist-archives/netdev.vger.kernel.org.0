Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057D45EAFC0
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiIZS0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiIZS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:26:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFFA4BA73
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:24:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b75so7520575pfb.7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4OBTQRXHJygCpY/2rBSvNKQlNNozBBa3mtJlOeJ/EyY=;
        b=cSzvTXKu85TucB7q+g9CQdjC/FdnYJW7ESEBDVMDQZhpqkoHzMT6tB5vmqaaVmtq+c
         HBo/BI5kdAn7jf+xxq5MiOLWI7cJumnHX29hS+SWLXo9wgZxYqgGZ4IjXwCG6/+UPFiS
         mSjP6/8kEubWj+KXOsoeUGGJwGHBMRMvzL4Ek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4OBTQRXHJygCpY/2rBSvNKQlNNozBBa3mtJlOeJ/EyY=;
        b=MZT8YzP7gufpCG0afZySeXKy5rQDpztXPaLgr/B8SVKLNCGLkT5QjqHfUr4YlZH7ug
         s0ugrCcLKnoZLJa0WK+v0JCDktObpCAA+vz8GZTMdutRuC7ygFAurPQEvOF4oulZsBDm
         E6tMa2q5ET5XrZPIcACI+eOKwl8gbJk3v9gaMPMNitGKwBCC1Z/CBMRD35M3PMA4leWx
         Q9c4FkaZMRzCoqbIlDpSL9TqtxxuNpl2nstEhsFKvryW9pRI9h8Lt0jjijwFliTlEMCW
         L9/jLw9TP6T7psUFNI9HzS+9w5l+PnilQTCS3mV1vslKqOgFQZs4XAdSbJVni2cpc0T8
         M+Rg==
X-Gm-Message-State: ACrzQf0Fpydk4ssrioDPP86hzxGL4tywVdieBcij75FmMECLzNLM/SwE
        bSVaVzaVdy33DVoEr2IXU5wP9w==
X-Google-Smtp-Source: AMsMyM6gzz3RlLPDBF6eEAacYBSNNxOrYYdXLeQNzcYYWROPiLY1NScn4aUnW3BZuZbnjPt9v5tgLQ==
X-Received: by 2002:a63:4750:0:b0:43c:dac:9e4b with SMTP id w16-20020a634750000000b0043c0dac9e4bmr21137736pgk.300.1664216679159;
        Mon, 26 Sep 2022 11:24:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902c70200b0016f85feae65sm11305644plp.87.2022.09.26.11.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 11:24:38 -0700 (PDT)
Date:   Mon, 26 Sep 2022 11:24:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 13/16] mempool: Use kmalloc_size_roundup() to match
 ksize() usage
Message-ID: <202209261123.B2CBAE87E0@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-14-keescook@chromium.org>
 <f4fc52c4-7c18-1d76-0c7a-4058ea2486b9@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4fc52c4-7c18-1d76-0c7a-4058ea2486b9@suse.cz>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:50:43PM +0200, Vlastimil Babka wrote:
> On 9/23/22 22:28, Kees Cook wrote:
> > Round up allocations with kmalloc_size_roundup() so that mempool's use
> > of ksize() is always accurate and no special handling of the memory is
> > needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >   mm/mempool.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/mempool.c b/mm/mempool.c
> > index 96488b13a1ef..0f3107b28e6b 100644
> > --- a/mm/mempool.c
> > +++ b/mm/mempool.c
> > @@ -526,7 +526,7 @@ EXPORT_SYMBOL(mempool_free_slab);
> >    */
> >   void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
> >   {
> > -	size_t size = (size_t)pool_data;
> > +	size_t size = kmalloc_size_roundup((size_t)pool_data);
> 
> Hm it is kinda wasteful to call into kmalloc_size_roundup for every
> allocation that has the same input. We could do it just once in
> mempool_init_node() for adjusting pool->pool_data ?
> 
> But looking more closely, I wonder why poison_element() and
> kasan_unpoison_element() in mm/mempool.c even have to use ksize()/__ksize()
> and not just operate on the requested size (again, pool->pool_data). If no
> kmalloc mempool's users use ksize() to write beyond requested size, then we
> don't have to unpoison/poison that area either?

Yeah, I think that's a fair point. I will adjust this.

-- 
Kees Cook
