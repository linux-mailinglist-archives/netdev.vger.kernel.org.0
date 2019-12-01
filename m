Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3FF610E2AA
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 17:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfLAQyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 11:54:47 -0500
Received: from mail-io1-f48.google.com ([209.85.166.48]:47062 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfLAQyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 11:54:47 -0500
Received: by mail-io1-f48.google.com with SMTP id i11so37507459iol.13;
        Sun, 01 Dec 2019 08:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2rtYPKXu0wUef3OhDol+BP9kZOGI7cYX1kVkgWIxDkA=;
        b=djDDcmb07Y7ohpmWUHxZKhWxBBNA92ZcXK6LhlPIl0GLkibJY5GsSTHutNLFtsxdjU
         fcIaXrtuTJf+D2N2xK4a/duYUaR8hbcGCgsE8DjHomULTUQTgBlArPUkyHr94Dg78qiD
         CqDvk7XbEdlUBHFFBhGDDSgIfnbdyDGM42kFWiXVVn2F/3egkJycyyhv+k5QeeoM9yIL
         3gEYRX8/6hiN1+R0NCWxrCwDx118fYgBfSNyMvda+JdLSdnbNnbOGdADh6r+1VcCi/CF
         R7VwAiCl81M4/NU6D/XBHfAcayCNtTGYJsoNXOw7VitOEFUu3IU/lJVnXtFfa3uqJrcM
         UkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2rtYPKXu0wUef3OhDol+BP9kZOGI7cYX1kVkgWIxDkA=;
        b=i7rgvRn2drpjQUrRI3721pic9qq9GiAdAkUpwVm5WnLt0sv3oy/RDDAfIJaQkXCFxI
         LtPW/+X4PNAJJfwlvNB7QV9piHhnfmpjSJM5/8oCwI40XSmXzCXWw3FWu/AQPckA0jA1
         GzcLveFqWhUajzJpZTZ+8ahwjbvAjNv077nfe81Z+WGypxoofRWmQSrQviW9TtInF1fQ
         vQECYbddHseSqP1vXjPF9wsma+RoGMIL7OZP+7G01I+Eh7C6/jDcYprjDr2oI0mvPG/J
         7GYF2cEAvV0hN8TJWHMcbuhmrt9rRHCQKlI6Uy6P4fITX+9o+U+DYHSuCpZHy2l04056
         aA1g==
X-Gm-Message-State: APjAAAUkssqHgTIxNR3Td3u3AXnB/NkC03OqigNqDlCGBAzc6xg13bbW
        8EWOvDAOEufNEVnJz0zoakilo4Lv
X-Google-Smtp-Source: APXvYqy1H3L0+0XKonVV1/vbmEUW8a220uqNNPbGk+oPe4TuLdAUDVUKK7r/sjoMDX1ZeQeq2PGW2Q==
X-Received: by 2002:a6b:8b44:: with SMTP id n65mr49370974iod.19.1575219286530;
        Sun, 01 Dec 2019 08:54:46 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:fd6b:fde:b20f:61ed])
        by smtp.googlemail.com with ESMTPSA id k199sm8870660ilk.20.2019.12.01.08.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 08:54:45 -0800 (PST)
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
To:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        kvm@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126123514.3bdf6d6f@cakuba.netronome.com>
 <20191128033255.r66d4zedmhudeaa6@ast-mbp.dhcp.thefacebook.com>
 <c6c6ca98-8793-5510-ad24-583e25403e35@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0aa6a69a-0bbe-e0fc-1e18-2114adb18c51@gmail.com>
Date:   Sun, 1 Dec 2019 09:54:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c6c6ca98-8793-5510-ad24-583e25403e35@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/19 10:18 PM, Jason Wang wrote:
> We try to follow what NFP did by starting from a fraction of the whole
> eBPF features. It would be very hard to have all eBPF features
> implemented from the start.  It would be helpful to clarify what's the
> minimal set of features that you want to have from the start.

Offloading guest programs needs to prevent a guest XDP program from
running bpf helpers that access host kernel data. e.g., bpf_fib_lookup
