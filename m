Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3782CD079B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 08:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfJIGpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 02:45:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60560 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJIGpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 02:45:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iI5iz-0005vw-Ew; Wed, 09 Oct 2019 08:45:29 +0200
Message-ID: <25d120fc154eb3da4185a3e82399cae97ba274f1.camel@sipsolutions.net>
Subject: Re: Potential uninitialized variables in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yizhuo Zhai <yzhai003@ucr.edu>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 09 Oct 2019 08:45:28 +0200
In-Reply-To: <CABvMjLQ0Qgzk74yg4quZG4CMKy8pb6pV3XGm_cg4NRkTiCHaKA@mail.gmail.com>
References: <CABvMjLQ0Qgzk74yg4quZG4CMKy8pb6pV3XGm_cg4NRkTiCHaKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-08 at 14:19 -0700, Yizhuo Zhai wrote:
> Hi All:
> net/wireless/chan.c:
> Inside function cfg80211_chandef_compatible(), variable "c1_pri40",
> " c2_pri40", "c1_pri80" and "c2_pri80" could be uninitialized if
> chandef_primary_freqs() fails. However, they are used later in the if
> statement to decide the control flow, which is potentially unsafe.

I guess theoretically this is right, but the function should only be
called with valid chandefs, and if chandef_primary_freqs() hit the
warning then the chandef certainly wasn't valid.

johannes

