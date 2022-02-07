Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E94AC283
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442486AbiBGPFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244609AbiBGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:03:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19F01C0401C7
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 07:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644246194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxF/KRvojcGP3XsaFuJbiGl5YjK5EzOxT0MESeC2AXA=;
        b=dv5Y3wOk9VhfM2V1bmTGu9jHVWN8RwSaYmLbtPKgFaOFfN1hCc2JgZOiUyASi8eP3+2Iq7
        uaMD/G9MBINKsJfpm7yid19dhQAc1Im9TRvt6DdH8w99wIBsUdbkBuUg5exAa8iAylA58b
        /s+U/HkOT3LDwwO6uDqvH9pDl8dTz54=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-1mBcwiO1M9mzW4josS38AQ-1; Mon, 07 Feb 2022 10:03:13 -0500
X-MC-Unique: 1mBcwiO1M9mzW4josS38AQ-1
Received: by mail-io1-f72.google.com with SMTP id q24-20020a5d8358000000b006133573a011so9241921ior.23
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 07:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dxF/KRvojcGP3XsaFuJbiGl5YjK5EzOxT0MESeC2AXA=;
        b=yKnwxj86TjgiUnVbSEcNXbNJ9gU8AzmZZHkkX+3IrZ9c1/l39PlY7X2CriXeIY/XO/
         mF0HOa3kqzFd0i8bj8Tu7q9XoSu6uYIw7RviD4jrO8Tx56c7ykkWsx9W1TVSJ+qRZdT+
         NYe//ZH6RcEyDiF7D+LVlIqnY0sPSRaxlILif8QsFFt538WnkQpQBTh1CHLV+0wOrOlH
         m8bgCjS258XRXBTwyv9EClHZojguhIkfsQLdxF9PKYxzfqkcNSYDE+ILlf3qPhneIlsG
         egBKhdvrADhWCYVcWnMX88yFEMH2vhoTxpjK5wxBiHp0wRjoOnB+DAmqzn+yuBBThfN8
         rMqA==
X-Gm-Message-State: AOAM531JMsC+GVzSv6FMWQGL8TUfVsKkbqtrDNlI6rwenLXtJLXlA+x2
        FoXJcXSkPf9Yk5F7e5surhXD7q8P4+gD8DLPxQWSbh6ccu6gJ5+kMYF/uqTcZF7NWJKy1vEA43R
        ppSRTXJaeqemn3ZcmNHdlDgrP8wcMWtSM
X-Received: by 2002:a05:6e02:4cd:: with SMTP id f13mr4596033ils.246.1644246192542;
        Mon, 07 Feb 2022 07:03:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYii+1llQovJZGqjtsXOT/DdGJZsB2HazJG1Yp8W4WjJoZMxDwLh+KvEsJbiheznda4IWSmA1vC42T69Hzy/c=
X-Received: by 2002:a05:6e02:4cd:: with SMTP id f13mr4596015ils.246.1644246192308;
 Mon, 07 Feb 2022 07:03:12 -0800 (PST)
MIME-Version: 1.0
References: <20220128151922.1016841-1-ihuguet@redhat.com> <20220128151922.1016841-2-ihuguet@redhat.com>
 <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 7 Feb 2022 16:03:01 +0100
Message-ID: <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 11:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 28 Jan 2022 16:19:21 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > Handling channels from CPUs in different NUMA node can penalize
> > performance, so better configure only one channel per core in the same
> > NUMA node than the NIC, and not per each core in the system.
> >
> > Fallback to all other online cores if there are not online CPUs in loca=
l
> > NUMA node.
>
> I think we should make netif_get_num_default_rss_queues() do a similar
> thing. Instead of min(8, num_online_cpus()) we should default to
> num_cores / 2 (that's physical cores, not threads). From what I've seen
> this appears to strike a good balance between wasting resources on
> pointless queues per hyperthread, and scaling up for CPUs which have
> many wimpy cores.
>

I have a few busy weeks coming, but I can do this after that.

With num_cores / 2 you divide by 2 because you're assuming 2 NUMA
nodes, or just the plain number 2?


--=20
=C3=8D=C3=B1igo Huguet

