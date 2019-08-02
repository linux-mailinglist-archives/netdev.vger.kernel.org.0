Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7D7FFF9
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436857AbfHBSCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:02:37 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36753 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405231AbfHBSCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:02:37 -0400
Received: by mail-qt1-f194.google.com with SMTP id z4so74846392qtc.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x0/imP+PQmkbv+nO4BOzOroOpmKGmhypr4x6s/BrmAc=;
        b=QU4+byOKqeH+oscCH7CXhPiAbbi8tfSoK1a1tvv1Y5hNHjRxB7zWYt7qowGQ0RNLtb
         hNqoOvE0XWRjiOjYc/vg4yJ/fT8d08W3ahxSMvx2rWwmNS4UOUC3o5FzJNzQu0dFSqYA
         cRiAn+orT7pK0gLAbADWyemlAP8AaJa0ufvlKFpcUTfmJLcAF378VCq+AH7cs+PMnXH8
         uUv2nkmN3NSqTZcSrSR3Eu1lyaHsjfbBoyU11EiJP8ojtqPB3xUeXn+pdl0fejUjG3HR
         Q3E6IzCShwtD+ppxnjJgFX3XU+ootEUufs8r2P/gYKYjtYel57bNFP5PvObDr3cjOOyl
         5mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x0/imP+PQmkbv+nO4BOzOroOpmKGmhypr4x6s/BrmAc=;
        b=UwfqJZieTKcPLep955+5BlADxyGeSiEfb7vEHJ0p5fYxtUpr1xDbfjUHWJ0AEBZ7pf
         9IzYs2VxqnXvKAR9JeeAagYeXwtTx/Gi7yXGwXMMlwRNlcN0lbJx0ffL52Y++tY2Tmmx
         BVnNEtvg/yg3nN7fSJxxiH4jOCYY9tZpn2JcuGgriNciB4ugcxPEUka50wVDcKYXTGh/
         b9OfI4IpSWTjdZIIY3ZhWgkVijQpgK/A1qnB+sZXeYRQrvcdoDKSu2spliPajo1/g1Ei
         QgEXOD+PBG9OxthC7Y2cPMKsXjqh19mN3bMdSbjrwhMKg0qw4p+WY+6R1uv0Y5ngwSMr
         4l0g==
X-Gm-Message-State: APjAAAWWreJ1rBp6zXE9S78GWrtvEGz7Vdc1F1WhC6qBl+hqMKOGzb5b
        wQBQ0rOGHaKcEHRVRtVk/5zcsA==
X-Google-Smtp-Source: APXvYqzngw8tV6BxNFGiW0CSqUH4hqv9Q65MQ9wH3WPxdRY3rhYBa9CXN3DwJQRneAnW/2FukjdU2A==
X-Received: by 2002:ac8:124c:: with SMTP id g12mr35071167qtj.57.1564768956248;
        Fri, 02 Aug 2019 11:02:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 123sm30288918qkm.61.2019.08.02.11.02.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 11:02:36 -0700 (PDT)
Date:   Fri, 2 Aug 2019 11:02:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
Message-ID: <20190802110216.5e1fd938@cakuba.netronome.com>
In-Reply-To: <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
        <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
        <20190801161129.25fee619@cakuba.netronome.com>
        <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
        <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 21:09:03 +0800, wenxu wrote:
> >> We'd have something like the loop in flow_get_default_block():
> >>
> >> 	for each (subsystem)
> >> 		subsystem->handle_new_indir_cb(indr_dev, cb);
> >>
> >> And then per-subsystem logic would actually call the cb. Or:
> >>
> >> 	for each (subsystem)
> >> 		block =3D get_default_block(indir_dev)
> >> 		indr_dev->ing_cmd_cb(...) =20
> > =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 nft dev chian =
is also based on register_netdevice_notifier, So for unregister case,
> >
> > the basechian(block) of nft maybe delete before the __tc_indr_block_cb_=
unregister. is right?
> >
> > So maybe we can cache the block as a list of all the subsystem in=C2=A0=
 indr_dev ? =20
>=20
>=20
> when the device is unregister the nft netdev chain related to this device=
 will also be delete through netdevice_notifier
>=20
> . So for unregister case,the basechian(block) of nft maybe delete before =
the __tc_indr_block_cb_unregister.

Hm, but I don't think that should be an issue. The ordering should be
like one of the following two:

device unregister:
  - driver notifier callback
    - unregister flow cb
      - UNBIND cb
        - free driver's block state
    - free driver's device state
  - nft block destroy
    # doesn't see driver's CB any more

Or:

device unregister:
  - nft block destroy
    - UNBIND cb
      - free driver's block state
  - driver notifier callback
    - free driver's state

No?

> cache for the block is not work because the chain already be delete and f=
ree. Maybe it improve the prio of
>=20
> rep_netdev_event can help this?

In theory the cache should work in a similar way as drivers, because
once the indr_dev is created and the initial block is found, the cached
value is just recorded in BIND/UNBIND calls. So if BIND/UNBIND works for
drivers it will also put the right info in the cache.
