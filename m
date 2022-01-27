Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C3649DA45
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiA0FfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiA0FfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:35:01 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D3CC06161C;
        Wed, 26 Jan 2022 21:35:00 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id s185so3936982oie.3;
        Wed, 26 Jan 2022 21:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=DOmRNqAz0lhTZtWjnPnnNSY2+Zw6bYBsBF5xYunjvBM=;
        b=LZkOm6JfBD93IR0buDaW+j75ACw0YiZeqIfq38IG4VOnAbYjfj4P4NVLKQDa0ezsFs
         iJoaEhGAToc2/vWzQHZsb9QBd+rA6W+FshRIgD9foQcNRYJ6JN9P313eHtadlleCu6cl
         77390zA5msX1fQLEtw2VrtOURIKSzCLuxHzE7NWcMprRsGgLJv9j5oxvQcc+JK3g1S72
         Jne7+xRmcbpdf1RXlOf1SI8VxkXRAHAuMIEGQoC7G5M20lAhTEB5qfdg2rNgbdpArKuL
         wMCVebgJYHN0oqL/bJ+hX6E7oQAZ96fVhYltbeTPYKnepimGFe2igpaEO5/nbG4SoAjK
         olRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=DOmRNqAz0lhTZtWjnPnnNSY2+Zw6bYBsBF5xYunjvBM=;
        b=JRRiN962nveUuP77+ZH+hgA9JqI3we+QYdXfSMu4sMU0z6A7Ocmv5lfEE07LzZ5sCV
         /M4qoqMguYPhc7ziE2XVTtcP9rIyc2kC/GEtFx+Jgto+D9f7AdBzaW/qY6GJr4k49TbP
         gqk88MKyPz60Tu0V+beyBK/UiEeHoDImLWzq3ZFwEFialRf2XWwduBm9Hg0IVrlv1+cr
         fBcEZXiPIlDKpyoE8QY2aVAjq7fgSKV2/xlB31O8fR5BmYR2XE7RuZ89+bL2P1ce0zC5
         RkN2wMIhEnelJN+EI3NfpEEnrX3qg5JnyBaNWLrg8h1vAco9m7wD/O7CW296gLDY+O8L
         p2Kg==
X-Gm-Message-State: AOAM530wY1Z5ZLS4eiVkOeUmKOLLud32+/07B9f5LcqPYikB0wmqvP25
        b/fv1clP21uXHPbxvabhQfk=
X-Google-Smtp-Source: ABdhPJzFNLsyFevpTLmtw7+pXKm3JYI4MB6pikOi7dw/M0dXgzF5xuRkBIpzVWPUsP4Q8GTzodBuBg==
X-Received: by 2002:a05:6808:189f:: with SMTP id bi31mr1290221oib.5.1643261699858;
        Wed, 26 Jan 2022 21:34:59 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id u3sm1523615ooh.19.2022.01.26.21.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 21:34:59 -0800 (PST)
Date:   Wed, 26 Jan 2022 21:34:52 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <61f22efcce503_57f03208c4@john.notmuch>
In-Reply-To: <20220125081717.1260849-2-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
 <20220125081717.1260849-2-liuhangbin@gmail.com>
Subject: RE: [PATCH bpf 1/7] selftests/bpf/test_xdp_redirect_multi: use temp
 netns for testing
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> Use temp netns instead of hard code name for testing in case the netns
> already exists.
> 
> Remove the hard code interface index when creating the veth interfaces.
> Because when the system loads some virtual interface modules, e.g. tunnels.
> the ifindex of 2 will be used and the cmd will fail.
> 
> As the netns has not created if checking environment failed. Trap the
> clean up function after checking env.
> 
> Fixes: 8955c1a32987 ("selftests/bpf/xdp_redirect_multi: Limit the tests in netns")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../selftests/bpf/test_xdp_redirect_multi.sh  | 60 ++++++++++---------
>  1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> index 05f872740999..cc57cb87e65f 100755
> --- a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
> @@ -32,6 +32,11 @@ DRV_MODE="xdpgeneric xdpdrv xdpegress"
>  PASS=0
>  FAIL=0
>  LOG_DIR=$(mktemp -d)
> +declare -a NS
> +NS[0]="ns0-$(mktemp -u XXXXXX)"
> +NS[1]="ns1-$(mktemp -u XXXXXX)"
> +NS[2]="ns2-$(mktemp -u XXXXXX)"
> +NS[3]="ns3-$(mktemp -u XXXXXX)"
>  
>  test_pass()
>  {
> @@ -47,11 +52,9 @@ test_fail()
>  
>  clean_up()
>  {
> -	for i in $(seq $NUM); do
> -		ip link del veth$i 2> /dev/null
> -		ip netns del ns$i 2> /dev/null
> +	for i in $(seq 0 $NUM); do
> +		ip netns del ${NS[$i]} 2> /dev/null

You dropped the `ip link del veth$i` why is this ok?

>  	done
> -	ip netns del ns0 2> /dev/null
>  }
