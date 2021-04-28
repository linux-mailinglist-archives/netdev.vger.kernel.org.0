Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E6E36D228
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 08:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbhD1GZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 02:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1GZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 02:25:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C875CC061574;
        Tue, 27 Apr 2021 23:24:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id zg3so11266859ejb.8;
        Tue, 27 Apr 2021 23:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FJpyexBJMRWoohWakaErFpopc7jUV93q9mqmN6OQ+5E=;
        b=CKsVc4iWBgbEYKP6Q/z88udotn7alDlUNxrK/7onujzp5+N8RuxvzSqnFykFvfD85b
         tCmheHJLbupv1lzXCDWCBNC8h3RCceO7ZyrMicISIinqvJYtxDL0tleO7JgUlGjwuSYf
         ODcvLzj8I3gkpxHqRjDhSn/FHaWHCz1CacMQpDg0+vNlant0qOJy/4/W2dQ1zvznOw+3
         8TpHUDPLGj+0iGwGWfZ/WvSfDYzpXwQEnYAdGtu9ctdpG/YEfqqYYSdWUz4XNUGVWB7G
         yyvr81DAzuA2PQWycL9P2sHWh+YvNvMMlgNrrdkB0CcTMroRHPAXTMDRPKWa5hQ3ny0a
         FcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FJpyexBJMRWoohWakaErFpopc7jUV93q9mqmN6OQ+5E=;
        b=Au+iPP4NBQ1cc9zLPOr2lo16mamLpwen/5XYtElqCiawnJ6CyJbCTCcUYqrIwlM8SV
         AZyouIwKx+BhSXiy/AMqqsO1NYBuqjNPD3V2vUJyXouqC57fbWR7WC8HmxqIB2G1mF9j
         VxOo6tcRqa7YjVUEDweDTKwK4AIShZ9RqoEnb7SNQh1lHOFOJeSAjUWQTgv0bzsmxhAj
         gvOoQOcnZlztG5D2UtwtFgy8xkq9N6ffiy9fnjkq868CeF+8s8ML1bGMTtF1UWwLIzN/
         kJ/bBZruWu6bwhG6AtUsu8gRGn5joqJxcHn136SPJzh13c7axj9V1brw7f3lr3Hcg4yE
         y4Xg==
X-Gm-Message-State: AOAM5312xGBahXpYl+QJldOfoQgZVaIUYgrGjHBOuNDxUGYem/epHNLK
        eVJh5No8lHtiZHEu1WrAjz71u28iM/+0XCbu5xk=
X-Google-Smtp-Source: ABdhPJwofkBXdapf3IZcQgeOf2LVxlfjiCmuDgNF1LZkF9bBrSruYVDHzlDD14oN+dR44SC7JPtN6pCgsfN7VcXKaPg=
X-Received: by 2002:a17:907:33ce:: with SMTP id zk14mr14148638ejb.372.1619591097442;
 Tue, 27 Apr 2021 23:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210421135747.312095-1-i.maximets@ovn.org>
In-Reply-To: <20210421135747.312095-1-i.maximets@ovn.org>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 28 Apr 2021 14:24:10 +0800
Message-ID: <CAMDZJNVQ64NEhdfu3Z_EtnVkA2D1DshPzfur2541wA+jZgX+9Q@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size calculation
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andy Zhou <azhou@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, William Tu <u9012063@gmail.com>,
        Jean Tourrilhes <jean.tourrilhes@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 9:57 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> Implementation of meters supposed to be a classic token bucket with 2
> typical parameters: rate and burst size.
>
> Burst size in this schema is the maximum number of bytes/packets that
> could pass without being rate limited.
>
> Recent changes to userspace datapath made meter implementation to be
> in line with the kernel one, and this uncovered several issues.
>
> The main problem is that maximum bucket size for unknown reason
> accounts not only burst size, but also the numerical value of rate.
> This creates a lot of confusion around behavior of meters.
>
> For example, if rate is configured as 1000 pps and burst size set to 1,
> this should mean that meter will tolerate bursts of 1 packet at most,
> i.e. not a single packet above the rate should pass the meter.
> However, current implementation calculates maximum bucket size as
> (rate + burst size), so the effective bucket size will be 1001.  This
> means that first 1000 packets will not be rate limited and average
> rate might be twice as high as the configured rate.  This also makes
> it practically impossible to configure meter that will have burst size
> lower than the rate, which might be a desirable configuration if the
> rate is high.
>
> Inability to configure low values of a burst size and overall inability
> for a user to predict what will be a maximum and average rate from the
> configured parameters of a meter without looking at the OVS and kernel
> code might be also classified as a security issue, because drop meters
> are frequently used as a way of protection from DoS attacks.
>
> This change removes rate from the calculation of a bucket size, making
> it in line with the classic token bucket algorithm and essentially
> making the rate and burst tolerance being predictable from a users'
> perspective.
>
> Same change proposed for the userspace implementation.
Hi Ilya
If we set the burst size too small, the meters of ovs don't work.  For example,
ovs-ofctl -O OpenFlow13 add-meter br-int "meter=1 kbps stats burst
bands=type=drop rate=10000 burst_size=12"
ovs-ofctl -O OpenFlow13 add-flow br-int "in_port=$P0 action=meter=1,output:$P1"
but the rate of port P1 was 5.61 Mbit/s
or
ovs-ofctl -O OpenFlow13 add-meter br-int "meter=1 kbps stats burst
bands=type=drop rate=10000 burst_size=1"
but the rate of port P1 was 0.

the length of packets is 1400B.
I think we should check whether the band->burst_size >= band->burst_rate ?

I don't test the userspace meters.
> Fixes: 96fbc13d7e77 ("openvswitch: Add meter infrastructure")
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>
> The same patch for the userspace datapath:
>   https://patchwork.ozlabs.org/project/openvswitch/patch/20210421134816.311584-1-i.maximets@ovn.org/
>
>  net/openvswitch/meter.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 15424d26e85d..96b524ceabca 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -392,7 +392,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
>                  *
>                  * Start with a full bucket.
>                  */
> -               band->bucket = (band->burst_size + band->rate) * 1000ULL;
> +               band->bucket = band->burst_size * 1000ULL;
>                 band_max_delta_t = div_u64(band->bucket, band->rate);
>                 if (band_max_delta_t > meter->max_delta_t)
>                         meter->max_delta_t = band_max_delta_t;
> @@ -641,7 +641,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
>                 long long int max_bucket_size;
>
>                 band = &meter->bands[i];
> -               max_bucket_size = (band->burst_size + band->rate) * 1000LL;
> +               max_bucket_size = band->burst_size * 1000LL;
>
>                 band->bucket += delta_ms * band->rate;
>                 if (band->bucket > max_bucket_size)
> --
> 2.26.3
>


-- 
Best regards, Tonghao
