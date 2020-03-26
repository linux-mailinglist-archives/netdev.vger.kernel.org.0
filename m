Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E031941DC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgCZOrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:47:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36433 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgCZOrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:47:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so8149740wrs.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LTj5at+6VWHUfGMfO7yZi6Qh9SHUcC+eDdBlZp7NEhQ=;
        b=vEN/KfUQGWj7EuOSpbmn50lKajaJgqfDc7khcOgfB5jX1uP8ylNTyhpYjdJslrRhrY
         HBZ8PU0PxocSNoeTDTUSqHmJIl9zGshlbpgS3tYxC8cw0RnwBxpRFMYdLTfq+lOEl04v
         BOA+2tJ8uNYuo7gNak3IgPmbhNUEQ75+bBk5Y+jgPxyPAjkGvfQYUTZuvLGaWC/fh9ge
         ioNiyZAZH74SpmlVDzvtn0zEWRRJkwcs7iGOa3TNcQvCj4R6DhG+slkvnZ6GbOjpN5Gw
         G+kI1aA8haFbliUXB1TwVfoeuamS/Tq8fQAVl3r/+JxhYDa+ABqqJT+ifKjaU0LqU2zJ
         DJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LTj5at+6VWHUfGMfO7yZi6Qh9SHUcC+eDdBlZp7NEhQ=;
        b=DI7QYkNui75VN2aKLJ2xj+tmTliKkIEaoTYukFjWzhgz7J2Vijs5uF8DPb+GSUlIgh
         X37HTco086/CVyHslDEkiA0/42rFD5cWq1TWvPW9sjirV5sW+1Y/delbSSyJzGIDyDh3
         GIY7gYJi6xImLT8DBFNBSG3ZZC4CVb8OLOn4Mzc9PgI8Qx3vgv7Fdce9ZHtIKsI2tkgt
         OtnizLdDfBQDtSMZVxu7a+n/llYbPUFI+yhXeRLwBVqYYP5TfWIdwbGj95miJxLaf78A
         884yNqGPftL/0a1pwcc3ulhdIXAyUxaFLCSc8ol+fsvLNkuZG7cZitMprmOpu9TqclQO
         GZGQ==
X-Gm-Message-State: ANhLgQ2Eb0jslFWgMfdRA7r0OQi9+pt40wek2oVQoBhqrz8JlfflqPOa
        QS8OvNYAoo6JuTnfQZ3ulf9nQg==
X-Google-Smtp-Source: ADFU+vt2ONNUmHv2DR9pQ3PMl+M1fSt3OwoPJMcvwQfK4GfyAXbb2Th0LSinnM0KiqbmgI6EIge0bg==
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr10403773wrj.219.1585234030724;
        Thu, 26 Mar 2020 07:47:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d21sm3965233wrb.51.2020.03.26.07.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:47:10 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:47:09 +0100
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
Message-ID: <20200326144709.GW11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> >> $ devlink slice show
>> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
>> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
>> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
>> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
>> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
>> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
>> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2    
>> >> >
>> >> >What are slices?    
>> >> 
>> >> Slice is basically a piece of ASIC. pf/vf/sf. They serve for
>> >> configuration of the "other side of the wire". Like the mac. Hypervizor
>> >> admin can use the slite to set the mac address of a VF which is in the
>> >> virtual machine. Basically this should be a replacement of "ip vf"
>> >> command.  
>> >
>> >I lost my mail archive but didn't we already have a long thread with
>> >Parav about this?  
>> 
>> I believe so.
>
>Oh, well. I still don't see the need for it :( If it's one to one with
>ports why add another API, and have to do some cross linking to get
>from one to the other?
>
>I'd much rather resources hanging off the port.

Yeah, I was originally saying exactly the same as you do. However, there
might be slices that are not related to any port. Like NVE. Port does
not make sense in that world. It is just a slice of device.
Do we want to model those as "ports" too? Maybe. What do you think?
