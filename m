Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B624509C4A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387612AbiDUJ2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387614AbiDUJ1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:27:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CC927B25
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 02:24:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u15so8703143ejf.11
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 02:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O9y8jVKI6JxIPSq3Jo8TtuKyE31dAL3ZHhRdum0T9yI=;
        b=JIYYFcwkt5zz+0bk1ozsOJdhiOuVV4R01nF4cYEd++rF2eFqy4I2HNxmQmnLdz+Waz
         b9bCaFA41bGIBWN2lGT8MmirdB7Gi4cEWKDZoX+EbrHAZWlyGUaNNHg7/AxEGCmZ5Ueo
         hBf9bEK5m5H52qhtJA5Np9wdgKsgKgbLLoyF8qvcCQX1cv0LITHH9ncPXjik/HBvkO9O
         dgt8WipSWtp92rLvkWK1MdAfnUeVlsHuYAZYxAMvJ98+6+rgFIsQRwSmQkelNw++iC3J
         BUIQQoqfnc1zECiis0EhVcuesE7rbgoh52ecGLVexfhhki+kpPfJq34hzMfTrucJwKT+
         50sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O9y8jVKI6JxIPSq3Jo8TtuKyE31dAL3ZHhRdum0T9yI=;
        b=WwGszguQn+vJP5ljzaQItAL0/ZGQQoflblzr+ZxOqg7vyjId2ezeW0nPPwoQGFVeD3
         iyeNs5yW+8dvUNj9SMcHmmTD9v6b/560X5OOTmU1zCJC6fsxPRBvDlSCJEkmaB/y0Td8
         pdoXzomQ6XFVqyRBrgGLA1rtGZuEONUieNJTQ/HDyK/wm90752QxQEFVSH06XKlIQ+/n
         bb56VNLYb0ZQTFMaRskIGZJZGSYcOe6pDYGEehmOwbbtW1JPJ6T6hBKa3s6fgmeWJB13
         ZyojrEj/DhRmws7zP8kC4QLbDVJCN+GTAN6qHA7ENUTFms5xdSXBX9b9iwxlmxaylZfv
         Getw==
X-Gm-Message-State: AOAM531t6HTzMRjxGd596G73oTWpmOfvzoan/O+SQMc4qpcyocftTUxQ
        z73iseKDtzWKBiXdq7M59G/vWLznLOM=
X-Google-Smtp-Source: ABdhPJy2zfRozR/NISd8IQQGEQrZnrNoKcZQyZgT+i/M82t9sEvdqfydYY6lxkgagnoF67+cso3lcA==
X-Received: by 2002:a17:906:9c82:b0:6e1:1d6c:914c with SMTP id fj2-20020a1709069c8200b006e11d6c914cmr21419407ejc.769.1650533071055;
        Thu, 21 Apr 2022 02:24:31 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm7567842eja.55.2022.04.21.02.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 02:24:30 -0700 (PDT)
Date:   Thu, 21 Apr 2022 12:24:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: IPv6 multicast with VRF
Message-ID: <20220421092429.waykidesd7de4q3o@skbuf>
References: <20220420165457.kd5yz6a6itqfcysj@skbuf>
 <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
 <20220420191824.wgdh5tr3mzisalsh@skbuf>
 <a5fdf1dc-61ef-29ba-91c3-5339c4086ec8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5fdf1dc-61ef-29ba-91c3-5339c4086ec8@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 02:40:53PM -0600, David Ahern wrote:
> On 4/20/22 1:18 PM, Vladimir Oltean wrote:
> > On Wed, Apr 20, 2022 at 12:59:45PM -0600, David Ahern wrote:
> >> Did you adjust the FIB rules? See the documentation in the kernel repo.
> >
> > Sorry, I don't understand what you mean by "adjusting". I tried various
> > forms of adding an IPv6 multicast route on eth0, to multiple tables,
> > some routes more generic and some more specific, and none seem to match
> > when eth0 is under a VRF, for a reason I don't really know. This does
> > not occur with IPv4 multicast, by the way.
> >
> > By documentation I think you mean Documentation/networking/vrf.rst.
> > I went through it but I didn't notice something that would make me
> > realize what the issue is.
>
> try this:
>     https://static.sched.com/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
> slide 79 and on

Yeah, that worked. Well, now I know what vrf_prepare() and vrf_cleanup()
from tools/testing/selfteste/net/forwarding/lib.sh are for, I guess..

Thanks for helping and for sharing the presentation.

> >> And add a device scope to the `get`. e.g.,
> >>
> >>     ip -6 route get ff02::1%eth0
> >
> > I'm probably not understanding this, because:
> >
> >  ip -6 route get ff02::1%eth0
> > Error: inet6 prefix is expected rather than "ff02::1%eth0".
>
> ip -6 ro get oif eth0 ff02::1
>
> (too many syntax differences between tools)

Could you explain why specifying the oif is needed here? If I don't do
it, I still can't find the route. Either that, or what would an
application need to do to find the route from the VRF FIB?

 ip -6 route get vrf vrf0 ff02::1
RTNETLINK answers: Network is unreachable
 ip -6 route get vrf vrf0 ff02::1 oif eth0
multicast ff02::1 dev eth0 table 3 proto kernel src 2001:db8:1::1 metric 256 pref medium

For some context, the multicast application I'm trying to get running in
a VRF is mcjoin (https://github.com/troglobit/mcjoin). It will send
packets as long as the interface only has a link-local IPv6 address.
As long as I add a global IPv6 address *and* the netdev is in the VRF
(basically the circumstances from the forwarding selftests), sendto()
fails with -ENETUNREACH.

 ip vrf exec vrf0 mcjoin -s -o -i eth0 ff0e::1 -c 1
Sending IPv6 multicast on eth0 addr, fe80::201:2ff:fe03:401 ifindex: 10, sd: 6
*,ff0e::1: invalid 0     delay 0     gaps 0     reorder 0     dupes 0     bytes 100           packets 1

Total: 1 packets

vs:

 ip addr add 2001:db8:1::1/64 dev eth0
 ip vrf exec vrf0 mcjoin -s -o -i eth0 ff0e::1 -c 1
Sending IPv6 multicast on eth0 addr, 2001:db8:1::1 ifindex: 10, sd: 6
Failed sending mcast to ff2e::1: Network is unreachable
*,ff2e::1: invalid 0     delay 0     gaps 1     reorder 0     dupes 0     bytes 0             packets 0

Total: 0 packets
