Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79022AC6C8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgKIVSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIVSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:18:12 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B028FC0613CF;
        Mon,  9 Nov 2020 13:18:10 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id a15so8689883otf.5;
        Mon, 09 Nov 2020 13:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=59zjdzQyhp71sMG1iWXtFCQNcH3XvIU0Stj+Q44iaHY=;
        b=BePoM79U3tOCqKP03BDWCIpjbvRQ76t9rRYgVJCjTKsfb3ipNwEB+fJ9OLqZeXWiB6
         hPFACET1kpaDIg36+CZEqAc7S6SVLjmBjKgzzBum9Bfb/EDJ5xYPY9wzbutrApV52OdQ
         gXr9wv8GZgyEgVmz60C9fyt1UtfDf6kBTgyAVY1BANszUec08P/UqThKVrjN320rCCzn
         wOEFK5VWKAAQEDZQci/H3TQDD9soIEukprXlcPglHr9il7eYJx4RQOwhWVxPgdz6Co58
         1CkJT8zwai0tGXo4uG4wzZgOEbaScmzSEnsBWI6+q8S9QlY3aL0NG3qNexXaUzbpeTMV
         2K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=59zjdzQyhp71sMG1iWXtFCQNcH3XvIU0Stj+Q44iaHY=;
        b=tCldRHhmPlz50ZEMrcQfMbc3qGAPEj3x1tPolclPr1H3l1k8nO8vxhEIX29Epk19ly
         6/vtR52betfWXaPLS9rUGDoStvIMVUGvkIw0UHY2BKQ2gFZIRUBNwatPp16Rz+5iV0am
         KkupCsVhAatonAwd7y6vHAsr2Vyc5/zXLNyUt3bohKE5lGUZv3QKEs6IW5IjXAPpwd+B
         CN1funXkc7Wcwa0JdQvqD6/0c7loRi8muBStvzYTwS0tTqcwajzTNpuHp89WH0KRl9lN
         4ayI9e5bUdRfY5nOpulArsvmhcoxL03irgQkwaPLU41OetDzvPhv3tx29E8GkUO5dbL7
         gkKw==
X-Gm-Message-State: AOAM532ul81V9Br3BNic1NPhhTpo2u/h5pCo8RtAaE1qVcbAoTf09e0/
        WcwOnE2VmznSmwT8QTma/Tw=
X-Google-Smtp-Source: ABdhPJy7zBoSPSd6sF9tk44JcNBE39Gv+8c70Pz8yU8jNpswflIx5sqMRbq/48X9vuCgZrjRcOqBZA==
X-Received: by 2002:a05:6830:1556:: with SMTP id l22mr12594411otp.102.1604956690092;
        Mon, 09 Nov 2020 13:18:10 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c14sm2802175otp.1.2020.11.09.13.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:18:09 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:18:01 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Qing <wangqing@vivo.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Message-ID: <5fa9b209b7eeb_8c0e208f3@john-XPS-13-9370.notmuch>
In-Reply-To: <1604735144-686-1-git-send-email-wangqing@vivo.com>
References: <1604735144-686-1-git-send-email-wangqing@vivo.com>
Subject: RE: [PATCH v3 bpf] trace: bpf: Fix passing zero to PTR_ERR()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Qing wrote:
> There is a bug when passing zero to PTR_ERR() and return.
> Fix smatch err.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  kernel/trace/bpf_trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 4517c8b..5113fd4
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1198,7 +1198,7 @@ static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
>  	*btf = bpf_get_btf_vmlinux();
>  
>  	if (IS_ERR_OR_NULL(*btf))
> -		return PTR_ERR(*btf);
> +		return IS_ERR(*btf) ? PTR_ERR(*btf) : -EINVAL;
>  
>  	if (ptr->type_id > 0)
>  		*btf_id = ptr->type_id;
> -- 
> 2.7.4
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
