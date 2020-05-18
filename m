Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5300A1D7149
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgERGwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERGwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 02:52:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22616C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 23:52:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so10332244wre.13
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 23:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ycnaxBYJp1+PtMhkSTehxlFGugyiJqfw7Rt4CytEYEA=;
        b=qTL1dhKGn2A7mcYT4VhDFDssXe0gvdL+fybv5K6BiMmMj1aYdyObD7aYHnYMaSAYkE
         svS8tynaYsbSMYu3VAkjdKpdicBe01Vt9EMghAUf4ciYapzfTnVFgpd9ufCF3HJrkCFS
         kNcPy41Ud3wg0gry33AJHVGHhXYuB2aeQqX/4A9pvFwqQkap3RLHHgceg4golRnEACJG
         sGTL2lSVgGBCmHuewGnJ3ID1hs1xEfetHTf/DKbIxl3NrLeX4btBlt762PtuuUV5bdQf
         0HysDkrJZuHYYnFkTsEKnsSOaFx0FIQgpAVYy43zzQUv1zEL3Zvq0MHFwF6lnAhuGE4c
         vskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ycnaxBYJp1+PtMhkSTehxlFGugyiJqfw7Rt4CytEYEA=;
        b=ZKT83oYLwX/J/bFfWTfdMSLmq09hX7kzTSNPQKTKZDvfRVv3BgBqrVpMOORjE+lpC0
         iLUmNrdvWBK1b1igppjyNqY8r1VGsiBW1cQTqcjxPeOGLe4+U+7YaiuI5oXYO1uFNI4B
         cKBypoccQGYXxfbOWVmIND0i9R8XlYj4uAjwfIPRxTvoUmhV2UZhaqDqdRtSSder6uDI
         4kPu3kQ5BqUanMYRfSmmgLxXzi0frer7A7+VTMyY6tipWiiMXP0axZS+Ki6cr/dLnNlI
         5/TCPFikijRpyIBmbgL31iK95ddivTCZiiA+EaVVAFJ7Zh5rXAcHphR/yb7yNlU2W9da
         NPfg==
X-Gm-Message-State: AOAM532F1FedM6/fcG/7htkslLR2fzECjqzcXRgSrzLyhZx4JMp+2rwd
        xIPLqD8JzN2M/YeitdY0uyw4yw==
X-Google-Smtp-Source: ABdhPJw1BYGUCcZ4/RQOJy1b9cCNuaPb6NEcoN3eqbOi83Xct/FWCqnVFxRBuz7fT04HFMh/V/YAKA==
X-Received: by 2002:a5d:6ca7:: with SMTP id a7mr17966381wra.391.1589784728721;
        Sun, 17 May 2020 23:52:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d6sm10150738wrj.90.2020.05.17.23.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 23:52:07 -0700 (PDT)
Date:   Mon, 18 May 2020 08:52:07 +0200
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
Message-ID: <20200518065207.GA2193@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 15, 2020 at 11:36:19PM CEST, jacob.e.keller@intel.com wrote:
>
>
>On 5/15/2020 2:30 AM, Jiri Pirko wrote:
>> Fri, May 15, 2020 at 01:52:54AM CEST, jacob.e.keller@intel.com wrote:
>>>> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
>>>>
>>>
>>> Can you clarify what sfnum means here? and why is it different from the
>>> index? I get that the index is a unique number that identifies the port
>>> regardless of type, so sfnum must be some sort of hardware internal
>>> identifier?
>> 
>> Basically pfnum, sfnum and vfnum could overlap. Index is unique within
>> all groups together.
>> 
>
>Right. Index is just an identifier for which port this is.
>
>> 
>>>
>>> When looking at this with colleagues, there was a lot of confusion about
>>> the difference between the index and the sfnum.
>> 
>> No confusion about index and pfnum/vfnum? They behave the same.
>> Index is just a port handle.
>> 
>
>I'm less confused about the difference between index and these "nums",
>and more so questioning what pfnum/vfnum/sfnum represent? Are they
>similar to the vf ID that we have in the legacy SRIOV functions? I.e. a
>hardware index?
>
>I don't think in general users necessarily care which "index" they get
>upfront. They obviously very much care about the index once it's
>selected. I do believe the interfaces should start with the capability
>for the index to be selected automatically at creation (with the
>optional capability to select a specific index if desired, as shown here).
>
>I do not think most users want to care about what to pick for this
>number. (Just as they would not want to pick a number for the port index
>either).

I see your point. However I don't think it is always the right
scenario. The "nums" are used for naming of the netdevices, both the
eswitch port representor and the actual SF (in case of SF).

I think that in lot of usecases is more convenient for user to select
the "num" on the cmdline.



>
>> 
>>>
>>>> The devlink kernel code calls down to device driver (devlink op) and asks
>>>> it to create a SF port with particular attributes. Driver then instantiates
>>>> the SF port in the same way it is done for VF.
>>>>
>>>
>>> What do you mean by attributes here? what sort of attributes can be
>>> requested?
>> 
>> In the original slice proposal, it was possible to pass the mac address
>> too. However with new approach (port func subobject) that is not
>> possible. I'll remove this rudiment.
>> 
>
>Ok.
>
>> 
>>>
>>>>
>>>> Note that it may be possible to avoid passing port index and let the
>>>> kernel assign index for you:
>>>> $ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10
>>>>
>>>> This would work in a similar way as devlink region id assignment that
>>>> is being pushed now.
>>>>
>>>
>>> Sure, this makes sense to me after seeing Jakub's recent patch for
>>> regions. I like this approach. Letting the user not have to pick an ID
>>> ahead of time is useful.
>>>
>>> Is it possible to skip providing an sfnum, and let the kernel or driver
>>> pick one? Or does that not make sense?
>> 
>> Does not. The sfnum is something that should be deterministic. The sfnum
>> is then visible on the other side on the virtbus device:
>> /sys/bus/virtbus/devices/mlx5_sf.1/sfnum
>> and it's name is generated accordingly: enp6s0f0s10
>> 
>
>Why not have the option to say "create me an sfnum and then report it to
>me" in the same way we do with region numbers now and plan to with port
>indexes?

Sure, why not.


>
>Basically: why do I as a user of the front end care what this number
>actually is? What does it represent?

See my answer above.


>
>> 
>> 
>>>
>>>> ==================================================================
>>>> ||                                                              ||
>>>> ||   VF manual creation and activation user cmdline API draft   ||
>>>> ||                                                              ||
>>>> ==================================================================
>>>>
>>>> To enter manual mode, the user has to turn off VF dummies creation:
>>>> $ devlink dev set pci/0000:06:00.0 vf_dummies disabled
>>>> $ devlink dev show
>>>> pci/0000:06:00.0: vf_dummies disabled
>>>>
>>>> It is "enabled" by default in order not to break existing users.
>>>>
>>>> By setting the "vf_dummies" attribute to "disabled", the driver
>>>> removes all dummy VFs. Only physical ports are present:
>>>>
>>>> $ devlink port show
>>>> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>>> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
>>>>
>>>> Then the user is able to create them in a similar way as SFs:
>>>>
>>>> $ devlink port add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8
>>>>
>>>
>>> So in this case, you have to specify the VF index to create? So this
>>> vfum is very similar to the sfnum (and pfnum?) above?
>> 
>> Yes.
>> 
>> 
>>>
>>> What about the ability to just say "please give me a VF, but I don't
>>> care which one"?
>> 
>> Well, that could be eventually done too, with Jakub's extension.
>> 
>
>Sure. I think that's what I was asking above as well. Ok.
>
>>>>
>>>>    $ devlink port show
>>>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>>>
>>>>    If there is another parent PF, say "0000:06:00.1", that share the
>>>>    same embedded switch, the aliasing is established for devlink handles.
>>>>
>>>>    The user can use devlink handles:
>>>>    pci/0000:06:00.0
>>>>    pci/0000:06:00.1
>>>>    as equivalents, pointing to the same devlink instance.
>>>>
>>>>    Parent PFs are the ones that may be in control of managing
>>>>    embedded switch, on any hierarchy leve>
>>>> 2) Child PF. This is a leg of a PF put to the parent PF. It is
>>>>    represented by a port a port with a netdevice and func:
>>>>
>>>>    $ devlink port show
>>>>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>>>>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2
>>>>        func: hw_addr aa:bb:cc:aa:bb:87 state active
>>>>
>>>>    This is a typical smartnic scenario. You would see this list on
>>>>    the smartnic CPU. The port pci/0000:06:00.0/1 is a leg to
>>>>    one of the hosts. If you send packets to enp6s0f0pf2, they will
>>>>    go to the child PF.
>>>>
>>>>    Note that inside the host, the PF is represented again as "Parent PF"
>>>>    and may be used to configure nested embedded switch.
>>>>
>>>>
>>>
>>> I'm not sure I understand this section. Child PF? Is this like a PF in
>>> another host? Or representing the other side of the virtual link?
>> 
>> It's both actually, at the same time.
>> 
>> 
>
>Ok. I still don't think I fully grasp this yet.
>
>
>>> Obviously this is a TODO, but how does this differ from the current
>>> port_split and port_unsplit?
>> 
>> Does not have anything to do with port splitting. This is about creating
>> a "child PF" from the section above.
>> 
>
>Hmm. Ok so this is about internal connections in the switch, then?

Yes. Take the smartnic as an example. On the smartnic cpu, the
eswitch management is being done. There's devlink instance with all
eswitch port visible as devlink ports. One PF-type devlink port per
host. That are the "child PFs".

Now from perspective of the host, there are 2 scenarios:
1) have the "simple dumb" PF, which just exposes 1 netdev for host to
   run traffic over. smartnic cpu manages the VFs/SFs and sees the
   devlink ports for them. This is 1 level switch - merged switch

2) PF manages a sub-switch/nested-switch. The devlink/devlink ports are
   created on the host and the devlink ports for SFs/VFs are created
   there. This is multi-level eswitch. Each "child PF" on a parent
   manages a nested switch. And could in theory have other PF child with
   another nested switch.
