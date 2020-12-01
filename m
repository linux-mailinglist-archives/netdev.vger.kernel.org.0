Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0403E2CA522
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391598AbgLAOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:09:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38534 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbgLAOJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:09:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1DtHP4002730;
        Tue, 1 Dec 2020 14:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pTmh0fAx41hLIvYDyOekZfZD8/4rzzXxS/TqqdPExwg=;
 b=vLWTsjjic+1p3i9uxybiHNVi42dcBKcTvA6AfpFTEr0sUNmVqp9yRxLgg7kIK5qGUN0J
 oofgNIgToJJBxsPbFd+Am4pBxk6JPpjzRqo19VpEwymshbhsnRALOcfpiO21XOp3kmxr
 lgOLJrUqyUshUH+0ojxyxXIg1LFHdnj2t2Bklh5y68LsxqqiRxoSPtOWNIoWynIJF754
 5bVkuWqCYCEFs8tq7LyeOV+zI3/vr+tI5ZKBss7pqjTfnpXNJRaPwJeD8R6AGcywA+BA
 lerBH0PS/hUi55aURtflNdJ2juhGcYo6ht8r8gtlOn38U9XkoMGDxbASv62fD9VykISM Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqjnq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 14:07:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Du5R6003844;
        Tue, 1 Dec 2020 14:05:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3540ey0hqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 14:05:41 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B1E1twO021849;
        Tue, 1 Dec 2020 14:05:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540ey0hp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 14:05:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1E5MSD015816;
        Tue, 1 Dec 2020 14:05:23 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 06:05:21 -0800
Date:   Tue, 1 Dec 2020 17:04:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, alsa-devel@alsa-project.org,
        linux-atm-general@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-ide@vger.kernel.org, dm-devel@redhat.com,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
        samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        usb-storage@lists.one-eyed-alien.net, drbd-dev@tron.linbit.com,
        devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
        linux-acpi@vger.kernel.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org, linux-input@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>,
        tipc-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org,
        selinux@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-geode@lists.infradead.org,
        linux-can@vger.kernel.org, linux-block@vger.kernel.org,
        linux-gpio@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        linux-mediatek@lists.infradead.org, xen-devel@lists.xenproject.org,
        nouveau@lists.freedesktop.org, linux-hams@vger.kernel.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-hwmon@vger.kernel.org,
        x86@kernel.org, linux-nfs@vger.kernel.org,
        GR-Linux-NIC-Dev@marvell.com, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        linux-mmc@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-crypto@vger.kernel.org, patches@opensource.cirrus.com,
        Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org,
        target-devel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
Message-ID: <20201201140449.GG2767@kadam>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011201129.B13FDB3C@keescook>
 <20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <202011220816.8B6591A@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011220816.8B6591A@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 08:17:03AM -0800, Kees Cook wrote:
> On Fri, Nov 20, 2020 at 11:51:42AM -0800, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 11:30:40 -0800 Kees Cook wrote:
> > > On Fri, Nov 20, 2020 at 10:53:44AM -0800, Jakub Kicinski wrote:
> > > > On Fri, 20 Nov 2020 12:21:39 -0600 Gustavo A. R. Silva wrote:  
> > > > > This series aims to fix almost all remaining fall-through warnings in
> > > > > order to enable -Wimplicit-fallthrough for Clang.
> > > > > 
> > > > > In preparation to enable -Wimplicit-fallthrough for Clang, explicitly
> > > > > add multiple break/goto/return/fallthrough statements instead of just
> > > > > letting the code fall through to the next case.
> > > > > 
> > > > > Notice that in order to enable -Wimplicit-fallthrough for Clang, this
> > > > > change[1] is meant to be reverted at some point. So, this patch helps
> > > > > to move in that direction.
> > > > > 
> > > > > Something important to mention is that there is currently a discrepancy
> > > > > between GCC and Clang when dealing with switch fall-through to empty case
> > > > > statements or to cases that only contain a break/continue/return
> > > > > statement[2][3][4].  
> > > > 
> > > > Are we sure we want to make this change? Was it discussed before?
> > > > 
> > > > Are there any bugs Clangs puritanical definition of fallthrough helped
> > > > find?
> > > > 
> > > > IMVHO compiler warnings are supposed to warn about issues that could
> > > > be bugs. Falling through to default: break; can hardly be a bug?!  
> > > 
> > > It's certainly a place where the intent is not always clear. I think
> > > this makes all the cases unambiguous, and doesn't impact the machine
> > > code, since the compiler will happily optimize away any behavioral
> > > redundancy.
> > 
> > If none of the 140 patches here fix a real bug, and there is no change
> > to machine code then it sounds to me like a W=2 kind of a warning.
> 
> FWIW, this series has found at least one bug so far:
> https://lore.kernel.org/lkml/CAFCwf11izHF=g1mGry1fE5kvFFFrxzhPSM6qKAO8gxSp=Kr_CQ@mail.gmail.com/

This is a fallthrough to a return and not to a break.  That should
trigger a warning.  The fallthrough to a break should not generate a
warning.

The bug we're trying to fix is "missing break statement" but if the
result of the bug is "we hit a break statement" then now we're just
talking about style.  GCC should limit itself to warning about
potentially buggy code.

regards,
dan carpenter
