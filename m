Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEDB60849E
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJVFgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJVFgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:36:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B0F28DC1E;
        Fri, 21 Oct 2022 22:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1950160A6A;
        Sat, 22 Oct 2022 05:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3312EC433D7;
        Sat, 22 Oct 2022 05:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666416973;
        bh=azzTvMYzLDNzfzEAHCDfv8mwDjw2ToLglxQlH51QNz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MnieiHnQw6AWKIhPC5P4jbFs6Y2BdojTjGMgIRniNz2TrzzBJn1IqK9L0qFWwVOdU
         ZV6V8nm2VvVbJEWgUF9KUgY2h0fiQLzDd/lP1bXLZCjAz/9rfhK4tlSRoWWAx6/meJ
         wX7TEEqJbtCP4RZTLjQ3WVd7aBx+UVu+9QPVrQRAtU51L7UPVbmiRqZjGb4Z/sP9OJ
         P/vSeeJJUEfTxIHB0VYcdVLtt2SV+v5dpTA3+AUB543BGPcbqdaja0BzNMNDFVAmE4
         8R0JBHAiNx0S/aHVwTg29WK3bmq/JugH2wSMQrkJe7gPwKdunuWKcSb5ujyFh9zggh
         EKj5isyxXI5CA==
Date:   Fri, 21 Oct 2022 22:36:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221021223612.42ba3122@kernel.org>
In-Reply-To: <Y1MQVbq2rjH/zPi2@krava>
References: <20221004072522.319cd826@kernel.org>
        <Yz1SSlzZQhVtl1oS@krava>
        <20221005084442.48cb27f1@kernel.org>
        <20221005091801.38cc8732@kernel.org>
        <Yz3kHX4hh8soRjGE@krava>
        <20221013080517.621b8d83@kernel.org>
        <Y0iNVwxTJmrddRuv@krava>
        <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
        <Y0kF/radV0cg4JYk@krava>
        <CAEf4BzZm2ViaHKiR+4pmWj6yzcPy23q-g_e+cJ90sXuDzkLmSw@mail.gmail.com>
        <Y1MQVbq2rjH/zPi2@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 23:34:13 +0200 Jiri Olsa wrote:
> > You are right, they should be identical once PTR is deduplicated
> > properly. Sorry, was too quick to jump to conclusions. I was thinking
> > about situations explained by Alan.
> > 
> > So, is this still an issue or this was fixed by [0]?
> > 
> >   [0] https://lore.kernel.org/bpf/1666364523-9648-1-git-send-email-alan.maguire@oracle.com/  
> 
> yes, it seems to be fixed by that
> 
> Jakub,
> could you check with pahole fix [1]?

If you mean the warning from the subject then those do seem to be gone.
But if I'm completely honest I don't remember how I triggered them in
the first place :S There weren't there on every build for me.

The objtool warning is still here:

$ make PAHOLE=~/pahole O=build_allmodconfig/ -j 60 >/tmp/stdout 2>/tmp/stderr; \
    cat /tmp/stderr 

vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0 
vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
