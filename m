Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C65D60ED5A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiJ0BUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ0BT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:19:59 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D02017ABD;
        Wed, 26 Oct 2022 18:19:50 -0700 (PDT)
X-UUID: e8bea9f107a24e92ab4a37ac41be74f2-20221027
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=GLNIvP2G/RDPSfcqBf/x3tjU8KvaD+BtHJOdbNcA5VI=;
        b=VV78YAlRIPs3mEdKx0jcdraQekKm3yf2yYy9cAwy14z9/LX3MONuUQtAKfUleA2Uot9BWxwp9ie1ivXoUUiY+pXHGQnRA9c8GUWVWDaoKVRrLrfLx51akbB6gd59noiUwsISqdoXTE5+1B+ku6ecT7oOx5pxsALefQKAWLq6d2A=;
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:49d831c9-3f95-470e-8ca0-1be34a851c22,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:54
X-CID-INFO: VERSION:1.1.12,REQID:49d831c9-3f95-470e-8ca0-1be34a851c22,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,BULK:0,RULE:Release_HamU,ACTION:
        release,TS:54
X-CID-META: VersionHash:62cd327,CLOUDID:703f4127-9eb1-469f-b210-e32d06cfa36e,B
        ulkID:221026152939UEHAN1OL,BulkQuantity:15,Recheck:0,SF:28|16|19|48|102,TC
        :nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: e8bea9f107a24e92ab4a37ac41be74f2-20221027
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1971803359; Thu, 27 Oct 2022 09:19:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 27 Oct 2022 09:19:45 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 27 Oct 2022 09:19:43 +0800
Message-ID: <3abbe6ea016b865b6762708fe8234913884a0ed5.camel@mediatek.com>
Subject: Re: [PATCH] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
From:   haozhe chang <haozhe.chang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>
CC:     "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        Haijun Liu =?UTF-8?Q?=28=E5=88=98=E6=B5=B7=E5=86=9B=29?= 
        <haijun.liu@mediatek.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lambert Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BC=9F=29?= 
        <Lambert.Wang@mediatek.com>,
        "Xiayu Zhang =?UTF-8?Q?=28=E5=BC=A0=E5=A4=8F=E5=AE=87=29?=" 
        <Xiayu.Zhang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>
Date:   Thu, 27 Oct 2022 09:19:42 +0800
In-Reply-To: <CAMZdPi_tTBgqSGCUaB29ifOUSE5nWa6ooOa=4k8T6pXJDfpO-A@mail.gmail.com>
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
         <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
         <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
         <CAMZdPi_tTBgqSGCUaB29ifOUSE5nWa6ooOa=4k8T6pXJDfpO-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-26 at 22:27 +0800, Loic Poulain wrote:
> On Wed, 26 Oct 2022 at 13:45, haozhe chang <haozhe.chang@mediatek.com
> > wrote:
> > 
> > On Wed, 2022-10-26 at 15:28 +0800, Loic Poulain wrote:
> > > Hi Haozhe,
> > > 
> > > On Wed, 26 Oct 2022 at 03:16, <haozhe.chang@mediatek.com> wrote:
> > > > 
> > > > From: haozhe chang <haozhe.chang@mediatek.com>
> > > > 
> > > > wwan_port_fops_write inputs the SKB parameter to the TX
> > > > callback of
> > > > the WWAN device driver. However, the WWAN device (e.g., t7xx)
> > > > may
> > > > have an MTU less than the size of SKB, causing the TX buffer to
> > > > be
> > > > sliced and copied once more in the WWAN device driver.
> > > 
> > > The benefit of putting data in an skb is that it is easy to
> > > manipulate, so not sure why there is an additional copy in the
> > > first
> > > place. Isn't possible for the t7xx driver to consume the skb
> > > progressively (without intermediate copy), according to its own
> > > MTU
> > > limitation?
> > > 
> > 
> > t7xx driver needs to add metadata to the SKB head for each
> > fragment, so
> > the driver has to allocate a new buffer to copy data(skb_put_data)
> > and
> > insert metadata.
> 
> Normally, once the first part (chunk) of the skb has been consumed
> (skb_pull) and written to the device, it will become part of the
> skb headroom, which can then be used for appending (skb_push) the
> header (metadata) of the second chunks, and so... right?
> 
> Just want to avoid a bunch of unnecessary copy/alloc here.
> 
t7xx DMA can transfer multiple fragments at once, if done as
recomended, the DMA performance will be inhibited.
> Regards,
> Loic
