Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022BD4DA569
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352254AbiCOW35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbiCOW34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:29:56 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77297275EF
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:28:43 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id w27so863797lfa.5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=w7BDs3bl+/ZPNAYyg8MK8EHAzhqEJFCQVGbId855EFw=;
        b=UNKIKiXT8QfonLayJTWbx/cxsyCrYGovzyCMkmOQ0WbbLDyVWoFc+Uk1YSJdQ1ErVj
         NSZ65OYFwoBxTx37iTZxofhPtQYuTz0inW2ISH8BrEsIVKWupQ1V/0v2AOTqnkzOqHIW
         MVzHAKTAj6L5LAFrRjVFItdVTexCKpxRKzLUb91eMO3QhpYWVcExxhjIB3WbJnai2fTU
         qfuNwPew+1Y3t6NU7MAANItoNNKZRVoZY9NnXqRDDEl6dp6M2w5ktTXMJ6Fflzyk/u8n
         bGm8okMa05EECvOosBzkbLV4oB43ONkLUH1EODsepFAU/yZWqBY7ocKkvqsrQZA8Ubbx
         k16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=w7BDs3bl+/ZPNAYyg8MK8EHAzhqEJFCQVGbId855EFw=;
        b=CzbXwz9D6Lm9mLRgBaMEIwxZroC7J4+0ThAIcdGtBAqeXFQF5GTNSbY0+rU5rehfJD
         rqa2vbAloPyu9jFAKP9rYfgK1lvp1SKRWhN1KwgHiHAUzQ/cIlwrhMDK4CRx3Ee56Lqv
         g4eophGFY4AAAtI0PeMuM1zAmaZVzd1e2VQS9CyjOkoM5T/Vb2KZUe7hswpRrILwRPsO
         9AjW4Ogs2bGI8r7j087Qts2ocMoAlD389CUdFTnwYBRaYj5zYzlcFTpAMN4xB3fKiMQL
         +9ajUpBQm04GXxB4yOrn9pEZG53jGdzMCjxwPw/gueuyPAAUxTDgRBbC3kf6ObcvSkcB
         fR4A==
X-Gm-Message-State: AOAM531YhaEAch69R+6ck5/+TU/HvjvEAvluCcALRbKIjhYpGi4xa1R4
        9Q7xKUgpdB5nXWkRp7ZL+5l61w==
X-Google-Smtp-Source: ABdhPJzSvTuOZ2Qd6cxpzVKDTdxQS6q1f1pKQ777CthPpVb5BrMo3DXztfZjgkzp4GIoFxE23grYmA==
X-Received: by 2002:a05:6512:3e21:b0:448:53c7:178e with SMTP id i33-20020a0565123e2100b0044853c7178emr18805261lfv.374.1647383321771;
        Tue, 15 Mar 2022 15:28:41 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id i2-20020ac25b42000000b004488d7f5eadsm21083lfp.88.2022.03.15.15.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:28:41 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 04/15] net: bridge: mst: Notify switchdev
 drivers of MST mode changes
In-Reply-To: <20220314223246.45cf8305@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-5-tobias@waldekranz.com>
 <20220314223246.45cf8305@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 15 Mar 2022 23:28:40 +0100
Message-ID: <87bky6lujr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 22:32, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 15 Mar 2022 01:25:32 +0100 Tobias Waldekranz wrote:
>> Trigger a switchdev event whenever the bridge's MST mode is
>> enabled/disabled. This allows constituent ports to either perform any
>> required hardware config, or refuse the change if it not supported.
>>=20
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>
> ../net/bridge/br_mst.c: In function =E2=80=98br_mst_set_enabled=E2=80=99:
> ../net/bridge/br_mst.c:102:16: error: variable =E2=80=98attr=E2=80=99 has=
 initializer but incomplete type
>   102 |         struct switchdev_attr attr =3D {
>       |                ^~~~~~~~~~~~~~
> ../net/bridge/br_mst.c:103:18: error: =E2=80=98struct switchdev_attr=E2=
=80=99 has no member named =E2=80=98id=E2=80=99
>   103 |                 .id =3D SWITCHDEV_ATTR_ID_BRIDGE_MST,
>       |                  ^~
> ../net/bridge/br_mst.c:103:23: error: =E2=80=98SWITCHDEV_ATTR_ID_BRIDGE_M=
ST=E2=80=99 undeclared (first use in this function)
>   103 |                 .id =3D SWITCHDEV_ATTR_ID_BRIDGE_MST,
>       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../net/bridge/br_mst.c:103:23: note: each undeclared identifier is report=
ed only once for each function it appears in
> ../net/bridge/br_mst.c:103:23: warning: excess elements in struct initial=
izer
> ../net/bridge/br_mst.c:103:23: note: (near initialization for =E2=80=98at=
tr=E2=80=99)
> ../net/bridge/br_mst.c:104:18: error: =E2=80=98struct switchdev_attr=E2=
=80=99 has no member named =E2=80=98orig_dev=E2=80=99
>   104 |                 .orig_dev =3D br->dev,
>       |                  ^~~~~~~~
> ../net/bridge/br_mst.c:104:29: warning: excess elements in struct initial=
izer
>   104 |                 .orig_dev =3D br->dev,
>       |                             ^~
> ../net/bridge/br_mst.c:104:29: note: (near initialization for =E2=80=98at=
tr=E2=80=99)
> ../net/bridge/br_mst.c:105:18: error: =E2=80=98struct switchdev_attr=E2=
=80=99 has no member named =E2=80=98u=E2=80=99
>   105 |                 .u.mst =3D on,
>       |                  ^
> ../net/bridge/br_mst.c:105:26: warning: excess elements in struct initial=
izer
>   105 |                 .u.mst =3D on,
>       |                          ^~
> ../net/bridge/br_mst.c:105:26: note: (near initialization for =E2=80=98at=
tr=E2=80=99)
> ../net/bridge/br_mst.c:102:31: error: storage size of =E2=80=98attr=E2=80=
=99 isn=E2=80=99t known
>   102 |         struct switchdev_attr attr =3D {
>       |                               ^~~~
> ../net/bridge/br_mst.c:125:15: error: implicit declaration of function =
=E2=80=98switchdev_port_attr_set=E2=80=99; did you mean =E2=80=98br_switchd=
ev_port_vlan_del=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>   125 |         err =3D switchdev_port_attr_set(br->dev, &attr, extack);
>       |               ^~~~~~~~~~~~~~~~~~~~~~~
>       |               br_switchdev_port_vlan_del
> ../net/bridge/br_mst.c:102:31: warning: unused variable =E2=80=98attr=E2=
=80=99 [-Wunused-variable]
>   102 |         struct switchdev_attr attr =3D {
>       |                               ^~~~

Sorry about that. Forgot to run the incremental build after the
rebase. Will be fixed in v5.
