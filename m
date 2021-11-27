Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2DC45FDD0
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 10:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353719AbhK0J5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 04:57:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354087AbhK0JzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 04:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638006719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p75atS3SnkNsb8S2VmpxFfNaOxa+SCCGx3bM477zQ0Y=;
        b=GX7JiXjvq4mU64ZKnBGrQZsyeNgMMM2Lb6PNIHQBlCWogas4byC7v+hbjqDI01ZEb8uej4
        Fww7gCow6tVTPTUgL7fe/8xxYyJlimV7r/0Pu3QiFTBO5ROedkEiogfeI4yp9gOLl7Hm1+
        UJe32Nn9oCZwUBRquDGNeg9X2aVZS4w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-0L7cuJixNrOj8uZ7cA7Zcg-1; Sat, 27 Nov 2021 04:51:56 -0500
X-MC-Unique: 0L7cuJixNrOj8uZ7cA7Zcg-1
Received: by mail-wm1-f71.google.com with SMTP id g80-20020a1c2053000000b003331a764709so8441552wmg.2
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 01:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=p75atS3SnkNsb8S2VmpxFfNaOxa+SCCGx3bM477zQ0Y=;
        b=L73R+lXc58XWvPcFkVMn7QZMsc0pgLPHbxEczGNxZPxZEARDI2bVL2pyKG8C+ydbzE
         MEEGM4FVczi9yl/I8cer6DomKH3Vv+Mpk/FASFJ0F4IU8Srb7G0Of46RkDlpOf4UYDoS
         KqH5tAeM62ebjIL2gRRjZXBFNL4ALM9wzlqzVHhzqAubCMySiSD39LYIyuDAiTA0avwx
         DOgdAxpCA+c6kfV+Ie+leparBzxv4Bs1LK3dftCArHyBaulHzTfzX+TTp+Fpc47vEBba
         RZ8PdaqbALga4wzCqZEUmZTd22dQMQebW2K0a7f+o2/G5JuZay2fhFALPwErcFh4FVBF
         o3qA==
X-Gm-Message-State: AOAM533aP3fwNvM6r8NNVhzpU2aEeLiuyv1ayk55OVCoAFmqL8okq5yd
        kpSJHJ31XEUIwyBvPaZxqVsUyGN9osHhMJWKmiZmv9eLnrMiblBPcgqPp4CjENJ8GW+wQ2vpNHo
        TduQzzjto2jBqaq/e
X-Received: by 2002:a1c:2047:: with SMTP id g68mr22167722wmg.181.1638006715541;
        Sat, 27 Nov 2021 01:51:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrC1pkgjEewkKotBw1LkGeoMrE6rp5r7iq42oOQXf6GEEveAUFje8X+iRIbN6+ivpoegAexw==
X-Received: by 2002:a1c:2047:: with SMTP id g68mr22167699wmg.181.1638006715350;
        Sat, 27 Nov 2021 01:51:55 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id 8sm12598430wmg.24.2021.11.27.01.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 01:51:54 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <804e9942-8697-4703-3cde-5f74d916e325@redhat.com>
Date:   Sat, 27 Nov 2021 10:51:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, bjorn@kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next 2/4] samples/bpf: xdpsock: add Dest and Src MAC
 setting for Tx-only operation
Content-Language: en-US
To:     Ong Boon Leong <boon.leong.ong@intel.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
 <20211124091821.3916046-3-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-3-boon.leong.ong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2021 10.18, Ong Boon Leong wrote:
> To set Dest MAC address (-G|--tx-dmac) only:
>   $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff
> 
> To set Source MAC address (-H|--tx-smac) only:
>   $ xdpsock -i eth0 -t -N -z -H 11:22:33:44:55:66
> 
> To set both Dest and Source MAC address:
>   $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff \
>     -H 11:22:33:44:55:66
> 
> The default Dest and Source MAC address remain the same as before.
> 
> Signed-off-by: Ong Boon Leong<boon.leong.ong@intel.com>
> ---
>   samples/bpf/xdpsock_user.c | 36 +++++++++++++++++++++++++++++++-----
>   1 file changed, 31 insertions(+), 5 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

