Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559FE406F8A
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhIJQUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:20:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhIJQUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCmmhYCPvZGsQCildcllyAD8h6CmMr1J1+mjHiwFbv8=;
        b=bine9hFo8wshVyIyXxFmWpAkhUkYfK8jtxNy2ip4RbxJWFSiDMSrLB5T0WQp+KiP6bcjv/
        RLoX9yYapoeOThJD0CVSqhL9CTyQj4PGztd7IANfJTcz7dRkD5uNgLwvfL5d515LUZ6ZBR
        MwOj+Mc4iRiVOyKHrxxyaRjlqVeA0aM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-V_nEA0_EN7S88xNEZYhcjg-1; Fri, 10 Sep 2021 12:19:05 -0400
X-MC-Unique: V_nEA0_EN7S88xNEZYhcjg-1
Received: by mail-lf1-f69.google.com with SMTP id n5-20020a19ef05000000b003e224cd5844so1068889lfh.12
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 09:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hCmmhYCPvZGsQCildcllyAD8h6CmMr1J1+mjHiwFbv8=;
        b=XRAf0/d4pY0ff5RS4yGfVtq0O5dHC4za8Jj0Dc78lQUUa9DaKj7CnVrEXvA0AjwpW4
         tI4se+YpIQokPR/eftQsCdcl7ZkX1cjxEChK0BP1O7Zo+D5lssjr65GcxpK/WWxV5Dn9
         JN2Ks0BJNIRBZbQKRBA6Z+7Y5IZQpTanb8FN+wkvgAvOdsrtzym+OgbtqECVO+w/7IXU
         cSpdt6lmRJD3H08YYdfHcppHFA1GbCaVH1nSQGJjvDiU2TdgClcXAXaSKVT7DA+aahr+
         HvZaq/f6nUNSj+C3fytwwJXavv3TE9rmijdO8Gnp3UQUVW7kuZAG40frbk4GHZTxnnIl
         v5UA==
X-Gm-Message-State: AOAM5319/Clux2hhvyPA3nmw/rnn10+nqyr/kjPiRZcAC57feAPl9Lxb
        jFVnHQeLN3ixk6OIWEtxt5JBGVfsjXZzb9NCQ/r09UPqdVJGOPm03pgWfDpoS1EzqK4c58QWTwn
        iBRsxsTS6w+UsbWQw
X-Received: by 2002:a05:6512:169b:: with SMTP id bu27mr4660374lfb.578.1631290744262;
        Fri, 10 Sep 2021 09:19:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzim6Euy/3NCFRnAiZtE9Q36wCG3/lp0JG3DrZgW43gzrdDOJ2Bf+M+9QprRsrpPnvVFV6h/A==
X-Received: by 2002:a05:6512:169b:: with SMTP id bu27mr4660341lfb.578.1631290743980;
        Fri, 10 Sep 2021 09:19:03 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id h13sm597384lfv.62.2021.09.10.09.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 09:19:03 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 02/18] xdp: introduce flags field in
 xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1631289870.git.lorenzo@kernel.org>
 <b74dac5c5bfe5115dd777d0eafcb0c3c21853348.1631289870.git.lorenzo@kernel.org>
Message-ID: <edf63174-dc00-fb1c-e467-5a1522783cde@redhat.com>
Date:   Fri, 10 Sep 2021 18:19:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b74dac5c5bfe5115dd777d0eafcb0c3c21853348.1631289870.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/09/2021 18.14, Lorenzo Bianconi wrote:
> Introduce flags field in xdp_frame and xdp_buffer data structures
> to define additional buffer features. At the moment the only
> supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
> frame (mb = 1). In the latter case the driver is expected to initialize
> the skb_shared_info structure at the end of the first buffer to link
> together subsequent buffers belonging to the same frame.
> 
> Acked-by: John Fastabend<john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi<lorenzo@kernel.org>
> ---
>   include/net/xdp.h | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

