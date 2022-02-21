Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E0B4BE323
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377303AbiBUOGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:06:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346989AbiBUOGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:06:32 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F7B1C107;
        Mon, 21 Feb 2022 06:06:09 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id u20so18856682lff.2;
        Mon, 21 Feb 2022 06:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=bk6iCziDs7KEQNE/9x22f3LO3qPYLR33HEQGFJDm3+k=;
        b=aq0QkXeh4owaIu+yypuEQ1a2yBDhwHw/SbxYGwXQJugzlJBo5NGN1vgaSKE1s8blTC
         nWlDO0+/q1CV1osEyC1ffUM28jtOwbQo4awy97wV1Vcg9B3+Z8FQxY6d78m2ViRfd0gm
         E8I3MGRy8Kk6+E7kBzN77teBDGcujJaspYOFJhzzMhBWVhdQIXCMu/af+jiYgaOexucX
         Lw0bstn4EUJRy2pUBz1IprvGW42vTqu1n1xdBYTSOY3twHqMnQvAME0a6FQDOKMJ9ZLi
         I2OySGBHpmlmw1hvIYla97mGlfYFL7tDQScnZw/w8+tUqo+8csOR7UozJ4hP/hAarYre
         qi1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=bk6iCziDs7KEQNE/9x22f3LO3qPYLR33HEQGFJDm3+k=;
        b=BvTmllOxWG73vYboeG+FnoNxdZnTzedD0huLmp7JJICnOU1M3VGP7Rx3pAvd9m0hRD
         QfQJTqudjSEfHoaQ9ast5VOfWXQqIKKbxLKC2wGrURVzWoVYaVsEWVGbiqFYjuwoiOwY
         GL2CvTTpFMdSM1NW5LtBsInZ7V7xJlcFBBIJ+JLstEZBK78+CyUNhMvrmvAE+UBTVHqo
         f0Rby9wxjl1rdKxIoE/eekJOLiV0AoANDyKnBXI6Iz12Y4r/beMGHaEdnuxaZ/Q9g6ZY
         WCXNPXm7Um5TPoLtUNXnRUKL7299E6D0zB3gVOiyZONAZrFAu9bdCjUgv61h1Duvo5VY
         8kYg==
X-Gm-Message-State: AOAM533DoYhQVfyerSrDHbczh7RxKC4Gm+Vek28s1fL0NMbc2OycTX2n
        YC4eZ33L2cOVXJm82pZ9qTgCutGG1NZCfx67Ztc=
X-Google-Smtp-Source: ABdhPJzgAFYt65DxXDN1Q3Wp51dwEeehuFeQLrHfCYHU4Yc4aaT7ljrmZjZD8OZxtCl1ulHLz1PRuQ==
X-Received: by 2002:ac2:5bc7:0:b0:442:c31e:876a with SMTP id u7-20020ac25bc7000000b00442c31e876amr13887095lfn.382.1645452367294;
        Mon, 21 Feb 2022 06:06:07 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id v7sm1353013ljd.120.2022.02.21.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 06:06:06 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/5] net: dsa: mv88e6xxx: Add support for
 bridge port locked mode
In-Reply-To: <YhIIJxxXP3JzD60/@shredder>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-5-schultz.hans+netdev@gmail.com>
 <20220219100034.lh343dkmc4fbiad3@skbuf> <YhIIJxxXP3JzD60/@shredder>
Date:   Mon, 21 Feb 2022 15:05:58 +0100
Message-ID: <86h78sqpq1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

On s=C3=B6n, feb 20, 2022 at 11:21, Ido Schimmel <idosch@idosch.org> wrote:
> On Sat, Feb 19, 2022 at 12:00:34PM +0200, Vladimir Oltean wrote:
>> On Fri, Feb 18, 2022 at 04:51:47PM +0100, Hans Schultz wrote:
>> > diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6=
xxx/port.c
>> > index ab41619a809b..46b7381899a0 100644
>> > --- a/drivers/net/dsa/mv88e6xxx/port.c
>> > +++ b/drivers/net/dsa/mv88e6xxx/port.c
>> > @@ -1234,6 +1234,39 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_=
chip *chip, int port,
>> >  	return err;
>> >  }
>> >=20=20
>> > +int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>> > +			    bool locked)
>> > +{
>> > +	u16 reg;
>> > +	int err;
>> > +
>> > +	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg);
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	reg &=3D ~MV88E6XXX_PORT_CTL0_SA_FILT_MASK;
>> > +	if (locked)
>> > +		reg |=3D MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK;
>> > +
>> > +	err =3D mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR,=
 &reg);
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	reg &=3D ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>> > +	if (locked)
>> > +		reg |=3D MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
>> > +
>> > +	err =3D mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR=
, reg);
>>=20
>> 	return mv88e6xxx_port_write(...);
>
> Not familiar with mv88e6xxx, but shouldn't there be a rollback of
> previous operations? Specifically mv88e6xxx_port_write()
>

If a register write function fails, I don't think that it would make
sense to try and resolve the situation by additional register write
calls (rollback).

>>=20
>> > +	if (err)
>> > +		return err;
>> > +
>> > +	return 0;
>> > +}
