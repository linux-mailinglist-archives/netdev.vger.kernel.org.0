Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B156509E0E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388580AbiDUKz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388575AbiDUKzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6099C1572F;
        Thu, 21 Apr 2022 03:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F054161AC7;
        Thu, 21 Apr 2022 10:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C95FC385A7;
        Thu, 21 Apr 2022 10:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650538383;
        bh=2qzjAXyKutw+YwkZ6g2dgQ11DWIpE1kmGQoC2zQjJg0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FlydmZ/lOQzSK/eALsRjEEOKGQXz3T+0ifk4fajVNX3DD4I+/PSFU/ZV7xPhkf84z
         dWeF19SRGNudGlFdQ/97bIrCYKSJcHhbB+IUWUDhirkJA49V0l2QFOXQ0hhYONT0/x
         zovyNSJlwJcQEL+OJBcXmvap180ereAJCukV0qzRs6mqRXwd2H4b+AcdHEF5JGrP+W
         DcLRLzj/jSDX2hKrNXECudeFNxncG58ynpCTTgTx8XKw3k/BEj2c9DOywtl0b3Bgwy
         8e46ldOBqdwMNKuGofDK9PgVEw1sE9zZhWLJmp0YGE35S5T1amcXNFbwW8cgsnQsfW
         zfPw2G0SqQ1SA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CA5662D1D2D; Thu, 21 Apr 2022 12:52:59 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf 00/11] bpf: random unpopular userspace fixes (32
 bit et al)
In-Reply-To: <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
References: <20220421003152.339542-1-alobakin@pm.me>
 <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Apr 2022 12:52:59 +0200
Message-ID: <87r15qhfn8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Again?
>
> -----BEGIN PGP MESSAGE-----
> Version: ProtonMail
>
> wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
> FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW
>
> Sorry I'm tossing the series out of patchwork.

FWIW I'm not seeing this in the version I pulled from Lore. So maybe
it's something ProtonMail does on a per-recipient basis? Still really
weird to do behind the scenes, though... :/

-Toke
