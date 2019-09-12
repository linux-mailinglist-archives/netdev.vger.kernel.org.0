Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F5B0C63
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbfILKOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:14:52 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42515 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbfILKOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:14:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id c195so3993002lfg.9
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 03:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=flqwx9shyx7tKT8d9BFo1Gu9ubXL2t2/nvCHaHIivYc=;
        b=E8Y8lQZ4XeV/Wb5DOvClRK25UmPyT6wxiUvdZi0INhTIoki1zcRUyJwe5w0ubzaXxt
         /RZpaHE+DJ1aYMW5EOAsofRhcPnYxgzPYzEZKtBfnfmeNmLkT+8YvRj4Pbriw0Kfs0c6
         Yy0ugbgiCPN6StxdQA751RB5yXKaLolTvk+RY9ZN/8RtG+xPbGPVrtzkiv0a33/wJ9wU
         jiVbVSohgaVm3bJ53M95u7HO2sZ8Y/gIHLUGAVER0r0JQxQi/59t2jCP4zQXq9wH2YKY
         DC+SksqPSPRhkxAcgxKOyDKlQE6mjhsjGTW3WVUGo1CrRYjI7+fyXVxexHi0A3ZrRzDz
         qqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=flqwx9shyx7tKT8d9BFo1Gu9ubXL2t2/nvCHaHIivYc=;
        b=PnJxjBFMFVUzFdyuMIUgb3aCU18cFZJD8ZnS4W22q6vsxPOIj7AfwWp11VWblosRsS
         e2GZsj8uOwbumWtFNU/dgw55D8HOikJWOmR72S64A0GQZOCFiwuvu3Dpd3yO8Ng05xWM
         F/3aItSRwhruAD0LMzhILNkwvLsJo6Itu1RlSEihtlArmzuOEvbBvqXxd8zbbmwoYDRo
         OOkIzpO7ix/pjWx0n8Q4BE+2wWdXyWe3xqUQ9pg3b55tXLmdSlNbNKnYKBIcGLz+anN4
         n7377zMWumNPJBSjrfBP4OYDCm8sSt9b7Y8O1fdw0ERCh7kf0BsJ6IenvAwN3k2ZY3Se
         p/2Q==
X-Gm-Message-State: APjAAAVLXl1DNglWvyuWSi4VTmBBW5AQWRgFGJcb+oNQhov3SIcS5kRY
        Pk70KhQZOm/32QdoUKnPMP7u9tLwo9N3+sxWn48=
X-Google-Smtp-Source: APXvYqwWRUVcJJIPu1MhTYgVZlYPou92JTHihIvI7RP4F7RTSKswy+YtxnHHrswX7+eidhxAHAIBVzR5zMS0kZoWBsA=
X-Received: by 2002:a19:c002:: with SMTP id q2mr27895995lff.62.1568283290011;
 Thu, 12 Sep 2019 03:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190907134532.31975-1-ap420073@gmail.com> <20190912.003209.917226424625610557.davem@davemloft.net>
 <CAMArcTV-Qvfd7xA0huCh_dbtr7P4LA+cQ7CpnaBBhdq-tq5fZQ@mail.gmail.com> <20190912.113807.52193745382103083.davem@davemloft.net>
In-Reply-To: <20190912.113807.52193745382103083.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 12 Sep 2019 19:14:37 +0900
Message-ID: <CAMArcTWMjTsZB8Ssx+hVMK-3-XozZw7AqVE62-H+zrJ+doC5Lw@mail.gmail.com>
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 at 18:38, David Miller <davem@davemloft.net> wrote:
>
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Thu, 12 Sep 2019 12:56:19 +0900
>
> > I tested with this reproducer commands without lockdep.
> >
> >     ip link add dummy0 type dummy
> >     ip link add link dummy0 name vlan1 type vlan id 1
> >     ip link set vlan1 up
> >
> >     for i in {2..200}
> >     do
> >             let A=$i-1
> >
> >             ip link add name vlan$i link vlan$A type vlan id $i
> >     done
> >     ip link del vlan1 <-- this command is added.
>
> Is there any other device type which allows arbitrary nesting depth
> in this manner other than VLAN?  Perhaps it is the VLAN nesting
> depth that we should limit instead of all of this extra code.

Below device types have the same problem.
VLAN, BONDING, TEAM, VXLAN, MACVLAN, and MACSEC.
All the below test commands reproduce a panic.

BONDING test commands:
    ip link add bond0 type bond
    for i in {1..200}
    do
            let A=$i-1
            ip link add bond$i type bond
            ip link set bond$i master bond$A
    done
    ip link set bond5 master bond0

TEAM test commands:
    ip link add team0 type team
    for i in {1..200}
    do
            let A=$i-1
            ip link add team$i type team
            ip link set team$i master team$A
    done

MACSEC test commands:
    ip link add link lo macsec0 type macsec
    for i in {1..100}
    do
            let A=$i-1
            ip link add link macsec$A macsec$i type macsec
    done
    ip link del macsec0

MACVLAN test commands:
    ip link add dummy0 type dummy
    ip link add macvlan1 link dummy0 type macvlan
    ip link add vlan2 link macvlan1 type vlan id 2
    let i=3
    for j in {1..100}
    do
            let A=$i-1
            ip link add macvlan$i link vlan$A type macvlan
            let i=$i+1
            let A=$i-1
            ip link add vlan$i link macvlan$A type vlan id $i
            let i=$i+1
    done
    ip link del dummy0

VXLAN test commands:
    ip link add vxlan1 type vxlan dev lo id 1 dstport 1
    for i in {2..100}
    do
            let A=$i-1
            ip link add vxlan$i type vxlan dev vxlan$A id $i dstport $i
    done
    ip link del vxlan1
