Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C11DA5BD
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgESXnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESXnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:43:17 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBF9C061A0E;
        Tue, 19 May 2020 16:43:17 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbBsV-0004NU-41; Wed, 20 May 2020 01:42:32 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 6D1E3100D00; Wed, 20 May 2020 01:42:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a seqcount
In-Reply-To: <20200519161141.5fbab730@hermes.lan>
References: <20200519214547.352050-1-a.darwish@linutronix.de> <20200519214547.352050-2-a.darwish@linutronix.de> <20200519150159.4d91af93@hermes.lan> <87v9kr5zt7.fsf@nanos.tec.linutronix.de> <20200519161141.5fbab730@hermes.lan>
Date:   Wed, 20 May 2020 01:42:30 +0200
Message-ID: <87lfln5w61.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:
> On Wed, 20 May 2020 00:23:48 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> No. We did not. -ENOTESTCASE
>
> Please try, it isn't that hard..
>
> # time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done
>
> real	0m17.002s
> user	0m1.064s
> sys	0m0.375s

And that solves the incorrectness of the current code in which way?
