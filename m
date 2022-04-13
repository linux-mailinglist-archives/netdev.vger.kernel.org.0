Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F344FFDE7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbiDMSgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiDMSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:36:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F039F5C871;
        Wed, 13 Apr 2022 11:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A368B8272E;
        Wed, 13 Apr 2022 18:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF871C385A3;
        Wed, 13 Apr 2022 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649874846;
        bh=lw5TiHWiWPe7FVeRC6rjUFCeA+yvP4jv9afjFgE3oWc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=dIT4Z/6maeZrdDbDsQ8QTlWLPC6EtFSdS1HEsCaB+lUsrupJSh6TQDTs1CdKwGmRb
         VS8ocCmXJ8O/+kWQu9okW7VZBMTv8vLSAOB4PrrqQUh/H579YjjHOHeENuJLHr8ez+
         XxsFUlq//m7lhdAyUp02jFOSAj5k7AyiNM+XY/DrNwfUmi6h6zjK28sWEBnIMSkQJL
         Kz7ZcUca6qyEOKca0G1pZ2jRHh/qCe1tQ9yatE0g0bczlTqvBVwsOGc0dP3lC+MJDZ
         IrkKFgGzjAXHXXxA4wRP1CaXg8wYkCmvzq5K5el9UxPXLifnZpNNUmLhLFybOa6R7P
         laVZFLI9WnABg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6102129623E; Wed, 13 Apr 2022 20:34:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, x86@kernel.org, hpa@zytor.com,
        Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: Re: [PATCH bpf-next 0/5] bpf trampoline for arm64
In-Reply-To: <20220413054959.1053668-1-xukuohai@huawei.com>
References: <20220413054959.1053668-1-xukuohai@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Apr 2022 20:34:02 +0200
Message-ID: <87mtgorfxh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xu Kuohai <xukuohai@huawei.com> writes:

> Add bpf trampoline support for arm64. Most of the logic is the same as
> x86.
>
> Tested on qemu, result:
>  #55 fentry_fexit:OK
>  #56 fentry_test:OK
>  #58 fexit_sleep:OK
>  #59 fexit_stress:OK
>  #60 fexit_test:OK
>  #67 get_func_args_test:OK
>  #68 get_func_ip_test:OK
>  #101 modify_return:OK

Yay! Great to see this; thanks a bunch for tackling it! :)

-Toke
