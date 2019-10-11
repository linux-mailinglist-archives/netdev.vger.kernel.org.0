Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5AAD3F8F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfJKMdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 08:33:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35808 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbfJKMdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 08:33:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so11745438wrt.2
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 05:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=kOytMM5gC8Rw7dhUX7I+Kbb6M5MxyF0glkinKL9u21w=;
        b=Bnd5yfCqKUEaKgZOqcY1CN8kvPV2Gr+Q4fywsvrdloeri8uix9ORjvFoTPWg9s38PE
         L6phjBKcq4O5svdzvdGK+0F0IBn4NU4oqEfyvd7vRZD+y1IMPIpxiTsKcMlmtgO7DSYV
         Sy3ij64JmKhmMIPgaaIVVaT3vg5hW8/uIU/4LhATkdavmkvYxYy2pMh4V3Y3aojGsOcs
         g7fcyebHP5q2nEaAMX9ETqiPBaHjiilQd1RVbZkpf2qlQwxyhwK92Tby86JtYJ+hlG/W
         Ylah4FkZGbo9WWpyq2uPxCbkQFm29srzZOiKZ7uxSjkDRZ7J6SY8w8C0jggauuUuTi7y
         vyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=kOytMM5gC8Rw7dhUX7I+Kbb6M5MxyF0glkinKL9u21w=;
        b=t2iEI2p4Pv0DHnMHqbAWawnbm0qdES4ti+QSAzZopVs8empKoPM+0wY+KQ1eubb8t/
         OTejkyjIKRo9lROEQULXKV201lRG5FAx5Isxf5QSETw38Z6/wB274oG7i91AscaLQMVm
         Wl+LrRYlp8i1WUUkUZn/EfmUGbX6D/So9EjS3RG8MmRYE5TIM07fythxnjqBhZAdxNSW
         3B49lrDpIQj/TOwui1Fg5GcZY0V7sd3pww+x2KQ7Ydu8tftsBIrIuapNtkdXhRL7Qc/F
         LK1IX60kshlkCCyLIEL2cOC18lsArZOznUmbS7yVwuD1D09ECU2hQcm18/A+JvZtEd4y
         KmCA==
X-Gm-Message-State: APjAAAXX1/1vr4MvJHhUw2D92pd1UZUfAmyyf4uLQNDEfE91YMs0w99e
        OfkAeN9+zyh1+XkvAMYn+i4ReQ==
X-Google-Smtp-Source: APXvYqyzZbUL8OhStZc+HlgbYhvSwM1wqEHLiHP4k90Cva2Yn7aztLK+n5fiCOQHcg5Dxowki5Fcfg==
X-Received: by 2002:adf:fad1:: with SMTP id a17mr13835488wrs.148.1570797177265;
        Fri, 11 Oct 2019 05:32:57 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id r10sm10685311wml.46.2019.10.11.05.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 05:32:56 -0700 (PDT)
Date:   Fri, 11 Oct 2019 15:32:53 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Message-ID: <20191011123253.GA8693@apalos.home>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191011122329.GA8373@apalos.home>
 <88b9c6742b1169d520376366b683df6c@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88b9c6742b1169d520376366b683df6c@dlink.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander, 

On Fri, Oct 11, 2019 at 03:27:50PM +0300, Alexander Lobakin wrote:
> Hi Ilias,
> 
> Ilias Apalodimas wrote 11.10.2019 15:23:
> > Hi Alexander,
> > 
> > On Thu, Oct 10, 2019 at 05:42:24PM +0300, Alexander Lobakin wrote:
> > > Hi Dave,
> > > 
> > > This series was written as a continuation to commit 323ebb61e32b
> > > ("net: use listified RX for handling GRO_NORMAL skbs"), and also takes
> > > an advantage of listified Rx for GRO. This time, however, we're
> > > targeting at a way more common and used function, napi_gro_receive().
> > > 
> > > There are about ~100 call sites of this function, including gro_cells
> > > and mac80211, so even wireless systems will benefit from it.
> > > The only driver that cares about the return value is
> > > ethernet/socionext/netsec, and only for updating statistics. I don't
> > > believe that this change can break its functionality, but anyway,
> > > we have plenty of time till next merge window to pay this change
> > > a proper attention.
> > 
> > I don't think this will break anything on the netsec driver. Dropped
> > packets
> > will still be properly accounted for
> > 
> 
> Thank you for clarification. Do I need to mention you under separate
> Acked-by in v2?
> 

Well i only checked for the netsec part. I'll try having a look on the whole
patch and send a proper Acked-by if i get some free time!

> > > 
> > > Besides having this functionality implemented for napi_gro_frags()
> > > users, the main reason is the solid performance boost that has been
> > > shown during tests on 1-core MIPS board (with not yet mainlined
> > > driver):
> > > 
> > > * no batching (5.4-rc2): ~450/450 Mbit/s
> > > * with gro_normal_batch == 8: ~480/480 Mbit/s
> > > * with gro_normal_batch == 16: ~500/500 Mbit/s
> > > 
> > > Applies on top of net-next.
> > > Thanks.
> > > 
> > > Alexander Lobakin (2):
> > >   net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
> > >   net: core: increase the default size of GRO_NORMAL skb lists to
> > > flush
> > > 
> > >  net/core/dev.c | 51
> > > +++++++++++++++++++++++++-------------------------
> > >  1 file changed, 26 insertions(+), 25 deletions(-)
> > > 
> > > --
> > > 2.23.0
> > > 
> > 
> > Thanks
> > /Ilias
> 
> Regards,
> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ

Regards
/Ilias
