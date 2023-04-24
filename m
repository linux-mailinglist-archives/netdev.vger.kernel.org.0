Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022A96ED1DB
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjDXQAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDXQAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:00:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156C859DF
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:00:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so3937309b3a.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682351999; x=1684943999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kLDgafokn5x18GtTd+H6a14Z4DMxmnCa80D7PeLVP0=;
        b=uYkrKKyUtV1StUmdzNvBAn/Wjmql+OVygRxELaLbibhk0MBZtiaVnJeWhB87271I3+
         qY9m8UD87FWczYLHPvdmQbAyp1K88Mq1XrrxHRgjySCOmO3nCeV8G1DFbHXEEb9j7rg6
         hKcEh5ZXdyUAStZY7FFCGHvVfS48tDTpajhiWZR5QYoQrinybfucQmmfmGfu1gs+7x/i
         HVANjeACLCSHmEQ+D/T0a57DHZgge7NY4l8DFI9W0WjqyqgyBKPU5TENc4oCOfQs4mpx
         p2H5rj6lMIKdqRQ7Qahg879uj7wNWbj4immZh2CWDtZvlQ2JoRj1mu1PfvALlnCCxIEM
         ehfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682351999; x=1684943999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kLDgafokn5x18GtTd+H6a14Z4DMxmnCa80D7PeLVP0=;
        b=iKLBr6JfVWSSg3P+2UIe7K4mwSJa+2i6UQ5DX4V2Q75Ayj9ZdrxmeoAUvFM2AxON2/
         wMh/t+DSXE9+xhwuRWzRPwOlE9OQsmz6aLR4wq/sX+h6gRSwaSG57dQdNITxoXRieBHP
         MrGy2Puhx3cOKmvUePofzvr6jWzoaMr0TH2kUkCrKc5b5ZbBRqZE5FHVUDp6ksgIcA+n
         XhOYcZRnNMageWbtUYwxOMAJB9rdSAm3s1FhBu3qKo4KZv7MEO3mcOJfgA+kLB+zywiH
         oMMOU6ZFqBDsABbHGIAAO+KBlJDPxyQMdVK5tbStyJon89/F/RL/3rxNhjh6tMriwymD
         5Fpw==
X-Gm-Message-State: AAQBX9cT6cFwATcfAHalzuiadrriswROtFQKc3qkCSBuS/UNUD/kyEJp
        jstFOZg+ddFYZELUv7UZGgfPnA==
X-Google-Smtp-Source: AKy350b1M8viTDSsdJd2O7T60H0YZoVte5oecG/7do4ljw0iLolWgbZfu2zHqF3rFIfXaAW+h+E5bQ==
X-Received: by 2002:a05:6a00:1496:b0:63d:4407:b6c with SMTP id v22-20020a056a00149600b0063d44070b6cmr20396535pfu.7.1682351999526;
        Mon, 24 Apr 2023 08:59:59 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s18-20020a056a00195200b0063b96574b8bsm7593251pfk.220.2023.04.24.08.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 08:59:59 -0700 (PDT)
Date:   Mon, 24 Apr 2023 08:59:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [Question] Any plan to write/update the bridge doc?
Message-ID: <20230424085949.4bf52ac0@hermes.local>
In-Reply-To: <ZEakbR71vNuLnEFp@shredder>
References: <ZEZK9AkChoOF3Lys@Laptop-X1>
        <ZEakbR71vNuLnEFp@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 18:46:53 +0300
Ido Schimmel <idosch@nvidia.com> wrote:

> On Mon, Apr 24, 2023 at 05:25:08PM +0800, Hangbin Liu wrote:
> > Hi,
> >=20
> > Maybe someone already has asked. The only official Linux bridge documen=
t I
> > got is a very ancient wiki page[1] or the ip link man page[2][3]. As th=
ere are
> > many bridge stp/vlan/multicast paramegers. Should we add a detailed ker=
nel
> > document about each parameter? The parameter showed in ip link page see=
ms
> > a little brief. =20
>=20
> I suggest improving the man pages instead of adding kernel
> documentation. The man pages are the most up to date resource and
> therefore the one users probably refer to the most. Also, it's already
> quite annoying to patch both "ip-link" and "bridge" man pages when
> adding bridge port options. Adding a third document and making sure all
> three resources are patched would be a nightmare...
>=20
> >=20
> > I'd like to help do this work. But apparently neither my English nor my
> > understanding of the code is good enough. Anyway, if you want, I can he=
lp
> > write a draft version first and you (bridge maintainers) keep working o=
n this. =20
>=20
> I can help reviewing man page patches if you want. I'm going to send
> some soon. Will copy you.
>=20
> >=20
> > [1] https://wiki.linuxfoundation.org/networking/bridge
> > [2] https://man7.org/linux/man-pages/man8/bridge.8.html
> > [3] https://man7.org/linux/man-pages/man8/ip-link.8.html
> >=20
> > Thanks
> > Hangbin =20

Yes, please update the iproute2 man pages.
=46rom there, I can make the old wiki just be a reference to them.
And Michael will pickup the man7.org versions from the current iproute2.

The iproute2 git tree is single source of current documentation please.
