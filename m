Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9392B5C4D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgKQJxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:53:08 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:49734 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgKQJxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:53:07 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kexfY-000J4Z-WF; Tue, 17 Nov 2020 10:53:01 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kexfY-000Dne-4b; Tue, 17 Nov 2020 10:53:00 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 6539A240041;
        Tue, 17 Nov 2020 10:52:59 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id DB331240040;
        Tue, 17 Nov 2020 10:52:58 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id A2EED21E27;
        Tue, 17 Nov 2020 10:52:58 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 17 Nov 2020 10:52:58 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
Message-ID: <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1605606780-000035B9-6429194D/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-16 21:16, Xie He wrote:
> Do you mean we will now automatically establish LAPB connections
> without upper layers instructing us to do so?

Yes, as soon as the physical link is established, the L2 and also the
L3 layer (restart handshake) is established.

In this context I also noticed that I should add another patch to this
patch-set to correct the restart handling.

As already mentioned I have a stack of fixes and extensions lying around
that I would like to get upstream.

> If that is the case, is the one-byte header for instructing the LAPB
> layer to connect / disconnect no longer needed?

The one-byte header is still needed to signal the status of the LAPB
connection to the upper layer.
