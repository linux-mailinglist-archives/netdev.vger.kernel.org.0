Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC654370AD7
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhEBJFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 05:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhEBJFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 05:05:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A856AC06174A
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 02:04:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ld81l-002t7L-Ok; Sun, 02 May 2021 11:04:38 +0200
Message-ID: <2784fc9d11a97ae4734d12058a6e0e6564ac9309.camel@sipsolutions.net>
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Date:   Sun, 02 May 2021 11:04:36 +0200
In-Reply-To: <608D5CA3.7020700@gmail.com> (sfid-20210501_154106_642617_08B34215)
References: <608BF122.7050307@gmail.com>
                         (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>
                 <608C3B2C.8040005@gmail.com>
         (sfid-20210430_190603_013225_96A76113) <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net>
         <608C9A57.5010102@gmail.com> <608D5CA3.7020700@gmail.com>
         (sfid-20210501_154106_642617_08B34215)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-05-01 at 16:50 +0300, Nikolai Zhubr wrote:
> Hi Johannes,
> 
> 01.05.2021 3:01, I wrote:
> [...]
> > > https://p.sipsolutions.net/5adbe659fb061f06.txt
> > 
> > Is it supposed to work correctly for unmodified 5.12 kernel? Because it
> 
> Success! I've found an apparently missing mutex_unlock() in alx_probe() 
> just before the "return 0" line.
> 

D'oh, right, missed that place.

> With that inserted, your patch indeed 
> fixes the 120 s boot delay here. And the link apparenly also works fine 
> after boot, in normal operation.
> Can it be somehow reviewed and submitted unstream please?
> I'd like it also ported to 4.xx then. (Maybe I can port myself though)

Well I don't think anyone's going to still backport such a patch to a
4.x kernel, but of course you can.

I guess I can see about making it a real patch, should only take a
little while to audit (again) the hardware access paths wrt. locking.

johannes

