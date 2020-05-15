Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB61D499A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 11:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgEOJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727803AbgEOJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 05:30:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AEDC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:30:19 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u188so1882784wmu.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+s/GtAifFZS0MgoczFm0yt0Ageo/FczNaIIMPte8FhY=;
        b=Ap/mdt75XvuaI5iojhSqfg9fJvH9Db/XfV05jk5C7/bwBkTEQOHgmOZkd6p/9cx+rU
         LZGH9rrt2ok1ZoToIhL2ZcjlMidNYU2pS1zjHx/1Iribq7UL25NMUe7kbaUVfV+CFZhl
         E8sFuojPD1oF3oY9Frjc3InhrgkxKOm8TDvaHlXnfD18aOAJF+Hqqzx3IrpKj3dBoPOC
         cDO0Sjc3ScvV/oC5n+65nsAlvVvnNNEwGtTt0pDP06iGJsyyLnAhaA7el+Pr4upiNU53
         XXVq+e9YMJ8VQ1PugUtmBslCujX3Mc2BbWtksNJ6CjE+CrdQPYGsFUEPjzJ45lygGtZC
         cvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+s/GtAifFZS0MgoczFm0yt0Ageo/FczNaIIMPte8FhY=;
        b=KOVgEhVhkDcVz9NOefoesEDiOh12SSjoUyCgFfDIy2OPhQW0lifRy6ub2GmPZY6rgR
         UiY+4x8wlQtEdKmlHo1UGNTT8bBZkU0cfqvSNZHxsmJf4fFj4nrzKwwJ3whM+q+34oga
         2eMnz+qXEvljUSc3YQeH0380VvVPPl5vYPeom2PfjaOjYHLqrblpX1W1mVha/L5FgmFS
         p8HVMoRlVFISBEs+Po+Nc9lF1csRf2M6ZIvLrFSgx6VRw1mzKTMHjkT0Z0RAesjvsFoy
         FrSxr2H0JmVGm28FiEwiqDmFg0lElBOBwyv67qHuyDBM+6/Gvot9Q1ESxJXkzguQv6R1
         q4gA==
X-Gm-Message-State: AOAM5317XaeBqbtMwM1AAya5QRTu8TL8mni1TFAvWDxyApS2F3qRquQ8
        6z61I/3b2YLrr+FC6ABJ3wQAIllMj/g=
X-Google-Smtp-Source: ABdhPJzbO6Zrn0HQCGmZbunYVTXd2tpICveK1+OA02/pHQ5v9zlK1ZBkEYmmvOOFJuuExAZ0WI7eXg==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr2939497wme.135.1589535017739;
        Fri, 15 May 2020 02:30:17 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id j1sm2683066wrm.40.2020.05.15.02.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 02:30:17 -0700 (PDT)
Date:   Fri, 15 May 2020 11:30:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
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
        valex@mellanox.com, linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: Re: [RFC v2] current devlink extension plan for NICs
Message-ID: <20200515093016.GE2676@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 15, 2020 at 01:52:54AM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 5/1/2020 2:14 AM, Jiri Pirko wrote:
>> ==================================================================
>> ||                                                              ||
>> ||          SF (subfunction) user cmdline API draft             ||
>> ||                                                              ||
>> ==================================================================
>> 
>> Note that some of the "devlink port" attributes may be forgotten,
>> misordered or omitted on purpose.
>> 
>> $ devlink port show
>> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
>> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
>>                     func: hw_addr 10:22:33:44:55:66 state active
>> 
>> There is one VF on the NIC.
>> 
>> Now create subfunction of SF0 on PF1, index of the port is going to be 100:
>> 
>
>Here, you say "SF0 on PF1", but you then specify sfnum as 10 below.. Is
>there some naming scheme or terminology here?

Typo, will fix.


>
>> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
>> 
>
>Can you clarify what sfnum means here? and why is it different from the
>index? I get that the index is a unique number that identifies the port
>regardless of type, so sfnum must be some sort of hardware internal
>identifier?

Basically pfnum, sfnum and vfnum could overlap. Index is unique within
all groups together.


>
>When looking at this with colleagues, there was a lot of confusion about
>the difference between the index and the sfnum.

No confusion about index and pfnum/vfnum? They behave the same.
Index is just a port handle.


>
>> The devlink kernel code calls down to device driver (devlink op) and asks
>> it to create a SF port with particular attributes. Driver then instantiates
>> the SF port in the same way it is done for VF.
>> 
>
>What do you mean by attributes here? what sort of attributes can be
>requested?

In the original slice proposal, it was possible to pass the mac address
too. However with new approach (port func subobject) that is not
possible. I'll remove this rudiment.


>
>> 
>> Note that it may be possible to avoid passing port index and let the
>> kernel assign index for you:
>> $ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10
>> 
>> This would work in a similar way as devlink region id assignment that
>> is being pushed now.
>> 
>
>Sure, this makes sense to me after seeing Jakub's recent patch for
>regions. I like this approach. Letting the user not have to pick an ID
>ahead of time is useful.
>
>Is it possible to skip providing an sfnum, and let the kernel or driver
>pick one? Or does that not make sense?

Does not. The sfnum is something that should be deterministic. The sfnum
is then visible on the other side on the virtbus device:
/sys/bus/virtbus/devices/mlx5_sf.1/sfnum
and it's name is generated accordingly: enp6s0f0s10



>
>> ==================================================================
>> ||                                                              ||
>> ||   VF manual creation and activation user cmdline API draft   ||
>> ||                                                              ||
>> ==================================================================
>> 
>> To enter manual mode, the user has to turn off VF dummies creation:
>> $ devlink dev set pci/0000:06:00.0 vf_dummies disabled
>> $ devlink dev show
>> pci/0000:06:00.0: vf_dummies disabled
>> 
>> It is "enabled" by default in order not to break existing users.
>> 
>> By setting the "vf_dummies" attribute to "disabled", the driver
>> removes all dummy VFs. Only physical ports are present:
>> 
>> $ devlink port show
>> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
>> 
>> Then the user is able to create them in a similar way as SFs:
>> 
>> $ devlink port add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8
>> 
>
>So in this case, you have to specify the VF index to create? So this
>vfum is very similar to the sfnum (and pfnum?) above?

Yes.


>
>What about the ability to just say "please give me a VF, but I don't
>care which one"?

Well, that could be eventually done too, with Jakub's extension.


>
>> The devlink kernel code calls down to device driver (devlink op) and asks
>> it to create a VF port with particular attributes. Driver then instantiates
>> the VF port with func.
>> 
>
>> 
>> ==================================================================
>> ||                                                              ||
>> ||                             PFs                              ||
>> ||                                                              ||
>> ==================================================================
>> 
>> There are 2 flavours of PFs:
>> 1) Parent PF. That is coupled with uplink port. The flavour is:
>>     a) "physical" - in case the uplink port is actual port in the NIC.
>>     b) "virtual" - in case this Parent PF is actually a leg to
>>        upstream embedded switch.
>
>So "physical" is for the physical NIC port. Ok. And "virtual" is one
>side of an internal embedded switch. This makes sense.

Yes.


>
>> 
>>    $ devlink port show
>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>> 
>>    If there is another parent PF, say "0000:06:00.1", that share the
>>    same embedded switch, the aliasing is established for devlink handles.
>> 
>>    The user can use devlink handles:
>>    pci/0000:06:00.0
>>    pci/0000:06:00.1
>>    as equivalents, pointing to the same devlink instance.
>> 
>>    Parent PFs are the ones that may be in control of managing
>>    embedded switch, on any hierarchy leve>
>> 2) Child PF. This is a leg of a PF put to the parent PF. It is
>>    represented by a port a port with a netdevice and func:
>> 
>>    $ devlink port show
>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2
>>        func: hw_addr aa:bb:cc:aa:bb:87 state active
>> 
>>    This is a typical smartnic scenario. You would see this list on
>>    the smartnic CPU. The port pci/0000:06:00.0/1 is a leg to
>>    one of the hosts. If you send packets to enp6s0f0pf2, they will
>>    go to the child PF.
>> 
>>    Note that inside the host, the PF is represented again as "Parent PF"
>>    and may be used to configure nested embedded switch.
>> 
>> 
>
>I'm not sure I understand this section. Child PF? Is this like a PF in
>another host? Or representing the other side of the virtual link?

It's both actually, at the same time.



>> 
>> ==================================================================
>> ||                                                              ||
>> ||            Dynamic PFs user cmdline API draft                ||
>> ||                                                              ||
>> ==================================================================
>> 
>> User might want to create another PF, similar as VF.
>> TODO
>> 
>
>Obviously this is a TODO, but how does this differ from the current
>port_split and port_unsplit?

Does not have anything to do with port splitting. This is about creating
a "child PF" from the section above.

