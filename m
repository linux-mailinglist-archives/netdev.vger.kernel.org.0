Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF09F5D220
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBOwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfGBOwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:52:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDECE3092667;
        Tue,  2 Jul 2019 14:52:38 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F2255D6A9;
        Tue,  2 Jul 2019 14:52:32 +0000 (UTC)
Date:   Tue, 2 Jul 2019 16:52:30 +0200
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
Message-ID: <20190702165230.6caa36e3@carbon>
In-Reply-To: <20190702144426.GD4510@khorivan>
References: <20190702153902.0e42b0b2@carbon>
        <156207778364.29180.5111562317930943530.stgit@firesoul>
        <20190702144426.GD4510@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 02 Jul 2019 14:52:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 17:44:27 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:
> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >
> >Jesper recently removed page_pool_destroy() (from driver invocation) and
> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
> >handle in-flight packets/pages. This created an asymmetry in drivers
> >create/destroy pairs.
> >
> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
> >This serves two purposes, (1) simplify drivers error handling as driver now
> >drivers always calls page_pool_destroy() and don't need to track if
> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
> >where a single RX-queue (with a single page_pool) provides packets for two
> >net_device'es, and thus needs to register the same page_pool twice with two
> >xdp_rxq_info structures.  
> 
> As I tend to use xdp level patch there is no more reason to mention (2) case
> here. XDP patch serves it better and can prevent not only obj deletion but also
> pool flush, so, this one patch I could better leave only for (1) case.
 
I don't understand what you are saying.

Do you approve this patch, or do you reject this patch?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
