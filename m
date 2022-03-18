Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAB94DDC61
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiCRPG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiCRPGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:06:55 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BDB2019D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 08:05:33 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVEAW-000A2O-1Y; Fri, 18 Mar 2022 16:05:32 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVEAV-0001pz-T5; Fri, 18 Mar 2022 16:05:31 +0100
Subject: Re: [PATCH bpf] selftests/bpf: exit with error code if test failed
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Alexei Starovoitov <ast@kernel.org>
References: <20220317071805.43121-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4a8e0d47-5498-2175-57ca-374ee9985b1f@iogearbox.net>
Date:   Fri, 18 Mar 2022 16:05:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220317071805.43121-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26485/Fri Mar 18 09:26:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 8:18 AM, Hangbin Liu wrote:
> The test_lirc_mode2.sh test exit with 0 even test failed. Fix it by
> exiting with an error code.
> 
> Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   tools/testing/selftests/bpf/test_lirc_mode2.sh | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_lirc_mode2.sh b/tools/testing/selftests/bpf/test_lirc_mode2.sh
> index ec4e15948e40..420dc86362f5 100755
> --- a/tools/testing/selftests/bpf/test_lirc_mode2.sh
> +++ b/tools/testing/selftests/bpf/test_lirc_mode2.sh
> @@ -36,3 +36,5 @@ then
>   		echo -e ${GREEN}"PASS: $TYPE"${NC}
>   	fi
>   fi
> +
> +exit $ret

nit: Shouldn't this also exit with error if no test_lirc_mode2_user was run?
