Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E37D6CDA79
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjC2NTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjC2NTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:19:18 -0400
Received: from out28-228.mail.aliyun.com (out28-228.mail.aliyun.com [115.124.28.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBB45264
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:19:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09650706|-1;BR=01201311R281S48rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0216246-0.000517973-0.977857;FP=0|0|0|0|0|0|0|0;HT=ay29a033018047204;MF=aiden.leong@aibsd.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.S20tABR_1680095915;
Received: from eq59.localnet(mailfrom:aiden.leong@aibsd.com fp:SMTPD_---.S20tABR_1680095915)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 21:18:36 +0800
From:   Aiden Leong <aiden.leong@aibsd.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        kernelxing@tencent.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Date:   Wed, 29 Mar 2023 21:18:35 +0800
Message-ID: <6984423.44csPzL39Z@eq59>
In-Reply-To: <16988771.uLZWGnKmhe@eq59>
References: <16988771.uLZWGnKmhe@eq59>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11955260.T7Z3S40VBb";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart11955260.T7Z3S40VBb
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Aiden Leong <aiden.leong@aibsd.com>
To: edumazet@google.com
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
Date: Wed, 29 Mar 2023 21:18:35 +0800
Message-ID: <6984423.44csPzL39Z@eq59>
In-Reply-To: <16988771.uLZWGnKmhe@eq59>
References: <16988771.uLZWGnKmhe@eq59>
MIME-Version: 1.0

On Wednesday, March 29, 2023 9:17:06 PM CST Aiden Leong wrote:
> Hi Eric,
> 
> I hope my email is not too off-topic but I have some confusion on how
> maintainers and should react to other people's work.
> 
> In short, you are stealing Jason's idea&&work by rewriting your
> implementation which not that ethical. Since your patch is based on his
> work, but you only sign-off it by your name, it's possible to raise lawsuit
> between Tencent and Linux community or Google.
> 
> I'm here to provoke a conflict because we know your name in this area and
> I'd to show my respect to you but I do have this kind of confusion in my
> mind and wish you could explain about it.
> 
Typo: I'm here NOT to provoke a conflict 
> There's another story you or Tom Herbert may be interested in: I was working
> on Foo Over UDP and have implemented the missing features in the previous
> company I worked for. The proposal to contribute to the upstream community
> was rejected later by our boss for unhappy events very similar to this one.
> 
> Aiden Leong
> 
> > Jason Xing attempted to optimize napi_schedule_rps() by avoiding
> > unneeded NET_RX_SOFTIRQ raises: [1], [2]
> > 
> > This is quite complex to implement properly. I chose to implement
> > the idea, and added a similar optimization in ____napi_schedule()
> > 
> > Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> > I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> > invocations.
> > 
> > While this had no impact on throughput or cpu costs on this synthetic
> > benchmark, we know that firing NET_RX_SOFTIRQ from softirq handler
> > can force __do_softirq() to wakeup ksoftirqd when need_resched() is true.
> > This can have a latency impact on stressed hosts.
> > 
> > [1] https://lore.kernel.org/lkml/20230325152417.5403-1->
> 
> kerneljasonxing@gmail.com/
> 
> > [2]
> > https://lore.kernel.org/netdev/20230328142112.12493-1-kerneljasonxing@gma
> > il.com/> 
> > Eric Dumazet (4):
> >   net: napi_schedule_rps() cleanup
> >   net: add softnet_data.in_net_rx_action
> >   net: optimize napi_schedule_rps()
> >   net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
> >  
> >  include/linux/netdevice.h |  1 +
> >  net/core/dev.c            | 46 ++++++++++++++++++++++++++++++---------
> >  2 files changed, 37 insertions(+), 10 deletions(-)


--nextPart11955260.T7Z3S40VBb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEENSNFoSpoTSrmxF9vGvlck5mKYvIFAmQkOqsACgkQGvlck5mK
YvLvUAf6A2cL0sa4BVKlZQ4AzAqh36IMJSM7m41Zpcxy0t6xL8Bv5Yqo9+RhNpMS
lJ/3Y2edOZQmLSzdublxUTIw7XmvKIefKcRFpwf8nX27VXxFcdTWt2wg5j8K4YxB
wYQTjpw4wtn4ldaxpePYKGdRZQUWi0bFw4DoDsA2X97dvuz0jZebfT9riMFnx1N/
S0Z7KL4tRwsy5b8HwIHUgqSNtoIYTVG8Mu10SYq4nTHvHPeRPoJIZP3kMgLNTuk0
N8P0h+SR891ITZryxohvUruQ2Vh8BlCgEt+4Kiurgoob2dcpMX/zkzqN4KcDxbWt
OwTlaegFzKeKFQV/GsJG/RlIGTAJNw==
=ifoc
-----END PGP SIGNATURE-----

--nextPart11955260.T7Z3S40VBb--



