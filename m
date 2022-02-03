Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEC74A7DDE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 03:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiBCCUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 21:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiBCCUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 21:20:40 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C04C061714;
        Wed,  2 Feb 2022 18:20:40 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id n15so2685694uaq.5;
        Wed, 02 Feb 2022 18:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tWvcpRyL+bk3Xxu49uwybu4k8QPczRdqaC57dr6g/JM=;
        b=SEi/OKvcrBc9qFDvZIBqAaQXwyFe/aBBjMQ/D/fXPqsKqwaqJ0WZ/W8Pwnm0HEoHfu
         kYoqExEfyxPLioE9hMsbC8lEK1y55FIUSYAr2OdfCpERm6WN03Ey6VNFuSZLtK0Hi+iC
         5QlTljl2NvT+JZjlmNSgba1c+pAAgrijGM0lCNRST1yfdlQtu+ox+d7b3kbl8C34ezYC
         rTBR8RFzYm/ONejmB2hjA/5o/5JwqalninyC2HvPS9eMoFU6VNBfJvrFbL/HQAXQYHa0
         Xt4i6KCt1olYgrvgMwCuGjkUmriy7i1ic0DKU8/2y1PBsTKXmD1ElOxbPG1BU5l243xe
         /RxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tWvcpRyL+bk3Xxu49uwybu4k8QPczRdqaC57dr6g/JM=;
        b=ymTaBqWhaS1DrlG1RukOtF/yF0bko02oBdv0j6kW/YdX/Q8R681s5okqdTuVVGesxY
         ATkZcd3JtiQGt2npyl1S4lIzvljDFYuaaj4TLNfnlVPjg4jkkcVcrIHcO3q2CjTBUAnz
         oD8jPEBASj9X8fpfKOqOvc56Jdac0ebEfZictgNy8LKz21MYCps32bFM8dXgImCQ1s7y
         ITMikr+jhCL5kFxHQ9ErBpGtWB6Gj1rdN0a3AaSRFxj1Zgfv1mZgyCBLq/IgyK2RRUC/
         ohblbecYjFsaixzOAinWxW+xMmyqt5XFWcjq2RUHpjkm4d/nOViJCVkIDJ6ztYcgwijC
         6iyw==
X-Gm-Message-State: AOAM5300U9x3goSMXB9QSv+YVMOZSo9qV+G75/hvDSBaChB05CKRK5qO
        gGp1fwX50spA9msqpSeCe6RadgzY1VUeU72rlYA=
X-Google-Smtp-Source: ABdhPJwD7hVjiKofWegP6ZZsLhWTmXz9k3fWDttPfDYs4unrIUMHCuO2GXKyG+Sixkk3szRYjrugagxk2U97bZ4CLjw=
X-Received: by 2002:a05:6102:38d1:: with SMTP id k17mr12641123vst.50.1643854839175;
 Wed, 02 Feb 2022 18:20:39 -0800 (PST)
MIME-Version: 1.0
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de> <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de> <YfKCTG7N86yy74q+@kroah.com>
 <20220127120039.GE9150@pengutronix.de> <YfKcYXjfhVKUKfzY@kroah.com>
In-Reply-To: <YfKcYXjfhVKUKfzY@kroah.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 3 Feb 2022 05:20:34 +0300
Message-ID: <CAHNKnsTY0cV4=V7t0Q3p4-hO5t9MbWWM-X0MJFRKCZ1SG0ucUg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from device tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        open list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg,

if I may be allowed, I would like to make a couple of points about
specifying network interface names in DT. As in previous mail, not to
defend this particular patch, but to talk about names assignment in
general.

I may be totally wrong, so consider my words as a request for
discussion. I have been thinking about an efficient way for network
device names assignment for routers with a fixed configuration and
have always come to a conclusion that DT is a good place for names
storage. Recent DSA capability to assign names from labels and this
patch by Oleksij show that I am not alone.

On Fri, Jan 28, 2022 at 3:34 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> And again, pick your names in userspace, embedded is not "special" here.

Embedded is not a special case, but fixed configuration is.

> You can do persistant network device names in a very trivial shell
> script if needed, we used to do it that way 18 years ago :)

Network device name is not a solely userspace entity. It is part of
the interface between the kernel and userspace software.

Sure, persistent names can be established with a userspace script. But
this implies the device renaming, which is a complex and race prone
task. Once I even found a comment in the kernel code that only network
devices could be renamed and this is a headache. As for userspace, it
is possible to workaround the device renaming issues. But this
requires a lot of code in many programs and sometimes even special
conventions on a programs interaction. E.g. consider a case where a
service would like to bind to a network interface, which is in the
middle of renaming by udev. On the other hand, we have the kernel that
could provide predictable names from the beginning for all software on
a host. So this is a desired option.

As for DT, this is an excellent database with perfectly established
relations to hardware configuration. And if we try to implement a
userspace storage with the network device names, then we will just
duplicate the DT in the userspace, as already was mentioned by
Oleksij. To me, implementation of a names database in userspace looks
more like reinventing the  DT (wheel) than adding device names to the
DT.

To summarize, we (developers of embedded software) have two related needs:
1) the need for persistent names provided by the kernel,
2) using the DT as a source of persistent names for (1).

Greg, what do you think about device names storing in DeviceTree in
the above context? Does it still make no sense?

-- 
Sergey
