Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B85BD5FB
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiISVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiISVAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:00:08 -0400
X-Greylist: delayed 765 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Sep 2022 14:00:06 PDT
Received: from mailhost.m5p.com (mailhost.m5p.com [74.104.188.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161052AF5
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 14:00:04 -0700 (PDT)
Received: from m5p.com (mailhost.m5p.com [IPv6:2001:470:1f07:15ff:0:0:0:f7])
        by mailhost.m5p.com (8.16.1/8.15.2) with ESMTPS id 28JKl0ox092890
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 19 Sep 2022 16:47:06 -0400 (EDT)
        (envelope-from ehem@m5p.com)
Received: (from ehem@localhost)
        by m5p.com (8.16.1/8.15.2/Submit) id 28JKkxYl092889;
        Mon, 19 Sep 2022 13:46:59 -0700 (PDT)
        (envelope-from ehem)
Date:   Mon, 19 Sep 2022 13:46:59 -0700
From:   Elliott Mitchell <ehem+xen@m5p.com>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Xen developer discussion <xen-devel@lists.xenproject.org>,
        netdev@vger.kernel.org
Subject: Re: Layer 3 (point-to-point) netfront and netback drivers
Message-ID: <YyjVQxmIujBMzME3@mattapan.m5p.com>
References: <YycSD/wJ9pL0VsFD@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YycSD/wJ9pL0VsFD@itl-email>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 08:41:25AM -0400, Demi Marie Obenour wrote:
> How difficult would it be to provide layer 3 (point-to-point) versions
> of the existing netfront and netback drivers?  Ideally, these would
> share almost all of the code with the existing drivers, with the only
> difference being how they are registered with the kernel.  Advantages
> compared to the existing drivers include less attack surface (since the
> peer is no longer network-adjacent), slightly better performance, and no
> need for ARP or NDP traffic.

I've actually been wondering about a similar idea.  How about breaking
the entire network stack off and placing /that/ in a separate VM?

One use for this is a VM could be constrained to *exclusively* have
network access via Tor.  This would allow a better hidden service as it
would have no network topology knowledge.

The other use is network cards which are increasingly able to handle more
of the network stack.  The Linux network team have been resistant to
allowing more offloading, so perhaps it is time to break *everything*
off.

I'm unsure the benefits would justify the effort, but I keep thinking of
this as the solution to some interesting issues.  Filtering becomes more
interesting, but BPF could work across VMs.


-- 
(\___(\___(\______          --=> 8-) EHM <=--          ______/)___/)___/)
 \BS (    |         ehem+sigmsg@m5p.com  PGP 87145445         |    )   /
  \_CS\   |  _____  -O #include <stddisclaimer.h> O-   _____  |   /  _/
8A19\___\_|_/58D2 7E3D DDF4 7BA6 <-PGP-> 41D1 B375 37D0 8714\_|_/___/5445


