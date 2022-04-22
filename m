Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EBF50BC35
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449651AbiDVP6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiDVP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:58:15 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B9A4EA0F;
        Fri, 22 Apr 2022 08:55:21 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhvcm-000EZ0-7W; Fri, 22 Apr 2022 17:55:12 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nhvcl-000LyW-QM; Fri, 22 Apr 2022 17:55:11 +0200
Subject: Re: [PATCH bpf] lwt_bpf: fix crash when using
 bpf_skb_set_tunnel_key() from bpf_xmit lwt hook
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mkl@pengutronix.de,
        tgraf@suug.ch, shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
References: <20220420165219.1755407-1-eyal.birger@gmail.com>
 <c053fdf3-84bb-faee-387d-6edb2df9ffee@iogearbox.net>
Message-ID: <d1fd11a9-6947-2783-2f77-66831f1cde20@iogearbox.net>
Date:   Fri, 22 Apr 2022 17:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c053fdf3-84bb-faee-387d-6edb2df9ffee@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26520/Fri Apr 22 10:30:17 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 5:48 PM, Daniel Borkmann wrote:
> On 4/20/22 6:52 PM, Eyal Birger wrote:
[...]
> 
> Ok, makes sense given for BPF_OK the dst->dev shouldn't change here (e.g. as opposed
> to BPF_REDIRECT). Applied, please also follow-up with a BPF selftest for test_progs
> so that this won't break in future when it's running as part of BPF CI.

(Coverage for lwt BPF flavor from test_progs is afaik non-existent aside from some section
name tests. Would be great in general to have runtime tests asserting lwt behavior there if
you have a chance.)
