Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E81492B84
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbiARQt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346282AbiARQt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:49:56 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D77C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:49:55 -0800 (PST)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 7CE212E19E5;
        Tue, 18 Jan 2022 19:49:51 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id n6EXU7aebi-noLONZtD;
        Tue, 18 Jan 2022 19:49:51 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1642524591; bh=y+XCa6aEV/B7A5+3a7jy8QBmSonwBKrQ9IbTC9xtme0=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=FQRDfDb/zTEQh8YGgQ+t1fujFHDG948G+28W1s27XBVt1bk0PVdjkbdaePCzESmLl
         IHqlOJ2j7+teelMgr/pgescWUJYaninS9wS0ck6iSj3y40gw8f4nrVqs7rx/+QJjHF
         E/5fBcjd9N6ZSO7PhJeKcfxV7dqUQ03M4K2WmA+4=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8118::1:1d])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id fMaeaisFY8-noPGPeon;
        Tue, 18 Jan 2022 19:49:50 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Tue, 18 Jan 2022 19:49:49 +0300
Cc:     Martin KaFai Lau <kafai@fb.com>, Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Content-Transfer-Encoding: 7bit
Message-Id: <0F05155C-ED5A-4FC0-8068-B7A1738B5735@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
 <20211103204607.21491-1-hmukos@yandex-team.ru>
 <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
 <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
 <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 18, 2022, at 18:57, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Mon, 17 Jan 2022 18:26:45 +0300 Akhmat Karakotov wrote:
>> We got the patch acked couple of weeks ago, please let us know what
>> further steps are required before merge.
> 
> Did you post a v4 addressing Yuchung's request?

I thought that Yuchung suggested to make a separate refactor patch?

> but that can be done by a later refactor patch

But if necessary I will integrate those changes in this patch with v4.

Thanks, Akhmat.
