Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1419D39FD9B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhFHRbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhFHRbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 13:31:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE00061375;
        Tue,  8 Jun 2021 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623173386;
        bh=ItzIBqXzJpZDik1ri9ZEy8dxLAgX/jhstdp/QleUEsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G9S49rKKT40nOKxSt69vJEFFnV8Nn1Avanob9mZSh5tccDrdgUcm+1K5/b7V+fiug
         ANtP7zi+Ii87TBfezRzw2P4IZwtJwz9qqKmN56J3Wi4aYgipkd1QOyplk2bvJ4CTv8
         LBTE3Uvs56lWYlAPTytWFKWIdGZAvJg2D43+Hzfo70M86F7v0xD0B714ccUm7R85UA
         viojxo48doTrAaLZCKM3uplWuFy4bIiQWJQzpCp/nM1oD/ycfO+Sog0HxtpiF/OeNz
         Sqi71l6fUlrR1ui3lVnBRj20+hTIIipY6JyZK/O407e+tCEozQom731MentiJ7UAcG
         JdU+3CLk8wMJQ==
Date:   Tue, 8 Jun 2021 10:29:45 -0700
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
        Jiaran Zhang <zhangjiaran@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
Message-ID: <20210608102945.3edff79a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <20190304174551.2300b7bc@cakuba.netronome.com>
        <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
        <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
        <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
        <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
        <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
        <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
        <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <530ff54c-3cee-0eb6-30b0-b607826f68cf@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 20:10:37 +0800 Yunsheng Lin wrote:
> >> I am not sure if controller concept already existed is reusable for
> >> the devlink instance representing problem for multi-function which
> >> shares common resource in the same ASIC. If not, we do need to pick
> >> up other name.
> >>
> >> Another thing I am not really think throught is how is the VF represented
> >> by the devlink instance when VF is passed through to a VM.
> >> I was thinking about VF is represented as devlink port, just like PF(with
> >> different port flavour), and VF devlink port only exist on the same host
> >> as PF(which assumes PF is never passed through to a VM), so it may means
> >> the PF is responsible for creating the devlink port for VF when VF is passed
> >> through to a VM?
> >>
> >> Or do we need to create a devlink instance for VF in the VM too when the
> >> VF is passed through to a VM? Or more specificly, does user need to query
> >> or configure devlink info or configuration in a VM? If not, then devlink
> >> instance in VM seems unnecessary?  
> > 
> > I believe the current best practice is to create a devlink instance for
> > the VF with a devlink port of type "virtual". Such instance represents
> > a "virtualized" view of the device.  
> 
> Afer discussion with Parav in other thread, I undersood it was the current
> practice, but I am not sure I understand why it is current *best* practice.
> 
> If we allow all PF of a ASCI to register to the same devlink instance, does
> it not make sense that all VF under one PF also register to the same devlink
> instance that it's PF is registering to when they are in the same host?
> 
> For eswitch legacy mode, whether VF and PF are the same host or not, the VF
> can also provide the serial number of a ASIC to register to the devlink instance,
> if that devlink instance does not exist yet, just create that devlink instance
> according to the serial number, just like PF does.
> 
> For eswitch DEVLINK_ESWITCH_MODE_SWITCHDEV mode, the flavour type for devlink
> port instance representing the netdev of VF function is FLAVOUR_VIRTUAL, the
> flavour type for devlink port instance representing the representor netdev of
> VF is FLAVOUR_PCI_VF, which are different type, so they can register to the same
> devlink instance even when both of the devlink port instance is in the same host?
> 
> Is there any reason why VF use its own devlink instance?

Primary use case for VFs is virtual environments where guest isn't
trusted, so tying the VF to the main devlink instance, over which guest
should have no control is counter productive.

> >> I meant we could still allow the user to provide a more meaningful
> >> name to indicate a devlink instance besides the id.  
> > 
> > To clarify/summarize my statement above serial number may be a useful
> > addition but PCI device names should IMHO remain the primary
> > identifiers, even if it means devlink instances with multiple names.  
> 
> I am not sure I understand what does it mean by "devlink instances with
> multiple names"?
> 
> Does that mean whenever a devlink port instance is registered to a devlink
> instance, that devlink instance get a new name according to the PCI device
> which the just registered devlink port instance corresponds to?

Not devlink port, new PCI device. Multiple ports may reside on the same
PCI function, some ports don't have a function (e.g. Ethernet ports).
