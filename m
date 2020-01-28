Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8D14C002
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 19:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1Sl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 13:41:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726276AbgA1Sl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 13:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580236915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g505J+OXZAIyrPJs5BzKa+nYQjRA1XdxShMDB6Q8I+g=;
        b=Hhdm/eGpvM7is1r15elWru8Y7yW0UK3Os/Y6D+ZJhDoz5koXCKy0I6Nn8YKHK7cT8U2bUE
        M5x0wfFrXXLo2KozGWL7wdG2EURWw8Z3q6Rthu5/6VVBeVQis3TZvyRyPmQ+QI0LU9Kj+a
        ZgdAAjbGDU6JIATfkj092CgY/cgdiaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-9oQaP31nPSOvdMupnGKybg-1; Tue, 28 Jan 2020 13:41:50 -0500
X-MC-Unique: 9oQaP31nPSOvdMupnGKybg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A315313E5;
        Tue, 28 Jan 2020 18:41:49 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2600F38E;
        Tue, 28 Jan 2020 18:41:37 +0000 (UTC)
Date:   Tue, 28 Jan 2020 19:41:36 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: Created benchmarks modules for page_pool
Message-ID: <20200128194136.4dff1cb2@carbon>
In-Reply-To: <CAGnkfhy4O+VO9u+pGE83qmtce8+OR4Q2s1e9Wdupr-Bo5FU1fg@mail.gmail.com>
References: <20200121170945.41e58f32@carbon>
        <20200122104205.GA569175@apalos.home>
        <20200122130932.0209cb27@carbon>
        <CAGnkfhy4O+VO9u+pGE83qmtce8+OR4Q2s1e9Wdupr-Bo5FU1fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jan 2020 17:22:47 +0100
Matteo Croce <mcroce@redhat.com> wrote:

> On Wed, Jan 22, 2020 at 1:09 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> > On Wed, 22 Jan 2020 12:42:05 +0200  
> > > Interesting, i'll try having a look at the code and maybe run then on
> > > my armv8 board.  
> >
> > That will be great, but we/you have to fixup the Intel specific ASM
> > instructions in time_bench.c (which we already discussed on IRC).
> >  
> 
> What does it need to work on arm64? Replace RDPMC with something generic?

Replacing the RDTSC. Hoping Ilias will fix it for ARM ;-) 

You can also fix yourself via using get_cycles() include <linux/timex.h>.
If the ARCH doesn't have support it will just return 0.

Have you tried it out on your normal x86/Intel box?
Hint:
 https://prototype-kernel.readthedocs.io/en/latest/prototype-kernel/build-process.html
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

