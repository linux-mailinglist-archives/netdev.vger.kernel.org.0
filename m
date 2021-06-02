Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF623990FC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhFBRAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhFBRAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 13:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3342A61C4F;
        Wed,  2 Jun 2021 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622653105;
        bh=PgL1vLDcibZvdbItP85eoqsZFX82Ivm26/Ytc8nZqVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=toRQYmq2gKGeGv8C8Fh3paqv9kOzU6LgLCFdILu4tjqxzXhA2V8GUpV61+yic0PF2
         T0zZQNf5uOxgo22opxfIzZqF1sIvTieVFESGY4dm5TnV0nn35sWT7aUNyybLxtJ0i5
         RRNvbkAzr4mQdTcr6HdG5BxCdcRWtwfoRDdYc+66P3D/m9QyUfTlMUd8XKrr55DkDI
         s/BHuBy1AgPJzi0CjcHL9AUlIkUgs6WnE+eNU4VQjMknHfAFoj2xwggd/AB7UrISjv
         WRXrYoiy/iJ0SHheQchwO6KoXnBE4pWOooZf0lWskYIezB4iaZOAOD5ongDaVy0S7Y
         BncMGMqWThw6w==
Date:   Wed, 2 Jun 2021 09:58:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <dlinkin@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>
Subject: Re: [PATCH RESEND net-next v3 00/18] devlink: rate objects API
Message-ID: <20210602095824.1d3ce0c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 15:17:13 +0300 dlinkin@nvidia.com wrote:
> From: Dmytro Linkin <dlinkin@nvidia.com>
> 
> Resending without RFC.
> 
> Currently kernel provides a way to change tx rate of single VF in
> switchdev mode via tc-police action. When lots of VFs are configured
> management of theirs rates becomes non-trivial task and some grouping
> mechanism is required. Implementing such grouping in tc-police will bring
> flow related limitations and unwanted complications, like:
> - tc-police is a policer and there is a user request for a traffic
>   shaper, so shared tc-police action is not suitable;
> - flows requires net device to be placed on, means "groups" wouldn't
>   have net device instance itself. Taking into the account previous
>   point was reviewed a sollution, when representor have a policer and
>   the driver use a shaper if qdisc contains group of VFs - such approach
>   ugly, compilated and misleading;
> - TC is ingress only, while configuring "other" side of the wire looks
>   more like a "real" picture where shaping is outside of the steering
>   world, similar to "ip link" command;
> 
> According to that devlink is the most appropriate place.

I don't think you researched TC well enough. But whatever, I'm tired 
of being the only one who pushes back given I neither work on or use
any of these features.

You need to provide a real implementation for this new uAPI, tho.
netdevsim won't cut it.
