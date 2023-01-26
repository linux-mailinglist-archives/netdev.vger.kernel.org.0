Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1D67C4A8
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjAZHIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZHIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:08:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BC64486;
        Wed, 25 Jan 2023 23:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9D36174B;
        Thu, 26 Jan 2023 07:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EC0C433EF;
        Thu, 26 Jan 2023 07:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674716924;
        bh=zVtoTy07dCJlD3zRQjAas3Rea8pNlUGxiolPZFPUWDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfz6ZKttGXRoez5VVQpWTFvQkX2WsDKpnY7orsKGdHLoefP/kGmB2x4cbQzv+Lndh
         L/DRmxyyTWnEKMeQGSuN9GZt/6e2vx9DoJgHbWUYfER5w8HRWEMmJ1odiz2Lr95zGQ
         F1VO/H3glNpPBg/l3YwoZHp9bU7iOsmGF3Yi021/S0FQDwZMQAEDPPh6Gc7YjXiAHJ
         la1zzde3/LS6c+xyE4kPEXToVZ5eCgn2VzbIQ1u8ByA19ZclYeduPB5Rillf+AyHad
         xbeOuQ89T7H83950qfnwrV3fCdTSj1zyPw8Pqmx/Bm9/0aBY1P7Pr9eKqsQUSgm6jn
         nSPFSaP4PG9Qg==
Date:   Wed, 25 Jan 2023 23:08:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests: net: Fix missing nat6to4.o when
 running udpgro_frglist.sh
Message-ID: <20230125230843.6ea157b1@kernel.org>
In-Reply-To: <20230125211350.113855-1-andrei.gherzan@canonical.com>
References: <20230125211350.113855-1-andrei.gherzan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 21:13:49 +0000 Andrei Gherzan wrote:
> The udpgro_frglist.sh uses nat6to4.o which is tested for existence in
> bpf/nat6to4.o (relative to the script). This is where the object is
> compiled. Even so, the script attempts to use it as part of tc with a
> different path (../bpf/nat6to4.o). As a consequence, this fails the script:

Is this a recent regression? Can you add a Fixes tag?

What tree did you base this patch on? Doesn't seem to apply

> Error opening object ../bpf/nat6to4.o: No such file or directory
> Cannot initialize ELF context!
> Unable to load program
> 
> This change refactors these references to use a variable for consistency
> and also reformats two long lines.
> 
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
