Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C043C222E
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 12:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhGIK1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:27:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232006AbhGIK1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625826296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/6iC91tON0SvOjlhn5PG16QP2f30snIS3eM6eOcnmo=;
        b=fpjGanuErMfn69oOMYp9qWff1/vfjaT4aW9uAjjr2QUS+FemmqKBMVal4hB6pqu2fIvbru
        cLI15FiidODhEHgTxK3WH2o/taKNk81q+FSoH1qi1mrHPOqoz+pqy5Gw3h3xsNBndJhmnL
        qUUnURhb3UCFpv2rTM1sFfhyuYz5YK4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-DJ2gE_QnNWObPRIPHPdTWQ-1; Fri, 09 Jul 2021 06:24:53 -0400
X-MC-Unique: DJ2gE_QnNWObPRIPHPdTWQ-1
Received: by mail-ej1-f70.google.com with SMTP id lb20-20020a1709077854b02904c5f93c0124so2928741ejc.14
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 03:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=s/6iC91tON0SvOjlhn5PG16QP2f30snIS3eM6eOcnmo=;
        b=qzuGBR4PSVKMlb5FUtHnKFxDahsLO3UuYuXsmujdG6ZGj+A0SJdfho17JsVOenknsQ
         AEudk8RRIObPF0E9JFdsdPexco7pB6y2TNA4aDKK5Vsbh2a0QoWVfvU/UX/ZxO8ymZ9T
         NOPpTnQ8km21X13RWxJoH1wUBxrhF4DzJYC6Y5raGXo4KKX3kPTmS5py8kbldBtZNoc2
         V19rp3ksDoz2IDoB5W4+gN/bZNAbJs81CDo1qM1goEqpW4JAUshUSyr1rbmfbuoVOTzB
         dlHRFpyo3+pggze1UKkKAoCLsrWObrhxCz0t4n80nFCrvrW4by4BvmPW8bAqldNvYzcz
         mhdw==
X-Gm-Message-State: AOAM5300HYHqsUR4LHYWiO+xJpXS3RtI8qIjlUrE7eWLr584hA6toqSh
        zwJO7d2grme44G8acnDS8g2xT3MIybeIDAYjjVZflRXXF9G03xmQNc1VCVqeuP+pRNsKTZsnA2R
        LjOlY7X+Cddv85aJO
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr36975010ejc.408.1625826291357;
        Fri, 09 Jul 2021 03:24:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsbfVxRZvXh93kGn0PUefHuB44OcOh6WxNC7Y1P3oD+AXEyd7HB5R6uBgDq5HUXBw6iJbK0A==
X-Received: by 2002:a17:907:1b22:: with SMTP id mp34mr36974973ejc.408.1625826290961;
        Fri, 09 Jul 2021 03:24:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j19sm2775572edw.43.2021.07.09.03.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 03:24:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 96DCE180733; Fri,  9 Jul 2021 12:24:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 2/3] veth: make queues nr configurable via kernel
 module params
In-Reply-To: <480e7a960c26c9ab84efe59ed706f1a1a459d38c.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
 <480e7a960c26c9ab84efe59ed706f1a1a459d38c.1625823139.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Jul 2021 12:24:48 +0200
Message-ID: <875yxjvl73.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> This allows configuring the number of tx and rx queues at
> module load time. A single module parameter controls
> both the default number of RX and TX queues created
> at device registration time.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 10360228a06a..787b4ad2cc87 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -27,6 +27,11 @@
>  #include <linux/bpf_trace.h>
>  #include <linux/net_tstamp.h>
>  
> +static int queues_nr	= 1;
> +
> +module_param(queues_nr, int, 0644);
> +MODULE_PARM_DESC(queues_nr, "Max number of RX and TX queues (default = 1)");

Adding new module parameters is generally discouraged. Also, it's sort
of a cumbersome API that you'll have to set this first, then re-create
the device, and then use channels to get the number you want.

So why not just default to allocating num_possible_cpus() number of
queues? Arguably that is the value that makes the most sense from a
scalability point of view anyway, but if we're concerned about behaviour
change (are we?), we could just default real_num_*_queues to 1, so that
the extra queues have to be explicitly enabled by ethtool?

-Toke

