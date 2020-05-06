Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453D1C7877
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgEFRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbgEFRpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 13:45:11 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E490DC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 10:45:10 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e10so1562434vsp.12
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 10:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hASypAIk45GMe7rNlqwCahNdX4a/8GjI8mpvIJTl9Ko=;
        b=XUm+4DSLaZTib4G4rwrclbXvrUPp7deXDVqdCGNwBJJAInEVvCyRA/TKTV9CgW6/zb
         frnDzXkjnUuAu4UqwkNICXLdK4ipZ5/o3s0+UFpykDmbkZwKKFzVxYDJV//mVNGz28vY
         QAW8KzSeaAkybaE6p1lmbFB7IkbdpWNc/KbLVdYIhdZYkY6IDR1+JQIVuHZ5Lra1/+mG
         AEKyhlbsKrX62neMPf9h0L+piNHKwlinI1GUHQauw6PpPNhToARRG4KbjiyKNQozHq5h
         m9TZvPguYN0FvTz8NeEdr3e62IbvVQZnpP0+RK07ORTIV4IMikSMuCEApB9RXUhDp/gD
         XdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=hASypAIk45GMe7rNlqwCahNdX4a/8GjI8mpvIJTl9Ko=;
        b=X6XiywlqSpcgKZMJoIjqnpouTmzQufw6+wOrFtaS1fm2JSe0vVgzlVAFn68LmNYPy3
         wTLEE5vAgIOx8N8gnfTqPZFDrP8N51Ppmj0EHU1iyPyY1odVJndGi5dWFzRTYNjYM+cq
         0zfbHFPDbYYfkGfdZ/eMbp8IAP/ie47iYgIr22nO8ySGnxCyuZtJb8WI2Tmjcn4KZPxr
         UTCxjexdyCRXs30XaYCiqKqW287YVTwTNuZTdxg733zEtMrHGd7G9xX8QllBebL1Nlpp
         OeQb9lZLHMbTBgtREIKRVolSyHcCTEn37AGsegujnN4UPoh5yWRvF66iZuw1f5tLmAqq
         Nh/A==
X-Gm-Message-State: AGi0PuZXVTvQbxVH2R3ZR6kGmReZ/9P4UxJFaHk/8PADEn5BiyWl+6cZ
        7mqz/KDSCOxIsdaixvQcjKlceoS/r5HX47NDrlqOJ8HCnTo=
X-Google-Smtp-Source: APiQypL/wGyZmmThGEOlpd/cNRmnkXpEo7ZnS7XnOJ1QEWQGjyC+WREYlCQ733Eu1Qg8FzfGzyF4o/KGpM1Rb7DAh1E=
X-Received: by 2002:a67:1502:: with SMTP id 2mr9161458vsv.80.1588787110104;
 Wed, 06 May 2020 10:45:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:768:0:0:0:0:0 with HTTP; Wed, 6 May 2020 10:45:09 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <005a01d622fa$25745e40$705d1ac0$@xen.org>
References: <1588581474-18345-1-git-send-email-kda@linux-powerpc.org>
 <1588581474-18345-2-git-send-email-kda@linux-powerpc.org> <004201d622e8$2fff5cf0$8ffe16d0$@xen.org>
 <CAOJe8K3sByKRgecjYBnm35_Kijaqu0TTruQwvddEu1tkF-TEVg@mail.gmail.com> <005a01d622fa$25745e40$705d1ac0$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 6 May 2020 20:45:09 +0300
Message-ID: <CAOJe8K3ieApcY_VmEx1fm4=vgKgWOs3__WSr4m+F8kkAAKX_uQ@mail.gmail.com>
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

On 5/5/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> >> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
>> >> *dev,
>> >>  		set_backend_state(be, XenbusStateConnected);
>> >>  		break;
>> >>
>> >> +	case XenbusStateReconfiguring:
>> >> +		read_xenbus_frontend_xdp(be, dev);
>> >
>> > Is the frontend always expected to trigger a re-configure, or could
>> > feature-xdp already be enabled prior to connection?
>>
>> Yes, feature-xdp is set by the frontend when  xdp code is loaded.
>>
>
> That's still ambiguous... what I'm getting at is whether you also need to
> read the xdp state when transitioning into Connected as well as
> Reconfiguring?

I have to read the state only during the Reconfiguring state since
that's where an XDP program is loaded / unloaded and then we transition
from Reconfigred to Connected

>
>   Paul
>
>
