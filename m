Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23162A0196
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgJ3JjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbgJ3JjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604050749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fm0ZVm7akPVJc7xPvnMJq/4eEAzASQBXeh98B9G5+Vk=;
        b=c4OXfmWrMOejjFLoFIrK3q5r88w2EqjgGCMxotgbvnpRt/v91mWms2VoJ9AYaQjv7HNS2E
        lJjjxvZClwNTS9qDhjXvUNPBaclr9yCOG5f/0RDCwRfaOukLEHrKX7CtJATtjNSE7gbkvo
        OZL13rGFbl3OfbiHYtOShZCxt7/wI7A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-d1-VdW_HNV--8kAzQ4tACg-1; Fri, 30 Oct 2020 05:39:07 -0400
X-MC-Unique: d1-VdW_HNV--8kAzQ4tACg-1
Received: by mail-wr1-f69.google.com with SMTP id t17so2443224wrm.13
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fm0ZVm7akPVJc7xPvnMJq/4eEAzASQBXeh98B9G5+Vk=;
        b=RtkfQBraA2kKNyWD9gCcR7bR36d7h62v+8jallgq5vvKdaK3LOwsExO5jyA1zjExGo
         jgqtC19ud+HqiPUy0TOCNuO0gCZRBqbP5UiXwYRyUGsra6sGVVzT4yOuN/zWgIK7SIbi
         yB3AUOac0Y55/2DGUaipMovCcEO3vNIHMKh1wUEO/Zxxhpr/KZ9YB4grUP69ouibJQIs
         kVjYmg8xJwyLA134ysHsstBNoT+U8fJtTeUR8nZLiunJNl4QidPx+Z5PJ/5Umu3FORC2
         ahrh/DdBn15dU8UnLIPlMizBd1Xk99LFOplFqSVCb7wgmRGqn+11qQc/VN+L/3nrt317
         bU0g==
X-Gm-Message-State: AOAM532B7KKcZ+UPs74a9iLWpLa6k+EARsRCfQ78BEOJ5fnBaxtnDEvw
        TlRFKCd89lz8zvBbIAucWCqPOhht5xuAdWgBnJM50P8jM1u8xwjs+dxDkm8wB7d4u/LNvMG6fI/
        tIgyqY08YT9s8cyK7
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr1800383wrn.427.1604050745965;
        Fri, 30 Oct 2020 02:39:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxUNf4D9Jk0R9n9RI12vwOojD+hKY323KAt7Ew5A1OtZsMOF6pyC7ZN5khcI9q/u8Zk7U4xg==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr1800368wrn.427.1604050745815;
        Fri, 30 Oct 2020 02:39:05 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id k18sm9812725wrx.96.2020.10.30.02.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 02:39:04 -0700 (PDT)
Date:   Fri, 30 Oct 2020 10:39:03 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net] selftests: add test script for bareudp tunnels
Message-ID: <20201030093903.GA5719@pc-2.home>
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
 <20201028183416.GA26626@pc-2.home>
 <CA+FuTSfs1ZsEuu4vKojEU_Bo=DibWDbPPXrw3f=2L6+UAr6UZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfs1ZsEuu4vKojEU_Bo=DibWDbPPXrw3f=2L6+UAr6UZw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 02:11:38PM -0400, Willem de Bruijn wrote:
> On Wed, Oct 28, 2020 at 10:27 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
> > > Test different encapsulation modes of the bareudp module:
> >
> > BTW, I was assuming that kselftests were like documentation updates,
> > and therefore always suitable for the net tree. If not, the patch
> > applies cleanly to net-next (and I can also repost of course).
> 
> I think that's where it belongs.

Hum, do you mean to net or to net-next?

> Very nice test, I don't have any detailed comments. Just one high level:
> 
> Are all kernel dependencies for the test captured in
> tools/testing/selftests/net/config? I think mirred is absent, for
> instance

Thanks! I didn't realise that we had this config file. I'll add the
build dependencies in v2.

