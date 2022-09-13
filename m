Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870B35B6C37
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiIMLIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 07:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIMLH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 07:07:56 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E63447B80
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 04:07:54 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-11eab59db71so31049307fac.11
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 04:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=a82qp2mmjCtNW5iMvKXvaAFhcYry+wa05ygFC8u+v68=;
        b=EnnjMPI59M5551tYLJHV+NhyLa9LYOdYHCmbAxvkUcLVgce0gtYDAfZOQ4o8AVeG7w
         J2RIYsG5zHNfd3bUbW56a4NVsPe4AqFDOsv4kEiYlW3sp/J4lnlL8qhjbA6ORkmnz9KX
         WUqAaZj7eQ7kFUeogs2I2v6BCgTxh13v3a2KiL5dn/jmp3GWZRgmfGZX+DHbvUqVL5Ap
         j1ZyQw+HiPCdAKy5w2QbEDHD8bD2Ve0FYMenTCEkKyteZhcd8Pv+VNfVmX84lg07KVDP
         CnmeOiJhJIJGpZefVJ48Z+dymk0eHqXgSYyWNMwS7t4bBA5poZgub9d87C/HfUU1E7eK
         ylGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=a82qp2mmjCtNW5iMvKXvaAFhcYry+wa05ygFC8u+v68=;
        b=UY7dshA1kC5S641mjZoXFo4+e3xuIdUIc7K7IF8nQXTLh3uxquFFfaiwSEeZIo7jyG
         eVm7b1An9rL6PUhi2peri7DGZwnFP/ViDmvkps1FiqN3ZXlDMZnDQvVt7z23eHzxU5ek
         vJGN+DCF4j4MD/9tOle15SasNzX8Mt8v8cZlI3ZqoSg2WIpxdUNBfSPTP3u40IBAwhQ6
         16WRyzuOJ0nmwW+S6DPKamI7IdKAKzte0iL6sJzscJsabVXw9RjQufNXzJcChPNjYHfa
         If3nfF2qP45bdL4FFdQsplc52LlAfgMsirL9AUeZXxwtK9MH+K+biPekz/T3WtfvubFj
         +sMw==
X-Gm-Message-State: ACgBeo2wzWR7BTnfHOlMqosBa+Zr7fMyfPkqKuOFekK6VgX0Zj9UuYOC
        Pif/WzxU+5edw4/dwTsLjKIh/44NhF7RJvLtClfr/DXt+ew=
X-Google-Smtp-Source: AA6agR4gmjixrcx6W0MXs44r15Pr17nu7J+mJzkfBGQM0Ru6q5sgrPwWMpGqeAY93ARWC4ZkF98rf5DFjXzcpGiBB9k=
X-Received: by 2002:a05:6870:c0c8:b0:101:b3c3:abc3 with SMTP id
 e8-20020a056870c0c800b00101b3c3abc3mr1468733oad.144.1663067273583; Tue, 13
 Sep 2022 04:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk> <Yx9z9Dm4vJFxGaJI@lore-desk> <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
 <Yx+W9EoEfoRsq1rt@lore-desk> <CAMhs-H8wWNrqb0RgQdcL4J+=oGws8pB8Uv_H=6Q8AyzXDgF89Q@mail.gmail.com>
 <CAMhs-H8Wsin67gTLPfv9x=hHM-prz4YYensNtyc=hZx+s4d=9Q@mail.gmail.com>
 <10e9ead9-5adc-5065-0c13-702aabd5dcb0@arinc9.com> <YyBibTHeSxwa31Cm@lore-desk>
In-Reply-To: <YyBibTHeSxwa31Cm@lore-desk>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Tue, 13 Sep 2022 13:07:42 +0200
Message-ID: <CAMhs-H_oe-pCBBTDQT_uzyEYUoSvJB=DveZpyUUmdB2Sz--Hww@mail.gmail.com>
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

On Tue, Sep 13, 2022 at 12:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
>
> > On 13.09.2022 11:31, Sergio Paracuellos wrote:
> > > Hi Lorenzo,
> > >
> > > On Tue, Sep 13, 2022 at 5:32 AM Sergio Paracuellos
> > > <sergio.paracuellos@gmail.com> wrote:
> > > >
> > > > Hi Lorenzo,
> > > >
> > > > On Mon, Sep 12, 2022 at 10:30 PM Lorenzo Bianconi <lorenzo@kernel.o=
rg> wrote:
> > > > >
> > > > > > Hi Lorenzo,
> > > > > >
> > > > > > On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > > > > > > Ethernet for MT7621 SoCs no longer works after changes in=
troduced to
> > > > > > > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise =
fine. Packets are
> > > > > > > > > sent out from the interface fine but won't be received on=
 the interface.
> > > > > > > > >
> > > > > > > > > Tested with MT7530 DSA switch connected to gmac0 and ICPl=
us IP1001 PHY
> > > > > > > > > connected to gmac1 of the SoC.
> > > > > > > > >
> > > > > > > > > Last working kernel is 5.19. The issue is present on 6.0-=
rc5.
> > > > > > > > >
> > > > > > > > > Ar=C4=B1n=C3=A7
> > > > > > > >
> > > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > > >
> > > > > > > > thx for testing and reporting the issue. Can you please ide=
ntify
> > > > > > > > the offending commit running git bisect?
> > > > > > > >
> > > > > > > > Regards,
> > > > > > > > Lorenzo
> > > > > > >
> > > > > > > Hi Ar=C4=B1n=C3=A7,
> > > > > > >
> > > > > > > just a small update. I tested a mt7621 based board (Buffalo W=
SR-1166DHP) with
> > > > > > > OpenWrt master + my mtk_eth_soc series and it works fine. Can=
 you please
> > > > > > > provide more details about your development board/environment=
?
> > > > > >
> > > > > > I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's =
gnubee-tools
> > > > > > which makes an image with filesystem and any Linux kernel of ch=
oice with
> > > > > > slight modifications (maybe not at all) on the kernel.
> > > > > >
> > > > > > https://github.com/neilbrown/gnubee-tools
> > > > > >
> > > > > > Sergio experiences the same problem on GB-PC1.
> > > > >
> > > > > ack, can you please run git bisect in order to identify the offen=
ding commit?
> > > > > What is the latest kernel version that is working properly? 5.19.=
8?
> > > >
> > > > I'll try to get time today to properly bisect and identify the
> > > > offending commit. I get a working platform with 5.19.8, yes but wit=
h
> > > > v6-rc-1 my network is totally broken.
> > >
> > > + [cc: Paul E. McKenney <paulmck@kernel.org> as commit author]
> > >
> > > Ok, so I have bisected the issue to:
> > > 1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more patient
> > > for RCU Tasks boot-time testing
> > >
> > > This is the complete bisect log:
> > >
> > > $ git bisect log
> > > git bisect start
> > > # good: [70cb6afe0e2ff1b7854d840978b1849bffb3ed21] Linux 5.19.8
> > > git bisect good 70cb6afe0e2ff1b7854d840978b1849bffb3ed21
> > > # bad: [568035b01cfb107af8d2e4bd2fb9aea22cf5b868] Linux 6.0-rc1
> > > git bisect bad 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> > > # good: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
> > > git bisect good 3d7cb6b04c3f3115719235cc6866b10326de34cd
> > > # bad: [b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1] Merge tag
> > > 'drm-next-2022-08-03' of git://anongit.freedesktop.org/drm/drm
> > > git bisect bad b44f2fd87919b5ae6e1756d4c7ba2cbba22238e1
> > > # bad: [526942b8134cc34d25d27f95dfff98b8ce2f6fcd] Merge tag
> > > 'ata-5.20-rc1' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
> > > git bisect bad 526942b8134cc34d25d27f95dfff98b8ce2f6fcd
> > > # good: [2e7a95156d64667a8ded606829d57c6fc92e41df] Merge tag
> > > 'regmap-v5.20' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
> > > git bisect good 2e7a95156d64667a8ded606829d57c6fc92e41df
> > > # good: [c013d0af81f60cc7dbe357c4e2a925fb6738dbfe] Merge tag
> > > 'for-5.20/block-2022-07-29' of git://git.kernel.dk/linux-block
> > > git bisect good c013d0af81f60cc7dbe357c4e2a925fb6738dbfe
> > > # bad: [aad26f55f47a33d6de3df65f0b18e2886059ed6d] Merge tag 'docs-6.0=
'
> > > of git://git.lwn.net/linux
> > > git bisect bad aad26f55f47a33d6de3df65f0b18e2886059ed6d
> > > # good: [c2a24a7a036b3bd3a2e6c66730dfc777cae6540a] Merge tag
> > > 'v5.20-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/c=
rypto-2.6
> > > git bisect good c2a24a7a036b3bd3a2e6c66730dfc777cae6540a
> > > # bad: [34bc7b454dc31f75a0be7ee8ab378135523d7c51] Merge branch
> > > 'ctxt.2022.07.05a' into HEAD
> > > git bisect bad 34bc7b454dc31f75a0be7ee8ab378135523d7c51
> > > # bad: [e72ee5e1a866b85cb6c3d4c80a1125976020a7e8] rcu-tasks: Use
> > > delayed_work to delay rcu_tasks_verify_self_tests()
> > > git bisect bad e72ee5e1a866b85cb6c3d4c80a1125976020a7e8
> > > # good: [f90f19da88bfe32dd1fdfd104de4c0526a3be701] rcu-tasks: Make RC=
U
> > > Tasks Trace stall warning handle idle offline tasks
> > > git bisect good f90f19da88bfe32dd1fdfd104de4c0526a3be701
> > > # good: [dc7d54b45170e1e3ced9f86718aa4274fd727790] rcu-tasks: Pull in
> > > tasks blocked within RCU Tasks Trace readers
> > > git bisect good dc7d54b45170e1e3ced9f86718aa4274fd727790
> > > # good: [e386b6725798eec07facedf4d4bb710c079fd25c] rcu-tasks:
> > > Eliminate RCU Tasks Trace IPIs to online CPUs
> > > git bisect good e386b6725798eec07facedf4d4bb710c079fd25c
> > > # good: [eea3423b162d5d5cdc08af23e8ee2c2d1134fd07] rcu-tasks: Update =
comments
> > > git bisect good eea3423b162d5d5cdc08af23e8ee2c2d1134fd07
> > > # bad: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f] rcu-tasks: Be more
> > > patient for RCU Tasks boot-time testing
> > > git bisect bad 1cf1144e8473e8c3180ac8b91309e29b6acfd95f
> > > # first bad commit: [1cf1144e8473e8c3180ac8b91309e29b6acfd95f]
> > > rcu-tasks: Be more patient for RCU Tasks boot-time testing
> > >
> > > I don't really understand the relationship with my broken network
> > > issue. I am using debian buster and the effect I see is that when the
> > > network interface becomes up it hangs waiting for a "task running to
> > > raise network interfaces". After about one minute the system boots,
> > > the login prompt is shown but I cannot configure at all network
> > > interfaces: dhclient does not respond and manually ifconfig does not
> > > help also:
> > >
> > > root@gnubee:~#
> > > root@gnubee:~# dhclient ethblack
> > > ^C
> > > root@gnubee:~# ifconfig ethblack 192.168.1.101
> > > root@gnubee:~# ping 19^C
> > > root@gnubee:~# ping 192.168.1.47
> > > PING 192.168.1.47 (192.168.1.47) 56(84) bytes of data.
> > > ^C
> > > --- 192.168.1.47 ping statistics ---
> > > 3 packets transmitted, 0 received, 100% packet loss, time 120ms
> > >
> > > I have tried to revert the bad commit directly in v6.0-rc1 but
> > > conflicts appeared with the git revert command in
> > > 'kernel/rcu/tasks.h', so I am not sure what I can do now.
> >
> > I've pinpointed the issue to 23233e577ef973c2c5d0dd757a0a4605e34ecb57 (=
"net:
> > ethernet: mtk_eth_soc: rely on page_pool for single page buffers"). Eth=
ernet
> > works fine after reverting this and newer commits for mtk_eth_soc.
>
> Hi Ar=C4=B1n=C3=A7,
>
> yes, I run some bisect here as well and this seems the offending commit. =
Can
> you please try the patch below?
>
> Regards,
> Lorenzo
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.c
> index ec617966c953..67a64a2272b9 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1470,7 +1470,7 @@ static void mtk_update_rx_cpu_idx(struct mtk_eth *e=
th)
>
>  static bool mtk_page_pool_enabled(struct mtk_eth *eth)
>  {
> -       return !eth->hwlro;
> +       return MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2);
>  }
>
>  static struct page_pool *mtk_create_page_pool(struct mtk_eth *eth,

I have applied this patch on the top of v6-0-rc5 and the network is
back, so this patch seems to fix the network issue for my GNUBee pC1:

Tested-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
>
> >
> > Ar=C4=B1n=C3=A7
