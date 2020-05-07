Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A194B1C7E80
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgEGAWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgEGAWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:22:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB37C061A0F;
        Wed,  6 May 2020 17:22:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6BC81277C589;
        Wed,  6 May 2020 17:22:05 -0700 (PDT)
Date:   Wed, 06 May 2020 17:22:05 -0700 (PDT)
Message-Id: <20200506.172205.208972233468631933.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dav.lebrun@gmail.com
Subject: Re: [net] seg6: fix SRH processing to comply with RFC8754
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504144211.5613-1-ahabdels@gmail.com>
References: <20200504144211.5613-1-ahabdels@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:22:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>
Date: Mon,  4 May 2020 14:42:11 +0000

> The Segment Routing Header (SRH) which defines the SRv6 dataplane is defined
> in RFC8754.
> 
> RFC8754 (section 4.1) defines the SR source node behavior which encapsulates
> packets into an outer IPv6 header and SRH. The SR source node encodes the
> full list of Segments that defines the packet path in the SRH. Then, the
> first segment from list of Segments is copied into the Destination address
> of the outer IPv6 header and the packet is sent to the first hop in its path
> towards the destination.
> 
> If the Segment list has only one segment, the SR source node can omit the SRH
> as he only segment is added in the destination address.
> 
> RFC8754 (section 4.1.1) defines the Reduced SRH, when a source does not
> require the entire SID list to be preserved in the SRH. A reduced SRH does
> not contain the first segment of the related SR Policy (the first segment is
> the one already in the DA of the IPv6 header), and the Last Entry field is
> set to n-2, where n is the number of elements in the SR Policy.
> 
> RFC8754 (section 4.3.1.1) defines the SRH processing and the logic to
> validate the SRH (S09, S10, S11) which works for both reduced and
> non-reduced behaviors.
> 
> This patch updates seg6_validate_srh() to validate the SRH as per RFC8754.
> 
> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>

Applied, thanks.
