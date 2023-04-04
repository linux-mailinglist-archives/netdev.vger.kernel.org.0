Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38A6D6D41
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjDDTiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbjDDTiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:38:17 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40537C7;
        Tue,  4 Apr 2023 12:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680637056; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=jr+O2D0F76JJU7kSwZlZ6I294JwkWu+0UOCw8XpzFlLFbtUlKp/Hhm8guCdhJGvS3U2CyVY2c/bJ5qXETP+gPh5atKuOmev9QccpfiTF3XzsLRd/m1fkTN9Fq1+P+0FS3PVf5N4QD5kZGGFuZoV9vb1B/TJ0wznJu7drD1vTO1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680637056; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=E2DTXl0wOTGge7LqnlEIvHTLL1rOaURDHtKaO0WFHcU=; 
        b=boRmo8TnI/Eg0BvnA8v+KFgkFPo+LaF1kW8D4awVhqktQE/OgLNlcth4BlHf7hvA7El2P0vuiPS1xGjeBrHWN1Adlp2uGFz5RJeqMDRim/Dkudy5cuUZiaN5sRyGICgypefJku2DRiHO2qN3nzHZte+nC8L6zu8hBr93zTesvu4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680637056;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=E2DTXl0wOTGge7LqnlEIvHTLL1rOaURDHtKaO0WFHcU=;
        b=ab753m7vvr7p0QelL1tg4ktxsIc5LvHNShTljT4isc+D44+NfP7kB/w8w551FhGs
        yr6LtcGzftMAyE8pIwTcpVZNsjrN5Bwx8q/fe0flkk20nWEW9qTligyxgyPEqmodufy
        a3rCZF/Mg3c9URAsf3Mhc2G+vbLJYkd+Tl/YPYNk=
Received: from [127.0.0.1] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680637054373581.3705118144012; Tue, 4 Apr 2023 12:37:34 -0700 (PDT)
Date:   Tue, 04 Apr 2023 22:37:22 +0300
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
To:     =?UTF-8?B?TGFuZGVuIENoYW8gKOi2meeajuWujyk=?= 
        <Landen.Chao@mediatek.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "arinc9.unal@gmail.com" <arinc9.unal@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "dqfext@gmail.com" <dqfext@gmail.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "erkin.bozoglu@xeront.com" <erkin.bozoglu@xeront.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net_2/3=5D_net=3A_dsa=3A_mt7530=3A_move?= =?US-ASCII?Q?_lowering_TRGMII_driving_to_mt7530=5Fsetup=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <4d9c562eb980642381cb43f65efb2ee13d742485.camel@mediatek.com>
References: <20230320190520.124513-1-arinc.unal@arinc9.com> <20230320190520.124513-2-arinc.unal@arinc9.com> <4d9c562eb980642381cb43f65efb2ee13d742485.camel@mediatek.com>
Message-ID: <87B17946-4602-4D27-8756-7481846EDE35@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26 March 2023 21:13:49 GMT+03:00, "Landen Chao (=E8=B6=99=E7=9A=8E=E5=AE=
=8F)" <Landen=2EChao@mediatek=2Ecom> wrote:
>On Mon, 2023-03-20 at 22:05 +0300, arinc9=2Eunal@gmail=2Ecom wrote:
>>=20
>> I asked this before, MT7530 DSA driver maintainers, please explain
>> the code
>> I mentioned on the second paragraph=2E
>>=20
>> ---
>> @@ -2207,6 +2198,15 @@ mt7530_setup(struct dsa_switch *ds)
>>=20
>>         mt7530_pll_setup(priv);
>>=20
>> +       /* Lower Tx driving for TRGMII path */
>> +       for (i =3D 0; i < NUM_TRGMII_CTRL; i++)
>> +               mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
>> +                            TD_DM_DRVP(8) | TD_DM_DRVN(8));
>> +
>I guess you ask this part, and I try my best to recall what the
>original author said years ago=2E
>It is used to adjust the RX delay of port 6 to match the tx
>signal of the link partner=2E

Ok, thanks for replying=2E I will move this at the end, inside 'if (trgint=
)'=2E Since this doesn't lower the driving, there's no apparent benefit to =
run this if trgmii is not being used=2E

Ar=C4=B1n=C3=A7
