Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77D551960
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiFTMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiFTMvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:51:22 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19C717A9D;
        Mon, 20 Jun 2022 05:51:17 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3Gs4-0005hk-A0; Mon, 20 Jun 2022 14:51:12 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o3Gs3-000Luv-UF; Mon, 20 Jun 2022 14:51:11 +0200
Subject: Re: [PATCH] libbpf: Remove kprobe_event on failed kprobe_open_legacy
To:     chuang <nashuiliang@gmail.com>, Jiri Olsa <olsajiri@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <20220614084930.43276-1-nashuiliang@gmail.com>
 <62ad50fa9d42d_24b34208d6@john.notmuch>
 <CACueBy7NqRszA3tCOvLhfi1OraUrL_GD9YZ9XOPNHzbR1=+z7g@mail.gmail.com>
 <Yq5A4Cln4qeTaAeM@krava>
 <CACueBy4Nr+rqJjZ3guBimd6t36V5B3CBp6_oZVMRzLvMZoTRpg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1b813650-baac-a93e-97b0-11967080fdfe@iogearbox.net>
Date:   Mon, 20 Jun 2022 14:51:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACueBy4Nr+rqJjZ3guBimd6t36V5B3CBp6_oZVMRzLvMZoTRpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26578/Mon Jun 20 10:06:11 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/22 3:56 AM, chuang wrote:
> On Sun, Jun 19, 2022 at 5:17 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>>
>> just curious.. is that because of ipmodify flag on ftrace_ops?
>> AFAICS that be a poblem just for kretprobes, cc-ing Masami
> 
> Yes, the core reason is caused by ipmodify flag (not only for kretprobes).
> Before commit 0bc11ed5ab60 ("kprobes: Allow kprobes coexist with
> livepatch"), it's very easy to trigger this problem.
> The kprobe has other problems and is communicating with Masami.
> 
> With this fix, whenever an error is returned after
> add_kprobe_event_legacy(), this guarantees cleanup of the kprobe
> event.

The details from this follow-up conversation should definitely be part of
the commit description, please add them to a v2 as otherwise context is
missing if we look at the commit again in say few months from now. Also,
would be good if Masami could provide ack given 0bc11ed5ab60.

Thanks,
Daniel
