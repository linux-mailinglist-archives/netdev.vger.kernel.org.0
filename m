Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DF95B6D9B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiIMMuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiIMMuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:50:40 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F039C20193
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 05:50:38 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v2-20020a056830090200b006397457afecso7972567ott.13
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 05:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=Ubn2a/648uUI8Z8V4YjofPq/oSPM/FwQGObvjENdGE8=;
        b=QRxZHLDaemKLsuTEAYKcZDNQUoEEg+oCC5bDJ481BiT2Qq9ZBOo7i+Wz1RGerE8cfB
         iGgVCq61iUCymLKNzfYcM+gBwHN37b+pP62tSOfrdWT0jkgbngv+OGpP1THohQiRs1oM
         LhQYcI+aKyFqDNvoWWWEIkfh0QIQi87NFryqFJuzMjzkcbibkllkPi9RROGzuj9BoWkA
         Es/bsV/X9zHzBIH7neXAznpo9Uge2+SKcQOTA3NpKcMo9qNe9Y9Vzr6SCm26CGtthmHK
         71upW4JDubGyz6w3cFeMAra3zfHI9A5K0ivw657SYAEIsz7+8RLTugCWFrN25xY+zsA2
         cPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ubn2a/648uUI8Z8V4YjofPq/oSPM/FwQGObvjENdGE8=;
        b=u4hUUs9MYwxC6HjGy0ec9ARhd8ISrGFyrmxC3+xYocOE/G0MJ6zf8BFuVN+1gBAwZk
         /z1fmURL4YD+lv110raE7VkhVhILBtqqaMpuJWY78vt2v7/2XucxCgsm40pYiTOUgFCI
         HJaDu5UVhrPtHAm+RDG9tG7Nm98w/u/vX/tpBKEvB6mZiACTJFmyXihqi4JLle/Sui+B
         uy4yIMfrSXp/e5ZRE7eLy4Eggh8D4lz8D8f/mPNtbc7i74TLlVQ8i5QwR4nCjiQAacxO
         0lWS1jMsqnsMC6UkaB0v41rMOp4LOEQoBYIPsHqS+fjDPOpui6W+7MXxIr94hA0lvJpY
         TtbA==
X-Gm-Message-State: ACgBeo2S+Q1kTBsHBV8DTFOBryblcqlLbSDfgqgHTULFhF6DMpme9eSv
        7GVTBf1HVleKnem2Avz8JSt0Xf2dI31w1QMkEJHQZPpcqe4=
X-Google-Smtp-Source: AA6agR71kGo4iSYvC/ycAeXLW64jYN+d0Xm+9U0LYyLHfXtEQtQy3D4ZwOpyj39H3IxcRNcIdc2l9skEl8TsSAU5f4A=
X-Received: by 2002:a05:6830:150e:b0:655:bc7d:1e5d with SMTP id
 k14-20020a056830150e00b00655bc7d1e5dmr6897502otp.272.1663073438247; Tue, 13
 Sep 2022 05:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk>
 <170d725f-2146-f1fa-e570-4112972729df@arinc9.com> <Yx+W9EoEfoRsq1rt@lore-desk>
 <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
 <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
 <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com> <YyBibTHeSxwa31Cm@lore-desk>
 <CAMhs-H_oe-pCBBTDQT_uzyEYUoSvJB=DveZpyUUmdB2Sz--Hww@mail.gmail.com>
 <693820e5-5e8c-fc36-5e5e-f7ca3bdcce72@arinc9.com> <YyB2L8dfnJfnrqWI@lore-desk>
In-Reply-To: <YyB2L8dfnJfnrqWI@lore-desk>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 13 Sep 2022 14:50:26 +0200
Message-ID: <CAMhs-H_K8j55o=Ky=vCokHUsbTz6ZU_fc3RLue-neY1ox8ncsA@mail.gmail.com>
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

On Tue, Sep 13, 2022 at 2:23 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote=
:
>
> > On 13.09.2022 14:07, Sergio Paracuellos wrote:
> > > Hi Lorenzo,
> > >
> > > On Tue, Sep 13, 2022 at 12:58 PM Lorenzo Bianconi <lorenzo@kernel.org=
> wrote:
> > > >
> > > > > On 13.09.2022 11:31, Sergio Paracuellos wrote:
> > > > > > Hi Lorenzo,
> > > > > >
> > > > > > On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
> > > > > > <sergio.paracuellos@gmail.com> wrote:
> > > > > > >
> > > > > > > Hi Lorenzo,
> > > > > > >
> > > > > > > On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@ke=
rnel.org> wrote:
> > > > > > > >
> > > > > > > > > Hi Lorenzo,
> > > > > > > > >
> > > > > > > > > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > > > > > > > > Ethernet for MT7621 SoCs no longer works after chan=
ges introduced to
> > > > > > > > > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initi=
alise fine. Packets are
> > > > > > > > > > > > sent out from the interface fine but won't be recei=
ved on the interface.
> > > > > > > > > > > >
> > > > > > > > > > > > Tested with MT7530 DSA switch connected to gmac0 an=
d ICPlus IP1001 PHY
> > > > > > > > > > > > connected to gmac1 of the SoC.
> > > > > > > > > > > >
> > > > > > > > > > > > Last working kernel is 5.19. The issue is present o=
n 6.0-rc5.
> > > > > > > > > > > >
> > > > > > > > > > > > Ar=C4=B1n=C3=A7
> > > > > > > > > > >
> > > > > > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > > > > > >
> > > > > > > > > > > thx for testing and reporting the issue. Can you plea=
se identify
> > > > > > > > > > > the offending commit running git bisect?
> > > > > > > > > > >
> > > > > > > > > > > Regards,
> > > > > > > > > > > Lorenzo
> > > > > > > > > >
> > > > > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > > > > >
> > > > > > > > > > just a small update. I tested a mt7621 based board (Buf=
falo WSR-1166DHP) with
> > > > > > > > > > OpenWrt master + my mtk_eth_soc series and it works fin=
e. Can you please
> > > > > > > > > > provide more details about your development board/envir=
onment?
> > > > > > > > >
> > > > > > > > > I've got a GB-PC2, Sergio has got a GB-PC1. We both use N=
eil's gnubee-tools
> > > > > > > > > which makes an image with filesystem and any Linux kernel=
 of choice with
> > > > > > > > > slight modifications (maybe not at all) on the kernel.
> > > > > > > > >
> > > > > > > > > https://github.com/neilbrown/gnubee-tools
> > > > > > > > >
> > > > > > > > > Sergio experiences the same problem on GB-PC1.
> > > > > > > >
> > > > > > > > ack, can you please run git bisect in order to identify the=
 offending commit?
> > > > > > > > What is the latest kernel version that is working properly?=
 5.19.8?
> > > > > > >
> > > > > > > I'll try to get time today to properly bisect and identify th=
e
> > > > > > > offending commit. I get a working platform with 5.19.8, yes b=
ut with
> > > > > > > v6-rc-1 my network is totally broken.
> > > > > >
> > > > > > + [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]
> > > > > >
> > > > > > Ok, so I have bisected the issue to:
> > > > > > 1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more pa=
tient
> > > > > > for RCU Tasks boot-time testing
> > > > > >
> > > > > > This is the complete bisect log:
> > > > > >
> > > > > > $ git bisect log
> > > > > > git bisect start
> > > > > > # good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
> > > > > > git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
> > > > > > # bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
> > > > > > git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> > > > > > # good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
> > > > > > git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
> > > > > > # bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
> > > > > > 'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
> > > > > > git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
> > > > > > # bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
> > > > > > 'ata-5.20-rc1' of
> > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
> > > > > > git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
> > > > > > # good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
> > > > > > 'regmap-v5.20' of
> > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> > > > > > git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
> > > > > > # good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
> > > > > > 'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
> > > > > > git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
> > > > > > # bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'do=
cs-6.0'
> > > > > > of git://git.lwn.net/linux
> > > > > > git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
> > > > > > # good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
> > > > > > 'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/her=
bert/crypto-2.6
> > > > > > git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
> > > > > > # bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
> > > > > > 'ctxt.2022.07.05a' into HEAD
> > > > > > git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
> > > > > > # bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Us=
e
> > > > > > delayed_work to delay rcu_tasks_verify_self_tests()
> > > > > > git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
> > > > > > # good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: M=
ake RCU
> > > > > > Tasks Trace stall warning handle idle offline tasks
> > > > > > git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
> > > > > > # good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: P=
ull in
> > > > > > tasks blocked within RCU Tasks Trace readers
> > > > > > git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
> > > > > > # good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
> > > > > > Eliminate RCU Tasks Trace IPIs to online CPUs
> > > > > > git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
> > > > > > # good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: U=
pdate comments
> > > > > > git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
> > > > > > # bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be=
 more
> > > > > > patient for RCU Tasks boot-time testing
> > > > > > git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
> > > > > > # first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
> > > > > > rcu-tasks: Be more patient for RCU Tasks boot-time testing
> > > > > >
> > > > > > I don't really understand the relationship with my broken netwo=
rk
> > > > > > issue. I am using debian buster and the effect I see is that wh=
en the
> > > > > > network interface becomes up it hangs waiting for a "task runni=
ng to
> > > > > > raise network interfaces". After about one minute the system bo=
ots,
> > > > > > the login prompt is shown but I cannot configure at all network
> > > > > > interfaces: dhclient does not respond and manually ifconfig doe=
s not
> > > > > > help also:
> > > > > >
> > > > > > root@gnubee:~#
> > > > > > root@gnubee:~# dhclient ethblack
> > > > > > ^C
> > > > > > root@gnubee:~# ifconfig ethblack 192.168.1.101
> > > > > > root@gnubee:~# ping 19^C
> > > > > > root@gnubee:~# ping 192.168.1.47
> > > > > > PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
> > > > > > ^C
> > > > > > --- 192.168.1.47 ping statistics ---
> > > > > > 3 packets transmitted, 0 received, 100% packet loss, time 120ms
> > > > > >
> > > > > > I have tried to revert the bad commit directly in v6.0-rc1 but
> > > > > > conflicts appeared with the git revert command in
> > > > > > 'kernel/rcu/tasks.h', so I am not sure what I can do now.
> > > > >
> > > > > I've pinpointed the issue to 23233e577ef973c2c5d0dd757a0a4605e34e=
cb57 ("net:
> > > > > ethernet: mtk_eth_soc: rely on page_pool for single page buffers"=
). Ethernet
> > > > > works fine after reverting this and newer commits for mtk_eth_soc=
.
> > > >
> > > > Hi Ar=C4=B1n=C3=A7,
> > > >
> > > > yes, I run some bisect here as well and this seems the offending co=
mmit. Can
> > > > you please try the patch below?
> > > >
> > > > Regards,
> > > > Lorenzo
> > > >
> > > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/=
net/ethernet/mediatek/mtk_eth_soc.c
> > > > index ec617966c953..67a64a2272b9 100644
> > > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > > @@ -1470,7 +1470,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_=
eth *eth)
> > > >
> > > >   static bool mtk_page_pool_enabled(struct mtk_eth *eth)
> > > >   {
> > > > -       return !eth->hwlro;
> > > > +       return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
> > > >   }
> > > >
> > > >   static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth=
,
> > >
> > > I have applied this patch on the top of v6-0-rc5 and the network is
> > > back, so this patch seems to fix the network issue for my GNUBee pC1:
> > >
> > > Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
> >
> > Can confirm the same behaviour on my GB-PC2.
> >
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>
> I debugged a bit more the problem and the issue is due to a 2 bytes align=
ment
> introduced by mt7621 on packet data.
> Since mt7621 is a low-end SoC and I do not have other SoCs for testing, I=
 will
> enable xdp support just for MT7986 for the moment. Thanks a lot for repor=
ting the
> issue and for testing.
>

Thanks to you for such a quick fix. Feel free to send us whatever
patch you need to test on mt7621.

Best regards,
    Sergio Paracuellos

> Regards,
> Lorenzo
>
> >
> > Ar=C4=B1n=C3=A7
