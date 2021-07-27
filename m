Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DCB3D7428
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbhG0LQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236212AbhG0LQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:16:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 097D6619E3;
        Tue, 27 Jul 2021 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627384604;
        bh=QvxPwrmw4cTJzKKJ7z8fgzFG9vSR9Cf+RBe2kFE4Mrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JhjtWUA5BgLxsdZbwnzGkM6OTQkbsJsaVgRG7g9ceshQucvLbFlUs3aYeMeqqZTbI
         sghp2udtdA8GFvu365VVCAVauhA7az/oZXMQIYKtcN4NAoSQ+1C1FBaeuM3XG6CRMr
         eEZ2JzQENAioae1WEmj7n6g0SyBZdJF0rF1TNAQOq/boKJdJHurIqo2HD/NOtSjkv/
         WLGQe3+OHEFZYvhQVHGppt30MIzsnQAbf2jMUrZFWUxGBOs6MV4tJ4T5lQDV9wACyP
         1Y4RVF5J4L2Hg5qVIjRFvNk9Ca6/I9rkmFTeqNzG+bjhAmsNaJU9yTDSVpsh6b5ODg
         Z/HTfGc9OIFYw==
Date:   Tue, 27 Jul 2021 14:16:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: kill IPA_VALIDATION
Message-ID: <YP/rFwvIHOvIwMNO@unreal>
References: <20210726174010.396765-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 12:40:06PM -0500, Alex Elder wrote:
> A few months ago I proposed cleaning up some code that validates
> certain things conditionally, arguing that doing so once is enough,
> thus doing so always should not be necessary.
>   https://lore.kernel.org/netdev/20210320141729.1956732-1-elder@linaro.org/
> Leon Romanovsky felt strongly that this was a mistake, and in the
> end I agreed to change my plans.

<...>

> The second patch fixes a bug that wasn't normally exposed because of
> the conditional compilation (a reason Leon was right about this).

Thanks Alex,

If you want another anti pattern that is very popular in netdev, the following pattern is
wrong by definition :):
if (WARN_ON(...))
  return ...

The WARN_*() macros are intended catch impossible flows, something that
shouldn't exist. The idea that printed stack to dmesg and return to the
caller will fix the situation is a very naive one. That stack already
says that something very wrong in the system.

If such flow can be valid use "if(...) return ..", if not use plain
WARN_ON(...).

Thanks
