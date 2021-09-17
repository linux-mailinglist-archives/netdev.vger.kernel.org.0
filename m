Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82140FEA4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244666AbhIQRaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243637AbhIQRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631899730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3IRX1cmUc1GC0I7v6XkLpxR1/n2INUJQ0FPY/9UWsls=;
        b=F8s1QnSf1la2P9GkaMyj0V88mtry+DTuXlyYV/MuCtxIkTN7t8HTgc3fyXIZh5u3eiMGLl
        SnPoRdNiu26vWiCl4pQstcvGUm2teeU6eniU++ZnIOCEdUD/57KiYjjCpiBEo9lQHXCbyC
        Y9AtjocAVNcR49I/5wJEhHQIkJRUpOA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-iV2kmw0HOFKgVjV4ShRHNg-1; Fri, 17 Sep 2021 13:28:49 -0400
X-MC-Unique: iV2kmw0HOFKgVjV4ShRHNg-1
Received: by mail-wm1-f69.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so4940329wmc.9
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3IRX1cmUc1GC0I7v6XkLpxR1/n2INUJQ0FPY/9UWsls=;
        b=ubm5atyZaDDFcaR73YncTu+NVe+OpbbVd0ijITrR7mbv6hstJmbEbC1AAvOehQdVgT
         Cm9zOAAu9twxB9OkGqNpOwyIYEwqSyFQjY8fZyiOg6qs8m6/qTZ6KfrQ9+K4Rtr5cqrW
         5Hf+hM6olpP8FCzTLqCBF5AfjoNgrlsbna/kqZBTNlAgNF0F6gqALczwgHcYUYzAEmrZ
         vN9UL74NMSLyNGsEngFky2OnmhZlNPfDYNRs8LOvjshZn0NUYXk/ovd++KzPu2ssyI/c
         7gt5atcgA9YhbxqtySwiB8WySU1ZZ2JN9RAglEtz+QC+qoPy6qMdzz4Rnw9lNcstrjo5
         pAPA==
X-Gm-Message-State: AOAM532Wfq/fm9F8vZ+cJ5eaDlm1DH13TO6ILHnMqXQ5idezNtc18lC8
        L38l9JOWcHbRxBZvQ54zqXBdVqUWoQPW4bH0LBvOcpg/ZR7m0czL9KXGIABxv3j+aboic2L0//D
        ieTSi66znXjlEdGSM
X-Received: by 2002:adf:ecd2:: with SMTP id s18mr1364223wro.99.1631899727780;
        Fri, 17 Sep 2021 10:28:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxniqIFXAelxLq2YgBdQk87/U3PVNKwu+CMo2ZSw+eAmh/dOxt56bsCiIunhEKJO9oRh6UuXA==
X-Received: by 2002:adf:ecd2:: with SMTP id s18mr1364206wro.99.1631899727526;
        Fri, 17 Sep 2021 10:28:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-134.dyn.eolo.it. [146.241.244.134])
        by smtp.gmail.com with ESMTPSA id z2sm6751959wma.45.2021.09.17.10.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 10:28:47 -0700 (PDT)
Message-ID: <c8fb99f0f01ccbf125b4263d954703a6b4f13b5e.camel@redhat.com>
Subject: Re: [RFC PATCH 2/5] tcp: expose the tcp_mark_push() and
 skb_entail() helpers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        MPTCP Upstream <mptcp@lists.linux.dev>
Date:   Fri, 17 Sep 2021 19:28:46 +0200
In-Reply-To: <CANn89iJOtSJ8JFCThtxjRpZQ9Q44LTs-dDxypEA6Hkho9KdxWQ@mail.gmail.com>
References: <cover.1631888517.git.pabeni@redhat.com>
         <07fd053d2c2239e70b20b105ff6f33d299dabea7.1631888517.git.pabeni@redhat.com>
         <CANn89iJOtSJ8JFCThtxjRpZQ9Q44LTs-dDxypEA6Hkho9KdxWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-09-17 at 09:43 -0700, Eric Dumazet wrote:
> On Fri, Sep 17, 2021 at 8:39 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > They will be used by the next patch.
> > 
> > Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > 
> 
> OK, but please rename skb_entail() to tcp_skb_entail() :)

ok, with that will also drop patch 1/5 - no more needed.

Thanks!

Paolo

