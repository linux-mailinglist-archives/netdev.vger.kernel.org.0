Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2083025DBAA
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgIDO2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:28:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730443AbgIDO2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599229684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IwmZ+bkJtm1ptxZ/ECWY3T+CE7HjdpigE1Uh+r6cTW0=;
        b=YP4MEoPBFQKaIOtge/4YcHgdykmnj9kE4kK/odI8VpzhKMvSGvH0uiGpJGSD8a7+O4E8cz
        7pxRCMJQhOGdtVwUJE7OBUir5jFkLFL1pflo54wLu/L7JJIzRwQOUwA1HfSQeluLK3+Hmf
        YRaz5MNmKje4iPd4QsIPun0r58bZTz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-O8hj-laNPdC0L1rxOxwNlw-1; Fri, 04 Sep 2020 10:28:02 -0400
X-MC-Unique: O8hj-laNPdC0L1rxOxwNlw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21AC1A0BC3;
        Fri,  4 Sep 2020 14:28:00 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C23B5D9CC;
        Fri,  4 Sep 2020 14:27:53 +0000 (UTC)
Date:   Fri, 4 Sep 2020 16:27:51 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
Message-ID: <20200904162751.632c4443@carbon>
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 15:53:25 +0200
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On my machine the "one core scenario Rx drop" performance went from
> ~65Kpps to 21Mpps. In other words, from "not usable" to
> "usable". YMMV.

We have observed this kind of dropping off an edge before with softirq
(when userspace process runs on same RX-CPU), but I thought that Eric
Dumazet solved it in 4cd13c21b207 ("softirq: Let ksoftirqd do its job").

I wonder what makes AF_XDP different or if the problem have come back?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

