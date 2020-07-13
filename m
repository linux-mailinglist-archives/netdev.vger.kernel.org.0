Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B621D710
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgGMN0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 09:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgGMN0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 09:26:00 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44903C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:26:00 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f16so6256113pjt.0
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 06:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9wmztWZaNyurqvRjtIqkJTMtisUduSp24nAtCCelslE=;
        b=rPBm2FI4AFIKsLp42xnJAVQ9WFgPDFEQlyYtWBlbuMxiDGV+H7nMIix+QjgpTACSSq
         AvlFTW3Yjp8FxHOp6sKFkSCVaidCcrYG0/RH1JZnVlLs0dm4JlG5IcqwbQuZTn0r09R2
         ormV4AF1R1PbQKKQTMiurYIe1+MWDe4eN5hCo9Ms6G13uwt9NKAiLwtIec4mbVE440PY
         82voD8SOZ7JXVLeSL68rFAkPD/k0K11aXf6m/LkJgCG1rWgfN24KKfmQTiIWniNPAkFe
         zWL+wkJ+KBMvjiy30fHjukOlHBuy7NkdpN1GZ2DaQcaCIJ1+T1fGjamAC1ICLIQmK4nW
         A8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9wmztWZaNyurqvRjtIqkJTMtisUduSp24nAtCCelslE=;
        b=OvYaMUUrdtCvEx9cX58fNIqbn42jzoghbDNMF2315wFOel2uKnbJflPZ17pq1yG0U6
         KU3Guair4rBCRDTIZGEV8cyDbIYFG5w7ULOYd6rzeCNh/F+sVase+Ud87uKXw0blHTVc
         ZipPzIsRtD3hcdFtd35Swa0NQ5hjv59mex6GiHwW6L2jE8ZoQS5YwLPYRi37zT1QAaRO
         38sLBJJgrXt7QKykWswa0kDZEst3oub0e792UG05xrwRLs1Qvj6aW3VLL/ICUfRjjgBd
         +V6hG4Nx36su/YiBOaomc6kwatWIQHJ/P2Ug5h0NrubuWT/lLukmxf8NOsxlHtNcKCvo
         9jWA==
X-Gm-Message-State: AOAM5325c8t4+ub1u/buIrk0Jln1uksL/bSYVYJQJUJ+nMG9KhgNx0rs
        vvu6ceQiMWsZD2WIYbZMIKEWNNf1
X-Google-Smtp-Source: ABdhPJzVx4ww7ZXTF5WF0IlUe9xjq4xfKddHlKyfg8Ri5wKaWu2gMSo05uxwWohJN+wA9GSnxHOYoQ==
X-Received: by 2002:a17:90a:158f:: with SMTP id m15mr19907331pja.93.1594646759877;
        Mon, 13 Jul 2020 06:25:59 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n63sm13190198pfd.209.2020.07.13.06.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 06:25:59 -0700 (PDT)
Date:   Mon, 13 Jul 2020 06:25:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: Re: [PATCH v3 net-next 3/3] octeontx2-pf: Add support for PTP clock
Message-ID: <20200713132557.GA27934@hoboy>
References: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
 <1594301221-3731-4-git-send-email-sundeep.lkml@gmail.com>
 <20200709160156.GC7904@hoboy>
 <CALHRZuoVtuHLFjwW_bJsWxVFYN=PYxwsj+YabNH4p=v82u-MVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALHRZuoVtuHLFjwW_bJsWxVFYN=PYxwsj+YabNH4p=v82u-MVA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 11:40:34AM +0530, sundeep subbaraya wrote:
> > > +static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
> > > +{
> > > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > > +     struct hwtstamp_config *cfg = &pfvf->tstamp;
> > > +
> >
> > Need to test phy_has_hwtstamp() here and pass ioctl to PHY if true.
> >
> For this platform PHY is taken care of by firmware hence it is not
> possible.

This has nothing to do with the FW.  The HW design might include a PHY
or MII time stamping device.

> > SKBTX_IN_PROGRESS may be set by the PHY, so you need to test whether
> > time stamping is enabled in your MAC driver as well.
> >
> In our case PHY will not set it and the pfvf/MAC driver sets it.

That might be true today, but the MAC driver should not prevent the
possibility of using an external time stamping device in the future.

Thanks,
Richard

