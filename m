Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9188539B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfHGTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:30:15 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36665 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbfHGTaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:30:15 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so42275105plt.3;
        Wed, 07 Aug 2019 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ObEX3XOlWeWT23v7d2oHVMbTltkGtaDbL7AOnbNpYho=;
        b=ckVPiHA3Y2kGvCQB1JLlSs2X0FYl6tzEn3uyXO6poAg3s8LtmZAbrQ5YOgbwH0PYuY
         n7QJq6AHZl1ocijZXJEQzaq/mRUaHuHlLKb+suAswLrLYfGiuiKDPKSNyEgEPBzpgikP
         mKohYgINTsrSTkX2MWMC5szbJuDcvp/ZhAsxVIilDr0gdOUxY73LgJT1qIZ3UXEy1wH1
         ONVrNINyXBWiQ9o9FpBofXjmvePGaeUbiYFIfzFV5LbXeX56BtwkP0hvF+hDrfg69wv2
         XHkWw7liSZ6rHNH/jKB52m2X5ZXA0ORDSFMYck8yVcq8uUBfhhtzGs+NIHHXUubwyum+
         D7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ObEX3XOlWeWT23v7d2oHVMbTltkGtaDbL7AOnbNpYho=;
        b=taJIypIww5f4Y1wv8JCVZ0vrl5V996owL4Ry3075BfTxZtbgs7UvutYcKBvZ87lxT6
         0NUfT6SYyw0uEmHBFMTdEG/eWpNgGHp+4fKsrKG/fo2XauUoAil87MfWnNfAXlWIaMfI
         sS4gJNHmdRi7hVDuy1t1fuGSeJ/6sObYZm06xj5WH5vfjm7WBKORhgDbixivwss5KkII
         wpf+m7rTF4++RIK7xrgF8+vcvvgSpuM98wwrqy7lidKhtIsGKW3rVXFXvjBs7DzoSjwO
         4ttvxtnGXeXUcyHhdB2zb/JxdNx5nqRnJelTvTR/T2XVaB0doBeoWubqFlILBerY0139
         qvtg==
X-Gm-Message-State: APjAAAXnY4P4GHO2/122GQH172Ds0zRd6B4F2gLK23JGyCzcPuyBJfJ9
        aBnWP0Ey8CoEziL6MCtboWc=
X-Google-Smtp-Source: APXvYqyvvg1ACVIpxDY7hfpLdLclBw4I4RfROp/RmaXlID5a+2MeRCbE4YmB1buH6l+AZ8ck5PD69w==
X-Received: by 2002:a62:79c2:: with SMTP id u185mr11161713pfc.237.1565206214810;
        Wed, 07 Aug 2019 12:30:14 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::7084])
        by smtp.gmail.com with ESMTPSA id cx22sm610978pjb.25.2019.08.07.12.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:30:13 -0700 (PDT)
Date:   Wed, 7 Aug 2019 12:30:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 02/14] libbpf: convert libbpf code to use new
 btf helpers
Message-ID: <20190807193011.g2zuaapc2uvvr4h6@ast-mbp>
References: <20190807053806.1534571-1-andriin@fb.com>
 <20190807053806.1534571-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807053806.1534571-3-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 10:37:54PM -0700, Andrii Nakryiko wrote:
> Simplify code by relying on newly added BTF helper functions.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
..
>  
> -	for (i = 0, vsi = (struct btf_var_secinfo *)(t + 1);
> -	     i < vars; i++, vsi++) {
> +	for (i = 0, vsi = (void *)btf_var_secinfos(t); i < vars; i++, vsi++) {

> +			struct btf_member *m = (void *)btf_members(t);
...
>  		case BTF_KIND_ENUM: {
> -			struct btf_enum *m = (struct btf_enum *)(t + 1);
> -			__u16 vlen = BTF_INFO_VLEN(t->info);
> +			struct btf_enum *m = (void *)btf_enum(t);
> +			__u16 vlen = btf_vlen(t);
...
>  		case BTF_KIND_FUNC_PROTO: {
> -			struct btf_param *m = (struct btf_param *)(t + 1);
> -			__u16 vlen = BTF_INFO_VLEN(t->info);
> +			struct btf_param *m = (void *)btf_params(t);
> +			__u16 vlen = btf_vlen(t);

So all of these 'void *' type hacks are only to drop const-ness ?
May be the helpers shouldn't be taking const then?

