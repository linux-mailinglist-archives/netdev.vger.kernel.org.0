Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC71CE95A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 01:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgEKXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 19:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728152AbgEKXwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 19:52:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2053C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:52:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nv1so9468872ejb.0
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 16:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0r7T88oIiIbb0iqzpoQJfqVccNGcD4MyIfYdsyM0ybk=;
        b=TZAaSc3bBXOa76pGbQgPMavokHGGzGINv+EjxeGI36GD3ylvU5jjIAC6CmWP6wXJ1Z
         flq+tbwh/Mx0IISXmnJMdh5XOnYEkpJcWRjTSUsUdFiTRCmd8mkjrIFiYvhh3UKunmeV
         JemB011uQIrER0ypTpPJqDnm1eREjZ4GYnn0j9bmkihDSci7YG33Me4kS2P8Fx2kiiTy
         mTqmUtoP0DabshZ+Kzod2klDMR4nCVIBgPHdw0YjgL5PwbY8jfr+TESAxh9v4qZz7FNJ
         B3SFysupWUXdPs1jX1yMWBIVafubdAimTNdMl8T+Rpn1EH7ad7wjB7blTBL6mNz684Us
         Iahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0r7T88oIiIbb0iqzpoQJfqVccNGcD4MyIfYdsyM0ybk=;
        b=VYRBtRGoHLLDYIQrRFf4TjoC+0vt4FXza81bfXsZ9iLWSdJnNR8tOi1Nr0S8CHa1a5
         BC69bsboQDcY6R7XZCh2b49+Pzm3uai7TBZ1SzhtXeCYUZC8eHqS3Y9kZAe0p5wJl6Xg
         wqHAGTkcvsalC1BGxJ6APSulv9S03LfbsfXwhicIoFlRGQNx2qqMfUpQaKB5PW2SrciF
         Dj20Zp7+Lnj/KPE1wRRsCV7N6MU7ALKE9yuc5SRg5vi5W+UhJ6g/7uVNPOfFVOzeG/Cm
         aoXoXACmROa/+0yUXkqp/mDTMmJN1GxEpWNncDnxz/24fiomEQhWSOGOHew9L96Ydtan
         tBWg==
X-Gm-Message-State: AGi0Puaf0bvypGBBLbRhfVMIEFHNFndDd5QYMGFqrP/Wow/sYwlIhRwE
        7c1qIRCmKu/sBzg3KJia2j0RAcaLx5vyh5zOC2qaDA==
X-Google-Smtp-Source: APiQypJbBlW+iQBkJscQ/4LsBv39J2qHAXfpONbJ08aqIyaFnoJfIBSEb3zWmWwlnQYscB39KxMaYYMvuIDeBnCVUKw=
X-Received: by 2002:a17:906:d8c1:: with SMTP id re1mr9065058ejb.184.1589241156382;
 Mon, 11 May 2020 16:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200511202046.20515-1-olteanv@gmail.com> <525db137-0748-7ae1-ed7f-ee2c74820436@gmail.com>
In-Reply-To: <525db137-0748-7ae1-ed7f-ee2c74820436@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 May 2020 02:52:25 +0300
Message-ID: <CA+h21hqbiMfm+h994eV=7vRghapJm7HzybauQcggLhfs7At+fg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] DSA: promisc on master, generic flow
 dissector code
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 02:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/11/2020 1:20 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The initial purpose of this series was to implement the .flow_dissect
> > method for sja1105 and for ocelot/felix. But on Felix this posed a
> > problem, as the DSA headers were of different lengths on RX and on TX.
> > A better solution than to just increase the smaller one was to also try
> > to shrink the larger one, but in turn that required the DSA master to be
> > put in promiscuous mode (which sja1105 also needed, for other reasons).
> >
> > Finally, we can add the missing .flow_dissect methods to ocelot and
> > sja1105 (as well as generalize the formula to other taggers as well).
>
> On a separate note, do you have any systems for which it would be
> desirable that the DSA standalone port implemented receive filtering? On
> BCM7278 devices, the Ethernet MAC connected to the switch is always in
> promiscuous mode, and so we rely on the switch not to flood the CPU port
> unnecessarily with MC traffic (if nothing else), this is currently
> implemented in our downstream kernel, but has not made it upstream yet,
> previous attempt was here:
>
> https://www.spinics.net/lists/netdev/msg544361.html
>
> I would like to revisit that at some point.
> --
> Florian

Yes, CPU filtering of traffic (not just multicast) is one of the
problems we're facing. I'll take a look at your patches and maybe I'll
pick them up.

Thanks,
-Vladimir
