Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3736C442BDB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhKBKyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBKyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 06:54:31 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CB6C061714;
        Tue,  2 Nov 2021 03:51:57 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 3C75BC01F; Tue,  2 Nov 2021 11:51:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635850314; bh=/+rgwyKj69Vlkv0On+QcUYGVMOPrFUm5qkV/iCdjSuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bllg/2urLxMrhi0EQ9vJE7hUT0j+9sipszv0uG4cD9GuneRFwaENHv+XPEAdtgpQ3
         BVZFTpfit0eEaeAj9ywQWv/smY2YtZf/mN1EftGrFsHzhC67p51Ja+zi9mOki67ikU
         bdIOsRWgYttAr8XixlwRIvmTM5QPJPhvaYQl+i4PciRR/q6EjKgIK9zuCcXtvpzGCT
         F6cNTJrPC0PmYKCC1kkyGGVZkhrhgSGZvmFlOFrzcqKJS7YGgoDKwgS5dJxErfmMuV
         dFziBQSpjp8J7wMtEcSa8ZcvMgc3mDpa8Bk+q/Hu3wSrbpkD3bkf3uCZvblDuGHCiN
         D2l1P2++pR8Rw==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7322BC009;
        Tue,  2 Nov 2021 11:51:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1635850312; bh=/+rgwyKj69Vlkv0On+QcUYGVMOPrFUm5qkV/iCdjSuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VMaB08Hu6Foyxs/pdMDPS6K8Al/e8m6rZ0Eoedy5eGGFg0BtzkXXkdvbiOhcja/bN
         nuUiCNQjIatikUFrmzTeCECJFWeWKEKzGxeMzs+Apt97UYqRG/ckfOhZmPwhsvD0zk
         WquzyAbppLOCo4qmbE1QJQ596SSnNxFVctkKlsxx71fQmYCyHTx61PGM5W+vV19UBR
         Y8CZYyWKlsHYEuE5CFwrqz/p2Gm5JZns92Z2k90P8+brOGfJojqbgPBRaRuGg3JP0P
         3yPeY9Oedsw7HTF2llivfdcWzb2wcY1P7/YE8RP9ZLuG5ZIzMw+4GplxnYfmp2hV/p
         f8wa6F+jyfD+g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b13de0de;
        Tue, 2 Nov 2021 10:51:45 +0000 (UTC)
Date:   Tue, 2 Nov 2021 19:51:30 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <YYEYMt543Hg+Hxzy@codewreck.org>
References: <20211017134611.4330-1-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211017134611.4330-1-linux@weissschuh.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the late reply

Thomas Weißschuh wrote on Sun, Oct 17, 2021 at 03:46:11PM +0200:
> Automatically load transport modules based on the trans= parameter
> passed to mount.
> The removes the requirement for the user to know which module to use.

This looks good to me, I'll test this briefly on differnet config (=y,
=m) and submit to Linus this week for the next cycle.

Makes me wonder why trans_fd is included in 9pnet and not in a 9pnet-fd
or 9pnet-tcp module but that'll be for another time...
-- 
Dominique
