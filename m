Return-Path: <netdev+bounces-1669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CEE6FEBCE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A828281678
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861791F19D;
	Thu, 11 May 2023 06:36:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E7371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:36:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487E819A6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683787011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sv76NtmE4dZCn9JdNGyD4d70x2/mYVFhzwx0GoRUTAE=;
	b=h4cpVEMTXa57uJEZN4CRuXLI9WtSwsaZmC8JNXJ6X44zCA6jdSTqyc/d5rKgpFcxyuPwuI
	50zHOMcuOzgdWHJSRXVhclAgVFw6DCi8+RFPS3zKEGWJv2qByjw/jKIJwPGmON3sRYTLoU
	dix0gypXWzl30CiOO+NuJYcwYAHmHZ0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-o-WxDhOJNd-M1WPGlyrkSA-1; Thu, 11 May 2023 02:36:50 -0400
X-MC-Unique: o-WxDhOJNd-M1WPGlyrkSA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-307ae58624dso122586f8f.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 23:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683787008; x=1686379008;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sv76NtmE4dZCn9JdNGyD4d70x2/mYVFhzwx0GoRUTAE=;
        b=GPrUY4WKm4Q/NuoPEf1gt5dcXqiZzlZ/ktiHXVEwhQ5JknnCd0CoIDo6Dv9HQ6oyXP
         3RLROHD6x1odcwBC2XdlbhZDIdDBMnVvxtZOgMukAwadQjeDd8D8yKcMwTLMHkAESeYw
         Dqxcq7Am0y7o+69IyzbePk7GEhXdfSyTg1NPesjpGu0AWvFxkjEXS7TJqqAH64Vajdcb
         u5N8xJAGvQzyHTsiJ+5/YA14ffPlOdLwSy38o5pM+E+1Uv6eTct+QBPf6cdyqSq7jGus
         a+3kYHdQQYkGhSUhavZ7AbnydYFBGrlH+WgOq0qWjF64k3SlOhWIqrvkXuYNW9b62qM2
         uvPA==
X-Gm-Message-State: AC+VfDxcfAIpeP791qpKS31Ig5/eo8HHUupKzSZCnGxBshCDPZlURtcO
	bdMKH+GPxur8SpM6IZVnWODN6LXxjof0iAiKJ5rEGqQKfCTXrZsvmYIFDHtXu05wSGBxTzz5fAL
	snIxXfdXL74Vn2PUchvx8puBR
X-Received: by 2002:a5d:4d84:0:b0:2cf:df6d:6063 with SMTP id b4-20020a5d4d84000000b002cfdf6d6063mr12255163wru.2.1683787008711;
        Wed, 10 May 2023 23:36:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7iFrhT3HWkOllzBe1k6nUZTnKxsfFTlLFEqrNHn9EvyGV8hVYJlMEaNM9jKqTOrkpmdcjfqA==
X-Received: by 2002:a5d:4d84:0:b0:2cf:df6d:6063 with SMTP id b4-20020a5d4d84000000b002cfdf6d6063mr12255149wru.2.1683787008377;
        Wed, 10 May 2023 23:36:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-149.dyn.eolo.it. [146.241.243.149])
        by smtp.gmail.com with ESMTPSA id y15-20020adfe6cf000000b0030633152664sm19302461wrm.87.2023.05.10.23.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 23:36:47 -0700 (PDT)
Message-ID: <33eec982e2ae94c7141d135f1de9bec02a60735b.camel@redhat.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>,
  Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, Philipp
 Rosenberger <p.rosenberger@kunbus.com>,  Zhi Han <hanzhi09@gmail.com>
Date: Thu, 11 May 2023 08:36:46 +0200
In-Reply-To: <20230510190517.26f11d4a@kernel.org>
References: 
	<342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
	 <20230509080627.GF38143@unreal> <20230509133620.GA14772@wunner.de>
	 <20230509135613.GP38143@unreal> <20230510190517.26f11d4a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-10 at 19:05 -0700, Jakub Kicinski wrote:
> On Tue, 9 May 2023 16:56:13 +0300 Leon Romanovsky wrote:
> > > > This is part of changelog which doesn't belong to commit message. T=
he
> > > > examples which you can find in git log, for such format like you us=
ed,
> > > > are usually reserved to maintainers when they apply the patch. =20
> > >=20
> > > Is that a new rule? =20
> >=20
> > No, this rule always existed, just some of the maintainers didn't care
> > about it.
> >=20
> > >=20
> > > Honestly I think it's important to mention changes applied to
> > > someone else's patch, if only to let it be known who's to blame
> > > for any mistakes. =20
> >=20
> > Right, this is why maintainers use this notation when they apply
> > patches. In your case, you are submitter, patch is not applied yet
> > and all changes can be easily seen through lore web interface.
> >=20
> > >=20
> > > I'm seeing plenty of recent precedent in the git history where
> > > non-committers fixed up patches and made their changes known in
> > > this way, e.g.: =20
> >=20
> > It doesn't make it correct.
> > Documentation/maintainer/modifying-patches.rst
>=20
> TBH I'm not sure if this is the correct reading of this doc.
> I don't see any problem with Lukas using the common notation.
> It makes it quite obvious what he changed and the changes are
> not invasive enough to warrant a major rewrite of the commit msg.

My reading of such documentation is that (sub-)maintainers could be
(more frequently) called to this kind of editing, but such editing is
not restricted.

In this specific case I could not find quickly via lore references to
the originating patch, so I find the editing useful.

The rationale of the mentioned process documentation is avoiding - when
possible and sensible - unneeded back and forth: I think we could and
should accept the patch in its current form.

I'm leaving it on PW a little more, in case there are strong, different
opinions.

Cheers,

Paolo


