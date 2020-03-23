Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3881900E0
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCWWGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:06:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35507 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWWGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:06:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id k13so5494724qki.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ww3ZxNiYMxqSoesnyQZ9lIRSuQBsiGVTwqtHtah6rOI=;
        b=LMWTEiWuxHO5lxq2bxGSPq2FevpMqNBuMXo747GAJisF38rgwR2hw8ew71ULT+GFVP
         22YKU/+ST/U1f59+pJcFvFvTO303t2x15C40PG1X8Pokq2jYIbvhoXKwpfiFqsLyJklP
         12faSJ9kAUbc5eFgfgXFNwtgzhlWO7+Ke1j8d8MeefoA56sRtPDDpNiFSMOoQ5dTi5n3
         SONuWNo32mRhgpamAlAqK/HIXtho9fZoslueqxryqXLlZ5Xiw06y1lOfvFGXaMyI9Isn
         W/S/GJmGk+FbT2IsqGHWUYf90KlkciKKGruEABLbYjtoJERcTHAokTTVRTYtHtTZ5EIg
         QyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ww3ZxNiYMxqSoesnyQZ9lIRSuQBsiGVTwqtHtah6rOI=;
        b=h+SfuvMGdDHqmugKAyapg7pzyGCZ2pZh347qki6otqpoVZr9q6W9tYzgc+BtXyfXaW
         rp/FZ20Vjn4yyOVfE5q8jpctfQOC4SJo/kxc8odYw9MCMXteMzd7h5q65a17gBdZOLHg
         JI7mKQ5Tl44/fbPV+Z25FG1LJZpa/X4c//dN2wCgyCj5nPr2r5oOBBqIkAJ1Y927XEdo
         86vPXZz9FKTPIWSMbH2Q7savxgdeQ3LfHYjaRfL2Fw/+XuE+TvqFH7S+xI7dkneXqe+L
         qfte8vOyviFQu2hpbID73gDzc/K5YenoEHDm05NGx2LRt7d9LDlCUaEJPZAMrmM+oqP5
         SODQ==
X-Gm-Message-State: ANhLgQ2hD1LtFEv+u/sjLQbtupX0OB4GgFNSqYwcyRBsKkGw01ngaYck
        CEq7ulJyaq4SpUfe3ufXEDQOyw==
X-Google-Smtp-Source: ADFU+vunL+0Lc1jaTWmT9Cc2gL+4YrNmgqpUwluYlf9U4m3R3e01VE9K0Co7yAtyYUBhSITuHa7EOg==
X-Received: by 2002:a37:98c4:: with SMTP id a187mr17561421qke.132.1585001166665;
        Mon, 23 Mar 2020 15:06:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id r46sm13208312qtb.87.2020.03.23.15.06.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 15:06:06 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jGVCv-0005TZ-JI; Mon, 23 Mar 2020 19:06:05 -0300
Date:   Mon, 23 Mar 2020 19:06:05 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@mellanox.com, yuvalav@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org,
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
Message-ID: <20200323220605.GE20941@ziepe.ca>
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
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 12:21:23PM -0700, Jakub Kicinski wrote:
> > >I see so you want the creation to be controlled by the same entity that
> > >controls the eswitch..
> > >
> > >To me the creation should be on the side that actually needs/will use
> > >the new port. And if it's not eswitch manager then eswitch manager
> > >needs to ack it.  
> > 
> > Hmm. The question is, is it worth to complicate things in this way?
> > I don't know. I see a lot of potential misunderstandings :/
> 
> I'd see requesting SFs over devlink/sysfs as simplification, if
> anything.

We looked at it for a while, working the communication such that the
'untrusted' side could request a port be created with certain
parameters and the 'secure eswitch' could know those parameters to
authorize and wire it up was super complicated and very hard to do
without races.

Since it is a security sensitive operation it seems like a much more
secure design to have the secure side do all the creation and present
the fully operational object to the insecure side.

To draw a parallel to qemu & kvm, the untrusted guest VM can't request
that qemu create a virtio-net for it. Those are always hot plugged in
by the secure side. Same flow here.

> > >The precedence is probably not a strong argument, but that'd be the
> > >same way VFs work.. I don't think you can change how VFs work, right?  
> > 
> > You can't, but since the VF model is not optimal as it turned out, do we
> > want to stick with it for the SFs too?
> 
> The VF model is not optimal in what sense? I thought the main reason
> for SFs is that they are significantly more light weight on Si side.

Not entirely really, the biggest reason for SF is because VF have to
be pr-eallocated and have a number limited by PCI.

The VF model is poor because the VF is just a dummy stub until the
representor/eswitch side is fully configured. There is no way for the
Linux driver to know if the VF is operational or not, so we get weird
artifacts where we sometimes bind a driver to a VF (and get a
non-working ethXX) and sometimes we don't. 

The only reason it is like this is because of how SRIOV requires
everything to be preallocated.

The SFs can't even exist until they are configured, so there is no
state where a driver is connected to an inoperative SF.

So it would be nice if VF and SF had the same flow, the SF flow is
better, lets fix the VF flow to match it.

Jason
