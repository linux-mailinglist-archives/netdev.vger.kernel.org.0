Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247C76F44AD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbjEBNH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbjEBNHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:07:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2857D4C2B;
        Tue,  2 May 2023 06:07:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9505214c47fso761757466b.1;
        Tue, 02 May 2023 06:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683032871; x=1685624871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+GJbRK7NkBHT5P0SByo+bizLoBFa/LKd0gSPw0CG9Yo=;
        b=heKzPGB40eEZ3mu2tTF8ufuteeVqQJG6vKU8HLGtIlfTaLFZHKXUU+q9dnF12ULBe3
         fAXGweIdFWnpz6BOmop/7OeCNPq1AutngcHCWKUNG/5kPLgsFEvqY51rQ7yOxCdUAOwd
         AO6i33I+VJSnsHyE208yxHd82oBUjL9tY4CYxJfjBNxQ/QgrB9+u2uH1OvDMZP18NMkJ
         HFpu83oPmeiuPJRNEhSPX//9AeDAJE1cXhXaB6hkch77P9jMiIFxFoySZKVDIyNvPIjK
         a/cmP8npQ/aC6f1C+CVdZgPDgSsY5v4R5pbA8IgmNJCch99SqiqYD0SNRQ2u+yH5j6U9
         hDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683032871; x=1685624871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+GJbRK7NkBHT5P0SByo+bizLoBFa/LKd0gSPw0CG9Yo=;
        b=S/VMJTmUDdUp2KusW+1W6Ag5aCXWld/IBWw44GlBkpMktvxb6bdQYCaO5UDO+FupYr
         ZVN0zKxmwfF0SfyN+CFGziqOK813GjHibovMOTrhEvM+STq0Ky/lNQ9BVY+vaOJbWPdd
         7iNK5nlDCBVXfwn7mtmMBH5u52q0t3CLGYWSkj1eCXpJS3BiwduzP0xjg1lcK6mkvMo8
         U4TsG3H5rN57qYd3B/PGf9dISlTaAilM/P8PCQ9yXnWxKKGhFFEf6nLj9mvhtjsVXQEc
         hIjiQzpy08ULjVZRJdwh8ItTZQT5xvajTh2y7Emgqdmfrv9DBZpbfz8NO7wGGxA/bxp8
         4gjQ==
X-Gm-Message-State: AC+VfDw3mVXSOuNBni3HhVTllvUycq7c5xZ5MowZiUD4Jz2vMAeRSu76
        spjbeDFrjHsGxoesWgMVaoU=
X-Google-Smtp-Source: ACHHUZ44X9DtAeoyHRZNkRdg7pdRHPunZQB32m64P/Zy5iQ+QdWEYwBbFJz7+J+f/BRXCAk/+E9eIQ==
X-Received: by 2002:a17:907:1c24:b0:94e:c43f:316b with SMTP id nc36-20020a1709071c2400b0094ec43f316bmr17066747ejc.19.1683032871384;
        Tue, 02 May 2023 06:07:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::20ef? ([2620:10d:c092:600::2:18ee])
        by smtp.gmail.com with ESMTPSA id s16-20020a170906169000b0094ec3271be5sm16043180ejd.53.2023.05.02.06.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 06:07:51 -0700 (PDT)
Message-ID: <49866ae2-db19-083c-6498-e7d9d62e8267@gmail.com>
Date:   Tue, 2 May 2023 14:03:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Adrien Delorme <delorme.ade@outlook.com>,
        "david.laight@aculab.com" <david.laight@aculab.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "leit@fb.com" <leit@fb.com>,
        "leitao@debian.org" <leitao@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "willemb@google.com" <willemb@google.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
References: <GV1P193MB200533CC9A694C4066F4807CEA6F9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <GV1P193MB200533CC9A694C4066F4807CEA6F9@GV1P193MB2005.EURP193.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/23 10:21, Adrien Delorme wrote:
>  From Adrien Delorme
> 
>> From: David Ahern
>> Sent: 12 April 2023 7:39
>>> Sent: 11 April 2023 16:28
>> ....
>>> Christoph's patch set a few years back that removed set_fs broke the
>>> ability to do in-kernel ioctl and {s,g}setsockopt calls. I did not
>>> follow that change; was it a deliberate intent to not allow these
>>> in-kernel calls vs wanting to remove the set_fs? e.g., can we add a
>>> kioctl variant for in-kernel use of the APIs?
>>
>> I think that was a side effect, and with no in-tree in-kernel
>> users (apart from limited calls in bpf) it was deemed acceptable.
>> (It is a PITA for any code trying to use SCTP in kernel.)
>>
>> One problem is that not all sockopt calls pass the correct length.
>> And some of them can have very long buffers.
>> Not to mention the ones that are read-modify-write.
>>
>> A plausible solution is to pass a 'fat pointer' that contains
>> some, or all, of:
>>        - A userspace buffer pointer.
>>        - A kernel buffer pointer.
>>        - The length supplied by the user.
>>        - The length of the kernel buffer.
>>        = The number of bytes to copy on completion.
>> For simple user requests the syscall entry/exit code
>> would copy the data to a short on-stack buffer.
>> Kernel users just pass the kernel address.
>> Odd requests can just use the user pointer.
>>
>> Probably needs accessors that add in an offset.
>>
>> It might also be that some of the problematic sockopt
>> were in decnet - now removed.
> 
> Hello everyone,
> 
> I'm currently working on an implementation of {get,set} sockopt.
> Since this thread is already talking about it, I hope that I replying at the correct place.

Hi Adrien, I believe Breno is working on set/getsockopt as well
and had similar patches for awhile, but that would need for some
problems to be solved first, e.g. try and decide whether it copies
to a ptr as the syscall versions or would get/return optval
directly in sqe/cqe. And also where to store bits that you pass
in struct args_setsockopt_uring, and whether to rely on SQE128
or not.


> My implementation is rather simple using a struct that will be used to pass the necessary info throught sqe->cmd.
> 
> Here is my implementation based of kernel version 6.3 :
> 
> Signed-off-by: Adrien Delorme <delorme.ade@outlook.com>
> 
> diff -uprN a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> --- a/include/uapi/linux/io_uring.h     2023-04-23 15:02:52.000000000 -0400
> +++ b/include/uapi/linux/io_uring.h     2023-04-24 07:55:21.406981696 -0400
> @@ -235,6 +235,25 @@ enum io_uring_op {
>    */
> #define IORING_URING_CMD_FIXED (1U << 0)
> 
> +/* struct io_uring_cmd->cmd_op flags for socket operations */
> +#define IO_URING_CMD_OP_GETSOCKOPT 0x0
> +#define IO_URING_CMD_OP_SETSOCKOPT 0x1
> +
> +/* Struct to pass args for IO_URING_CMD_OP_GETSOCKOPT and IO_URING_CMD_OP_SETSOCKOPT operations */
> +struct args_setsockopt_uring{

The name of the structure is quite inconsistent with the
rest. It's better to be io_[uring_]_sockopt_arg or some
variation.

> +       int                             level;
> +       int                     optname;
> +       char __user *   user_optval;
> +       int                     optlen;

That's uapi, there should not be __user, and field sizes
should be more portable, i.e. use __u32, __u64, etc, look
through the file.

Would need to look into the get/setsockopt implementation
before saying anything about uring_cmd_{set,get}sockopt.


> +};
> +
> +struct args_getsockopt_uring{
> +       int                             level;
> +       int                     optname;
> +       char __user *   user_optval;
> +       int      __user *       optlen;
> +};
> +
> 
> /*
>    * sqe->fsync_flags
> diff -uprN a/net/socket.c b/net/socket.c
> --- a/net/socket.c      2023-04-23 15:02:52.000000000 -0400
> +++ b/net/socket.c      2023-04-24 08:06:44.800981696 -0400
> @@ -108,6 +108,11 @@
> #include <linux/ptp_clock_kernel.h>
> #include <trace/events/sock.h>
> 
> +#ifdef CONFIG_IO_URING
> +#include <uapi/linux/io_uring.h>
> +#include <linux/io_uring.h>
> +#endif
> +
> #ifdef CONFIG_NET_RX_BUSY_POLL
> unsigned int sysctl_net_busy_read __read_mostly;
> unsigned int sysctl_net_busy_poll __read_mostly;
> @@ -132,6 +137,11 @@ static ssize_t sock_splice_read(struct f
>                                  struct pipe_inode_info *pipe, size_t len,
>                                  unsigned int flags);
> 
> +
> +#ifdef CONFIG_IO_URING
> +int socket_uring_cmd_handler(struct io_uring_cmd *cmd, unsigned int flags);
> +#endif
> +
> #ifdef CONFIG_PROC_FS
> static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> {
> @@ -166,6 +176,9 @@ static const struct file_operations sock
>          .splice_write = generic_splice_sendpage,
>          .splice_read =  sock_splice_read,
>          .show_fdinfo =  sock_show_fdinfo,
> +#ifdef CONFIG_IO_URING
> +       .uring_cmd = socket_uring_cmd_handler,
> +#endif
> };
> 
> static const char * const pf_family_names[] = {
> @@ -2330,6 +2343,126 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int
>          return __sys_getsockopt(fd, level, optname, optval, optlen);
> }
> 
> +#ifdef CONFIG_IO_URING
> +
> +/*
> + * Make getsockopt operation with io_uring.
> + * This fonction is based of the __sys_getsockopt without sockfd_lookup_light
> + * since io_uring retrieves it for us.
> + */
> +int uring_cmd_getsockopt(struct socket *sock, int level, int optname, char __user *optval,
> +               int __user *optlen)
> +{
> +       int err;
> +       int max_optlen;
> +
> +       err = security_socket_getsockopt(sock, level, optname);
> +       if (err)
> +               goto out_put;
> +
> +       if (!in_compat_syscall())
> +               max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
> +
> +       if (level == SOL_SOCKET)
> +               err = sock_getsockopt(sock, level, optname, optval, optlen);
> +       else if (unlikely(!sock->ops->getsockopt))
> +               err = -EOPNOTSUPP;
> +       else
> +               err = sock->ops->getsockopt(sock, level, optname, optval,
> +                                           optlen);
> +
> +       if (!in_compat_syscall())
> +               err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
> +                                                    optval, optlen, max_optlen,
> +                                                    err);
> +out_put:
> +       return err;
> +}
> +
> +/*
> + * Make setsockopt operation with io_uring.
> + * This fonction is based of the __sys_setsockopt without sockfd_lookup_light
> + * since io_uring retrieves it for us.
> + */
> +int uring_cmd_setsockopt(struct socket *sock, int level, int optname, char *user_optval,
> +               int optlen)
> +{
> +       sockptr_t optval = USER_SOCKPTR(user_optval);
> +       char *kernel_optval = NULL;
> +       int err;
> +
> +       if (optlen < 0)
> +               return -EINVAL;
> +
> +       err = security_socket_setsockopt(sock, level, optname);
> +       if (err)
> +               goto out_put;
> +
> +       if (!in_compat_syscall())
> +               err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
> +                                                    user_optval, &optlen,
> +                                                    &kernel_optval);
> +       if (err < 0)
> +               goto out_put;
> +       if (err > 0) {
> +               err = 0;
> +               goto out_put;
> +       }
> +
> +       if (kernel_optval)
> +               optval = KERNEL_SOCKPTR(kernel_optval);
> +       if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
> +               err = sock_setsockopt(sock, level, optname, optval, optlen);
> +       else if (unlikely(!sock->ops->setsockopt))
> +               err = -EOPNOTSUPP;
> +       else
> +               err = sock->ops->setsockopt(sock, level, optname, optval,
> +                                           optlen);
> +       kfree(kernel_optval);
> +out_put:
> +       return err;
> +}
> +
> +/*
> + * Handler uring_cmd socket file_operations.
> + *
> + * Operation code and struct are defined in /include/uapi/linux/io_uring.h
> + * The io_uring ring needs to be set with the flags : IORING_SETUP_SQE128 and IORING_SETUP_CQE32
> + *
> + */
> +int socket_uring_cmd_handler(struct io_uring_cmd *cmd, unsigned int flags){
> +
> +       /* Retrieve socket */
> +       struct socket *sock = sock_from_file(cmd->file);
> +
> +       if (!sock)
> +               return -EINVAL;
> +
> +       /* Does the requested operation */
> +       switch (cmd->cmd_op) {
> +               case IO_URING_CMD_OP_GETSOCKOPT:
> +                       struct args_getsockopt_uring *values_get = (struct args_getsockopt_uring *) cmd->cmd;
> +                       return uring_cmd_getsockopt(sock,
> +                                                                               values_get->level,
> +                                                                               values_get->optname,
> +                                                                               values_get->user_optval,
> +                                                                               values_get->optlen);
> +
> +               case IO_URING_CMD_OP_SETSOCKOPT:
> +                       struct args_setsockopt_uring *values_set = (struct args_setsockopt_uring *) cmd->cmd;
> +                       return uring_cmd_setsockopt(sock,
> +                                                                               values_set->level,
> +                                                                               values_set->optname,
> +                                                                               values_set->user_optval,
> +                                                                               values_set->optlen);
> +               default:
> +                       break;
> +
> +       }
> +       return -EINVAL;
> +}
> +#endif
> +
> /*
>    *     Shutdown a socket.
>    */
> 
> I would appreciate any feedback or advice you may have on this work. Hopefully it will be of some kind of help. Thank you for your time and consideration.
> 
> Adrien

-- 
Pavel Begunkov
