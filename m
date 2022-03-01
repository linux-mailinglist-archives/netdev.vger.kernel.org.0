Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A77D4C8207
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 05:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiCAEMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 23:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiCAEMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 23:12:39 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF0359A65;
        Mon, 28 Feb 2022 20:11:58 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r8so3600059ioj.9;
        Mon, 28 Feb 2022 20:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=JizWy30NqngQ6w03lzthwcXJikA7CYicX/+9BAz4MlA=;
        b=STMAWXuvP/GtcJc48Qivw8j6/0RiafH9Cjxv2MwGwhGdxyGJlQatc95cWs8Igl3mhm
         WMSmy0N88p686/tnGCAcHJlfkjU0hIvlWamLA6VEhEI2SCaWP92TgAl7PNItcZsTsz+Z
         CH4+zUNwAQQsR7y/sxlGG+L7viPTsMfDWuTDYZvCY2ceTiOBZdC1J+n1A4lHkzM+xHUQ
         8hNKPISZZdZW2ci/zaUfKgENIn0qauLN+kwcPFHkK9vy6TtD71jY/GJZkOuY2DKWQe+v
         n0uGqEg19xMdrijaJ25AqGebj+JnmMpA4zn64wUe6tD4HfJ82ZAxrCAQDCi4qrAL13TQ
         /2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=JizWy30NqngQ6w03lzthwcXJikA7CYicX/+9BAz4MlA=;
        b=EgT4xxTrrK492qFSPt2OVnsK04xQQ0kkSuRTmxYm2xnbiT7vOJ/CJB9qBJyfAbmCG3
         KEIZzWBxAQ2Q+xgaazaVk+Z6aFmgrB5B/Ve8+/xKpx4rW42kXmLcpO6s8VjM/nb8Ob1d
         UfG9m/vF6noSA3DFY6gZMYfvW5g8eWB0JrcS3bpdENhU1V3G8fCNuFWJeoy8vqRuPgLz
         /7ax8IPdWuZC3Z8dlB6xFqGMCtL97Ll3/9QLIJgA9Bc/mSo/xkBMukZ/Pv/zjBgtDgRc
         nLCU2y9HOWxwS5PIVkT6QKHEoNK+EFxz0c5dEeLuI5VIyg1cGBGOfDuD2YNAYY2eX+t6
         FdxQ==
X-Gm-Message-State: AOAM530fnTQbRLbSVSaLzpbHPwSxHW9eSxLpnZ4LTxJ8tVq+nk4yOaHD
        hAZVIPJR5PaSNwj2Xu1V0IY=
X-Google-Smtp-Source: ABdhPJx9RRWsgBlvoDlLpBPES6K7oeLPchGu0lHzyUOWf2CNhZWBgDtEtaij8OBEpV7m1UP9+krOpg==
X-Received: by 2002:a05:6638:408:b0:313:f2bd:2d2 with SMTP id q8-20020a056638040800b00313f2bd02d2mr19883468jap.110.1646107918292;
        Mon, 28 Feb 2022 20:11:58 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id y3-20020a920903000000b002be151ee1e6sm7181457ilg.30.2022.02.28.20.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:11:57 -0800 (PST)
Date:   Mon, 28 Feb 2022 20:11:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, bpf@vger.kernel.org
Cc:     edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Message-ID: <621d9d067de02_8c479208b9@john.notmuch>
In-Reply-To: <20220225014929.942444-5-wangyufen@huawei.com>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-5-wangyufen@huawei.com>
Subject: RE: [PATCH bpf-next 4/4] bpf, sockmap: Fix double uncharge the mem of
 sk_msg
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen wrote:
> If tcp_bpf_sendmsg is running during a tear down operation, psock may be
> freed.
> 
> tcp_bpf_sendmsg()
>  tcp_bpf_send_verdict()
>   sk_msg_return()
>   tcp_bpf_sendmsg_redir()
>    unlikely(!psock))
>    sk_msg_free()
> 
> The mem of msg has been uncharged in tcp_bpf_send_verdict() by
> sk_msg_return(), so we need to use sk_msg_free_nocharge while psock
> is null.
> 
> This issue can cause the following info:
> WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
> Call Trace:
>  <TASK>
>  __sk_destruct+0x24/0x1f0
>  sk_psock_destroy+0x19b/0x1c0
>  process_one_work+0x1b3/0x3c0
>  worker_thread+0x30/0x350
>  ? process_one_work+0x3c0/0x3c0
>  kthread+0xe6/0x110
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x22/0x30
>  </TASK>
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/ipv4/tcp_bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 1f0364e06619..03c037d2a055 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -139,7 +139,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
>  	int ret;
>  
>  	if (unlikely(!psock)) {
> -		sk_msg_free(sk, msg);
> +		sk_msg_free_nocharge(sk, msg);
>  		return 0;
>  	}
>  	ret = ingress ? bpf_tcp_ingress(sk, psock, msg, bytes, flags) :

Did you consider simply returning an error code here? This would then
trigger the sk_msg_free_nocharge in the error path of __SK_REDIRECT
and would have the side effect of throwing an error up to user space.
This would be a slight change in behavior from user side but would
look the same as an error if the redirect on the socket threw an
error so I think it would be OK.

Thanks,
John
