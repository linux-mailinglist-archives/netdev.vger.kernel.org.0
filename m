Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAACA652D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 11:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfICJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 05:29:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42760 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfICJ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 05:29:31 -0400
Received: by mail-io1-f68.google.com with SMTP id n197so32390684iod.9
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 02:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8Jt2xE+wUv9+deP8KWEAK1pKoGoCtpCuIlNTIBVFtsk=;
        b=sE0kMM1ehxOBajVIEEyhAsbhFmOEaL7cNOzXZYeedi2dQID0MrrCdMMpN03VsY0qGf
         JKg9uUb5SwUCS3N9sfLTEUeACxFZUgymPriNvXGYj8gilPuVNvBI4M+R4qIgWhd6Lt5Y
         W2MUif97ljnk6aVb2UJ6W+6Rnc9jvZUUcTrIRwbhL60Q/zBWeOlZ+aOVLV9M9l0rb5/h
         ojKLxt7YAnJFIgNW7Gt8OVdx/gorzSmCGapqB2tLOn23gLoJDVz3G4+pLxLSLK3h6Hpw
         E0dLwmURj2Z+rDpLQycUxgn0GYNeXRvepGWSZVXorEqr1sHCbIwuorU/+7b8kKyCVvyN
         guRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8Jt2xE+wUv9+deP8KWEAK1pKoGoCtpCuIlNTIBVFtsk=;
        b=Vm9o7tJTV0QBKBdJH9JE0M0P2aBwLWqSq24RV75/IVa6cZt+s39DUeA2W128IIMr39
         jPWzkN7NcGAfYBbpSl3i0nuSu91KwJv4GZJ1VpnwjR9gziH3RtOaN34KMAmMNQUENO9f
         b2mB8QN3Tqe0RM9z/BXfgzWH1wMDQRKN3b0aAhLMahzwyoWLk7gAq6oI/n2vE/Tnt+WU
         DIRISaX/DaOpJczr26r+H7sSB94Se6gCOxu3BAMUzd79FAihNl9Yt+VBXSZJqSwKz5On
         IJMNcAg2hCdFrQBA+T33xD+DGzm4bTB5A4g7tB72VVJy+fq/sm6cgwhJdHDsT1jSC9/f
         S6yQ==
X-Gm-Message-State: APjAAAXKQAdCYhlec2/0NKpl+cvirdkDKyrztKjjgD6i7z97jo8sM2u/
        wDEkzXgNrX7X/byXSvWoAym8HLwbBS2sFIo83h4=
X-Google-Smtp-Source: APXvYqyqmApAaMaXTtqEbD1y/Ln9NWqeKiV+OTfXPjdHpU5VpeEoQQH1lRinS+CH1cwZDlWiM0MrRImp4R6iHhXu8xo=
X-Received: by 2002:a02:ad0e:: with SMTP id s14mr16247237jan.97.1567502971141;
 Tue, 03 Sep 2019 02:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAA93jw73AJMwLL+6cNLB2R6oqA2DyMYc1ZUsrFPndESs0ZONng@mail.gmail.com>
 <3e8fd488-1bd1-3213-6329-6baf8935a446@gmail.com>
In-Reply-To: <3e8fd488-1bd1-3213-6329-6baf8935a446@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 3 Sep 2019 02:29:20 -0700
Message-ID: <CAA93jw5KLS2be7ZhaiCOM3Jz-TsmQBY=z7iF0Oq6QU6=mQH8pA@mail.gmail.com>
Subject: Re: how to search for the best route from userspace in netlink?
To:     David Ahern <dsahern@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 2, 2019 at 8:13 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 9/2/19 4:07 PM, Dave Taht wrote:
> > Windows has the "RtmGetMostSpecificDestination" call:
> > https://docs.microsoft.com/en-us/windows/win32/rras/search-for-the-best=
-route
> >
> > In particular, I wanted to search for the best route, AND pick up the
> > PMTU from that (if it existed)
> > for older UDP applications like dnssec[1] and newer ones like QUIC[2].
>
> RTM_GETROUTE with data for the route lookup. See iproute2 code as an
> example.

Yes. I really didn't describe my thinking very well. It's coping with
pmtu better
in the case of a more increasingly udp'd and tunneled internet. tcp
(being kernel based)
will do the probe and cache that attribute of the path, udp does not.
A udp based app with root privs could be setting it after figuring it
out,  a userspace one cannot.

for more detail from server-al sides of that philosophical debate,
please see the links I posted
originally.



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
