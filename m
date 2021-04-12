Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC00335BC4D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhDLIh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:37:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237302AbhDLIh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618216628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=llt0UsbYdmkKs2AvmSC/mKO6pX1P62Vepd/ZGeV16rI=;
        b=WW05y9lzMZuBGJn7mZwHPtfy1SP1OeqyjoeCWuCj+41H2Dkp/S0YGBLKFKFhcr8JIQqMHT
        sDpl4FC3cjdirZk/mFUk75RfUUlwA1H6ArGjachdSi5Eql5U8UPnM3zllqiwG82+Sp+tt6
        00YJjlVrHjzNkBGaKAq2tfpk2vcHj9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-76BEtMu-MMezS2dODWGT1w-1; Mon, 12 Apr 2021 04:37:04 -0400
X-MC-Unique: 76BEtMu-MMezS2dODWGT1w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41A936D246;
        Mon, 12 Apr 2021 08:37:02 +0000 (UTC)
Received: from ovpn-115-67.ams2.redhat.com (ovpn-115-67.ams2.redhat.com [10.36.115.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE57A5C22A;
        Mon, 12 Apr 2021 08:36:59 +0000 (UTC)
Message-ID: <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
Subject: Re: Bug Report Napi GRO ixgbe
From:   Paolo Abeni <pabeni@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me
Date:   Mon, 12 Apr 2021 10:36:58 +0200
In-Reply-To: <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com>
References: <20210316223647.4080796-1-weiwan@google.com>
         <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
         <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
         <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
         <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
         <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2021-04-10 at 14:22 +0300, Martin Zaharinov wrote:
> Hi  Team
> 
> One report latest kernel 5.11.12 
> 
> Please check and help to find and fix

Please provide a complete splat, including the trapping instruction.
> 
> Apr 10 12:46:25  [214315.519319][ T3345] R13: ffff8cf193ddf700 R14: ffff8cf238ab3500 R15: ffff91ab82133d88
> Apr 10 12:46:26  [214315.570814][ T3345] FS:  0000000000000000(0000) GS:ffff8cf3efb00000(0000) knlGS:0000000000000000
> Apr 10 12:46:26  [214315.622416][ T3345] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Apr 10 12:46:26  [214315.648390][ T3345] CR2: 00007f7211406000 CR3: 00000001a924a004 CR4: 00000000001706e0
> Apr 10 12:46:26  [214315.698998][ T3345] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Apr 10 12:46:26  [214315.749508][ T3345] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Apr 10 12:46:26  [214315.799749][ T3345] Call Trace:
> Apr 10 12:46:26  [214315.824268][ T3345]  netif_receive_skb_list_internal+0x5e/0x2c0
> Apr 10 12:46:26  [214315.848996][ T3345]  napi_gro_flush+0x11b/0x260
> Apr 10 12:46:26  [214315.873320][ T3345]  napi_complete_done+0x107/0x180
> Apr 10 12:46:26  [214315.897160][ T3345]  ixgbe_poll+0x10e/0x2a0 [ixgbe]
> Apr 10 12:46:26  [214315.920564][ T3345]  __napi_poll+0x1f/0x130
> Apr 10 12:46:26  [214315.943475][ T3345]  napi_threaded_poll+0x110/0x160
> Apr 10 12:46:26  [214315.966252][ T3345]  ? __napi_poll+0x130/0x130
> Apr 10 12:46:26  [214315.988424][ T3345]  kthread+0xea/0x120
> Apr 10 12:46:26  [214316.010247][ T3345]  ? kthread_park+0x80/0x80
> Apr 10 12:46:26  [214316.031729][ T3345]  ret_from_fork+0x1f/0x30

Could you please also provide the decoded the stack trace? Something
alike the following will do:

cat <file contaning the splat> | ./scripts/decode_stacktrace.sh <path to vmlinux>

Even more importantly:

threaded napi is implemented with the merge
commit adbb4fb028452b1b0488a1a7b66ab856cdf20715, which landed into the
vanilla tree since v5.12.rc1 and is not backported to 5.11.x. What
kernel are you really using?

Thanks,

Paolo

