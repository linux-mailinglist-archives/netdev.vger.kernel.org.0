Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3E71ACDCE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388466AbgDPQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 12:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731424AbgDPQf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 12:35:28 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24CCC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 09:35:27 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id c12so2318634qvj.5
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 09:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4WIIiyh9h1e7R9WGPb6eeYzSiIzX5QG2HX6gvaEf460=;
        b=CUKx+75cpInIm6k+auuHn+srLnxhZBgcIGBKWfWpvqLhbW0rgxtt1JZ+8/dwMvoD2i
         JuzYZM72OyGZT+ldsRyO1LC59oP53n49KcJyS+Mm3Flxe8+lQVmcGwadfgp84Y+UT6F8
         JvWYylPFd1PepRyNKZcP8XlyFz2u3cjII72tBa895wN7I7xx7XhA9Hgv0shRZTc0rWvL
         ehG1OxRppVYQOa/Q6u1InN8FqvoFXrkyVG10VWiXc/pe8+1RiQ2FtuOES3GLpAzK2c6s
         9hAgnM7Sc31U/dwY25HlfFFBm1l3KZF/HRIDsj5bDfwk9VI19WbgRAQKlzRzALhHBhyo
         ZLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WIIiyh9h1e7R9WGPb6eeYzSiIzX5QG2HX6gvaEf460=;
        b=YRSd1Qw+X1qXLSAZMiNl360ZIJTPIZpqA9mV+nqqxYRZFnGy7wanAPHytnajde51JH
         znNgClh/IUFkAEKjMU4lI0KatzdfxMf7dQ9R+odZa+4EPKs2GL4ztLy+Lf6wicNaUfxJ
         QyuLOqWsIoNhkImOoy+AkRHEK+tShjyv858FM/t9KWxCIbsxh1RsHbnK4djIokehCyNt
         ZXBz91DajdzTnfpVFX9WjxSN+eWgouxHOAWhB5jH8pfgr4wtk26uBNG/fixaBBEXWWxe
         Pc/77eXfDVmAVrxjLQTbR9xPIhAV53SlAG13yVjypU//3C+nCmgSrrGc9gRkx6hpLmUZ
         sHaQ==
X-Gm-Message-State: AGi0Pua2dYG3gA8v3Cpc6WMlX7xaXq/CJsj3KyfSCSuSBF2S+CdEWHc0
        4Mpx10gAuzf82tM55kfJDfY=
X-Google-Smtp-Source: APiQypL95B6Sg24THElyH9xoBvF7c4B6EbUD1nYTvqCL1hZaeB9W6DgmvYJw8fBrdI/j/QGyeK49XA==
X-Received: by 2002:a0c:ef05:: with SMTP id t5mr6747144qvr.113.1587054926999;
        Thu, 16 Apr 2020 09:35:26 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id j2sm11528359qtp.5.2020.04.16.09.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 09:35:26 -0700 (PDT)
Subject: Re: [PATCH RFC-v5 bpf-next 02/12] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200413171801.54406-1-dsahern@kernel.org>
 <20200413171801.54406-3-dsahern@kernel.org> <87k12fleaw.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0b9c1c4e-c6a3-48a1-7f0a-f7362e9a10a6@gmail.com>
Date:   Thu, 16 Apr 2020 10:35:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87k12fleaw.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/20 8:01 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> From: David Ahern <dahern@digitalocean.com>
>>
>> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
>> at the XDP layer, but the egress path.
>>
>> Since egress path will not have ingress_ifindex and rx_queue_index
>> set, update xdp_is_valid_access to block access to these entries in
>> the xdp context when a program is attached to egress path.
>>
>> Update dev_change_xdp_fd to verify expected_attach_type for a program
>> is BPF_XDP_EGRESS if egress argument is set.
>>
>> The next patch adds support for the egress ifindex.
>>
>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> ---
>>  include/uapi/linux/bpf.h       | 1 +
>>  net/core/dev.c                 | 6 ++++++
>>  net/core/filter.c              | 8 ++++++++
>>  tools/include/uapi/linux/bpf.h | 1 +
>>  4 files changed, 16 insertions(+)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 2e29a671d67e..a9d384998e8b 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>>  	BPF_TRACE_FEXIT,
>>  	BPF_MODIFY_RETURN,
>>  	BPF_LSM_MAC,
>> +	BPF_XDP_EGRESS,
>>  	__MAX_BPF_ATTACH_TYPE
>>  };
>>  
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 06e0872ecdae..e763b6cea8ff 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -8731,6 +8731,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>>  		if (IS_ERR(prog))
>>  			return PTR_ERR(prog);
>>  
>> +		if (egress && prog->expected_attach_type != BPF_XDP_EGRESS) {
>> +			NL_SET_ERR_MSG(extack, "XDP program in Tx path must use BPF_XDP_EGRESS attach type");
>> +			bpf_prog_put(prog);
>> +			return -EINVAL;
>> +		}
>> +
>>  		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
>>  			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
>>  			bpf_prog_put(prog);
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 7628b947dbc3..c4e0e044722f 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6935,6 +6935,14 @@ static bool xdp_is_valid_access(int off, int size,
>>  				const struct bpf_prog *prog,
>>  				struct bpf_insn_access_aux *info)
>>  {
>> +	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
>> +		switch (off) {
>> +		case offsetof(struct xdp_md, ingress_ifindex):
>> +		case offsetof(struct xdp_md, rx_queue_index):
>> +			return false;
>> +		}
>> +	}
>> +
> 
> How will this be handled for freplace programs - will they also
> "inherit" the expected_attach_type of the programs they attach to?
> 

not sure I understand your point. This is not the first program type to
have an expected_attach_type; it should work the same way others do -
e.g., cgroup program types.
