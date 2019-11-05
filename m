Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C981F0930
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfKEWT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:19:56 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43284 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEWTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:19:55 -0500
Received: by mail-pf1-f194.google.com with SMTP id 3so17061760pfb.10;
        Tue, 05 Nov 2019 14:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DsHJmEIIIrm5llKfHfWNBac2bUAsjqDaDwcQrvpscP8=;
        b=CWs+xcgb2JUlniBdlpnaP7v822kSJG9v78gS6hXRgCduqHZMPJmIOOGpztM8xLuAQ4
         59inn80bDUNJqhMpVys9sNTkU4TqmCSZ7VpmfWp2vxIBiYdAjqLVoD+4UmgMmMpbsAI0
         qs6YnxbQe4DaSWY10VfMykz+MuptTJFhNs+rS96Pwa5Z+BVyQZd2CjIwtVGgCMLffEPB
         1XPIMjjX/A9RFx6UT++j+xILeZYx9yBkEmdR3NMkbMbN48HrXuTxqDUuHjaym0Aia4h7
         zWojO7jvFGACc+rIpelsKxVyKYoyKyHu2FC0TPVep5ZH1PTMvvPxIU81gnOs58aJ0Opl
         MwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DsHJmEIIIrm5llKfHfWNBac2bUAsjqDaDwcQrvpscP8=;
        b=do/rWKTvISy3gCveek18NKHKljeWeKmPrHkwk7lVxkSa7XsqfuCgcHLRLIRULWFzx7
         mN+fRLLNy86dvl8KbNo11sHq6L6eNyLOKUGefGKeTT//eXeJk24CjD+/nmy65YUdL15R
         7H74aa6HSfRp0Y3oo9p/xLOfZS1NqqKC/2KvVxY7hjVI82Bols8bY3lraOTkuECT5Djd
         i0dZyotLLslP73e8tSpNoqpxm4TdLltRXwCW3wSQf8x//+lDuhedeREIhI1s+z2dp4Qx
         iZqX4UkquRlFVuLRQNG/FIH1aft57pcni5P15z6/rFhkqAk9MrAnV/GPXWZxYRBoAjOu
         2FjQ==
X-Gm-Message-State: APjAAAWOVvb1Uh1r9SXuSYu6Lh+mbJVxpS2ixhWfzJuX4ZCpoPH5w3IA
        D0R8DU5L24cYI7Ft6mfzSJI=
X-Google-Smtp-Source: APXvYqx2Y5oP75Rj+JnSZXin+UXox17qajmTaFRiZnSmNKGVCyyoNBucADWiUWt+qoeJxrzvzWledw==
X-Received: by 2002:a63:a452:: with SMTP id c18mr38904159pgp.188.1572992394515;
        Tue, 05 Nov 2019 14:19:54 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id z14sm20498794pfq.66.2019.11.05.14.19.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:19:53 -0800 (PST)
Date:   Tue, 5 Nov 2019 14:19:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf@vger.kernel.org, yhs@fb.com, daniel@iogearbox.net,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v7] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191105221951.lxlitdtl7frkyrmk@ast-mbp.dhcp.thefacebook.com>
References: <20191103075417.36443-1-ethercflow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191103075417.36443-1-ethercflow@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 02:54:17AM -0500, Wenbo Zhang wrote:
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
> 
> This requirement is mainly discussed here:
> 
>   https://github.com/iovisor/bcc/issues/237
> 
> v6->v7:
> - fix missing signed-off-by line
> 
> v5->v6: addressed Andrii's feedback
> - avoid unnecessary goto end by having two explicit returns
> 
> v4->v5: addressed Andrii and Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
> - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> - remove fdput from fdget_raw's error path
> - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
> into the buffer or an error code if the path was too long
> - modify the normal path's return value to return copied string length
> including NUL
> - update this helper description's Return bits.
> 
> v3->v4: addressed Daniel's feedback
> - fix missing fdput()
> - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> - move fd2path's test code to another patch
> - add comment to explain why use fdget_raw instead of fdget
> 
> v2->v3: addressed Yonghong's feedback
> - remove unnecessary LOCKDOWN_BPF_READ
> - refactor error handling section for enhanced readability
> - provide a test case in tools/testing/selftests/bpf
> 
> v1->v2: addressed Daniel's feedback
> - fix backward compatibility
> - add this helper description
> - fix signed-off name
> 
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---
>  include/uapi/linux/bpf.h       | 15 ++++++++++-
>  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 15 ++++++++++-
>  3 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a6bf19dabaab..d618a914c6fe 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2777,6 +2777,18 @@ union bpf_attr {
>   * 		restricted to raw_tracepoint bpf programs.
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
> + *
> + * int bpf_get_file_path(char *path, u32 size, int fd)
> + *	Description
> + *		Get **file** atrribute from the current task by *fd*, then call
> + *		**d_path** to get it's absolute path and copy it as string into
> + *		*path* of *size*. The **path** also support pseudo filesystems
> + *		(whether or not it can be mounted). The *size* must be strictly
> + *		positive. On success, the helper makes sure that the *path* is
> + *		NUL-terminated. On failure, it is filled with zeroes.
> + *	Return
> + *		On success, returns the length of the copied string INCLUDING
> + *		the trailing NUL, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -2890,7 +2902,8 @@ union bpf_attr {
>  	FN(sk_storage_delete),		\
>  	FN(send_signal),		\
>  	FN(tcp_gen_syncookie),		\
> -	FN(skb_output),
> +	FN(skb_output),			\
> +	FN(get_file_path),
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f50bf19f7a05..41be1c5989af 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -683,6 +683,52 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
>  	.arg1_type	= ARG_ANYTHING,
>  };
>  
> +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> +{
> +	struct fd f;
> +	char *p;
> +	int ret = -EBADF;
> +
> +	/* Use fdget_raw instead of fdget to support O_PATH, and
> +	 * fdget_raw doesn't have any sleepable code, so it's ok
> +	 * to be here.
> +	 */
> +	f = fdget_raw(fd);
> +	if (!f.file)
> +		goto error;
> +
> +	/* d_path doesn't have any sleepable code, so it's ok to
> +	 * be here. But it uses the current macro to get fs_struct
> +	 * (current->fs). So this helper shouldn't be called in
> +	 * interrupt context.
> +	 */
> +	p = d_path(&f.file->f_path, dst, size);
> +	if (IS_ERR(p)) {
> +		ret = PTR_ERR(p);
> +		fdput(f);
> +		goto error;
> +	}

This is definitely very useful helper that bpf tracing community has
been asking for long time, but I have few concerns with implementation:
- fdget_raw is only used inside fs/, so it doesn't look right to skip the layers.
- accessing current->fs is not always correct, so the code should somehow
  check that it's ok to do so, but I'm not sure if (in_irq()) would be enough.
- some implementations of d_dname do sleep.  For example: dmabuffs_dname.
  Though it seems to me that it's a bug in that particular FS. But I'd like
  to hear clear yes from VFS experts that fdget_raw() + d_path() is ok
  from preempt_disabled section.

The other alternative is to wait for sleepable and preemptible BPF programs to
appear. Which is probably a month or so away. Then all these issues will
disappear.

