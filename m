Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489665106D5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351486AbiDZS3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243586AbiDZS3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:29:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94B8183BB;
        Tue, 26 Apr 2022 11:26:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so3295749pjm.1;
        Tue, 26 Apr 2022 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AIP/KCf31icd6aTpHu4ClIXTKExsYlc1nF9Ck4UBFO4=;
        b=ASh3DRkEA+Z+witYT+XGkDcp26/cSNzYH04ZMC3K4Ji5rv6SlfJSkLRnbQgE7bdVVu
         p095pvgktFtE0RChuFQyOd5U8nnq4TrnCphFU4IV4uoKXbO90BUBP8+q8LRsqEdSM8eo
         XTtGbiCsLHBaVt5oyCAhrgWgnvHSVVG2Q1oC6oYoKzsyRttdFsd75f6R9XqDPfrvTCjm
         QQh+nXS9vbh4M201Cx3PHuYFSa80VrHzCn3X3OiA1dgYisFd7oy8zSKdnrNajod7QKU6
         +kPKjb4bD3Oc/sngWsuYe76oyLPXPV9FBMihercuWYDbY720awauNE/usrTWoIv+N3KI
         LiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AIP/KCf31icd6aTpHu4ClIXTKExsYlc1nF9Ck4UBFO4=;
        b=KFV/tsbo6YCIQAnNYSGWrpm5yULi52QnqLAY8ZvNMmxWr4SsdxvUVYLyjCmoJh3fzl
         B1MMhWf4bvDFjSB6oXIqLI+dNvbJEsYsAWL9P9fOEFgi62VG9bU6tvrn4J8cYH3U6Wi2
         Ard9HYoL5cN1uI4OLlCF0+Q/bTBHEaq6fP27cEPnTnDid0DB0CYcXwsj5xDGkLwHl8FX
         idV/ZSHBcWBJYwX9HplcHhf/+KObyox/WUFPO8rKdnbtBVtVOrWQtcWK2A2b/CxJcGKc
         HMmcYLmR2a51FYZjlyXHnm3hQuFJXkUFGwWHjHiBdZUrVTCmweHIPO7yvZrziYVHum3O
         fr1w==
X-Gm-Message-State: AOAM531lcdZseCZ8JeFa/4yJbEbpRJnGWWl/2We3ZUic2dQAE3Ufingt
        Dbuh8iAMphv02jKgbcjfugU=
X-Google-Smtp-Source: ABdhPJymXnb+NXofYx8pw1ceObJBk1LTznmbck8j6egPTl+XzJzA8PLCRJZv1jy/Kzw3l9GA0BESfw==
X-Received: by 2002:a17:90b:3b8c:b0:1d4:c5e9:db89 with SMTP id pc12-20020a17090b3b8c00b001d4c5e9db89mr36307294pjb.178.1650997586035;
        Tue, 26 Apr 2022 11:26:26 -0700 (PDT)
Received: from MacBook-Pro.local ([2620:10d:c090:500::2:3e5a])
        by smtp.gmail.com with ESMTPSA id s13-20020aa78d4d000000b0050ab610d9fcsm15758543pfe.33.2022.04.26.11.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:26:25 -0700 (PDT)
Date:   Tue, 26 Apr 2022 11:26:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     menglong8.dong@gmail.com
Cc:     ast@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, benbjiang@tencent.com,
        flyingpeng@tencent.com, imagedong@tencent.com, edumazet@google.com,
        kafai@fb.com, talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] bpf: init map_btf_id during compiling
Message-ID: <20220426182621.kgut2bpateytcxaj@MacBook-Pro.local>
References: <20220424092613.863290-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424092613.863290-1-imagedong@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 05:26:13PM +0800, menglong8.dong@gmail.com wrote:
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0918a39279f6..588a001cc767 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4727,30 +4727,6 @@ static const struct bpf_map_ops * const btf_vmlinux_map_ops[] = {
>  #undef BPF_MAP_TYPE
>  };
>  
> -static int btf_vmlinux_map_ids_init(const struct btf *btf,
> -				    struct bpf_verifier_log *log)
> -{
> -	const struct bpf_map_ops *ops;
> -	int i, btf_id;
> -
> -	for (i = 0; i < ARRAY_SIZE(btf_vmlinux_map_ops); ++i) {
> -		ops = btf_vmlinux_map_ops[i];
> -		if (!ops || (!ops->map_btf_name && !ops->map_btf_id))
> -			continue;
> -		if (!ops->map_btf_name || !ops->map_btf_id) {
> -			bpf_log(log, "map type %d is misconfigured\n", i);
> -			return -EINVAL;
> -		}
> -		btf_id = btf_find_by_name_kind(btf, ops->map_btf_name,
> -					       BTF_KIND_STRUCT);
> -		if (btf_id < 0)
> -			return btf_id;
> -		*ops->map_btf_id = btf_id;
> -	}
> -
> -	return 0;
> -}
> -
>  static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
>  				     struct btf *btf,
>  				     const struct btf_type *t,
> @@ -4812,11 +4788,6 @@ struct btf *btf_parse_vmlinux(void)
>  	/* btf_parse_vmlinux() runs under bpf_verifier_lock */
>  	bpf_ctx_convert.t = btf_type_by_id(btf, bpf_ctx_convert_btf_id[0]);
>  
> -	/* find bpf map structs for map_ptr access checking */
> -	err = btf_vmlinux_map_ids_init(btf, log);
> -	if (err < 0)
> -		goto errout;
> -

Looks nice. Please address build warn and resubmit.
