Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD065A95D9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiIALjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiIALjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:39:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDA1139F7C
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 04:39:16 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b44so22148506edf.9
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 04:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=cwQPFQYC6FfW+75drNomTnV2hgdjj72iaH/y+IIrk4o=;
        b=B7LK9Rql1meKYTSjNEghBHaiXv0mzI/O6O1KAM0pRjwwuVQ7X+XToZ7+QmNqd/Oopv
         jue32CGa14LWYRgmKkain1gUL0pHOCZjKvtWnosrhC9QhNs8QQqlQUqBAyTTYMWsr6/V
         qIYow92MPGHbG9drPLEB6n+BMUn4DoNO4FYqNzjq0YtlT7jNvCN6QgqrYWw1+ZrFY2mr
         DRw/4IlKs9jxuC0ma0erjhD0DcYoY9e42dh+QRFozDfRy7CwLpPuFKV6H5468N63ERF+
         HAkrxNebvmXp655HzvNIyDpnQ6RfvOKDoPtMV9dfD4dhQlHzgOC+JXGWEkKth5XM8mpq
         97yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cwQPFQYC6FfW+75drNomTnV2hgdjj72iaH/y+IIrk4o=;
        b=HQYeIoADZZspjFowfJUpEnCoDMQ5iodkxBTL/4JgpBxTWDzedbPypOzzTh2HfP3tiP
         k+6UK/CtbQpXyULJuxcZxsBwR33l5kYopMWVoS0kVIX1EjFwTBWvTdBMMn5xRHPd7OjP
         eTBVUmPVNPnW2EQajZzjlMIYl0LKftnZMBoBBthJNhXymZmOYtY8FBt/NVYKl4NsuDsL
         z4uCsh5tc02hm9gb5QhajTLFKRpyR1hv+k89aY44H7iKWqvuSJH9UAHsWsdQae/0M0so
         BOgu00PI9vvarwkEA8+IXnU4gZ8sRcsiGiKuy3Qe2wWQZvfZRpxiSPkc5y5wmk2Y5eed
         +j2g==
X-Gm-Message-State: ACgBeo34ucRAmGtcIXo2dK5dZRgFKeRM6Kwpkmy9an9xaBmE2w7iFkPI
        l5Lkh7g5qSZ8uDRR4Gktiqs=
X-Google-Smtp-Source: AA6agR4MRrmf4TctEZSxVMfUigeie1h3/8JSrWKG1u9gutGGCviwbmG0U4Xk8i6GDteQ50GojbkSjw==
X-Received: by 2002:a05:6402:5488:b0:443:39c5:5347 with SMTP id fg8-20020a056402548800b0044339c55347mr28607938edb.204.1662032355279;
        Thu, 01 Sep 2022 04:39:15 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id dv10-20020a170906b80a00b0073d6234ceebsm8285731ejb.160.2022.09.01.04.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 04:39:14 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:39:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Message-ID: <20220901113912.wrwmftzrjlxsof7y@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf>
 <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf>
 <87czcfzkb6.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czcfzkb6.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 08:21:33AM +0200, Kurt Kanzenbach wrote:
> > So from Florian's comment above, he was under case (b), different than yours.
> > I don't understand why you say that when ACS is set, "the STP frames are
> > truncated and the trailer tag is gone". Simply altering the ACS bit
> > isn't going to change the determination made by stmmac_rx(). My guess
> > based on the current input I have is that it would work fine for you
> > (but possibly not for Florian).
> 
> I thought so too. However, altering the ACS Bit didn't help at all.

This is curious. Could you dump the Length/Type Field (LT bits 18:16)
from the RDES3 for these packets? If ACS does not take effect, it would
mean the DWMAC doesn't think they're Length packets I guess? Also, does
the Error Summary say anything? In principle, the length of this packet
is greater than the EtherType/Length would say, by the size of the tail
tag. Not sure how that affects the RX parser.

> We could do some measurements e.g., with perf to determine whether
> removing the FCS logic has positive or negative effects?

Yes, some IP forwarding of 60 byte frames at line rate gigabit or higher
should do the trick. Testing with MTU sized packets is probably not
going to show much of a difference.

> > How large can you configure the hellcreek switch to send packets towards
> > the DSA master? Could you force a packet size (including hellcreek tail tag)
> > comparable to dma_conf->dma_buf_sz?
> 
> I don't think so.
> 
> > Or if not, perhaps you could hack the way in which stmmac_set_bfsize()
> > works, or one of the constants?
> 
> I'm not sure if i follow you here.

I mean if you can't bring the MTU of the switch closer to the buffer
size of the DSA master, at least bring the buffer size closer to the MTU
of the switch. If this means, idk, hacking the DEFAULT_BUFSIZE macro to
a lower value such as to force splitting some otherwise "normal" packet
sizes into 2 buffers, fine.

Then, the next step would be to force this splitting to occur exactly
where the FCS lies in the buffers. Then I should be able to hear the
kaboom from over here.
