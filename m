Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756AADB06F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 16:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406172AbfJQOtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 10:49:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:59478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405405AbfJQOtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 10:49:50 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iL765-0003Nx-83; Thu, 17 Oct 2019 16:49:49 +0200
Received: from [178.197.249.55] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iL765-000CzU-0G; Thu, 17 Oct 2019 16:49:49 +0200
Subject: Re: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file
 descriptor to a pathname
To:     Zwb <ethercflow@gmail.com>, netdev@vger.kernel.org
Cc:     yhs@fb.com
References: <20191017092631.3739-1-ethercflow@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <365b18db-cf7f-1d1d-f048-7220eb702e8f@iogearbox.net>
Date:   Thu, 17 Oct 2019 16:49:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191017092631.3739-1-ethercflow@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25605/Thu Oct 17 10:52:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/19 11:26 AM, Zwb wrote:
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
> 
> Signed-off-by: Zwb <ethercflow@gmail.com>

SOB requires that there is a proper name, see Documentation/process/submitting-patches.rst +431.

[...]
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a65c3b0c6935..a4a5d432e572 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2769,6 +2769,7 @@ union bpf_attr {
>   	FN(get_current_pid_tgid),	\
>   	FN(get_current_uid_gid),	\
>   	FN(get_current_comm),		\
> +	FN(fd2path),			\

Adding into the middle will break existing BPF programs. Helper description is also missing.

>   	FN(get_cgroup_classid),		\
>   	FN(skb_vlan_push),		\
>   	FN(skb_vlan_pop),		\
