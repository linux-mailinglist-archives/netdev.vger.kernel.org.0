Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FEF4A64D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfFRQKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729308AbfFRQKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 12:10:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E5920B1F;
        Tue, 18 Jun 2019 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560874238;
        bh=27tzGqss7W1INeTOZvlPttXLlDhuND5mt5s6cmAcYfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbagzbc1cxMBT3pAtPwVkyb/uAxnO7C7Px3DW0pP5qcFGUMdG/mDsiEiBqbMybScc
         gq7/B4TtEwXLJkk3U0I/VF1/BOWli9bteBf/FHomvSizWQ+3/qf/FTWBdAgmdeolig
         JOGMXG2UwVOX3w5PFLe9z+2SorlznJISlrSLAR3k=
Date:   Tue, 18 Jun 2019 18:10:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
Message-ID: <20190618161036.GA28190@kroah.com>
References: <CA+G9fYs2+-yeYcx7oe228oo9GfDgTuPL1=TemT3R20tzCmcjsw@mail.gmail.com>
 <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:31:16AM -0400, Willem de Bruijn wrote:
> On Tue, Jun 18, 2019 at 7:27 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > selftests: net: udpgso_bench.sh failed on 4.19, 4.14, 4.9 and 4.4 branches.
> > PASS on stable branch 5.1, mainline and next.
> > This failure is started happening on 4.19 and older kernel branches after
> > kselftest upgrade to version 5.1
> 
> Does version 5.1 here mean running tests from Linux 5.1, against older kernels?
> 
> > Is there any possibilities to backport ?
> >
> > Error:
> > udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
> 
> MSG_ZEROCOPY for UDP was added in commit b5947e5d1e71 ("udp:
> msg_zerocopy") in Linux 5.0.
> 
> The selftest was expanded with this feature in commit db63e489c7aa
> ("selftests: extend zerocopy tests to udp"), also in Linux 5.0.
> 
> Those tests are not expected to pass on older kernels.

Any way to degrade gracefully if the feature is not present at all in
the kernel under test?  People run the latest version of kselftests on
older kernels all the time.

thanks,

greg k-h
