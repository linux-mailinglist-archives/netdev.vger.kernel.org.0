Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC0B58F7CD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 08:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiHKGlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 02:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiHKGli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 02:41:38 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C246277;
        Wed, 10 Aug 2022 23:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660200073; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=JIuhEtk+zC29CbNkmdOCrw+Q5z2xH1mC4BnEARSwRXYvM3ivF+ov3OHhbg+Uz/sq7kczmueyeTpvLbNf+GjamFTQG9n0ST9ufl3fAYXaerMTAFpR4K79HjTauu27QSgplrXttiR1ORBvfh7Eqz6OM7OWm9MckYroa+Cr5xHkqM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660200073; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qzGf/xcU2qq0loWcNErzo5p+bIrEsm6IFkASa7YpiCw=; 
        b=RsjzwqRl5kyoQAszaa1fi/Pq/SLsnaS8X4AOvxTio0sa6W20pxrPNP1G/qEKVt2jUTgqMT5afTjCd8+U0vvPC7YMwFWfZKWw7ZIes/Owntd79EXRJNIckiSio0OxDqUadwgr4xa8FnQz4Fjmuue8unB5kA7kkPngLjKPDU6Mmf0=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660200073;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=qzGf/xcU2qq0loWcNErzo5p+bIrEsm6IFkASa7YpiCw=;
        b=UMSq0MqTUseR1Ca9R3QbfhVoBkeMmWaW3kL9mXslNS0ht+KTczA9AXIJJvKLwmCc
        kJD3rE3ZTwBZGw/sfIC+lN9XB+PS+nZAvysF363UNOw7aEku3XMWNZkoBiP+xfTJjSM
        lVgHUhqDzFRrdELEHnYQTTQiy9zeXIyKgkLyW4OE=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660200062303914.6279487087534; Thu, 11 Aug 2022 12:11:02 +0530 (IST)
Date:   Thu, 11 Aug 2022 12:11:02 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "syzbot" <syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com>
Cc:     "davem" <davem@davemloft.net>,
        "johannes" <johannes@sipsolutions.net>, "kuba" <kuba@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "syzkaller-bugs" <syzkaller-bugs@googlegroups.com>
Message-ID: <1828ba28d43.27f8b7ca86738.4232033862850200536@siddh.me>
In-Reply-To: <000000000000f5acfd05e5e5ccdc@google.com>
References: <000000000000f5acfd05e5e5ccdc@google.com>
Subject: Re: [syzbot] WARNING in ieee80211_ibss_csa_beacon
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 22:17:12 +0530  syzbot  wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:

Trying again.

#syz test https://github.com/siddhpant/linux.git warning_ibss_csa_beacon
