Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1B1BAD77
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgD0TDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgD0TDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 15:03:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28DB216FD;
        Mon, 27 Apr 2020 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588014183;
        bh=xQLf68e8EDOZCKmNCjf8GllXGeJRC7Dy8MkcjuxX9lM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yektJv63+EJv5Pp3A+ezkT9aBBwbBGOQaFytGTcr4MWAKzCsY08nB/Bw5sjQWbsQp
         QpU2EwsIzPO35CHXuWCtPGq73uPVCsIjXhLTSiJRJ/8NREVkeqiloaDekaXaVy8IB2
         xGg+XnXP8wREAFJrekspK1j0RgdWiTf5fFHkY9c8=
Date:   Mon, 27 Apr 2020 12:03:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 08/17] net: atlantic: A2
 driver-firmware interface
Message-ID: <20200427120301.693525a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
References: <20200424174447.0c9a3291@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200424.182532.868703272847758939.davem@davemloft.net>
        <d02ab18b-11b4-163c-f376-79161f232f3e@marvell.com>
        <20200426.180505.1265322367122125261.davem@davemloft.net>
        <e34bcab1-303e-a4bd-862c-125f254e93d3@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 18:38:21 +0300 Igor Russkikh wrote:
> >>>  
> >>>> On Fri, 24 Apr 2020 10:27:20 +0300 Igor Russkikh wrote:  
> >>>>> +/* Start of HW byte packed interface declaration */
> >>>>> +#pragma pack(push, 1)  
> >>>>
> >>>> Does any structure here actually require packing?  
> >>>
> >>> Yes, please use the packed attribute as an absolute _last_ resort.  
> >>
> >> These are HW bit-mapped layout API, without packing compiler may screw  
> > up  
> >> alignments in some of these structures.  
> > 
> > The compiler will not do that if you used fixed sized types properly.
> > 
> > Please remove __packed unless you can prove it matters.  
> 
> Just double checked the layout without packed pragma, below is what pahole
> diff gives just on one structure.

Okay, then mark the appropriate fields of that structure as packed.
I looked at first 4 structures and they should require no packing.

> Compiler does obviously insert cache optimization holes without pragmas.
> And since these structures are HW mapped API - this all will not work without
> pack(1).

Hm. These are not "cache optimization holes", just alignment.
