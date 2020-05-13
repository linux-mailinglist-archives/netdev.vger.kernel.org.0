Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6842E1D13B4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgEMNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgEMNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 09:00:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0851DC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 06:00:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s8so20790884wrt.9
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 06:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yY+0/XxgHTojFmhtTmbAFJ7vz86fh0v480A49unmA5Q=;
        b=poIth7Kr0nyoz2lUGp6kfihCbyCHYAYk6bw7ZHL5WQyQ8EBumk6ln9rEd29T7vo8pA
         6RlweTrsxexyamyu+f5KCNy5K4+Mo5BiKwTx+k5dzp7nV9t1Prdz3dqGF6ccFNN9lZCV
         qiXA325ZikqfbbJGqSbA1gSNnoeE5qawgkxlhDfwQ4BOlDPo6sWZ3hzHQSRjgMzFbBil
         FWm4jcTefODjL8chqqHNDxNs3vReauEGy1vpq4TPMXcFLhQc2r9sREeyT5NjYbdNuzmI
         X+D7THmVo+aaiUNxeK/iL0fDCiXnItPgu2af48EOE1opG+TTLy8/SBn2ZL1dzzHXyi35
         MLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yY+0/XxgHTojFmhtTmbAFJ7vz86fh0v480A49unmA5Q=;
        b=K9jnYv/ZSv3ok9QWYVM3Xa5zuKlazK+uzXM4kjqrskCy/lpJl7IQo5BD4zskNoman/
         OAbu4bt6I2beEHHvF6ZlMzLujnkAYM5VBIHGNmSM7n5oTvpD2ivhIhFaa9EYWC9303IG
         5PDiZkSQIef4xtH19M4ZoBW2R3Clnjas463UEfw7o59KuiNoOKzSDyAGJRLUWZu0DQQI
         8IBPpJEPHnNY1+LtY4hXjb4UR/2QG/k2WhVjMwYAvIa7EDIWgcCbSKIfnIBrJ/nKZvEq
         13zuruj1AhX3gDJvwFumk5m0zNgAeNYMjldFCiue6wRQogJkp1DO8e5f7Qnthxa7C2z+
         hWQQ==
X-Gm-Message-State: AGi0PuZQS7YQHl60o6luE/Rh1lT0hhQxSdcg6P6k8932CWiBwxwqbGZ7
        ijYDf+GWwIyjZgtQvj1ahIr3Jg==
X-Google-Smtp-Source: APiQypKmmZE/G5U/lC2+ZghvmYDfihfujhLobljlz9aMHawh6CN2QmQJf2lwR7mAr3fxcxPKEtkyVA==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr23235673wrv.242.1589374811293;
        Wed, 13 May 2020 06:00:11 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id f123sm22912660wmf.44.2020.05.13.06.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 06:00:10 -0700 (PDT)
Date:   Wed, 13 May 2020 15:00:09 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        parav@mellanox.com, yuvalav@mellanox.com, jgg@ziepe.ca,
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
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: Re: [oss-drivers] [RFC v2] current devlink extension plan for NICs
Message-ID: <20200513130008.GA24409@netronome.com>
References: <20200501091449.GA25211@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501091449.GA25211@nanopsycho.orion>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 11:14:49AM +0200, Jiri Pirko wrote:
> Hi all.
> 
> First, I would like to apologize for very long email. But I think it
> would be beneficial to the see the whole picture, where we are going.
> 
> Currently we are working internally on several features with
> need of extension of the current devlink infrastructure. I took a stab
> at putting it all together in a single txt file, inlined below.
> 
> Most of the stuff is based on a new port sub-object called "func"
> (called "slice" previously" and "subdev" originally in Yuval's patchsets
> sent some while ago).
> 
> The text describes how things should behave and provides a draft
> of user facing console input/outputs. I think it is important to clear
> that up before we go in and implement the devlink core and
> driver pieces.
> 
> I would like to ask you to read this and comment. Especially, I would
> like to ask vendors if what is described fits the needs of your
> NIC/e-switch.
> 
> Please note that something is already implemented, but most of this
> isn't (see "what needs to be implemented" section).
> 
> v1->v2
> - mainly move from separate slice object into port/func subobject
> - couple of small fixes here and there
> 
> 
> 
> 
> ==================================================================
> ||                                                              ||
> ||            Overall illustration of example setup             ||
> ||                                                              ||
> ==================================================================
> 
> Note that there are 2 hosts in the picture. Host A may be the smartnic host,
> Host B may be one of the hosts which gets PF. Also, you might omit
> the Host B and just see Host A like an ordinary nic in a host.
> 
> Note that the PF is merged with physical port representor.
> That is due to simpler and flawless transition from legacy mode and back.
> The devlink_ports and netdevs for physical ports are staying during
> the transition.

Hi Jiri,

I'm probably missing something obvious but this merge seems at odds with
the Netronome hardware.

We model a PF as, in a nutshell, a PCIE link to a host. A chip may have
one or more, and these may go to the same or different hosts. A chip may
also have one or more physical ports. And there is no strict relationship
between a PF and a physical port.

Of course in SR-IOV legacy mode, there is such a relationship, but its not
inherent to the hardware nor the NFP driver implementation of SR-IOV
switchdev mode.

...
