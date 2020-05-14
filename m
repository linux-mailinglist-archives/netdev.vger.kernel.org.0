Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE721D2729
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgENGIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725976AbgENGID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 02:08:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80139C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 23:08:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h17so2251130wrc.8
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 23:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5iBeXBEKmXyiyA0yKSf8Nub1BZtkHYNtG5+Nqzo6+Z0=;
        b=ltYwjcasr3wzOJh0EQmtemHP0+7PLwUcaNGzrDGuIJn5gHmPj6jn/68Ntr9GrNS9ES
         sF2XAOZxjX8P4Udv5e+MkhY+W//0OZtmPZ77Mffh0pZhWBWevtyQXlyJ2O2TBhEb8w+d
         +BbhLd/NEfwuLcJMioRnaytFgeOrR1I5NJo9/px5n7M/ynv0BKd0oXPyav0dQlIpP6mF
         FTvE3lM2Mc0E9f6uMp3yCeD8FlDUePJIuM6I1kB9LgKrbw5bdFms2SGFIPm0ETmYqfex
         JO3kcHgcxRFKf3DYZkoKfFsPywdgge8rm7ijyzDz42s0iJzoKpjqoxw/REUUI9X0LRLY
         qwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5iBeXBEKmXyiyA0yKSf8Nub1BZtkHYNtG5+Nqzo6+Z0=;
        b=Fv1STqvSIkAcXU2FM7SM0Ib8NmYbl9TwQATli+P9JbjO2T4hMT/nVPhyXb8W3G5jw6
         IxM/xLh36Mf0DrEYZ0HACRM4fciJ8rtOl+3CYB4hgfbyyB9PtVuY5Dd3Lq2mG0s1rqIX
         kh0yAb2voUzTBr4wlREX7tJS2sRX63re1Ssv2M5ofK6BLczDdg6tXzFeUVcMvwFjKDAj
         2xehI8iK2FEZBlgGlAWtpvZ7R960tCQlDcVX0YafEB+0XS+tJO4dcaKwqAKJUPDCH9Ip
         U6AfFTataghkvR2SkZ9sLehrnatdFp6rqSTHBRQAdoaBpznMmo21AzafQgD8ll53KQkB
         Ucbw==
X-Gm-Message-State: AOAM533h5J7i+eilmlxxvdMfcLWCiJpgB4E3+pInqdmi1DBljGV1AEbI
        dw6WjOoaQLndCT9OS3uBHakePQ==
X-Google-Smtp-Source: ABdhPJyXPUAgMTJBgMq8MxzCPEkwwZfF+j8x3Q5CyNrqpAkO2db7S1lExeSkPEX1en8VMRuMg6J0GQ==
X-Received: by 2002:a5d:5710:: with SMTP id a16mr3279047wrv.209.1589436482219;
        Wed, 13 May 2020 23:08:02 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id q14sm2475164wrc.66.2020.05.13.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 23:08:00 -0700 (PDT)
Date:   Thu, 14 May 2020 08:07:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@netronome.com>
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
Message-ID: <20200514060759.GA2676@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
 <20200513130008.GA24409@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513130008.GA24409@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 13, 2020 at 03:00:09PM CEST, simon.horman@netronome.com wrote:
>On Fri, May 01, 2020 at 11:14:49AM +0200, Jiri Pirko wrote:
>> Hi all.
>> 
>> First, I would like to apologize for very long email. But I think it
>> would be beneficial to the see the whole picture, where we are going.
>> 
>> Currently we are working internally on several features with
>> need of extension of the current devlink infrastructure. I took a stab
>> at putting it all together in a single txt file, inlined below.
>> 
>> Most of the stuff is based on a new port sub-object called "func"
>> (called "slice" previously" and "subdev" originally in Yuval's patchsets
>> sent some while ago).
>> 
>> The text describes how things should behave and provides a draft
>> of user facing console input/outputs. I think it is important to clear
>> that up before we go in and implement the devlink core and
>> driver pieces.
>> 
>> I would like to ask you to read this and comment. Especially, I would
>> like to ask vendors if what is described fits the needs of your
>> NIC/e-switch.
>> 
>> Please note that something is already implemented, but most of this
>> isn't (see "what needs to be implemented" section).
>> 
>> v1->v2
>> - mainly move from separate slice object into port/func subobject
>> - couple of small fixes here and there
>> 
>> 
>> 
>> 
>> ==================================================================
>> ||                                                              ||
>> ||            Overall illustration of example setup             ||
>> ||                                                              ||
>> ==================================================================
>> 
>> Note that there are 2 hosts in the picture. Host A may be the smartnic host,
>> Host B may be one of the hosts which gets PF. Also, you might omit
>> the Host B and just see Host A like an ordinary nic in a host.
>> 
>> Note that the PF is merged with physical port representor.
>> That is due to simpler and flawless transition from legacy mode and back.
>> The devlink_ports and netdevs for physical ports are staying during
>> the transition.
>
>Hi Jiri,
>
>I'm probably missing something obvious but this merge seems at odds with
>the Netronome hardware.
>
>We model a PF as, in a nutshell, a PCIE link to a host. A chip may have
>one or more, and these may go to the same or different hosts. A chip may
>also have one or more physical ports. And there is no strict relationship
>between a PF and a physical port.

Yeah, no problem. You can have multiple physical ports under the same
devlink instance. In that case, from devlink perspective it is not
important if the physical port is backed by PF or not. I will rephrase a
bit so this is clear.


>
>Of course in SR-IOV legacy mode, there is such a relationship, but its not
>inherent to the hardware nor the NFP driver implementation of SR-IOV
>switchdev mode.
>
>...
