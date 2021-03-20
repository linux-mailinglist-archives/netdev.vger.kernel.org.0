Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE05E34298A
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCTAy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCTAyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:54:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4645EC061760
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:54:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b9so12423639ejc.11
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgQXe0cWf59brnTyPAf2KhEj4+ZhZVhfve0gDWUjExA=;
        b=kr4d8DaIvQJJsNt/ziItohG8zdjExZ7oDjWlP6359eENCYhBRJUUbBVS/hxdiB4Xlr
         IvjgG9EgKu/IsGoEUyxsezjJSrNl9fN1epPUy7mZer9yH1JjCeEpWu1yNlA7URC8klvO
         VZQoaLaB5kct0LCiFmpAx5idOKhBA0lsbNFZOW6B+Nq+QLpL+r0Lx99iAJpFCeOEqbfA
         PtGgViQiQBx1ghrDBv2bXPn9e18irWpKU9RyVc+2k1PAzyAtb3jMU7qbSBSiJQLgc1GQ
         Y+WTaDUTlEqvSTyuXxBy313Mq9+8qcmF76fPO9CeZb0S402ySddmo5h9iwh7BYr73QMk
         WCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgQXe0cWf59brnTyPAf2KhEj4+ZhZVhfve0gDWUjExA=;
        b=p6eUiW8cW8TuVQ7Ygy135kG5rfgT3YXyIA45T4Vp8EmdFC1JUNRWEjX1vapSj1K187
         swQ8RBhu7NRhI9rImhXigQw4A1FAp3uqpbPuLNGio7kGpotryKKEw+iHHoDwjioOWRzj
         e+fh8+Joj30YveLInBoVkZcL/y5Mp9U4p7ZQ8FkKFM0jN45C65Jm8xfS1eYtuV/k+Z+W
         /8Tx7Y7r34bcHX9ZeC/ym6bOkvQQT8F2lNbaMtPmioAHAnxzLjKD6+Rgk6TUySEyfBdn
         AOPqM71mLIQXroS0xih/OpCZCAQxNeOrBOGLXA69HIv8d/KJJnwOpsjegH8Eu2FlSp6v
         iMEg==
X-Gm-Message-State: AOAM530xwS2+QMqo4VdInUY8NaygzaWFK6TIiEjl/wLMv4a666llVOfo
        +PKIpEKKpkPGUTTGTOnrJT7BOXnqS7g=
X-Google-Smtp-Source: ABdhPJxS/I3dwLdPXMHOAJvkEQwYCVBoCgmEnSXLuiIijR7kLLDSQfFSedMXhgmmCwyWKkU3OdSAHQ==
X-Received: by 2002:a17:906:1c13:: with SMTP id k19mr7332352ejg.457.1616201647731;
        Fri, 19 Mar 2021 17:54:07 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id q26sm4496859eja.45.2021.03.19.17.54.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 17:54:07 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id v11so10794748wro.7
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 17:54:07 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr7264925wrh.50.1616201646856;
 Fri, 19 Mar 2021 17:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210317221959.4410-1-ishaangandhi@gmail.com> <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com> <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
In-Reply-To: <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 19 Mar 2021 20:53:28 -0400
X-Gmail-Original-Message-ID: <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
Message-ID: <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
Subject: Re: [PATCH v3] icmp: support rfc5837
To:     David Ahern <dsahern@gmail.com>
Cc:     Ishaan Gandhi <ishaangandhi@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 7:54 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/19/21 10:11 AM, Ishaan Gandhi wrote:
> > Thank you. Would it be better to do instead:
> >
> > +     if_index = skb->skb_iif;
> >
> > or
> >
> > +     if_index = ip_version == 4 ? inet_iif(skb) : skb->skb_iif;
> >
>
> If the packet comes in via an interface assigned to a VRF, skb_iif is
> most likely the VRF index which is not what you want.
>
> The general problem of relying on skb_iif was discussed on v1 and v2 of
> your patch. Returning an iif that is a VRF, as an example, leaks
> information about the networking configuration of the device which from
> a quick reading of the RFC is not the intention.
>
> Further, the Security Considerations section recommends controls on what
> information can be returned where you have added a single sysctl that
> determines if all information or none is returned. Further, it is not a
> a per-device control but a global one that applies to all net devices -
> though multiple entries per netdevice has a noticeable cost in memory at
> scale.
>
> In the end it seems to me the cost benefit is not there for a feature
> like this.

The sysctl was my suggestion. The detailed filtering suggested in the
RFC would add more complexity, not helping that cost benefit analysis.
I cared mostly about being able to disable this feature outright as it has
obvious risks.

But perhaps that is overly simplistic. The RFC suggests deciding trusted
recipients based on destination address. With a sysctl this feature can be
only deployed when all possible recipients are trusted, i.e., on an isolated
network. That is highly limiting.

Perhaps a per-netns trusted subnet prefix?

The root admin should always be able to override and disable this outright.
