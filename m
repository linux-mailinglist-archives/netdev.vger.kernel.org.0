Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44405D273
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGBPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:10:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbfGBPKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 11:10:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 232C981DE5;
        Tue,  2 Jul 2019 15:10:39 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 955155D9D3;
        Tue,  2 Jul 2019 15:10:30 +0000 (UTC)
Date:   Tue, 2 Jul 2019 17:10:29 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702171029.76c60538@carbon>
In-Reply-To: <20190702145612.GF4510@khorivan>
References: <20190702153902.0e42b0b2@carbon>
        <156207778364.29180.5111562317930943530.stgit@firesoul>
        <20190702144426.GD4510@khorivan>
        <20190702165230.6caa36e3@carbon>
        <20190702145612.GF4510@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 02 Jul 2019 15:10:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 17:56:13 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Tue, Jul 02, 2019 at 04:52:30PM +0200, Jesper Dangaard Brouer wrote:
> >On Tue, 2 Jul 2019 17:44:27 +0300
> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >  
> >> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:  
> >> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> >
> >> >Jesper recently removed page_pool_destroy() (from driver invocation) and
> >> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
> >> >handle in-flight packets/pages. This created an asymmetry in drivers
> >> >create/destroy pairs.
> >> >
> >> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
> >> >This serves two purposes, (1) simplify drivers error handling as driver now
> >> >drivers always calls page_pool_destroy() and don't need to track if
> >> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
> >> >where a single RX-queue (with a single page_pool) provides packets for two
> >> >net_device'es, and thus needs to register the same page_pool twice with two
> >> >xdp_rxq_info structures.  
> >>
> >> As I tend to use xdp level patch there is no more reason to mention (2) case
> >> here. XDP patch serves it better and can prevent not only obj deletion but also
> >> pool flush, so, this one patch I could better leave only for (1) case.  
> >
> >I don't understand what you are saying.
> >
> >Do you approve this patch, or do you reject this patch?
> >  
> It's not reject, it's proposition to use both, XDP and page pool patches,
> each having its goal.

Just to be clear, if you want this patch to get accepted you have to
reply with your Signed-off-by (as I wrote).

Maybe we should discuss it in another thread, about why you want two
solutions to the same problem.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
