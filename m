Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3EC46C69
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfFNWff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:35:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbfFNWff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:35:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D2D514E84BBF;
        Fri, 14 Jun 2019 15:35:34 -0700 (PDT)
Date:   Fri, 14 Jun 2019 15:35:33 -0700 (PDT)
Message-Id: <20190614.153533.2180346521044325296.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org
Subject: Re: [PATCH net-next v3 0/2] net/mlx5: use indirect call wrappers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1560333783.git.pabeni@redhat.com>
References: <cover.1560333783.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 15:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 12 Jun 2019 12:18:34 +0200

> The mlx5_core driver uses several indirect calls in fast-path, some of them
> are invoked on each ingress packet, even for the XDP-only traffic.
> 
> This series leverage the indirect call wrappers infrastructure the avoid
> the expansive RETPOLINE overhead for 2 indirect calls in fast-path.
> 
> Each call is addressed on a different patch, plus we need to introduce a couple
> of additional helpers to cope with the higher number of possible direct-call
> alternatives.
> 
> v2 -> v3:
>  - do not add more INDIRECT_CALL_* macros
>  - use only the direct calls always available regardless of
>    the mlx5 build options in the last patch
> 
> v1 -> v2:
>  - update the direct call list and use a macro to define it,
>    as per Saeed suggestion. An intermediated additional
>    macro is needed to allow arg list expansion
>  - patch 2/3 is unchanged, as the generated code looks better this way than
>    with possible alternative (dropping BP hits)

Applied, thanks.
