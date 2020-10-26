Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E432990C4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783507AbgJZPPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:15:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43184 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783148AbgJZPPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:15:03 -0400
Received: by mail-io1-f67.google.com with SMTP id h21so10415276iob.10;
        Mon, 26 Oct 2020 08:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pGUqI6ohN0SuSER1PyVwsi+1WKpuN3EOxatCZ1T2/GA=;
        b=AvDH5ioFER7d0vxy+G5Fn7bzjp++fAJ5sO1oABtQPDCdUpENDIBq1hC3e6qplApn5G
         XGyBIXwwV+gAEbdkjICxeUQRr6wc4uptMguZTK0rcmDSRNG+zB6dF0hwt17GjnVwKOj+
         e+i6WiEEn6ZNiza/JSdRAVyQB87vLlaVp4xQ6pO4hgIgztumHB/iO954hQWlVDg6mLG1
         3VH2sdB40lk4aFhewYv40Fk4FXBkO8SiZrfXymbX6q+HwiohxSwx9qfAVHKoe09xBNPh
         4G6vj3d8/dkoWxRZDHCXHEI+kwXsFrUcYJm2OxKftGErSWjUJCw0SdWqI0/DCBp1g+sE
         o3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pGUqI6ohN0SuSER1PyVwsi+1WKpuN3EOxatCZ1T2/GA=;
        b=s1X+z1hfDLk4SfWP23ZCXUKtI8TSMbjlgoF3ptCrwb9+YgCX/LQbbBlHjAzhoVp+SB
         c2f6Zl4MV1zjsmBdzSDCzYzz6dDQ1H1/UoDlcTk9dqKqqDGzK57LhVMJzr3y/eQHCmnn
         gfOqjmAMU5Pm/k3PhUynCT//Ah2crsoB45I1c0e5BfYzT+aLcQ4aMqAI1fH8UdXe+9MI
         GRXrgOBfuGHUBYcCiKNMKdynlXwu7C+cuhSjqLkPz4wieauymPuEAf81MiysxQ9iPtHs
         sbDfc2I6AHe1bAmy5B9WuxAXXAZq+EaQCEoFOKbeAqSTA1IYxMD7vdFe4HGsO37I5M3p
         czxQ==
X-Gm-Message-State: AOAM532/+WwXawp+0seMcjDfy0nidtzCcmDc2KPL5Q0t+ZN55mZ6cw1o
        npvnp1/Z3L9yCI5ZdYHmM/k=
X-Google-Smtp-Source: ABdhPJwFaSI62BG79oPcOjquajkliX9bdmF6iTyF9K4is4QDR3lVGScmYO0lBBz1N6R8/Ub/qVcT1g==
X-Received: by 2002:a5e:a601:: with SMTP id q1mr11021128ioi.152.1603725302305;
        Mon, 26 Oct 2020 08:15:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:146b:8ced:1b28:de0])
        by smtp.googlemail.com with ESMTPSA id l78sm6907310ild.30.2020.10.26.08.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 08:15:01 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com> <87eelm5ofg.fsf@toke.dk>
 <91aed9d1-d550-cf6c-d8bb-e6737d0740e0@gmail.com>
 <20201026085610.GE2408@dhcp-12-153.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <063cb81c-a1b7-3893-792e-280adb6a0f33@gmail.com>
Date:   Mon, 26 Oct 2020 09:15:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026085610.GE2408@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/20 2:56 AM, Hangbin Liu wrote:
> 
> Hi David,
> 
> On Sun, Oct 25, 2020 at 04:12:34PM -0600, David Ahern wrote:
>> On 10/25/20 9:13 AM, Toke HÃ¸iland-JÃ¸rgensen wrote:
>>> David Ahern <dsahern@gmail.com> writes:
>>>
>>>> On 10/22/20 9:38 PM, Hangbin Liu wrote:
>>>>> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
>>>>> instructions and load directly.
>>>>
>>>> for completeness, libbpf should be able to load a program from a buffer
>>>> as well.
>>>
>>> It can, but the particular use in ipvrf is just loading half a dozen
>>> instructions defined inline in C - there's no object files, BTF or
>>> anything. So why bother with going through libbpf in this case? The
>>> actual attachment is using the existing code anyway...
>>>
>>
>> actually, it already does: bpf_load_program
> 
> Thanks for this info. Do you want to convert ipvrf.c to:
> 
> @@ -256,8 +262,13 @@ static int prog_load(int idx)
>  		BPF_EXIT_INSN(),
>  	};
>  
> +#ifdef HAVE_LIBBPF
> +	return bpf_load_program(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
> +				"GPL", 0, bpf_log_buf, sizeof(bpf_log_buf));
> +#else
>  	return bpf_prog_load_buf(BPF_PROG_TYPE_CGROUP_SOCK, prog, sizeof(prog),
>  			         "GPL", bpf_log_buf, sizeof(bpf_log_buf));
> +#endif
>  }
>  
>  static int vrf_configure_cgroup(const char *path, int ifindex)
> @@ -288,7 +299,11 @@ static int vrf_configure_cgroup(const char *path, int ifindex)
>  		goto out;
>  	}
>  
> +#ifdef HAVE_LIBBPF
> +	if (bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE, 0)) {
> +#else
>  	if (bpf_prog_attach_fd(prog_fd, cg_fd, BPF_CGROUP_INET_SOCK_CREATE)) {
> +#endif
>  		fprintf(stderr, "Failed to attach prog to cgroup: '%s'\n",
>  			strerror(errno));
>  		goto out;
> 

works for me. The rename in patch 2 can be dropped as well correct?
