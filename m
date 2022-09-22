Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1D5E6CF3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIVUVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIVUVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1931B10F735
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663878101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8fW3xWTKzsefF2RvXPfAH5yzzaw8F3R8M4svnMlThM=;
        b=YZSYSGKts9jgqeQCkuK36+H+BWBfYSTW28pRJYf+6FWoi37VXIk9AokyKC568SjHBiN8dp
        GsKnvLJCIbHgMIcVPQc28KVLg+QI2p6/5Lqx9c6v2EA6HNddilMJFXtV2317RrEdaofrZr
        HcxiQfsUe+rhxIW3qcRw2u4VjIGkNps=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-KP8-0G4_PVm44xp6kpZikA-1; Thu, 22 Sep 2022 16:21:37 -0400
X-MC-Unique: KP8-0G4_PVm44xp6kpZikA-1
Received: by mail-qv1-f69.google.com with SMTP id f9-20020ad442c9000000b004ac7f4fde18so7222595qvr.14
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 13:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=U8fW3xWTKzsefF2RvXPfAH5yzzaw8F3R8M4svnMlThM=;
        b=LnualUw6dHlgEM00YFHrjtMvbUtPMnHh0vUTNL0QMTSkgkohc8c4xfGXymME3GUgQ8
         grdueKc1zFlXUL3YNIFe8oPPS/S6cflfcNmu+5C4XzCAi0r34kSoTO/FZfRARbibSFaV
         6TlGoGuoatRFS+q7oaBVA5DEpU4CNg34NDDECOd6zek1m7mYKD7LpxfRLVrgjdXhCHJ3
         Lw6kTQ16pnv+AomqgB7ZKEJ2ICaBeyceQoC42W+qiBFJqoh0mqwFLN7JGZK7O/rHkPZq
         CQhErbwXZcrz1nz1EHY0ZroD/91D7t1UdDnEUlblMXhaKlp6cB5WuMuArGR4/uBS/d/h
         4zJQ==
X-Gm-Message-State: ACrzQf3b81rQCoserHspbh9CgN3v1RMiMXXtI42Bc53EH9fPxgYxHM5N
        fBgTyXbJvzjOChIndTn5Eq65SVpsZmCWaWCm4Fe/4CjOC+owSz4c6JBS/aMrF5KUd0L/8cplfKp
        o3wTFefhqeQIW79As
X-Received: by 2002:a05:620a:2115:b0:6cd:ef64:b287 with SMTP id l21-20020a05620a211500b006cdef64b287mr3536891qkl.704.1663878096909;
        Thu, 22 Sep 2022 13:21:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6WNjeixQ9lPXAh7qbAjL7NpZaZuOaUD2elIkefVm19/LUXKFOShuADxyQdmiENkyEamUL3BQ==
X-Received: by 2002:a05:620a:2115:b0:6cd:ef64:b287 with SMTP id l21-20020a05620a211500b006cdef64b287mr3536879qkl.704.1663878096688;
        Thu, 22 Sep 2022 13:21:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id bs13-20020a05620a470d00b006b5d9a1d326sm4674707qkb.83.2022.09.22.13.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 13:21:36 -0700 (PDT)
Message-ID: <da50974ca9a542b7a7c1596132ddffba6bb9d7af.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 22 Sep 2022 22:21:33 +0200
In-Reply-To: <791065bb090ffe08f170e91bd7fabe0a5660ab53.camel@redhat.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
         <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
         <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com>
         <d347ab0f1a1aaf370d7d2908122bd886c02ec983.camel@redhat.com>
         <CAKgT0Uf-fDHD_g75PSO591WVHdtHuUJ+L=aWBWoiM3vHyzxRtw@mail.gmail.com>
         <791065bb090ffe08f170e91bd7fabe0a5660ab53.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-22 at 18:29 +0200, Paolo Abeni wrote:
> On Wed, 2022-09-21 at 14:44 -0700, Alexander Duyck wrote:
> > On Wed, Sep 21, 2022 at 1:52 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > In that case we will still duplicate a bit of code  -
> > > this_cpu_ptr(&napi_alloc_cache) on both branches. gcc 11.3.1 here says
> > > that the generated code is smaller without this change.
> > 
> > Why do you need to duplicate it? 
> 
> The goal was using a single local variable to track the napi cache and
> the memory info. I thought ("was sure") that keeping two separate
> variables ('nc' and 'page_frag' instead of 'nc' and 'pfmemalloc') would
> produce the same amount of code. gcc says I'm wrong and you are right
> ;)
> 
> I'll use that in v2, thanks!

I'm sorry for being so noisy lately. I've to take back the above.
Before I measured the code size with for debug builds. With non debug
build the above schema does not reduce the instructions number.

I'll share the code after some more testing.

Cheers,

Paolo

