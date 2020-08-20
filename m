Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE0424AF59
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHTGkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTGkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 02:40:41 -0400
Received: from coco.lan (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D847220786;
        Thu, 20 Aug 2020 06:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597905640;
        bh=smEfryQX4LpVGJzthIRWac0/v0EWxUcxXXFygmlh3ss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVpRlkTA4U4rKgGuZwZCNYKjnVf9jx9QyQlWzioyqxEFKFORZR+nmJ3A1W5F4jif/
         BJYtLKuGsdnPxO5hTUeXwINInbRp8ypXBnFZxS/ysUVhzONji7yUZ2lF5OFSGgTyUY
         312IwaWgMhztAUA9bEhtGh6dl9ki8qovoCmm2Kpk=
Date:   Thu, 20 Aug 2020 08:40:30 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxarm@huawei.com, mauro.chehab@huawei.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Liwei Cai <cailiwei@hisilicon.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        linux-media <linux-media@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Rob Clark <robdclark@chromium.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Liuyao An <anliuyao@huawei.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Wei Xu <xuwei5@hisilicon.com>,
        Rongrong Zou <zourongrong@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Network Development <netdev@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Chen Feng <puck.chen@hisilicon.com>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200820084030.3663de78@coco.lan>
In-Reply-To: <20200819212551.GA114762@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <CALAqxLVRsPKv-xmxQfBFaBa9XOmSfrFj3w9_zyfzNJk8+Kfjug@mail.gmail.com>
        <20200819212551.GA114762@ravnborg.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 19 Aug 2020 23:25:51 +0200
Sam Ravnborg <sam@ravnborg.org> escreveu:

> Hi John.
> 
> > > So, IMO, the best is to keep it on staging for a while, until those
> > > remaining bugs gets solved.  
> > 
> > I'm not sure I see all of these as compelling for pushing it in via
> > staging. And I suspect in the process of submitting the patches for
> > review folks may find the cause of some of the problems you list here.  
> 
> There is a tendency to forget drivers in staging, and with the almost
> constant refactoring that happens in the drm drivers we would end up
> fixing this driver when a bot trigger an error.
> So IMO we need very good reasons to go in via staging.

My plan is to have this driver upstream for 5.10, and getting it
out of staging by Kernel 5.11. So, I doubt that the DRM kAPIs would
change a lot during those 2 Kernel cycles.

In any case, I'm also fine to have a final patch at the end of this
series moving it out of staging. The only thing that, IMHO, prevents
it to be out of staging is the LDI underflow. Right now, if no input
events reach the driver, DPMS will put the monitor to suspend, and
it never returns back from life. I bet that, once we discover the
root cause, the fix would be just a couple of lines, but identifying
where the problem is can take a while.

Thanks,
Mauro
