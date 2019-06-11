Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA513D3E6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406072AbfFKRWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:22:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42181 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405821AbfFKRWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:22:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id l19so4728726pgh.9
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 10:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=o5FSqNp2JqSYjY0k2S39i20Wh63EY9+cEp/F5oCK1Q8=;
        b=QDp1et69MBe6cly96tjCGQFSKE3XUHvd3SIo5Inr9BO1GHhIZbXa3z/kJ14yU84lEO
         eRhLMzAhC0GlhWUM9xq8oc/VC3XyXQXj5DkPvoN6lqOUXAYG40MDsWi9VPBXVxNQWxSO
         bKiehEo23lW1PnZXsQonHoNFwYYKytnaal/eIROexSEpYiQsTrEZU/8f08AMCK2gpluU
         OaA/H3qc1s0YW0jVNxl1rQ84s4BGoVrevgUW1M/1kitnsoo2s6v/ClQxMfE9fNKs3AKZ
         l0bOs0IezglJVYoUT3BtCPohPkl7WijVhhI+Gh7cKLos9Jq3OcDL04sJ6Ksh4gUcMCMM
         NhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=o5FSqNp2JqSYjY0k2S39i20Wh63EY9+cEp/F5oCK1Q8=;
        b=oC5J+1aSMybbj1mZs59D9ep0PLRQy90t8wb2e/lYf+RlrhRaWO/UUwQp/S2wsccWTi
         9SjsELquti0tuqRZeQghulCjC9JXTBfnVrHWumn5Ghq6J5P/RoQAucv97bHcEQKcDZ1Z
         foUHkLQAAucjelWT+P4WuCDwyQmpc+dlpDsmqZAYdaoSUcqu8zK71bICaiokcGjR75Ox
         P5tn9h96YCquLetWkzyiGubG6Sg7YjVSXK62n8ovOrh0Y4qBn2OoMeQH+RGeSiLGTKvC
         g4ctW+d59bw/abHxJWc/9p27MhzywedLmkkg4lv6lsvi28a/1TdJrhe1ZwGXiXR8nOCs
         8IHw==
X-Gm-Message-State: APjAAAU/eirzLWa1+qEsY0ZzGAwz6Jvy7NSs2v2sDzBCCzqgX61iwe0/
        diKchhe3wM4Y3lCqrw05m46ynw==
X-Google-Smtp-Source: APXvYqx9a7yYBlTTawFLBIIOUEhitc2xs2UdVsUe6gCzfM+WxBWbzXuDp1BZVorREBq8+/KzxNOEig==
X-Received: by 2002:a63:2b8a:: with SMTP id r132mr20991679pgr.196.1560273769273;
        Tue, 11 Jun 2019 10:22:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x6sm14211368pgr.36.2019.06.11.10.22.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 10:22:49 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:22:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, saeedm@mellanox.com
Subject: Re: [PATCH bpf-next v3 0/5] net: xdp: refactor XDP program queries
Message-ID: <20190611102245.1565e742@cakuba.netronome.com>
In-Reply-To: <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
        <20190610152433.6e265d6c@cakuba.netronome.com>
        <980c54f7-e270-f6cf-089d-969cebad8f38@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 09:24:41 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On 2019-06-11 00:24, Jakub Kicinski wrote:
> > On Mon, 10 Jun 2019 18:02:29 +0200, Bj=C3=B6rn T=C3=B6pel wrote: =20
> >> Jakub, what's your thoughts on the special handling of XDP offloading?
> >> Maybe it's just overkill? Just allocate space for the offloaded
> >> program regardless support or not? Also, please review the
> >> dev_xdp_support_offload() addition into the nfp code. =20
> >=20
> > I'm not a huge fan of the new approach - it adds a conditional move,
> > dereference and a cache line reference to the fast path :(
> >=20
> > I think it'd be fine to allocate entries for all 3 types, but the
> > potential of slowing down DRV may not be a good thing in a refactoring
> > series.
> >  =20
>=20
> Note, that currently it's "only" the XDP_SKB path that's affected, but
> yeah, I agree with out. And going forward, I'd like to use the netdev
> xdp_prog from the Intel drivers, instead of spreading/caching it all over.
>=20
> I'll go back to the drawing board. Any suggestions on a how/where the
> program should be stored in the netdev are welcome! :-) ...or maybe just
> simply store the netdev_xdp flat (w/o the additional allocation step) in
> net_device. Three programs and the boolean (remove the num_progs).

Three progs?  Are we planning to allow SKB and DRV at the same time?
One prog and flags looked fairly reasonable to me.  Flags can even be
a u8.  The offload prog can continue to live in the driver.
