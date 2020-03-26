Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F60194235
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCZO74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:59:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35904 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgCZO74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:59:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id g62so7392883wme.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dm0T+YWOoJSyDk1JwjqcP0zrbPLG7oa0HEiHJymOdgo=;
        b=hROVBXxa+h/UhwpjAywQGVDjL/X+Hh6JfWpufDP+2qwpHX0LPxMUuFZjYfRHGc2vaX
         zOEp8mfi7Ux/ccrNvaAZ1cLeXaVCg0LW/pYjlBBVpq0efVsHhMJ4zoJn0/JIm3V109A1
         KQL7xJr5FakNJ+ScxARF1pXGEwYC7F6VRogaziX20t2mDWD+RZB3cZo1EC1K6eVmmuUJ
         acJamHaMSZTCgNuAfq/a+LYJSzsQ9VFg3VPCEwV+wgMYrzxzWsBMQ90FwOzEnw8cilmF
         r7LW4aWU+2ML6UTeqT0AKNhShiUMACCrpP1PmuIDdOqq3N4P9LjSC1aqqXsw2DWlLUsH
         Ctlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dm0T+YWOoJSyDk1JwjqcP0zrbPLG7oa0HEiHJymOdgo=;
        b=Ae8AOZmLiZvS9mNiiF0yT6TZY7UescbXTkvDh3rpC7jaWieQZQ5bpXD4+motGNkxSI
         l54ww2/F+6bkR7zX0I93NCCU1/ncltGZK0JqGhyuWIcp1SsF0NAnUYyio8D3p+3GtKwC
         j6lU71+4dtXMsQxtLPiLUrH34ldQM2Xigq36ZJBTAHpNinbo7PfKOzZ3cEh+UL7z3hDG
         u4h8GYy3PhNOS4EWaVd2PAl/FI05nfu+yDTYLMcfuQLIeAMrcIifos7xocA6bcTl9bSZ
         +4nih9XYeWkFn1sauvWURWShzgFesVc5c7NFPltodl+iM/UArGK/Y2iR9afthHbTYreZ
         EZ4g==
X-Gm-Message-State: ANhLgQ1dwu7fe9Yi/FBX7xyqSIVLUJyiMQBNi87Hq7VJurWEhB9qoi3+
        IIopGILwe2slMMaX7NDXhNneZg==
X-Google-Smtp-Source: ADFU+vv+q8FN0UCQT2toTqhTywrDKEReJ/fFgpUijUhx5w+cinTgtgIOMXHP5gTY36BxpT8F0IyBZw==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr348892wmi.9.1585234794947;
        Thu, 26 Mar 2020 07:59:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b187sm4075274wmc.14.2020.03.26.07.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:59:53 -0700 (PDT)
Date:   Thu, 26 Mar 2020 15:59:53 +0100
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
Message-ID: <20200326145953.GY11304@nanopsycho.orion>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >> >> $ devlink slice add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10 hw_addr aa:bb:cc:aa:bb:cc    
>> >> >
>> >> >Why is the SF number specified by the user rather than allocated?    
>> >> 
>> >> Because it is snown in representor netdevice name. And you need to have
>> >> it predetermined: enp6s0pf1sf10  
>> >
>> >I'd think you need to know what was assigned, not necessarily pick
>> >upfront.. I feel like we had this conversation before as well.  
>> 
>> Yeah. For the scripting sake, always when you create something, you can
>> directly use it later in the script. Like if you create a bridge, you
>> assign it a name so you can use it.
>> 
>> The "what was assigned" would mean that the assigne
>> value has to be somehow returned from the kernel and passed to the
>> script. Not sure how. Do you have any example where this is happening in
>> networking?
>
>Not really, but when allocating objects it seems idiomatic to get the
>id / handle / address of the new entity in response. Seems to me we're
>not doing it because the infrastructure for it is not in place, but
>it'd be a good extension.
>
>Times are a little crazy but I can take a poke at implementing
>something along those lines once I find some time..

I can't really see how is this supposed to work efficiently. Imagine a
simple dummy script:
devlink slice add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
devlink slice set pci/0000.06.00.0/100 hw_addr aa:bb:cc:aa:bb:cc
devlink slice del pci/0000.06.00.0/100

The handle is clear then, used for add/set/del. The same thing.


Now with dynamically allocated index that you suggest:
devlink slice add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10
#somehow get the 100 into variable $XXX
XXX=???
devlink slice set pci/0000.06.00.0/$XXX hw_addr aa:bb:cc:aa:bb:cc
devlink slice del pci/0000.06.00.0/$XXX

there are two things I don't like about this:
1) You use different handles for different actions.
2) You need to somehow get the number into variable $XXX

What is the benefit of this approach?
