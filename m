Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5668CE708D
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 12:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbfJ1Liq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 07:38:46 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40042 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfJ1Liq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 07:38:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP3Lz-0002Q7-6E; Mon, 28 Oct 2019 12:38:31 +0100
Message-ID: <0e6c13812faa01026b55d64c1af500eda048b759.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2019-07-31
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Date:   Mon, 28 Oct 2019 12:38:29 +0100
In-Reply-To: <c062695f8d05a4c36a6d69f421b05208ac51fd2c.camel@sipsolutions.net> (sfid-20191028_120835_987215_F3E3F93B)
References: <20190731155057.23035-1-johannes@sipsolutions.net>
         <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
         <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
         <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
         <c062695f8d05a4c36a6d69f421b05208ac51fd2c.camel@sipsolutions.net>
         (sfid-20191028_120835_987215_F3E3F93B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-28 at 12:08 +0100, Johannes Berg wrote:
> On Mon, 2019-10-28 at 11:53 +0100, Arnd Bergmann wrote:
> > > Why do you say 32-bit btw, it should be *bigger* on 64-bit, but I didn't
> > > see this ... hmm.
> > 
> > That is correct. For historic reasons, both the total amount of stack space
> > per thread and the warning limit on 64 bit are twice the amount that we
> > have on 32-bit kernels, so even though the problem is more serious on
> > 64-bit architectures, we do not see a warning about it because we remain
> > well under the warning limit.
> 
> Hmm, but I have:
> 
> CONFIG_FRAME_WARN=1024
> 
> in my compilation

But the compiler decides not to inline it, for whatever reason. Only if
I mark it as __always_inline, does it actually inline it.

But it does seem to merge the storage, if I inline only assoc_success()
I get 888 bytes (after the fix), if I inline also
ieee80211_rx_mgmt_assoc_resp() then I get 904 bytes.

johannes

