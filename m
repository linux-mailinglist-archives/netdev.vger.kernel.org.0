Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04A39BFCD
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFDSm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFDSm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 14:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D64C361420;
        Fri,  4 Jun 2021 18:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622832070;
        bh=YXxpD1vUwL0WAWe/atfH4lFwiD4Zg6mcW758XW94/q4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fw2E7eqUVBR5BpnGBehjo7PXtgkbZYbWw7+4qSUbSWvxooMFuSgXjzPrzGgGP9Q30
         z1EcAqkT752PgKwuYZcvgLJCaWffBcBTY1FmU7Urx9sguTaFJWLfIxkwETf/WzEurL
         fSNOS+gcKlGDAYGDEmG6W9zzR0Wb/sdcf8QlT9Yjm7/9lKpNmzm7yv4J+XFwn0ze+4
         RDlJNKG8+fZtOLG1qORRjdLuN/Q2S0Fh1VpJL8dFMF33Nq/uwnPlOpaCvuQKRtKYVf
         TTsaFyJTTusPOEpj4mja7K9RAEL8+loTyX8aJlI87DiKsLh4ThH6cRg3yyL75zv1Hi
         1FWWpACOlCrAA==
Date:   Fri, 4 Jun 2021 11:41:09 -0700
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
Message-ID: <20210604114109.3a7ada85@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
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
        <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
        <20210603105311.27bb0c4d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c9afecb5-3c0e-6421-ea58-b041d8173636@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Jun 2021 09:18:04 +0800 Yunsheng Lin wrote:
> >> Yes, it is confusing, how about using the controler_id to indicate
> >> different NIC? we can make sure controler_id is unqiue in the same
> >> host, a controler_id corresponds to a devlink instance, vendor info
> >> or serial num for the devlink instance can further indicate more info
> >> to the system user?
> >>
> >> pci/controler_id/0000:03:00.0/61  
> > 
> > What is a "controller id" in concrete terms? Another abstract ID which
> > may change on every boot?  
> 
> My initial thinking is a id from a global IDA pool, which indeed may
> change on every boot.
> 
> I am not really thinking much deeper about the controller id, just
> mirroring the bus identifiers for pcie device and ifindex for netdev,

devlink instance id seems fine, but there's already a controller
concept in devlink so please steer clear of that naming.

> which may change too if the device is pluged into different pci slot
> on every boot?

Heh. What is someone reflashes the part to change it's serial number? :)
pci slot is reasonably stable, as proven by years of experience trying
to find stable naming for netdevs.

> >> How about:
> >> The PF first probed creates the devlink instance? PF probed later can
> >> connect/register to that devlink instance created by the PF first probed.
> >> It seems some locking need to ensure the above happens as intended too.
> >>
> >> About linking, the PF provide vendor info/serial number(or whatever is
> >> unqiue between different vendor) of a controller it belong to, if the
> >> controller does not exist yet, create one and connect/register to that
> >> devlink instance, otherwise just do the connecting/registering.  
> > 
> > Sounds about right, but I don't understand why another ID is
> > necessary. Why not allow devlink instances to have multiple names, 
> > like we allow aliases for netdevs these days?  
> 
> We could still allow devlink instances to have multiple names,
> which seems to be more like devlink tool problem?
> 
> For example, devlink tool could use the id or the vendor_info/
> serial_number to indicate a devlink instance according to user's
> request.

Typing serial numbers seems pretty painful.

> Aliase could be allowed too as long as devlink core provide a
> field and ops to set/get the field mirroring the ifalias for
> netdevice?

I don't understand.
