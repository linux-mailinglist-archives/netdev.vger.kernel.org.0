Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE34A5EB78E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 04:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiI0CWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 22:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiI0CWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 22:22:37 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9785CAA372
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:22:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l65so8430983pfl.8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4u3DF202lZRW0YOPuz3zxb4HZyH1RZ22Lsn3DoaRjKE=;
        b=JeE3U11iOk0uuiMw6Ukzurncyh213htFxID3LVptKPtm/h9sEEUbPC1B0I1b7CEKQS
         GBDx+APAnctavyUBFGJ7JdxI+VOAPGzR7NzYl/4/aLh7ojYEz77xZVqEOnhySNJCVRN9
         tNh0bUJCXbCN0go3kUhaovd3r62M4f10vHeuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4u3DF202lZRW0YOPuz3zxb4HZyH1RZ22Lsn3DoaRjKE=;
        b=Y6mhZ1v2eDCMmpbMTWmd10+aoXL5scfpIxJdrKtfbd7UFhdHytSY52Zf/vOXh3jcsL
         gNazHOKQDG0CPLjos5iR2cXkJou8rnZx4fwUGZPI73A31hGEcXkHbW8LbRpswcYBmPYy
         8zKK7ez3wa6Cn9kDuYXfTqCYoElMbP7Gpln5lt82+L42zgW8t9iMQb4DKRAA+GyvR5t5
         WloCZd/wBq6gOKVFSTLeyaDyBhpiNKyltveHFrYcmdNBqm6NjV6O92ryFPYrAgRH80CL
         ka9AtvhpI7IzJzETJit43/yQ+zyMNJxrl2i21pMkYWqoZ/2zLapvN7L65FaS+Px9RM7G
         2VJQ==
X-Gm-Message-State: ACrzQf2+42OIarhYnGCnkwazOZslrcBA0JanCcb+E8Yj2naZjJGmHQBD
        0ap7ZE55PKKx/eIUjh0xnb48Sw==
X-Google-Smtp-Source: AMsMyM4XIvwSnoqajH9j/PTPQ5c5zIvRChiseWAkIXp1b211TTbIE+Xwz/yjVPu3Po52v+Jq5u9gPQ==
X-Received: by 2002:a65:6e4a:0:b0:438:874c:53fd with SMTP id be10-20020a656e4a000000b00438874c53fdmr23105047pgb.355.1664245352087;
        Mon, 26 Sep 2022 19:22:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id bg8-20020a056a02010800b004348bd693a8sm189625pgb.31.2022.09.26.19.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 19:22:31 -0700 (PDT)
Date:   Mon, 26 Sep 2022 19:22:30 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: ethernet: rmnet: Replace zero-length array
 with DECLARE_FLEX_ARRAY() helper
Message-ID: <202209261920.3A2EA07D4@keescook>
References: <YzIei3tLO1IWtMjs@work>
 <202209261502.7DB9C7119@keescook>
 <20220926172604.71a20b7d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926172604.71a20b7d@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:26:04PM -0700, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 15:02:48 -0700 Kees Cook wrote:
> > On Mon, Sep 26, 2022 at 04:50:03PM -0500, Gustavo A. R. Silva wrote:
> > > Zero-length arrays are deprecated and we are moving towards adopting
> > > C99 flexible-array members, instead. So, replace zero-length arrays
> > > declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> > > helper macro.
> > > 
> > > This helper allows for flexible-array members in unions.
> > > 
> > > Link: https://github.com/KSPP/linux/issues/193
> > > Link: https://github.com/KSPP/linux/issues/221
> > > Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>  
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Not directly related to this patch, but I just had to look at pahole
> output for sk_buff and the struct_group() stuff makes is really painful
> to read :/ Offsets for the members are relative to the "group" and they
> are all repeated.
> 
> Is there any chance you could fix that? Before we sprinkle more pixie
> dust around, perhaps?

Unfortunately I don't see a way around it until we can make changes to
the C language spec, and that's measured in decades. :(

Perhaps we could add some kind of heuristic to pahole to "hide" one of
the internal struct_group() copies, and to hide the empty flexible-array
wrapper structs? (pahole already can't tell the difference between a
0-length array and a flexible-array.) Would that be workable?

-- 
Kees Cook
