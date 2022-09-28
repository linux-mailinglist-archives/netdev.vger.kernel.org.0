Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4B25EE8AE
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 23:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiI1Vxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 17:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiI1VxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 17:53:21 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7A5B6025;
        Wed, 28 Sep 2022 14:53:20 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id A94DEC021; Wed, 28 Sep 2022 23:53:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664401997; bh=BHV/yJbIkGK5qQNJNI3iNQ3gbP+uXMdXAVbx7REK9Go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2xL5HoPSL36MiwWb6YMyFPWRcAofCwW2O51mPBRKP6Wu4+6eCSPzLEvV1dElgnlis
         goPoiRFjrtWaFxfyLXaHeGTnVQgIsw27ASVP4UY0FF4QxBrIMrynT8fR/9D8sAKHmP
         MFLDxlWJp019Pi9HknmQ72LIX7yzfNvPSaSkA5PM5nAdwk3EciiY1mQkybn6t5N4SO
         UEITC5kjFzhBXwnH2+Z7pSJ5Eu8401/SKPIeavM9bQPJUVozBpeVpBYj4Um1sIfxHE
         AQs3OjOASyF8O7WZik22smPphUT8Q+FeBiZlh36jWI0akNXu/E+hPiI7NTo7eCv3PQ
         H7H0IStviAjAg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id E49F7C009;
        Wed, 28 Sep 2022 23:53:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1664401996; bh=BHV/yJbIkGK5qQNJNI3iNQ3gbP+uXMdXAVbx7REK9Go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=3vq8WmaRPHEHacUrTeCpJZ7fB9QV5nwCbyyXxvRxw/yfFKWDbg/vUHcWK8ikg3a5S
         1maclwvEeS1YqcrPN2DgYP6PRLP3QaKOZ1tspvBqaxKtQ3+PrldQnfvol58tLXdiAC
         v0tyImF+5cQalVeNfeWNPwo9NbTmlum7t5JfQ3OtIje6mubFVvt0EIGpUL2Rrcvn+5
         6SQ/cclQZVQ92GeVmYnv6tcOEYEpFRxtgjDQ1LoLoHdAAyjp9T4ccQAkhmyjcor5rk
         cS+R4jdVpmjAIYBQLFF7/sxlAciHi4mfJQKmCUmgL47ubuMfbupa8j2Phx35IJOk7q
         cMhxvJanPZ6NQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c428fee3;
        Wed, 28 Sep 2022 21:53:11 +0000 (UTC)
Date:   Thu, 29 Sep 2022 06:52:56 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] KASAN: use-after-free Read in rdma_close
Message-ID: <YzTCOGCo5mIxwf9S@codewreck.org>
References: <00000000000015ac7905e97ebaed@google.com>
 <YzQuoqyGsooyDfId@codewreck.org>
 <YzQ12+jtARpwS5bw@unreal>
 <1783490.kFEjeSjHVE@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1783490.kFEjeSjHVE@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Sep 28, 2022 at 02:57:07PM +0200:
> OK, maybe it's just me, but ask yourself Leon, if you were the only guy left 
> (i.e. Dominique) still actively taking care for 9p, would those exactly be 
> motivating phrases for your efforts? Just saying.

I didn't plan on replying (happy to disagree), but I'm actually grateful
for Leon to have taken the time to look here: Thank you!
While I probably would also have spotted the error (the change is
fresh), it saved me time even if you account for some bikeshedding.

(Not particularly happy with the amount of time I can allocate to 9p nor
the maintainance work I'm doing by the way, but I guess it's better than
leaving it completely unmaintained)

> From technical perspective, yes, destruction in reverse order is usually the 
> better way to go. Whether I would carve that in stone, without any exception, 
> probably not.

I think it's a tradeoff really.
Unrolling in place is great, don't get me wrong, but it's also easy to
miss things when adding code later on -- we actually just did that and
got another kasan report which made me factor things in to future-proof
the code.

Having a single place of truth that knows how to "untangle" and properly
free a struct, making sure it is noop for parts of the struct that
haven't been initialized yet, is less of a burden for me to think about.


... Just happened to be wrong about the "making sure it's noop" part
because I didn't check properly and my mental model had close functions
noop on NULL clnt->priv, like free functions...
(Uh, actually it is for RDMA, so the "problem" was that it left
clnt->trans set after later errors -- but conversely virtio's close
doesn't check so also had the problem and we really must ensure we don't
close something not open)

Anyway, I've sent a couple of patch (even fixing up the order to match
in create/destroy), I'll consider this closed.

-- 
Dominique
