Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FA7588FF6
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbiHCQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbiHCQBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:01:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC18B48C97;
        Wed,  3 Aug 2022 09:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78064B82306;
        Wed,  3 Aug 2022 16:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EB1C433D7;
        Wed,  3 Aug 2022 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659542470;
        bh=ag/lSTQWRd8gqBoVPmhF9Le1IGQ4IHOAtatLaz5Oc50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5xyF8osvAl4j2QkDFLrHszV+msLoA2Y7AIEdlCUxic278wSuJnZ6TsijTh3Tjkg2
         wY4RyDxIqyTqFrfrXXSJmoNQPwWiTGrLW97FB/PaDHFHhhIi+p0/sApQBy+8F+NKCc
         XbWOQtcVGfw7xmOYZ9TNl8eCbuJLq6aOHiq0LmKuXVpiVVI8SK3vXmON+kxgZVnRDY
         TKf+FZSTvUf4TMXMn1Aa17Aeakz3Nb7Ri9piwSmaiO36Pdp/u+8wazZWXyMRV9Vono
         NeU8cNRYBt9emO+NtYyKlvLCuCchGmgKEkf+58AhXU6W37nlDO+Myp82lvPEwDDBjX
         eVBiXkGRfMUhA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 593C240736; Wed,  3 Aug 2022 13:01:07 -0300 (-03)
Date:   Wed, 3 Aug 2022 13:01:07 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        =?utf-8?B?6LCt5qKT54WK?= <tanzixuan.me@gmail.com>,
        Zixuan Tan <tanzixuangg@gmail.com>, terrelln@fb.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
Message-ID: <Yuqbw8rTWLL+njpc@kernel.org>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava>
 <CABwm_eT_LE6VbLMgT31yqW=tc_obLP=6E0jnMqVn1sMdWrVVNw@mail.gmail.com>
 <Yrqcpr7ICzpsoGrc@krava>
 <YufUAiLqKiuwdvcP@krava>
 <YuloQYU72pe4p3eK@kernel.org>
 <YuokoBdtJ2Jp1R25@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YuokoBdtJ2Jp1R25@krava>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Aug 03, 2022 at 09:32:48AM +0200, Jiri Olsa escreveu:
> On Tue, Aug 02, 2022 at 03:09:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Aug 01, 2022 at 03:24:18PM +0200, Jiri Olsa escreveu:
> > > On Tue, Jun 28, 2022 at 08:16:06AM +0200, Jiri Olsa wrote:
> > > > On Mon, Jun 27, 2022 at 11:08:34AM +0800, 谭梓煊 wrote:
> > > > > #ifdef HAVE_LIBCRYPTO                <-- but check this, it's always false

> > > > nice :)

> > > > > #define BUILD_ID_MD5
> > > > > #undef BUILD_ID_SHA /* does not seem to work well when linked with Java */
> > > > > #undef BUILD_ID_URANDOM /* different uuid for each run */

> > > > > #ifdef BUILD_ID_SHA
> > > > > #include <openssl/sha.h>
> > > > > #endif

> > > > > #ifdef BUILD_ID_MD5
> > > > > #include <openssl/md5.h>
> > > > > #endif
> > > > > #endif                               <-- this block will be skipped
> > > > > ```

> > > > > Maybe we should fix this, to really make use of libcrypto if it is available?

> > > > yea, I think that was the original idea, let's keep the variable with
> > > > SUPPORT suffix and use the -Wdeprecated-declarations for genelf.c
> > > > 
> > > > full fix would be to detect the new API and use it when it's available but..
> > > > given that the check was false at least since 2016, perhaps we could remove
> > > > that code? ;-) Stephane?
> > > 
> > > ping
> > 
> > So, we should start with 谭梓煊 patch, then fix that ifdef and go on
> > from there?
> 
> yes, I thought we could remove that, but there's no reply from
> Stephane so let's fix that

Yeah, I did it and it seems to build, so lets ship it :-)

- Arnaldo
