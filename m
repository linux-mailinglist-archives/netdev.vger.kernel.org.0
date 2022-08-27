Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A83C5A32F2
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345196AbiH0AG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345254AbiH0AGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:06:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC490EA337
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 879C5B83352
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC7C433D6;
        Sat, 27 Aug 2022 00:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661558793;
        bh=CSdokSMyRLqfmpw5XBOpuGsfhJw4daeTnTVQWQ5+NkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lWoKV09oSJN6zB8pbRT2O7pzVP0d9D6jms2iXs17KbIYrdexW1zhRZkesij55XJYn
         FsQkbXPXnR07zrspYaMfdFZeq/Rgi6auFM3M93viMFlzi6bU/e6sEZNbOL5Sh7ntPu
         BPrKIH/QnGnPwQiNHyCZ2nTuOtpXQxEMZyj8G00PF9dC5XZfPnY6DGBMONXZROubVM
         h49m9IY7uBv0mO8IGGjJmnfk31fp1npPk4dLdp7+GI80CV4/wb/5vt0flB0fCaH4+b
         X2ZlYjqZPUJT7/CkIgOHUFhTU1/s3cBxNuz6uTJGnAjWN0KP7m6GdfGBFMF+0O0OG9
         ci02UEuEesEqQ==
Date:   Fri, 26 Aug 2022 17:06:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
Message-ID: <20220826170632.4c975f21@kernel.org>
In-Reply-To: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 21:34:47 +0200 (CEST) Thorsten Glaser wrote:
> Hi,
>=20
> is it possible for qdiscs to communicate with each other?
>=20
> For example, if I have a normal egress qdisc and an ingress
> qdisc, how could I =E2=80=9Cshare=E2=80=9D configuration values so that e=
.g.
> a =E2=80=9Ctc change=E2=80=9D can affect both in one run?
>=20
> Use case: we have a normal egress qdisc that does a lot of
> things. Now we add artificial latency, and we need to do that
> on ingress as well, for symmetry, obviously, so I=E2=80=99ll write a
> small qdisc that does just that for ingress. But we=E2=80=99re already
> firing a =E2=80=9Ctc change=E2=80=9D to the egress qdisc every few ms or =
so,
> and I don=E2=80=99t want to double that overhead.

How do you add latency on ingress? =F0=9F=A4=94=20
The ingress qdisc is just a stub to hook classifiers/actions.=20
