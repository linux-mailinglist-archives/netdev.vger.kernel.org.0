Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8889A47EDB1
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 10:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352202AbhLXJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 04:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352184AbhLXJUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 04:20:08 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B5BC061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 01:20:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1n0gk8-0004A6-5p
        for netdev@vger.kernel.org; Fri, 24 Dec 2021 10:20:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1n0ggH-000o1z-42
        for netdev@vger.kernel.org;
        Fri, 24 Dec 2021 10:16:05 +0100
Date:   Fri, 24 Dec 2021 10:16:05 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     netdev@vger.kernel.org
Subject: Re: ip xfrm delete / deleteall not able to delete SAs with SPI=0
Message-ID: <YcWP1V7b4ZLhbcM7@nataraja>
References: <YcTyNRqYdBGoEYid@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcTyNRqYdBGoEYid@nataraja>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again,

I did a bit more testing and the problem seems to occur with SPI=0,
i.e. the kernel permits a SA for SPI=0 to be created via netlink, but then
it somehow fails to allow that to be deleted again via netlink, and it will
be stuck until the user manually flushes all SAs.

To be fair, RFC4303 says "The SPI value of zero (0) is reserved for local,
implementation-specific use and MUST NOT be sent on the wire"

However, despite that, I think the kernel should ether

a) reject creation of any SA with SPI=0

b) if it accepts a SA with SPI=0 in NEWSA, it should equally accept
   the symmetric DELSA operation with SP=0

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
