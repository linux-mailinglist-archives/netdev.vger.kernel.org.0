Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020E56766C1
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 15:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAUOft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 09:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAUOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 09:35:48 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3824B21979;
        Sat, 21 Jan 2023 06:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1674311728;
        bh=4V28Gz5Ugct3USbMjHEv7PNQzjfdAFmkjsHE76lUssI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=W8e41qKmGYUFZf78K3M+TQB04Q8IoBo4UUovSynrvR6RDOWBcasFBBM89CfB1IA+p
         PP09eCcalDy7IG6Cudd3p04dIwlzMENPVbvH4wleYKT5ZN2+zMeNzxYHQHzN0HKdvT
         TgnxJ2Lc8lsWTsBvfmAIRDeb2ZT3+sMjr70Q6L715pmcM/bQIwVqA43SKx9IP2ceHS
         7EH2bd4+oSgaLHRp+3wBZj2PA5J1vRXPsFIwfx+ozFN+1fy9m5XygIEi7Rv8VR5tm/
         jCcIJDf87pHW/9zW+sqCpgiaV94cdpTh4nBnchF0HVWinVbZTUt+lLUri5oxQSbv+O
         8bFZ8SQhLSQLg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.152.198] ([217.61.152.198]) by web-mail.gmx.net
 (3c-app-gmx-bap60.server.lan [172.19.172.130]) (via HTTP); Sat, 21 Jan 2023
 15:35:28 +0100
MIME-Version: 1.0
Message-ID: <trinity-fd23c4a0-a979-475e-a077-330577d7d632-1674311727972@3c-app-gmx-bap60>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Aw: Re: [BUG] vlan-aware bridge breaks vlan on another port on same
 gmac
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 21 Jan 2023 15:35:28 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230121133549.vibz2infg5jwupdc@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:g0li+axzpVis+uzirmrAvrroCtduzzYxo3+jtQufx5O1L0QZ73vg5WZFReRvxrdWs3aCs
 9IkY2TTVo9c6k3uSkQ/8+IHB5NO4h4olMIY/p7LHHkmTKmGqJy4io+bHAUOrRb9RyGanCKQHmeuU
 Xl0huoyWVv4TgWGNy7ZchSSkQgOiaAybEFZbYwUBEyqzfxf+E6ISPgrNmLOnmCHC47IeAjcSNCoe
 UPrU5x3+CW8wYKhjKLOGPSL1URWV52xR2p/CCHyusOqCiLCDzGhxwSl4S0iB8Yk2ns64LJWg7KNy
 IA=
UI-OutboundReport: notjunk:1;M01:P0:8TBN3mYj3Qk=;JpZuon1vS0wKt2XiGySils9iO1y
 5enzztuoZKIr0nhGBkdHdRcmD+D2Fkax1WGNzwNVvbs7vVlyYnT3gnZ8xbygCRBfDO1l5NJ2k
 tLqkoSl5iH4jbkIqcIyrHPEpel2z/okOvrvFSiPmJfGHI9i6jeOI8Ow/Yd25liQcD/oOEWwjQ
 qJ7un59Dsbu2FuzKsl4UZrx0VukvU0tWhomZqIzCmLER8UN0SgxqD9p2ykcjaGs5z/scc51kt
 JF+Hof+vtVXZkbWQlAh/N3aB6XEh0fEA9tzOklCTVTu8r3Nbo2oceIZEKR7pr+eSnqC8oiiw9
 pCMZ6yTTEB3nr3UZXk4nwK6v0ra5oG8aB+tVDlwnJg8xXeGeBlqyXzVZr6cxsQo2znb3agLBm
 XbjM4KSa5eOSO99/vC9Zp2ZKUwzr0ZNkKt+zTInnV0GQcF8d1tu0CkZmrMmTxJ/xsaVGAKEAr
 WRLmqZfx3wPsEuClZuEaUfSbBcfA10sHo0k6JmaVS5dmKvmW5KpYzCj3nDjnG2FXYiZ7M9iwM
 P5kLmKmdjWN4jrSKZ0di5Jf7ahaTj3Nlb7FwYMp0Qx4eC1nBh90cHfHD84AFyvHJ011fTnywW
 Bgw1J6z/iD7ANtEb5TFIlS7goa/I6Dcqwx3ML9er768Mmtu6KvMs3+etnmkaYpcp7AOaszn/1
 F5az59YW82AxaGs30DmGOc7D/+T6mWQ4WNtKA+qFlfjbgf0/zyPVG3+600cgi6vevdnwKDsG6
 5MJxR8rFccXl0E2g8RfCJlUrZTXMmcUOzIJvdBhjTGRfMdhUUaHEpZlXhmEvwbb+U1GQvBJWF
 PUs6MFR8HlCYywFiZb7YMdEg==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 21. Januar 2023 um 14:35 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> It's hard for me to understand how applying only patch "tag_mtk only
> combine VLAN tag with MTK tag is user port is VLAN aware" can produce
> the results you describe... For packets sent to port lan0, nothing
> should have been changed by that patch, because dsa_port_is_vlan_filteri=
ng(dp)
> should return true.
>
> If you can confirm there isn't any mistake in the testing procedure,
> I'll take a look later today at the hardware documentation and try to
> figure out why the CPU port is configured the way it is.

booted an older kernel without your patches, and tried the vlan-aware brid=
ge the same way,
and it is not working there too. So not broken with your patches.

this is how i have created the bridge completely (to exclude a mistake in =
my setup):

BRIDGE=3Dlanbr0
ip link add name ${BRIDGE} type bridge vlan_filtering 1 vlan_default_pvid =
1
ip link set ${BRIDGE} up
ip link set lan0 master ${BRIDGE}
ip link set lan0 up

ip link add link lanbr0 name lanbr0.100 type vlan id 110
ip a a 192.168.110.5/24 dev lanbr0.100
ip link set lanbr0.100 up

btw. why is my vlan software-only and not pushed to hardware?

regards Frank
