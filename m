Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890255F2F6D
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 13:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJCLR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 07:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJCLR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 07:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FE739BA4
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 04:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664795843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNN/awQowjYY/OSbhWJ12ieMCymWD1ABTgD2NfFaiQY=;
        b=HZ19Vgs02KDGj3Gh+vvf9PIvmWu3nZxdhVyEDKjmOE5UMXp7TqOr7OQynj4KgubtmnsVeK
        buu7jSqrFcIEK0sJtm9DixtHDbiam1ktJWwVu0+Y9aLNX3IGDmmOP3S6GwC6X2IN7xw3jr
        W5ORJ1/y8oqFs+ChoapZSNet0PPBCpk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-193-FmgCuQ2QP8e7RHM-S34Xbg-1; Mon, 03 Oct 2022 07:17:21 -0400
X-MC-Unique: FmgCuQ2QP8e7RHM-S34Xbg-1
Received: by mail-qk1-f200.google.com with SMTP id bl17-20020a05620a1a9100b006cdf19243acso8784344qkb.4
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 04:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zNN/awQowjYY/OSbhWJ12ieMCymWD1ABTgD2NfFaiQY=;
        b=4Fai/Ivg9WVAblsSJcQ14F1j2cbcD019m1gW3HxJ+B4dYrFdWyEUMCtQCIufx8is0K
         0WyT88iDZ6h1TGLRNYoCSyPxQUIcmoLdGCF2ZIMMH44YER2cYYkQ1A4IFoSAyYnh51o0
         m2FfRMZRcd960LYTTldzV+pzoOHt5PdD/ppEOoJ3W4iNiWVRMB6fnCF5w4fOWcI0TL1z
         8zuhIzbJbU+89s2kuQs0Zh7lREd0Tkj/VRgqFJnoLzcbltRWLb+Lzl33dN9qi9Yo9oLy
         ThgOZ4hNZRL+Z3XWDUgMmnqfex14OH1DLvJUMp0YWaIocIjUCkcs0oAim3dGiUORQJyo
         tCAQ==
X-Gm-Message-State: ACrzQf31ReXKcZRpgEHR5KGDV1lGuSUXGTOOJg1H9xipdf7jTWDyt9zA
        waiLsCJxM/lVbvGvcPJ9E8Tf3jDMsa4X0Ux6KOQ//yAsl/eYBS3GTltthypN9v9Z4tgvgtRipDd
        UqXHKlxST1cUezakr
X-Received: by 2002:a05:620a:219a:b0:6ce:4164:e22c with SMTP id g26-20020a05620a219a00b006ce4164e22cmr12814960qka.214.1664795840614;
        Mon, 03 Oct 2022 04:17:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6TrmZnw4wqso9g92894QWa6i8MwytoRbzKZSVIgtg/vozS1sjjP0hWsMHQLrOcTaAC25Qh5g==
X-Received: by 2002:a05:620a:219a:b0:6ce:4164:e22c with SMTP id g26-20020a05620a219a00b006ce4164e22cmr12814948qka.214.1664795840391;
        Mon, 03 Oct 2022 04:17:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id dm19-20020a05620a1d5300b006cbbc3daaacsm11529406qkb.113.2022.10.03.04.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 04:17:19 -0700 (PDT)
Message-ID: <866a0ac45418a3543c9ddc2869671fc9c2b20afb.camel@redhat.com>
Subject: Re: [PATCH net] sunrpc: Use GFP_NOFS to prevent use of
 current->task_frag.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
        Benjamin Coddington <bcodding@redhat.com>
Date:   Mon, 03 Oct 2022 13:17:15 +0200
In-Reply-To: <96a18bd00cbc6cb554603cc0d6ef1c551965b078.1663762494.git.gnault@redhat.com>
References: <96a18bd00cbc6cb554603cc0d6ef1c551965b078.1663762494.git.gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 14:16 +0200, Guillaume Nault wrote:
> Commit a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all
> rpciod/xprtiod jobs") stopped setting sk->sk_allocation explicitly in
> favor of using memalloc_nofs_save()/memalloc_nofs_restore() critical
> sections.
> 
> However, ->sk_allocation isn't used just by the memory allocator.
> In particular, sk_page_frag() uses it to figure out if it can return
> the page_frag from current or if it has to use the socket one.
> With ->sk_allocation set to the default GFP_KERNEL, sk_page_frag() now
> returns current->page_frag, which might already be in use in the
> current context if the call happens during memory reclaim.
> 
> Fix this by setting ->sk_allocation to GFP_NOFS.
> Note that we can't just instruct sk_page_frag() to look at
> current->flags, because it could generate a cache miss, thus slowing
> down the TCP fast path.
> 
> This is similar to the problems fixed by the following two commits:
>   * cifs: commit dacb5d8875cc ("tcp: fix page frag corruption on page
>     fault").
>   * nbd: commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
>     memory reclaim").
> 
> Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
> Fixes: a1231fda7e94 ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

@Trond, @Anna, @Chuck: are you ok with this patch? Should we take it
via the net tree or will you merge it?

Thanks!

Paolo

