Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00D3F7BA2
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhHYRkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhHYRku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629913204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81zHE3jdEOgDiPBleAi5K9urXW1YnLo0WL9p+cxG+C8=;
        b=eQXEqYXIn/wOFweuABaXNGTEBR2glWcSDFsjUec042/b+uMLMKMwOrdIJvb/Z8J7xmrqvz
        3tK0xq3+pn55Yeq2mcCAF4CQphh17olN1gSaG01ur1b19CW/V8Ftz/hR2f8Ex2iQfJwBFX
        moyaqJ7lcXFCEP/N3ikfiPXjrGEgwNs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-j6kvVa7TPCeOURD1Cme4pA-1; Wed, 25 Aug 2021 13:40:03 -0400
X-MC-Unique: j6kvVa7TPCeOURD1Cme4pA-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so1931wmj.8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:40:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=81zHE3jdEOgDiPBleAi5K9urXW1YnLo0WL9p+cxG+C8=;
        b=cVIDG/Wv1QBY19tQwGU+SVjy9hGEbipQCCtXKc5oCHN0D9lm0fZqBtoZfdCrlNqbmd
         cIPSfDV/edRXUS9sjOusjNXpWDmoZk85K84XYtSzFTGN/fdLNOsVjYXs4/JgxHC/vzV3
         mKaynKK4VBoqUmLaToT75s/B0vCsTmVdl2GxSUkfwkYOuZKT9rluUow3QAOB6pK9AUrJ
         fyT9UnhSectjBvmCgyShpqUN/a+OS+OJ/MSKqQTYr1jNHfIMgT1hEinVjflYV5F/N3KG
         y9h5PzznahDI6y9A4buSkSxo0WrVpKmTRbmETTmJyr7RCHLGYrADlucN1dFuK2SOVsos
         x9xA==
X-Gm-Message-State: AOAM5323z0aULagw9qJQQkJwLSSmQd2wh0AnnQON48pvEovWwUxXZUn4
        TYKidWjl7MSWvQ0ggajoBm/l/yLqtNpe5mfv3nluxA7nb+eT/cFYoaANWymitHGRd7/8TNIFWuU
        8HQaGUj3L3ZKO11Md
X-Received: by 2002:a1c:a5c2:: with SMTP id o185mr10515485wme.34.1629913201852;
        Wed, 25 Aug 2021 10:40:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcubUjamC7d/K5QNbPCOIgXUII04FSQZ2I+b3Izje8KQU8I8x/AM5RfXkle7PkRlC4gp4xtw==
X-Received: by 2002:a1c:a5c2:: with SMTP id o185mr10515473wme.34.1629913201569;
        Wed, 25 Aug 2021 10:40:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-233-185.dyn.eolo.it. [146.241.233.185])
        by smtp.gmail.com with ESMTPSA id h12sm270032wmm.29.2021.08.25.10.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 10:40:01 -0700 (PDT)
Message-ID: <066edfb09fb6afcf12533498b5da2fa6366a284c.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests/net: allow GRO coalesce test on veth
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Coco Li <lixiaoyan@google.com>
Date:   Wed, 25 Aug 2021 19:40:00 +0200
In-Reply-To: <CA+FuTSeavsMkRtuLO1EqWjod9ua=Yp4UHnV15+xJJ_6P1gxc7w@mail.gmail.com>
References: <2d9ca8df08aed8dcb8c56554225f8f71db621bbe.1629886126.git.pabeni@redhat.com>
         <CA+FuTSeavsMkRtuLO1EqWjod9ua=Yp4UHnV15+xJJ_6P1gxc7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-25 at 12:17 -0400, Willem de Bruijn wrote:
> On Wed, Aug 25, 2021 at 6:25 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > This change extends the existing GRO coalesce test to
> > allow running on top of a veth pair, so that no H/W dep
> > is required to run them.
> > 
> > By default gro.sh will use the veth backend, and will try
> > to use exiting H/W in loopback mode if a specific device
> > name is provided with the '-i' command line option.
> > 
> > No functional change is intended for the loopback-based
> > tests, just move all the relevant initialization/cleanup
> > code into the related script.
> > 
> > Introduces a new initialization helper script for the
> > veth backend, and plugs the correct helper script according
> > to the provided command line.
> > 
> > Additionally, enable veth-based tests by default.
> 
> Very nice. Thanks for extending the test to be run as part of
> continuous testing over veth, Paolo.
> 
> > +setup_veth_ns() {
> > +       local -r link_dev="$1"
> > +       local -r ns_name="$2"
> > +       local -r ns_dev="$3"
> > +       local -r ns_mac="$4"
> > +       local -r addr="$5"
> > +
> > +       [[ -e /var/run/netns/"${ns_name}" ]] || ip netns add "${ns_name}"
> > +       echo 100000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
> > +       ip link set dev "${ns_dev}" netns "${ns_name}" mtu 65535
> > +       ip -netns "${ns_name}" link set dev "${ns_dev}" up
> > +       if [[ -n "${addr}" ]]; then
> > +               ip -netns "${ns_name}" addr add dev "${ns_dev}" "${addr}"
> > +       fi
> 
> unused? setup_veth_ns is always called with four arguments.

yep. Too much C&P from esiting code :(

I'll send a v2 after some more testing.

Thanks!

Paolo

