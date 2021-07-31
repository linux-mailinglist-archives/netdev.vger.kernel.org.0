Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48733DC618
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 15:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhGaN1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhGaN1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 09:27:14 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B861C06175F;
        Sat, 31 Jul 2021 06:27:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id cf5so5983371edb.2;
        Sat, 31 Jul 2021 06:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=in-reply-to:references:thread-topic:user-agent:mime-version
         :content-transfer-encoding:subject:from:date:to:cc:message-id;
        bh=xl09+cxouK/J8oQbWqVsZd+JkQVF+Hr4QFi7eK3edzg=;
        b=nQgLQpxWPfiFCI3TlKKidWTFMQj5R2bx5WVEcdYTDRAIO5H7Ki22zu4sGPWAHI0246
         aEm1k5BLdaoYUAN6ifFPowXWMiJzJH2wC12SKbmsD6h2g1rpquOy2ntEsMjD9RAwbBHC
         65yy2xHFzo3hj4jHF8On0YcLlRbnUsA0c9CAkk4xedWzFBXnypui1qTU6mVC1V8CkUhw
         B9Xa3g6aPyMxgfmAqZWiswEARMM8yfW6Ro+wMDLpkZ/S6BKk6RMTz2k84R47VsB8tW5A
         Gk4VfrKIButSiEBtsVBM9IsDlPrE2IlARmuURy2pYI3SjoYXYhKZbOkSRyD8ObMfxBEe
         3HVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:in-reply-to:references:thread-topic:user-agent
         :mime-version:content-transfer-encoding:subject:from:date:to:cc
         :message-id;
        bh=xl09+cxouK/J8oQbWqVsZd+JkQVF+Hr4QFi7eK3edzg=;
        b=DveEK/4bWATKEx0rr8/Zm/Vw5r8ATIZ8Kipfcjnc5jF9kMb+uzMHU9daJ+qpuj83p5
         QOjgFJ8IzXXPTF2+B6izStSVky0J54ywuoFb4xSW2S/Mcoo0CCbaKFjBZmykt2y2Fkq1
         XgNLTDr6xnX8dIIWLvVFmQXZxThjyD7INGA7xPazvFw/Oi5ubohX5OLNPxHbctXAuWN8
         vQzHPEP88JaNmqyuL94NALISIX722KTd8q2rWt8y1NkKnJavL72aw+h18S7AbbOuDGoP
         HdFxN8HGGiRQdsgBmRZrscP4jnNuJFz4RnQFw96XzKqpQgduJSE15QLJjxpnligbXqko
         ch5g==
X-Gm-Message-State: AOAM532hxKi1dL7RHMrduU9WZx20gSnLWILvpRHVoaNi+440EGTx/TVw
        fP9xbiRJdqVkgf4JJhzYmkehE5DFrh+mcw==
X-Google-Smtp-Source: ABdhPJzlw31pNS40a/9JFPmy1rPxcNXk5ZQGBfrczjR6U3W2TJEh4j5Csva/YdpkPS3o00SAyEjjWA==
X-Received: by 2002:a05:6402:c01:: with SMTP id co1mr9067625edb.287.1627738027162;
        Sat, 31 Jul 2021 06:27:07 -0700 (PDT)
Received: from [192.168.1.158] (83-87-52-217.cable.dynamic.v4.ziggo.nl. [83.87.52.217])
        by smtp.gmail.com with ESMTPSA id l16sm1701766eje.67.2021.07.31.06.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 06:27:06 -0700 (PDT)
In-Reply-To: <20210727132015.835651-5-sashal@kernel.org>
References: <20210727132015.835651-1-sashal@kernel.org> <20210727132015.835651-5-sashal@kernel.org>
X-Referenced-Uid: 5707
Thread-Topic: [PATCH AUTOSEL 4.19 5/6] mt7530 fix mt7530_fdb_write vid missing ivl bit
X-Blue-Identity: !l=240&o=43&fo=2660&pl=166&po=0&qs=PREFIX&f=HTML&m=!%3ANzRiZDk5M2QtNTJhNy00MTE4LThlNmYtYTk2ZDg2NDQzNGU0%3ASU5CT1g%3D%3ANTcwNw%3D%3D%3AANSWERED&p=164&q=SHOW
X-Is-Generated-Message-Id: true
User-Agent: Android
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Local-Message-Id: <e1508978-8f0e-40a6-baa8-3d3bc4c82811@gmail.com>
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH AUTOSEL 4.19 5/6] mt7530 fix mt7530_fdb_write vid missing ivl bit
From:   Eric Woudstra <ericwouds@gmail.com>
Date:   Sat, 31 Jul 2021 15:27:04 +0200
To:     Sasha Levin <sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Message-ID: <e1508978-8f0e-40a6-baa8-3d3bc4c82811@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


A few days after this patch, I send in another as it needs a fix=2E If you=
 apply this patch, please also apply the other: set ivl bit only for vid la=
rger than 1=2E

On Jul 27, 2021, 3:20 PM, at 3:20 PM, Sasha Levin <sashal@k=
ernel=2Eorg> wrote:
>From: Eric Woudstra <ericwouds@gmail=2Ecom>
>
>[ Upstr=
eam commit 11d8d98cbeef1496469b268d79938b05524731e8 ]
>
>According to refer=
ence guides mt7530 (mt7620) and mt7531:
>
>NOTE: When IVL is reset, MAC[47:=
0] and FID[2:0] will be used to
>read/write the address table=2E When IVL i=
s set, MAC[47:0] and CVID[11:0]
>will be used to read/write the address tab=
le=2E
>
>Since the function only fills in CVID and no FID, we need to set t=
he
>IVL bit=2E The existing code does not set it=2E
>
>This is a fix for th=
e issue I dropped here earlier:
>
>http://lists=2Einfradead=2Eorg/pipermail=
/linux-mediatek/2021-June/025697=2Ehtml
>
>With this patch, it is now possi=
ble to delete the 'self' fdb entry
>manually=2E However, wifi roaming still=
 has the same issue, the entry
>does not get deleted automatically=2E Wifi =
roaming also needs a fix
>somewhere else to function correctly in combinati=
on with vlan=2E
>
>Signed-off-by: Eric Woudstra <ericwouds@gmail=2Ecom>
>Si=
gned-off-by: David S=2E Miller <davem@davemloft=2Enet>
>Signed-off-by: Sash=
a Levin <sashal@kernel=2Eorg>
>---
> drivers/net/dsa/mt7530=2Ec | 1 +
> dri=
vers/net/dsa/mt7530=2Eh | 1 +
> 2 files changed, 2 insertions(+)
>
>diff --=
git a/drivers/net/dsa/mt7530=2Ec b/drivers/net/dsa/mt7530=2Ec
>index 6335c4=
ea0957=2E=2E96dbc51caf48 100644
>--- a/drivers/net/dsa/mt7530=2Ec
>+++ b/dr=
ivers/net/dsa/mt7530=2Ec
>@@ -414,6 +414,7 @@ mt7530_fdb_write(struct mt753=
0_priv *priv, u16 vid,
> 	int i;
> 
> 	reg[1] |=3D vid & CVID_MASK;
>+	reg[=
1] |=3D ATA2_IVL;
> 	reg[2] |=3D (aging & AGE_TIMER_MASK) << AGE_TIMER;
> 	=
reg[2] |=3D (port_mask & PORT_MAP_MASK) << PORT_MAP;
> 	/* STATIC_ENT indic=
ate that entry is static wouldn't
>diff --git a/drivers/net/dsa/mt7530=2Eh =
b/drivers/net/dsa/mt7530=2Eh
>index 101d309ee445=2E=2E72f53e6bc145 100644
>=
--- a/drivers/net/dsa/mt7530=2Eh
>+++ b/drivers/net/dsa/mt7530=2Eh
>@@ -43,=
6 +43,7 @@
> #define  STATIC_EMP			0
> #define  STATIC_ENT			3
> #define MT=
7530_ATA2			0x78
>+#define  ATA2_IVL			BIT(15)
> 
> /* Register for address=
 table write data */
> #define MT7530_ATWD			0x7c
>-- 
>2=2E30=2E2

