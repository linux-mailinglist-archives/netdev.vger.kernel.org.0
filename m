Return-Path: <netdev+bounces-3881-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 105577095D5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED0EF1C211B6
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F26D8839;
	Fri, 19 May 2023 11:03:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D27487;
	Fri, 19 May 2023 11:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA98C433D2;
	Fri, 19 May 2023 11:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684494232;
	bh=hCAAc+TNbuzkt0nWAsdUMnYbobl64u6xrVvPxYHXD6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nV61AYVtM/1pc9o0dc8qmGqQ0EntCR5w5fUA7GKknwh7nBnlh6K1q01En8E2Y1R8M
	 eFwttfEtz7T/tcYVSB8dapyM0mtaenV5UAY5rD0KI7bIESEzA8v5R+uQbNIms5xeOl
	 VkGka5Rolh3+BPmzCIh/poK0u/7oAu7y5vvMnSXL3QjbkHpAVpPAT1eRYa3StLXufi
	 AcB6jNZGGIA5ChTksthScCMvbty0NHWJ0eCAorU0wuClfDEBuIxgsuxY4QypRGUJ+o
	 Q0/GJ56/Q1ik6okcm1nkcSGrHW0J+0c2VfQA+Hlz8GNNyl7Z++mirjEvr/WjhlQ+Mw
	 uGFNjvJ3JuWZA==
Date: Fri, 19 May 2023 13:03:44 +0200
From: Christian Brauner <brauner@kernel.org>
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Luca Boccassi <bluca@debian.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/3] net: core: add getsockopt SO_PEERPIDFD
Message-ID: <20230519-zielbereich-inkompatibel-79e1a910e3f9@brauner>
References: <20230517113351.308771-1-aleksandr.mikhalitsyn@canonical.com>
 <20230517113351.308771-3-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230517113351.308771-3-aleksandr.mikhalitsyn@canonical.com>

On Wed, May 17, 2023 at 01:33:50PM +0200, Alexander Mikhalitsyn wrote:
> Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Luca Boccassi <bluca@debian.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: bpf@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Tested-by: Luca Boccassi <bluca@debian.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
> v5:
> 	- started using (struct proto)->bpf_bypass_getsockopt hook

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

