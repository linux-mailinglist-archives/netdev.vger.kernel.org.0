Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7C22095D
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbgGOKBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:01:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45700 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726859AbgGOKBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594807296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HekGS7tagFCyUygsCpeQ/B9KX+evKC/CjFFwusa1ifg=;
        b=aVwRCI7f+dVnG4OVY6t3rh6vm3oR7QaN4b+lgLFBnPbaUxt0QpohtOb2Fcj2bFWlqWdUz0
        Q+iKc3noQuXCzmQLdHj0S2YARTGVkwUiNUCQUl+q+tAdI4Q8h4L2SzN08O2sg1N33tBpnK
        n5RsvSNIl5N9uVeJAS1809QFQtSd3E0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-FALJhjeONti1px9imst8BQ-1; Wed, 15 Jul 2020 06:01:34 -0400
X-MC-Unique: FALJhjeONti1px9imst8BQ-1
Received: by mail-wr1-f71.google.com with SMTP id o25so734892wro.16
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 03:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HekGS7tagFCyUygsCpeQ/B9KX+evKC/CjFFwusa1ifg=;
        b=J57SZ6b8YwedT4q2blVOXFFRYdMmZbB6X+CmHKSVzHrCyi5rAiUPpRHHybFx9FE+Wu
         Keb9n8hqli12kQrMVbgbg1yHXlio4dpSoRhOC6wsUHxAfOHH7Xgbg2t/S4Ut8bbFO7Ha
         W4dHxUahC9lNLQK5on328t90fsHe5Qg07vUsy+d1JgrdstOLRZhcuKmH8Uws5crX6hoz
         2dNgikgScIRaUfe0J/9aRTe8Ywj0FGvl73vGE23+JFJ+HdBeQVRMEjm1CBrxqdPDR2iv
         CcWf1zs9fSkVoGz9P2Q7wegoqvC1C5Iy3n2TP7hc4ZuyYweaRYIHx+mXX0vlN+E0Qwxs
         JAHQ==
X-Gm-Message-State: AOAM532eUd6OYozhJlqmPQnhIEgD8s6AXYlhtdKhmuCmv7kGvog0Hrnj
        gQ2aMu3m1GhByF9uwdTTY09e2Hfm9w+jDo7MEASbvxWi/PQIeAP8hE1OzMIpaMBYLua/5j8yB2f
        pSqPDCifvcrywsJcv
X-Received: by 2002:a7b:cf10:: with SMTP id l16mr7919845wmg.93.1594807293252;
        Wed, 15 Jul 2020 03:01:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1WZv6wCcqcC8E09KqCGI8Gy46vvkixsA7u+HHjLSiqLG8muYvy9tQVwLI2mOpJCOMHMsgEA==
X-Received: by 2002:a7b:cf10:: with SMTP id l16mr7919828wmg.93.1594807293016;
        Wed, 15 Jul 2020 03:01:33 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id h199sm2701343wme.42.2020.07.15.03.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 03:01:32 -0700 (PDT)
Date:   Wed, 15 Jul 2020 06:01:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
Subject: Re: [PATCH 6/7] ifcvf: replace irq_request/free with helpers in vDPA
 core.
Message-ID: <20200715055538-mutt-send-email-mst@kernel.org>
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-6-git-send-email-lingshan.zhu@intel.com>
 <c7d4eca1-b65a-b795-dfa6-fe7658716cb1@redhat.com>
 <f6fc09e2-7a45-aaa5-2b4a-f1f963c5ce2c@intel.com>
 <09e67c20-dda1-97a2-1858-6a543c64fba6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09e67c20-dda1-97a2-1858-6a543c64fba6@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 04:40:17PM +0800, Jason Wang wrote:
> 
> On 2020/7/13 下午6:22, Zhu, Lingshan wrote:
> > 
> > 
> > On 7/13/2020 4:33 PM, Jason Wang wrote:
> > > 
> > > On 2020/7/12 下午10:49, Zhu Lingshan wrote:
> > > > This commit replaced irq_request/free() with helpers in vDPA
> > > > core, so that it can request/free irq and setup irq offloading
> > > > on order.
> > > > 
> > > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > > ---
> > > >   drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++-----
> > > >   1 file changed, 6 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c
> > > > b/drivers/vdpa/ifcvf/ifcvf_main.c
> > > > index f5a60c1..65b84e1 100644
> > > > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > > > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > > > @@ -47,11 +47,12 @@ static void ifcvf_free_irq(struct
> > > > ifcvf_adapter *adapter, int queues)
> > > >   {
> > > >       struct pci_dev *pdev = adapter->pdev;
> > > >       struct ifcvf_hw *vf = &adapter->vf;
> > > > +    struct vdpa_device *vdpa = &adapter->vdpa;
> > > >       int i;
> > > >           for (i = 0; i < queues; i++)
> > > > -        devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> > > > +        vdpa_free_vq_irq(&pdev->dev, vdpa, vf->vring[i].irq, i,
> > > > &vf->vring[i]);
> > > >         ifcvf_free_irq_vectors(pdev);
> > > >   }
> > > > @@ -60,6 +61,7 @@ static int ifcvf_request_irq(struct
> > > > ifcvf_adapter *adapter)
> > > >   {
> > > >       struct pci_dev *pdev = adapter->pdev;
> > > >       struct ifcvf_hw *vf = &adapter->vf;
> > > > +    struct vdpa_device *vdpa = &adapter->vdpa;
> > > >       int vector, i, ret, irq;
> > > >         ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> > > > @@ -73,6 +75,7 @@ static int ifcvf_request_irq(struct
> > > > ifcvf_adapter *adapter)
> > > >            pci_name(pdev));
> > > >       vector = 0;
> > > >       irq = pci_irq_vector(pdev, vector);
> > > > +    /* config interrupt */
> > > 
> > > 
> > > Unnecessary changes.
> > This is to show we did not setup this irq offloading for config
> > interrupt, only setup irq offloading for data vq. But can remove this
> > since we have config_msix_name in code to show what it is
> 
> 
> Btw, any reason for not making config interrupt work for irq offloading? I
> don't see any thing that blocks this.
> 
> Thanks

Well config accesses all go through userspace right?
Doing config interrupt directly would just be messy ...


> 
> > Thanks BR Zhu Lingshan
> > > 

