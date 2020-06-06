Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3221F087A
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 22:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgFFUIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 16:08:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728197AbgFFUIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 16:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591474113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I3vo96oJCGr914y5mhSidy9wAMihpQEenpV5SRACxSM=;
        b=AxImsgBJiIPxtr6kX6B4KBfGa/bglStmGbfL0c5bVtmpiEYXCQET/Rh5JS3+O5ft0qdnhu
        vOGBJ77ruVoHLJy/N0hmH+ipcGqfsSU9Wq1Yi+gikNC4ToEyH2hH1vDxv9olq7fsAIWP/J
        4F2SXIduB5brR3uKueghBTB5WzOf/eA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-U6mTjncpPH2_Bzf83xRRvQ-1; Sat, 06 Jun 2020 16:08:31 -0400
X-MC-Unique: U6mTjncpPH2_Bzf83xRRvQ-1
Received: by mail-wr1-f70.google.com with SMTP id n6so5362964wrv.6
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 13:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=I3vo96oJCGr914y5mhSidy9wAMihpQEenpV5SRACxSM=;
        b=cqWtFihrXbUlTy1Tjb6412a7aNIkg/kJaFPHH8W3eHcJvo03Q5RtAB18Yf3Obo0Bb5
         5QLspOqJfrzOLZU6kMEj/1BjcC6Sld9BnpwqP9bXu/dDOlAsmGGwhi4Wjhwc1830Ud6f
         KTnJ1MAx1O6r1DKYieoj8T49sVNrCsovELUVLAyycptapEWPyKVihZuVc1u05bqV5Pj2
         o6kJySOC8uqE80zW7QtiW6uh93AUUyubCG2naysAg8vEg89hRWIWnuBjNDMf5fOMchmE
         4vPFQrvFFNjdwDs/jPlrNaKIE/syrB4FYHNKq0v9sV7DdMpvYj2V+DFVdgX8gsibVju+
         45Jg==
X-Gm-Message-State: AOAM5309o2BLyC5owuKPWNkT79CkZ19HjSPakIzFmuQLPc6pF9zZGWP1
        mXjvT2Jyilfh0vt/VVnjimTHBzcesA7ARmI7j1DDlP6TglYlKMg/DKujR0OUPVeeEPoBBa7Bnpp
        Q2tlndZBzRw0kujZ1
X-Received: by 2002:adf:ef50:: with SMTP id c16mr15276937wrp.161.1591474110576;
        Sat, 06 Jun 2020 13:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0SbwsNKKsOSlo/OYcuuvmM2xPp+M+9Ct36WZUV5Yngc7zJm9tOIPYCV68GGyxEnn/rpfZ/Q==
X-Received: by 2002:adf:ef50:: with SMTP id c16mr15276923wrp.161.1591474110326;
        Sat, 06 Jun 2020 13:08:30 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z9sm16153180wmi.41.2020.06.06.13.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 13:08:29 -0700 (PDT)
Date:   Sat, 6 Jun 2020 16:08:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200606160524-mutt-send-email-mst@kernel.org>
References: <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
 <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
 <20200603013600-mutt-send-email-mst@kernel.org>
 <b7de29fa-33f2-bbc1-08dc-d73b28e3ded5@redhat.com>
 <20200603022935-mutt-send-email-mst@kernel.org>
 <f0573536-e6cc-3f68-5beb-a53c8e1d0620@redhat.com>
 <20200604124759-mutt-send-email-mst@kernel.org>
 <55b50859-a71b-c57e-e26b-5fc8659eac22@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55b50859-a71b-c57e-e26b-5fc8659eac22@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 06:03:38PM +0800, Jason Wang wrote:
> 
> On 2020/6/5 上午12:49, Michael S. Tsirkin wrote:
> > > > 2. Second argument to translate_desc is a GPA, isn't it?
> > > No, it's IOVA, this function will be called only when IOTLB is enabled.
> > > 
> > > Thanks
> > Right IOVA. Point stands how does it make sense to cast
> > a userspace pointer to an IOVA? I guess it's just
> > because it's talking to qemu actually, so it's abusing
> > the notation a bit ...
> > 
> 
> Yes, but the issues are:
> 
> 1) VHOST_SET_VRING_ADDR is used for iotlb and !iotlb
> 2) so did the memory accessors
> 
> Unless we differ separate IOTLB datapath out, there's probably not easy to
> have another notation.
> 
> Thanks

With the batching/format independence rework, it might be possible to
separate that down the road. We'll see.

-- 
MST

