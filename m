Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7302EE83BB
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbfJ2JDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:03:12 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60414 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbfJ2JDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:03:12 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iPNP6-0004Ha-89; Tue, 29 Oct 2019 10:03:04 +0100
Message-ID: <dbbc8c3e898ec499f30a6ac1f262666ced6905fb.camel@sipsolutions.net>
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Oct 2019 10:03:02 +0100
In-Reply-To: <30465e05-3465-f496-d57f-5e115551f5cb@ncentric.com> (sfid-20191029_094137_778584_BACBC770)
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
         <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
         <30465e05-3465-f496-d57f-5e115551f5cb@ncentric.com>
         (sfid-20191029_094137_778584_BACBC770)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 09:41 +0100, Koen Vandeputte wrote:

> I can confirm the issue as I'm also seeing this sometimes in the field here.
> 
> Sometimes when a devices goes out of range and then re-enters,
> the link refuses to "come up", as in rx looks to be "stuck" without any 
> reports in system log or locking issues (lockdep enabled)

Right. I've recently debugged this due to issues in distributed
beaconing (rather than moving in/out of range), but I guess it would be
relatively simple to reproduce this with wmediumd, if that can be
controlled dynamically?

What kernel are you running? You could check if you have

95697f9907bf ("mac80211: accept deauth frames in IBSS mode")
4b08d1b6a994 ("mac80211: IBSS: send deauth when expiring inactive STAs")

which might help somewhat, but don't fully cover the case of moving out
of range.

johannes

