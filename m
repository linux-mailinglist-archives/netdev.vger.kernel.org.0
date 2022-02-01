Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ADE4A60CA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiBAPyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:54:50 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:40030 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiBAPyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:54:49 -0500
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 8ECAC8030834;
        Tue,  1 Feb 2022 18:54:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 8ECAC8030834
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1643730881;
        bh=q7p/ERkbzTvBtExsgEoM33+CP/S9E+0x3HKFUadi6y8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=iTKSzGgEyOGAxVI90jaGFGlhexAc0jzav9EuDs8/ru4cqqD6GGWirWYDJYagfeQB5
         uq955UsnETah28HseAig1ZqgBn4d1rvuql/vowCkf8R+t2T67j/HKwzSsOgXuPfG1J
         xPdj8ha5gHVoCWl8FbYKLcTEZeC1wWGgzQNlQq+4=
Received: from mobilestation (192.168.168.10) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 1 Feb 2022 18:53:39 +0300
Date:   Tue, 1 Feb 2022 18:54:39 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Alexey Sheplyakov <asheplyakov@basealt.ru>,
        <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Evgeny Sinelnikov <sin@basealt.ru>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220201155439.hv42mqed2n7wekuo@mobilestation>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220128150642.qidckst5mzkpuyr3@mobilestation>
 <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
 <20220128122718.686912e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220128122718.686912e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On Fri, Jan 28, 2022 at 12:27:18PM -0800, Jakub Kicinski wrote:
> On Fri, 28 Jan 2022 22:55:09 +0400 Alexey Sheplyakov wrote:
> > On Fri, Jan 28, 2022 at 06:06:42PM +0300, Serge Semin wrote:
> > > Hello Alexey and network folks
> > > 
> > > First of all thanks for sharing this patchset with the community. The
> > > changes indeed provide a limited support for the DW GMAC embedded into
> > > the Baikal-T1/M1 SoCs. But the problem is that they don't cover all
> > > the IP-blocks/Platform-setup peculiarities  
> > 
> > In general quite a number of Linux drivers (GPUs, WiFi chips, foreign
> > filesystems, you name it) provide a limited support for the corresponding
> > hardware (filesystem, protocol, etc) and don't cover all peculiarities.
> > Yet having such a limited support in the mainline kernel is much more
> > useful than no support at all (or having to use out-of-tree drivers,
> > obosolete vendor kernels, binary blobs, etc).
> > 
> > Therefore "does not cover all peculiarities" does not sound like a valid
> > reason for rejecting this driver. That said it's definitely up to stmmac
> > maintainers to decide if the code meets the quality standards, does not
> > cause excessive maintanence burden, etc.
> 
> Sounds sensible, Serge please take a look at the v2 and let us know if
> there are any bugs in there. Or any differences in DT bindings or user
> visible behaviors with what you're planning to do. If the driver is
> functional and useful it can evolve and gain support for features and
> platforms over time.

I've already posted my comments in this thread regarding the main
problematic issues of the driver, but Alexey for some reason ignored
them (dropped from his reply). Do you want me to copy my comments to
v2 and to proceed with review there?

Regarding the DT-bindings and the user-visible behavior. Right, I'll
add my comments in this matter. Thanks for suggesting. This was one of
the problems why I was against the driver integrating into the kernel.
One of our patchset brings a better organization to the current
DT-bindings of the Synopsys DW *MAC devices. In particular it splits
up the generic bindings for the vendor-specific MACs to use and the
bindings for the pure DW MAC compatible devices. In addition the
patchset will add the generic Tx/Rx clocks DT-bindings and the
DT-bindings for the AXI/MTL nodes. All of that and the rest of our
work will be posted a bit later as a set of the incremental patchsets
with small changes, one by one, for an easier review. We just need
some more time to finish the left of the work. The reason why the
already developed patches hasn't been delivered yet is that the rest
of the work may cause adding changes into the previous patches. In
order to decrease a number of the patches to review and present a
complete work for the community, we decided to post the patchsets
after the work is fully done.

-Sergey
