Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D315A3A8A43
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhFOUm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 16:42:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:45067 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOUmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 16:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1623789610;
        bh=EAElDhEvE0npNuUB64RNjL9W4eVHMaspYGhc4IBGHtE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ShNLsT9HJ4XPopUGPBM5HabevtWBvmoIb2QM066mqsF6zdQ9NPy26epXmS/DxCvWX
         uQ0EEINGtfyoarpbQwq1xQHZBVbirXXyQWRCWN23ukPWg6IDhrtA34PPTRhysRIL5v
         DOuMNbgaPtWwgK2nWt0RmCT+iNU9p9ZuoTO+ODVo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [89.247.255.103] ([89.247.255.103]) by web-mail.gmx.net
 (3c-app-gmx-bap35.server.lan [172.19.172.105]) (via HTTP); Tue, 15 Jun 2021
 22:40:10 +0200
MIME-Version: 1.0
Message-ID: <trinity-b69ee8f7-2a39-428c-898e-1b55a48ff9cf-1623789610211@3c-app-gmx-bap35>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     socketcan@hartkopp.net, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 15 Jun 2021 22:40:10 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210614072058.syvgyz7lexexsvxp@pengutronix.de>
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
 <20210614072058.syvgyz7lexexsvxp@pengutronix.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:kvJqYaTAwZQ+GOMSQVKgKv/t7zSGTtdGay5yeLq9xABaKwJDp0n2HZeGrGw2va48DvQxl
 lFJDin1/zTEaLjm7eZOVphD+ldAjvSRU4Sqz8dvnM80KxJSCXuSnWyG5zQWa1Y/9fjHNf99vT9jn
 hDDubJ0TMK3NSuRNu96A5LblbcfNX8paZ4gdRfWCNqsx5aDr0jfMrLK4dpS/k4St3X59tKySdGBh
 8eRojiSMsQOuZUXiuwAwtH7d2YaqYWZNhhMU0iiC71pTHxTiRtIVeK3TDie5hh67u8BVFZkMz3I7
 1w=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nJBizfb9i/c=:MDd5F9BMcIiHIgJd4gJghe
 uK/5GFLIq79D6dE6EhdWKYFqq2l/O5F1AqH+OtDEwzUw1f/SC8d1EdcQexN2fHNNf32JAqHQv
 lFI6pEy2TeOBYwFckY1VlRWJuhHcHbJi1RECnTsxDklKqrWtBh3tbTl7IoN5JZxuHGduH9ifi
 wa4gIInxueikBdkMYpFBgmFbSVAKkJfwnE1dup4DrwBKfHuvsoz5/gDqdSq8zmq9++wTthClk
 MtarIy9HhXLQ0I5bZ2fflDhYgQAPtCrQJXKvtbvHjf4zOO7yb5KXM/rw5UhwoSrKLLJ2Bnoat
 J9OodZNNCiuCImOim9D8AKs4xG1mViAGQ7CnpE2qUkKhJ82R6Uu7kZj/sAsDAX2oDLmOEJAxs
 Hy/XfaOiUQBVj+VdjCrFOqd83Z7Sn2ta64V9a7bGdyaIanoKpFHPq+MzvhmyaLElgMgXCaUiX
 j3LP5oaU7+zUtXez+MnGq0EbPPq8/GJnHX2SI0LM520qfOUPR1ez8ic849JLXHBd1geVV8oY+
 JdVx/w/AIQbVYxp6vc1IoGNb/IdEvOY4MJxytFSDG1eaO+J4lG3HUbZwQCFpffbtaEemSsEdo
 QJ3hFdL8MiudzB897eTZwbpDIpZPjvYHgT0kR2EvUa3dV0fgVZc1AtmdnWIS9DpO6Y3vUc4iK
 njGmEksg+Zs+DiOGRmhFWbtb0k0+Xgtq1En8RHr9Vwm4f34bL4Nsc5yM7uQskoTFu8iqT3uij
 +Uc1+LDO2y4U0z5fBZ9wSjuFsV0V7thyKAmDsxtWy84+Iy/7i0C9EiZmwopH827Uij334e+/L
 G71s/mD63gd76tuwHj/ATlycFvW2g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue has been assigned CVE-2021-34693 and the announcement on
oss-security is available in the link below.
https://www.openwall.com/lists/oss-security/2021/06/15/1

Norbert
