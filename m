Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5E12F8B5
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgACNTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:19:04 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:38545 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgACNTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:19:04 -0500
Date:   Fri, 03 Jan 2020 13:19:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578057542;
        bh=EgfevZt6ZMwl4DISGfvsdGPG17nr00sGLRZI3GwcHlA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=qZR7euC+VTbesmvelpJCRCEe1/2SXH2o3wZOT/tufSZIYrpmIK3P5qh5LMOuykmWZ
         ymWWYrNFdRvk+WHxxyNizOSJmX2w/HnQ/NJOcDya7oxP1N4HYdCq+sV9Z2esQX5QSK
         pzgibBcZ3f/Qq9oGCRWnECV+02NIpgViOu/4uzjI=
To:     Eric Dumazet <edumazet@google.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <5gI82sir9U2gaHqvZgEXtxtdFJnbS_9geSflUCqgXjNKjtQfHmBWsfqaNuauMKKpefp5yrcgF7rs7O65ZBGFXL8mLFODpfc_bmB2ZBUgyQM=@protonmail.com>
In-Reply-To: <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

However, I think that backward compatibility should not be too serious beca=
use sysctl_max_syn_backlog is only enabled when syn_cookies is turned off.

If sysctl_max_syn_backlog is set small, there is no difference between the =
original code and the new code.

Only in the BUG scenarios I mentioned in the patch, the system behavior wil=
l change, but these are corrections that have no impact on users.

It's just that the part of the request retention queue will not be mistaken=
ly occupied, and earlier use of syn cookies instead of filling up the backl=
og.
