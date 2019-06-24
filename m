Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9214551065
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbfFXP3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:29:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46706 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728981AbfFXP3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AuLQsK9hRO1fb6NJfONFwxIOQIE7npgOk1R+t9Ub7ts=; b=fpnySevvVrhdEBV3ijKCActWC
        po7uhKBUpY4QCcVXmmR9NaA+6bVOAV590rzFfaNrM6SKMf6ymxCOx0ZRMdpTY/bcw2H/VxokqTNgW
        ytMc4jvWg9ZZrcWnHFEqOc6uO6ZjGsfJRjvLkNdlM+OeWxU2masdu2fQ4Pu1y8CI/VV8zoTjwMzEk
        IAubmlQGQWwJtTASH66B5tlNGXkYYWfyiKFfDYAWNDIvKAmd9VCw5gu3CCyhEz0VyZ9q21C27hdze
        xXHOcZbM8Py+ijx++l8yICyG3kqfcGt1MuE/4okPB2dyrUaRsnlruaJtxwoftAx33TKuiHjyJMe8T
        w/LGXMdfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfQtH-0000uH-7d; Mon, 24 Jun 2019 15:28:19 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1EA9120A585BA; Mon, 24 Jun 2019 17:28:18 +0200 (CEST)
Date:   Mon, 24 Jun 2019 17:28:18 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 00/15] cleanup cppcheck signed shifting errors
Message-ID: <20190624152818.GX3463@hirez.programming.kicks-ass.net>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624152743.GG3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624152743.GG3436@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 05:27:43PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 24, 2019 at 08:50:50PM +0700, Phong Tran wrote:
> > There are errors with cppcheck 
> > 
> > "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
> 
> As I've already told you; your checker is bad. That is not in face

Bah, fact, typing hard.

> undefined behaviour in the kernel.
> 
> That's not to say you shouldn't clean up the code, but don't give broken
> checkout output as a reason.
