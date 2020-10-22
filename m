Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BEA2956E8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895514AbgJVDn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:43:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441714AbgJVDn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 23:43:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8299E21D6C;
        Thu, 22 Oct 2020 03:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603338209;
        bh=8f6HmpIcRJ3M7KpM+462DX4+WXzKS753bbrgorSvmFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1HbqfSZ/VzNi5dJt/Xa4HV+V5tek16Ggr3WD9/MoX7d1f9WaspcTZtLkwafmYWk96
         CFwxmsYzph85J0NimgonAalLpEp4NXN8AReNo40h7A1H8n/zU7dq38MlaNvFCg0XGm
         2JaLDgAptep24hhImvJ2/bAKjp1hsdvfKwTxzeq8=
Date:   Wed, 21 Oct 2020 20:43:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selftests: mptcp: depends on built-in IPv6
Message-ID: <20201021204321.144e6df4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1d28e7da-3fce-b064-a159-662f53e5a3b@linux.intel.com>
References: <20201021155549.933731-1-matthieu.baerts@tessares.net>
        <1d28e7da-3fce-b064-a159-662f53e5a3b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 17:35:32 -0700 (PDT) Mat Martineau wrote:
> > Recently, CONFIG_MPTCP_IPV6 no longer selects CONFIG_IPV6. As a
> > consequence, if CONFIG_MPTCP_IPV6=y is added to the kconfig, it will no
> > longer ensure CONFIG_IPV6=y. If it is not enabled, CONFIG_MPTCP_IPV6
> > will stay disabled and selftests will fail.
> >
> > We also need CONFIG_IPV6 to be built-in. For more details, please see
> > commit 0ed37ac586c0 ("mptcp: depends on IPV6 but not as a module").
> >
> > Note that 'make kselftest-merge' will take all 'config' files found in
> > 'tools/testsing/selftests'. Because some of them already set
> > CONFIG_IPV6=y, MPTCP selftests were still passing. But they will fail if
> > MPTCP selftests are launched manually after having executed this command
> > to prepare the kernel config:
> >
> >  ./scripts/kconfig/merge_config.sh -m .config \
> >      ./tools/testing/selftests/net/mptcp/config
> >
> > Fixes: 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it")
> > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied, thank you!
