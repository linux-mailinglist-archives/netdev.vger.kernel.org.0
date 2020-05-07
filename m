Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A01C884A
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEGLah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgEGLag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 07:30:36 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4704AC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 04:30:36 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id l25so3128690vso.6
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 04:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wOFK7Xi1fpMDEr14fm1ZZw2Ilgkyrq3a9ZlSaGBDdOw=;
        b=grvnGNqRAmCQ7mzNrf1uhSKs8SCmGaDed+ZtoM5Fn7WmeZPsfWkFr4WkDQpLSmNvNU
         ZTC/zB+lUBSr0AmB4Kr49cANhQmrlh8JFwAgEsznmEr61Hqn1WPc2avTTfITWao0dVGr
         IhoxMRZKFCF5N7zGap4Jha0qFnCbpuVodFVP/m8+HI3D9tcJC6VbQiFKOoMLwBGhAHIj
         g/Bce4FkBsfKnr/xAt7ewi39QdhfZiA1MnjPZudAzs0+toRTPjlXgkEDYdJ0nU8pJyWb
         hy1OKDXAMFDsT20NB0Ppfs6XZLjdAN7RljV9CIIPnlsCfVv3ku1BUGy3MBS3uyVM9n40
         5vaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=wOFK7Xi1fpMDEr14fm1ZZw2Ilgkyrq3a9ZlSaGBDdOw=;
        b=CQVixQT5CgBwkzV5xbjjxnJw7DfvtHoonXtKRLkB7pAP5OWKx5SUZfXlfbJJzlP7c/
         UZhLsGEwW3F8H0UL/wngdmf4p4IAmxIijTKhnImwEPVW7VdfvEs5ngNP+k0WxzD2soH3
         cXRlAobFf4bpHem7gHPyI43YKri0v2OZC4TCAOpVqvzh1n2f2bHbE1+T4YXlTnZ61QTj
         XcGC65hfGP8XnFKuKDFWvp1JZNC58fIZuDtASEANw1QnUxazfE0Rr0gdc+yBOB1/IMLD
         JvvhWFgumZQ10ZsQmMmSUT/h3kxKjFrvSFGr6gXEXor/VAjgE3bKkyZtucrpbcYczXgC
         pe+A==
X-Gm-Message-State: AGi0Pubuovpwt8jwPwMfdwb0wkfUyrEbLKcY401a3/v37JBB+0rEoths
        t021LLSaM/LuzLzpSeBl6doy+Q6OOdt/UIBevc2tqQ==
X-Google-Smtp-Source: APiQypI3gLlJkvqcpTOw3IZL68NDf2R26qKv3WMc4xKeOpN7asaiRzr19OANh+U8juNqSIqGOUkXIE/ExdxasM84/aw=
X-Received: by 2002:a67:1502:: with SMTP id 2mr12210952vsv.80.1588851035477;
 Thu, 07 May 2020 04:30:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:768:0:0:0:0:0 with HTTP; Thu, 7 May 2020 04:30:34 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <00aa01d6243f$bedafad0$3c90f070$@xen.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
 <1588581474-18345-2-git-send-email-kda@linux-powerpc.org> <004201d622e8$2fff5cf0$8ffe16d0$@xen.org>
 <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com>
 <005a01d622fa$25745e40$705d1ac0$@xen.org> <CAOJe8K3ieApcY_VmEx1fm4=vgKgWOs3__WSr4m+F8kkAAKX_uQ@mail.gmail.com>
 <00aa01d6243f$bedafad0$3c90f070$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 7 May 2020 14:30:34 +0300
Message-ID: <CAOJe8K0cB9govqjLO8wtpwz1FcY23x+ppL97pC7c8UKbbMMXYQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/2] xen networking: add XDP offset adjustment
 to xen-netback
To:     paul@xen.org
Cc:     netdev@vger.kernel.org, jgross@suse.com, wei.liu@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 06 May 2020 18:45
>> To: paul@xen.org
>> Cc: netdev@vger.kernel.org; jgross@suse.com; wei.liu@kernel.org;
>> ilias.apalodimas@linaro.org
>> Subject: Re: [PATCH net-next v7 2/2] xen networking: add XDP offset
>> adjustment to xen-netback
>>
>> On 5/5/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> >> -----Original Message-----
>> >> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct
>> >> >> xenbus_device
>> >> >> *dev,
>> >> >>  		set_backend_state(be, XenbusStateConnected);
>> >> >>  		break;
>> >> >>
>> >> >> +	case XenbusStateReconfiguring:
>> >> >> +		read_xenbus_frontend_xdp(be, dev);
>> >> >
>> >> > Is the frontend always expected to trigger a re-configure, or could
>> >> > feature-xdp already be enabled prior to connection?
>> >>
>> >> Yes, feature-xdp is set by the frontend when  xdp code is loaded.
>> >>
>> >
>> > That's still ambiguous... what I'm getting at is whether you also need
>> > to
>> > read the xdp state when transitioning into Connected as well as
>> > Reconfiguring?
>>
>> I have to read the state only during the Reconfiguring state since
>> that's where an XDP program is loaded / unloaded and then we transition
>> from Reconfigred to Connected
>>
>
> Ok, but what about netback re-connection? It is possible that netback can be
> disconnected, unloaded, reloaded and re-attached to a running frontend. In
> this case XDP would be active so I still think read_xenbus_frontend_xdp()
> needs to form part of ring connection (if only in this case).

I made a change to xdp-netfront to keep the state of XDP
and then just pass the saved state in talk_to_netback()

>
>   Paul
>
>
