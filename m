Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAA4194200
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgCZOvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:51:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38761 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgCZOvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:51:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id f6so747380wmj.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GkCupglxQhwJlBvPKO1HS6od6FkHDMJGYrX+FTmaqW0=;
        b=rA+hqxCY5+7cWP7wyELrY5fDU1PncAMFOoLeRlGXgVIB1WTnH8KZsAIU1/OCajGgs6
         wJQCxdK5kmIkW06HVzspclAGhVY82b8bsyQqdwu0wMkrgDsHJai8NexQDazKeTDwiH+y
         SZ09yQ5sZ+fUsH957/hwR9XJxYPwWpJjln3w/MIyWF4B8lPqp5ksXOhnQC4DQK1E0gRs
         22heBU863nDftvmsP/uUPxF9LxvbGrKTgAHDVJjp1p+A8VYnDBBoqHMxvP+HdaUf29iV
         pPC07p/NhO+P2oB+nG+1tWZqu0c7fjwZnSr8IcFHTA5B8+6SZr/Wv4gp5+N8bTgHCanZ
         z3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GkCupglxQhwJlBvPKO1HS6od6FkHDMJGYrX+FTmaqW0=;
        b=A36rzs/5f0piUtRjIQifJ/QNZIs4YFscFrgCyX7b1HyfJjAaadgLhAuJBDk/7iiUSx
         GnWSqTRocBy3hfwZobr1qNvb2R4vJUf/JsEqVlZDkbJDpYJj13GqXiYtT4GJGzO+hRtc
         fXN3Uu2XunkOJiu4IkIcwdYLpZfbLKFwGnvko1yx68ZE6J1j4EEEeMOGWBmzgBWaXZ8k
         Ub577n8fZIUrvji4CZQ9yraXV6htkbFxc8ySxyd72Vd2u+mM1LpxUxaDHvkLVefOnN7o
         xZ17sMPYB8XOnDWTOxm4pv0HxrjBW/Q+AqBoT1ZE0vASsRICLWTrL2n7U2vXZjgb6kMm
         uIIg==
X-Gm-Message-State: ANhLgQ3sPi7EMMNwIIV3gR/BY6e9uSF928DjkzLjyjTSgFgbuZ5ZFSZK
        xyBvEcItarzb/MOz0rYFVmbXvyeFiTk=
X-Google-Smtp-Source: ADFU+vsD2CeSo3WJDGiqTmLZSDaZdYLA0QVrPRFpj4RixWxbO6YPkHLizU28Niy/ApbyysI0iJ6vWQ==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr294133wml.181.1585234308030;
        Thu, 26 Mar 2020 07:51:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v129sm1069562wmg.1.2020.03.26.07.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:51:47 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:51:46 +0100
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
Message-ID: <20200326145146.GX11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326144709.GW11304@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 03:47:09PM CET, jiri@resnulli.us wrote:
>>> >> >> $ devlink slice show
>>> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
>>> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
>>> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
>>> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
>>> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
>>> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
>>> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2    
>>> >> >
>>> >> >What are slices?    
>>> >> 
>>> >> Slice is basically a piece of ASIC. pf/vf/sf. They serve for
>>> >> configuration of the "other side of the wire". Like the mac. Hypervizor
>>> >> admin can use the slite to set the mac address of a VF which is in the
>>> >> virtual machine. Basically this should be a replacement of "ip vf"
>>> >> command.  
>>> >
>>> >I lost my mail archive but didn't we already have a long thread with
>>> >Parav about this?  
>>> 
>>> I believe so.
>>
>>Oh, well. I still don't see the need for it :( If it's one to one with
>>ports why add another API, and have to do some cross linking to get
>>from one to the other?
>>
>>I'd much rather resources hanging off the port.
>
>Yeah, I was originally saying exactly the same as you do. However, there
>might be slices that are not related to any port. Like NVE. Port does
>not make sense in that world. It is just a slice of device.
>Do we want to model those as "ports" too? Maybe. What do you think?

Also, the slice is to model "the other side of the wire":

eswitch - devlink_port ...... slice

If we have it under devlink port, it would probably
have to be nested object to have the clean cut.
