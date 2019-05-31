Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86DF31742
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfEaWhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfEaWhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 18:37:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 248383082E4D;
        Fri, 31 May 2019 22:37:45 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5181119C69;
        Fri, 31 May 2019 22:37:38 +0000 (UTC)
Date:   Sat, 1 Jun 2019 00:37:36 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190601003736.65cb6a61@carbon>
In-Reply-To: <20190531170332.GB3694@khorivan>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
        <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
        <20190531174643.4be8b27f@carbon>
        <20190531162523.GA3694@khorivan>
        <20190531183241.255293bc@carbon>
        <20190531170332.GB3694@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 31 May 2019 22:37:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 20:03:33 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Probably it's not good example for others how it should be used, not
> a big problem to move it to separate pools.., even don't remember why
> I decided to use shared pool, there was some more reasons... need
> search in history.

Using a shared pool is makes it a lot harder to solve the issue I'm
currently working on.  That is handling/waiting for in-flight frames to
complete, before removing the mem ID from the (r)hashtable lookup.  I
have working code, that basically remove page_pool_destroy() from
public API, and instead lets xdp_rxq_info_unreg() call it when
in-flight count reach zero (and delay fully removing the mem ID).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
