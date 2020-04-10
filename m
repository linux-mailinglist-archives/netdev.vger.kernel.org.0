Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDCDB1A3E8C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 05:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDJDAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 23:00:23 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50798 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgDJDAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 23:00:23 -0400
Received: by mail-pj1-f68.google.com with SMTP id b7so303368pju.0;
        Thu, 09 Apr 2020 20:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AQk4mNPo1rM91Nw8K13eaCa0gv8MYDldNLpKlwDrZFQ=;
        b=lHVW7mQVsZzwww/iWDUQJIpgCMJ2jxDDqrxeEIAO9xkq/TyuKo1u21PLccMFAa/lBz
         rqt7omDIsHJseYPOFiqe1eBmn8u0GkAxafxGnT9UC2h8insR0vSSSzDWBHW0gUOxtCOJ
         4tEm3/eoEDig9tuG+iPSo4SYuEtSK1PqjA7Niv/b2Dl/jhgMwF49zo/ElF40tOijGcKH
         Zp/cfYX9BQwGC3RWdWATAu1E7w8/cajQSzonUd4yh2VB6UQ2lJFCp3SQJ4cMkoFmEa6/
         gjhWfVjQTBRYOrNa+O9N/9p7WHYB+fPsAaRLieH4TEaVGrn8zFy5se5Ah3Il+EQ2GlvZ
         Al4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AQk4mNPo1rM91Nw8K13eaCa0gv8MYDldNLpKlwDrZFQ=;
        b=M9YdZSEta90qZXC9B1+Hp5lM8i4LCEKHCUKp9b9iI46XXWDzjz275gEo1E6uNshOMT
         KJIoA6grzW4gtodz0IwzK+PdBgJknVypro0QrGb8/DlRFO+Gurjwaol7n8gJvjJXx+oc
         IpcNsLo/MrYpj7AzNf6txtL37/tfuTiTpDxhqwmxTnvp0wx/rjzQ+qCJNHuzfNPPTDp1
         3znDIiFboxto+Rr7TDqNi7r09PgWNF7eDWoTem9rkqox5HUgEmmmyau+cp7WMniOgK8t
         T9L2e57Zon59mHLOnJOk55L2yIxN1oODW2zjB1ncFHvgj9PCGmxNLokJOor2eFTRqDCd
         r/Tg==
X-Gm-Message-State: AGi0PuZWRid2Nyckou5rtrztqIr71yVKfbf6VsJqIXZqMN8Vya+Qdu7g
        2LdkoOqOsiYR3zFg0WkWPfs=
X-Google-Smtp-Source: APiQypJlaKS5U3gT7aBUovoy0iPXJNzhHe46NT5UwqPGJKVUu+1Fzy5bwlDah7St3wVVfjTYT7CMvg==
X-Received: by 2002:a17:90a:80ca:: with SMTP id k10mr2949132pjw.45.1586487621076;
        Thu, 09 Apr 2020 20:00:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f219])
        by smtp.gmail.com with ESMTPSA id f9sm477692pjt.45.2020.04.09.20.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 20:00:20 -0700 (PDT)
Date:   Thu, 9 Apr 2020 20:00:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408232526.2675664-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 04:25:26PM -0700, Yonghong Song wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0f1cbed446c1..b51d56fc77f9 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -354,6 +354,7 @@ enum {
>  /* Flags for accessing BPF object from syscall side. */
>  	BPF_F_RDONLY		= (1U << 3),
>  	BPF_F_WRONLY		= (1U << 4),
> +	BPF_F_DUMP		= (1U << 5),
...
>  static int bpf_obj_pin(const union bpf_attr *attr)
>  {
> -	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags != 0)
> +	if (CHECK_ATTR(BPF_OBJ) || attr->file_flags & ~BPF_F_DUMP)
>  		return -EINVAL;
>  
> +	if (attr->file_flags == BPF_F_DUMP)
> +		return bpf_dump_create(attr->bpf_fd,
> +				       u64_to_user_ptr(attr->dumper_name));
> +
>  	return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
>  }

I think kernel can be a bit smarter here. There is no need for user space
to pass BPF_F_DUMP flag to kernel just to differentiate the pinning.
Can prog attach type be used instead?
