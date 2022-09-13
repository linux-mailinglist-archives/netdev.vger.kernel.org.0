Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F715B6996
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiIMIbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiIMIb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:31:29 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B4C3340A
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:31:26 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-12803ac8113so30140132fac.8
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=eS0keHrwLMEGvIjO+pY5ygqjHB/SPNncDJUPziHs85o=;
        b=eIFW7eRfPGy5TSSbF8w75Av3OVeC6Go3WJYZ9yZ9cMRMed1DrlbWdVx+NAS/W8rkdn
         uhJCroUNgmjz6x+drtcGIEfSLsA17rgtdJRaCZmch87rp4coLI2nGVD2Lvqo0kZTF1Y3
         Oc9UXefLqEnB5kcb+S+xMgI/OvtdjcmTC7VA8BTYQLECIij4gobDNlx573aRu/NkzPSQ
         dgxmukm5eF7190OS+gbcoOp7o+1otfIujaaIP/f415U+5X3YYpyZ3H0s8gyLip1AL+5c
         q0caD106ZuqSUIRjUmkR4pu/IVIXQmQbXt7sEEaoA9RVO/MEXsx6bwtnVDTo52Kc6n3Q
         hYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=eS0keHrwLMEGvIjO+pY5ygqjHB/SPNncDJUPziHs85o=;
        b=V+SIrkhPzL1yumI3crQoMxV4ur/OYy84qrlQ9SAuZXng/6DXervRuLwAvr7u//LnmN
         E9gSc7ogMD114KQSjaVmzigsMM9WDMrTKr4b+roV8ZmetSMHbnNgacTmrXbbTQZ1zckw
         6BkEgSa4GHLw0boyvlHJT1pZ6r6/yD/anHYYPrs0TG97g5pCqGwaZGNsrw96dTmOqhnA
         VCBBD17xa61qK+2UOFy2Qgkvy/j8avfHBg5griBDq92tj9onpu6XLjpah6p/4RM/oNgO
         9raKSgUQdNLsYHtw2U2rvyhM5RDWWETRgga2uyNiGJOKqiPPI3hHlcBUpd9bKOQYBIfc
         EHrA==
X-Gm-Message-State: ACgBeo1krWV1GuT11PT2M5Jupw8xaBXFIaxM1AbDZywLmslYbpK1NE/I
        TE0L9RWaG3p8I5jEP3iCKX7TY9HMtSrXhfg4v0BKc9Sk8b0=
X-Google-Smtp-Source: AA6agR4tHCyOH1HiHm2Z5zwcPpz6epQRwbVeI95Cd/JV4FC3Tnr8Fnw4sK88ZsEaNM2pD6jWKwkFdgZSSMkEMnJKoto=
X-Received: by 2002:a05:6808:1b22:b0:34f:7879:53cc with SMTP id
 bx34-20020a0568081b2200b0034f787953ccmr1005686oib.144.1663057885965; Tue, 13
 Sep 2022 01:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk> <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk> <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
In-Reply-To: <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 13 Sep 2022 10:31:14 +0200
Message-ID: <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, paulmck@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
<sergio.paracuellos@gmail.com> wrote:
>
> Hi Lorenzo,
>
> On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kernel.org> wr=
ote:
> >
> > > Hi Lorenzo,
> > >
> > > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > > Ethernet for MT7621 SoCs no longer works after changes introduc=
ed to
> > > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. =
Packets are
> > > > > > sent out from the interface fine but won't be received on the i=
nterface.
> > > > > >
> > > > > > Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1=
001 PHY
> > > > > > connected to gmac1 of the SoC.
> > > > > >
> > > > > > Last working kernel is 5.19. The issue is present on 6.0-rc5.
> > > > > >
> > > > > > Ar=C4=B1n=C3=A7
> > > > >
> > > > > Hi Ar=C4=B1n=C3=A7,
> > > > >
> > > > > thx for testing and reporting the issue. Can you please identify
> > > > > the offending commit running git bisect?
> > > > >
> > > > > Regards,
> > > > > Lorenzo
> > > >
> > > > Hi Ar=C4=B1n=C3=A7,
> > > >
> > > > just a small update. I tested a mt7621 based board (Buffalo WSR-116=
6DHP) with
> > > > OpenWrt master + my mtk_eth_soc series and it works fine. Can you p=
lease
> > > > provide more details about your development board/environment?
> > >
> > > I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's gnubee=
-tools
> > > which makes an image with filesystem and any Linux kernel of choice w=
ith
> > > slight modifications (maybe not at all) on the kernel.
> > >
> > > https://github.com/neilbrown/gnubee-tools
> > >
> > > Sergio experiences the same problem on GB-PC1.
> >
> > ack, can you please run git bisect in order to identify the offending c=
ommit?
> > What is the latest kernel version that is working properly? 5.19.8?
>
> I'll try to get time today to properly bisect and identify the
> offending commit. I get a working platform with 5.19.8, yes but with
> v6-rc-1 my network is totally broken.

+ [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]

Ok, so I have bisected the issue to:
1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more patient
for RCU Tasks boot-time testing

This is the complete bisect log:

$ git bisect log
git bisect start
# good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
# bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
# good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
# bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
# bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
'ata-5.20-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
# good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
'regmap-v5.20' of
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
# good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
# bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'docs-6.0'
of git://git.lwn.net/linux
git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
# good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-=
2.6
git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
# bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
'ctxt.2022.07.05a' into HEAD
git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
# bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Use
delayed_work to delay rcu_tasks_verify_self_tests()
git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
# good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: Make RCU
Tasks Trace stall warning handle idle offline tasks
git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
# good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: Pull in
tasks blocked within RCU Tasks Trace readers
git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
# good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
Eliminate RCU Tasks Trace IPIs to online CPUs
git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
# good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: Update commen=
ts
git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
# bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more
patient for RCU Tasks boot-time testing
git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
# first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
rcu-tasks: Be more patient for RCU Tasks boot-time testing

I don't really understand the relationship with my broken network
issue. I am using debian buster and the effect I see is that when the
network interface becomes up it hangs waiting for a "task running to
raise network interfaces". After about one minute the system boots,
the login prompt is shown but I cannot configure at all network
interfaces: dhclient does not respond and manually ifconfig does not
help also:

root@gnubee:~#
root@gnubee:~# dhclient ethblack
^C
root@gnubee:~# ifconfig ethblack 192.168.1.101
root@gnubee:~# ping 19^C
root@gnubee:~# ping 192.168.1.47
PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
^C
--- 192.168.1.47 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 120ms

I have tried to revert the bad commit directly in v6.0-rc1 but
conflicts appeared with the git revert command in
'kernel/rcu/tasks.h', so I am not sure what I can do now.

Thanks,
    Sergio Paracuellos

>
> Thanks,
>     Sergio Paracuellos
>
> >
> > Regards,
> > Lorenzo
> >
> > >
> > > Ar=C4=B1n=C3=A7
