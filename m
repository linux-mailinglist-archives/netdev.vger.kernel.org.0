Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2039D36D68
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFFHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:36:16 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:35761 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfFFHgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:36:16 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hYmwV-0007y5-IZ; Thu, 06 Jun 2019 09:36:12 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hYmwV-0003SS-D5; Thu, 06 Jun 2019 09:36:11 +0200
Date:   Thu, 6 Jun 2019 09:36:11 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: EoGRE sends undersized frames without padding
Message-ID: <20190606073611.7n2w5n52pfh3jzks@sesse.net>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
 <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
 <20190605072712.avp3svw27smrq2qx@sesse.net>
 <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 06:17:51PM -0700, Cong Wang wrote:
> Hmm, sounds like openvswitch should pad the packets in this scenario,
> like hardware switches padding those on real wires.

Well, openvswitch say that they just throw packets around and assume they're
valid... :-)

In any case, if you talk EoGRE to the vWLC directly, I doubt it accepts this,
given that it doesn't accept it on the virtual NICs.

>> Yes, but that's just Linux accepting something invalid, no? It doesn't mean
>> it should be sending it out.
> Well, we can always craft our own ill-formatted packets, right? :) Does
> any standard say OS has to drop ethernet frames shorter than the
> minimum?

I believe you're fully allowed to accept them (although it might be
technically difficult on physical media). But that doesn't mean everybody
else has to accept them. :-)

>>> Some hardware switches pad for ETH_ZLEN when it goes through a real wire.
>> All hardware switches should; it's a 802.1Q demand. (Some have traditionally
>> been buggy in that they haven't added extra padding back when they strip the
>> VLAN tag.)
> If so, so is the software switch, that is openvswitch?

What if the other end isn't a (virtual) switch, but a host?

/* Steinar */
-- 
Homepage: https://www.sesse.net/
