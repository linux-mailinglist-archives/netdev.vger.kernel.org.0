Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6296F60CD8F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiJYNdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiJYNdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:33:06 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43018C43E;
        Tue, 25 Oct 2022 06:33:05 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bx35so10896647ljb.2;
        Tue, 25 Oct 2022 06:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHuqg6wazq61wsFVkWE/SISNbbv5RZy8Z/GvW6u8Jy8=;
        b=lDDSUSCZF7fC5+uNBApF9nvfP9mLQYn/+TEv026tp9jKgOqgfM2sodFT1H4rShWmnk
         eJOMvn9vws3cn5/uo+k9Ip+xwcmymbeo0vY0WfoLq1xB8ui/euavkHzdrE431nU5HGTG
         J5nSQqDhCOGxXOnCSddpblc0QUDEfLR+MT70J65CmN15xRJ12oMYC9yppOqjATYrOrpD
         zPJRPhiCjoa/OXtA/0AhxMrvxQdKmozvZqwc0qR4mRLzN7HoxSNZmvaaQZOPG03nSFNB
         O5PocyE3OZabhtT925TjqOkgVhxqDt54qiAgfQHI7gX89vx1D5z1ZwqWZ8K3AalpQ17/
         4bPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pHuqg6wazq61wsFVkWE/SISNbbv5RZy8Z/GvW6u8Jy8=;
        b=wM0co6PKo3+hivRtgBF+I3ST7QEc8BN5RzKkvFIXUBNBDUz6oBmtBi6eKL8hiwMZ2A
         kVWLzfcwd8qZI+bmIeJCYQTzz1+Gsq9u7LN/ePNN2TqnoX5kvMetP6Y5Abi5FWV5dh04
         6aKXxrYUEz/sPwSvAinjAN2XF4lXNWeQI0EFqCKHp3EVXub0hooC68Fhd3GA7cihMLdY
         N9YqfIm/96W1b7YOwWT61D9O86PhfiRdhZx3snZeQqevNqoGHi+GBB09zeiRMHs/Zzx7
         5vrq/Oki4e/QgEYW41zPtTN+S36FUogKqEB34BvJXMuCHlArUdyOSBhQJXoWddoGpjPG
         x9nA==
X-Gm-Message-State: ACrzQf1Jf0PQGJ6rUlpd0TI0FW66j1hnD+Da/vmxsqV1iwJ+WJGbxI4x
        jbwIHX2GIF2bYKst/DolxcU=
X-Google-Smtp-Source: AMsMyM7kO5mPMXHaB6fu52Hog/bI1RsTBBEMNFwb6vdMHznguKU2T1AOcdBBaJRhRqWbKjOTnzzfQQ==
X-Received: by 2002:a2e:9e43:0:b0:25d:d8e9:7b15 with SMTP id g3-20020a2e9e43000000b0025dd8e97b15mr14297278ljk.234.1666704783270;
        Tue, 25 Oct 2022 06:33:03 -0700 (PDT)
Received: from smtpclient.apple (188-177-109-202-dynamic.dk.customer.tdc.net. [188.177.109.202])
        by smtp.gmail.com with ESMTPSA id g40-20020a0565123ba800b0049110ba325asm415367lfv.158.2022.10.25.06.33.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Oct 2022 06:33:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
From:   Michael Lilja <michael.lilja@gmail.com>
In-Reply-To: <Y1fd+DEPZ8xM2x5B@salvia>
Date:   Tue, 25 Oct 2022 15:32:51 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia> <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=20

Thanks for the optimisation suggestions, my nft is a rough conversion =
from iptables, I will look into using maps.

The ingress chain will work fine for SW OFFLOAD but HW OFFLOAD is not =
solved by this, at least what I see is that once a flow is offloaded to =
HW the driver doesn=E2=80=99t see the packets?

If I use the ingress chain I guess I don=E2=80=99t have access to =E2=80=98=
ct mark=E2=80=99 yet? I could think of a use-case where schedules should =
only some =E2=80=98flow type=E2=80=99:
 meta mask !=3D 0x12340000/16 meta day =E2=80=9CTuesday" meta hour >=3D =
"06:00" meta hour < "07:00" drop=20

I have more advanced rules that check the ct mark and will need to drop =
if mark =3D=3D something. These mark =3D=3D something rules are applied =
=E2=80=98runtime=E2=80=99 and flowables doesn=E2=80=99t seem to be =
flushed on nft load, which is also a reason for my =E2=80=98flow =
retire=E2=80=99 from the tables.

So my overall goal is to receive packets, mark them with a value =
depending on 'flow type' and then for the flows that are allowed to be =
forwarded offload them to the ingress flow table for either HW or SW =
offload. Once in a while I will change the verdict of a =E2=80=98flow =
type=E2=80=99 and will need that to apply for all existing flows and =
future flows, besides the fixed schedules, and it should work both for =
SW OFFLOAD and HW OFFLOAD.

I only have the M7621 device to play with for HW OFFLOAD, but it works =
fine with my patch.



Thanks

>=20
>=20
> I suggest to move your 'forward' chain to netdev/ingress using =
priority
>=20
>      filter - 1
>=20
> so the time schedule evaluation is always done before the flowtable
> lookup, that is, schedules rules will be always evaluated.
>=20
> In your example, you are using a linear ruleset, which might defeat
> the purpose of the flowtable. So I'm attaching a new ruleset
> transformed to use maps and the ingress chain as suggested.
> <schedules.nft>

