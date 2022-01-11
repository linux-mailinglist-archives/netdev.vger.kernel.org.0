Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220CC48A821
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 08:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348413AbiAKHJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 02:09:56 -0500
Received: from mxhk.zte.com.cn ([63.216.63.35]:46472 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbiAKHJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 02:09:55 -0500
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4JY1zP3Nwmz83Lwn;
        Tue, 11 Jan 2022 15:09:53 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl1.zte.com.cn with SMTP id 20B79fBY066368;
        Tue, 11 Jan 2022 15:09:41 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 11 Jan 2022 15:09:40 +0800 (CST)
Date:   Tue, 11 Jan 2022 15:09:40 +0800 (CST)
X-Zmail-TransId: 2b0461dd2d3495c83906
X-Mailer: Zmail v1.0
Message-ID: <202201111509409733901@zte.com.cn>
In-Reply-To: <CACGkMEvdKATVvLVQtfPfSeev83Ajskg4gFoHDhWT7wrWEQ3FEA@mail.gmail.com>
References: 20211224070404.54840-1-wang.yi59@zte.com.cn,CACGkMEvdKATVvLVQtfPfSeev83Ajskg4gFoHDhWT7wrWEQ3FEA@mail.gmail.com
Mime-Version: 1.0
From:   <wang.yi59@zte.com.cn>
To:     <jasowang@redhat.com>
Cc:     <mst@redhat.com>, <sgarzare@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xue.zhihong@zte.com.cn>, <wang.liang82@zte.com.cn>,
        <zhang.min9@zte.com.cn>
Subject: =?UTF-8?B?UmU6W1BBVENIIHYyXSB2ZHBhOiByZWdpc3Qgdmhvc3QtdmRwYSBkZXYgY2xhc3M=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 20B79fBY066368
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 61DD2D41.000 by FangMail milter!
X-FangMail-Envelope: 1641884993/4JY1zP3Nwmz83Lwn/61DD2D41.000/10.30.14.238/[10.30.14.238]/mse-fl1.zte.com.cn/<wang.yi59@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 61DD2D41.000/4JY1zP3Nwmz83Lwn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,
> On Fri, Dec 24, 2021 at 3:13 PM Yi Wangwrote:
> >
> > From: Zhang Min
> >
> > Some applications like kata-containers need to acquire MAJOR/MINOR/DEVNAME
> > for devInfo [1], so regist vhost-vdpa dev class to expose uevent.
>
> Hi:
>
> I think we need to be more verbose here e.g:
>
> 1) why can't we get major/minor with the current interface

Although major/minor can be acquired in /sys/bus/vdpa/devices/vdpa0/vhost-vdpa/vhost-vdpa-0/dev,
applications like kata-containers prefer and actually have tried to obtain them
in /sys/class/vhost-vdpa/vhost-vdpa-0/uevent, such like [1].

> 2) what kind of the uevent is required and not supported currently

The items needed show in uevent are MAJOR MINOR DEVNAME that vhost_vdpa_probe
currently has registed, but dev_uevent_filter failed to pass and uevent show is
empty now, so we regist dev class to let dev_uevent_filter pass and show them.

1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go

>
> Thanks
>
> >
> > 1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go
> >
> > Signed-off-by: Zhang Min
