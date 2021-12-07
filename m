Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE4746C01F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbhLGQBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:01:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46814 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239332AbhLGQBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:01:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50485CE1B7E;
        Tue,  7 Dec 2021 15:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268D8C341C1;
        Tue,  7 Dec 2021 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638892689;
        bh=2ryqHWEwM1f2X3lf6mB2G1XPeM+9sGpcyawrhEeaL6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RzEXQD5lHf9f0BLEtHnIx0PuMXQtITX/Q+hPmdI+C0iiSlC7YS+rR8puoUr5b3EVp
         d+nOEjcF5Tvk5lTBkyKgSR74Au4hVX4yB7zf9Oczz9UwvjHxveqUzKv/XvOawNheqj
         tiG2OOGpG53zlvjJLbvUQuL2qxG0sDN6WNnrbNK0Q3Fm/4knD2ba5CKmFAFvhMuajS
         CaQqW7iIZob7ILJLwyZhH5b31nk3jFWTYlC0WzymECVQd1LcV7Wo9+3uV4UEUNeoZM
         SAOf+II9IDhdEkKafJ4yCpZyZHvCLrwzSw1//8COdo5PXsIBZsdjrahUx+7wUDh7wh
         S961JTDhJTUlw==
Date:   Tue, 7 Dec 2021 07:58:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        David Ahern <dsahern@gmail.com>
Cc:     "Zhou, Jie2X" <jie2x.zhou@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>, lkp <lkp@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>,
        "Li, ZhijianX" <zhijianx.li@intel.com>
Subject: Re: selftests/net/fcnal-test.sh: ipv6_ping test failed
Message-ID: <20211207075808.456e5b4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR11MB4792DFC72C7F7489F22B26E5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <PH0PR11MB4792DFC72C7F7489F22B26E5C56E9@PH0PR11MB4792.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding David and Zhijian.

On Tue, 7 Dec 2021 07:07:40 +0000 Zhou, Jie2X wrote:
> hi,
> 
>   I test ipv6_ping by "./fcnal-test.sh -v -t ipv6_ping".
>   There are two tests failed.
> 
>    TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
>    TEST: ping out, VRF bind - multicast IP                                       [FAIL]
> 
>    While in fcnal-test.sh the expected command result is 2, the result is 1, so the test failed.
>    ipv6_ping_vrf()
>    {
>     ......
>         for a in ${NSB_LINKIP6}%${VRF} ${MCAST}%${VRF}
>         do
>                 log_start
>                 show_hint "Fails since VRF device does not support linklocal or multicast"
>                 run_cmd ${ping6} -c1 -w1 ${a}
>                 log_test_addr ${a} $? 2 "ping out, VRF bind"
>         done
> 
>     The ipv6_ping test output is attached.
>     Did I set something wrong result that these tests failed?
> 
> best regards,
