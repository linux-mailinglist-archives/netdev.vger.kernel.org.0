Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEE6C327E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfJALa5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 07:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfJALa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 07:30:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D191882EA;
        Tue,  1 Oct 2019 11:30:57 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19D1260C83;
        Tue,  1 Oct 2019 11:30:49 +0000 (UTC)
Date:   Tue, 1 Oct 2019 13:30:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        mcroce@redhat.com, brouer@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191001133048.108b056a@carbon>
In-Reply-To: <87zhiku3lv.fsf@toke.dk>
References: <cover.1569920973.git.lorenzo@kernel.org>
        <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
        <20191001125246.0000230a@gmail.com>
        <87zhiku3lv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 01 Oct 2019 11:30:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Oct 2019 13:06:36 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Maciej Fijalkowski <maciejromanfijalkowski@gmail.com> writes:
> 
> > On Tue,  1 Oct 2019 11:24:43 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >  
> >> Add basic XDP support to mvneta driver for devices that rely on software
> >> buffer management. Currently supported verdicts are:
> >> - XDP_DROP
> >> - XDP_PASS
> >> - XDP_REDIRECT  
> >
> > You're supporting XDP_ABORTED as well :P any plans for XDP_TX?  
> 
> Wait, if you are supporting REDIRECT but not TX, that means redirect
> only works to other, non-mvneta, devices, right? Maybe that should be
> made clear in the commit message :)

If you implemented XDP_REDIRECT, then it should be trivial to implement
XDP_TX, as you can just convert the xdp_buff to xdp_frame and call your
ndo_xdp_xmit function directly (and do the tail-flush).

Or maybe you are missing a ndo_xdp_xmit function (as Toke indirectly
points out).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
