Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E13E3D4108
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 21:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhGWTCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 15:02:06 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:38441 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhGWTCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 15:02:04 -0400
Received: by mail-pj1-f45.google.com with SMTP id j8-20020a17090aeb08b0290173bac8b9c9so10459223pjz.3
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 12:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MJRb9z9w2T1pw15bznzH8U8+ZElzBg4Yr2imhbXucq8=;
        b=euTBdcGoIWESdoj09I3hCFktStixJNdqTZq1+6cB/y8iz4oyf+7Rv8i4GRfRR4HvhP
         78zSHnHDFUNQwp+BciXq9RecLanjjZ0n389VvrmRpTs+U8qq9YOGkVITlM8+4nyMN2jT
         mWJZJJO76Mgx7L4v7dMIVr1cYp1XiAnjdcM8CDe53CMiaNktaDk9uxaHyW2OpDOH98cc
         iRjN1UwiVvdiXKizWZnuIVeIq0v7qsec7PXWEiwBziWPZYxm/r+DCpiWMtBMsDg/ZCMm
         HN+ci23RAW4R+O20C/0hgZmWD1YUv8smHhntz7LcbQ657WQ7d8T03hZBNwSxsir1bEwa
         TIKg==
X-Gm-Message-State: AOAM531rpNsjBpXBaKg1qWMBzXbb94HzW7xuKSN7mN8VSWWZVPJcuKBr
        NgOorvwHCF8E6TXwE7XEyxk=
X-Google-Smtp-Source: ABdhPJxEkt7iA0KvLte4vk/r3u5xIJ/HU7v0kmbtay+c6QM7YEXVco4I+0jv3Y20BckYFthHMH32ew==
X-Received: by 2002:a62:584:0:b029:32e:3b57:a1c6 with SMTP id 126-20020a6205840000b029032e3b57a1c6mr5850811pff.13.1627069356595;
        Fri, 23 Jul 2021 12:42:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:a676:ed9f:319b:a155? ([2601:647:4802:9070:a676:ed9f:319b:a155])
        by smtp.gmail.com with ESMTPSA id g13sm34910477pfo.112.2021.07.23.12.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 12:42:36 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 22/36] net: Add ulp_ddp_pdu_info struct
To:     Boris Pismenny <borisp@nvidia.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-23-borisp@nvidia.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <eaa53cb5-f9ee-1402-b653-662a4c220a8d@grimberg.me>
Date:   Fri, 23 Jul 2021 12:42:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722110325.371-23-borisp@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +/**
> + * struct ulp_ddp_pdu_info - pdu info for tcp ddp crc Tx offload.
> + *
> + * @end_seq:	tcp seq of the last byte in the pdu.
> + * @start_seq:	tcp seq of the first byte in the pdu.
> + * @data_len:	pdu data size (in bytes).
> + * @hdr_len:	the size (in bytes) of the pdu header.
> + * @hdr:	pdu header.
> + * @req:	the ulp request for the original pdu.
> + */
> +struct ulp_ddp_pdu_info {
> +	struct list_head list;
> +	u32		end_seq;
> +	u32		start_seq;
> +	u32		data_len;
> +	u32		hdr_len;
> +	void		*hdr;
> +	struct request	*req;

Not sure what ddp does with this, but it shouldn't accept struct
request what-so-ever.
