Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6164BD9E2
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442752AbfIYIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 04:30:00 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:36941 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442734AbfIYI37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 04:29:59 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f04a7c82;
        Wed, 25 Sep 2019 07:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:content-type; s=mail; bh=F1x6e+
        cCGG/zD2EMOllsVE7y05c=; b=uFLcSUjcfehMSQaYeALWaBn4jNxO+wgx8fX7h0
        FcPxVROU1FWNhQqgVP3Y2Wzpdsk3riWgZHyoVC5J5TWJfGEX7V1/FcrBhjxsETS/
        TF2T8T/lcbgsmxElLSK6D1ULFg2ggjEm9uzcdWFVIBY1xrn2QptvD1H0PNVKOjeZ
        l1G93XobpNjHPRUR1e7jalUVGKpSQH6nxMjAnvLz6Tulr6hbTFxsMXdGTBVUh8/J
        dzSN9eQ2s2WbG4NQU8wn9F+uPVT74v5kFhPhZ3yOTYvyZH/qX2dvBTrlu6+99GLw
        ZDuGwpmEo309sBG+lhwVd1cRv0/HgTP+hK46WgzDst/3yS+w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a9f835e9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 25 Sep 2019 07:44:14 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id k20so4168533oih.3;
        Wed, 25 Sep 2019 01:29:57 -0700 (PDT)
X-Gm-Message-State: APjAAAX5vOoLino9OV/hOQ10LIPZ8F/g9SVMMi8+J7Hfs6EuUuudnsev
        69dVWixZoM7BtkmESZgLbxOdU+ZBCGIsNYw5Mns=
X-Google-Smtp-Source: APXvYqwNXLHiOGCKCubwzVxRj/ec4LjQJFZ7Aw+gylPjxUUmM/jS8eL6FGpbNGuX9OzHxhRru7lSKTbuxmkXFmEDZYQ=
X-Received: by 2002:aca:f555:: with SMTP id t82mr3519613oih.66.1569400196781;
 Wed, 25 Sep 2019 01:29:56 -0700 (PDT)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 25 Sep 2019 10:29:45 +0200
X-Gmail-Original-Message-ID: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
Message-ID: <CAHmME9pmfZAp5zd9BDLFc2fWUhtzZcjYZc2atTPTyNFFmEdHLg@mail.gmail.com>
Subject: WireGuard to port to existing Crypto API
To:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

I'm at the Kernel Recipes conference now and got a chance to talk with
DaveM a bit about WireGuard upstreaming. His viewpoint has recently
solidified: in order to go upstream, WireGuard must port to the
existing crypto API, and handle the Zinc project separately. As DaveM
is the upstream network tree maintainer, his opinion is quite
instructive.

I've long resisted the idea of porting to the existing crypto API,
because I think there are serious problems with it, in terms of
primitives, API, performance, and overall safety. I didn't want to
ship WireGuard in a form that I thought was sub-optimal from a
security perspective, since WireGuard is a security-focused project.

But it seems like with or without us, WireGuard will get ported to the
existing crypto API. So it's probably better that we just fully
embrace it, and afterwards work evolutionarily to get Zinc into Linux
piecemeal. I've ported WireGuard already several times as a PoC to the
API and have a decent idea of the ways it can go wrong and generally
how to do it in the least-bad way.

I realize this kind of compromise might come as a disappointment for
some folks. But it's probably better that as a project we remain
intimately involved with our Linux kernel users and the security of
the implementation, rather than slinking away in protest because we
couldn't get it all in at once. So we'll work with upstream, port to
the crypto API, and get the process moving again. We'll pick up the
Zinc work after that's done.

I also understand there might be interested folks out there who enjoy
working with the crypto API quite a bit and would be happy to work on
the WireGuard port. Please do get in touch if you'd like to
collaborate.

Jason
