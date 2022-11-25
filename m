Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D94638DA7
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKYPsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKYPsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:48:01 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19B41901C
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:47:58 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b12so7374527wrn.2
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enlI4vPPBNimbpu3uWHLv5u1ZdCpL4iqYpp5/6FLkLI=;
        b=Keo7eS1kLOyu/5/z+bFjtnIOirhkdoFJoh0Vt/S9blFvLbZ8icDVIMhQEKpQ3QPzFO
         aiA35c5pGkmBvW4Gflh0LcG27Srv+dvQXXeDEQPrCFKA9Esxr4q9LYJINJD84zqUKMF9
         Ss2s5pksVJvpXjtCBEiEzh8ct08dvWpuwtmBEmQSILE84UDWg8VeJ9ZCgaZGP0PBoIU7
         HkgzXpyjU+7WziOaRQr6tS9Z+T0Y6knQ5HJihyqF1tw1E2o/u1NBpXHOQ0FB9qU0Af6A
         g1Z7ZGTP7uNKF6feFpKYJQ9khmrf3b0uRpkQLk+oaeUWdqHw8vc1zUC89/J3RpeVARDa
         rDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enlI4vPPBNimbpu3uWHLv5u1ZdCpL4iqYpp5/6FLkLI=;
        b=EhmgeG6oOKW0VivmvUgSVlafU8AxqCzUKgJn6RKLNVE8MZFVJpiL3tIDpKPIuCPZ0y
         v2XTvDW1y0XsLQ78lUfJfSeL0AQKIvoVeJg630W0xOWYD6HSxJqwMGTk3N6BCtINetjc
         izxV2E6Krap7lb7xE9RYWNf559uQ47mV/chCIA0Z5kz5Tg2m5/LMBerDNNb3L2mbcLoh
         bq5Cizeh56cHeU8y2T6JHW5VwQ9aJJWhw0Rj5bPy2ltWn2jLXX7tHrtn3Oz+yMux8eUz
         b9cy2X08mOM5z5Wj1oX8xRioXX10+gr/gAjjyLKczVzg6bN9iKx3dQOaxpRT7JbvvyTh
         N2EQ==
X-Gm-Message-State: ANoB5pn0RdpRqnOuprwIyo9r6TVifpy84vJJIS+3+tFLMiMcJbo9dFk5
        sg2Vx0Ufq+6eC5exu6TeQwSEx4NdJIQ=
X-Google-Smtp-Source: AA0mqf75zf+eXp5e3IwscXcTGLfo5bkFv7C7hrSBhPS5EAiJ/ThApBluLHhK4K+SZX3cU+bz0kAiBA==
X-Received: by 2002:adf:e508:0:b0:236:588f:b5d with SMTP id j8-20020adfe508000000b00236588f0b5dmr12331461wrm.255.1669391277137;
        Fri, 25 Nov 2022 07:47:57 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id x8-20020adff0c8000000b00241f632c90fsm4543736wro.117.2022.11.25.07.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:47:56 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH v2 net-next 0/6] Remove uses of kmap_atomic()
Date:   Fri, 25 Nov 2022 16:47:55 +0100
Message-ID: <2325231.NG923GbCHz@suse>
In-Reply-To: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On mercoled=EC 23 novembre 2022 21:52:13 CET Anirudh Venkataramanan wrote:
> kmap_atomic() is being deprecated. This little series replaces the last
> few uses of kmap_atomic() in the networking subsystem.
>=20
> This series triggered a suggestion [1] that perhaps the Sun Cassini,
> LDOM Virtual Switch Driver and the LDOM virtual network drivers should be
> removed completely. I plan to do this in a follow up patchset. For
> completeness, this series still includes kmap_atomic() conversions that
> apply to the above referenced drivers. If for some reason we choose to not
> remove these drivers, at least they won't be using kmap_atomic() anymore.
>=20
> Also, the following maintainer entries for the Chelsio driver seem to be
> defunct:
>=20
>   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>   Rohit Maheshwari <rohitm@chelsio.com>
>=20
> I can submit a follow up patch to remove these entries, but thought
> maybe the folks over at Chelsio would want to look into this first.
>=20
> Changes v1 -> v2:
>   Use memcpy_from_page() in patches 2/6 and 4/6
>   Add new patch for the thunderbolt driver
>   Update commit messages and cover letter
>=20
> [1]
> https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel=
=2Ecom
> /T/#m3da3759652a48f958ab852fa5499009b43ff8fdd
>=20
> Anirudh Venkataramanan (6):
>   ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
>   sfc: Use kmap_local_page() instead of kmap_atomic()
>   cassini: Use page_address() instead of kmap_atomic()
>   cassini: Use memcpy_from_page() instead of k[un]map_atomic()
>   sunvnet: Use kmap_local_page() instead of kmap_atomic()
>   net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()
>=20
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 26 +++++-----
>  drivers/net/ethernet/sfc/tx.c                 |  4 +-
>  drivers/net/ethernet/sun/cassini.c            | 48 ++++++-------------
>  drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
>  drivers/net/thunderbolt.c                     |  8 ++--
>  5 files changed, 35 insertions(+), 55 deletions(-)
>=20
>=20
> base-commit: e80bd08fd75a644e2337fb535c1afdb6417357ff
> --
> 2.37.2

I noticed too late that your patches were already applied. The message from=
=20
the patchwork bot was the latest. I'm sorry for the noise: my tags were=20
unnecessary but I didn't yet know :-(

However, again thanks for helping with these conversions,

=46abio



