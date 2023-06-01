Return-Path: <netdev+bounces-7068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7E47199DA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 072BE281769
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6354522D57;
	Thu,  1 Jun 2023 10:32:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5667122D54
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:32:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C01129
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685615544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6q+KX/k75E+rVt3X94R2L8nrTARAGFfCqIAPs9yXJ4=;
	b=d5TWbnAahJuGyTlXW45bl+QedvlG0I5oWETKrE6BAPUxP9pGQyUk8iPvljqWXOjCwchPnW
	L8ze3hVEwv0CXRmNzSvOMsoOI5nWHDt+fg/eqLYQgFzLXrdi6fDa6umhKT7jiMRIpERYq9
	mgZtUPqQ3kT9GMJ7/td++8228aAxYyE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-HjOph7t3MgK-QS3a09CaIA-1; Thu, 01 Jun 2023 06:32:23 -0400
X-MC-Unique: HjOph7t3MgK-QS3a09CaIA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-626204b0663so1797066d6.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 03:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685615543; x=1688207543;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m6q+KX/k75E+rVt3X94R2L8nrTARAGFfCqIAPs9yXJ4=;
        b=NYZ9DqPPHZhgmlsOgupNxCdJ97w50IscwZ7gnP/A01tf8KIWledF/FCYqpr8oTvtM5
         2mT8NF7LdpYOLiatiPlqiOxM18uBXpeC94oTuQWD0JR3GzigUe6M4iCg3blBdty8vQiq
         HHpfFCmW8xDe5zWsCZVYcuxCm9jh+5kzHkd3V2yzZy124Zlv7PUWH88Cnwgn0EnXaHbr
         yFQUQsxMfs0HgbhOPk35X9NmQOEM/VOr18XP3aThdJkieauXTNYHfTBKXbXEonUFHcKv
         LJLnHv4WICe/8JoSpEqmqt1BaqolQw6A4/nd3VDArIuK6aCYnUOUB4ldZIGFRm1wCFN1
         p8Jg==
X-Gm-Message-State: AC+VfDy0yuwqKM7jMXFAT35LThUZO4fiSvH3menY1L6O5xOd0QyzWx5e
	/1IAbvJY65M/KKxiKma4ImYPORxbPI+oFmtkmDM38MPz1862TeQPcvXQEecn1sYSUQ69wlrBE7p
	a0mMAXx7/wWsn2Toy
X-Received: by 2002:a05:6214:765:b0:5ed:c96e:ca4a with SMTP id f5-20020a056214076500b005edc96eca4amr5389570qvz.1.1685615543126;
        Thu, 01 Jun 2023 03:32:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ckZ4+GL4Jleu8XE76qHE243+7UyCyLw+kBF8DtpalXlVScxWqzj59eNGhXZSEb6jBTj5UIQ==
X-Received: by 2002:a05:6214:765:b0:5ed:c96e:ca4a with SMTP id f5-20020a056214076500b005edc96eca4amr5389550qvz.1.1685615542837;
        Thu, 01 Jun 2023 03:32:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id d10-20020ac8534a000000b003e69d6792f6sm7459431qto.45.2023.06.01.03.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 03:32:22 -0700 (PDT)
Message-ID: <d36ba731c063b3ddace873926cc773426c55ca4a.camel@redhat.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
From: Paolo Abeni <pabeni@redhat.com>
To: Andreas Svensson <andreas.svensson@axis.com>, Andrew Lunn
 <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>,  "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,  kernel@axis.com,
 Baruch Siach <baruch@tkos.co.il>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Thu, 01 Jun 2023 12:32:19 +0200
In-Reply-To: <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
	 <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
	 <f89e203a-af77-9661-1003-0e9370ff6fab@axis.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-06-01 at 11:10 +0200, Andreas Svensson wrote:
> On 5/30/23 19:28, Andrew Lunn wrote:
> > On Tue, May 30, 2023 at 04:52:23PM +0200, Andreas Svensson wrote:
> > > A switch held in reset by default needs to wait longer until we can
> > > reliably detect it.
> > >=20
> > > An issue was observed when testing on the Marvell 88E6393X (Link Stre=
et).
> > > The driver failed to detect the switch on some upstarts. Increasing t=
he
> > > wait time after reset deactivation solves this issue.
> > >=20
> > > The updated wait time is now also the same as the wait time in the
> > > mv88e6xxx_hardware_reset function.
> >=20
> > Do you have an EEPROM attached and content in it?
>=20
> There's no EEPROM attached to the switch in our design.
>=20
> >=20
> > It is not necessarily the reset itself which is the problem, but how
> > long it takes after the reset to read the contents of the
> > EEPROM. While it is doing that, is does not respond on the MDIO
> > bus. Which is why mv88e6xxx_hardware_reset() polls for that to
> > complete.
>=20
> Ok, yes that makes sense. I could add the mv88e6xxx_g1_wait_eeprom_done
> function after the reset deactivation.
>=20
> >=20
> > I know there are some users who want the switch to boot as fast as
> > possible, and don't really want the additional 9ms delay. But this is
> > also a legitimate change. I'm just wondering if we need to consider a
> > DT property here for those with EEPROM content. Or, if there is an
> > interrupt line, wait for the EEPROM complete interrupt. We just have
> > tricky chicken and egg problems. At this point in time, we don't
> > actually know if the devices exists or not.
> >=20
> > 	  Andrew
>=20
> It just seems like we need to wait longer for the switch 88E6393X
> until it responds reliably on the MDIO bus. But I'm open to adding
> a new DT property if that's needed.
>=20
> The datasheet for 88E6393X also states that it needs at least 10ms
> before it's ready. But I suppose this varies from switch to switch.

I read the above as a new version of this fix is coming, thus not
applying this patch.

Thanks,

Paolo


