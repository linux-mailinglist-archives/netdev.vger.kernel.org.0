Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1854D5758
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbiCKBaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345334AbiCKBaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:30:23 -0500
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3CA5198EC5
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:29:20 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 89B6B4400EE
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:29:19 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646962159; bh=m8QdkyzF5uJyIUo9GVO42SoDTGsjEsvoqS7wv+zGISc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sIXI/KvAEXG8MUgcV1YhcN0SJFIo5C2NY+LC+IbCYhk1LyX870bAZxQ0m/28bVD+h
         AvezerSrky1CSg41dyz1q2ol52u+A4QVpFOKXH9r/3rVwICq3nqnbCiAtw5WFyL1yl
         WJ36Uydytktgon3PD2BVh12FgBiBKgdRhv7lua/c=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -659988000
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 09:29:19 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646962159; bh=m8QdkyzF5uJyIUo9GVO42SoDTGsjEsvoqS7wv+zGISc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sIXI/KvAEXG8MUgcV1YhcN0SJFIo5C2NY+LC+IbCYhk1LyX870bAZxQ0m/28bVD+h
         AvezerSrky1CSg41dyz1q2ol52u+A4QVpFOKXH9r/3rVwICq3nqnbCiAtw5WFyL1yl
         WJ36Uydytktgon3PD2BVh12FgBiBKgdRhv7lua/c=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 1945F15414F8;
        Fri, 11 Mar 2022 09:29:17 +0800 (CST)
Date:   Fri, 11 Mar 2022 09:29:16 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220311092916.00005266@tom.com>
In-Reply-To: <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220310134830.130818-1-sunmingbao@tom.com>
        <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 12:48:25 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 10 Mar 2022 21:48:30 +0800 Mingbao Sun wrote:
> > Since the kernel API 'kernel_setsockopt' was removed, and since the
> > function =E2=80=98tcp_set_congestion_control=E2=80=99 is just the real =
underlying guy
> > handling this job, so it makes sense to get it exported. =20
>=20
> Do you happen to have a reference to the commit which removed
> kernel_setsockopt and the justification?  My knee jerk reaction
> would the that's a better path than allowing in-kernel socket users=20
> to poke at internal functions even if that works as of today.

FYI
(Sorry for putting URLs in the mail):

kernel_setsockopt disappeared from kernel v5.8,
and all the relevant users have switched to
dedicated small functions.

The mail thread:
https://lists.archive.carbon60.com/linux/kernel/3712394

The commit:
https://github.com/torvalds/linux/commit/5a892ff2facb4548c17c05931ed899038a=
0da63e

