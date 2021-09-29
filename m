Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A4941C20D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245198AbhI2JyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:54:24 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:43948 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233563AbhI2JyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:54:22 -0400
X-UUID: 547a0fc1cb1546838bbdbd583c31fdfe-20210929
X-UUID: 547a0fc1cb1546838bbdbd583c31fdfe-20210929
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <jason-ch.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 48417275; Wed, 29 Sep 2021 17:52:38 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Sep 2021 17:52:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Sep
 2021 17:52:37 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Sep 2021 17:52:37 +0800
Message-ID: <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
From:   Jason-ch Chen <jason-ch.chen@mediatek.com>
To:     Hayes Wang <hayeswang@realtek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Date:   Wed, 29 Sep 2021 17:52:37 +0800
In-Reply-To: <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
         <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-29 at 08:14 +0000, Hayes Wang wrote:
> Jason-ch Chen <jason-ch.chen@mediatek.com>
> > Sent: Wednesday, September 29, 2021 1:18 PM
> 
> [...]
> > When unplugging RTL8152 Fast Ethernet Adapter which is plugged
> > into an USB HUB, the driver would get -EPROTO for bulk transfer.
> > There is a high probability to get the soft/hard lockup
> > information if the driver continues to submit Rx before the HUB
> > completes the detection of all hub ports and issue the
> > disconnect event.
> 
> I don't think it is a good idea.
> For the other situations which return the same error code, you would
> stop the rx, too.
> However, the rx may re-work after being resubmitted for the other
> cases.
> 
> Best Regards,
> Hayes
> 
Hi Hayes,

Sometimes Rx submits rapidly and the USB kernel driver of opensource
cannot receive any disconnect event due to CPU heavy loading, which
finally causes a system crash.
Do you have any suggestions to modify the r8152 driver to prevent this
situation happened?

Regards,
Jason

