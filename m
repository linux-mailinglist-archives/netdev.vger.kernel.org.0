Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868001BA7CF
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgD0PVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:21:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36828 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgD0PVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588000870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rfbHnNnXO6uCqGbzPWFWTVkqGUYgJmGrSHg5SptyPOU=;
        b=LJywP+91Qiw9k5gnGb8yfedB+HjRpiQqT4g6AKMYr2+ZY3tauhMrP7MSqtjcDo8dWfYU7s
        +R9ELE5UkkZmdzW5nkvTCn37sZRpjYm7l5D+y6WZqU8ppwZ2+IAMYeXn0w/CSC608AYZun
        f6sF6/NBSY+8j9/sUWl0Z0RyvwxuO+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-arcoMcCnO0OpPbwOK6bz1Q-1; Mon, 27 Apr 2020 11:21:05 -0400
X-MC-Unique: arcoMcCnO0OpPbwOK6bz1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EA8319200F2;
        Mon, 27 Apr 2020 15:21:03 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D20A56062E;
        Mon, 27 Apr 2020 15:20:51 +0000 (UTC)
Date:   Mon, 27 Apr 2020 17:20:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next 07/33] xdp: xdp_frame add member frame_sz and
 handle in convert_to_xdp_frame
Message-ID: <20200427172050.08053c2d@carbon>
In-Reply-To: <5c929d29-8cf8-de81-3b96-f63a9195c735@gmail.com>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757167661.1370371.5983006045491610549.stgit@firesoul>
        <5c929d29-8cf8-de81-3b96-f63a9195c735@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Apr 2020 12:24:07 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> > +/* Avoids inlining WARN macro in fast-path */
> > +void xdp_warn(const char* msg, const char* func, const int line);
> > +#define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)  
> 
> Shouldn't this have WARN_ONCE()-like mechanism?
> A buggy driver may generate massive amount of dump messages...

Well, in this use-case I think I want it be loud.  I usually miss those
WARN_ONCE messages, and I while extending and testing drivers, it was
an advantage that is was loud, as it caught some of my own bugs.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

