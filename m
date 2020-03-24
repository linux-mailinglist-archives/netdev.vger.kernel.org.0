Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D8E191188
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCXNoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:44:09 -0400
Received: from mail-qv1-f48.google.com ([209.85.219.48]:37478 "EHLO
        mail-qv1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgCXNoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:44:00 -0400
Received: by mail-qv1-f48.google.com with SMTP id n1so9193367qvz.4
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 06:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LYb7AqsR6P+Kz0HB0VXQpq0nk/88Ht3Nm5p8wDHO4Lo=;
        b=Oup6GJf8YMIrCdnYBx/ghpf/OYZ+XGL9XddthiMAX3euJilG4BzIo0FMjXYUwofHHF
         9mLtQinH+f+3xWpVOIO3Z+9N+TE9xGoTfjWpsVgwab+sHXNePYKeZF3I9uX4uleNyu6L
         iIBCX5dY7LWwsd0z3w33W/vFpyOmWETOoKo7iCztq62OG76TiJAvELVx8h8Kv0KhcBqa
         Uq0fcamuebY8fgyvxen27JGssbmwFN3tTf9R6iDe4153jR/2J9c5/zeI41qB02tp4NHY
         BcH+pRhEsUNoSiLv3jUkUz05JI0avrjrNICndGkRQ10xAgr3Bcj52kZlOpkA4z0eemNw
         A7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LYb7AqsR6P+Kz0HB0VXQpq0nk/88Ht3Nm5p8wDHO4Lo=;
        b=jH5OTphzrf5fQVT239HOPnCuLetbPiSZppEMybfdUCsnsVUGbGhHbkeh5lYhQOKXQ+
         /GNwuyeWy99B29ly8pds7D7QHpg3EVsDTixnyaiDLzCGbzSdzGnl92kzejE/oAM3qz7H
         S/4whbJi2ze+uIBRJpC0qtRYy95qhG2PSwkiFN8kTaDnChFK0EhuAuT+oqbONPBq+p7C
         zhh6SzVkl2RwdPp/1BshVrDedMzGKWJpUNT2castapwkIZckbmvqsr9gHF0xjLGcW6ed
         veYSijEl3hok15sBOqjwFC3Qea4KU4vzS4tu8Uq4xn3bkYxN+l0yImqNzGeNYu1Up0ds
         p8xg==
X-Gm-Message-State: ANhLgQ3yOKiY9ypoq95Wml4h0iKhkCirdIDIqO1jmVuleFAFgKkWrQyS
        rU7APD6HViLhNiWgYLW7Ceu/Jw==
X-Google-Smtp-Source: ADFU+vuK9Tc/6jyxR77yqELtWOh2e/EkqijMDCU1p2pXU7glvkh/z+0uzRxf/6ka1KmTaf+fcTKx7Q==
X-Received: by 2002:a0c:fb12:: with SMTP id c18mr6248075qvp.171.1585057438488;
        Tue, 24 Mar 2020 06:43:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 82sm13475084qkd.62.2020.03.24.06.43.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Mar 2020 06:43:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGjqX-0002Yj-2R; Tue, 24 Mar 2020 10:43:57 -0300
Date:   Tue, 24 Mar 2020 10:43:57 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200324134357.GJ20941@ziepe.ca>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
 <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200323225009.GA1839@ziepe.ca>
 <20200323204116.7c2f6e46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323204116.7c2f6e46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 08:41:16PM -0700, Jakub Kicinski wrote:
> On Mon, 23 Mar 2020 19:50:09 -0300 Jason Gunthorpe wrote:
> > On Mon, Mar 23, 2020 at 12:31:16PM -0700, Jakub Kicinski wrote:
> > 
> > > Right, that is the point. It's the host admin that wants the new
> > > entity, so if possible it'd be better if they could just ask for it 
> > > via devlink rather than some cloud API. Not that I'm completely opposed
> > > to a cloud API - just seems unnecessary here.  
> > 
> > The cloud API provides all the permissions checks and security
> > elements. It cannot be avoided.
> 
> Ack, the question is just who consults the cloud API, the Host or the
> SmartNIC (latter would abstract differences between cloud APIs).

I feel it is more natural to use the native cloud API. It will always
have the right feature set and authorization scheme. If we try to make
a lowest common denominator in devlink then it will probably be a poor
match, and possibly very complicated.

We have to support push auto-creation anyhow to make the 'device
pre-exists at boot time' case work right.

> > If you try to do it as you say then it is weird. You have to use the
> > cloud API to authorize the VM to touch a certain network, then the VM
> > has to somehow take that network ID and use devlink to get a netdev
> > for it. And the cloud side has to protect against a hostile VM sending
> > garbage along this communication channel.
> 
> I don't understand how the VM needs to know the network ID, quite the
> opposite, the Network ID should be gettable/settable by the hypervisor/
> /PF.

I don't follow, if I have thousands of vlans in my cloud world I need
some way to label them all. If the VM is going to ask for a specific
vlan to be plugged into it, then it needs to ask with the right label.

> > vs simply host plugging in the correct network fully operational when
> > the cloud API connects the VM to the network.
> 
> That means the user has to pre-allocate the device ID, or query the
> cloud API after the device is created about its attributes (in the case
> of two interfaces being requested simultaneously).

I suppose it would use MAC address matching, the cloud creation action
will indicate the MAC and the netdev will appear with that MAC when it
is ready

I think we could do a better job passing some kind of meta-information
into the guest..

Jason
