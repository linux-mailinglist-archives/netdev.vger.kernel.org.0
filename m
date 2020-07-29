Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5497F231BC8
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgG2JGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgG2JGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:06:14 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF71C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 02:06:14 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 1552B58718807; Wed, 29 Jul 2020 11:06:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 11A9A60C4AEA0;
        Wed, 29 Jul 2020 11:06:11 +0200 (CEST)
Date:   Wed, 29 Jul 2020 11:06:11 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] net: make sockptr_is_null strict aliasing safe
In-Reply-To: <63bc30d717314a378064953879605e7c@AcuMS.aculab.com>
Message-ID: <nycvar.YFH.7.77.849.2007291104100.28290@n3.vanv.qr>
References: <20200728163836.562074-1-hch@lst.de> <20200728163836.562074-3-hch@lst.de> <63bc30d717314a378064953879605e7c@AcuMS.aculab.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wednesday 2020-07-29 10:04, David Laight wrote:
>From: Christoph Hellwig <hch@lst.de>
>> Sent: 28 July 2020 17:39
>> 
>> While the kernel in general is not strict aliasing safe we can trivially
>> do that in sockptr_is_null without affecting code generation, so always
>> check the actually assigned union member.
>
>Even with 'strict aliasing' gcc (at least) guarantees that
>the members of a union alias each other.
>It is about the only way so safely interpret a float as an int.

The only?

  float given;
  int i;
  memcpy(&i, &given, sizeof(i));
  BUILD_BUG_ON(sizeof(i) > sizeof(given));
