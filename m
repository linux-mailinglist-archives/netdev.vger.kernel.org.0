Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED39B25F123
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 02:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIGAJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 20:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgIGAJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 20:09:22 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64589C061573;
        Sun,  6 Sep 2020 17:09:21 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id j11so15941850ejk.0;
        Sun, 06 Sep 2020 17:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=93zhO48suX6QzkH46mTIlpJ2YtXViw8tf8wpAARIdJo=;
        b=MAuaXP8/gHKbbROVChKdLmxdhfQd+YgsNtrxAvoddxd9pYs810z7VxMVh0OBByd7px
         nVdkeSTav3p4ro8baI9CauV5NjiyqZBLetZZFJ8eG8VFhl7BxAqhKljKEckKlFaRTuxr
         ravHJ8/n9UHWAgbc/H/IV4s0AoTmNJLPi5CFc1fFh9z/ky9VzAYgH4QHRdZqU+yw8FYd
         f4p+5Ucox12O9dnEfMPgdDwp4lQ0LuPhw53bYc+Ta9XxQlV0i5UjUkWQrMT8yehspxaP
         VCwPMV0lCDqoVo6AcdHxX0A/a0xmUEhjmvBgU0u9QHU0X+RzKge5ohQ67iVT4Qsjiz7C
         LsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=93zhO48suX6QzkH46mTIlpJ2YtXViw8tf8wpAARIdJo=;
        b=lV3S7ptPloZRGrzMFVO1rNskQxzJ4HN1HlxrwgEiwLWbVhdDWZ24gC9eSlmmrIT766
         wBYWLnVZMHMrgj6IGYpXr62aGQPb20BLvO+9xo2IrNysufVgXyAKFqXpSgCCYISxjhO3
         L7X47b4StnsVZUMrQkD0wGgqteo1gtub3a7+e7e/3D+z+/K2DV2vEic6Y5L9JgQ215jA
         6xTFFqSbjxRlbl9nbXYXIHmhqHRFe49BqNAbEvGORaY+R+H7PCuOX5HdjR+rKKerewja
         VD1fc3mgsxe7bgqSTQPtUrNdj2QjFPka8pLWX975uqw4mOAFnIKxo2oydkTKUfFqxehO
         yrUA==
X-Gm-Message-State: AOAM531Tp+2ozN6VlHOVszhjFdt++3WttRCgR5D+Pekwz/iUrvsrIxYr
        jjEbF9MABAfbU0DmAovMdjs=
X-Google-Smtp-Source: ABdhPJweeQ4NuQTd29lGUGxEe+zjVwQETK+Z2icG9hinmHOQfqVfRyzOItom1EPmdDSFHaBaDqtSvg==
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr19227646ejb.493.1599437359957;
        Sun, 06 Sep 2020 17:09:19 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id sd17sm13977062ejb.93.2020.09.06.17.09.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2020 17:09:18 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id DE62827C0054;
        Sun,  6 Sep 2020 20:09:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 06 Sep 2020 20:09:15 -0400
X-ME-Sender: <xms:KnpVX_Ch3CwVUK0KmW_gD3CLFPUiK-_U3jGIt7G5xFPQQCkvrJRRcA>
    <xme:KnpVX1ivpASud1s-3tVmIZdTT7SRzcHgHnG5_ox9zhyaSG6DVIXiG9tY6jQwfSpa0
    -p5tbG7XSADzE7xRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegkedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdelieegudfggeevjefhjeevueevieetjeeikedvgfejfeduheefhffggedv
    geejnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:KnpVX6kQKNwQPvrDp_3a-lIFvB20SRN_E3ZHCmpb1OlaGsvpzeHO2Q>
    <xmx:KnpVXxxatupxLX5GJq5ves9wfrvpo0InsWQa73s6d0T2z5zoyH5-1A>
    <xmx:KnpVX0RKrVoYlcSYg7qJJhpM1W1TLfR3TV4CtjBAfzxfUnTVyYpjnw>
    <xmx:K3pVXxiqzy9rzAbNzKVEXt2fWFsQvcG5GZG5SOVZ7pt33Ftx7seM32rQPBI>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id F393B328005D;
        Sun,  6 Sep 2020 20:09:13 -0400 (EDT)
Date:   Mon, 7 Sep 2020 08:09:12 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC v2 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V
 communication
Message-ID: <20200907000912.GF7503@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-8-boqun.feng@gmail.com>
 <MW2PR2101MB10521041242835B2D6E3EA0AD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10521041242835B2D6E3EA0AD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 12:30:48AM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:01 PM
[...]
> >  struct rndis_request {
> >  	struct list_head list_ent;
> >  	struct completion  wait_event;
> > @@ -215,18 +215,18 @@ static int rndis_filter_send_request(struct rndis_device *dev,
> >  	packet->page_buf_cnt = 1;
> > 
> >  	pb[0].pfn = virt_to_phys(&req->request_msg) >>
> > -					PAGE_SHIFT;
> > +					HV_HYP_PAGE_SHIFT;
> >  	pb[0].len = req->request_msg.msg_len;
> >  	pb[0].offset =
> > -		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
> > +		(unsigned long)&req->request_msg & (HV_HYP_PAGE_SIZE - 1);
> 
> Use offset_in_hvpage() as defined in patch 6 of the series?
> 

Fair enough, I will use offset_in_hvpage() in the next version

Regards,
Boqun

> > 
> >  	/* Add one page_buf when request_msg crossing page boundary */
> > -	if (pb[0].offset + pb[0].len > PAGE_SIZE) {
> > +	if (pb[0].offset + pb[0].len > HV_HYP_PAGE_SIZE) {
> >  		packet->page_buf_cnt++;
> > -		pb[0].len = PAGE_SIZE -
> > +		pb[0].len = HV_HYP_PAGE_SIZE -
> >  			pb[0].offset;
> >  		pb[1].pfn = virt_to_phys((void *)&req->request_msg
> > -			+ pb[0].len) >> PAGE_SHIFT;
> > +			+ pb[0].len) >> HV_HYP_PAGE_SHIFT;
> >  		pb[1].offset = 0;
> >  		pb[1].len = req->request_msg.msg_len -
> >  			pb[0].len;
> > --
> > 2.28.0
> 
