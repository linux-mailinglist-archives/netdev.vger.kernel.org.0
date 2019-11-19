Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98365101224
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfKSDVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:21:33 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45278 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfKSDVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:21:33 -0500
Received: by mail-pl1-f193.google.com with SMTP id w7so10937875plz.12;
        Mon, 18 Nov 2019 19:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AJSVdvbi212zCUDsjBqGjD7qtdajE6+qPwR1HzaIyho=;
        b=XAsjp0UfvBJaaNSKz53ndim8SsS53XqDhf+5/udM2dsqWIeqGVOC3axEMLay6pskwu
         iLXBwOZdteWt8F4DYXpabbg12dy0hfASmooqVzcKUeAiZbewE3dP647mfEg5hdmo+Grc
         774RVyR7XWxR951pd+rZ9SUuFBpJa7QyxxUhp8WnnuQb39N8PNWKHN82jiZZjBNa8p+F
         jGH8JCjERXrBK32Qn3sIn/mDEgRup5ShLbW0MLuwvBunlOuM4tyZz2wO5kjxCXqw5YVy
         9oYfpOekOIp+ccFs/mleVqlE7w6XzaEIYut5wDh67JU7eCmLdusctls8elqWxD9tcCel
         d1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AJSVdvbi212zCUDsjBqGjD7qtdajE6+qPwR1HzaIyho=;
        b=Cwe1pkJ3WLErwBDezvI75+RBIBpQ/GqviCX9J21wwycrDT2IoOsUPtiod2coBnOQGJ
         mEQw6OcWR0BVtD53KJ0oa1g0B56+/vrl4F4XfjavVkIkA+dNG6+iNvz585TBDGFkZSaK
         JyQUnpmmFgZGuS4G1otomIsloUVKpm32CYWUlDMN0mpnEae+NZyqd29uVQclXkR5IvV+
         uF5wzkrH8KG9+UTI24MiUH/p2hVCJp7POenuWQ2rlxuZG9jJQvC7aZRorAj17IA4HQUj
         6vL8aBCiz0irXy5fw6UCusngFRu3iJBld/Fzxzp1xAh1zOWGyAqT43W1H5TTIpU0EGqp
         RxsA==
X-Gm-Message-State: APjAAAXSu9ZWvLju6sRHe/4k1i/baNKpLlr/VBiu3qOw5mHsfafCQli8
        JZ6pSUUrtZk/XgsA3ABGJuc=
X-Google-Smtp-Source: APXvYqwHySuggv2EYKl7B2OgoSD6B53sTlzBDOVVTaqfvIwzxELqlOUIP0zisQ0Rc4OBeJhOdMMX1w==
X-Received: by 2002:a17:90a:195e:: with SMTP id 30mr3318897pjh.60.1574133692723;
        Mon, 18 Nov 2019 19:21:32 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::db2d])
        by smtp.gmail.com with ESMTPSA id 81sm25657044pfx.142.2019.11.18.19.21.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 19:21:31 -0800 (PST)
Date:   Mon, 18 Nov 2019 19:21:29 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
References: <20191117070807.251360-1-andriin@fb.com>
 <20191117070807.251360-6-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117070807.251360-6-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 11:08:06PM -0800, Andrii Nakryiko wrote:
> Add support for extern variables, provided to BPF program by libbpf. Currently
> the following extern variables are supported:
>   - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
>     executing, follows KERNEL_VERSION() macro convention;
>   - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
>     boolean, and integer values are supported. Strings are not supported at
>     the moment.
> 
> All values are represented as 64-bit integers, with the follow value encoding:
>   - for boolean values, y is 1, n or missing value is 0;
>   - for tristate values, y is 1, m is 2, n or missing value is 0;
>   - for integers, the values is 64-bit integer, sign-extended, if negative; if
>     config value is missing, it's represented as 0, which makes explicit 0 and
>     missing config value indistinguishable. If this will turn out to be
>     a problem in practice, we'll need to deal with it somehow.

I read that statement as there is no extensibility for such api.

> Generally speaking, libbpf is not aware of which CONFIG_XXX values is of which
> expected type (bool, tristate, int), so it doesn't enforce any specific set of
> values and just parses n/y/m as 0/1/2, respectively. CONFIG_XXX values not
> found in config file are set to 0.

This is not pretty either.

> +
> +		switch (*value) {
> +		case 'n':
> +			*ext_val = 0;
> +			break;
> +		case 'y':
> +			*ext_val = 1;
> +			break;
> +		case 'm':
> +			*ext_val = 2;
> +			break;
> +		case '"':
> +			pr_warn("extern '%s': strings are not supported\n",
> +				ext->name);
> +			err = -EINVAL;
> +			goto out;
> +		default:
> +			errno = 0;
> +			*ext_val = strtoull(value, &value_end, 10);
> +			if (errno) {
> +				err = -errno;
> +				pr_warn("extern '%s': failed to parse value: %d\n",
> +					ext->name, err);
> +				goto out;
> +			}

BPF has bpf_strtol() helper. I think it would be cleaner to pass whatever
.config has as bytes to the program and let program parse n/y/m, strings and
integers.

LINUX_KERNEL_VERSION is a special case and can stay as u64.

