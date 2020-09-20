Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE7D271554
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgITPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:21:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ED3C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 08:21:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id x23so9728377wmi.3
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zbqk19DRUKiAoEVE2ZMp3tw6spv8ELW5R8m5iBOQBcA=;
        b=LEyAdlCa8fNSK76wZsQQltJFo1Ci7TUHgStyf2o0iWmO8RFlMNL0Te6C++pEYqB76V
         CBNaTsqcVmWAd8RCaEr4MC5QTAQ0aJ/MPbfMOz4LDjYGl4quf3AZatbqS/YmREFlqqma
         iZFXjW0GSwV9m2nGVZM5Ep2mTkQ8z8l9xJnXPgjG4A0sLPbxUpwei6yD2OGnxGhLTix5
         eD8k6/7DJ04sx+qso4/kViVrwjvjxJonFnzAke1ZwVE7pL8Tv7BBC1PRJUVGcqyU8u7w
         RPtfPsHIgGJvDeVcq/M8Oc4TF4l0Q4e+dzO8s0GDGxXn9WFP+NlbtFCNvMBpnqXaMQu8
         +ENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zbqk19DRUKiAoEVE2ZMp3tw6spv8ELW5R8m5iBOQBcA=;
        b=p+2eZd9MB5M9WoqghRyctWUo3Xot20hs+pGN1zdMgtz2Vv/37GVzaGG9E84Zzm2Ovi
         hiHY3163moCpanm2Y1GpGW6juUgZTGlMLc4di4WplXjdKR77Y5rgkD/g9yMnKAHHBhfh
         awXqtCl2EGU+LVAayl/emTcUIY4+CoJ2u+w8R03f4fTs9uqxu32Mg/zW+K+0lWP/MlC3
         adYwlHNKARTPt+xXt6NcSVb20zoJ8XLFrGAtLu8vlFTpnJxiuAveM8WU+IqmL5Rx7jIO
         kybMsmmMyqEsxeYgt7bpyEded5u9D4mw0e8T45/up+/8NfL9RY2H8WrsXyc7dUvsiV/a
         M6rQ==
X-Gm-Message-State: AOAM533pOsN7adFGqpVQyPPE9xBYtkI2YW0lL3DgEjlliC49fpAwS7n3
        enfPM43BbS2C4fmmGWpR5+ZiQg==
X-Google-Smtp-Source: ABdhPJzHJv+QUhDuwiK5NbjUtNgRgGxeTYr+LXUXqo35t4O9epo16YiYnszQUn4NiCjdV1XTqozqvg==
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr25207330wmj.166.1600615298338;
        Sun, 20 Sep 2020 08:21:38 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id t6sm17593694wre.30.2020.09.20.08.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2020 08:21:37 -0700 (PDT)
Date:   Sun, 20 Sep 2020 17:21:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200920152136.GB2323@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
 <20200910070016.GT2997@nanopsycho.orion>
 <f4d3923c-958c-c0b4-6aa3-f2500d4967e9@linux.ibm.com>
 <20200918072054.GA2323@nanopsycho.orion>
 <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdb48e1-171b-3ec6-c993-0499639d0fc4@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Sep 19, 2020 at 01:20:34AM CEST, tlfalcon@linux.ibm.com wrote:
>
>On 9/18/20 2:20 AM, Jiri Pirko wrote:
>> Thu, Sep 17, 2020 at 10:31:10PM CEST, tlfalcon@linux.ibm.com wrote:
>> > On 9/10/20 2:00 AM, Jiri Pirko wrote:
>> > > Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>> > > > On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>> > > > > On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>> > > > > > Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>> > > > > > > Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>> > > > > > > VNIC devices to administrators through devlink (originally through
>> > > > > > > sysfs files, but that was rejected in favor of devlink). Could you
>> > > > > > > give any tips on how you might go about doing this?
>> > > > > > Tom, I believe you need to provide more info about what exactly do you
>> > > > > > need to setup. But from what you wrote, it seems like you are looking
>> > > > > > for bridge/tc offload. The infra is already in place and drivers are
>> > > > > > implementing it. See mlxsw for example.
>> > > > > I think Tom's use case is effectively exposing the the VF which VLANs
>> > > > > and what MAC addrs it can use. Plus it's pvid. See:
>> > > > > 
>> > > > > https://www.spinics.net/lists/netdev/msg679750.html
>> > > > Thanks, Jakub,
>> > > > 
>> > > > Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>> > > > the VF's PVID. Other use-cases may be explored later on though.
>> > > Who is configuring those?
>> > > 
>> > > What does mean "allowed MAC address"? Does it mean a MAC address that VF
>> > > can use to send packet as a source MAC?
>> > > 
>> > > What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
>> > > some VIDs are allowed.
>> > > 
>> > > Pardon my ignorance, this may be routine in the nic world. However I
>> > > find the desc very vague. Please explain in details, then we can try to
>> > > find fitting solution.
>> > > 
>> > > Thanks!
>> > These MAC or VLAN ACL settings are configured on the Power Hypervisor.
>> > 
>> > The rules for a VF can be to allow or deny all MAC addresses or VLAN ID's or
>> > to allow a specified list of MAC address and VLAN ID's. The interface allows
>> > or denies frames based on whether the ID in the VLAN tag or the source MAC
>> > address is included in the list of allowed VLAN ID's or MAC addresses
>> > specified during creation of the VF.
>> At which point are you doing this ACL? Sounds to me, like this is the
>> job of "a switch" which connects VFs and physical port. Then, you just
>> need to configure this switch to pass/drop packets according to match.
>> And that is what there is already implemented with TC-flower/u32 + actions
>> and bridge offload.
>> 
>Yes, this the filtering is done on a virtual switch in Power firmware. I am
>really just trying to report the ACL list's configured at the firmware level
>to users on the guest OS.

We have means to model switches properly in linux and offload to them.
I advise you to do that.


>
>Tom
>
>> > Thanks for your help,
>> > 
>> > Tom
>> > 
