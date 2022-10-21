Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3518607DE4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJURs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJURsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:48:24 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA46269091;
        Fri, 21 Oct 2022 10:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666374467;
        bh=5QbrjKqljxqksy5puufmiF+jXfgBlAoOUGXFjbxtpbQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hBhbJF4jc8rovTo6jtdQzC4jf96E2Y2BZGDCj8OOv7uVvPAtWDWe+3+lPpVpqHrev
         hY9tNEpZhA+/wv2jZa3PpEH8ZQJdqKYbhdWH0+HSxxEf75JFo5UvX6IwA2NDbo8QAI
         GemWHbXMEq5LAqIIq8xXe6n/MtZ3Pq7ekSGRAHN8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.146.132] ([217.61.146.132]) by web-mail.gmx.net
 (3c-app-gmx-bap55.server.lan [172.19.172.125]) (via HTTP); Fri, 21 Oct 2022
 19:47:47 +0200
MIME-Version: 1.0
Message-ID: <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 21 Oct 2022 19:47:47 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
References: <20221020144431.126124-1-linux@fw-web.de>
 <Y1F0pSrJnNlYzehq@shell.armlinux.org.uk>
 <02A54E45-2084-440A-A643-772C0CC9F988@public-files.de>
 <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:GDNCzu2w9Sb5SdqBgz4X6STf3+fSzJrSEUCB66OPIVCQTyPLjBmzWXa+MHHuTXv8u2sXQ
 wv0U9DyOfKYtSk5dkjolBQH+zi0xwerN7oZZ1mnTi1VgLvzFy6d5w3gGB1lefJlC0ngncQP9cR+f
 faqLtGrwoWJB/rtIX77qXr05Ge0JgMY88wOBBCzUJHWt+pOhMnQXP965uB27Tu61/CCNRb+tV2fb
 JQgslHLsGwhJZvKoEXtXLFRK3sVmSuTrXKhFXXWS4nYmJM8Uy0OKCikiIkBatnm8+kS2OrRRXYHW
 vo=
X-UI-Out-Filterresults: notjunk:1;V03:K0:TD+n0rJeT4w=:XljR1f4x6ydGS0+XhQ/B3s
 4iL/C3Ttc33hzqTmSeQBqBxxQygsToOCMuS6YO/U2W99Eek1iEGBKaaSRuITP/8Z2piCd2kLw
 h0FSeCTwNO9viA0yBcnj74cyEYEh/7Y/nIShtgHOGADsCYg3AzZmE5CBJ7vRtsaQYX4WtrdxH
 0t/VaEWSHVeSXHV+WiHwZNBJE4bgUOgXDZOX4u8fPxcNgtfcqYvuqNkCIto0u5hOukEtdX9Lq
 4Wm/op2idY2BjsDhNkIQoa5KGUX6gz4M+ZoyJ0Fmu0w4aEJAe4/LvH/VH5UDva4tIH5ugxHkB
 ixtyU/Sksric7WCLFoZHdsPU1Yt7NJJxcl+EtQdnOsd6e04XHwEytM9UfQi0OaeCvvXcmPsi5
 LB2t3QsdRpWyOfbXYhB9r8Zx4iRn3A6E3ktm0yDor2k8lek/gD34QW6BA/0/4ZEXz8GezbIYV
 gp6ZsHzuYBZK1AYou9WipXwKM2vTc9cktZ0cnA9hMXSdH+Q4imggKUhI2+aDKirSfjLJS35gY
 XRP09F4y7pOX/pXCYrRK/104+mP9ImyPYq/zhZGcPQTCFsFtZZFVq7KTVqcRVkeIko8hclYvu
 6MIDhe/CBAcWSVsa9b0DkhHtetX911dwD7hSgsU+YDXhEdfBrt2IfsH5TJLtPmcevZ7v95RPC
 +20bj4sOrn/uFeJzCK6seCPiNq56e7gOflBqi+WQP8IHmW4XcDDPg3MJRsQ3zRtmLhrGG5uIM
 TFVjedpHshrzrVZi9imF4GC0sd5HfaRSrJlPC0YRjqygTmt/IjKIJS66/D5POW9dplPCI32OG
 Kt5Dk+IQZZi4GN7n+LNVOxUVQU9iB8kLLiC5qbh8Q/TmHpBZYxO9TuSSEvlBSuPGkXATm0AdT
 OlRfs4IuzT3gCW5Gv5lcZEyuvT2483fACpBHgwBZeq2Cyi00asOoG2lhrFGG9k4G3g3VhB96X
 g77inuxSwS2Ti1wsbrm0CZ4OmQYYgH1WUoxu8emEAdRLKIbOMWAfKZ5naC2fl6pCd6bmYQQDP
 ttRxfHmFn6cVBmWjPtzibuf7AAaGej0eeZ0cUKrls8mkQ7jWkv/djJ15KPxfgg/BExN40725/
 MzOSoxkZIMtz+17lo7EeR0TB/fB3XuByH0n4bKl+8eDNTKnzC86u5qEwYDvdNY+ox0SaTfkD5
 T1k5UztsrsfmfJtPd6/2+/yBLlj7Z/kfY3HRQuRa2jMXbi4+xRSFJrJbnBvYbUDDJnr2vRlKq
 01u1v22a4Mylfincmx3D1WLW8XFsmFsmsGY69vdp8ff9YQuxmoctq93XehSN3dJIq2rLgFCO4
 JZHHdhaO
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Freitag, 21. Oktober 2022 um 11:06 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> On Fri, Oct 21, 2022 at 08:04:51AM +0200, Frank Wunderlich wrote:
> > I have no register documentation to check if there is any way to read =
out pause/duplex setting. Maybe MTK can answer this or extend function lat=
er.
>
> I suspect we can probably guess.
>
> Looking at SGMSYS_PCS_CONTROL_1, this is actually the standard BMCR in
> the low 16 bits, and BMSR in the upper 16 bits, so:
>
> At address 4, I'd expect the PHYSID.
> At address 8, I'd expect the advertisement register in the low 16 bits
> and the link partner advertisement in the upper 16 bits.
>
> Can you try an experiment, and in mtk_sgmii_init() try accessing the
> regmap at address 0, 4, and 8 and print their contents please?

is this what you want to see?

 int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_r=
gc3)
 {
        struct device_node *np;
+       unsigned int val;
        int i;

        for (i =3D 0; i < MTK_MAX_DEVS; i++) {
@@ -158,6 +159,12 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct devic=
e_node *r, u32 ana_rgc3)
                if (IS_ERR(ss->pcs[i].regmap))
                        return PTR_ERR(ss->pcs[i].regmap);

+               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1, &val)=
;
+               printk(KERN_ALERT "dev: %d offset:0 0x%x",i,val);
+               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1+4, &va=
l);
+               printk(KERN_ALERT "dev: %d offset:4 0x%x",i,val);
+               regmap_read(ss->pcs[i].regmap, SGMSYS_PCS_CONTROL_1+8, &va=
l);
+               printk(KERN_ALERT "dev: %d offset:8 0x%x",i,val);
                ss->pcs[i].pcs.ops =3D &mtk_pcs_ops;
        }


[    1.083359] dev: 0 offset:0 0x840140
[    1.083376] dev: 0 offset:4 0x4d544950
[    1.086955] dev: 0 offset:8 0x1
[    1.090697] dev: 1 offset:0 0x81140
[    1.093866] dev: 1 offset:4 0x4d544950
[    1.097342] dev: 1 offset:8 0x1

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
>

regards Frank
