Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4663D8BD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiK3PEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiK3PEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:04:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC534F63
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 07:04:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o7-20020a05600c510700b003cffc0b3374so1632457wms.0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 07:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CblclVSvG4Ad9bZLQNsoiuQd96HmBkiRb6NfAARjS/c=;
        b=HM/rT674Cw7XYkk+NIYJgiFq/CYBV+FqXchCWGc2wwU+ShH9LHTMcKaCvWICs0n0WO
         C9Y1J2wdvrHjc2IwXtoWaMzaZ3vl6wkf8UDj2GkJVYrqGHfaUg8/4zsXMftLv2Q/PIiW
         EcJHT6ahNmCIGO1UWHPVJcr1nfvKjxgJxhtJXUE/Ga9+qCrW8GK2Bt/bgmet03Hs3yqV
         YQlkRgDqS3SIWK3GlgjrKaB010sLkWEfOKdyBwteRM/T5nMxf5VdZfZZJy21mcEdzPZy
         3hXw17MxOUOieIMDovagMBgU1yNKpQ7OyfDltJTQ/LYWdNk8sYHrOajWXXUyieeRzj3V
         yF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CblclVSvG4Ad9bZLQNsoiuQd96HmBkiRb6NfAARjS/c=;
        b=tSlT545Po4fKXJ4F/2atsBFQbbbCCxMdGbtrjuhgPHgtCvd9f3sYgQ0OXjRScfS96g
         d/7AnIztA+1XU1W5+0jIwtlpxAJiFCwKFQ8jz3VlTdiIJ3CSsH0FHgH4I/2qUGXrRBvJ
         g0uYHTN3uRC3s/E9Erwot2ONBIoHYzH7XjwzGnikGlqxQ/f1xiGleLF9ZBXroI6b729n
         XzQs+IHKlNLDn2L+/zQfX66Pkk77goOExIAtRfbP4nyGN226WvymfuyRdd+Yp+oKh7tG
         fMY5vBwAw4W4HGUAr8x6uqwg/S2p5if2kuWCwWmgPcUHhAZNxPXm7wTW37Dr2oeJMTjx
         C2Wg==
X-Gm-Message-State: ANoB5pldwliPj7AncuaeJr+KItjTbKSf+GnwdmI2ZrgxlHloDQSH2O2K
        Pj6bpBBP5XbtWOHpYovIYeaw6ddbw14NfHxnfjg=
X-Google-Smtp-Source: AA0mqf4Mxz5Py5I0tleN6GShdLuDpqtzPHoVQabVmDV4b+rnyrvFW+/4dt6FGXTQxVZbmcHbur0zz00+NpBs1HvNLAQ=
X-Received: by 2002:a05:600c:4e46:b0:3d0:57ea:3188 with SMTP id
 e6-20020a05600c4e4600b003d057ea3188mr11635905wmq.28.1669820674281; Wed, 30
 Nov 2022 07:04:34 -0800 (PST)
MIME-Version: 1.0
References: <20221130124616.1500643-1-dnlplm@gmail.com>
In-Reply-To: <20221130124616.1500643-1-dnlplm@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 30 Nov 2022 07:04:21 -0800
Message-ID: <CAA93jw58hiRprhvCiek+YSOSb_y2QsQVWQMzrPARgGJGj9gEew@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/3] add tx packets aggregation to ethtool and rmnet
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 5:15 AM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Hello maintainers and all,
>
> this patchset implements tx qmap packets aggregation in rmnet and generic
> ethtool support for that.
>
> Some low-cat Thread-x based modems are not capable of properly reaching t=
he maximum
> allowed throughput both in tx and rx during a bidirectional test if tx pa=
ckets
> aggregation is not enabled.
>
> I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 b=
ased modem
> (50Mbps/150Mbps max throughput). What is actually happening is pictured a=
t
> https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view

Thank you for documenting which device this is. Is it still handing in
150ms of bufferbloat in good conditions,
and 25 seconds or so in bad?

> Testing with iperf TCP, when rx and tx flows are tested singularly there'=
s no issue
> in tx and minor issues in rx (not able to reach max throughput). When the=
re are concurrent
> tx and rx flows, tx throughput has an huge drop. rx a minor one, but stil=
l present.
>
> The same scenario with tx aggregation enabled is pictured at
> https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/view
> showing a regular graph.
>
> This issue does not happen with high-cat modems (e.g. SDX20), or at least=
 it
> does not happen at the throughputs I'm able to test currently: maybe the =
same
> could happen when moving close to the maximum rates supported by those mo=
dems.
> Anyway, having the tx aggregation enabled should not hurt.
>
> The first attempt to solve this issue was in qmi_wwan qmap implementation=
,
> see the discussion at https://lore.kernel.org/netdev/20221019132503.6783-=
1-dnlplm@gmail.com/
>
> However, it turned out that rmnet was a better candidate for the implemen=
tation.
>
> Moreover, Greg and Jakub suggested also to use ethtool for the configurat=
ion:
> not sure if I got their advice right, but this patchset add also generic =
ethtool
> support for tx aggregation.
>
> The patches have been tested mainly against an MDM9207 based modem throug=
h USB
> and SDX55 through PCI (MHI).
>
> v2 should address the comments highlighted in the review: the implementat=
ion is
> still in rmnet, due to Subash's request of keeping tx aggregation there.
>
> Thanks,
> Daniele
>
> Daniele Palmas (3):
>   ethtool: add tx aggregation parameters
>   net: qualcomm: rmnet: add tx packets aggregation
>   net: qualcomm: rmnet: add ethtool support for configuring tx
>     aggregation
>
>  Documentation/networking/ethtool-netlink.rst  |  17 ++
>  .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
>  .../ethernet/qualcomm/rmnet/rmnet_config.h    |  20 ++
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  18 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   6 +
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 191 ++++++++++++++++++
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  54 ++++-
>  .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 +
>  include/linux/ethtool.h                       |  12 +-
>  include/uapi/linux/ethtool_netlink.h          |   3 +
>  net/ethtool/coalesce.c                        |  22 +-
>  11 files changed, 342 insertions(+), 7 deletions(-)
>
> --
> 2.37.1
>


--=20
This song goes out to all the folk that thought Stadia would work:
https://www.linkedin.com/posts/dtaht_the-mushroom-song-activity-69813666656=
07352320-FXtz
Dave T=C3=A4ht CEO, TekLibre, LLC
