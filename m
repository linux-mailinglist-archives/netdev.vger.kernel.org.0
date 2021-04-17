Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29371362E66
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhDQHvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:51:14 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:51808 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235685AbhDQHvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 03:51:12 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 13H7oUhZ014279;
        Sat, 17 Apr 2021 09:50:30 +0200
Date:   Sat, 17 Apr 2021 09:50:30 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Keyu Man <kman001@ucr.edu>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Message-ID: <20210417075030.GA14265@1wt.eu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
 <20210417072744.GB14109@1wt.eu>
 <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMqUL6bkp2Dy3AMFZeNLjE1f-sAwnuBWpXH_FSYTSh8=Ac3RKg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 12:42:39AM -0700, Keyu Man wrote:
> How about at least allow the existing queue to finish? Currently a tiny new
> fragment would potentially invalid all previous fragments by letting them
> timeout without allowing the fragments to come in to finish the assembly.

Because this is exactly the principle of how attacks are built: reserve
resources claiming that you'll send everything so that others can't make
use of the resources that are reserved to you. The best solution precisely
is *not* to wait for anyone to finish, hence *not* to reserve valuable
resources that are unusuable by others.

Willy
