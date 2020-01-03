Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6D12F6F6
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgACLEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:04:51 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36599 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgACLEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:04:51 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so23301975pgc.3
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 03:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IRsLgmVxnk5gNK6KQ8gDiwoRP8BQ2cRq8us2aY+nodQ=;
        b=KwsQuzcSuYR1VvDZr1VR758tiBnKfYjdoR+zSRgZ1J+yi2/nU1OuRLqvPx6SG+XlYu
         NeLnPNF5cAg73kLC4Radu5YVnyzHKWSBeNIaXHp9OaUsDo0isI5gJiemTUyGX+HsO3ZP
         g8OopfznUh6hFPRg2cDIQ/PSs+Amb3Q8esaKD60uF6nZAcmp4iVaYhAHH46doTSy/Rp2
         sp4Pi0T56d5RZ5S+ypKz89NkY+1AwYbNDVlmfrEmIlJ2DYFbmP2D7ScUoGvI8sAf7eB6
         IYHFH6naMWF50RBtiiqUZcPwLoICz7SM6eP9zcFPlkj/e20OgWu1NGEZRmmxne6LmsGE
         AWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IRsLgmVxnk5gNK6KQ8gDiwoRP8BQ2cRq8us2aY+nodQ=;
        b=ul1eBtIsLrqAVONObQ5Obgw7bwbSrNds83XUyIYKwUFquHGFdcvKI5FvsGBHMKLnZK
         qeunDCyLzAZF/So76CqY4Gn83UVwJEMGO3PyawBGcsU8oPplDI5aIP8fTvjvEy9Ib/gL
         o/dZ6hehrsm1RlZC0c/nQxjKET/IFHwvs+38ghSb30EI1Ql3bNIiuq2oRTBW8rLoioiP
         aq9wHfC88oUX4ji1D7DsTZhmBC9g4eeOxKiJppPDL/yt02ikufOJH4bWjr/qPKzz2oQk
         reT0sZbi1lOpa10Egt7kIRznCtZfO62FEdEd7Q5ImdUZnyd0ynHhQoKROAoZFLMWFRL5
         SfPg==
X-Gm-Message-State: APjAAAX26pa3c1h4SOqXKvaCOzZAywjng6r1sXtajUISgrCyHpEunp1p
        uTvEN0G033aQA4wjhZyrwwnCsT26
X-Google-Smtp-Source: APXvYqy819E5OAwuYCSZ0vPxdrqCuz7hFPCO2Qcrrz0xMe1wOw4jiFdfBlaxVUmHzBOPYVekBzhdlQ==
X-Received: by 2002:a63:584:: with SMTP id 126mr94740141pgf.100.1578049490384;
        Fri, 03 Jan 2020 03:04:50 -0800 (PST)
Received: from [192.168.1.236] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id v143sm59483798pfc.71.2020.01.03.03.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:04:49 -0800 (PST)
Subject: Re: [RFC v2 net-next 03/12] libbpf: api for getting/setting link xdp
 options
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
 <20191226023200.21389-4-prashantbhole.linux@gmail.com>
 <CAEf4Bza=AT5NcBkQnJucgY5+QfkQTVX_S2CfiV6o6p_oGrr=ng@mail.gmail.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <be49a172-9601-0b97-0fb6-c9f968181092@gmail.com>
Date:   Fri, 3 Jan 2020 20:04:46 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza=AT5NcBkQnJucgY5+QfkQTVX_S2CfiV6o6p_oGrr=ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/30/2019 1:49 PM, Andrii Nakryiko wrote:
> On Wed, Dec 25, 2019 at 6:34 PM Prashant Bhole
> <prashantbhole.linux@gmail.com> wrote:
>>
>> This patch introduces and uses new APIs:
>>
>> struct bpf_link_xdp_opts {
>>          struct xdp_link_info *link_info;
>>          size_t link_info_sz;
>>          __u32 flags;
>>          __u32 prog_id;
>>          int prog_fd;
>> };
> 
> Please see the usage of DECLARE_LIBBPF_OPTS and OPTS_VALID/OPTS_GET
> (e.g., in bpf_object__open_file). This also seems like a rather
> low-level API, so might be more appropriate to follow the naming of
> low-level API in bpf.h (see Andrey Ignatov's recent
> bpf_prog_attach_xattr() changes).
> 
> As is this is not backwards/forward compatible, unless you use
> LIBBPF_OPTS approach (that's what Alexei meant).

Got it.

> 
> 
>>
>> enum bpf_link_cmd {
>>          BPF_LINK_GET_XDP_INFO,
>>          BPF_LINK_GET_XDP_ID,
>>          BPF_LINK_SET_XDP_FD,
>> };
>>
>> int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
>>                        enum bpf_link_cmd cmd);
>> int bpf_set_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
>>                        enum bpf_link_cmd cmd);
>>
>> The operations performed by these two functions are equivalent to
>> existing APIs.
>>
>> BPF_LINK_GET_XDP_ID equivalent to bpf_get_link_xdp_id()
>> BPF_LINK_SET_XDP_FD equivalent to bpf_set_link_xdp_fd()
>> BPF_LINK_GET_XDP_INFO equivalent to bpf_get_link_xdp_info()
>>
>> It will be easy to extend this API by adding members in struct
>> bpf_link_xdp_opts and adding different operations. Next patch
>> will extend this API to set XDP program in the tx path.
> 
> Not really, and this has been extensively discussed previously. One of
> the problems is old user code linked against newer libbpf version
> (shared library). New libbpf will assume struct with more fields,
> while old user code will provide too short struct. That's why all the
> LIBBPF_OPTS stuff.

Got it. Thanks for reviewing.

Prashant

> 
>>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> ---
>>   tools/lib/bpf/libbpf.h   | 36 +++++++++++++++++++
>>   tools/lib/bpf/libbpf.map |  2 ++
>>   tools/lib/bpf/netlink.c  | 77 ++++++++++++++++++++++++++++++++++++----
>>   3 files changed, 109 insertions(+), 6 deletions(-)
>>
> 
> [...]
> 
