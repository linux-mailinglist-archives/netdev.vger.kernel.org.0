Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784B21A6C1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgGISV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGISV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:21:27 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFA6C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:21:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so3481376ljn.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=11gPwvbTzhcBYbo+vwPUgMj7SJcAk2yAyF7jDQyYrDQ=;
        b=L2ZWb2PTR19zzCqVEjb9Xmg361g/AUvEoxd18yaexoIIIvj4/Uzz4hmrNv96qSuZN/
         sjxlAngpsGDhag86wEs9xg1hvFA7pr+jyFrHN0+OqdUCJ3IqRn5mCpLu8FW2nx6TNYVu
         GeNVqzhJX+JufNDuVCUt81ZikTeRMxc/LFTIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=11gPwvbTzhcBYbo+vwPUgMj7SJcAk2yAyF7jDQyYrDQ=;
        b=FyDQWyPXylFdUfnVFUlrucBpV9/WcPsyeIbuBwTxV43mW8QWk/c2LijwjuFswRCUIm
         ESGInDSj6ZwO8m0sqqUWhDvs7e3fjqbHlYhsNgKBtk/rWfdYd62GJgRGuC5c/TTsimJB
         tO+gB9N1cD6KSrDURqEeF/7Dgmx5C87lkdzDNhmc1QgsTRMIU346oGKsiZWeVDhAaJ4s
         mbH5n6JRhCCfhsSB1K7dcuQVfijNAT8ExKusF40BZ7pkgt42tk89+oAbTmkp3bPSB4Nz
         5ngS4ovdP84keYUaJaTdlVQwIVXPzRMODO+K66TEHp5mNTZ/w5bhPuZw4lIfpdgbMhn1
         CNuQ==
X-Gm-Message-State: AOAM533g0rnOejz2kub9bC3YhTUI8LW64hydwKaLttit8BPIJjnWbUNH
        dmn3rezdxvLNdchBgif525kvYQ==
X-Google-Smtp-Source: ABdhPJyIvtZvgCwJDBk4N9jrMxUsGzwvy61eu1Iyl0GjXzmKDzz2OB1s/2QZ0X3uo4XDOaYUuQ5PGA==
X-Received: by 2002:a2e:9b41:: with SMTP id o1mr25390840ljj.360.1594318885862;
        Thu, 09 Jul 2020 11:21:25 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m9sm1212543lfb.5.2020.07.09.11.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:21:25 -0700 (PDT)
References: <20200709115151.75829-1-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] selftests: bpf: fix detach from sockmap tests
In-reply-to: <20200709115151.75829-1-lmb@cloudflare.com>
Date:   Thu, 09 Jul 2020 20:21:24 +0200
Message-ID: <87eepka6sb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 01:51 PM CEST, Lorenz Bauer wrote:
> Fix sockmap tests which rely on old bpf_prog_dispatch behaviour.
> In the first case, the tests check that detaching without giving
> a program succeeds. Since these are not the desired semantics,
> invert the condition. In the second case, the clean up code doesn't
> supply the necessary program fds.
>
> Reported-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Fixes: bb0de3131f4c ("bpf: sockmap: Require attach_bpf_fd when detaching a program")
> ---
>  tools/testing/selftests/bpf/test_maps.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
> index 6a12a0e01e07..754cf611723e 100644
> --- a/tools/testing/selftests/bpf/test_maps.c
> +++ b/tools/testing/selftests/bpf/test_maps.c
> @@ -789,19 +789,19 @@ static void test_sockmap(unsigned int tasks, void *data)
>  	}
>  
>  	err = bpf_prog_detach(fd, BPF_SK_SKB_STREAM_PARSER);
> -	if (err) {
> +	if (!err) {
>  		printf("Failed empty parser prog detach\n");
>  		goto out_sockmap;
>  	}
>  
>  	err = bpf_prog_detach(fd, BPF_SK_SKB_STREAM_VERDICT);
> -	if (err) {
> +	if (!err) {
>  		printf("Failed empty verdict prog detach\n");
>  		goto out_sockmap;
>  	}
>  
>  	err = bpf_prog_detach(fd, BPF_SK_MSG_VERDICT);
> -	if (err) {
> +	if (!err) {
>  		printf("Failed empty msg verdict prog detach\n");
>  		goto out_sockmap;
>  	}
> @@ -1090,19 +1090,19 @@ static void test_sockmap(unsigned int tasks, void *data)
>  		assert(status == 0);
>  	}
>  
> -	err = bpf_prog_detach(map_fd_rx, __MAX_BPF_ATTACH_TYPE);
> +	err = bpf_prog_detach2(parse_prog, map_fd_rx, __MAX_BPF_ATTACH_TYPE);
>  	if (!err) {
>  		printf("Detached an invalid prog type.\n");
>  		goto out_sockmap;
>  	}
>  
> -	err = bpf_prog_detach(map_fd_rx, BPF_SK_SKB_STREAM_PARSER);
> +	err = bpf_prog_detach2(parse_prog, map_fd_rx, BPF_SK_SKB_STREAM_PARSER);
>  	if (err) {
>  		printf("Failed parser prog detach\n");
>  		goto out_sockmap;
>  	}
>  
> -	err = bpf_prog_detach(map_fd_rx, BPF_SK_SKB_STREAM_VERDICT);
> +	err = bpf_prog_detach2(verdict_prog, map_fd_rx, BPF_SK_SKB_STREAM_VERDICT);
>  	if (err) {
>  		printf("Failed parser prog detach\n");
>  		goto out_sockmap;

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
