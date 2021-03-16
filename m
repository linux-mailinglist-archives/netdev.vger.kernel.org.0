Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4233D012
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhCPIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhCPIot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:44:49 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A8EC06174A;
        Tue, 16 Mar 2021 01:44:49 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c17so4741383pfv.12;
        Tue, 16 Mar 2021 01:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2t2nl6SVqGRT0ENhyt7CpGXaAMJS6RD4WcDr5aSLD14=;
        b=rymkl9UtSvs5N0z9VH+KVNkNYAC03M4PjNAmD80pfp51GMd/G0XsWbnxmeOI67jtVP
         QI3/4oy3E1nN7YeRw3wLdBb3k6YwTZfOhhOlVwNKAnMdC1+snRm7v1Nfqkt1gcWob+K1
         SvmMWaoz5+oluHvCxDQvQlv3JcJu67nAPHmd6ecN//PfmWcQ1GYarslJjtgwjhrXFq2T
         M0TJnqhLCxnEa59FeIyCzDKL4a2dLf+OFAW2dX6isvZCl2XEqFrCyKTg+NtegQj7N04Y
         gsQMnMag/ZaldYJ6SSzkIoh4SOw7MnVH2X6K7yjfXNxQ0Z2GhewtRysnU4zH819+BzX8
         FoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2t2nl6SVqGRT0ENhyt7CpGXaAMJS6RD4WcDr5aSLD14=;
        b=ILrzuZoijwleCr18h38X+Oefu0IEcakqCUqOAhCxVdxCY3nv/QvLiY0lhvFGysxNQi
         HFe6kln3saBm1mX++mM7hbDOLzWa9p3T7ZLzm6emMyL4jO4/I+ujtxZlnYX6aVn4CQc9
         OMqu6MZWvr+6pjd3YyWUq8RSkLPx+5k39dL2pZyfP8tkkB02aapPHVm/+ycXuXTN2Is9
         8vrWdborScfOUx9uOLsu8yiZ+DEmFhR82TIKhS2CEKJizKxfQb3/TrDiENIaXOfWb8ps
         AzVIKa9oMoZxu8kLWy/1rvSt8NOmiTgDFDgJXwoTxXZc/kWXfa3scwlG3zemshgpVnH3
         q72w==
X-Gm-Message-State: AOAM531YtPHks6csScqaSrTT+2ot/E/2CUm15fa1ws2zzPCV1pcU+DcB
        rNgX38juF+40jwvl00H1iSCKaj94rjxZC8OwVIA=
X-Google-Smtp-Source: ABdhPJyjiC2b0uRI6HdeHc5P0Mu0huyazQJ+R6qaD958AArP6XVLFBKVjFaeUb9w046oqEKgPXSe3Lyhrcij8cFZTOg=
X-Received: by 2002:a63:534f:: with SMTP id t15mr3169313pgl.126.1615884289038;
 Tue, 16 Mar 2021 01:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com> <20210311152910.56760-14-maciej.fijalkowski@intel.com>
In-Reply-To: <20210311152910.56760-14-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 16 Mar 2021 09:44:38 +0100
Message-ID: <CAJ8uoz0+Ofu32-QmX1mYka2f52ym=zG_OPyz3wto=pv-brOi-w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 13/17] veth: implement ethtool's
 get_channels() callback
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 4:43 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Libbpf's xsk part calls get_channels() API to retrieve the queue count
> of the underlying driver so that XSKMAP is sized accordingly.
>
> Implement that in veth so multi queue scenarios can work properly.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/veth.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index aa1a66ad2ce5..efca3d45f5c2 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -218,6 +218,17 @@ static void veth_get_ethtool_stats(struct net_device *dev,
>         }
>  }
>
> +static void veth_get_channels(struct net_device *dev,
> +                             struct ethtool_channels *channels)
> +{
> +       channels->tx_count = dev->real_num_tx_queues;
> +       channels->rx_count = dev->real_num_rx_queues;
> +       channels->max_tx = dev->real_num_tx_queues;
> +       channels->max_rx = dev->real_num_rx_queues;
> +       channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_rx_queues);
> +       channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_rx_queues);

Copy and paste error in the above two lines. One of the min entries
should be dev->real_num_tx_queues. Kind of pointless otherwise ;-).

> +}
> +
>  static const struct ethtool_ops veth_ethtool_ops = {
>         .get_drvinfo            = veth_get_drvinfo,
>         .get_link               = ethtool_op_get_link,
> @@ -226,6 +237,7 @@ static const struct ethtool_ops veth_ethtool_ops = {
>         .get_ethtool_stats      = veth_get_ethtool_stats,
>         .get_link_ksettings     = veth_get_link_ksettings,
>         .get_ts_info            = ethtool_op_get_ts_info,
> +       .get_channels           = veth_get_channels,
>  };
>
>  /* general routines */
> --
> 2.20.1
>
