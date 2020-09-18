Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174F026F69B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 09:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 03:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIRHU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 03:20:58 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3641AC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 00:20:58 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x14so4488372wrl.12
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 00:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QxuJZObJjoIpMvR2y3HTxTLZN8CbQM/vzgoFC8jMi40=;
        b=vBwAt86gs/gG5GqVsuwzDgzgPd1pNCI6Bu6xdciaJWzefTuL7qy2i4lB0jMsK+F1W2
         4RTLVZ3Z6aIQVoLPCmsaBS/XOqC8OaPlIYU6eqkdYFiDmWI/+XRvrFWp10mN3kb9uhyy
         Md4miXbrVfgUQNCcJs3qpZpte2hUfebXWuHtKhP0stxVKvOwkMSNKnSp8I/06DWOozwZ
         1AjIcOxX5SORvdqfMYw1MuEhQQ2GLDvo70crFzOlhkb0JHscMnjG3Glm/gi14pe8MRTq
         4tcczy7PL7N53H6cR2pfMygdCzmrGLPEt9d5fBuAm0perlGGNrVyS0l251W7l4WEY19M
         /aaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QxuJZObJjoIpMvR2y3HTxTLZN8CbQM/vzgoFC8jMi40=;
        b=jpMmo9Itqi8LjW4GcCE/4qMd4fZHn8gI2bXvnBqyq8xxzr3m9w25pZq67k53Fk3F5s
         j1H1thaa6P0LQ2MAPObspX9GBBXBQ1bOtaOCmohbt8FAVlrPzM3+HGD5/ST1bgHHAa4w
         CLkOtZ7QWXw8LSnp9LJ7s0lleabMPiO2eKyk/zeSh+0OZqOVtAjXpMunPWTmA89wgawG
         3ducA7UHo6Yq5TYLuARiHAqJPabyGC/bDuY6h9G3os3t79SXLhuLsCAOi0kpHhhLlFA5
         o/lGTTMVPrqsTIRaoQDGIOpn4btntBIK/6fOXBVRoZO6PNae06Ce0UPGpTg2cYDjTi3d
         InuQ==
X-Gm-Message-State: AOAM532+whNtQ4Vqt/yPnNVr3NQeNE7sxoNTQeGQWU36R0GKb+QwJUz3
        OwnRfYsp/u+lEEoAktqrdlAD4w==
X-Google-Smtp-Source: ABdhPJw6Sf2GxL0onDQ6vfV1+pxOIBmVRPJkInloyU4MsjCUOexfLl4HMJH8zYFISW7IwmJTwmr7kQ==
X-Received: by 2002:a5d:44cc:: with SMTP id z12mr37382467wrr.189.1600413656792;
        Fri, 18 Sep 2020 00:20:56 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 97sm3497653wrm.15.2020.09.18.00.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 00:20:56 -0700 (PDT)
Date:   Fri, 18 Sep 2020 09:20:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200918072054.GA2323@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
 <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 17, 2020 at 10:31:10PM CEST, tlfalcon@linux.ibm.com wrote:
>
>On 9/10/20 2:00 AM, Jiri Pirko wrote:
>> Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>> > On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>> > > On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>> > > > Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>> > > > > Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>> > > > > VNIC devices to administrators through devlink (originally through
>> > > > > sysfs files, but that was rejected in favor of devlink). Could you
>> > > > > give any tips on how you might go about doing this?
>> > > > Tom, I believe you need to provide more info about what exactly do you
>> > > > need to setup. But from what you wrote, it seems like you are looking
>> > > > for bridge/tc offload. The infra is already in place and drivers are
>> > > > implementing it. See mlxsw for example.
>> > > I think Tom's use case is effectively exposing the the VF which VLANs
>> > > and what MAC addrs it can use. Plus it's pvid. See:
>> > > 
>> > > https://www.spinics.net/lists/netdev/msg679750.html
>> > Thanks, Jakub,
>> > 
>> > Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>> > the VF's PVID. Other use-cases may be explored later on though.
>> Who is configuring those?
>> 
>> What does mean "allowed MAC address"? Does it mean a MAC address that VF
>> can use to send packet as a source MAC?
>> 
>> What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
>> some VIDs are allowed.
>> 
>> Pardon my ignorance, this may be routine in the nic world. However I
>> find the desc very vague. Please explain in details, then we can try to
>> find fitting solution.
>> 
>> Thanks!
>
>These MAC or VLAN ACL settings are configured on the Power Hypervisor.
>
>The rules for a VF can be to allow or deny all MAC addresses or VLAN ID's or
>to allow a specified list of MAC address and VLAN ID's. The interface allows
>or denies frames based on whether the ID in the VLAN tag or the source MAC
>address is included in the list of allowed VLAN ID's or MAC addresses
>specified during creation of the VF.

At which point are you doing this ACL? Sounds to me, like this is the
job of "a switch" which connects VFs and physical port. Then, you just
need to configure this switch to pass/drop packets according to match.
And that is what there is already implemented with TC-flower/u32 + actions
and bridge offload.


>
>Thanks for your help,
>
>Tom
>
