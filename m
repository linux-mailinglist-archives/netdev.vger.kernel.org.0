Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18FC461FA4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378722AbhK2S4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbhK2SyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:54:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9C1C08C5D9;
        Mon, 29 Nov 2021 07:12:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA65561241;
        Mon, 29 Nov 2021 15:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D53C004E1;
        Mon, 29 Nov 2021 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638198778;
        bh=ADugjtCiZDrN0uMz5QUqwcnpM502BuoI8JK5TuLR/TQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oBqGzch9xCxxoCk/dkSODXpuKnct+4tCjUz5AysRge2uuv4d3CUMW2fUgaqiehGBU
         D2cjRYWfRm9JCvKbh12m5qNfI7nZmcuSbQFvEUmd8pJ6zrGueZ4sRGCoDPHEf3ci/q
         +ZjG1zJ/Xeu2WQwvgi356I5poy65nD9I9TAW7oKBb1Ik5zmp2rG2gPkLoLE4QOupFZ
         11PRmHtLyAgQr/p5G2drpNiT1Gb0v6n1SEiQk4zEhg1sUIF2u8BniNXySDX968WXDg
         sDCi/Z6IkJfdjmNnOUdI1iiDa7EvL9hEE5A1q8H4f6HcGg4DRwaYimYsEdXHnzD2Lb
         mGOHXk8jI1x9w==
Date:   Mon, 29 Nov 2021 07:12:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
Message-ID: <20211129071257.302c6c0e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f96722557fbde5b9711da8d53c709858c03af47.camel@redhat.com>
References: <cover.1637924200.git.pabeni@redhat.com>
        <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
        <20211126101941.029e1d7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8f6f900b2b48aaedf031b20a7831ec193793768b.camel@redhat.com>
        <5f96722557fbde5b9711da8d53c709858c03af47.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 15:56:33 +0100 Paolo Abeni wrote:
> On Fri, 2021-11-26 at 19:57 +0100, Paolo Abeni wrote:
> > On Fri, 2021-11-26 at 10:19 -0800, Jakub Kicinski wrote:  
> > > Since we have to touch all the drivers each time the prototype of this
> > > function is changed - would it make sense to pass in rxq instead? It has
> > > more info which may become useful at some point.  
> > 
> > I *think* for this specific scenario the device name provides all the
> > necessary info - the users need to know the driver causing the issue.
> > 
> > Others similar xdp helpers - e.g. trace_xdp_exception() - have the same
> > arguments list used here. If the rxq is useful I guess we will have to
> > change even them, and touch all the drivers anyway.  
> 
> Following the above reasoning I'm going to post v3 with the same
> argument list used here, unless someone stops me soon ;)

It's fine, it was just a thought :)
