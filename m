Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B032B410AC1
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 10:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhISI27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 04:28:59 -0400
Received: from mout.gmx.net ([212.227.15.15]:36979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhISI26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 04:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1632040038;
        bh=bhpnsaGrv1Np5DCcjaML4H7Oxy9P1u6fnD5PIt2nVJE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=BJoNlmIpWvL93Ez43cKMHRjF33O5J5CmJnSxXc3wRAb6X+RvTeDzKSXDpRDfmubDb
         rvgwifMccIi4fCRuhbs5njatCvfgrKOLEyFt0L/t+CK+oVYjpRga2hrn5D3XKm2j9i
         fEecdnN2+Vo6NmoMPr2z5xAk64umomxs8dvIL8mE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([79.150.72.99]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MJE2D-1mC8pq469b-00KeCc; Sun, 19
 Sep 2021 10:27:18 +0200
Date:   Sun, 19 Sep 2021 10:27:05 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Kees Cook <keescook@chromium.org>, Len Baker <len.baker@gmx.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Colin Ian King <colin.king@canonical.com>,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Message-ID: <20210918171519.GA2141@titan>
References: <20210911102818.3804-1-len.baker@gmx.com>
 <20210918132010.GA15999@titan>
 <BYAPR21MB1270797B518555DF5DC87871BFDE9@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1270797B518555DF5DC87871BFDE9@BYAPR21MB1270.namprd21.prod.outlook.com>
X-Provags-ID: V03:K1:0Usx9DIb/dE6r4AgA5bj+2H9ipZynWUT6G16cuQBnHsNr+kBZoR
 +l/jfqBdlR3QmD0jTX6WNa8vHjJkdzf2bXDDPykHodB/1mrO1nUJ6AZLVl0NgXVz0gtGISk
 jJ+kwAH1QYzowbUo0nJ0gygeIJkKK7eUPjsvlQ4Z6FH7rISeES9ue7+jK9zDavetLczc1FT
 V4vqf4e+YebRTYGD58maw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/o2y+7uZsWk=:i/6c2zo8lB/CxbdCkH5RA9
 NQsyuIZxvE/yGV1swzX6YJsbVmi+DPQweOyxQkuR1oSGzmYtrIM0jVspuno6MXmIsiFDve7fE
 jhJswVHO2qnR8+5ytzSIcdVPc11h5iw+p9oTg0GGqK22cWPc5qfTAsisPXetdfHkaDsSDJGMT
 dkZFNw8yCxreLE/4T2L7EXINbcCmYrXyo9cyHOJGTxbUQwctT3g9pNJByOf0K7k+N4Jfa7R4U
 TnNuSSIjhY3M5y2Cd+pE7akPSo7u9oRNEiwbRZg3kS59GaZVQCCzcw9A0w0sQjg7hJT7F6DrN
 7WHFJGGSXTDhnqkpwLLfzg4bdehL2r4rUN61xmnifuq0GzdLqiV/mTucoaUFXpvaXkarM1kvH
 PXTbFhzsVK8YO4Nbx3TcifN1Wv/f95j6Fcc1V9iNMQbGxZZ/Kmr+VcacyTJ6uK///k6PJSa5r
 6udijW033Ntc9RjBOgJwQzMXndp9FtYrRx6ID5KSzLbon3K5l64RUK9ZuTwPAtr3eJmpghSiw
 bdO3YIiFNqklJoSwf6HuLPY67gYQJYfdnQtoVAoy79mwhPLyBtbXoNic/ICj8tv0wxjORRpHV
 k2L3c12zEhQYo3T2j+TtyGGzyHw0gKk1GO0txkS01nyrmUH9liqqhplSN2dBTul+280nwyrDd
 CnjCE/iaRtKodvNswDp+Cm59tyGYQ1YUraeAgBi64giLKIngZLxrxqDJeFtB10TfmWJh5vTvj
 Z+jkPJUkx6RQwM5ABGSzoJXH+VCrxpvaYx+1ukhe6a1ocjZVZ64oNGmiwVT50G/N62uQqrILN
 0gQ8IjrDzkkhcSlQTtA13Ot28Ij6ptU5ID0TA3eg336hQFoevTbQF+IM2s/8Tz6hs9i6ByOuK
 lQg67WHcWTycJ1PBTfDkwJis4osh8bkRAIuSekP9DyFa0JgLxSFiMwYw71x+hWnUOVKL54uqd
 jnF8z5Yfp13dnERAiUKiIyuR7eJ58hGCvtF0M61E4BpYh9kSyD6W7XfAVl0WmcKfYTWwtLVQ7
 mVXi3v8OUtczsCkLCmE8HjGwVuuaepVm9KCYYde0i8EFhFsMkkjFIfXvDDA2g5KWYtvE69SgA
 lReoUDAC/jsw2M=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dexuan,

On Sat, Sep 18, 2021 at 05:06:16PM +0000, Dexuan Cui wrote:
> > From: Len Baker <len.baker@gmx.com>
> > Sent: Saturday, September 18, 2021 6:20 AM
> >  ...
> > I have received a email from the linux-media subsystem telling that th=
is
> > patch is not applicable. The email is the following:
> >
> > Regards,
> > Len
>
> The patch is already in the net-next tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/comm=
it/?id=3Df11ee2ad25b22c2ee587045dd6999434375532f7

Thanks for the info.

Regards,
Len
