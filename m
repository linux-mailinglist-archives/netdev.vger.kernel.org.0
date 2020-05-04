Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F2C1C387D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEDLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728401AbgEDLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 07:42:55 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FCDC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 04:42:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f13so20466754wrm.13
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 04:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LggiorTwjZTeCDnqwkWe0DxzAJptkw+Oq1vRCANON2g=;
        b=VbX3qsf89SNDJhq0LAKiz5C4WFo6Iy8fsJn28xZvV8zXMEyDLtXVgm2Yw7W4Dy/JJc
         Iq1GWifKBnEOiIJKZnsppRzicrI+IkdGozwzgTJ8+pJUf1stf/RnhPovjBEm2C5bjTuM
         JjMOKZDaxCjdBFocw8zkvkXXvsYg8/p5Ks/UogWhWZuQeAO8sRmj9GPtQdsXgHdy52WY
         FUn9/hOv8p0ixGP8vOwBY50USt28N5m51NXPPUwnJDftqrC2tca7NWyFF7L154aXdg1x
         CTJRvVzemZ40LF2DcsKRxm/tJnptaX5WjZUq7wEkXWvpxJDc5wyLqN9013O+g/eCvqu2
         EzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LggiorTwjZTeCDnqwkWe0DxzAJptkw+Oq1vRCANON2g=;
        b=JNeZTh3gFWmWLFnxVDYT1JUdSBNBmHe7T6kim6pW9ObVeFTpx2iMnO7oGq3B6M8MW/
         XixtYaRlwM0B0iS1rUr6OXUz0C5F/kin4hm3P9tyI2ADHnqC6qBpuriqu9qwNciMJFJh
         gjNzYKiOmhq2JLCB4PWulUfV4MyMAtMhOH//g1UhpdTYv776ZAvxQmMnkfKNNIyBBWTi
         OLaka8hbkGQkzLe09Uwu+NiVF4GGqi97Zz0epjk19iIKYPxz2bvHcTsIr1jmRlHOdWgw
         O2ULBKYYjeNrA+DQESEe4RKeufsGMCKxzmYDp31ZznBvpg4wsgVTlDb7ePODe/2YY7LX
         /ffw==
X-Gm-Message-State: AGi0PuaQiLLY5eIM176s7ssiXmu0Mqci/7F56nNEx9VWK1ASbOrVc+R/
        wOeIGCSUwssqDo6JnVOLV/IVbw==
X-Google-Smtp-Source: APiQypJ+RE6ZSgF9EYdv+Q15RKRvEeEwTcnzc5aiYo2XK9aQ4e9EBuuHFWtmXOu2vklt6vE3DhHcAQ==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr7170968wrq.171.1588592573732;
        Mon, 04 May 2020 04:42:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l19sm13646961wmj.14.2020.05.04.04.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 04:42:53 -0700 (PDT)
Date:   Mon, 4 May 2020 13:42:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
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
        vikas.gupta@broadcom.com
Subject: Re: [RFC v2] current devlink extension plan for NICs
Message-ID: <20200504113419.GA14398@nanopsycho.orion>
References: <20200501091449.GA25211@nanopsycho.orion>
 <80453af6-7cb3-59a7-910e-2fc69263ebde@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80453af6-7cb3-59a7-910e-2fc69263ebde@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 04, 2020 at 04:12:18AM CEST, sridhar.samudrala@intel.com wrote:
>
>
>On 5/1/2020 2:14 AM, Jiri Pirko wrote:
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
>
><snip>
>
>> 
>> 
>> 
>> ==================================================================
>> ||                                                              ||
>> ||             Port func user cmdline API draft                 ||
>> ||                                                              ||
>> ==================================================================
>> 
>> Note that some of the "devlink port" attributes may be forgotten or misordered.
>> 
>> Funcs are created as sub-objects of ports where it makes sense to have them
>> The driver takes care of that. The "func" is a handle to configure "the other
>> side of the wire". The original port object has port leve properties,
>> the new "func" sub-object on the other hand has device level properties".
>> 
>> This is example for the HOST A from the example above:
>> 
>> $ devlink port show
>> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
>> pci/0000:06:00.0/2: flavour pcipf pfnum 2 type eth netdev enp6s0pf2
>>                      func: hw_addr 10:22:33:44:55:66 state active
>> pci/0000:06:00.0/3: flavour pcivf pfnum 2 vfnum 0 type eth netdev enp6s0pf2vf0
>>                      func: hw_addr 10:22:33:44:55:77 state active
>> pci/0000:06:00.0/4: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
>>                      func: hw_addr 10:22:33:44:55:88 state active
>> pci/0000:06:00.0/5: flavour pcisf pfnum 0 sfnum 1 type eth netdev enp6s0pf0sf1
>>                      func: hw_addr 10:22:33:44:55:99 state active
>> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2 type nvme
>>                      func: state active
>
>
>I am trying to understand how the current implementation of 'devlink port' is
>being refactored to support this new model.
>
>Today 'devlink port show' on a system with 2 port mlx5 NIC with 1 VFs created
>on each PF shows
>
>pci/0000:af:00.0/1: type eth netdev enp175s0f0np0 flavour physical port 0
>pci/0000:af:00.1/1: type eth netdev enp175s0f1np1 flavour physical port 1
>pci/0000:af:00.2/1: type eth netdev enp175s0f2np0 flavour virtual port 0
>pci/0000:af:08.2/1: type eth netdev enp175s8f2np0 flavour virtual port 0

The representor instances are not present here. They should be added.

The output would look like this:

pci/0000:af:00.0/1: type eth netdev enp175s0f0np0 flavour physical port 0 pfnum 0
pci/0000:af:00.0/2: type eth netdev enp175s0f1np1 flavour physical port 1 pfnum 1
pci/0000:af:00.0/3: type eth netdev enp175s0f0pf0vf0 flavour pcivf pfnum 0 vfnum 0
                      func: hw_addr 10:22:33:44:55:66 state active
pci/0000:af:00.0/4: type eth netdev enp175s0f1pf1vf0 flavour pcivf pfnum 1 vfnum 0
                      func: hw_addr 10:22:33:44:55:77 state active

pci/0000:af:00.2/1: type eth netdev enp175s0f2np0 flavour virtual port 0
pci/0000:af:08.2/1: type eth netdev enp175s8f2np0 flavour virtual port 0


Handle pci/0000:af:00.1 is alias for pci/0000:af:00.0. It's the same
instance of devlink object.




>
>
>Can you tell me how this will be represented in the new model?
>
>It looks like you are assigning a pfnum to physical port as well as PCI PF.
>However, i am little confused as both pfnum 0 and pfnum 1 which seem to be 2
>physical ports have the same bus/dev/func 06:00.0 and also the VF ports.

Two ports of the same nic can be under 1 PF or each can be a separate
PF. In both cases, there should be 1 devlink instances shared for both.
In my example, I mixed this up a bit, sorry about that. It should be one
of following:
1) Same PF for both ports:
  pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
  pci/0000:06:00.0/1: flavour physical pfnum 0 type eth netdev enp6s0f0np2
2) Separate per-port PF:
  pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
  pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f1np2

  and pci/0000:06:00.1 is alias for pci/0000:06:00.0


Will fix. Thanks!

>
>Thanks
>Sridhar
