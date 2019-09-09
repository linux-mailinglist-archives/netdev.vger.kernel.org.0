Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE687AD8AE
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 14:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404775AbfIIMQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 08:16:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391097AbfIIMQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 08:16:01 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 006D1C054C52
        for <netdev@vger.kernel.org>; Mon,  9 Sep 2019 12:16:01 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id o13so9926023qtr.15
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 05:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cR0iPk7k3gak2smW+VGCzi1D6+WqwWLkfLqRmEk+oQ0=;
        b=LpN+SKy5O5ksFdNAKUgodKEIijsQesev0GA4r/d2rJsXkGHhy1KG3JCXZPxWAAyojD
         BRmLvqH9iDM4HTw2qEcPZ/WJizn8+b/D9FdTnMmuiCTChc3OW1p7fyfAF4cFWRpXY1mH
         LdLHY48DHkBnWKn3EU+2VdbVUFHfh6zdgGugyImfWvDn+VkIbubsltrNIbnxpzQAlb6A
         UsFsCjiUxqGEL4Jz+S/1R0dC3gdDfW1sOSfdEvD4T0pJLE2cJKON5EAhKR8Eu3OptD8g
         pPTM+5SubHaZJoHseVT7jiahQwEXedsF8m1evnj2CuNTYiPPUzrhZoqBpmgnE0NaQsb1
         ga5g==
X-Gm-Message-State: APjAAAWKAYylCEIHPHzveJjLR/387FyQmYS8Yg7NDnVoRpLHm52KPIk2
        Y/MEWvrnwXKIoVqIDi6nRViyRmJ4yGXEcSt2uuItLql2JJ1ks5yO4kjH32XUSImoNTppStePayb
        gR/0ktATIC+f09eid
X-Received: by 2002:aed:3527:: with SMTP id a36mr23116296qte.82.1568031360372;
        Mon, 09 Sep 2019 05:16:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwTjEC9gLktIgrr/FKS4EvJdW8yr2QsPhfhm1/EGltRDxNNwBhSFB09DwZLmFGxdw8mqFXn1g==
X-Received: by 2002:aed:3527:: with SMTP id a36mr23116262qte.82.1568031360138;
        Mon, 09 Sep 2019 05:16:00 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id g194sm7059848qke.46.2019.09.09.05.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 05:15:59 -0700 (PDT)
Date:   Mon, 9 Sep 2019 08:15:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     David Miller <davem@davemloft.net>, jgg@mellanox.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, jglisse@redhat.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
Message-ID: <20190909081537-mutt-send-email-mst@kernel.org>
References: <20190905122736.19768-1-jasowang@redhat.com>
 <20190905135907.GB6011@mellanox.com>
 <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
 <20190906.151505.1486178691190611604.davem@davemloft.net>
 <bb9ae371-58b7-b7fc-b728-b5c5f55d3a91@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb9ae371-58b7-b7fc-b728-b5c5f55d3a91@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 03:18:01PM +0800, Jason Wang wrote:
> 
> On 2019/9/6 下午9:15, David Miller wrote:
> > From: Jason Wang <jasowang@redhat.com>
> > Date: Fri, 6 Sep 2019 18:02:35 +0800
> > 
> > > On 2019/9/5 下午9:59, Jason Gunthorpe wrote:
> > > > I think you should apply the revert this cycle and rebase the other
> > > > patch for next..
> > > > 
> > > > Jason
> > > Yes, the plan is to revert in this release cycle.
> > Then you should reset patch #1 all by itself targetting 'net'.
> 
> 
> Thanks for the reminding. I want the patch to go through Michael's vhost
> tree, that's why I don't put 'net' prefix. For next time, maybe I can use
> "vhost" as a prefix for classification?

That's fine by me.

-- 
MST
