Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2E24B011
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgHTHVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTHVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 03:21:21 -0400
Received: from coco.lan (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEDA72078B;
        Thu, 20 Aug 2020 07:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597908081;
        bh=Zq62Yi8puI9hJDCGZSsFugaJwyxuNLefoKRAmrJhm3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9k8h5M43Qx2spsmVYYJjRUU0UEst9opFNuXhI8qbEDJS4InjWBvL+/jFNAgQSE/e
         KY6oWBl0i07qdAXgcOKjn1UZub5AH3qe6/A149bkNB6fDwyEXfOJe0U0ysWb+cxUSQ
         4HXpQmQNlVTYCpo2TZwichIkmrV93ZSkZYbrJiXk=
Date:   Thu, 20 Aug 2020 09:21:11 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200820092111.2a5f348e@coco.lan>
In-Reply-To: <20200819204800.GA110118@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <20200819152120.GA106437@ravnborg.org>
        <20200819174027.70b39ee9@coco.lan>
        <20200819204800.GA110118@ravnborg.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sam,

Em Wed, 19 Aug 2020 22:48:00 +0200
Sam Ravnborg <sam@ravnborg.org> escreveu:

> Hi Mauro.
> 
> It seems my review comments failed to reach dri-devel - likely due to
> the size of the mail.

Probably. It reached here properly.

> Link:
> https://lore.kernel.org/linux-devicetree/20200819173558.GA3733@ravnborg.org/
> 
> I my review feedback I refer to checkpatch a few time.
> For drivers/gpu/ we have some nice tooling support.
> One thing our tooling does for us is running checkpatch every time
> we apply a patch.
> 
>     checkpatch -q --emacs --strict --show-types
> 
> So we expect patches to be more or less checkpatch --strict clean.
> 
> "more or less" - as common sense also plays a role.
> And sometimes checkpatch is just wrong.
> 
> Just in case you wondered why checkpatch --strict was requested.

We also use checkpatch --strict for media as a reference,
ignoring the things that would make things worse during review :-)

I'll run checkpatch here and ensure that the coding style
issues will be properly addressed.

Thanks,
Mauro
