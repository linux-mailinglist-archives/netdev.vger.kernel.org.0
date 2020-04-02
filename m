Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E6219BB8F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 08:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgDBGQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 02:16:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54169 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgDBGQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 02:16:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id d77so2096181wmd.3
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 23:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yC9mWaWOzMBJ3Qh+R+u7cLmiZ3txhsX2C7sa3TD+MBU=;
        b=rxSIE9ADEkgN30pHrfX6VzMhL1uhXauaADrjMlDDsOEIlNEOUK3V6R7Sq6uG5ORlCO
         XzRllYK2r3ISgfgXN0nkA8aLLNs3fCzQboix2aLwCikigbyzfCLpYgr+osd8N13CDDcC
         qj9M0xp7O/a7KCVcYoImTjxe0rn0LWeF1S1eqXncs8T0PgGbcve0CZmIqzqIS91jI1SS
         5BcHgeCajoyeSveULGGi+rZT3odv7uOnAkPmBqVEVjV1sarmqaMK0COyYApRYAjDSp4s
         rjBlqhtnM7D4HZFllBnGgNmvPiWh3I+tMYlB68SDivSadvSWG6PnN/Z2ZICQVGZCCmnw
         0leg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yC9mWaWOzMBJ3Qh+R+u7cLmiZ3txhsX2C7sa3TD+MBU=;
        b=hrP+1KbyrKhfM/vctxJyaqgO4YgQlNyTUEieUZ1UR1gEN0vqqIevKk5gde0qqZ9Vti
         TyEf9z5K4aN23irh6pm9TR9JMgG0PCXZTolDKsiXjOicj1tFK029eAyM8aTwKgnAL+As
         dOvZVShzTEAtICtH9tlJSv8Ttm2KSHJsCdgebGWGelC8wI49QSr1TS1cTyxmSVg+6okA
         aZqP5KWQDT5QxU74FhxcSgSkhW1py+K83vhO71RyyDJRuHibeZ9rmjE3Qpp/Bu30xItL
         FMW1HFSkMs5wo/4rmplzEmoGTI9qD/n8wM/QFEyxYJlq7hYNUiEWa1k2eLNiBgjHPjTh
         syeQ==
X-Gm-Message-State: AGi0PubMK5KYi03zn10whiHtkFQsIWmk4hwhdXfofoq9j1rt/Qs1t9il
        EGgXgoslMur6V0S4hpk/cC9aBQ==
X-Google-Smtp-Source: APiQypKIrbCQTLG0wSbREPfiaINE++4KsrC86Do6CGqh2APZlbn71L1mIJLxf48OMoXAEWTVrH6KpQ==
X-Received: by 2002:a1c:3b02:: with SMTP id i2mr1773115wma.139.1585808205405;
        Wed, 01 Apr 2020 23:16:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f13sm5822272wrx.56.2020.04.01.23.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 23:16:44 -0700 (PDT)
Date:   Thu, 2 Apr 2020 08:16:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
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
Message-ID: <20200402061643.GB2199@nanopsycho.orion>
References: <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
 <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
 <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 01, 2020 at 10:12:31PM CEST, kuba@kernel.org wrote:
>On Wed, 1 Apr 2020 07:32:46 +0000 Parav Pandit wrote:
>> > From: Jakub Kicinski <kuba@kernel.org>
>> > Sent: Tuesday, March 31, 2020 11:03 PM
>> > 
>> > On Tue, 31 Mar 2020 07:45:51 +0000 Parav Pandit wrote:  
>> > > > In fact very little belongs to the port in that model. So why have
>> > > > PCI ports in the first place?
>> > > >  
>> > > for few reasons.
>> > > 1. PCI ports are establishing the relationship between eswitch port
>> > > and its representor netdevice.
>> > > Relying on plain netdev name doesn't work in certain pci topology
>> > > where netdev name exceeds 15 characters.
>> > > 2. health reporters can be at port level.  
>> > 
>> > Why? The health reporters we have not AFAIK are for FW and for queues
>> > hanging. Aren't queues on the slice and FW on the device?  
>> There are multiple heath reporters per object.
>> There are per q health reporters on the representor queues (and
>> representors are attached to devlink port). Can someone can have
>> representor netdev for an eswitch port without devlink port? No,
>> net/core/devlink.c cross verify this and do WARN_ON. So devlink port
>> for eswitch are linked to representors and are needed. Their
>> existence is not a replacement for representing 'portion of the
>> device'.
>
>I don't understand what you're trying to say. My question was why are
>queues not on the "slice"? If PCIe resources are on the slice, then so
>should be the health reporters.

I agree. These should be attached to the slice.


>
>> > > 3. In future at eswitch pci port, I will be adding dpipe support
>> > > for the internal flow tables done by the driver.
>> > > 4. There were inconsistency among vendor drivers in using/abusing
>> > > phys_port_name of the eswitch ports. This is consolidated via
>> > > devlink port in core. This provides consistent view among all
>> > > vendor drivers.
>> > >
>> > > So PCI eswitch side ports are useful regardless of slice.
>> > >  
>> > > >> Additionally devlink port object doesn't go through the same
>> > > >> state machine as that what slice has to go through.
>> > > >> So its weird that some devlink port has state machine and some
>> > > >> doesn't.  
>> > > >
>> > > > You mean for VFs? I think you can add the states to the API.
>> > > >  
>> > > As we agreed above that eswitch side objects (devlink port and
>> > > representor netdev) should not be used for 'portion of device',  
>> > 
>> > We haven't agreed, I just explained how we differ.  
>> 
>> You mentioned that " Right, in my mental model representor _is_ a
>> port of the eswitch, so repr would not make sense to me."
>> 
>> With that I infer that 'any object that is directly and _always_
>> linked to eswitch and represents an eswitch port is out of question,
>> this includes devlink port of eswitch and netdev representor. Hence,
>> the comment 'we agree conceptually' to not involve devlink port of
>> eswitch and representor netdev to represent 'portion of the device'.
>
>I disagree, repr is one to one with eswitch port. Just because
>repr is associated with a devlink port doesn't mean devlink port 
>must be associated with a repr or a netdev. 
