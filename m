Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB56CFDDF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjC3IOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjC3IOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:14:47 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE0235AD;
        Thu, 30 Mar 2023 01:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=NGOvA+g28wjEHQf9W6AzPb4YDDg/KhBMYR6TNf4AJDo=;
        t=1680164086; x=1681373686; b=xhb5x04giMu80gmEiCD3G0AW24YPt3ijyLkzOWiPQEXUBFm
        Nf1p4TPc8C+va2m3JZY1491UscplDxl9X0UZ8+R++785JmrQxzlfSLHJdO3fg2/8e0r4WuxUwrE9A
        ws8J7oxshxVuE06zc9lsJPb5s0IUqtLau2j9wVaxQGy6VAjxnJ3CaPrGtbGcEGnTFIJUigSgwJcsl
        O58A8xwwxqzEBnq3ZQIHVo3xDsCcM9Houxg2q1vHAFdx5/Zp+AzTaXWPVJy6LFxXE4YAwwSoJCU0c
        4UvA3uTahKJju4xonflOym6FwtUrnwxZsaVdzKD1MHH11Kepa77rVgA/Bxdom7GA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phnQi-000wYp-1h;
        Thu, 30 Mar 2023 10:14:44 +0200
Message-ID: <b7b09926e76112e79d0683089c85cad894d8d6de.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 2/2] mac80211: use the new drop reasons
 infrastructure
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 30 Mar 2023 10:14:43 +0200
In-Reply-To: <20230329210633.39cca656@kernel.org>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
         <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
         <34e43da3694e2d627555af0149ebe438e1ed2938.camel@sipsolutions.net>
         <20230329210633.39cca656@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-29 at 21:06 -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 23:56:31 +0200 Johannes Berg wrote:
> > > +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_MONI=
TOR);
> > > +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_UNUS=
ABLE);
> > > +
> > >  	rcu_barrier(); =20
> >=20
> > This is making me think that perhaps we don't want synchronize_rcu()
> > inside drop_reasons_unregister_subsys(), since I have two now and also
> > already have an rcu_barrier() ... so maybe just document that it's
> > needed?
>=20
> premature optimization? some workload is reloading mac80211 in a loop?

Yeah, true, nobody is going to do that :-)

Let's leave it this way.

johannes
