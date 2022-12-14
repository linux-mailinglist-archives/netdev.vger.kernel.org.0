Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E5864CE3F
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiLNQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLNQmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:42:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA47515709
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:42:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so7775770pjj.2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vS+RTrRq2hQTjv7i/U2/fMIuzau/nqbiR4TlfkevDU8=;
        b=RF5W6zbub+4RFFIgx/yZ/2RKE3A7A1q/lEPSWFwvLjMeCblRuW5/4NeUPHJ+I6e5oI
         +cLQFlfxUi6mnPAxEJK6YggJYxoQxB16Uvk4URUN7cv/c8yJnB7O08Sy4m7gfqGWkRQQ
         BRMPIvV5KVK0aR+zXJhAT7swE5W1gstJ5ELVeb9wLWkiig+MpODBOAkF93yDALvqJAne
         JeW2WtZkZHt8FvnpFU5Av4hgK5PJ5PY9CGkFTFHXv/2Cymakqkth7GH3goyN9hOYbNwq
         heIp9x14R3GMDRFpxF4+3NKrN1MVnMn2P8AE5YqrAvS+PGNPCN0+ucVlaFaqFXgCn++w
         Lr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vS+RTrRq2hQTjv7i/U2/fMIuzau/nqbiR4TlfkevDU8=;
        b=pxA5AgmP7dGymKdO7DDO98Zja4GuF9ze6uofRo/lOj62Kc23aDa8gwCfWhBieuHw21
         O7jOK+VyxfBIJsFbV4xXT4YLF8ivjPWX3AGwiqkyvNSV01foctefYAVCg6AsyaU3OAWt
         23YavjpEHdYEcwktV9uSn8w3rzbfb/RPwhwst91rbNzihuqu2f36MlbhwdPa9WIVunEY
         daUA5o6YVHHqbkNPVdIIvLdvmMsvKW24pUQG4rGQSLOY3lxrOsZpZUzHksrj8WxDOoBE
         nuPRQcxuZVeHdKs53V1Juv1D58tSxB4MJg5pD2sPMEDoUiQlneYriTKAE5bzvsjiJ59p
         jJlA==
X-Gm-Message-State: AFqh2kqWFVpGeCYx10RFUx/Ntgf0mlHDsF8a8hyBIxU+z1R9yAQQ/1e9
        yCj45DQj/FczlEW6L99qDWVYcidWkyI=
X-Google-Smtp-Source: AMrXdXu8/H6gZCHKvVsPVweileNjiIbo5XJAufuqjvbcNI0ZUoD0jPs6/DwF+pLr1IgH0dOFkVXvVA==
X-Received: by 2002:a17:90b:210:b0:223:2edf:857e with SMTP id fy16-20020a17090b021000b002232edf857emr4317960pjb.8.1671036126066;
        Wed, 14 Dec 2022 08:42:06 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id p15-20020a17090a348f00b0021952b5e9bcsm1608601pjb.53.2022.12.14.08.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:42:05 -0800 (PST)
Message-ID: <7ee98dcab99a4fd23323f6cec803ef6c008118b0.camel@gmail.com>
Subject: Re: [PATCH net] mctp: Remove device type check at unregister
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Matt Johnston <matt@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, jk@codeconstruct.com.au
Date:   Wed, 14 Dec 2022 08:42:04 -0800
In-Reply-To: <20221214061044.892446-1-matt@codeconstruct.com.au>
References: <20221214061044.892446-1-matt@codeconstruct.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 14:10 +0800, Matt Johnston wrote:
> The check could be incorrectly triggered if a netdev
> changes its type after register. That is possible for a tun device
> using TUNSETLINK ioctl, resulting in mctp unregister failing
> and the netdev unregister waiting forever.
>=20
> This was encountered by https://github.com/openthread/openthread/issues/8=
523
>=20
> The check is not required, it was added in an attempt to track down mctp_=
ptr
> being set unexpectedly, which should not happen in normal operation.
>=20
> Fixes: 7b1871af75f3 ("mctp: Warn if pointer is set for a wrong dev type")
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> ---
>  net/mctp/device.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/net/mctp/device.c b/net/mctp/device.c
> index 99a3bda8852f..dec730b5fe7e 100644
> --- a/net/mctp/device.c
> +++ b/net/mctp/device.c
> @@ -429,12 +429,6 @@ static void mctp_unregister(struct net_device *dev)
>  	struct mctp_dev *mdev;
> =20
>  	mdev =3D mctp_dev_get_rtnl(dev);
> -	if (mdev && !mctp_known(dev)) {
> -		// Sanity check, should match what was set in mctp_register
> -		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
> -			    __func__, dev->type);
> -		return;
> -	}
>  	if (!mdev)
>  		return;
> =20

It looks like this is incomplete if we are going to allow for these
type of changes. We might as well also remove the block in
mctp_register that was doing a similar check for devices that already
have the mctp_ptr set. Otherwise you will likely need to follow up on
this later.

Alternatively if you are wanting to be consistent you could just drop
the "return", in which case you will still get the warn in both cases
but it doesn't seem to affect behavior otherwise.

In addition you may want to look at registering a notifier to catch
NETDEV_PRE_TYPE_CHANGE and NETDEV_PRE_TYPE_CHANGE. It would enable you
to catch these types of things in the future if you are wanting to
allow changing types.
