Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D971F6E2896
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjDNQoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDNQoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:44:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E7599
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:44:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o2so18843193plg.4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681490646; x=1684082646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHnZOG9p5K5iFbMTLwF1UTbK06Pq5B/jcNadLRcTA4o=;
        b=e+reg1+Qdnmzj8SfImUsK+QKGGf4PR+on5Zvdy+eJZTUMOxUVFzSRbuDD1OvuAetRD
         NvzHsNO06zcMuPszDcaID2cV6+7MR3+R60TKCqWn1prkARtUrJoplc1ffZoKQnWeOLCz
         1hBnPgaUCMqmz4p08g3nM+DmtCOyQ3Djd+IHltSOvkjPpSdBjsf+7/tbmKg0RJbwzadV
         PbaFeKBH4jkSxaL8h4y1gViLj6ugH1lXd5jc93qXXpG0fWUuALtxvyNWmqDTn0hBu5M6
         ePl6Vj4lA7phVkWPcwKQsN6g9FJscN9xFvZWiMzQ0Jrezh1HufnbuY/5lleFNvBczZXe
         1iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681490646; x=1684082646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rHnZOG9p5K5iFbMTLwF1UTbK06Pq5B/jcNadLRcTA4o=;
        b=Ft/U8py1wOaCjnYV3bpO9825GX+pasUbk+mm2SpVmS58dNuMDPsWQLibuSjKradrd6
         LzN8ShV2WZjxPrKhaoIPgijR5h0BO1tolXFJx5pB7C2aK7mh0HLhpDmPxQC+pRex3l3f
         NFnV7FeTLA2HH9hgQgz+hp2JqZqgqpxb46OoEgE4AV5dD/smSF+x9s3fedjokOwPk6x1
         GSJDRmSwGxMn96f+XDtVpmOiVnErEzg+Erl3++43NRaRFXo1K8D5utWul//e2/eGc2T8
         cXIzBuLrXApgWCHDxkuPPRGl0PPajaeSL0E/MLl+J4p6Vo51RkeYR24CRPEAkrYEg/eR
         jlXw==
X-Gm-Message-State: AAQBX9fpNPyRkJ8P7NWfZGDdEpnaduHwmaU6MqW2clQSbS7asUVRabpc
        fJTTh+w051SBqQG0ItTwzBy5dzyQ5JgqmQ/jK7oWoQ==
X-Google-Smtp-Source: AKy350aEscWQR7bY75/BPDEL1wMw0B2tH6slP1toeJOk//qHPhH4tfl5D8j+Uwp0p/E8pMvX2PrPpQ==
X-Received: by 2002:a17:902:d510:b0:19d:778:ff5 with SMTP id b16-20020a170902d51000b0019d07780ff5mr4473555plg.15.1681490645720;
        Fri, 14 Apr 2023 09:44:05 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090aec1300b00240aff612f0sm3088288pjy.5.2023.04.14.09.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 09:44:05 -0700 (PDT)
Date:   Fri, 14 Apr 2023 09:44:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Lars Ekman <uablrek@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: iproute2 bug in json output for encap
Message-ID: <20230414094403.4d7db9df@hermes.local>
In-Reply-To: <65b59170-28c2-2e3b-f435-2bdcc6d7b10c@gmail.com>
References: <e3bfc8e6-5522-4e65-373e-976388533765@gmail.com>
        <20230414082103.1b7c0d82@hermes.local>
        <cf099564-2b3c-e525-82cd-2d8065ba7fb3@gmail.com>
        <65b59170-28c2-2e3b-f435-2bdcc6d7b10c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 18:26:03 +0200
Lars Ekman <uablrek@gmail.com> wrote:

> Hi again,
>=20
> Digging a little deeper I see that the double "dst" items will cause
> problems with most (all?) json parsers. I intend to use "go" and json
> parsing will be parsed to a "map" (hash-table) so duplicate keys will
> not work.
>=20
> https://stackoverflow.com/questions/21832701/does-json-syntax-allow-dupli=
cate-keys-in-an-object
>=20
> IMHO it would be better to use a structured "encap" item. Something like;
>=20
> [ {
> =C2=A0=C2=A0=C2=A0 "dst": "192.168.11.0/24",
> =C2=A0=C2=A0 =C2=A0"encap": {
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "protocol": "ip6",
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "id": 0,
> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 "src": "::",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "dst": "fd00::c0a8:2dd",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "hoplimit": 0,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tc": 0
> =C2=A0=C2=A0 =C2=A0},
> =C2=A0=C2=A0=C2=A0 "scope": "link",
> =C2=A0=C2=A0=C2=A0 "flags": [ ]
> } ]
>=20
> Best Regards,
>=20
> Lars Ekman

That makes sense, not sure if it would break any existing scripts.
Probably true for ip link as well.

