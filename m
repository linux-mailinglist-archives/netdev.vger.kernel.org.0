Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36BB1466D0
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAWLfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 06:35:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727312AbgAWLfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 06:35:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579779317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0GG6st7mSzLOBI/v4SeDFdRfgX519rldnWKxwzRETGI=;
        b=b9SNMsOTKRVzFDLpCuh7YMpkwwPCid1DscFsK1raSmatKKBgFNb1prRA9YU2c0JikUg6oq
        7dOq35v7eebTUomw8U5gbgrhemdHdkN5HgD5qmsCTDoXzJC8Vc+fCOys4/775CCHDyBnLe
        mml0t8FZH/n1LNQHCOVMsrSiLYOqGCs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-EE6WQe5kNv-oHMwS1VZB_w-1; Thu, 23 Jan 2020 06:35:14 -0500
X-MC-Unique: EE6WQe5kNv-oHMwS1VZB_w-1
Received: by mail-lj1-f198.google.com with SMTP id f15so934958ljj.11
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 03:35:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0GG6st7mSzLOBI/v4SeDFdRfgX519rldnWKxwzRETGI=;
        b=G5cAHslzjT0KOePydyyJhaNsahncjb3kRRxXX54CjwzW3Bd0JGzESyut2+C25PhWPq
         f31sKGLvvFpmwX7mZPG2/aWQpKxP9iV28Igda36YKr+YjHDPx2NQmr0RXUQ15YXgDjjA
         t0CgMXrxbby7+Wy978eyDNpAXnEOwmzUmb+pLbY4lw6vcr2Nl8VJ+wNq99XCrlo0tLdc
         UuEWAwHUQ1T8q9i0iHH2wY0NO0u3ZzQzziaGm69/QEv472MeQcajARtDxRilqtBL+YpK
         3l3n5Lkjdr0ewdK7VfWfuINvdvpIq3qC27Scg4w5E6uBZi5AQzmv7W+ACakM6O7NH+Zh
         JoMg==
X-Gm-Message-State: APjAAAXrh2Y4J6Io0Cx1I4lFbSDAJM5lzu91Er3uumLv6nwZyCHIVcEU
        JQJAPVUsAopdDnPWaPs0w+aClk0hmT6qp7deiCy1jQTnfmSyg4UoxA+HyLeLUkCbjw12MkByjl0
        BPRlwcOK4Hf1bjRS/
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr22925403ljm.63.1579779313294;
        Thu, 23 Jan 2020 03:35:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhQqaPINvTLBSugrqDB0pEI4x+dpUBYR/GvXDPgp3NJhBP31x2sVjLhwQJ9NfbShqA2lfKmg==
X-Received: by 2002:a05:651c:106f:: with SMTP id y15mr22925386ljm.63.1579779313145;
        Thu, 23 Jan 2020 03:35:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p12sm916576lfc.43.2020.01.23.03.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 03:35:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DEC4F1800F2; Thu, 23 Jan 2020 12:35:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200123014210.38412-4-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 12:35:11 +0100
Message-ID: <87tv4m9zio.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attached
> to the egress path of a device. Add rtnl_xdp_egress_fill and helpers as
> the egress counterpart to the existing rtnl_xdp_fill. The expectation
> is that going forward egress path will acquire the various levels of
> attach - generic, driver and hardware.

How would a 'hardware' attach work for this? As I said in my reply to
the previous patch, isn't this explicitly for emulating XDP on the other
end of a point-to-point link? How would that work with offloaded
programs?

-Toke

