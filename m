Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021D711DDC1
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 06:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbfLMFa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 00:30:59 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:47034 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMFa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 00:30:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id z21so691877pjq.13;
        Thu, 12 Dec 2019 21:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=OKFBK2gNnko329ZjaMQO2iIA5rqF5fZBNGyDOWHkP1c=;
        b=aSNeJR7P3e9Zhq8c4REfNlFQEeVnGUSQ3oH+G10BsXXcQn7Q8JUB+P2fLU6tSdNHG3
         2Cb/0NoRzHJhCGBwJebnuwJ3XQ0lySrGLJGRWXTVl61SgdrlDnuqJA7beYzOANNAqZ3F
         +8eSu89IMYVX9tvDU8L8KgNrUzqnxyHPPpnIK1RTNDt3aRQ29QRD/QnvymEKzcv3P4EH
         Fl43ZdjElsCyHEAxq55JS4+BeBr+RCQAIF+dSYRqOCTDcS5x51YcSTnPkkj2tw8PqVjv
         DLz49U0xoXRh5bcBYCjUW6CguhRrrOVkhVNTsPXq5e3i92Xad0ahBV1KREylfidM7J3o
         WOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OKFBK2gNnko329ZjaMQO2iIA5rqF5fZBNGyDOWHkP1c=;
        b=pwzljhm/u029shB4sEPZ+WTXGq+OL4TLVOGWedd06QY6qK/3MTA6I28WhBP54RAZR6
         Zw4+kj38PrQnc6xvKXinr+x/DycZmoc3X0nCNZKpgKEOa3DbPAvDQlPTn4OCw9hyAs9T
         HfdXvegIuZcgYEkQRM9AH2BZkTtoZ28jQn05opCcf5zZzdqgu5ohGOKPRBnXdpGRtrJ/
         VaQPME8M2MqkAgNuUw4gBurdOb6me/PRGHa/CYF86zjVDZqPcA7miga8i1Zpdnkt1IOZ
         IxQ0GZrpnnwWOcLiQBRhPRyKWLQWImxsbBgMuDF2EWi9WqEiH8Rk/xVPt4tNS5lkseo9
         jTyg==
X-Gm-Message-State: APjAAAUCPPLnHWhscNl9Dt6Xh+aeWfK+XPQoNMB5oLS9IqHStR7RM/PU
        1/OZ9Qd/iyjmSP27utq9Q6U=
X-Google-Smtp-Source: APXvYqyZiWcOGaj/mAMQKc+gZoyY+2W+UPiIcxjhO6bEPEMfTNmgsaa31cK6VB2UkK6GbEw4puY9YQ==
X-Received: by 2002:a17:90a:c790:: with SMTP id gn16mr14674570pjb.76.1576215058772;
        Thu, 12 Dec 2019 21:30:58 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:180::c195])
        by smtp.gmail.com with ESMTPSA id r28sm3416057pgk.39.2019.12.12.21.30.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 21:30:57 -0800 (PST)
Date:   Thu, 12 Dec 2019 21:30:55 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20191213053054.l3o6xlziqzwqxq22@ast-mbp>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
 <20191211123017.13212-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191211123017.13212-3-bjorn.topel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:30:13PM +0100, Björn Töpel wrote:
> +
> +#define DEFINE_BPF_DISPATCHER(name)					\
> +	unsigned int name##func(					\
> +		const void *xdp_ctx,					\
> +		const struct bpf_insn *insnsi,				\
> +		unsigned int (*bpf_func)(const void *,			\
> +					 const struct bpf_insn *))	\
> +	{								\
> +		return bpf_func(xdp_ctx, insnsi);			\
> +	}								\
> +	EXPORT_SYMBOL(name##func);			\
> +	struct bpf_dispatcher name = BPF_DISPATCHER_INIT(name);

The dispatcher function is a normal function. EXPORT_SYMBOL doesn't make it
'noinline'. struct bpf_dispatcher takes a pointer to it and that address is
used for text_poke.

In patch 3 __BPF_PROG_RUN calls dfunc() from two places.
What stops compiler from inlining it? Or partially inlining it in one
or the other place?

I guess it works, because your compiler didn't inline it?
Could you share how asm looks for bpf_prog_run_xdp()
(where __BPF_PROG_RUN is called) and asm for name##func() ?

I hope my guess that compiler didn't inline it is correct. Then extra noinline
will not hurt and that's the only thing needed to avoid the issue.

