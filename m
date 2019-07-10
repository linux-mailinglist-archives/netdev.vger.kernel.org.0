Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F164264C8D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfGJTKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfGJTKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 15:10:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B98E230BC56E;
        Wed, 10 Jul 2019 19:10:02 +0000 (UTC)
Received: from elisabeth (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19BB38847E;
        Wed, 10 Jul 2019 19:09:59 +0000 (UTC)
Date:   Wed, 10 Jul 2019 21:09:54 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jan Szewczyk <jan.szewczyk@ericsson.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: Question about linux kernel commit: "net/ipv6: move metrics
 from dst to rt6_info"
Message-ID: <20190710210954.530d72a5@elisabeth>
In-Reply-To: <AM6PR07MB5639E2AEF438DD017246DF13F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
References: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
        <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
        <AM6PR07MB5639E2AEF438DD017246DF13F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 10 Jul 2019 19:10:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jan,

On Wed, 10 Jul 2019 12:59:41 +0000
Jan Szewczyk <jan.szewczyk@ericsson.com> wrote:

> Hi!
> I digged up a little further and maybe it's not a problem with MTU
> itself. I checked every entry I get from RTM_GETROUTE netlink message
> and after triggering "too big packet" by pinging ipv6address I get
> exactly the same messages on 4.12 and 4.18, except that the one with
> that pinged ipv6address is missing on 4.18 at all. What is weird -
> it's visible when running "ip route get to ipv6address". Do you know
> why there is a mismatch there?

If I understand you correctly, an implementation equivalent to 'ip -6
route list show' (using the NLM_F_DUMP flag) won't show the so-called
route exception, while 'ip -6 route get' shows it.

If that's the case: that was broken by commit 2b760fcf5cfb ("ipv6: hook
up exception table to store dst cache") that landed in 4.15, and fixed
by net-next commit 1e47b4837f3b ("ipv6: Dump route exceptions if
requested"). For more details, see the log of this commit itself.

-- 
Stefano
