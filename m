Return-Path: <netdev+bounces-4193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7794170B951
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3F9D280ED3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7B3A947;
	Mon, 22 May 2023 09:47:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A119471;
	Mon, 22 May 2023 09:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2BCC433EF;
	Mon, 22 May 2023 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684748835;
	bh=Yf3cTGeDcLfBzTtUWTnOWjllezGokJ4uWqOHgCJzQKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NeYUyiXBhr6SSSQhAeayYBdwbfFiUAWxKBXejeJbZam+6f2AqXqFB4+vOD8eLu9eG
	 OskL5YwSGg1obT+ZUrtPq03ywXLLCqKsZtl+IMEv6ENMNzkRMeva3X4JCZLid/qn5F
	 EB+QY1FR5gIHnZm8rQZA2qz0fOFngCO6Nvi22wcA4OtCupV6iTr0GdgIukyo3ADtWL
	 +laGXYFwxO1Ov4kNJy8Xj1v77YoBt7AR/RxXBSQ9o88SNs5Pue2RUWzdGWhbLtw0qa
	 e3zka0/0RujuSO9909CiEw6Z251/GSNrXZ+Zbj92LnBSg9AkkYEA6+c5rCeM9sRaMj
	 5WGZh6r0OQBBg==
Date: Mon, 22 May 2023 11:47:08 +0200
From: Christian Brauner <brauner@kernel.org>
To: kernel test robot <lkp@intel.com>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	davem@davemloft.net, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230522-sammeln-neumond-e9a8d196056b@brauner>
References: <20230517113351.308771-2-aleksandr.mikhalitsyn@canonical.com>
 <202305202107.BQoPnLYP-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202305202107.BQoPnLYP-lkp@intel.com>

On Sat, May 20, 2023 at 10:11:36PM +0800, kernel test robot wrote:
> Hi Alexander,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on net-next/main]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230517-193620
> base:   net-next/main
> patch link:    https://lore.kernel.org/r/20230517113351.308771-2-aleksandr.mikhalitsyn%40canonical.com
> patch subject: [PATCH net-next v5 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
> config: powerpc-randconfig-s043-20230517
> compiler: powerpc-linux-gcc (GCC) 12.1.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/969a57c99c9d50bfebd0908f5157870b36c271c7
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Alexander-Mikhalitsyn/scm-add-SO_PASSPIDFD-and-SCM_PIDFD/20230517-193620
>         git checkout 969a57c99c9d50bfebd0908f5157870b36c271c7
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202305202107.BQoPnLYP-lkp@intel.com/
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> >> ERROR: modpost: "pidfd_prepare" [net/unix/unix.ko] undefined!

TLI, that AF_UNIX can be a kernel module...
I'm really not excited in exposing pidfd_prepare() to non-core kernel
code. Would it be possible to please simply refuse SO_PEERPIDFD and
SCM_PIDFD if AF_UNIX is compiled as a module? I feel that this must be
super rare because it risks breaking even simplistic userspace.

