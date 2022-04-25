Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5250E33D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiDYOg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiDYOg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:36:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68F38D8B;
        Mon, 25 Apr 2022 07:33:54 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizmj-000B7G-CL; Mon, 25 Apr 2022 16:33:53 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nizmi-000HBE-RJ; Mon, 25 Apr 2022 16:33:53 +0200
Subject: Re: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, ast@kernel.org,
        andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com>
 <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <513485c6-82ea-9cf0-1df0-3ea75935809c@iogearbox.net>
Date:   Mon, 25 Apr 2022 16:33:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220420222459.307649-3-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/22 12:24 AM, Mat Martineau wrote:
[...]
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index 0a3b0fb04a3b..5b3a6f783182 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -283,4 +283,10 @@ static inline int mptcpv6_init(void) { return 0; }
>   static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { }
>   #endif
>   
> +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
> +#else
> +static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk) { return NULL; }
> +#endif
> +

Where is this relevant to JIT specifically?

Thanks,
Daniel
