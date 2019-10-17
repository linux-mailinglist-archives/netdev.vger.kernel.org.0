Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C62DB550
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391789AbfJQR7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:59:33 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55248 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729325AbfJQR7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:59:33 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4153C800084;
        Thu, 17 Oct 2019 17:59:31 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 17 Oct
 2019 10:59:24 -0700
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        <saeedm@mellanox.com>, <vishal@chelsio.com>, <vladbu@mellanox.com>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-4-pablo@netfilter.org>
 <20191016163651.230b60e1@cakuba.netronome.com>
 <20191017161157.rr4lrolsjbnmk3ke@salvia>
 <20191017162237.h4e6bdoosd5b2ipj@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c4d14782-25dd-11a1-4147-2d8547ced3d1@solarflare.com>
Date:   Thu, 17 Oct 2019 18:59:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191017162237.h4e6bdoosd5b2ipj@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24982.005
X-TM-AS-Result: No-10.700600-4.000000-10
X-TMASE-MatchedRID: 9vvqFUF7IWkbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizx68+i8GTH6noXs
        ThVwDUvYkZy8iW8THfMA/Q43xHXqxxc1U+EFS2my7+etKcKRtq6wqLgRdvwAikGDUY9EEYrsR+X
        4fj4ypMkjk5nJ43ka/Qz9pU3X9LWh6sRuS6yGtfT27WtDgGBc8uChnL3c+k98VI7KaIl9Nhc73D
        IZt1OvmVfk7+g08q3sxAdO595FIkHm8Tq/Qity6k+zv2ByYSDQnzPrJkGalpCsIKZ2EtsOgnFaJ
        RjHZFgbSRvuKtM0SbVAusMt0rqlzLQYXgk3R5pdUPktDdOX0fv5qGeseGYAlPQkrXkUDmL194do
        8m0JE5JaVofDcjXVSCBFdNGSzsPuSURlVF5LmCyQmLXB14cW2joSfZud5+Ggy5JfHvVu9It4wWi
        C1lUZQqsS/YcdHdrDowGZK1+ebLYE2uNXYzS5v/SG/+sPtZVkLUKRFvXchm5QKAQSutQYXNxwX6
        9jh9hhn1rHCTKgIH9mWH64atfLC3Ze/7gEt+VklTsGW3DmpUsB4JHtiamkLAp+tuYb4NtQbfuQO
        2/rMosuLbwcx7geGUnzu99Xkc4W9wWUtZcWqU6KR0fcRBoRNcK2EIRFRDecwEgSPNlM5Q139f9f
        xq2qS5SKO/2nz9g59EIQaSiFQKwM8jMXjBF+sIMbH85DUZXyAPpGmOpAZoX6C0ePs7A07cNbTFV
        OzjU8LjRQdZg/woqNeKuk+fEdYymBMk2frH0zYoFYygu1lts=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.700600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24982.005
X-MDID: 1571335172-VxXwl59WhtBz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/10/2019 17:22, Pablo Neira Ayuso wrote:
> You refer to single u32 word changing both sport and dport.
>
> What's the point with including this in the subset of the uAPI to be
> supported?
What's the point with removing this from the uAPI which implicitly the
 kernel internal layers supported (whether individual drivers did or
 not)?

> In software, it really makes sense to use this representation since it
> is speeding up packet processing.
>
> In hardware, supporting this uAPI really gets you nothing at all.
That depends how the hardware works.  Current hardware tends to do pedit
 offload based on protocol(-ossified) fields, but there's no guarantee
 that every future piece of hardware will be the same.  Someone might
 build HW whose packet-editing part is based on the pedit uAPI approach,
 explicitly designing their HW to support Linux semantics.  And you'd be
 telling them "sorry, we decided to remove part of that uAPI because,
 uhh, well we didn't actually have a reason but we did it anyway".

> We have to document what subset of the uAPI is support through
> hardware offloads. Pretending that we can support all uAPI is not
> true, we only support for tc pedit extended mode right now.
Who's "we"?  AIUI the kernel will pass any pedits to drivers, they don't
 have to be extended mode, and they certainly don't have to have come
 from the iproute2 'tc' binary, so they might not bear any relation to
 the protocol fields tc knows about.
Pedit is supposed to work even in the absence of protocol knowledge in
 the kernel (e.g. in combination with cls_u32, you can filter and mangle
 traffic in a completely new protocol), you're turning it into Yet
 Another Ossified TCP/IP Monoculture.  This is not the direction the
 networking offloads community is trying to move in.

+100 to everything Jakub said, and please remember that some of us have
 to maintain driver support for slightly more than just the latest
 kernel, and your pointless churn makes that much harder.  ("A slow sort
 of country; here, it takes all the running _you_ can do, just to stay
 in the same place.")  I'm not talking about drivers stretching back to
 2.6 era here; we _expect_ that to be painful.  But when code to build
 on as recent as 4.20 is a thicket of clustered ifdefs, without a single
 piece of user-visible functionality being added as a result (and some
 removed; not only are you chopping bits of the pedit API off, but TC
 action stats are *still* broken since 5.1), something is _very_ wrong.

Of course we know the real reason you're making all these API changes is
 for netfilter offload (I have my doubts whether anyone is actually
 using netfilter in the wild; crusties still use iptables and early-
 adopters have all jumped ship to eBPF solutions, but if you're so
 desperate for netfilter to remain relevant I suppose we have to humour
 you at least a little), but there's absolutely no technical reason I
 can see why netfilter couldn't translate its mangles into existing
 pedit language.  If patch 3 is truly and unavoidably a prerequisite of
 patch 4, you'll need to explain why if you want a sympathetic hearing.

-Ed
