Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4CC242A9D
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgHLNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 09:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgHLNvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 09:51:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D07C061383;
        Wed, 12 Aug 2020 06:51:48 -0700 (PDT)
Date:   Wed, 12 Aug 2020 15:51:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597240305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3kVoq9w4ldqVEl5dCV3XCb9BX8aAVM+5QyIJqtT2VM=;
        b=3CKEgAVL9t6YI4g1rGc76lWIBGe1bW3Q9/dhUqA0Nslk4DPhrSnsvRTRsTU3vWZKP1VvLF
        v06eZigwAm1zj4vY1KJCNmjAIYqzv7Nwnuxs1avq/J3gpmNL6iJrJ5PQFxzCn4VPf3Iw/q
        vShMgA+aTsWWX8JbK/Q7BRJcavUAg8ltqBMfc7e/DBof5U/YPP/XmqMqK92B9gXFFJ5LM3
        N3NN2BXj05RIdYyoc0vaPy97+YiTEs9Ls1mkMWW9jsD0jDG1MEh0/sRKA0c0KJh4DveIlv
        mdXBfnSuWiB16t/O/im8Zv4dIlzMXE8XvCdEmFyECZA0geSU7Qr9FJLlF/JtXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597240305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3kVoq9w4ldqVEl5dCV3XCb9BX8aAVM+5QyIJqtT2VM=;
        b=A87MKS8BjGXHLbw5Coalz+9eS/4MKePNmq2StRQ1Wpm88yPjaCZNCm2EIgL8LEfYS+o1a4
        6MgO/lYYsLitfYCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     David Miller <davem@davemloft.net>, Jiafei.Pan@nxp.com,
        olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] enetc: use napi_schedule to be compatible
 with PREEMPT_RT
Message-ID: <20200812135144.hpsfgxusojdrsewl@linutronix.de>
References: <20200803201009.613147-1-olteanv@gmail.com>
 <20200803201009.613147-2-olteanv@gmail.com>
 <20200803.182145.2300252460016431673.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200803.182145.2300252460016431673.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-03 18:21:45 [-0700], David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> > The driver calls napi_schedule_irqoff() from a context where, in RT,
> > hardirqs are not disabled, since the IRQ handler is force-threaded.
=E2=80=A6
> >=20
> > Signed-off-by: Jiafei Pan <Jiafei.Pan@nxp.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Applied.

Could these two patches be forwarded -stable, please? The changelog
describes this as a problem on PREEMPT_RT but this also happens on !RT
with the `threadirqs' commandline switch.

Sebastian
