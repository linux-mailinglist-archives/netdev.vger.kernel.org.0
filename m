Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B0B486302
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbiAFKhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiAFKhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:37:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97723C061245;
        Thu,  6 Jan 2022 02:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E1A5B82057;
        Thu,  6 Jan 2022 10:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05247C36AE5;
        Thu,  6 Jan 2022 10:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641465448;
        bh=X0wz0lYz05U9K22FsPT6MUcN3arQdAhXiAZ56bH2CSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gt95TYUPkA4UQBChqQPMIliP5XM4d7x/yUG6SGtPBMp4Z0Bryje/FeGy/dm+CcPEO
         vg4JSvGoA7Sd429ktTkEARmpS6XwGN5FN86/mH1C2MB+SuiTC48uauQObpOJsWY3lQ
         KrWsD372kF37sEKjLYMCho/ordJi6O95nP0Xvey0=
Date:   Thu, 6 Jan 2022 11:37:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: txtimestamp.c:164:29: warning: format '0' expects argument of
 type 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
 int'} [-Wformat=]
Message-ID: <YdbGZiKKdVgh8A4i@kroah.com>
References: <CA+G9fYtaoxVF-bL40kt=FKcjjaLUnS+h8hNf=wQv_dKKWn_MNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtaoxVF-bL40kt=FKcjjaLUnS+h8hNf=wQv_dKKWn_MNQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 03:39:09PM +0530, Naresh Kamboju wrote:
> While building selftests the following warnings were noticed for arm
> architecture on Linux stable v5.15.13 kernel and also on Linus's tree.
> 
> arm-linux-gnueabihf-gcc -Wall -Wl,--no-as-needed -O2 -g
> -I../../../../usr/include/    txtimestamp.c  -o
> /home/tuxbuild/.cache/tuxmake/builds/current/kselftest/net/txtimestamp
> txtimestamp.c: In function 'validate_timestamp':
> txtimestamp.c:164:29: warning: format '0' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
> int'} [-Wformat=]
>   164 |   fprintf(stderr, "ERROR: 0 us expected between 0 and 0\n",
>       |                           ~~^
>       |                             |
>       |                             long unsigned int
>       |                           0
>   165 |     cur64 - start64, min_delay, max_delay);
>       |     ~~~~~~~~~~~~~~~
>       |           |
>       |           int64_t {aka long long int}
> txtimestamp.c: In function '__print_ts_delta_formatted':
> txtimestamp.c:173:22: warning: format '0' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
> int'} [-Wformat=]
>   173 |   fprintf(stderr, "0 ns", ts_delta);
>       |                    ~~^      ~~~~~~~~
>       |                      |      |
>       |                      |      int64_t {aka long long int}
>       |                      long unsigned int
>       |                    0
> txtimestamp.c:175:22: warning: format '0' expects argument of type
> 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
> int'} [-Wformat=]
>   175 |   fprintf(stderr, "0 us", ts_delta / NSEC_PER_USEC);
>       |                    ~~^
>       |                      |
>       |                      long unsigned int
>       |                    0
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link:
> https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/
> 
> metadata:
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>   git commit: 734eb1fd2073f503f5c6b44f1c0d453ca6986b84
>   git describe: v5.15.13
>   toolchain: gcc-11
>   kernel-config: https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/config
> 
> 
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> 
> tuxmake --runtime podman --target-arch arm --toolchain gcc-10 \
>  --kconfig https://builds.tuxbuild.com/23HFntxpqyCx0RbiuadfGZ36Kym/config \
>   dtbs dtbs-legacy headers kernel kselftest kselftest-merge modules

Same question as before, is this a regression, and if so, any pointers
to a fix?

thanks,

greg k-h
