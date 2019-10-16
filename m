Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8DD8810
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbfJPFXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:23:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43245 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfJPFXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:23:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id i32so13542953pgl.10;
        Tue, 15 Oct 2019 22:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7dqAkDETKOIEKkdWiPPT+xp/6+UjqmTALtad5nl8xMw=;
        b=FQaMRW9G0t+yy+7C6por4iWfh76yAqcPE67KdIa5tk/KKt1eDAwQsEVRAn0lPK+p3h
         /r6uMz5UPvHvVw09JZ8AT490qbxfshHcbln+vrPHhzItcWlqSzoNMB+exzmKEEdUXW8z
         qdpbCmdbe2MKynj8ftWOsgGHcSBUKOuKHeMFZzBMGLkQj0yX9o5Xj+20y2beJ+UT6RfE
         Nd+q6yJBbOJkxQhzfunkTessRZ+a/35EC6Tgk7dHGpdCNmuSB7EDLgYAoEgfcIxUoRZn
         5+dv8EQdcVdd7dnWSARqYCy0tudd1tb+SiA5C7iu7w9wF7y8zD2tzgkC2Wjw4nIq0q+3
         M9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7dqAkDETKOIEKkdWiPPT+xp/6+UjqmTALtad5nl8xMw=;
        b=cd7153nP9Yip4AT6wUsLMfcUrYEt3MOWOX/wQaJuZmHoOvkkBFK73dd+SfHQz53J1p
         f5rLGd8OaL/PD9khguM66Yp9EcYC/yIdWQLsllNfVfAWV9jAQt8MrIVT6nVtBbRkj1ny
         LaUVXjlvLLdxmYXT+LH51sIJRpwSEXlCeafz8nC7bZRPJ2hDAVsTxgGgfUMBxQfodyYJ
         9I/X8NEg0HsUKkuOROr/XlNgLuRxlKBJMOgn7hwVqcSsUfli7DAWhuLZzPZteX9bY/6U
         sTzlyEA+uDhHupnrTlxhfJBjbk0oDTpTSNo67/YGCa0G3mzDJGZVVJaJ2q+PIkQMRD4u
         8TPQ==
X-Gm-Message-State: APjAAAWYi7eqop9k50KZRmJSIaZUsG7pIATd5eN4lofSMNG5zqI4U5yx
        AyUXX2O+FpH73+cnlXsDxKA=
X-Google-Smtp-Source: APXvYqwz5D/0a6wRSKUeqRTr3fbqjKn6VUPUxfSFiyCiNNfAnXibRjxxLAUMQlks+GD8M0LkaHN3bA==
X-Received: by 2002:a62:5305:: with SMTP id h5mr43761916pfb.121.1571203409261;
        Tue, 15 Oct 2019 22:23:29 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::8bc])
        by smtp.gmail.com with ESMTPSA id c34sm2051958pgb.35.2019.10.15.22.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 22:23:28 -0700 (PDT)
Date:   Tue, 15 Oct 2019 22:23:26 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 1/3] bpf: use check_zeroed_user() in
 bpf_check_uarg_tail_zero()
Message-ID: <20191016052324.2owkg2zochq5l7l3@ast-mbp>
References: <20191016004138.24845-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-1-christian.brauner@ubuntu.com>
 <20191016034432.4418-2-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016034432.4418-2-christian.brauner@ubuntu.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 05:44:30AM +0200, Christian Brauner wrote:
> In v5.4-rc2 we added a new helper (cf. [1]) check_zeroed_user() which
> does what bpf_check_uarg_tail_zero() is doing generically. We're slowly
> switching such codepaths over to use check_zeroed_user() instead of
> using their own hand-rolled version.
> 
> [1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: bpf@vger.kernel.org
> Acked-by: Aleksa Sarai <cyphar@cyphar.com>
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
> /* v1 */
> Link: https://lore.kernel.org/r/20191009160907.10981-2-christian.brauner@ubuntu.com
> 
> /* v2 */
> Link: https://lore.kernel.org/r/20191016004138.24845-2-christian.brauner@ubuntu.com
> - Alexei Starovoitov <ast@kernel.org>:
>   - Add a comment in bpf_check_uarg_tail_zero() to clarify that
>     copy_struct_from_user() should be used whenever possible instead.
> 
> /* v3 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - use correct checks for check_zeroed_user()
> ---
>  kernel/bpf/syscall.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 82eabd4e38ad..40edcaeccd71 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -58,35 +58,28 @@ static const struct bpf_map_ops * const bpf_map_types[] = {
>   * There is a ToCToU between this function call and the following
>   * copy_from_user() call. However, this is not a concern since this function is
>   * meant to be a future-proofing of bits.
> + *
> + * Note, instead of using bpf_check_uarg_tail_zero() followed by
> + * copy_from_user() use the dedicated copy_struct_from_user() helper which
> + * performs both tasks whenever possible.
>   */
>  int bpf_check_uarg_tail_zero(void __user *uaddr,
>  			     size_t expected_size,
>  			     size_t actual_size)
>  {
> -	unsigned char __user *addr;
> -	unsigned char __user *end;
> -	unsigned char val;
> +	size_t size = min(expected_size, actual_size);
> +	size_t rest = max(expected_size, actual_size) - size;
>  	int err;
>  
>  	if (unlikely(actual_size > PAGE_SIZE))	/* silly large */
>  		return -E2BIG;
>  
> -	if (unlikely(!access_ok(uaddr, actual_size)))
> -		return -EFAULT;
> -
>  	if (actual_size <= expected_size)
>  		return 0;
>  
> -	addr = uaddr + expected_size;
> -	end  = uaddr + actual_size;
> -
> -	for (; addr < end; addr++) {
> -		err = get_user(val, addr);
> -		if (err)
> -			return err;
> -		if (val)
> -			return -E2BIG;
> -	}
> +	err = check_zeroed_user(uaddr + expected_size, rest);

Just noticed this 'rest' math.
I bet compiler can optimize unnecessary min+max, but
let's save it from that job.
Just do actual_size - expected_size here instead.

