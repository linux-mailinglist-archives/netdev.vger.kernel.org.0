Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67F51FAA47
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgFPHpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgFPHpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:45:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF098C05BD43;
        Tue, 16 Jun 2020 00:45:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n24so20453783ejd.0;
        Tue, 16 Jun 2020 00:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9UCZeGHHHKkRG4zqXE/A7RhXHhHKairl1CSt+Zzjpak=;
        b=Cz1fVZIzFqI9PLwQigltSabqGPa014dqi5tTEQERMjzOcSgf7y+ue4y3N0vZZTJSbN
         ZOKE4/X8uLCun3yDYaxUiH58zvDGalQuzZ7f/ugYyXbQeZXuso6jxwiBQp2iL6LMw6yt
         u8DO7WuaQck0yZ05+BcjkhkzWSV9GTaEiJUb6xL0O0YhzVora9je9ie5Sfc1oAgsMRkQ
         HrSWhRxduuJqf0uqkwrxwAqsNzKHQZnxUllF9hzvdL5mdAVZw8kbhQ9owN0CZfidVfdR
         lwJ5Sl2e71hp6PvYdVo9xU0A/Omzi10k2ddiz23eBCncm5z4q4/FGp0rdsmaCdrsHHc+
         wIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9UCZeGHHHKkRG4zqXE/A7RhXHhHKairl1CSt+Zzjpak=;
        b=I4GbN+J65kAhZHKQD+rfXfTA31dkciQPaoubNgnWuIQPGsnwa1T+MBAhjWiDOlVUbZ
         HMMmHb8GYEVS0+Bo/1Wbkkh+Y264WbdxZmFYOIEhsxl68m6e1EhdvPbT04h7MP9+itLr
         e+fflr6ApPaRF94K9r3TXNAP2aQ5MHY+WaKo+p/WxCEnMCik+GfBeOM0s60prdsd5CfT
         rKiSBEP7TsYpV1rATp2mrBd+8pO271omN9hPutOmSHIMc+BGTQEb58OX1ARlCAhalmfk
         hgcAhhyb8fyJPTi1DcaiLSrGyOxCwIG+o3gLIwwyVa6Le+CUF1HVU4O5btYzFyfGrAhR
         f4tw==
X-Gm-Message-State: AOAM531vdNL9z6wuoMLET2HREh887wpaWlE6c3GpFfSH7KEu0yUzjDnS
        NCNlw54c6DJzqYeniTCOY+RVIc+v//vCJfXm2Og=
X-Google-Smtp-Source: ABdhPJy6meDuVQDBwcDUxWt/oUvxUZtl4JuICUdPAZf17Kj+yj3BRrYlPu9XsWDJsU86OiHGTJ1s8o6f04CkYtRK/Io=
X-Received: by 2002:a17:906:3a43:: with SMTP id a3mr1504252ejf.121.1592293518424;
 Tue, 16 Jun 2020 00:45:18 -0700 (PDT)
MIME-Version: 1.0
References: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
In-Reply-To: <1592273581-31338-1-git-send-email-wangxidong_97@163.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 16 Jun 2020 15:44:14 +0800
Message-ID: <CAMDZJNUnsQM93DiP8zGyxEAzRgDogQc7HgMhSE-3WdWJWSsW8A@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH 1/1] openvswitch: fix infoleak in conntrack
To:     Xidong Wang <wangxidong_97@163.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 10:13 AM Xidong Wang <wangxidong_97@163.com> wrote:
>
> From: xidongwang <wangxidong_97@163.com>
>
> The stack object =E2=80=9Czone_limit=E2=80=9D has 3 members. In function
> ovs_ct_limit_get_default_limit(), the member "count" is
> not initialized and sent out via =E2=80=9Cnla_put_nohdr=E2=80=9D.
>
> Signed-off-by: xidongwang <wangxidong_97@163.com>
> ---
>  net/openvswitch/conntrack.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 4340f25..1b7820a 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -2020,6 +2020,7 @@ static int ovs_ct_limit_get_default_limit(struct ov=
s_ct_limit_info *info,
>  {
>         struct ovs_zone_limit zone_limit;
>         int err;
> +       memset(&zone_limit, 0, sizeof(zone_limit));
why not init zone.count =3D=3D 0, instead of memset, because zone_id/limit
will be inited later.
memset uses more cpu cycles.
>         zone_limit.zone_id =3D OVS_ZONE_LIMIT_DEFAULT_ZONE;
>         zone_limit.limit =3D info->default_limit;
> --
> 2.7.4
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev



--=20
Best regards, Tonghao
