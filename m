Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50D57E82D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 22:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGVUSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 16:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbiGVUSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 16:18:07 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1587F50A;
        Fri, 22 Jul 2022 13:18:06 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oEz62-0001L1-Ni; Fri, 22 Jul 2022 22:18:02 +0200
Received: from [194.230.146.161] (helo=localhost.localdomain)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oEz62-0007BH-6C; Fri, 22 Jul 2022 22:18:02 +0200
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
To:     "Paul E. McKenney" <paulmck@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, kernel-team@fb.com
References: <20220722180641.2902585-1-paulmck@kernel.org>
 <20220722180641.2902585-2-paulmck@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net>
Date:   Fri, 22 Jul 2022 22:17:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220722180641.2902585-2-paulmck@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26609/Fri Jul 22 09:56:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/22 8:06 PM, Paul E. McKenney wrote:
> This patch updates bpf_design_QA.rst to clarify that the ability to
> attach a BPF program to a given function in the kernel does not make
> that function become part of the Linux kernel's ABI.
> 
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> ---
>   Documentation/bpf/bpf_design_QA.rst | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/bpf/bpf_design_QA.rst b/Documentation/bpf/bpf_design_QA.rst
> index 2ed9128cfbec8..46337a60255e9 100644
> --- a/Documentation/bpf/bpf_design_QA.rst
> +++ b/Documentation/bpf/bpf_design_QA.rst
> @@ -279,3 +279,15 @@ cc (congestion-control) implementations.  If any of these kernel
>   functions has changed, both the in-tree and out-of-tree kernel tcp cc
>   implementations have to be changed.  The same goes for the bpf
>   programs and they have to be adjusted accordingly.
> +
> +Q: Attaching to kernel functions is an ABI?

small nit, I'd change to: Attaching to arbitrary kernel functions [...]

Otherwise I think this could be a bit misunderstood, e.g. most of the networking
programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
attaching programs is part of ABI.

Rest looks good, thanks for writing this up, Paul!

> +-------------------------------------------
> +Q: BPF programs can be attached to many kernel functions.  Do these
> +kernel functions become part of the ABI?
> +
> +A: NO.
> +
> +The kernel function prototypes will change, and BPF programs attaching to
> +them will need to change.  The BPF compile-once-run-everywhere (CO-RE)
> +should be used in order to make it easier to adapt your BPF programs to
> +different versions of the kernel.
> 

