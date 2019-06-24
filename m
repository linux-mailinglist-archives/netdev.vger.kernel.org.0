Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB3502C8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfFXHLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:11:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbfFXHLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 03:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RQ35CdI7OgSCvNIJDvf1p+BfUv8hYylGCi0q85yv+Yw=; b=baaTIpENIFYajuYTAHyVtoJWM
        a1DUikSr096fgOD3KX66qiitLLwEMKxstZe8F41v2bSIUYioz/6i/Vb3pW05jvnSnC5RPE6dMcTgk
        FedZTCJIKdzczm2PnKEbJfSoyTfz35zM5fMJsM0iTkOxlNBkJIIR1i0sUUDu1qFJyoqUqf5O1fwMa
        l74AR53sr2mYYr4dztHj0eXb6WjQaYg+uj0apZv4X+6qDpy7TCzvXnv803NPjM0irg441yMX68Br0
        7M3ZzB6dbVUOAGX2i68AXvhyavS/LvKi+Yk7Gl2BqJiPyfGlLda1wsZU/Dj3y2X8MalupSjMainTx
        eExFIV/+A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfJ8O-0002ZO-91; Mon, 24 Jun 2019 07:11:24 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D17A920A021ED; Mon, 24 Jun 2019 09:11:21 +0200 (CEST)
Date:   Mon, 24 Jun 2019 09:11:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, nsekhar@ti.com,
        ast@kernel.org, jolsa@redhat.com, netdev@vger.kernel.org,
        gerg@uclinux.org, lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        festevam@gmail.com, gregory.clement@bootlin.com,
        allison@lohutok.net, linux@armlinux.org.uk, krzk@kernel.org,
        haojian.zhuang@gmail.com, bgolaszewski@baylibre.com,
        tony@atomide.com, mingo@redhat.com, linux-imx@nxp.com, yhs@fb.com,
        sebastian.hesselbarth@gmail.com, illusionist.neo@gmail.com,
        jason@lakedaemon.net, liviu.dudau@arm.com, s.hauer@pengutronix.de,
        acme@kernel.org, lkundrak@v3.sk, robert.jarzmik@free.fr,
        dmg@turingmachine.org, swinslow@gmail.com, namhyung@kernel.org,
        tglx@linutronix.de, linux-omap@vger.kernel.org,
        alexander.sverdlin@gmail.com, linux-arm-kernel@lists.infradead.org,
        info@metux.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, alexander.shishkin@linux.intel.com,
        hsweeten@visionengravers.com, kgene@kernel.org,
        kernel@pengutronix.de, sudeep.holla@arm.com, bpf@vger.kernel.org,
        shawnguo@kernel.org, kafai@fb.com, daniel@zonque.org
Subject: Re: [PATCH 01/15] arm: perf: cleanup cppcheck shifting error
Message-ID: <20190624071121.GN3436@hirez.programming.kicks-ass.net>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190623151313.970-2-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623151313.970-2-tranmanphong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:12:59PM +0700, Phong Tran wrote:
> fix "Shifting signed 32-bit value by 31 bits is undefined behaviour
> errors"
> 
> [arch/arm/kernel/perf_event_v7.c:1080]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
> [arch/arm/kernel/perf_event_v7.c:1436]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
> [arch/arm/kernel/perf_event_v7.c:1783]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour

I don't think that is true; the kernel uses -fno-strict-overflow (which
implies -fwrapv) and that takes away all the signed UB.
