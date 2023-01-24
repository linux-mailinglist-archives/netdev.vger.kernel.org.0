Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D12167A058
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjAXRnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAXRnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:43:07 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF746725
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:43:06 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k18so15454156pll.5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kVpn5SMLD9pIiP0+8Xm3dHvf5ZmENfuH2Pxsjs07rZM=;
        b=Ri/8pJDvge0Awmaf5DNXwCqG+o70l5xFTNqs4AFQo1KC32MlZFz/pV8vYHoM6uKR+j
         qhBXLXJwffqEN/YZedW4481g+haZdvtdVYHEZnNHvgPoM8qITPUdlHTy1segQg5UnlnV
         dJUm2cHCSEZ54SGGPcVHPjbQwli1dtjJlXpYNykQ2G9mUivTaKUWZ4q33Wn1DxmyCMch
         DPrJGTZaA0oEtRgVzdkiBus2MrIPe0VwH0GFu/MSVyADY8Ggd6FM/8DC22itey77m0O5
         1/Dy6oE3d4IX8cvnMKArYgb+/8Ap27LdjqyLa0oejvqFffoAVKkdaPXOuuFqV1y3wzl6
         4E9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVpn5SMLD9pIiP0+8Xm3dHvf5ZmENfuH2Pxsjs07rZM=;
        b=bp011XFkR//9UqrZLILk+b63m+YAt04N2ux1WVHpnf2A0YBv3P0OotX4NvFIpOGrBm
         YHfZwGiMuB95WFG+vAxad3xff9Q+jqxZrPUCh0a7FkWjpIIafgXysfpQRUtpk+S2CH7i
         MgmGjMkuU74L4oaADinfAQh+LaGrzppfZ/LxfcscRmyJTEc/lVkue6/5MaP66LvsR6fI
         wukhnkf0Gp68c9pYdtcCeVPJYsBo6l7Ty1QHocM7Qf9bCw9J9xVfSzlDH4frQWvKVD2W
         j2aqKWE3nFLCae0KY0yYRGOkTRDXxNk+csM538mbW+UvdEUFtig8jll+Vg1BfBSW9xs3
         SwMA==
X-Gm-Message-State: AFqh2korRNBLy8ubTt+9/uzDE/DEORDEQyXXOtj9jM5WICZjsTNEwDB3
        6XN2JNiHZZZwQ81A1RvWdHF8S8Wsk9dXYzsnlgjiYg==
X-Google-Smtp-Source: AMrXdXu84A7RJILwgoKpk8B12punuj2R/JnqdpZOPgedaESUceXYwyUtZtIMeIQMeIEsAhgseHygWwjNvsCc5jsCxno=
X-Received: by 2002:a17:90a:2c4d:b0:229:2410:ef30 with SMTP id
 p13-20020a17090a2c4d00b002292410ef30mr3250936pjm.66.1674582185932; Tue, 24
 Jan 2023 09:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com> <20230119221536.3349901-18-sdf@google.com>
 <71be95ee-b522-b3db-105a-0f25d8dc52cb@redhat.com>
In-Reply-To: <71be95ee-b522-b3db-105a-0f25d8dc52cb@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 24 Jan 2023 09:42:53 -0800
Message-ID: <CAKH8qBvK-tJxQwBsUvQZ39KyhyAbd76H1xhdzmzeKbbN5Hzq7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 17/17] selftests/bpf: Simple program to dump
 XDP RX metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 7:26 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> Testing this on mlx5 and I'm not getting the RX-timestamp.
> See command details below.

CC'ed Toke since I've never tested mlx5 myself.
I was pretty close to getting the setup late last week, let me try to
see whether it's ready or not.

> On 19/01/2023 23.15, Stanislav Fomichev wrote:
> > To be used for verification of driver implementations. Note that
> > the skb path is gone from the series, but I'm still keeping the
> > implementation for any possible future work.
> >
> > $ xdp_hw_metadata <ifname>
>
> sudo ./xdp_hw_metadata mlx5p1
>
> Output:
> [...cut ...]
> open bpf program...
> load bpf program...
> prepare skb endpoint...
> XXX timestamping_enable(): setsockopt(SO_TIMESTAMPING) ret:0
> prepare xsk map...
> map[0] = 3
> map[1] = 4
> map[2] = 5
> map[3] = 6
> map[4] = 7
> map[5] = 8
> attach bpf program...
> poll: 0 (0)
> poll: 0 (0)
> poll: 0 (0)
> poll: 1 (0)
> xsk_ring_cons__peek: 1
> 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> rx_timestamp: 0
> rx_hash: 2773355807
> 0x1821788: complete idx=8 addr=8000
> poll: 0 (0)
>
> The trace_pipe:
>
> $ sudo cat /sys/kernel/debug/tracing/trace_pipe
>            <idle>-0       [005] ..s2.  2722.884762: bpf_trace_printk:
> forwarding UDP:9091 to AF_XDP
>            <idle>-0       [005] ..s2.  2722.884771: bpf_trace_printk:
> populated rx_hash with 2773355807
>
>
> > On the other machine:
> >
> > $ echo -n xdp | nc -u -q1 <target> 9091 # for AF_XDP
>
> Fixing the source-port to see if RX-hash remains the same.
>
>   $ echo xdp | nc --source-port=2000 --udp 198.18.1.1 9091
>
> > $ echo -n skb | nc -u -q1 <target> 9092 # for skb
> >
> > Sample output:
> >
> >    # xdp
> >    xsk_ring_cons__peek: 1
> >    0x19f9090: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> >    rx_timestamp_supported: 1
> >    rx_timestamp: 1667850075063948829
> >    0x19f9090: complete idx=8 addr=8000
>
> xsk_ring_cons__peek: 1
> 0x1821788: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
> rx_timestamp: 0
> rx_hash: 2773355807
> 0x1821788: complete idx=8 addr=8000
>
> It doesn't look like hardware RX-timestamps are getting enabled.
>
> [... cut to relevant code ...]
>
> > diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > new file mode 100644
> > index 000000000000..0008f0f239e8
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > @@ -0,0 +1,403 @@
> [...]
>
> > +static void timestamping_enable(int fd, int val)
> > +{
> > +     int ret;
> > +
> > +     ret = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
> > +     if (ret < 0)
> > +             error(-1, errno, "setsockopt(SO_TIMESTAMPING)");
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> [...]
>
> > +     printf("prepare skb endpoint...\n");
> > +     server_fd = start_server(AF_INET6, SOCK_DGRAM, NULL, 9092, 1000);
> > +     if (server_fd < 0)
> > +             error(-1, errno, "start_server");
> > +     timestamping_enable(server_fd,
> > +                         SOF_TIMESTAMPING_SOFTWARE |
> > +                         SOF_TIMESTAMPING_RAW_HARDWARE);
> > +
>
> I don't think this timestamping_enable() with these flags are enough to
> enable hardware timestamping.
>
> --Jesper
>
