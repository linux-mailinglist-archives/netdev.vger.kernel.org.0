Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2996A6700
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 05:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCAEiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 23:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCAEiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 23:38:16 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F320305E5;
        Tue, 28 Feb 2023 20:38:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id g3so3035037wri.6;
        Tue, 28 Feb 2023 20:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGJPeH0r7xdEaYTJzJa7w1hRBmNpRDwnHXG8dM1Fi/8=;
        b=DFkgiwwMhK+5PJqOSgpPSKTngPQSY2UCT674oq6b9cyIrdrAk/eFMPKzpXxAIyU2mu
         AIMVErKA5nZWJ3wD8mx7LGgpKD/41iyjWqIcH59c+EiRJJdzAwSPBWx7UO39UnVQ//Db
         pDQhwa3j/09Z+VPJzZ9qZnnueCsDjit6+GxcDcNGGBZnoDkyxUmzcM9LpdjFsVuPhCMg
         Pn/vqPoGz0RLuhzpxtqYIfmX+SUxQk+WUTbPXVLxLWQ8XksU3r3yg2yKs1cvcUNfk/8r
         WHl+ZnqvX9Dy4JY5JTkBQPOfvpCf1+/e5aVvofM8BmoIuxHtoOImKJMYsOP2O/mRx63r
         kEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iGJPeH0r7xdEaYTJzJa7w1hRBmNpRDwnHXG8dM1Fi/8=;
        b=hhwQloN70Wt4656Dq1gyph6uIM+ZyQsgRWr87kf2w/8lDvGc8yL90W01irAEKu3lDK
         nzdTTJKIjcHO5EoCUzF+qvLfgwZ593yIs7hEw8fqQTSpie9mNIMQFGEcTaX8OCYje3me
         fKT0LR5nCey6hdRHOGKLtlRBXLTyc+y+7UZkTygU+OBSWVoZ4WHnAgPcFH1p7RC+lZKP
         i4mjLO5Bmdtkp90uG/DCjI8SV7uq5EzIyuuThmLIBsluqS/gzziNuIbe37UhgA7VX5G+
         KAsfNIdmPMrzzCYjHibFsKJcbNTkilRsUTM1jMXRS+MyI+4UEg/zkcr+G11fvkr+Fvi4
         wMGg==
X-Gm-Message-State: AO0yUKXWncOyRmdFHipC0OzAqNvaG3y0nygX6fI3h8whwPJnCKiDh1db
        uhLJEiIb2a+HHdEvlT6urV0=
X-Google-Smtp-Source: AK7set+gUptp4vTi5bsWAxrQuCAD1OMXyp9cGvDDgba6mo1W7tgWi8r8vzfAV/1dNQguTi11mFakdQ==
X-Received: by 2002:adf:e54b:0:b0:2c7:169b:c577 with SMTP id z11-20020adfe54b000000b002c7169bc577mr3859807wrm.19.1677645493423;
        Tue, 28 Feb 2023 20:38:13 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id r14-20020adff70e000000b002c567881dbcsm11442126wrp.48.2023.02.28.20.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 20:38:12 -0800 (PST)
Subject: Re: [PATCH v5 01/17] asm-generic/iomap.h: remove ARCH_HAS_IOREMAP_xx
 macros
To:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-mm@kvack.org, arnd@arndb.de,
        christophe.leroy@csgroup.eu, hch@infradead.org,
        agordeev@linux.ibm.com, wangkefeng.wang@huawei.com,
        schnelle@linux.ibm.com, David.Laight@ACULAB.COM, shorne@gmail.com,
        willy@infradead.org, loongarch@lists.linux.dev,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        netdev@vger.kernel.org, Martin Habets <habetsm.xilinx@gmail.com>
References: <20230301034247.136007-1-bhe@redhat.com>
 <20230301034247.136007-2-bhe@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <7bd6db48-ffb1-7eb1-decf-afa8be032970@gmail.com>
Date:   Wed, 1 Mar 2023 04:38:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230301034247.136007-2-bhe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/2023 03:42, Baoquan He wrote:
> diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/io.h
> index 30439cc83a89..07f99ad14bf3 100644
> --- a/drivers/net/ethernet/sfc/io.h
> +++ b/drivers/net/ethernet/sfc/io.h
> @@ -70,7 +70,7 @@
>   */
>  #ifdef CONFIG_X86_64
>  /* PIO is a win only if write-combining is possible */
> -#ifdef ARCH_HAS_IOREMAP_WC
> +#ifdef ioremap_wc
>  #define EFX_USE_PIO 1
>  #endif
>  #endif

So I don't know how valid what we're doing here is...

> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index 08237ae8b840..196087a8126e 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -93,15 +93,15 @@ extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
>  extern void ioport_unmap(void __iomem *);
>  #endif
>  
> -#ifndef ARCH_HAS_IOREMAP_WC
> +#ifndef ioremap_wc
>  #define ioremap_wc ioremap
>  #endif

... but it looks like this will break it, since in sfc/io.h
 `#ifdef ioremap_wc` will always be true (if I'm correctly
 understanding what we get via #include <linux/io.h>, which I'm
 probably not because asm includes always confuse me).
I.e. we're not just interested in "can code that calls ioremap_wc
 compile?", we care about whether we actually get WC, because
 we're making an optimisation decision based on it.
