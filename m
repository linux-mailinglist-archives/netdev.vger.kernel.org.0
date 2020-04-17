Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761AD1ADA29
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgDQJir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:38:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgDQJiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587116324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVkbDn8gkw5+Noos0y5yOQUyWaS8jqC9S0wOjm7uqw4=;
        b=E7yXcE89s8jUeGNZATNBPoSWrofGS94YVwHEkjOM1Zbj93t+wjSsvXUp8kQp3ppEDp76GZ
        0QycDRKY8T5P+F+X3L8f+xgNB/bQIHoBt6VWMU4KuwyJGJB6ej1bcfWMNzHCENw4W8uC1d
        gPzgPXP4TwoNcOd0ZC0km/IVtsgORRs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-m5Git4f3N6mJg79iKNdC-A-1; Fri, 17 Apr 2020 05:38:43 -0400
X-MC-Unique: m5Git4f3N6mJg79iKNdC-A-1
Received: by mail-wm1-f71.google.com with SMTP id 71so271701wmb.8
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 02:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EVkbDn8gkw5+Noos0y5yOQUyWaS8jqC9S0wOjm7uqw4=;
        b=rXgBgp3TN4eHy3UgrY95o3uKrlKyZbio0efnODGh8dKoatsEJlxWscEAOghKGrAIX1
         gyKQQS/LFwDkqnpwGhnDJhz/HMDmvgXjQFddlgaKupfHsg8DoSR8IavVd2KZxGOJiKBs
         4Jh0fXRFVnVxBb/OvA4rbkbUr+mswETDwi5U9OQK+pEPsObOaSjJ8UWZthVE6pYLx4Oe
         Qaoc5PjVPtlYr6mDpPoIDZXh9NtrKj5w5ALgXlCwlBBnxfB0Ra4abKESe6VVVB4ak0nB
         NaJxP76+408ayWDA3v/tJC860AC6PTZ6vSXyKtKR5yhk2nArhQmpUzLUZBBbh+x9UZg6
         41Vw==
X-Gm-Message-State: AGi0PubK2Nstqgs85q6f/XgXSp7QFzQhfzu1Otol7OBGdSspPRYcRV34
        ig2Ph6Moilx/cDrW0noaDSe+lRx6cm9Tssqda8SDHkyG4IPWqCnyuOjQUJjrIuuQ0gLbr6K+W0H
        W+4v9hbcrNZyRqHpD
X-Received: by 2002:adf:e711:: with SMTP id c17mr1264151wrm.334.1587116322163;
        Fri, 17 Apr 2020 02:38:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypLI0ZplMhJRXp9IgnvDd4jNrwD2zcF2noQBvqCsovqT0NxBwm05qUG6Nsovmh0zi9ATjf9KqA==
X-Received: by 2002:adf:e711:: with SMTP id c17mr1264134wrm.334.1587116321952;
        Fri, 17 Apr 2020 02:38:41 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id a24sm6912835wmb.24.2020.04.17.02.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 02:38:41 -0700 (PDT)
Date:   Fri, 17 Apr 2020 05:38:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
Message-ID: <20200417053803-mutt-send-email-mst@kernel.org>
References: <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
 <20200417050029-mutt-send-email-mst@kernel.org>
 <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce8a18e5-3c74-73cc-57c5-10c40af838a3@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 05:33:56PM +0800, Jason Wang wrote:
> 
> On 2020/4/17 下午5:01, Michael S. Tsirkin wrote:
> > > There could be some misunderstanding here. I thought it's somehow similar: a
> > > CONFIG_VHOST_MENU=y will be left in the defconfigs even if CONFIG_VHOST is
> > > not set.
> > > 
> > > Thanks
> > > 
> > BTW do entries with no prompt actually appear in defconfig?
> > 
> 
> Yes. I can see CONFIG_VHOST_DPN=y after make ARCH=m68k defconfig

You see it in .config right? So that's harmless right?

-- 
MST

