Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA36619C388
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbgDBODA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:03:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40585 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732484AbgDBOC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:02:59 -0400
Received: by mail-wr1-f67.google.com with SMTP id s8so2200252wrt.7
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fqn7p/l7UwSVEcFtTYwLbDZZfP18GORIXD0/qCGLlHI=;
        b=ayNgC39jRlZElPUbkmOCwcKapm+bAKDE9EO+rfAWTQhemjIpsA312DayojrbJb0+ll
         iHbmk0q3yYT1AVAr731mbxjnPHwij/f0j+J7a/AvmA4GqCjSJKwXNMJiMf1GfRFjoC4C
         nTgTujtXFyF6zy9tCsrkPAxxGsc5MUYHqjBaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fqn7p/l7UwSVEcFtTYwLbDZZfP18GORIXD0/qCGLlHI=;
        b=kF729PDiRyf8Ux172Gn+9dhVztF8X3OQDx3a7//lrMFqNiCLo7RFcHq4i4m/CPNwWu
         pBopKF/od4MXbSG9IEsjWWZr07hCp5/3sKkOY2L5fdFKbreNTMCvnM+nZUCyFHTxf+rH
         cEZv4OEgwImqyoffpI2sjjyjlMChEe6gJO6To/Wip1LZso4IRZzuwOnxq/2AaGeB8CP8
         cQS4T2JSoXEiKB9r9pBQ6bryETyLSL9oF+q5FxqLXe8aie0Js7gZ4wOVZMKg4+119eER
         25GjK8W6/MYkCiYzoBbbA5Sg8308MGS1dHaI3ukWB0n2R2/lt99sgr4tPjAr74e3pa6d
         1lzQ==
X-Gm-Message-State: AGi0PuaDJfrs+75BSBG18UT5QDavn09N9zhwmjsl94Nw6bHRPqL988Pe
        3MkP/civFfBja2RAx35n0VKNqw==
X-Google-Smtp-Source: APiQypK+8UMfG1mJo59/786/qFE6iY0sUP7qJJoMnX9RQZSEFfXGn9lxL0DMeRUI8e6DiMcBzP3G6w==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr3654797wrt.401.1585836177591;
        Thu, 02 Apr 2020 07:02:57 -0700 (PDT)
Received: from revest.fritz.box ([2a02:168:ff55:0:c8d2:c098:b5ec:e20e])
        by smtp.gmail.com with ESMTPSA id b199sm7965195wme.23.2020.04.02.07.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:02:56 -0700 (PDT)
Message-ID: <2c93a2c75e55291473370d9805f8dd0484acd5a3.camel@chromium.org>
Subject: Re: [PATCH 2/3] bpf: Add d_path helper
From:   Florent Revest <revest@chromium.org>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 02 Apr 2020 16:02:55 +0200
In-Reply-To: <20200401110907.2669564-3-jolsa@kernel.org>
References: <20200401110907.2669564-1-jolsa@kernel.org>
         <20200401110907.2669564-3-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+build1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-01 at 13:09 +0200, Jiri Olsa wrote:
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> + *	Description
> + *		Return full path for given 'struct path' object, which
> + *		needs to be the kernel BTF 'path' object. The path is
> + *		returned in buffer provided 'buf' of size 'sz'.
> + *
> + *	Return
> + *		length of returned string on success, or a negative
> + *		error in case of failure
> + *

You might want to add that d_path is ambiguous since it can add
" (deleted)" at the end of your path and you don't know whether this is
actually part of the file path or not. :) 

> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +	char *p = d_path(path, buf, sz - 1);

I am curious why you'd use sz - 1 here? In my experience, d_path's
output is 0 limited so you shouldn't need to keep an extra byte for
that (if that was the intention here).

> +	int len;
> +
> +	if (IS_ERR(p)) {
> +		len = PTR_ERR(p);
> +	} else {
> +		len = strlen(p);
> +		if (len && p != buf) {
> +			memmove(buf, p, len);

Have you considered returning the offset within buf instead and let the
BPF program do pointer arithmetics to find the beginning of the string?

> +			buf[len] = 0;

If my previous comment about sz - 1 is true, then this wouldn't be
necessary, you could just use memmove with len + 1.

> +		}
> +	}
> +
> +	return len;
> +}

