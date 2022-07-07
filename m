Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61A9569C41
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiGGHvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiGGHvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D877433A17
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657180257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+6vKb5qtW2WQk3PF9/RN812iqCXsUylPTfCM4P31gZ0=;
        b=Z9/dRsgWOW1aq8VVcce7SDWbhH4blf5vJqWJFFf8luO3qJI/54bMxFmLmUUajfrDcCiL0q
        FlHWlxvDCExwmI+THavvOsRuEa119rLr82g/xq61SJceD+W6v3CpydQIynJSU4EaELWDOI
        vHUuqOpUOiDnjntdw+XZOCagrlSKQGg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-Ns67yTAhOKOQ4b9PgQxv8Q-1; Thu, 07 Jul 2022 03:50:55 -0400
X-MC-Unique: Ns67yTAhOKOQ4b9PgQxv8Q-1
Received: by mail-wm1-f72.google.com with SMTP id r7-20020a1c4407000000b003a2cfab0839so15919wma.5
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 00:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+6vKb5qtW2WQk3PF9/RN812iqCXsUylPTfCM4P31gZ0=;
        b=fmdWTiHO69GJ6gs15L1gW3mhwPo4FEd+0eqsF2Lx/nR7BdYIoSR2iyH4pmWyERBSa6
         jLTM48nEBV+9Ph3JtABled2RgWHCfK3m7GtxC+R+pqpUj4kHp7xNEv7GLBCQuE1e/XZ8
         ZMrUgOpBDXpHQe0FU8L9+CpxsSFVVFbR5925GGLKlHaHWGiWGQJp+NcGe3fmFVVz4S+S
         bTfoiTXFpyrZ3Ajct6qNKJC7YAjuO56Q9wgqCweVGiv4L6HjbBksDo0YZPaK2UZMJj/l
         ccNW2vqr0x/2+68eBRyZdCmfnODobT4YesZTRZo3aoAxfnY+eST7/W7IOQggynMXfKSn
         TWFQ==
X-Gm-Message-State: AJIora+2MfjzacATkNem/PyJyu3rA9n/W6HOLMDjBaqPFP/YuEDYbqfk
        U5f3Crb96+4E+/S1wxL0mOsKnMakyIW7Z75ky1YMvYkCzigAAFMvutAfEhZNFPnvat/T4myxWZl
        BRBtGogAlTtDRCwVF
X-Received: by 2002:adf:fa04:0:b0:21d:1864:3172 with SMTP id m4-20020adffa04000000b0021d18643172mr44359084wrr.292.1657180254794;
        Thu, 07 Jul 2022 00:50:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s+oP8nKMiKtM5JWiNW2EmP7v5KZWVhT1rv4ikXnOMyupFZ/UG6Ka+8OsYj9pCbnG7pzppYQQ==
X-Received: by 2002:adf:fa04:0:b0:21d:1864:3172 with SMTP id m4-20020adffa04000000b0021d18643172mr44359057wrr.292.1657180254605;
        Thu, 07 Jul 2022 00:50:54 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id u6-20020a5d5146000000b0020fcc655e4asm38297650wrt.5.2022.07.07.00.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:50:54 -0700 (PDT)
Date:   Thu, 7 Jul 2022 09:50:52 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     James Chapman <jchapman@katalix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] net: l2tp: fix clang -Wformat warning
Message-ID: <20220707075052.GA3912@debian.home>
References: <20220706230833.535238-1-justinstitt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706230833.535238-1-justinstitt@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 04:08:33PM -0700, Justin Stitt wrote:
> When building with clang we encounter this warning:
> | net/l2tp/l2tp_ppp.c:1557:6: error: format specifies type 'unsigned
> | short' but the argument has type 'u32' (aka 'unsigned int')
> | [-Werror,-Wformat] session->nr, session->ns,
> 
> Both session->nr and session->ns are of type u32. The format specifier
> previously used is `%hu` which would truncate our unsigned integer from
> 32 to 16 bits. This doesn't seem like intended behavior, if it is then
> perhaps we need to consider suppressing the warning with pragma clauses.

pppol2tp_seq_session_show() is only called for L2TPv2 sessions, where
ns and nr are 2 bytes long (L2TPv3 uses 3 bytes, hence the u32 type in
the generic l2tp_session structure). So %hu shouldn't truncate anything
here.

However %u doesn't harm and is cleaner than silencing the warning with
pragma.

Acked-by: Guillaume Nault <gnault@redhat.com>


> This patch should get us closer to the goal of enabling the -Wformat
> flag for Clang builds.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/378
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> ---
>  net/l2tp/l2tp_ppp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
> index 8be1fdc68a0b..db2e584c625e 100644
> --- a/net/l2tp/l2tp_ppp.c
> +++ b/net/l2tp/l2tp_ppp.c
> @@ -1553,7 +1553,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
>  		   session->lns_mode ? "LNS" : "LAC",
>  		   0,
>  		   jiffies_to_msecs(session->reorder_timeout));
> -	seq_printf(m, "   %hu/%hu %ld/%ld/%ld %ld/%ld/%ld\n",
> +	seq_printf(m, "   %u/%u %ld/%ld/%ld %ld/%ld/%ld\n",
>  		   session->nr, session->ns,
>  		   atomic_long_read(&session->stats.tx_packets),
>  		   atomic_long_read(&session->stats.tx_bytes),
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 

