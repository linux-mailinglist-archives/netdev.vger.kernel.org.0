Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890DE519E1C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348887AbiEDLht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348871AbiEDLhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:37:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821552B1A7;
        Wed,  4 May 2022 04:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3FC960A3D;
        Wed,  4 May 2022 11:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3D7C385A5;
        Wed,  4 May 2022 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651664050;
        bh=B2BOkmQWAewYICCAZqhm4S7YchQqMKeCiQ7EuGLUGeE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=X/fplh0RgU2RQqvSj00dZlcKsfPuFjC8mU9wT/apulBFOYH+I9nHmY2ihFrEcuET0
         gcixXjgWz48w4d6+qM+P5qBKZnerjpIipEoBxNI7EBs8PVleFMrqWoNUrRCkD6awQ9
         2uBYiucUMx8r7oMq+Cw0UKCher8oxJeqMU6VKzzLkuOhiUCxXw/cSJxqXhT27bl4KZ
         sq+sWs8HsfC36DhwPIC/2TpcL8gFxIeBQInWKTdXFtd1DJhD2tSloobTTBaBi6TTsL
         OZjp8dmox3bbYtCGLkPXjx1dM33oO7msqdhsksW5c3b4fGm+c+V8919ck9avGaVOka
         cEPlesZqPZYxA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C45E3464C7; Wed,  4 May 2022 13:34:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
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
In-Reply-To: <20220503211001.160060-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
 <CAADnVQJJiBO5T3dvYaifhu3crmce7CH9b5ioc1u4=Y25SUxVRA@mail.gmail.com>
 <20220503211001.160060-1-alobakin@pm.me>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 May 2022 13:34:07 +0200
Message-ID: <8735hpwmz4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alobakin@pm.me> writes:

> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date: Wed, 20 Apr 2022 17:40:34 -0700
>
>> On Wed, Apr 20, 2022 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> Again?
>>
>> -----BEGIN PGP MESSAGE-----
>> Version: ProtonMail
>>
>> wcFMA165ASBBe6s8AQ/8C9y4TqXgASA5xBT7UIf2GyTQRjKWcy/6kT1dkjkF
>> FldAOhehhgLYjLJzNAIkecOQfz/XNapW3GdrQDq11pq9Bzs1SJJekGXlHVIW
>
> ProtonMail support:
>
> "
> The reason that some of the recipients are receiving PGP-encrypted
> emails is that kernel.org is providing public keys for those
> recipients (ast@kernel.org and toke@kernel.org specifically) via WKD
> (Web Key Directory), and our API automatically encrypts messages
> when a key is served over WKD.
>
> Unfortunately, there is currently no way to disable encryption for
> recipients that server keys over WKD but the recipients should be
> able to decrypt the messages using the secret keys that correspond
> to their public keys provided by kernel.org.
> This is applicable both to messages sent via the ProtonMail web app,
> and messages sent via Bridge app.
>
> We have forwarded your feedback to the appropriate teams, and we
> will see if we can implement a disable encryption option for these
> cases. Unfortunately, we cannot speculate when we might implement
> such an option.
> "
>
> Weeeeeird, it wasn't like that a year ago.

Well, they're also doing something non-standard with their WKD
retrieval, so maybe that changed? GPG itself will refuse to retrieve a
key that doesn't have the email address specified in the key itself:

$ gpg --locate-keys toke@kernel.org
gpg: key 4A55C497F744F705: no valid user IDs
gpg: Total number processed: 1
gpg:           w/o user IDs: 1
gpg: error retrieving 'toke@kernel.org' via WKD: No fingerprint

Given that they do it this way, I suppose this will affect every
@kernel.org address that has a PGP key attached (of which there are
currently 519, according to pgpkeys.git)...

-Toke
