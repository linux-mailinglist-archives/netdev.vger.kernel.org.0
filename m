Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77915FF355
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiJNSDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 14:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiJNSDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 14:03:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96561B6C96;
        Fri, 14 Oct 2022 11:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5267AB82356;
        Fri, 14 Oct 2022 18:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B209C433C1;
        Fri, 14 Oct 2022 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665770612;
        bh=161vf/MZ9Uq3Rm1iKnGWQxZPlYkzch68bDKn9ElqWek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEJO7TBTXFVb84YJq4B8bg3pcBpDmPFaxL0rYF/0KgkmFCZBuC4Gc3hRO7qGu27Gn
         W5JOn0WbEzkrTeyQsaLUKUOBmkO9kOVhdj9DGaQ/i5QsAw3Uh2qW9B/a3cA2+1nGLK
         hKJgyv3Pcy2WTFs255fuRKk8132aBj2VOXerxamlWtB6MftmjBvYACjnqDkL0QwkJG
         tmZuUkKHtQKVgi3wBu+MiSL5JGCgevOvnlEzIZSWjT/mJ1pU4LzJWpQOAtZu7xGqo2
         s/mh38esWmQGxSYEjMkUeOCJ1ciuEpUJrr1SXF6TpCl8mLcFsS2dDxaqaA7HOR7yQF
         zIKyw3oCmOz4Q==
Date:   Fri, 14 Oct 2022 11:03:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     guoren@kernel.org, andriy.shevchenko@linux.intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
Message-ID: <20221014110330.044bbbf4@kernel.org>
In-Reply-To: <CAAH8bW_6uT7M_y7GEZSrzo1WJZfZ2j=UeZreXX9yHCEFqXNJzQ@mail.gmail.com>
References: <20221014030459.3272206-1-guoren@kernel.org>
        <20221014030459.3272206-2-guoren@kernel.org>
        <20221013203544.110a143c@kernel.org>
        <20221013203911.2705eccc@kernel.org>
        <Y0jowX4zIZMMVc0H@yury-laptop>
        <20221014090311.392e0546@kernel.org>
        <CAAH8bW_6uT7M_y7GEZSrzo1WJZfZ2j=UeZreXX9yHCEFqXNJzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 09:16:01 -0700 Yury Norov wrote:
> > We will not be merging a refactoring series into net to silence an
> > arguably over-eager warning. We need a minimal fix, Guo Ren's patches
> > seem to miss the mark so I reckon the best use of everyone's time is
> > to just drop the exposing patch and retry in -next =F0=9F=A4=B7 =20
>=20
> If you prefer treating symptoms rather than the disease - I have nothing
> to add.

I don't, but we may consider different things to be "the disease".
Please do not insinuate that I don't care about fixing bugs.

What I can grok from the history and your commit messages is that=20
you want to catch people who pass what you consider invalid inputs=20
to the helpers, but nothing will crash/OOB access here, because=20
the helper double checks that the input is < nr_bits.

So it's a nice cleanup and refactoring, sure, but not an urgent fix
that needs to go to Linus ASAP.

If that's not what you're fixing please explain, I believe I already
asked you to clarify before. And the commit message aren't exactly
informative either.
