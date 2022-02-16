Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC594B819A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiBPHcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:32:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiBPHce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:32:34 -0500
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 23:32:21 PST
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B1012D907;
        Tue, 15 Feb 2022 23:32:20 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id E0BC5201402;
        Wed, 16 Feb 2022 07:15:43 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 6786F806D0; Wed, 16 Feb 2022 08:11:05 +0100 (CET)
Date:   Wed, 16 Feb 2022 08:11:05 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        miaoqing@codeaurora.org, rsalvaterra@gmail.com,
        Jason Cooper <jason@lakedaemon.net>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] ath9k: use hw_random API instead of directly dumping
 into random.c
Message-ID: <Ygyjib2FKY87S7/H@owl.dominikbrodowski.net>
References: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
 <20220215162812.195716-1-Jason@zx2c4.com>
 <87o8374sx3.fsf@toke.dk>
 <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9pZaYW-p=zU4v96TjeSijm-g03cNpvUJcNvhOqh5v+Lwg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, Feb 16, 2022 at 12:52:15AM +0100 schrieb Jason A. Donenfeld:
> On 2/16/22, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> >> @@ -22,9 +22,6 @@
> >>  #include "hw.h"
> >>  #include "ar9003_phy.h"
> >>
> >> -#define ATH9K_RNG_BUF_SIZE	320
> >> -#define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
> >
> > So this comment says "quality: 10/32" but below you're setting "quality"
> > as 320. No idea what the units are supposed to be, but is this right?
> 
> I think the unit is supposed to be how many entropic bits there are
> out of 1024 bits? These types of estimates are always BS, so keeping
> it on the lower end as before seemed right. Herbert can jump in here
> if he has a better idea; that's his jig.

10/32 = 320/1024, so that change is correct.

	Dominik
