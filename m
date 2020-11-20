Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90212BB862
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgKTVeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgKTVeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 16:34:05 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98F1C0613CF;
        Fri, 20 Nov 2020 13:34:04 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kgE2X-00BcGw-Fl; Fri, 20 Nov 2020 22:33:57 +0100
Message-ID: <8ccd245040d047ce1a7ef7332fe001cdc671e047.camel@sipsolutions.net>
Subject: Re: [PATCH net] cfg80211: fix callback type mismatches in
 wext-compat
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 20 Nov 2020 22:33:56 +0100
In-Reply-To: <202011201118.CE625B965@keescook> (sfid-20201120_202702_159340_988FC7C4)
References: <20201117205902.405316-1-samitolvanen@google.com>
         <202011171338.BB25DBD1E6@keescook>
         <CABCJKudJojTh+is8mdMicczgWiTXw+KwCuepmG5gLVmqPWjnHA@mail.gmail.com>
         <202011201118.CE625B965@keescook> (sfid-20201120_202702_159340_988FC7C4)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 11:26 -0800, Kees Cook wrote:
> On Tue, Nov 17, 2020 at 02:07:43PM -0800, Sami Tolvanen wrote:
> > On Tue, Nov 17, 2020 at 1:45 PM Kees Cook <keescook@chromium.org> wrote:
> > > On Tue, Nov 17, 2020 at 12:59:02PM -0800, Sami Tolvanen wrote:
> > > > Instead of casting callback functions to type iw_handler, which trips
> > > > indirect call checking with Clang's Control-Flow Integrity (CFI), add
> > > > stub functions with the correct function type for the callbacks.
> > > 
> > > Oh, wow. iw_handler with union iwreq_data look like really nasty hacks.
> > > Aren't those just totally bypassing type checking? Where do the
> > > callbacks actually happen? I couldn't find them...
> > 
> > The callbacks to these happen in ioctl_standard_call in wext-core.c.
> 
> Thanks! If this is all the 'old compat' code, this patch looks fine. I
> think new stuff should probably encode types in some fashion (rather
> than via wrappers).

Everything mentioning wext has been deprecated for something like 15
years ... so yeah. But people still use it :(

johannes

