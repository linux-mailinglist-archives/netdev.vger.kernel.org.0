Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9850EEC5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241802AbiDZCdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiDZCdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:33:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8735DC3;
        Mon, 25 Apr 2022 19:30:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 99F961F380;
        Tue, 26 Apr 2022 02:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650940205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX473lc685/tBD4BRCMRWuDdbRGCZDWIYx8mJX3hLck=;
        b=BsQO/6RREy3URhfML1m8e6NbTRaNKruo9eoDgIrO5VITB3Syz4+hCyxu7g17DW0cDPMhQ5
        n6VWYJEd/bgqhJvkZTWz64sQrpFqF1rUvbAjHqD8dLtJRGJSkcgCa2ca596rkG+6jkURyK
        WAnf4JBeEOFON7XG4m/EAsVXkJagdt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650940205;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX473lc685/tBD4BRCMRWuDdbRGCZDWIYx8mJX3hLck=;
        b=sFwOwESgQ/Geeyne4VZk2i+bfUE10gpYbhO5z185tVmKyy4H4kLsVwgfKhz2rNPYtUbYHc
        XkALn5kb06QGxrBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3CA9813A39;
        Tue, 26 Apr 2022 02:29:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GnchOiZZZ2JdFwAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 26 Apr 2022 02:29:58 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, "Netdev" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Trond Myklebust" <trond.myklebust@hammerspace.com>,
        linux-nfs@vger.kernel.org,
        "Anna Schumaker" <anna.schumaker@netapp.com>
Subject: Re: [PATCH 4.19 000/338] 4.19.238-rc1 review
In-reply-to: <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
References: <20220414110838.883074566@linuxfoundation.org>,
 <CA+G9fYvgzFW7sMZVdw5r970QNNg4OK8=pbQV0kDfbOX-rXu5Rw@mail.gmail.com>,
 <CA+G9fYscMP+DTzaQGw1p-KxyhPi0JB64ABDu_aNSU0r+_VgBHg@mail.gmail.com>
Date:   Tue, 26 Apr 2022 12:29:55 +1000
Message-id: <165094019509.1648.12340115187043043420@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022, Naresh Kamboju wrote:
> On Mon, 18 Apr 2022 at 14:09, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
> >
> > On Thu, 14 Apr 2022 at 18:45, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.238 release.
> > > There are 338 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 16 Apr 2022 11:07:54 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.238-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > Following kernel warning noticed on arm64 Juno-r2 while booting
> > stable-rc 4.19.238. Here is the full test log link [1].
> >
> > [    0.000000] Booting Linux on physical CPU 0x0000000100 [0x410fd033]
> > [    0.000000] Linux version 4.19.238 (tuxmake@tuxmake) (gcc version
> > 11.2.0 (Debian 11.2.0-18)) #1 SMP PREEMPT @1650206156
> > [    0.000000] Machine model: ARM Juno development board (r2)
> > <trim>
> > [   18.499895] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [   18.504172] WARNING: inconsistent lock state
> > [   18.508451] 4.19.238 #1 Not tainted
> > [   18.511944] --------------------------------
> > [   18.516222] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> > [   18.522242] kworker/u12:3/60 [HC0[0]:SC0[0]:HE1:SE1] takes:
> > [   18.527826] (____ptrval____)
> > (&(&xprt->transport_lock)->rlock){+.?.}, at: xprt_destroy+0x70/0xe0
> > [   18.536648] {IN-SOFTIRQ-W} state was registered at:
> > [   18.541543]   lock_acquire+0xc8/0x23c

Prior to Linux 5.3, ->transport_lock needs spin_lock_bh() and=20
spin_unlock_bh().

Thanks,
NeilBrown
