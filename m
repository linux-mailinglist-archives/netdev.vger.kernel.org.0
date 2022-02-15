Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCA4B732A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbiBOQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:09:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbiBOQJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:09:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E550180203;
        Tue, 15 Feb 2022 08:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84792617BE;
        Tue, 15 Feb 2022 16:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E938C340EB;
        Tue, 15 Feb 2022 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644941346;
        bh=tImsfnAxOPMcPnLVgrYT5gGpxJc4VWMMuOHOnIwaKUo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d6uHlOp2zPaXBNJ8j+yZ+Lf1fndbvmUMoMamiNjDe+rh1holE8cTUiMdxoX6RhNdE
         zdey89G+lR93ezdSDGCB0egIrGTCaAix3vW5tVJGRwseoBRYXBmoS9DiVXV3Ir4CgW
         U5AbgmaEuybcDgmGNvgOIM+O9LSMKkKQYirBKTxhct3PTlAZOCE6UuvuuPCm8L4976
         YdPUhNlxZcKOMOlc/FB6hW+1VlhrvlVEY8o6KvpGB8Dys9XWZ4DSU7wa+3xdZ+WDEo
         GJAPU2ZaTqYyonUnvX2m219fKmMlg0K0LxpEcridt5HjbFS5USLG00mNBm6MqQzNSz
         7nyo7ET647NRw==
Message-ID: <71823500-3947-0b9a-d53f-5406feb244ac@kernel.org>
Date:   Tue, 15 Feb 2022 09:09:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 00/19] net: add skb drop reasons for TCP, IP, dev
 and neigh
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, menglong8.dong@gmail.com
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
References: <20220215112812.2093852-1-imagedong@tencent.com>
 <20220215080452.2898495a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220215080452.2898495a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/22 9:04 AM, Jakub Kicinski wrote:
> There's no reason to send 19 patches at a time. Please try to send
> smaller series, that's are easier to review, under 10 patches
> preferably, certainly under 15.

+1. It takes time to review code paths and make sure the changes are
correct.

Send the first 9 as set; those target the TCP stack and then wait for
them to be merged before sending more.
