Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB1521E4EF
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGNBCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGNBCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 21:02:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0630FC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 18:02:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FA4012986ED4;
        Mon, 13 Jul 2020 18:02:10 -0700 (PDT)
Date:   Mon, 13 Jul 2020 18:02:10 -0700 (PDT)
Message-Id: <20200713.180210.1797175286159137272.davem@davemloft.net>
To:     borisp@mellanox.com
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
References: <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
        <20200713.120530.676426681031141505.davem@davemloft.net>
        <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 18:02:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>
Date: Tue, 14 Jul 2020 01:15:26 +0300

> On 13/07/2020 22:05, David Miller wrote:
>> From: Boris Pismenny <borisp@mellanox.com>
>> Date: Mon, 13 Jul 2020 10:49:49 +0300
>>
>> Why can't the device generate the correct TLS signature when
>> offloading?  Just like for the protocol checksum, the device should
>> load the payload into the device over DMA and make it's calculations
>> on that copy.
> 
> Right. The problematic case is when some part of the record is already
> received by the other party, and then some (modified) data including
> the TLS authentication tag is re-transmitted.

Then we must copy to avoid this.
