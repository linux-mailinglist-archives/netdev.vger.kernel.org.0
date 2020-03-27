Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392D019524C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 08:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgC0Hrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 03:47:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40656 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0Hrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 03:47:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so11242439wmf.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 00:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQYg8gsKVdXwiev0CxJjfobTE7ek50t3MJQZVWjYu18=;
        b=keCRhVNaRwr5ruIK7zVVILc70WsOY5NoyLyYv8EQsjMmTzwin0XqMaC+8k+G0f01nE
         Zre2ICuPBPDeO+0LmXIxlrRR/nnBPT9IlQVfCFi3ZzmkCyS+x3bM41aijK47WD4JxYT2
         FOn1oUSUX25smWRiASYNH4ALDyjLnKQCsmVrSLidMwYQAGsgfT28p05H023oAIzttUCK
         1muGROct73OiuxOjKY+nIiwZKX2QF1YN2aMo7Ui3SUNfI7ErM7v+UlAR3uemUbaJeqB9
         bBkwVJ5z1QOKxTgOItEGKIrOEIewywhIFaKq4gIqzGGSNk8hJyx7qokqy7mGQQm7Xkop
         vWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XQYg8gsKVdXwiev0CxJjfobTE7ek50t3MJQZVWjYu18=;
        b=Uct0EyOJSOqI19MCaA4sNI6GlWcJF678tQ86iPVQ4OqbCWkauU1D2ldPFmsjeWQMT9
         B7pCKSYkeZLs/JXvzVFyG0OUFx5/6799CwhyuYZ/bjcEwzCsrRbU2dLaroiwLQrF4UJm
         3PxFBH67X9/Np22kSRIJA6VipZxZqNYkoY0nvrxTi8xGX7naudji+xAoST6qK6fmCkF6
         5HEh6Cr8XgNJ2i20LKn+a4N5OG4hRmWbMfBuC46mXnkdeLlNpcq3lbnRBZcPAsCALieh
         zW73hWIbaXrAiwsm3uQ50J8be6j8DKcTATCRVqsHSFXWDRACW+j1PRhgdv2XAh5qv0m0
         fdmA==
X-Gm-Message-State: ANhLgQ3XYrcTQd/ZVhcMfczeQQfFP7kveNUJdaUl1eCL5DH1KXJjYr6u
        41brAWj9dzHxyHdgCBNXdqerRg==
X-Google-Smtp-Source: ADFU+vvw3c0Q2BD4UdqauW23UIEgQEy6yFB2u6vY0dYNyi+NxmekxVWxGclTwFAVM/HCAr6grQ+3lg==
X-Received: by 2002:a7b:cc81:: with SMTP id p1mr3959249wma.158.1585295257921;
        Fri, 27 Mar 2020 00:47:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u16sm7624227wro.23.2020.03.27.00.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 00:47:37 -0700 (PDT)
Date:   Fri, 27 Mar 2020 08:47:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200327074736.GJ11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 09:30:01PM CET, kuba@kernel.org wrote:
>On Thu, 26 Mar 2020 15:51:46 +0100 Jiri Pirko wrote:
>> Thu, Mar 26, 2020 at 03:47:09PM CET, jiri@resnulli.us wrote:
>> >>> >> >> $ devlink slice show
>> >>> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
>> >>> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
>> >>> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
>> >>> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
>> >>> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
>> >>> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
>> >>> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2      
>> >>> >> >
>> >>> >> >What are slices?      
>> >>> >> 
>> >>> >> Slice is basically a piece of ASIC. pf/vf/sf. They serve for
>> >>> >> configuration of the "other side of the wire". Like the mac. Hypervizor
>> >>> >> admin can use the slite to set the mac address of a VF which is in the
>> >>> >> virtual machine. Basically this should be a replacement of "ip vf"
>> >>> >> command.    
>> >>> >
>> >>> >I lost my mail archive but didn't we already have a long thread with
>> >>> >Parav about this?    
>> >>> 
>> >>> I believe so.  
>> >>
>> >>Oh, well. I still don't see the need for it :( If it's one to one with
>> >>ports why add another API, and have to do some cross linking to get
>> >>from one to the other?
>> >>
>> >>I'd much rather resources hanging off the port.  
>> >
>> >Yeah, I was originally saying exactly the same as you do. However, there
>> >might be slices that are not related to any port. Like NVE. Port does
>> >not make sense in that world. It is just a slice of device.
>> >Do we want to model those as "ports" too? Maybe. What do you think?  
>> 
>> Also, the slice is to model "the other side of the wire":
>> 
>> eswitch - devlink_port ...... slice
>> 
>> If we have it under devlink port, it would probably
>> have to be nested object to have the clean cut.
>
>So the queues, interrupts, and other resources are also part 
>of the slice then?

Yep, that seems to make sense.

>
>How do slice parameters like rate apply to NVMe?

Not really.

>
>Are ports always ethernet? and slices also cover endpoints with
>transport stack offloaded to the NIC?

devlink_port now can be either "ethernet" or "infiniband". Perhaps,
there can be port type "nve" which would contain only some of the
config options and would not have a representor "netdev/ibdev" linked.
I don't know.
