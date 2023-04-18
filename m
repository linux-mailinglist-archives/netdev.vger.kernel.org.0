Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E86E66FB
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDROUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 10:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjDROUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 10:20:30 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C33E9C
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:20:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f16b99b990so22620665e9.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1681827627; x=1684419627;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VuHEI4+TYN1anXAPqDxS2fPdoIRrluy7efqigF6G4jY=;
        b=a8202y0Mn0FDttxfKjZ9b8TD+yOdIlKKCP8hDkqORxrhiZngiNAJj2Xbl3DoN0mo5V
         zYFVBjwBUpqGV36n/0s8LbHGfArMMsAsypyM9eS75r7/E+sSE65UveKarl2qo87rQqTW
         iPyENYsaplAnU+zluM/1hKtDM80LMLHbkxsQFX2liOXWHCwmIrmoe7MT29RaGUhqG/+L
         7L0DTSwQwJNC9IVcDZhtQru4tiUF9CU23qWUC+QuGfAFMXHZG+6AVNuL7dEaPEe7S7Ba
         53gDbtti28TORF5eK5htEQisrry8sQnsmDIMoIvKJDIUnsnL5m26IO+X8kqtmE7QxGsQ
         9TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827627; x=1684419627;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VuHEI4+TYN1anXAPqDxS2fPdoIRrluy7efqigF6G4jY=;
        b=HXNyyPewyiP0Nnk7pwT3kf2aS+uBHdc9LHX5qW4NXqG5hePpCAEP+iZFla18WhFDrv
         FUnxu8k37HW2hm6fXeqfOCLGoUDPzhd5jEfic2WBZBqgXBe3Yd4FCLc7D6cQPPgLPrft
         2VxhUySwtP9JRpEzuM7ZqRDutf5CpdBEn6mNXmS6iO7FSvAkCaFi75990LgpZbeIO9Fw
         2hYzMKZ7/7CPsTPUnpBKwZGhO3NfK2FfN+KiTQAogLYcEvXHti3FEg5MJ8m/5y1piIZJ
         MIfUXnkWSTWV1NLqGaFAEM5RmZVmfe00UNKrJbOW9Kbjv9oU6fXXOXnuIpii1pVsmgb5
         lWyw==
X-Gm-Message-State: AAQBX9fYQ7RveTpmPVthuhNihrdXqz5R1f7iBNNDHlg1kxfQubHolUeJ
        GOgxAL1BODPNa2Xsv+HYQoWDew==
X-Google-Smtp-Source: AKy350ZaYPJIf97UUNHFeyU40oc8eUloLnyRkw5TUjopZLdr4iuSDHdhZ+U9UIHOux+HY+D67/iAmA==
X-Received: by 2002:a5d:404e:0:b0:2f7:725d:e7b4 with SMTP id w14-20020a5d404e000000b002f7725de7b4mr2408994wrp.18.1681827627055;
        Tue, 18 Apr 2023 07:20:27 -0700 (PDT)
Received: from ?IPV6:2a02:8011:e80c:0:192d:7ca1:96c2:5c9b? ([2a02:8011:e80c:0:192d:7ca1:96c2:5c9b])
        by smtp.gmail.com with ESMTPSA id v11-20020a5d678b000000b002fa834e1c69sm5205346wru.52.2023.04.18.07.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 07:20:26 -0700 (PDT)
Message-ID: <b325e432-7652-96d3-055a-0107a88ea1fa@isovalent.com>
Date:   Tue, 18 Apr 2023 15:20:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next v3 5/6] tools: bpftool: print netfilter link info
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-6-fw@strlen.de>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20230418131038.18054-6-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-18 15:10 UTC+0200 ~ Florian Westphal <fw@strlen.de>
> Dump protocol family, hook and priority value:
> $ bpftool link
> 2: netfilter  prog 14
>         ip input prio -128
>         pids install(3264)
> 5: netfilter  prog 14
>         ip6 forward prio 21
>         pids a.out(3387)
> 9: netfilter  prog 14
>         ip prerouting prio 123
>         pids a.out(5700)
> 10: netfilter  prog 14
>         ip input prio 21
>         pids test2(5701)
> 
> v2: Quentin Monnet suggested to also add 'bpftool net' support:
> 
> $ bpftool net
> xdp:
> 
> tc:
> 
> flow_dissector:
> 
> netfilter:
> 
>         ip prerouting prio 21 prog_id 14
>         ip input prio -128 prog_id 14
>         ip input prio 21 prog_id 14
>         ip forward prio 21 prog_id 14
>         ip output prio 21 prog_id 14
>         ip postrouting prio 21 prog_id 14
> 
> 'bpftool net' only dumps netfilter link type.  netfilter links are sorted by
> protocol family, hook and priority.
> 
> Suggested-by: Quentin Monnet <quentin@isovalent.com>
> Link: https://lore.kernel.org/bpf/eeeaac99-9053-90c2-aa33-cc1ecb1ae9ca@isovalent.com/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/bpf/bpftool/link.c       |  83 ++++++++++++++++++++++++++
>  tools/bpf/bpftool/main.h       |   3 +
>  tools/bpf/bpftool/net.c        | 105 +++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  15 +++++
>  tools/lib/bpf/libbpf.c         |   2 +
>  5 files changed, 208 insertions(+)
> 

> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index c40e44c938ae..61710cc63ef7 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -647,6 +647,107 @@ static int do_detach(int argc, char **argv)

> +static void show_link_netfilter(void)
> +{
> +	unsigned int nf_link_len = 0, nf_link_count = 0;
> +	struct bpf_link_info *nf_link_info = NULL;
> +	__u32 id = 0;
> +
> +	while (true) {
> +		struct bpf_link_info info;
> +		int fd, err;
> +		__u32 len;
> +
> +		err = bpf_link_get_next_id(id, &id);
> +		if (err) {
> +			if (errno == ENOENT)
> +				break;
> +			p_err("can't get next link: %s (id %d)", strerror(errno), id);
> +			break;
> +		}
> +
> +		fd = bpf_link_get_fd_by_id(id);
> +		if (fd < 0) {
> +			p_err("can't get link by id (%u): %s", id, strerror(errno));
> +			continue;
> +		}
> +
> +		memset(&info, 0, sizeof(info));
> +		len = sizeof(info);
> +
> +		err = bpf_link_get_info_by_fd(fd, &info, &len);
> +
> +		close(fd);
> +
> +		if (err) {
> +			p_err("can't get link info for fd %d: %s", fd, strerror(errno));
> +			continue;
> +		}
> +
> +		if (info.type != BPF_LINK_TYPE_NETFILTER)
> +			continue;
> +
> +		if (nf_link_count >= nf_link_len) {
> +			struct bpf_link_info *expand;
> +
> +			if (nf_link_count > (INT_MAX / sizeof(info))) {
> +				fprintf(stderr, "link count %d\n", nf_link_count);

The only nit I have is that we could use p_err() here, and have a more
descriptive message (letting user know that we've reached a limit).

Looks all good otherwise. Thanks!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
