Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA5492BE6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiARRHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 12:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238016AbiARRHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 12:07:44 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3202EC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 09:07:43 -0800 (PST)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 6C07A2E043A;
        Tue, 18 Jan 2022 20:07:41 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id UgYMBDR8Zo-7eLieB44;
        Tue, 18 Jan 2022 20:07:41 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1642525661; bh=T8Ih0wt6Pre+LiP6YMgWpa+UU62/wFtvKn/w1ngrPk8=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=FzlojmIYqHMtKK/VYuLWnHsa09aqa79cPjuqMx4kIkxyduYv4UoHt3L1oTKVa1ZJ9
         Adu9t3srroFwGmHBayHIgJV1+BR6wwHnlE8IBsvN6M8ciU+Rxawh3Iq2jFgqlLI/AI
         QTQGg9IKoTpOsVCtiyuHbrLqU0ziMo7Yh6cdGH7s=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8118::1:1d])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id vwjLJTju2C-7ePuqIDD;
        Tue, 18 Jan 2022 20:07:40 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20220118090453.3345919d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Tue, 18 Jan 2022 20:07:40 +0300
Cc:     Martin KaFai Lau <kafai@fb.com>, Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <26CE358E-1A2F-4971-B455-9100142830BE@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <20211103204607.21491-1-hmukos@yandex-team.ru>
 <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
 <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
 <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0F05155C-ED5A-4FC0-8068-B7A1738B5735@yandex-team.ru>
 <20220118090453.3345919d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 18, 2022, at 20:04, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 18 Jan 2022 19:49:49 +0300 Akhmat Karakotov wrote:
>> On Jan 18, 2022, at 18:57, Jakub Kicinski <kuba@kernel.org> wrote:
>>>=20
>>> On Mon, 17 Jan 2022 18:26:45 +0300 Akhmat Karakotov wrote: =20
>>>> We got the patch acked couple of weeks ago, please let us know what
>>>> further steps are required before merge. =20
>>>=20
>>> Did you post a v4 addressing Yuchung's request? =20
>>=20
>> I thought that Yuchung suggested to make a separate refactor patch?
>=20
> Unclear whether separate patch implies separate "series" there.
>=20
>>> but that can be done by a later refactor patch =20
>>=20
>> But if necessary I will integrate those changes in this patch with =
v4.
>=20
> Right, net-next is closed, anyway, v4 as a 2-patch mini-series may be
> the best way.

Why separate then if the second patch is just a refactor? Wouldn't =
single patch be simpler and better?=
