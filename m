Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC5511AC4D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfLKNmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:42:22 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:54210 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbfLKNmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:42:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if2Ft-0048AX-7O; Wed, 11 Dec 2019 14:42:17 +0100
Message-ID: <14bbfcc8408500704c46701251546e7ff65c6fd0.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 14:42:15 +0100
In-Reply-To: <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net> (sfid-20191211_125201_337679_199CAD32)
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
         <878snjgs5l.fsf@toke.dk>
         <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
         <875zingnzt.fsf@toke.dk>
         <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net>
         (sfid-20191211_125201_337679_199CAD32)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Btw, there's *another* issue. You said in the commit log:

    This patch does *not* include any mechanism to wake a throttled TXQ again,
    on the assumption that this will happen anyway as a side effect of whatever
    freed the skb (most commonly a TX completion).

Thinking about this some more, I'm not convinced that this assumption
holds. You could have been stopped due to the global limit, and now you
wake some queue but the TXQ is empty - now you should reschedule some
*other* TXQ since the global limit had kicked in, not the per-TXQ limit,
and prevented dequeuing, no?

johannes

