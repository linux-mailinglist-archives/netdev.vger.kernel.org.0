Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECE3B93A6
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhGAPCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233252AbhGAPCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625151590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e4QZ42Wn/bTx6wK6v1D/8yVG9mJGX11j52pQnpcYUjg=;
        b=Qno5Dr+FRmYJOUwKn5yU+t8kAR5fFFelO1GVuOFP5TRe0d6aNo1NWdMtIq5GZBuaMWDUm1
        3XGWWgIFYFN5htT1Ltu1B87AEgveeh3i4CRJfanWmZzZ3y8IZyxT8X8NichP8oWj8QjD8F
        Sbezt4KVSqtRQGuZ9XQ50smLn+8hsNQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-CcPFLZXmMeW3GaFFzeHTZA-1; Thu, 01 Jul 2021 10:59:49 -0400
X-MC-Unique: CcPFLZXmMeW3GaFFzeHTZA-1
Received: by mail-wm1-f69.google.com with SMTP id n11-20020a05600c3b8bb02901ec5ef98aa0so1307420wms.0
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 07:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e4QZ42Wn/bTx6wK6v1D/8yVG9mJGX11j52pQnpcYUjg=;
        b=ry+An9ppmFdaBOSUr5qu4RyWAI5KwOjzgfplYQirGGxpfz+ybbF3K3X6atO4Mq1KxB
         PyZsiUWdxsOIyuluiZ5oggePlu2MorPh/JHJIQREVvhTnxGhzhO8IfZgOjaE6MJkQ/mU
         ex80I6Ba+++WZ0809HcIVNtWnAIPTOJFY08x7h2aapmlaXHmYh84yRXLOCxfoWlGIelF
         knZd407jl7JzEemWRbHz2Rere2KHRV4nwn4+63rfdluO92I2GhZO/PaOpzAl3FixEPGT
         i+DvHxKQf7lScVbEmK+PoW6SJKT4p6iZxMdWYk7xJybn+MLvh+l7IZhF9q4kd4LyMKEF
         TZWg==
X-Gm-Message-State: AOAM5329c14Wf/lfsrvJ2Q9aBH2LQ3qmV2nQutQHO5auS4FT3CMT5T/C
        HxM8vcUo0d4WSQzvnAHvX0oGxLFLkZcnyCWkhqmmzIihY9zydnlkv9ThQ3aXuDokBbY01grt6cV
        RxPJT0oNXtjYVT5CN
X-Received: by 2002:adf:a18a:: with SMTP id u10mr87211wru.254.1625151588073;
        Thu, 01 Jul 2021 07:59:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylQNdi0eKL98y1ZKO47m1WjhsyL6LGJE1e0Qjmk6CcaysPiibCLFaSgwpslGmXs2sDfpn7CQ==
X-Received: by 2002:adf:a18a:: with SMTP id u10mr87194wru.254.1625151587908;
        Thu, 01 Jul 2021 07:59:47 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f13sm157913wrt.86.2021.07.01.07.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 07:59:45 -0700 (PDT)
Date:   Thu, 1 Jul 2021 16:59:43 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] selftests: forwarding: Test redirecting gre
 or ipip packets to Ethernet
Message-ID: <20210701145943.GA3933@pc-32.home>
References: <cover.1625056665.git.gnault@redhat.com>
 <0a4e63cd3cde3c71cfc422a7f0f5e9bc76c0c1f5.1625056665.git.gnault@redhat.com>
 <YN1Wxm0mOFFhbuTl@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN1Wxm0mOFFhbuTl@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 08:46:46AM +0300, Ido Schimmel wrote:
> On Wed, Jun 30, 2021 at 02:51:38PM +0200, Guillaume Nault wrote:
> > diff --git a/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
> > new file mode 100644
> > index 000000000000..4c0bf2d7328a
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/forwarding/topo_nschain_lib.sh
> > @@ -0,0 +1,267 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +# A chain of 4 nodes connected with veth pairs.
> > +# Each node lives in its own network namespace.
> 
> Hi,
> 
> The tests under tools/testing/selftests/net/forwarding/ are meant to use
> VRFs as lightweight namespaces. This allows us to run the tests on both
> physical switches with loopback cables and veth pairs, thereby
> validating both the hardware and software datapaths.
> 
> See tools/testing/selftests/net/forwarding/README

It wasn't clear to me that net/forwarding was _only_ for VRF-based
tests.

> If the tests cannot be converted to VRFs, then I suggest moving them to
> tools/testing/selftests/net/

I first tried to write this selftest using VRFs, but there were some
problems that made me switch to namespaces (I don't remember precisely
which ones, probably virtual tunnel devices in collect_md mode).

I'll give VRF another try. And if I can't get to a satisfying solution,
I'll move the selftest under net/.

