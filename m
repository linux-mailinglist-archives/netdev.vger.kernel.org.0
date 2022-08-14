Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06829592635
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 21:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiHNTkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 15:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiHNTkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 15:40:39 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EF6DF9C;
        Sun, 14 Aug 2022 12:40:37 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4605B5C0075;
        Sun, 14 Aug 2022 15:40:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 14 Aug 2022 15:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660506035; x=1660592435; bh=OFDS3Ok0yf
        v0moILB97wP3ESPtiwUDtMRJp1ZG51Sj8=; b=uH75q/OzmmB40Yjv4xjn0dDp09
        XBh1CAgIfN7IU5ALlW1lsT3zSrRb4fCzjb5iG5tYqKExCYNnE7W6NsIV8PnIpzbG
        WfD8Z1UgArCnHOHDdsCW5VNKaQV0YOsPeSsKoxx5/sTarSD/o8b2t+tWjxFdl92o
        jASY+/ZepjkQLn6WaOIGBkYb9ykYCgYf0LGVeTztsbVeg7/UlzrwjpPy8MxyRqE3
        XCQC865gnWwoKtgrd23Vce48ZR1Bzbk3yOogkCCWZDMPzMwC+OX+zzxfNKZL/PdO
        61fDyxfkNbQxL2ZQgjKMclIhvfEMS7E2lK0dF9I1UMaMyZBoVRQUxPO+YBeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660506035; x=1660592435; bh=OFDS3Ok0yfv0moILB97wP3ESPtiw
        UDtMRJp1ZG51Sj8=; b=sk9ii4aXH/3jVA9fddHFDm48OBqIaUOntKcROmicKQrh
        COlH601UOwpnDR12lb7lJgbxzVtkPN+J3jnqZ37l4lpvo/A/bi1gcv2m71S8tZQC
        AmKOHzGnkCOKCuMF3Ts56/28kOE59E2Qergj2MeKpq98XEQel0zKHpIk7UG5u/+K
        gtKC0TJpLs2+gMuh2LuxBMaMapmLZRRDZ73bKPkWxZSxi85tVqjh0j5KCydrwMnz
        Gl+EjrGBzTK0CGaJd2wqEXlACbY0XUri/afSdt9biuZKhK8UF9MwDyxOxqNDBU74
        HOG4KoNNBN/UQOfoP25aZRwNQZZRyx/OXmwmB0IObw==
X-ME-Sender: <xms:sU_5YiTe5wqJsCWmf1j7jScCYIoOIuGgK6mBpj5svVgh3xsafPPagQ>
    <xme:sU_5YnwJdD8vs7LhVGMkKbvEasnvdpHdSAw1qiVcvrH0xH1-VdzNQX_nsZK_NSqKP
    XcX5WPUwIFCjD3Jxg>
X-ME-Received: <xmr:sU_5Yv3JnYJt6WwcGb0jGnWSZStf8qsDkC7HXPPaLwTaqX9PKWRubjzLN1ZevacA7OAPWfbu8t2wC6LCJyXIwVWWtXRX3IUQv1Aq344bwM_e9lV8vyzEm2vUHQKt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehtddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:sU_5YuC6x0AkDcy0k1TxCWh67N2aZOXEsAm-BpZ61Nt4Iip923V8Ow>
    <xmx:sU_5YriVs8ldXhNXKnyeYU1IqQ6BzySWVSpElFy-8gUhc_9WHynEaw>
    <xmx:sU_5YqqrgFDpjkd4C1j5knMFr1Jgxyt3M_VssQXsbablF7UTuVkNfw>
    <xmx:s0_5YuMbcnHFU0IF30q_brMWsXuethJVTLzLesNi--Kk-T8meBptkg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 14 Aug 2022 15:40:32 -0400 (EDT)
Date:   Sun, 14 Aug 2022 12:40:31 -0700
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
        syoshida@redhat.com, xieyongji@bytedance.com, xuqiang36@huawei.com
Subject: Re: [GIT PULL] virtio: fatures, fixes
Message-ID: <20220814194031.ciql3slc5c34ayjw@awork3.anarazel.de>
References: <20220812114250-mutt-send-email-mst@kernel.org>
 <20220814004522.33ecrwkmol3uz7aq@awork3.anarazel.de>
 <1660441835.6907768-1-xuanzhuo@linux.alibaba.com>
 <20220814035239.m7rtepyum5xvtu2c@awork3.anarazel.de>
 <20220814043906.xkmhmnp23bqjzz4s@awork3.anarazel.de>
 <20220814045853-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814045853-mutt-send-email-mst@kernel.org>
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

On 2022-08-14 04:59:48 -0400, Michael S. Tsirkin wrote:
> On Sat, Aug 13, 2022 at 09:39:06PM -0700, Andres Freund wrote:
> > Hi,
> > 
> > On 2022-08-13 20:52:39 -0700, Andres Freund wrote:
> > > Is there specific information you'd like from the VM? I just recreated the
> > > problem and can extract.
> > 
> > Actually, after reproducing I seem to now hit a likely different issue. I
> > guess I should have checked exactly the revision I had a problem with earlier,
> > rather than doing a git pull (up to aea23e7c464b)
> 
> Looks like there's a generic memory corruption so it crashes
> in random places.

Either a generic memory corruption, or something wrong with IO.

> Would bisect be possible for you?

I'll give it a go.

Greetings,

Andres Freund
