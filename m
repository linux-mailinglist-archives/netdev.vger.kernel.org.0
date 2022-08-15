Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E22592A04
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 09:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiHOHCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiHOHCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:02:08 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9315ADFD9;
        Mon, 15 Aug 2022 00:02:07 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id ED7175C00C5;
        Mon, 15 Aug 2022 03:02:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Aug 2022 03:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660546926; x=1660633326; bh=7XuUYChiRO
        cmN5Xe3tNrNb0d4/N6U6GmFm8bRA2mFtk=; b=vH5e5G5tLvGDdYIwaCom93xIqK
        /6QcVDoe1ka18/izrAzvhNMVIv423tgERZhx+sjgFaZ4S4WO1qLUATrrWdIXM6Go
        LSJQSTwfCu6V8oee8TmU+35873gzvFWshjjfJWybrebTMTL3fPtH+5DuxEkAXNWV
        Nv06f5tcqHcib1A/AcLoSIQbNNscKYE4b9ZNaxaVn+MbaY19BZEs5xQySS1PZmeU
        KnqZq5PUMJA/61i5S4EWgPqYstenYf4Zxcl9d9/dv+9NwN5tr4dEj0CT0dV9nZb0
        mcTgyG//37OJ+tFNPPZmCRx9JvZhQbwN46uJJTRQoVAklZFeJifvnHWUI76g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660546926; x=1660633326; bh=7XuUYChiROcmN5Xe3tNrNb0d4/N6
        U6GmFm8bRA2mFtk=; b=0Mh9+zPWZ20UDPeP7vaHcWXp/NI8ITDyDD3QP8533ylV
        /+cdrGP2w1N1yWTzSjfmYRgVDG8NzDgZUZmk/jEVrA/RGvuPBfVS2i54NryJAGFA
        j2rxw4B659ne16DH99ePsDBUB/8/9r4ndTSeGfN4zzaV24S6UlcW7H5YOgC5QhJw
        yVXvhDCMKBIquJKp6DkmrZ5nzwuHI0u5VYDXPM+A5p7viRECWYXSecpREofxQZuy
        0wzND6APj+G6UjizDOyFcmYR/phKTG25KGjHCOF1xVb9VA2fsOaoIsByzJ62A1e+
        giYQmOFtQ6MN4tyBoQu6fkalNpK/UyBQPuw9iuc0Jw==
X-ME-Sender: <xms:bO_5Yt3A_yXm-xHz4fhrr0yd8O9daPYalo0o1IdTFY7xHLnzFteJeQ>
    <xme:bO_5YkHI3a5OUndFVMzpNfllZiWLiMYSS-vmgBEUsaIpEQ9s9GtrytRjwjSn5wTCj
    otax7oE7ZH_mRW-vw>
X-ME-Received: <xmr:bO_5Yt4Bpac5DfOgs7Wvh-d_XGVQPVpSlt1qA2ehBEq9R9X4axVz7kFQRvxYJ4fF0I9jD4mjiJwxdfEBzEyyPPE9vFWmSYY8RUN8GW4eN-RpsuSh6ypyBCieXJt4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehuddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpeeuleehvdekhedvvdegveelkeethfetfeeufeehhfetiefggfdtgeek
    keegieegueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigv
    lhdruggv
X-ME-Proxy: <xmx:be_5Yq2reiIsazzhUnbA6CSFyQggLT14gX8z1vPb04JEKdiOv-9ttg>
    <xmx:be_5YgFLOGrNJVMTgjfz18VrH7gMLOrGtrImU1IOibeyhrIZjp7vMw>
    <xmx:be_5Yr9xLVFZt0cFdLN1d3e6lP-qzPXptj7pF5fcWmmmEv8q8uXarA>
    <xmx:bu_5YjGomEc1YBtJYX2oYkWY_i9_YqIFKCU7yeyOH5OMbCEPyRH7Kw>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 03:02:04 -0400 (EDT)
Date:   Mon, 15 Aug 2022 00:02:03 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, colin.i.king@gmail.com,
        colin.king@intel.com, dan.carpenter@oracle.com, david@redhat.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        gshan@redhat.com, hdegoede@redhat.com, hulkci@huawei.com,
        jasowang@redhat.com, jiaming@nfschina.com,
        kangjie.xu@linux.alibaba.com, lingshan.zhu@intel.com,
        liubo03@inspur.com, michael.christie@oracle.com,
        pankaj.gupta@amd.com, peng.fan@nxp.com, quic_mingxue@quicinc.com,
        robin.murphy@arm.com, sgarzare@redhat.com, suwan.kim027@gmail.com,
        syoshida@redhat.com, xieyongji@bytedance.com, xuqiang36@huawei.com,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [GIT PULL] virtio: fatures, fixes
Message-ID: <20220815070203.plwjx7b3cyugpdt7@awork3.anarazel.de>
References: <20220812114250-mutt-send-email-mst@kernel.org>
 <20220814004522.33ecrwkmol3uz7aq@awork3.anarazel.de>
 <1660441835.6907768-1-xuanzhuo@linux.alibaba.com>
 <20220814035239.m7rtepyum5xvtu2c@awork3.anarazel.de>
 <20220814043906.xkmhmnp23bqjzz4s@awork3.anarazel.de>
 <20220814045853-mutt-send-email-mst@kernel.org>
 <20220814194031.ciql3slc5c34ayjw@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814194031.ciql3slc5c34ayjw@awork3.anarazel.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-14 12:40:31 -0700, Andres Freund wrote:
> On 2022-08-14 04:59:48 -0400, Michael S. Tsirkin wrote:
> > On Sat, Aug 13, 2022 at 09:39:06PM -0700, Andres Freund wrote:
> > > Hi,
> > >
> > > On 2022-08-13 20:52:39 -0700, Andres Freund wrote:
> > > > Is there specific information you'd like from the VM? I just recreated the
> > > > problem and can extract.
> > >
> > > Actually, after reproducing I seem to now hit a likely different issue. I
> > > guess I should have checked exactly the revision I had a problem with earlier,
> > > rather than doing a git pull (up to aea23e7c464b)
> >
> > Looks like there's a generic memory corruption so it crashes
> > in random places.
>
> Either a generic memory corruption, or something wrong with IO.
>
> > Would bisect be possible for you?
>
> I'll give it a go.

Bisect points to

commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7 (refs/bisect/bad)
Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Mon Aug 1 14:38:57 2022 +0800

    virtio_net: set the default max ring size by find_vqs()

    Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
    rx at the same time.

                             | rx/tx ring size
    -------------------------------------------
    speed == UNKNOWN or < 10G| 1024
    speed < 40G              | 4096
    speed >= 40G             | 8192

    Call virtnet_update_settings() once before calling init_vqs() to update
    speed.

    Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    Acked-by: Jason Wang <jasowang@redhat.com>
    Message-Id: <20220801063902.129329-38-xuanzhuo@linux.alibaba.com>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


I'm not 100% confident yet, because the likelihood of encountering problems
was not uniform across the versions, with one of them showing the problem only
in 1/3 boots, whereas some of the others showed it 100% of the time. But I've
rebooted enough times to be fairly confident.

With 762faee5a267 I reliably see network not connecting, with
762faee5a267^=fe3dc04e31aa I haven't seen a problem yet.


I did see some other types of crashes in commits nearby, so this might not be
the only problematic bit. See also the discussion around
https://lore.kernel.org/all/CAHk-=wikzU4402P-FpJRK_QwfVOS+t-3p1Wx5awGHTvr-s_0Ew@mail.gmail.com/

Greetings,

Andres Freund
