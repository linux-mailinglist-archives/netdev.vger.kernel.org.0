Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7467025ECF1
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 06:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIFEvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 00:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgIFEvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 00:51:13 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226E1C061573;
        Sat,  5 Sep 2020 21:51:13 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id f11so5060801qvw.3;
        Sat, 05 Sep 2020 21:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S+yc3P3tKNdaheR8C4irj9BMqK6L98Ju22GvQsWWgBE=;
        b=ZUaxledhueBq9Vc/H2dDgnA1nhPm5u4mA3aJpU6quYyT010mOj6IayBu2fo6lOaUvO
         buxgjg4D4rAffbOdzZn0SYc+G7ERV9xRSEHoHmfXNnG7VPKmeoqJCH1nRE44UjAAwMRH
         XIpRhRbZH29KaiPD5Y/bJnpuDntLmacwNwJU3ys4Q8tN2pabrReEAivvZlGpNK1vfhuB
         UBOozC4hO7gD7tuR7kJMe0lFXHIzzAAVZCWKVvY4Sg1kcbA8UQR2JXYTnOY+58w6qfXX
         bksjIUq8CUyRnd1H23HqHMeAuZyvxoPcxb1DvGRuKndyCoRGyCm+J0AHoKanXF4CK3LE
         u3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S+yc3P3tKNdaheR8C4irj9BMqK6L98Ju22GvQsWWgBE=;
        b=kzgCS7QJ85/AXb0R27urd2k8GpcjSHaVSI1yl7TJHuP0dnNk0agrHk79W+ynJ3HM/b
         vpd1RNGYQs+DDNm2cNsEj4B/Lz2ZSwQPYva+UWojLiJ8vKEDtDa5NhN8K9BQ2rDH5Qyj
         Q4O1WIT2wwji4/kNamOafUGxhyYula2loDO6sZeUe2oyB50zA/921a93wCrfDfiPrARn
         13cRaW/afICi0DgNWtGvyQmFlAC3XW/DMHZFo5mlWz8xHdKEuaOphnTlkmeA1Pmy2BDF
         cZkDbkxwU0AsURKWitFZXZreq2h2WhxWqJySERTS13UCDm/u4II51hGQBQykFEEnc+re
         Nu0Q==
X-Gm-Message-State: AOAM531jhTtZlHMsowwRTdM7DVGg0y+85cuABfEnvupEqOB0WlG8NRut
        Z/l5+sqhfFs8TYNKdcczuqM=
X-Google-Smtp-Source: ABdhPJwKhFcCv07nv/3Y6M8uL9V109sfu5OYjJg3KXakjofYEfAXOLshmMpH+JCDwfK7uU1SXrSR+A==
X-Received: by 2002:a0c:e989:: with SMTP id z9mr14715798qvn.81.1599367870118;
        Sat, 05 Sep 2020 21:51:10 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id f8sm4584295qtx.81.2020.09.05.21.51.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 21:51:09 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3F4E927C0054;
        Sun,  6 Sep 2020 00:51:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 06 Sep 2020 00:51:08 -0400
X-ME-Sender: <xms:u2pUX1eiWo1nY4nzQanEa7Jwlj-heG1LV_JUZpnLEEcajp61zadSZg>
    <xme:u2pUXzNlm__kfWD8uD59qu_9aCZFKaJ9kXs0guPAHmKsPbGDjwZ5fD6qvC3ivOZGa
    4Su548MZErRSCNQXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudegiedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdelieegudfggeevjefhjeevueevieetjeeikedvgfejfeduheefhffggedv
    geejnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:u2pUX-hAeu5Md4hciO5-OHgDSWHKWz4nyDaRK2xLIiP-E2uR9cRmAA>
    <xmx:u2pUX-9-IavrJS6qrIsE34_JGX33g7gOvh35zQ2f9pYR1hx6PUukXg>
    <xmx:u2pUXxuK5XdMKRm91YsrmUijAm8GeeCSU6HEt7bRFOg2WaBUJJp1dQ>
    <xmx:vGpUXxMlvS1HryUnhHQ842KlMvAuuEjtvsYeEQ957BCPeXFAXvCv-LWjI14>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0641F3280059;
        Sun,  6 Sep 2020 00:51:06 -0400 (EDT)
Date:   Sun, 6 Sep 2020 12:51:05 +0800
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
Subject: Re: [RFC v2 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Message-ID: <20200906045105.GE7503@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-4-boqun.feng@gmail.com>
 <MW2PR2101MB105294660A73A7C69273AB9ED72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB105294660A73A7C69273AB9ED72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 12:19:08AM +0000, Michael Kelley wrote:
[...]
> > 
> > @@ -462,7 +576,13 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
> >  	open_msg->openid = newchannel->offermsg.child_relid;
> >  	open_msg->child_relid = newchannel->offermsg.child_relid;
> >  	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
> > -	open_msg->downstream_ringbuffer_pageoffset = newchannel-
> > >ringbuffer_send_offset;
> > +	/*
> > +	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
> > +	 * the unit of ->ringbuffer_send_offset is PAGE, so here we first
> > +	 * calculate it into bytes and then convert into HV_HYP_PAGE.
> > +	 */
> > +	open_msg->downstream_ringbuffer_pageoffset =
> > +		hv_ring_gpadl_send_offset(newchannel->ringbuffer_send_offset << PAGE_SHIFT) >> HV_HYP_PAGE_SHIFT;
> 
> Line length?
> 

Thanks for the review! I've resolved all your comments on wording for
patch #2 and #4 in my local branch. For this line length issue, I fix it
with two changes:

1)	both the callsite of hv_ring_gpadl_send_offset() use ">> ..."
	to calculate the index in HV_HYP_PAGE, so I change the function
	to return offset in unit of HV_HYP_PAGE instead of bytes, and
	that can save us the ">> ..." here.

2)	newchannel->ringbuffer_send_offset is read in the previous code
	of the function into local variable "send_pages", so I use it
	to replace the "newchannel->ringbuffer_send_offset" here.

now the code is:

	open_msg->downstream_ringbuffer_pageoffset =
		hv_ring_gpadl_send_hvpgoffset(send_pages << PAGE_SHIFT);

Regards,
Boqun


> >  	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
> > 
> >  	if (userdatalen)
> > @@ -556,7 +676,6 @@ int vmbus_open(struct vmbus_channel *newchannel,
> >  }
> >  EXPORT_SYMBOL_GPL(vmbus_open);
> > 
