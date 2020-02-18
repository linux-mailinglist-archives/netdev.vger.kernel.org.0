Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318A6163776
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgBRXsa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Feb 2020 18:48:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRXs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:48:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2536915B7527F;
        Tue, 18 Feb 2020 15:48:29 -0800 (PST)
Date:   Tue, 18 Feb 2020 15:48:28 -0800 (PST)
Message-Id: <20200218.154828.858448801341482999.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     toke@redhat.com, kuba@kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, andrew@lunn.ch, brouer@redhat.com,
        dsahern@kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <703ce998-e454-713c-fc7a-d5f1609146d8@iogearbox.net>
References: <20200218132921.46df7f8b@kicinski-fedora-PC1C0HJN>
        <87eeury1ph.fsf@toke.dk>
        <703ce998-e454-713c-fc7a-d5f1609146d8@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 15:48:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Wed, 19 Feb 2020 00:19:36 +0100

> On 2/18/20 11:23 PM, Toke Høiland-Jørgensen wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>>> On Tue, 18 Feb 2020 01:14:29 +0100 Lorenzo Bianconi wrote:
>>>> Introduce "rx" prefix in the name scheme for xdp counters
>>>> on rx path.
>>>> Differentiate between XDP_TX and ndo_xdp_xmit counters
>>>>
>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>
>>> Sorry for coming in late.
>>>
>>> I thought the ability to attach a BPF program to a fexit of another
>>> BPF
>>> program will put an end to these unnecessary statistics. IOW I
>>> maintain
>>> my position that there should be no ethtool stats for XDP.
>>>
>>> As discussed before real life BPF progs will maintain their own stats
>>> at the granularity of their choosing, so we're just wasting datapath
>>> cycles.
> 
> +1

Bugs in bpf programs leading to lack of fundamental statistics.

I think that is absolutely the wrong tradeoff.

And if performance is a concern, we can have a knob to turn off
the xdp counter bumps.  This is something I totally support.
