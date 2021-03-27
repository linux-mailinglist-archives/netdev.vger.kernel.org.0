Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF034B79E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhC0OZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 10:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhC0OZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 10:25:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037A3C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 07:25:24 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gb6so3944017pjb.0
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 07:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lerRti7xbu/lufpGYDNPKP2V0eAxjOfRQTTrp1o16pE=;
        b=JuxRX+aeOJB5Q0pBgPDHoAvzzw418vBW+OX4/LrJajdrmttP8oWMPanqHNGSJ6OUD0
         bJ3KXk/70HuSmdDkPYObrPjnmT9f5AO4fF15NacTqsHZ3G6wqYlydBDv5+iyFnj44K6i
         3kY9b2phhN1iWafByVabeqjXOwzFLFa/EYVCJk3OEW0YvVYjiwnHH2QBnFFD8JMULvhb
         UosCierMLxs7kSnRjHpHDJ+jV7y6dc7vyNo0jFJf32vp5T9KzxzI2wp2xzkWPSxjP0kN
         P454L0wH8TnqtNYhZ6u/uGi7n2PdGtlS1RWLv7DmJwtfmNPzikXidZ4YAOnnoJ8qvD+E
         OerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lerRti7xbu/lufpGYDNPKP2V0eAxjOfRQTTrp1o16pE=;
        b=RoCvJNfTzjy5G9imTbRJ1neX9i+Zt1L8NwBiNu93mG7asOA3iQOlGkoGsEHRRjNeSd
         9pbX8/e83ncpwfjKWtX9grmh9hjX/nKiJW/8sZXIZN6ma2XSUkbp2RYq8MGIVVTrQO5+
         q7iDqZ+8L1p+Nn9xfvv1hEAqXH27l4s0sK1yRGhDRNoxCT6u6sfZFYumH4id2indeD8s
         HnzUz4TZHanKuAx+SATifhMt0w9801JpFVigSYXo7j/Xst9L5G4uZVBt9FfyrixGCYfj
         P74px1HCom2c8FmM53iNu7ZRAXErzVbGtaPn2wo3luJblSO9nI3Tc42VC6WD9PHpbDgQ
         rHxA==
X-Gm-Message-State: AOAM532VrkTdoVzMmdHvdh6egM4X45AXvRwEvrEMauM2vKW4oZ+vHC3o
        6RYbTI2w3n04VNIp1Z6Mo/A=
X-Google-Smtp-Source: ABdhPJzR/NhiXpMqCOvZmr3g6loz0fOVb+QxxJD4IHy/x/X+1BsrbvwnjYNOfXRcYG2vKSf55Oy/HQ==
X-Received: by 2002:a17:902:ee95:b029:e5:e2c7:5f76 with SMTP id a21-20020a170902ee95b02900e5e2c75f76mr21005221pld.25.1616855123515;
        Sat, 27 Mar 2021 07:25:23 -0700 (PDT)
Received: from ThinkCentre-M83 ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id l25sm12727894pgu.72.2021.03.27.07.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 07:25:23 -0700 (PDT)
Date:   Sat, 27 Mar 2021 22:25:20 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net:qrtr: fix atomic idr allocation in
 qrtr_port_assign()
Message-ID: <20210327142520.GA5271@ThinkCentre-M83>
References: <20210327140702.4916-1-ducheng2@gmail.com>
 <YF89PtWrs2N5XSgb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF89PtWrs2N5XSgb@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 03:12:14PM +0100, Greg Kroah-Hartman wrote:
> Adding the xarray maintainer...
> 
> On Sat, Mar 27, 2021 at 10:07:02PM +0800, Du Cheng wrote:
> > add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
> > due to internal use of per_cpu variables, which requires preemption
> > disabling/enabling.
> > 
> > reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller
> > 
> > Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
> > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > ---
> > changelog
> > v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
> > v2: revert to GFP_ATOMIC but add preemption disable/enable protection
> > 
> >  net/qrtr/qrtr.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index edb6ac17ceca..6361f169490e 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  	mutex_lock(&qrtr_port_lock);
> >  	if (!*port) {
> >  		min_port = QRTR_MIN_EPH_SOCKET;
> > +		idr_preload(GFP_ATOMIC);
> >  		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
> > +		idr_preload_end();
> 
> This seems "odd" to me.  We are asking idr_alloc_u32() to abide by
> GFP_ATOMIC, so why do we need to "preload" it with the same type of
> allocation?
> 
> Is there something in the idr/radix/xarray code that can't really handle
> GFP_ATOMIC during a "normal" idr allocation that is causing this warning
> to be hit?  Why is this change the "correct" one?
> 
> thanks,
> 
> greg k-h


From the comment above idr_preload() in lib/radix-tree.c:1460
/**
 * idr_preload - preload for idr_alloc()
 * @gfp_mask: allocation mask to use for preloading
 *
 * Preallocate memory to use for the next call to idr_alloc().  This function
 * returns with preemption disabled.  It will be enabled by idr_preload_end().
 */

idr_alloc is a very simple wrapper around idr_alloc_u32().

On top of radix_tree_node_alloc() which is called by idr_alloc_u32(), there is
this comment at line 244 in the same radix-tree.c
/*
 * This assumes that the caller has performed appropriate preallocation, and
 * that the caller has pinned this thread of control to the current CPU.
 */

Therefore the preload/preload_end are necessary, or at least should have
preemption disabled

Regards,
Du Cheng

