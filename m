Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D796BD7A6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCPR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCPR6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:58:42 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCCEEB63
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:58:41 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id l13so2711231qtv.3
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 10:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1678989520;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/CT0VC/Pi7ybH2oOvSPa04iJydx3LmU8cq1LYYBaxo=;
        b=Kt0P7blQO4QiB8u64webILAnLelRgcsXJPwaGCHYUs5sinmkiUe9DIvx9WIpHtyDaw
         CDXigO1BoXDuJ4oHyHiwhuKZlXoaqnL4urF7LQ3T41abKnJuK67rIZuKEg1CXdwRnoIb
         5VKkNqobEmpNJzvWeg8b7NwFu7SunOGAdmfgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678989520;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/CT0VC/Pi7ybH2oOvSPa04iJydx3LmU8cq1LYYBaxo=;
        b=IGjouCRaVcU7fNkaAg313IoCmCX221HJwS6WaSJ8Qfbh/TAVUIhUBAZ0ukqbx9uUMZ
         TgB5IwBlCwS7VE1Je4eY61ybyERzsr921Jo1PvIpBcYS5Du2TfkLPXCwEOZWyIl9sE+L
         c1xbGetK5UC2N6mgDbDSMZstJj9bFDHecN6BDm+2Gk4zbDzA6xanarLOTthaHhrBSUZT
         XLWyNbp+T+4koVLcxB2dPgC+2jYYKw21EFIRFDRTNjoZqN71R95MhtLCAB4iP/bHVBgK
         5BKKsftSWQybyhWTXDBANonsehtfJ+ICa8mGuuxPLY7qiW6X1eQQ8QqxrSrk50LIwUpd
         zfug==
X-Gm-Message-State: AO0yUKVuN1ao/Vs1LQgabGgJcpwlfrGcbtrjpv/TnRb6Z3EgjmTvAiFY
        nW02sM3hAo9lY3tDTvbSMpuqXA==
X-Google-Smtp-Source: AK7set8HcNhSlWCGy+lNBoJsBAtijhqmWQ97EAO52ZHjlCfBQdPWeZxnUrnhy9+jutYLdNGQT0oP0g==
X-Received: by 2002:ac8:5c16:0:b0:3c0:14ec:bfc0 with SMTP id i22-20020ac85c16000000b003c014ecbfc0mr8136756qti.22.1678989520079;
        Thu, 16 Mar 2023 10:58:40 -0700 (PDT)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id q62-20020a374341000000b0074589d41342sm31762qka.17.2023.03.16.10.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 10:58:39 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mac802154: Rename kfree_rcu() to kvfree_rcu_mightsleep()
Date:   Thu, 16 Mar 2023 13:58:28 -0400
Message-Id: <6EAB6B07-60C0-4489-9281-E01264E86DA5@joelfernandes.org>
References: <99dccb18-d16e-0b5b-586d-59a7649f68c4@datenfreihafen.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        boqun.feng@gmail.com, paulmck@kernel.org, urezki@gmail.com
In-Reply-To: <99dccb18-d16e-0b5b-586d-59a7649f68c4@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 16, 2023, at 12:36 PM, Stefan Schmidt <stefan@datenfreihafen.org> w=
rote:
>=20
> =EF=BB=BFHello Joel.
>=20
>> On 10.03.23 02:31, Joel Fernandes (Google) wrote:
>> The k[v]free_rcu() macro's single-argument form is deprecated.
>> Therefore switch to the new k[v]free_rcu_mightsleep() variant. The goal
>> is to avoid accidental use of the single-argument forms, which can
>> introduce functionality bugs in atomic contexts and latency bugs in
>> non-atomic contexts.
>> The callers are holding a mutex so the context allows blocking. Hence
>> using the API with a single argument will be fine, but use its new name.
>> There is no functionality change with this patch.
>> Fixes: 57588c71177f ("mac802154: Handle passive scanning")
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>> ---
>> Please Ack the patch but we can carry it through the RCU tree as well if
>> needed, as it is not a bug per-se and we are not dropping the old API bef=
ore
>> the next release.
>=20
> The "but we can carry it" part throws me off here. Not sure if you want th=
is through the RCU tree (I suppose). In that case see my ack below.
>=20
> If you want me to take it through my wpan tree instead let me know.

We will take this with your Ack below, thank you!

 - Joel


>>  net/mac802154/scan.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
>> index 9b0933a185eb..5c191bedd72c 100644
>> --- a/net/mac802154/scan.c
>> +++ b/net/mac802154/scan.c
>> @@ -52,7 +52,7 @@ static int mac802154_scan_cleanup_locked(struct ieee802=
154_local *local,
>>      request =3D rcu_replace_pointer(local->scan_req, NULL, 1);
>>      if (!request)
>>          return 0;
>> -    kfree_rcu(request);
>> +    kvfree_rcu_mightsleep(request);
>>        /* Advertize first, while we know the devices cannot be removed */=

>>      if (aborted)
>> @@ -403,7 +403,7 @@ int mac802154_stop_beacons_locked(struct ieee802154_l=
ocal *local,
>>      request =3D rcu_replace_pointer(local->beacon_req, NULL, 1);
>>      if (!request)
>>          return 0;
>> -    kfree_rcu(request);
>> +    kvfree_rcu_mightsleep(request);
>>        nl802154_beaconing_done(wpan_dev);
>> =20
>=20
>=20
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
>=20
> regards
> Stefan Schmidt
