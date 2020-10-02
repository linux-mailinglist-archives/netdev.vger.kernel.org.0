Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5405328174B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388026AbgJBP7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387893AbgJBP7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:59:11 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44388C0613D0;
        Fri,  2 Oct 2020 08:59:11 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o18so1709140ilg.0;
        Fri, 02 Oct 2020 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qLkLXB+bBxozOJHMfD7Vb0R8YMektlfsAiW40puaMT0=;
        b=hX6GiCMglkF0NjZMmV/ALZ6AT2Rwg80axYmdphOkdAEgUjrxnhHbwojbiw5+/eCLgB
         5N/tOaVwa/PcGTK0M9jEi89HseWuSI+2xTPWVqIGZYaY7SUOz+RCCDNziefjLEW03Mio
         e7VMD4CLJYVuiESza/5aM1OrxcTm0j61vftKx9fituOZPTDWsteOSt7Ak5hmC+C+vHM2
         C0Qor3rgFVkt0pNPHl2YyVivgLmp4wePTPsfAQxYKfYfX+540YLbUBDnKqynvbKeM+PV
         jIECRMPWyNCzGII/+W/1DCvU901f5y0MoBto4FeO5eHwKADVGWKHR1lDDzoVFOJ9X7l+
         dszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qLkLXB+bBxozOJHMfD7Vb0R8YMektlfsAiW40puaMT0=;
        b=lp9zPnNQleY9CqcilVi72JtxsK7LGq4WxaF+0p8UghmCv61m7/oDo/ABsEbG5YyjQ2
         3oSeTJ6isagDxXy+13/bYsiGzR/3663SHzX7Dv8Yq0V5lEILY7+2ZKAGRhlylhSxTpnH
         xeZO71B50+ZH1JyKlHOU27RqEuUCw8TKXo5mwDXuhbnKjLvNvLUTNbvRJOOiSc8v6aEE
         M+0OtIeD84NPX4nqjcxw5lnJG3W0xEgNUmcvC4TCSKmkJhHyyC13zkoUaLJDeSAf2K9A
         QKQo1g/CbORLfFtYtLBhH9cOeRxXjrV9rJV6vbMJOBi6dcB9WwJvc4tglRo9p0NTJ8Qk
         Hcew==
X-Gm-Message-State: AOAM530wkvTXfLKT96oVVpNEMNwIiZD4sDWvOrOBW4GTPTBgc1ARRXZP
        klj94ytEd4i+HXBggAhSbcphJMVW5k5kpA==
X-Google-Smtp-Source: ABdhPJyhq89g13nfdUg/HdgOAKUyLcxW9uwDaP/cWWz2RqhTxxnAP3ewnlEsvhobSW8oxNErSqBRlg==
X-Received: by 2002:a92:8742:: with SMTP id d2mr2272601ilm.153.1601654350680;
        Fri, 02 Oct 2020 08:59:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v13sm523578ilh.65.2020.10.02.08.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 08:59:09 -0700 (PDT)
Date:   Fri, 02 Oct 2020 08:59:03 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Message-ID: <5f774e472c782_38b0208be@john-XPS-13-9370.notmuch>
In-Reply-To: <20201002000451.1794044-1-sdf@google.com>
References: <20201002000451.1794044-1-sdf@google.com>
Subject: RE: [PATCH bpf-next] selftests/bpf: properly initialize linfo in
 sockmap_basic
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev wrote:
> When using -Werror=missing-braces, compiler complains about missing braces.
> Let's use use ={} initialization which should do the job:
> 
> tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: In function 'test_sockmap_iter':
> tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:181:8: error: missing braces around initializer [-Werror=missing-braces]
>   union bpf_iter_link_info linfo = {0};
>         ^
> tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:181:8: error: (near initialization for 'linfo.map') [-Werror=missing-braces]
> tools/testing/selftests/bpf/prog_tests/sockmap_basic.c: At top level:
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Works for me.

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  tools/testing/selftests/bpf/prog_tests/sockmap_basic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 4c4224e3e10a..85f73261fab0 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -198,7 +198,7 @@ static void test_sockmap_copy(enum bpf_map_type map_type)
>  {
>  	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
>  	int err, len, src_fd, iter_fd, duration = 0;
> -	union bpf_iter_link_info linfo = {0};
> +	union bpf_iter_link_info linfo = {};
>  	__u32 i, num_sockets, num_elems;
>  	struct bpf_iter_sockmap *skel;
>  	__s64 *sock_fd = NULL;
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 


