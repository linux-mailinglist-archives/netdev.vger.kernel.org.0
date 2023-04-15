Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C0F6E2E00
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjDOAvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOAvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9931BE6;
        Fri, 14 Apr 2023 17:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0731614E1;
        Sat, 15 Apr 2023 00:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC1FC433D2;
        Sat, 15 Apr 2023 00:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681519901;
        bh=bB2NT69LBZ9BjmwJ8HNoVcuUympJMh5JpNZZaQv1Rk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h7ovqmOjBpQgzV4olEuwILUyBuVA3unecvCVGbvIbNWpTqPUxNCMzTkunwwNa8pes
         uLvAo96zOqp0x1AMVx7kFkdhs86Mh1eMyo8R+hdflknQPjLct7ofThSTFtMO7Oxfd7
         B0t2mHZ0cZ0lGErO7kTX0VWaT9fQSxTzBPuOk43uLQom+IzEXKaVBoA8v9oqx49kM4
         J7DIPx2wh5kwRn5mvCxm1xSnq4+O7w1ERoE9YcxX5ctUkbHTNMkeIGXEST/hDxdLGG
         zfk5gJB5v4hBDOlIrIb9VFv2I7u9yMv2CcTcWgejfTfF9ZvhzwC5E9jNDqcZxY/UW3
         S79Rg+0k5VxFQ==
Date:   Fri, 14 Apr 2023 17:51:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org, sdf@google.com
Subject: Re: [PATCH net-next v4 2/4] net: socket: add sockopts blacklist for
 BPF cgroup hook
Message-ID: <20230414175139.21d284b6@kernel.org>
In-Reply-To: <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
        <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
        <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
        <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 16:38:35 +0200 Aleksandr Mikhalitsyn wrote:
> Sure, I will add next time.
> 
> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> 
> I think it's better to add Stanislav Fomichev to CC.

This should go in separately as a fix, right? Not in a -next series.

Also the whole set as is does not build on top of net-next :(
