Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9644D8818
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbfJPFZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:25:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36080 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfJPFZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:25:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so13569148pgk.3;
        Tue, 15 Oct 2019 22:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tgB81cyefpFakuk6zdIviYL9506XtYk1wgoR57DN6ms=;
        b=t3AjPm/ueds16Gdc4Of68h6MdRIa86PNBEG9y0li57o+Du0tLW/soOBC13TpTMbb5c
         Jy0I1fdBqm7f7JqN91yx1u+AgkBhw+vHNLeOXb08q9HiI6GHXgioQXuAG1evS8e4Z8oz
         KCUQaEABhM5N2zjxXb2oUMMox6UUGhPpyeIxKuLpBUK522qJjm5Dkopr33REYbN5TGrf
         oHNy/z532OpDRetnTf8XSO7EQswSTCl8PdapIoVztalq9+gC+0lHx0cQ0Jx+/1MunUmC
         LhC5Z7deAAYOgd8L2lpwjSZGNzQGfObMwrJZIf+Y8bqLEVHcyUlcvgi3ud6NSgfzVve9
         FH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tgB81cyefpFakuk6zdIviYL9506XtYk1wgoR57DN6ms=;
        b=JPiVBeSSN6rvFAsRl4RM5JQgoZanFhhZuhEV404dRpYluC8+3v2k7cCmkb+Mh7zeE4
         aLeotgoWnotfiWbonfaEyqLud1kTwoC7sRrHa7rfKgxBbb/qlJK8KhU+XAikMd5rpOZe
         eg5ux+1oL+uh6PgrZFiV8b00fwaehyZWxHvRjjv0/FhW4/Tj1NZyoM09K4IuOTynpGl1
         /utNWSs7FEwaAHMs1yqV4PQzHCMAq95MtLS9B91W3IddxNnJIGf1IkETIAqSPM8/iRLH
         0vAlXnl5hVNtpzpO5RlLtCRULt8m4CU017OxRSXQz3l1m10bRup6epN9tuq+iWOwnBZo
         wAyw==
X-Gm-Message-State: APjAAAVeFWZVv2DgTiNvXSJTEAxuDHM8wARLQ3d6TGKdtc+plYuhXtMj
        d+p8YJd2F2I8cEFQnZHKg1E=
X-Google-Smtp-Source: APXvYqydb+5ITh8DgK3MAx2K6IDcb2fS1NWR7rTVdKOYao+qPBPYmgM4znQ/lj+TXnVeQTyVa+kO0w==
X-Received: by 2002:a63:748:: with SMTP id 69mr24364599pgh.109.1571203552176;
        Tue, 15 Oct 2019 22:25:52 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::8bc])
        by smtp.gmail.com with ESMTPSA id i184sm26355174pge.5.2019.10.15.22.25.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 22:25:51 -0700 (PDT)
Date:   Tue, 15 Oct 2019 22:25:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 2/3] bpf: use copy_struct_from_user() in
 bpf_prog_get_info_by_fd()
Message-ID: <20191016052548.gktf2ctvee7mrwlr@ast-mbp>
References: <20191016004138.24845-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016034432.4418-3-christian.brauner@ubuntu.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 05:44:31AM +0200, Christian Brauner wrote:
> In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
> This helper is intended for all codepaths that copy structs from
> userspace that are versioned by size. bpf_prog_get_info_by_fd() does
> exactly what copy_struct_from_user() is doing.
> Note that copy_struct_from_user() is calling min() already. So
> technically, the min_t() call could go. But the info_len is used further
> below so leave it.
> 
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: bpf@vger.kernel.org
> Acked-by: Aleksa Sarai <cyphar@cyphar.com>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v1 */
> Link: https://lore.kernel.org/r/20191009160907.10981-3-christian.brauner@ubuntu.com
> 
> /* v2 */
> Link: https://lore.kernel.org/r/20191016004138.24845-3-christian.brauner@ubuntu.com
> - Alexei Starovoitov <ast@kernel.org>:
>   - remove unneeded initialization
> 
> /* v3 */
> unchanged
> ---
>  kernel/bpf/syscall.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 40edcaeccd71..151447f314ca 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2306,20 +2306,17 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
>  				   union bpf_attr __user *uattr)
>  {
>  	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
> -	struct bpf_prog_info info = {};
> +	struct bpf_prog_info info;
>  	u32 info_len = attr->info.info_len;
>  	struct bpf_prog_stats stats;
>  	char __user *uinsns;
>  	u32 ulen;
>  	int err;
>  
> -	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
> +	info_len = min_t(u32, sizeof(info), info_len);
> +	err = copy_struct_from_user(&info, sizeof(info), uinfo, info_len);

really?! min?!
Frankly I'm disappointed in quality of these patches.
Especially considering it's v3.

Just live the code alone.

