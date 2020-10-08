Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C52879C5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgJHQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729164AbgJHQO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:14:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24BFC061755;
        Thu,  8 Oct 2020 09:14:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQYYa-001jkw-PM; Thu, 08 Oct 2020 18:14:16 +0200
Message-ID: <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its
 debugfs is being used
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Taehee Yoo' <ap420073@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolai Stange <nicstange@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date:   Thu, 08 Oct 2020 18:14:15 +0200
In-Reply-To: <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com> (sfid-20201008_181146_072575_728542C7)
References: <20201008155048.17679-1-ap420073@gmail.com>
         <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
         (sfid-20201008_181146_072575_728542C7)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:
> From: Taehee Yoo
> > Sent: 08 October 2020 16:49
> > 
> > When debugfs file is opened, its module should not be removed until
> > it's closed.
> > Because debugfs internally uses the module's data.
> > So, it could access freed memory.
> > 
> > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > So that all modules will be held when its debugfs file is opened.
> 
> Can't you fix it in common code?

Yeah I was just wondering that too - weren't the proxy_fops even already
intended to fix this?

The modules _should_ be removing the debugfs files, and then the
proxy_fops should kick in, no?

So where's the issue?

johannes

