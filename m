Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33EB492B90
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbiARQwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiARQwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:52:09 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08999C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:52:09 -0800 (PST)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 4E5872E19E5;
        Tue, 18 Jan 2022 19:52:06 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Rpbu1gzXC7-q5P0RMtj;
        Tue, 18 Jan 2022 19:52:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1642524726; bh=LC7rOMwMsuc7pMv/km+jxpOvkgGMnSK02socXymlm2U=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=KGlTgbq5UVc2P+X1sqr/rrGzHIKY7woJnEwO3nYHn3jIOleQxqUlGj4okYk2qgLZy
         K820g05waKtmnFybjbxiY/KfprAqjnPIsUWeZrwtiGqs+exNmvY9DJx7n6SdD03msA
         91cAjmcdED1YDUQafgAJ2Tjyr8KA0jaxTIrtk/Pg=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:8118::1:1d])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 4QSCWdUXda-q5Q0trfi;
        Tue, 18 Jan 2022 19:52:05 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [RFC PATCH v3 net-next 4/4] tcp: change SYN ACK retransmit
 behaviour to account for rehash
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20220118080350.5765ed94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Tue, 18 Jan 2022 19:52:05 +0300
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        tom@herbertland.com, zeil@yandex-team.ru, davem@davemloft.net
Content-Transfer-Encoding: 7bit
Message-Id: <6E4E9B44-B0A3-42F8-B7A6-E4F5038A5896@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-5-hmukos@yandex-team.ru>
 <614E2777-315B-4C47-94B8-F6E9D6F3E4B5@yandex-team.ru>
 <20220118080350.5765ed94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 18, 2022, at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Mon, 17 Jan 2022 18:31:37 +0300 Akhmat Karakotov wrote:
>> We got the patch reviewed couple of weeks ago, please let us know what
>> further steps are required before merge. Thanks, Akhmat.
> 
> We rarely merge RFC patchsets these days, you need to repost without
> the RFC marking. Obviously keeping Eric's Acks. You should also CC
> the bpf list & maintainers on patch 3. Please repost next week, the
> merge window is still ongoing and net-next is closed for another few
> days:
> 
> http://vger.kernel.org/~davem/net-next.html

Thanks for answer, Jakub! I'll resend it next week.
