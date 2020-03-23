Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52061901E3
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgCWXcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:32:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35405 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgCWXcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:32:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id d5so6981086wrn.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 16:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=greyhouse-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FmUnb5yoFNj3fmP68Je1AGik/in+cu9VGqz4KWMCf90=;
        b=E6BXiw+cOMPaa84WMLwtyIRRYMo5KkWkCnyKgaxW6mV/hQI1LJ7cosFFmKFF+mReMB
         zWTZ2GBl+0iTsMbg7ZSeKoZ8SrtoL6JBOgc/4Kzv56bPVZfxnXJmomRzGSw4xItNBqWh
         woeNes3WP47saLLyI6Ijte2UIVZj9O9SZvds60H5Z47d3CH5Tid3p0sAakYa5rUlvw/k
         eALYlL2PeFIuMIvWBMtxdVtYRPEboCeZE4PqbBh+k4RLtI2dwy6te/ZZVcSZ3eSw1syB
         mzmGOtQXh4a/clQdiQpejkXgJjZb61tTQqOiI2LmJc3ENXiuavQ/pdkyWB9atL0JThDt
         sk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FmUnb5yoFNj3fmP68Je1AGik/in+cu9VGqz4KWMCf90=;
        b=b94v1GACGRBC2hBKOEF7BzweqAHDFxUlsMXf6Piu1N/UmOrPc8Y5mPdG07RRA0nkAO
         mF1VI1rj0cvqTs5ZtBvenFyxJffxdK2ftz8SOIy5FDiSYI+Lex676RQ4DBalRtWTMKnd
         MhshmR7urIfwBz+tsYttb+N1goFfikc4uve1Jf3gF7D0aqsU0fUT3lovqDHzKMUg49CQ
         u+8/t+Jue4efgIRMoXWYjxCWPyV82IHBP21Gtheu8KLltAZAk4JFPmzyVWo/9JuiSlEQ
         Gvc6UOZSyrd/HYjThtjAkcHMWFO9XLu9bpxdgAJgNJxjWnroMzep9dxKT25yCfWgQXrn
         TexA==
X-Gm-Message-State: ANhLgQ1W56TTJC2rzLyCH0Wc3H1M3XK8G3VAnqxp/TSCM5p2uOWVpawz
        JuPDj5h9ZtQiByQa6yPRnrjYtw==
X-Google-Smtp-Source: ADFU+vuOHEFXDTbHaLGGSFJa90vrQIXo+FW3KVzrULpsxWFYYNDV7LCi1W4DoAr21inrZlHXKs4kzA==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr12351788wrp.23.1585006328091;
        Mon, 23 Mar 2020 16:32:08 -0700 (PDT)
Received: from C02YVCJELVCG.greyhouse.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id o4sm25557734wrp.84.2020.03.23.16.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 16:32:07 -0700 (PDT)
Date:   Mon, 23 Mar 2020 19:32:00 -0400
From:   Andy Gospodarek <andy@greyhouse.net>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@mellanox.com, yuvalav@mellanox.com,
        jgg@ziepe.ca, saeedm@mellanox.com, leon@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        moshe@mellanox.com, ayal@mellanox.com, eranbe@mellanox.com,
        vladbu@mellanox.com, kliteyn@mellanox.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, tariqt@mellanox.com,
        oss-drivers@netronome.com, snelson@pensando.io,
        drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323233200.GD21532@C02YVCJELVCG.greyhouse.net>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321093525.GJ11304@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 10:35:25AM +0100, Jiri Pirko wrote:
> Fri, Mar 20, 2020 at 10:25:08PM CET, kuba@kernel.org wrote:
> >On Fri, 20 Mar 2020 08:35:55 +0100 Jiri Pirko wrote:
> >> Fri, Mar 20, 2020 at 04:32:53AM CET, kuba@kernel.org wrote:
> >> >On Thu, 19 Mar 2020 20:27:19 +0100 Jiri Pirko wrote:  
[...]
> >
> >Also, once the PFs are created user may want to use them together 
> >or delegate to a VM/namespace. So when I was thinking we'd need some 
> >sort of a secure handshake between PFs and FW for the host to prove 
> >to FW that the PFs belong to the same domain of control, and their
> >resources (and eswitches) can be pooled.
> >
> >I'm digressing..
> 
> Yeah. This needs to be sorted out.
> 
> 
> >
> >> Now the PF itself can have a "nested eswitch" to manage. The "parent
> >> eswitch" where the PF was created would only see one leg to the "nested
> >> eswitch".
> >> 
> >> This "nested eswitch management" might or might not be required. Depends
> >> on a usecare. The question was, how to configure that I as a user
> >> want this or not.
> >
> >Ack. I'm extending your question. I think the question is not only who
> >controls the eswitch but also which PFs share the eswitch.
> 
> Yes.
> 

So we have implemented the notion of an 'adminstrative PF.'  This is a
gross simplification, but the idea is that the PCI domain (or CPU
complex) that contains this PF is the one that is 'in-charge' of the
eSwitch and the rest of the resources (firmware/phycode update) and
might also be the one that gets the VF representors when VFs are created
on any other PCI host/domains.

I'm not sure we need a kernel API to set it as I would leave this as
something that might be burned into the hardware in some manner.

> >
> >I think eswitch is just one capability, but SmartNIC will want to
> >control which ports see what capabilities in general. crypto offloads
> >and such.
> >
> >I presume in your model if host controls eswitch the smartNIC sees just
> 
> host may control the "nested eswitch" in the SmartNIC case.
> 

I'm not sure programming the eswitch in a nested manner is realistic.
Sure we can make hardware do it, but it's probably more trouble than
it's worth.  If a smartnic wants to give control of flows to the host
then it makes more sense to allow some communication at a higher layer
so that requests for hardware offload can be easily validated against
some sort of policy set forth by the admin of the smartnic.

> >what what comes out of Hosts single "uplink"? What if SmartNIC wants
> >the host to be able to control the forwarding but not loose the ability
> >to tap the VF to VF traffic?
> 
> You mean that the VF representors would be in both SmartNIC host and
> host? I don't know how that could work. I think it has to be either
> there or there.
> 

Agreed.  The VF reps should probably appear on whichever host/domain has
the Admin PF.

