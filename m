Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C13363D
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfFCRM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:12:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35666 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfFCRM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 13:12:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so12927490wrv.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 10:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hdzztUxr8+P2yiTShU7eDsGECp578g9yYtd++GlZKeM=;
        b=YHBoiOODCu6PHgDttATy2kvMgIpaVHP/Y1ZLTzpWroQFuNU8dmiGF85Qzf2I8VGTR0
         CgzRuEEQA8A0iVjlAcsuP04YbFFXH6loPt/UaGYrobJJrKR9jlAjeQZ0rClLPnZl+h7X
         Hc2u5lUAgtKlOQmrV7KIiV9/eI5w2e0Bb7taZmI4F2l1EHr/U1PgsPhiS9aZ43L6/sS0
         rQuDIj/LfVygTvQhFXbJRTIZdeWcEtAWtZOF3xCXUWZbCDxlNHQBokZe8RacAPFBgbGi
         1YIlDSFm1wXonaTjVGVq8qs13S8vxely644588B+/w+Si9njxkhuzF6lOONsMbKIzuEV
         ZKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hdzztUxr8+P2yiTShU7eDsGECp578g9yYtd++GlZKeM=;
        b=RH4Eu8cyia5Jf3Q+6JjOkbAkIJTMusX1fAYOFbUTFcJC6JkGci6WZLU7Izi7uk9Dgh
         Z+RugP5wzdo/hMa0sEKG6L+NyF+ebi03jnvsPhnId/XjwcBQeOG4wE9ybKbLRsGaS02H
         lUMdNCtK0XiPWYCFFGJuImfrlq3oPGPAhkMELdInnBrbMAiJ1w8HWTBc9suKM56Iaf0N
         euVatJqAQ4SZiY4LDiwR7DzuE4ThW0qKMfazZIZxq0UvLluDQSQLI+68C2PLKH2QXFAe
         xXjpzPB5NlhBfpqcjQBk/TKOdd+2v61Jkvecn4UpL8gtWMPDJEQTHlLr/KaU7QeoZbH+
         eMRQ==
X-Gm-Message-State: APjAAAUiVLK1I/qXwWownyW2bvPcJXfTjRaxIdf2MbLkn7XwVOMwODXW
        uF8SUfUH4VLWOnKyfe/k2SgPOA==
X-Google-Smtp-Source: APXvYqx2gy6R5EWjGdW4uHp6XrM8Ts2Jk2G8SrQ412rzSVmlcjnvLQUppAdTfeKc5Hf1g0ujRMEPdw==
X-Received: by 2002:adf:ead0:: with SMTP id o16mr4216795wrn.216.1559581947459;
        Mon, 03 Jun 2019 10:12:27 -0700 (PDT)
Received: from [10.16.0.69] (host.78.145.23.62.rev.coltfrance.com. [62.23.145.78])
        by smtp.gmail.com with ESMTPSA id l18sm35284484wrh.54.2019.06.03.10.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 10:12:26 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC][PATCH kernel_bpf] honor CAP_NET_ADMIN for BPF_PROG_LOAD
To:     Andreas Steinmetz <ast@domdv.de>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <1188fe85-d627-89d1-d56b-91011166f9c7@6wind.com>
Date:   Mon, 3 Jun 2019 19:12:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 28/05/2019 à 18:53, Andreas Steinmetz a écrit :
> [sorry for crossposting but this affects both lists]
> 
> BPF_PROG_TYPE_SCHED_CLS and BPF_PROG_TYPE_XDP should be allowed
> for CAP_NET_ADMIN capability. Nearly everything one can do with
> these program types can be done some other way with CAP_NET_ADMIN
> capability (e.g. NFQUEUE), but only slower.
> 
> This change is similar in behaviour to the /proc/sys/net
> CAP_NET_ADMIN exemption.
> 
> Overall chances are of increased security as network related
> applications do no longer require to keep CAP_SYS_ADMIN
> admin capability for network related eBPF operations.
> 
> It may well be that other program types than BPF_PROG_TYPE_XDP
> and BPF_PROG_TYPE_SCHED_CLS do need the same exemption, though
> I do not have sufficient knowledge of other program types
> to be able to decide this.
> 
> Preloading BPF programs is not possible in case of application
> modified or generated BPF programs, so this is no alternative.
> The verifier does prevent the BPF program from doing harmful
> things anyway.
> 
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>
It makes sense to me.
Do you plan to submit it formally?

Looking a bit more at this topic, I see that most part of the bpf code uses
capable(CAP_NET_ADMIN). I don't see why we cannot use ns_capable(CAP_NET_ADMIN).


Regards,
Nicolas

> 
> --- a/kernel/bpf/syscall.c	2019-05-28 18:00:40.472841432 +0200
> +++ b/kernel/bpf/syscall.c	2019-05-28 18:17:50.162811510 +0200
> @@ -1561,8 +1561,13 @@ static int bpf_prog_load(union bpf_attr
>  		return -E2BIG;
>  	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
>  	    type != BPF_PROG_TYPE_CGROUP_SKB &&
> -	    !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> +	    !capable(CAP_SYS_ADMIN)) {
> +		if (type != BPF_PROG_TYPE_SCHED_CLS &&
> +		    type != BPF_PROG_TYPE_XDP)
> +			return -EPERM;
> +		if(!capable(CAP_NET_ADMIN))
> +			return -EPERM;
> +	}
>  
>  	bpf_prog_load_fixup_attach_type(attr);
>  	if (bpf_prog_load_check_attach_type(type, attr->expected_attach_type))
> 
