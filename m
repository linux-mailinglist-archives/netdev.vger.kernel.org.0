Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2604F3898F8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhESV50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhESV50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 17:57:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4A8C061574;
        Wed, 19 May 2021 14:56:04 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h6so13500343ila.7;
        Wed, 19 May 2021 14:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=5mRkprA2tLjeO7o2uum3+MPJOgOznrRqFoN+MMN+W3U=;
        b=oGpmT6cMlA4DduTCP1KUDlYrcARx7YnECdcSoVqW47RWPvHBNsOCMjubk0f9iQrXbV
         FvuF5F96eP5qZUyl+tCg5EFdt2ikK84WKhrkguJCw8nhjHssSo+huzY/GC4K2K59zxCP
         eQ+vxPRB/MXKFDPMmzgCRblI+ORhYE8egEUlZuKko691vR4/fPJA8BJLYByQRfxSmLwR
         NnMqqKndr+A8nkA4Pdwxf7aSQJD2VwiJr7slUYOmftUeUJxJVT4rn2YPesS94LD3EYxn
         emYyjuvAfcAdCvS6ECaTBcQrBCRU7UTrxk0Ve8YdSQaa4ZrdeeB2tL05OS8X+Kk0kghj
         t3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=5mRkprA2tLjeO7o2uum3+MPJOgOznrRqFoN+MMN+W3U=;
        b=givDitadHvqSdIgXSLDRwLr0O9qFFtdBwRdGr7013vNBJ6DNnuYV2xdxsKVUAP7szC
         yufcwSJbLmsyoasgLchdeOGnG201qt42D5zylkGCSBfKiQCdI9TgG47yP8qzhAcLls/e
         Oaut/NG9u784ninnxXgRuoZN7EKkzadx30FQN6ClNq4fwQ+qDGVxSQoqoLBH4Qg7lg68
         EQBNcr8VWehcytSKLMJkDPR/i1j4k1iA6Mbk0ZSuuw/dYYQIHZH00N/fUAPsebUnKn28
         henWWIitvU/RntECXhGiafpYc/psyGnEnQnc97k0P+/7LsSxOJ6+2nUM5brm9n2M+1n9
         ECPw==
X-Gm-Message-State: AOAM532GjIZFxgq65bwTmDDcy096unHdd48ywpqScpYmUmxy1VEmnvOg
        sSS6K2Hs2EMHWEhsFNoYdLY=
X-Google-Smtp-Source: ABdhPJzfPJkKVERjY0feox9i8bBQGEGd5ezJAF/fXd+Ht8LHIEcfl/Jefcp9Y23ThCVvsqjfp5msLg==
X-Received: by 2002:a92:c8d2:: with SMTP id c18mr1246773ilq.54.1621461364344;
        Wed, 19 May 2021 14:56:04 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id d5sm696409ilf.55.2021.05.19.14.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 14:56:03 -0700 (PDT)
Date:   Wed, 19 May 2021 14:55:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch>
In-Reply-To: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf] selftests/bpf: Retry for EAGAIN in
 udp_redir_to_connected()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> We use non-blocking sockets for testing sockmap redirections,
> and got some random EAGAIN errors from UDP tests.
> 
> There is no guarantee the packet would be immediately available
> to receive as soon as it is sent out, even on the local host.
> For UDP, this is especially true because it does not lock the
> sock during BH (unlike the TCP path). This is probably why we
> only saw this error in UDP cases.
> 
> No matter how hard we try to make the queue empty check accurate,
> it is always possible for recvmsg() to beat ->sk_data_ready().
> Therefore, we should just retry in case of EAGAIN.
> 
> Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> index 648d9ae898d2..b1ed182c4720 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
>  	if (pass != 1)
>  		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
>  
> +again:
>  	n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> -	if (n < 0)
> +	if (n < 0) {
> +		if (errno == EAGAIN)
> +			goto again;
>  		FAIL_ERRNO("%s: read", log_prefix);

Needs a counter and abort logic we don't want to loop forever in the
case the packet is lost.

> +	}
>  	if (n == 0)
>  		FAIL("%s: incomplete read", log_prefix);
>  
> -- 
> 2.25.1
> 


