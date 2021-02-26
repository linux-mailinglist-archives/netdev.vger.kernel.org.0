Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8514C326209
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 12:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 06:36:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhBZLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 06:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614339311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sDZwOEVS9t1txKosxZ6AgJPd1yK0dZxFgh8hc7RQj8E=;
        b=T50RlOvQLYgZ5Vf56ucNvbnu1AF/2ynGvZZ/NMThttnypFuaAW/yj38a9mGMBb8j4NjygU
        VSMT5qFoKI/9kAZip0rLyroHZGmHz30cc2owBmnketwSTkoW9ehXxqwsg7vcYhpXReyNOP
        X92tiPNMre4WP7uGt8KaU2hVpkf2AMk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-JiV_CUcZNk-Gwv39ypQYZw-1; Fri, 26 Feb 2021 06:35:09 -0500
X-MC-Unique: JiV_CUcZNk-Gwv39ypQYZw-1
Received: by mail-ed1-f71.google.com with SMTP id t27so2068027edi.2
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 03:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=sDZwOEVS9t1txKosxZ6AgJPd1yK0dZxFgh8hc7RQj8E=;
        b=GMJIYaaIaGL1fWh0oJpcwpAOsIU+TolELuyUow5R5LDidpDcvxLvURWjb26oH2RuYD
         cmA7Yp2yCj6HKJRM4fSlGaORxDm2tLl0VMdIvvZe/4REqvfBdRMvp2El2Erfh82YlibK
         hs2KbthZjnDDCzZnSUklc91p777IEg5iqT7ruwQhoEFv9Col3u9Ip5YHfEgu8PYkAstH
         /4Lt9s6i7HWw3jbK9Bngk0XCFuArIX7v4D+L8hYaZkZVj54QUCO3T8egglj7UvnSxrEF
         iho8GalCd8BrwDKk5a9mBwFdD5L49q19/IDGnICa+AI/pZoDvtLnEgc8bOcCLaH3ve/G
         QFWw==
X-Gm-Message-State: AOAM530PuUDSFZ+0kWRceTFMAjDqR7HOiJH5y5KdnrfWBXus5S6947Wo
        xTAKY2iSXL10iMG99DkXEuCDb0K1KcRvFG3H0FE8xlo2F22jRwRioKweqwCR91fSUejz4w6OauP
        Am9QO0TewuKFEvH7v
X-Received: by 2002:aa7:d58e:: with SMTP id r14mr2688546edq.332.1614339308628;
        Fri, 26 Feb 2021 03:35:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJ+RlYOjg/zeHA4woGsFSGt2uX+17bcQS6qorYsPRKXGF5hGmkznvNlqIdkgMOJB2/ffk+bQ==
X-Received: by 2002:aa7:d58e:: with SMTP id r14mr2688523edq.332.1614339308322;
        Fri, 26 Feb 2021 03:35:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q20sm5186759ejs.17.2021.02.26.03.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 03:35:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9D548180094; Fri, 26 Feb 2021 12:35:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v4 0/2] Optimize
 bpf_redirect_map()/xdp_do_redirect()
In-Reply-To: <20210226112322.144927-1-bjorn.topel@gmail.com>
References: <20210226112322.144927-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Feb 2021 12:35:07 +0100
Message-ID: <87v9afysd0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> Hi XDP-folks,
>
> This two patch series contain two optimizations for the
> bpf_redirect_map() helper and the xdp_do_redirect() function.
>
> The bpf_redirect_map() optimization is about avoiding the map lookup
> dispatching. Instead of having a switch-statement and selecting the
> correct lookup function, we let bpf_redirect_map() be a map operation,
> where each map has its own bpf_redirect_map() implementation. This way
> the run-time lookup is avoided.
>
> The xdp_do_redirect() patch restructures the code, so that the map
> pointer indirection can be avoided.
>
> Performance-wise I got 3% improvement for XSKMAP
> (sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
> machine.
>
> More details in each commit.
>
> @Jesper/Toke I dropped your Acked-by: on the first patch, since there
> were major restucturing. Please have another look! Thanks!

Will do! Did you update the performance numbers above after that change?

-Toke

