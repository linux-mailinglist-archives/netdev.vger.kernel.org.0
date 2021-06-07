Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A22F39E7B7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFGTsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhFGTsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55C756105A;
        Mon,  7 Jun 2021 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623095205;
        bh=dEuiQUJnksGGg/ykRRIGjyiCgFn9ZRheR07LlYGtvQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e2YP6vifGC/D6wRChlhmZg8IRCyiOuC3qTDC8XY3E/NW8nO9IBrkTamX/Qc9yfvHg
         tEp1w89hF/tUMY/BTstIFuwLqesa0KYI02bcL7ShWZGxNWjpYBHOGJrqNdgC8E2tFL
         2kbkurPQmJfB5dj2nDyHi2e0ep5isSyFY4gOzld0rznD5B35aZzyNtPS7swWk/Rn0w
         U30jIeyG8RM2Ez808tAzVy/zF34clbtzt0el0g5KbUaELC2gIleEtVqoRu0HkMP1RC
         cUrO/xRNkt0z5as6ufslPZ3kptLuPVcf68L3x2RG3xz9loyDGgO3EikDedtcuocsej
         qEEaednhMM6Fw==
Date:   Mon, 7 Jun 2021 12:46:43 -0700
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
Message-ID: <20210607124643.1bb1c6a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <4e7a41ed-3f4d-d55d-8302-df3bc42dedd4@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
        <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Jun 2021 09:36:38 +0800 Yunsheng Lin wrote:
> On 2021/6/5 2:41, Jakub Kicinski wrote:
> > On Fri, 4 Jun 2021 09:18:04 +0800 Yunsheng Lin wrote:  
> >> My initial thinking is a id from a global IDA pool, which indeed may
> >> change on every boot.
> >>
> >> I am not really thinking much deeper about the controller id, just
> >> mirroring the bus identifiers for pcie device and ifindex for netdev,  
> > 
> > devlink instance id seems fine, but there's already a controller
> > concept in devlink so please steer clear of that naming.  
> I am not sure if controller concept already existed is reusable for
> the devlink instance representing problem for multi-function which
> shares common resource in the same ASIC. If not, we do need to pick
> up other name.
> 
> Another thing I am not really think throught is how is the VF represented
> by the devlink instance when VF is passed through to a VM.
> I was thinking about VF is represented as devlink port, just like PF(with
> different port flavour), and VF devlink port only exist on the same host
> as PF(which assumes PF is never passed through to a VM), so it may means
> the PF is responsible for creating the devlink port for VF when VF is passed
> through to a VM?
> 
> Or do we need to create a devlink instance for VF in the VM too when the
> VF is passed through to a VM? Or more specificly, does user need to query
> or configure devlink info or configuration in a VM? If not, then devlink
> instance in VM seems unnecessary?

I believe the current best practice is to create a devlink instance for
the VF with a devlink port of type "virtual". Such instance represents
a "virtualized" view of the device.

> >> which may change too if the device is pluged into different pci slot
> >> on every boot?  
> > 
> > Heh. What is someone reflashes the part to change it's serial number? :)
> > pci slot is reasonably stable, as proven by years of experience trying
> > to find stable naming for netdevs.  
> 
> I suppose that requires a booting to take effect and a vendor tool
> to reflash the serial number, it seems reasonable the vendor/user will
> try their best to not mess the serial number, otherwise service and
> maintenance based on serial number will not work?
> I was thinking about adding the vendor name besides the serial number
> to indicate a devlink instance, to avoid that case that two hw from
> different vendor having the same serial number accidentally.

I'm not opposed to the use of attributes such as serial number for
selecting instance, in principle. I was just trying to prove that PCI
slot/PCI device name is as stable as any other attribute. 

In fact for mass-produced machines using PCI slot is far more
convenient than globally unique identifiers because it can be used 
to talk to a specific device in a server for all machines of a given
model, hence easing automation.

> >> We could still allow devlink instances to have multiple names,
> >> which seems to be more like devlink tool problem?
> >>
> >> For example, devlink tool could use the id or the vendor_info/
> >> serial_number to indicate a devlink instance according to user's
> >> request.  
> > 
> > Typing serial numbers seems pretty painful.
> >   
> >> Aliase could be allowed too as long as devlink core provide a
> >> field and ops to set/get the field mirroring the ifalias for
> >> netdevice?  
> > 
> > I don't understand.  
> 
> I meant we could still allow the user to provide a more meaningful
> name to indicate a devlink instance besides the id.

To clarify/summarize my statement above serial number may be a useful
addition but PCI device names should IMHO remain the primary
identifiers, even if it means devlink instances with multiple names.

In addition I don't think that user-controlled names/aliases are
necessarily a great idea for devlink.
