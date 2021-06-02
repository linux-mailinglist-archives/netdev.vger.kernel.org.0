Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41F639900D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhFBQg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhFBQgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 12:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DE146195D;
        Wed,  2 Jun 2021 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622651681;
        bh=Y2ts2VeQeEJTY79Gee4DzDpGZoCnZg5+an2ZFNY8gG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QmpK0+TKSa2zCg7hBNdXN9TACnD4ATU7xa6jhEZIxCAMoEcLyi7lOIUigURaWFho3
         4/OJjCIvqxUQA5CONGO+axKQGvXwX/IyrcGBjvhxTczs51byXJ+9XFjhN3Yc0EylHe
         qzKVY/IygUalQXnKwI57CAiJIV/Rt8duU8u3yf1P0zo5Q4PmQwupb0LaoNg6fRPpSs
         Crt3n/h3xAqXBpIsTN4Sl/biqydl9Kp2U/alpfOEJfq+tXvmizx+SWFQI0WZPkGz2f
         YoahiJo3VedeFG+pjEs4WJNCpwuDgwP0GZHtNnOKhOWFudSq2iW00TblXh5Z8bIN68
         0nKDcBC0Y29hw==
Date:   Wed, 2 Jun 2021 09:34:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <20190301120358.7970f0ad@cakuba.netronome.com>
        <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190304174551.2300b7bc@cakuba.netronome.com>
        <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
        <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
        <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 10:24:11 +0800 Yunsheng Lin wrote:
> On 2021/6/2 5:34, Jakub Kicinski wrote:
> > On Tue, 1 Jun 2021 15:33:09 +0800 Yunsheng Lin wrote:  
> >> Is there a reason why it didn't have to be solved yet?
> >> Is it because the devices currently supporting devlink do not have
> >> this kind of problem, like single-function ASIC or multi-function
> >> ASIC without sharing common resource?  
> > 
> > I'm not 100% sure, my guess is multi-function devices supporting
> > devlink are simple enough for the problem not to matter all that much.
> >   
> >> Was there a discussion how to solved it in the past?  
> > 
> > Not really, we floated an idea of creating aliases for devlink
> > instances so a single devlink instance could answer to multiple 
> > bus identifiers. But nothing concrete.  
> 
> What does it mean by "answer to multiple bus identifiers"? I
> suppose it means user provides the bus identifiers when setting or
> getting something, and devlink instance uses that bus identifiers
> to differentiate different PF in the same ASIC?

Correct.

> can devlink port be used to indicate different PF in the same ASIC,
> which already has the bus identifiers in it? It seems we need a
> extra identifier to indicate the ASIC?
> 
> $ devlink port show
> ...
> pci/0000:03:00.0/61: type eth netdev sw1p1s0 split_group 0

Ports can obviously be used, but which PCI device will you use to
register the devlink instance? Perhaps using just one doesn't matter 
if there is only one NIC in the system, but may be confusing with
multiple NICs, no?

> >> "same control domain" means if it is controlled by a single host, not
> >> by multi hosts, right?
> >>
> >> If the PF is not passed through to a vm using VFIO and other PF is still
> >> in the host, then I think we can say it is controlled by a single host.
> >>
> >> And each PF is trusted with each other right now, at least at the driver
> >> level, but not between VF.  
> > 
> > Right, the challenge AFAIU is how to match up multiple functions into 
> > a single devlink instance, when driver has to probe them one by one.  
> 
> Does it make sense if the PF first probed creates a auxiliary device,
> and the auxiliary device driver creates the devlink instance? And
> the PF probed later can connect/register to that devlink instance?

I would say no, that just adds another layer of complication and
doesn't link the functions in any way.

> > If there is no requirement that different functions are securely
> > isolated it becomes a lot simpler (e.g. just compare device serial
> > numbers).  
> 
> Is there any known requirement if the different functions are not
> securely isolated?

Not sure I understand. If the functions are in different domains 
of control allowing one of them to dump state of the other may be
problematic given features like TLS offload, for instance.
