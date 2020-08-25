Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B5251E53
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHYRck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgHYRcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:32:39 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Aug 2020 10:32:38 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D5EC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:32:38 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kAcSS-0003kQ-8a; Tue, 25 Aug 2020 19:10:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kAcJp-00Gb9n-CY; Tue, 25 Aug 2020 19:01:09 +0200
Date:   Tue, 25 Aug 2020 19:01:09 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Gabriel Ganne <gabriel.ganne@6wind.com>
Subject: Re: [PATCH net-next v2] gtp: add notification mechanism
Message-ID: <20200825170109.GH3822842@nataraja>
References: <20200825143556.23766-1-nicolas.dichtel@6wind.com>
 <20200825155715.24006-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825155715.24006-1-nicolas.dichtel@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

thanks a lot for your patch.

On Tue, Aug 25, 2020 at 05:57:15PM +0200, Nicolas Dichtel wrote:
> Like all other network functions, let's notify gtp context on creation and
> deletion.

While this may be in-line with typical kernel tunnel device practises, I am not
convinced it is the right way to go for GTP.

Contrary to other tunneling mechansims, GTP doesn't have a 1:1 rlationship between
tunnels and netdev's.  You can easily have tens of thousands - or even many more -
PDP contexts (at least one per subscriber) within one "gtp0" netdev.  Also, the state
is highly volatile.  Every time a subscriber registers/deregisters, goes in or out of
coverage, in or out of airplane mode, etc. those PDP contexts go up and down.

Sending (unsolicited) notifications about all of those seems quite heavyweight to me.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
