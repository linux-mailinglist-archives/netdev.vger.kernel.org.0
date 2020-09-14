Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C98268930
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgINKXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 06:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgINKWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 06:22:50 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D96C06174A;
        Mon, 14 Sep 2020 03:22:49 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so22443378eja.3;
        Mon, 14 Sep 2020 03:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JcgkykQbCEEzXPOIKLN/riEHEv6JbaxpqPU0ln50usE=;
        b=hzM7MOO9Rq9mUDA18kNMYt8jvZNAg4cOM75HXB9rzSkA2PdvarrESSKauS0rt7oIFS
         8tys67UrARZuybnkT31wATqbBVQ6dyGGnlrQxxcgxCstmOLdLpB74ALzBk5C57e+YiXm
         0FTJMvrZdzQGX64u2FUkKEDzlqP5mVpqkHGo49yz5CtmjgOlAw0/8WidBJLCKr7JuuOy
         AB01U/psleIcCbsplAvTLkTKDXj0kkXZL3G8NBM8RG5dD8xww8xxmed1ya/ClqHOS0Wf
         uOwSd1bDDSpWfQEB5J/qrtVECPePwCkr5Bg+Bf7/x1Y7mgTuoh1MBJI9kzEsWLcVwz/d
         OcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JcgkykQbCEEzXPOIKLN/riEHEv6JbaxpqPU0ln50usE=;
        b=KMuq67NlS+HRF7pasuyg+r/SSyzjzOWlNkFureCJfnDyeoxpmNUSg2IoIL4ECaOKlf
         AOmF+dbxNxQSc4uDo4lAwy0J3IWl3rff3VQF/TrPSNlYvOa51qUwIYHZuSzn5PpH762N
         UJIBuyGL4cxHA0dO8+xTXdqBr51FvaYTBYBt5tzNl/PFk8+0v42mU3q1l4j3ab1unn2t
         y0RaGX4Tw7wzsZf985F5OA3hni/O7EF5aKPzw/4HTIfQm7ETLJN77/RXi4nBLKMg7n2C
         71G0vcIHbbPp1PJeqeGV2Xo8NpA2T7zN8qYQ4FXVR5syW+owOUNmVDsV7gsi0bR/BXE7
         E1/Q==
X-Gm-Message-State: AOAM532Z1pEMpWfSN/erR1KTSCt15EJ3SnwVeL4ieAP3ACn+xHD/Qrhz
        96Se9lgonfRW6Od4wz66C3o=
X-Google-Smtp-Source: ABdhPJwpMgR1QyKRF+Kx+/hv2hcRWvEASyyAo3WtCvNRWY08dtRJDCvsuH3otupJYgT7EZUdcIIYKQ==
X-Received: by 2002:a17:906:4b4a:: with SMTP id j10mr13903598ejv.498.1600078967703;
        Mon, 14 Sep 2020 03:22:47 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id e15sm8827333eds.5.2020.09.14.03.22.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 03:22:46 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 01B2027C0054;
        Mon, 14 Sep 2020 06:22:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Sep 2020 06:22:43 -0400
X-ME-Sender: <xms:cURfX-NqGW-l0nzsMMf9SBHOJ4BR-riZQvV2i6qhqpTBM1n42ck86A>
    <xme:cURfX8-QFM8aa_0TAPAqgJKYNpFSzXdJanLqbLIaCkoneIIzdevUun9tXvnu02Zq0
    p_Pmvt-F8aBtu1-rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeiiedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdelieegudfggeevjefhjeevueevieetjeeikedvgfejfeduheefhffggedv
    geejnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:cURfX1T6D57hu7t5BUnlV0l8BZgxvpp-gb7ZsHu4j4JvlLpoMwlMIQ>
    <xmx:cURfX-t5CIr1HQbqC6DxHCylZ4AeCGuRTWjUk9Yb39pfPwxHWfjh9Q>
    <xmx:cURfX2fPDM7ZbuInfgNAx6PoZgxiINQQBXUQ5EpyGEQvh4YzWEuIew>
    <xmx:ckRfX6OyRJZcGmIW0NC4Nv53MQh6BYUo6bKgv50VxeE-UwleIdCKZnmh4Q8>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76F87306467E;
        Mon, 14 Sep 2020 06:22:40 -0400 (EDT)
Date:   Mon, 14 Sep 2020 18:22:39 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org
Subject: Re: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at
 least take two pages
Message-ID: <20200914102239.GB45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-9-boqun.feng@gmail.com>
 <20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
 <20200914093016.lsfrfk4c7kyj6tn3@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914093016.lsfrfk4c7kyj6tn3@liuwe-devbox-debian-v2>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 09:30:16AM +0000, Wei Liu wrote:
> On Mon, Sep 14, 2020 at 04:46:00PM +0800, Boqun Feng wrote:
> > On Thu, Sep 10, 2020 at 10:34:52PM +0800, Boqun Feng wrote:
> > > When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> > > least 2 * PAGE_SIZE: one page for the header and at least one page of
> > > the data part (because of the alignment requirement for double mapping).
> > > 
> > > So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> > > using vmbus_open() to establish the vmbus connection.
> > > 
> > > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > > ---
> > >  drivers/input/serio/hyperv-keyboard.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
> > > index df4e9f6f4529..6ebc61e2db3f 100644
> > > --- a/drivers/input/serio/hyperv-keyboard.c
> > > +++ b/drivers/input/serio/hyperv-keyboard.c
> > > @@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
> > >  
> > >  #define HK_MAXIMUM_MESSAGE_SIZE 256
> > >  
> > > -#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> > > -#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> > > +#define KBD_VSC_SEND_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
> > > +#define KBD_VSC_RECV_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
> > >  
> > 
> > Hmm.. just realized there is a problem here, if PAGE_SIZE = 16k, then
> > 40 * 1024 > 2 * PAGE_SIZE, however in the ring buffer size should also
> > be page aligned, otherwise vmbus_open() will fail.
> > 
> > I plan to modify this as
> > 
> > in linux/hyperv.h:
> > 
> > #define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(sizeof(struct hv_ring_buffer) + (playload_sz))
> > 
> > and here:
> > 
> > #define KBD_VSC_SEND_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)
> > #define KBD_VSC_RECV_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)
> > 
> > and the similar change for patch #9.
> 
> OOI why do you reduce the size by 4k here?
> 

To keep the total ring buffer size unchanged (still 40k) when
PAGE_SIZE=4k. Because in VMBUS_RING_SIZE() (which I plan to rename as
HV_RING_SIZE()), the hv_ring_buffer size is already added.

Regards,
Boqun

> Wei.
> 
> > 
> > Thoughts?
> > 
> > Regards,
> > Boqun
> > 
> > >  #define XTKBD_EMUL0     0xe0
> > >  #define XTKBD_EMUL1     0xe1
> > > -- 
> > > 2.28.0
> > > 
