Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F77473A01
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbhLNBBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhLNBBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:01:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251D8C061574;
        Mon, 13 Dec 2021 17:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E07DAB81747;
        Tue, 14 Dec 2021 01:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FA5C34603;
        Tue, 14 Dec 2021 01:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639443707;
        bh=J2YzhteudgGKBjSMwjNSaligcXYNTl4flQOqaYSG+rQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/7cGhJC2LaC/tuCM7g0hjQGmKHW5fpDXY17KTQQnlEp7YtL6IwtgHjd9WDYFtLYC
         w/Ibr5UvtKpT8Jzn1Xh5lpKvhAz/ehMC06y9/MDj/YkXi7anX3VNBAWRTUlHwfcoU1
         pK3nlAEH94d24ddMusUrhsZNDBTGpAlVABV1M0BPMF6Yw37XtUXW7tawQYHa+3yVuc
         2OymEi4yaXpUPjJXjMoFWxx3YCJ46Supu/kMt4rCNDeZD6OpMna33qDpPdhnVaNv9z
         fCTzAzcwziaRfuEWs5linuu0JRwkSRrTDCADO43wjeVB/kJsBBgnDAQ3QQJDTLk0Ul
         eVogq7Nm1oSag==
Date:   Mon, 13 Dec 2021 17:01:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Shay Drory <shayd@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Message-ID: <20211213170146.24676fa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160c22e7ee745e44b4f37d53003205d8f63b8016.camel@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
        <160c22e7ee745e44b4f37d53003205d8f63b8016.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 23:06:26 +0000 Saeed Mahameed wrote:
> On Wed, 2021-12-08 at 16:17 +0200, Shay Drory wrote:
> > This series provides knobs which will enable users to
> > minimize memory consumption of mlx5 Functions (PF/VF/SF).
> > mlx5 exposes two new generic devlink params for EQ size
> > configuration and uses devlink generic param max_macs.
> >=20
> > Patches summary:
> > =C2=A0- Patch-1 Introduce log_max_current_uc_list_wr_supported bit=20
> > =C2=A0- Patches-2-3 Provides I/O EQ size param which enables to save
> > =C2=A0=C2=A0 up to 128KB.
> > =C2=A0- Patches-4-5 Provides event EQ size param which enables to save
> > =C2=A0=C2=A0 up to 512KB.
> > =C2=A0- Patch-6 Clarify max_macs param.
> > =C2=A0- Patch-7 Provides max_macs param which enables to save up to 70KB
> >=20
> > In total, this series can save up to 700KB per Function.
>=20
> Jakub are ok with this version ?
> I would like to take it to my trees.

Yup, go for it. Sorry I didn't ack - I was going to apply it today but
Dave reminded me that you probably want to take it thru your tree.
