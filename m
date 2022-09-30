Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283505F15A8
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiI3WDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiI3WDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:03:31 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738C18F423;
        Fri, 30 Sep 2022 15:03:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id b2so11712632eja.6;
        Fri, 30 Sep 2022 15:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=w1LUNGae1tKCepvb0oOGHF++V1v90y9UBTYHWhUfzAA=;
        b=LNmiO19Lzs2yuUyodCb6bzUXcpgj17k/JJvoy0TdiXj17vhMD8G2vLFLqfPhMnXstL
         Qy9sgewfQhwdYihswkIQX+u2cKirqaZwJ89+MDAJo1h6WusEgGkOKdxaQoD1XPiLdkVr
         lzsphSywwAq7qk40yYdi+6Gn3lkQkckHA+/jLm0mbLdnav90Gij9+A0mwymMuJESrlLb
         0IQUHZ9Vq/OEWHdH4iL0nTgsFTEab+BUrlna+wNyKkl8hQHWnFCxlRgdgODjwVEGav0H
         UGI7Cr6harkCrjfCb6ExBg+cQ5e4Su3d91bqSSc5/KTkM1aTrt1TkyeDzjWo4JT9JeKH
         kFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=w1LUNGae1tKCepvb0oOGHF++V1v90y9UBTYHWhUfzAA=;
        b=DmugNxw87EGX9stIWDMU7769YRaKHqHpk/2Hn+pERs/zeuLPKcWDN5m1dhuKuXVT5F
         x9RFkOEhQHdwJ16UQvF1vVeG/s1Ql6EJ4Abkb3YvoX99Xbcut0HXDuQI3N/kIediaUrH
         SrjiI+EhBRv7J0u9MzyJ88tPCVv0PDLXYA7+tQne2nldrXuc0K66v/Hg18n3ZX1GwGpg
         3L9hmu2lVmvRO/PcGFDNth1+DQPjUGSCje0mj8l7n3Ck4L28uf1oSLSWSRENMA9Q0fOJ
         FTu1ip4VKpAfbL2jMPpmAOWFRzwgDh21nyKWKM1AEYfmd0ZuMQ6p2/m/v8i2AjRKebfi
         nRjQ==
X-Gm-Message-State: ACrzQf3bAtvXsvoFHgCI5SKQAzMsxHpPxM3woGmhCv8h+XlNRwAtGQxN
        JBToqtZMKygCd29RWACDUK0=
X-Google-Smtp-Source: AMsMyM4sdp1MWWaYaJKLOcSXT3SWaRWras92rfoJ6q3CHFksLe+XCS2i9JymJ/lS58ISBcwlLeSJWQ==
X-Received: by 2002:a17:906:dc8b:b0:787:8f41:d231 with SMTP id cs11-20020a170906dc8b00b007878f41d231mr7950685ejc.547.1664575408188;
        Fri, 30 Sep 2022 15:03:28 -0700 (PDT)
Received: from localhost.localdomain (host-79-34-226-61.business.telecomitalia.it. [79.34.226.61])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906298b00b0073de0506745sm1703399eje.197.2022.09.30.15.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 15:03:27 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ira Weiny <ira.weiny@intel.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
Date:   Sat, 01 Oct 2022 00:03:24 +0200
Message-ID: <832292081.0ifERbkFSE@localhost.localdomain>
In-Reply-To: <27280395.gRfpFWEtPU@localhost.localdomain>
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <22aa8568-7f6e-605e-7219-325795b218b7@intel.com> <27280395.gRfpFWEtPU@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, September 23, 2022 5:05:43 PM CEST Fabio M. De Francesco wrote:
> Hi Anirudh,
> 
> On Friday, September 23, 2022 12:38:02 AM CEST Anirudh Venkataramanan wrote:
> > On 9/22/2022 1:58 PM, Alexander Duyck wrote:
> > > On Thu, Sep 22, 2022 at 1:07 PM Anirudh Venkataramanan
> > > <anirudh.venkataramanan@intel.com> wrote:

[snip]

> > Is using page_address() directly beneficial in some way?
> 
> A possible call chain on 32 bits kernels is the following:
> 
> kmap_local_page() ->
>  __kmap_local_page_prot() { 
> 	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && |
> PageHighMem(page))
> 		return page_address(page);
> 
> ....
> }
> 
> How many instructions can you save calling page_address() directly?
> If you don't know, look at the assembly.

I just realized that perhaps you were expecting something like either "No, it 
is not directly beneficial because []" or "Yes, it is directly beneficial 
because []".

Instead, I used a rhetoric question that might not have been so clear as I 
thought. This kind of construct is so largely used in my native language, that 
nobody might misunderstand. I'm not so sure if it is the same in English.

I mean, are those dozen "unnecessary" further assembly instructions too many 
or too few to care about? I _think_ that they are too many.

Therefore, by showing a possible call chain in 32 bits architectures, I 
indirectly responded "no, I can't see any direct benefit", at least because....

1) Whatever the architecture, if pages can't come from Highmem, code always 
ends up calling page_address(). In 32 bits archs they waste precious kernel 
stack space (a scarce resources) only to build two stack frames (one per each 
called functions).

 2) Developers adds further work to the CPU and force the kernel to run 
unnecessary code.

I'll always use page_address() when I can "prove" that the allocation cannot 
come from ZONE_HIGHMEM.

Thanks,

Fabio



