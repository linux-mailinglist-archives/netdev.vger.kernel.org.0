Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06153E3049
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 22:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244936AbhHFUWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 16:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbhHFUWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 16:22:30 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51172C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 13:22:14 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id z9-20020a9d62c90000b0290462f0ab0800so909687otk.11
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 13:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oT1ZaMnF/922fd8LeOSNLkY5D7MM5QFVcedxKnQmmuY=;
        b=DqCYiA3kfhyWS45JVuQNyl4NSV0Q8gfQNzVz64+fVx05v0O/3aERdCM8tbI8KuG5bX
         ++BLY+EVv8CD7iglXvHGMsh9FBbU/3aaBfT4hXldf4QXR9EaGXzMIpJSqZJIMwHCMc/F
         zlWg8QRNUSnCUj+cPRNvRnUR/dpvncODT9tgrv0jO4QjzOIr3m/5bx4blaTEE3JUQf7M
         32pI4RHgS7XNeafBqKWML6q604dSuWP5k4GPoawzGXe3rPzcCyOPVIbVaDVgH3utW5qE
         ijgrBKSpSv57DT5Jq6TJ2NMTiCrUaRlMO+D2BabPzcPUvZapzE42JE61zdsJYzWrWoeC
         tTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oT1ZaMnF/922fd8LeOSNLkY5D7MM5QFVcedxKnQmmuY=;
        b=grWRzyMq3AbvbhBKdXSIuBpr4m43nChRFEU4WueTcXVlSbQZG3PECkKBk9hB/u+EXj
         B/Bu1yQ0ZuzY0Nm8tV6VHgNPbvv9o+XCTCaeYweYLoJLircviVJMDUe8gT0oYfeC3kjD
         cUPcUNAGXwVaM+obgT4iX1SnII7d5XA18lA52ks9glBK5XOyouQyjIEgYg9vWE6Y0Bq4
         w0HbNYZHCncVhlOLGKsn6L2EVJ7joxqrSfrYuN3iC0NRjv5ILs3nRu9KMnNotG4XYAUE
         R1GF4xaYd84Uves2ub1TKTTU7deba8DqX/dewIyWUYvyrvdY7NEx2BAELrYNCvBwij7o
         9CDA==
X-Gm-Message-State: AOAM533RcstiIpVHGoKg7mj5/6866SaUvMN6TcLq+JfZOKi3slOAmIKs
        n4K8TD9a6CPnRZMrDdvf7dVSXHZPZ4rvrW7DZwi82g==
X-Google-Smtp-Source: ABdhPJwzj8mVkjaEbMHJrQlDaEv/v7ndldmE4RrSndfFONu0sVpp9+/bvZNtHc+l2QjcOzrCkyg1N5rhOieEHkhbWwo=
X-Received: by 2002:a05:6830:3143:: with SMTP id c3mr8845702ots.229.1628281333710;
 Fri, 06 Aug 2021 13:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org> <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org> <87bl6aqrat.fsf@miraculix.mork.no>
In-Reply-To: <87bl6aqrat.fsf@miraculix.mork.no>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Fri, 6 Aug 2021 22:22:02 +0200
Message-ID: <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

> > The summary of the thread was to set a large rx_urb_size during probe
> > itself for qmi_wwan.
>
> Yes, I think it would be good to make the driver DTRT automatically.
> Coding driver specific quirks into ModemManager might work, but it feels
> wrong to work around a Linux driver bug. We don't have to do that.  We
> can fix the driver.
>
> > https://patchwork.kernel.org/project/linux-usb/patch/20200803065105.8997-1-yzc666@netease.com/
> >
> > We could try setting a large value as suggested there and it should
> > hopefully
> > solve the issue you are seeing.
>
> Why can't we break the rx_urb_size dependency on MTU automatically when
> pass_through or qmi_wwan internal muxing is enabled? Preferably with
> some fixed default size which would Just Work for everyone.
>

That default fixed size you're suggesting for the rx_urb_size, isn't
it supposed to have the same logical meaning as RMNET_MAX_PACKET_SIZE
at the end?

-- 
Aleksander
https://aleksander.es
