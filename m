Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF74653EC88
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbiFFOZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 10:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiFFOYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 10:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC70013DE0;
        Mon,  6 Jun 2022 07:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730A36143D;
        Mon,  6 Jun 2022 14:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9ACC385A9;
        Mon,  6 Jun 2022 14:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654525458;
        bh=aFLl9XT7mHXq2zrDMWznzjs62GQDDKxGzu/TMPDrnCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3WvkqJ35tLiXG7jiGLfWKZ68oCkoWLEJmrYcV0htK/Jap78TqI+d8rMaLoHQacbB
         TDLLBVzj81KN6BUpBTyKEZcvxXbmneaOZkYh4QmEiM3JXw3w8PGPvemlZW+XcbLauX
         mCBsF0qjd9YXF9MJ3KJp5BrJp7hXc01q32IVJd9y7Dh8SvdUWciYpgT6lMVTruACRN
         T30WeWaua/jn02MabL8uTHO0UL5VYPkKA4VUsgCyvSUiqxfxMjJDgJ44HMn01crVOG
         w6xXWsV2lLrzNYJCelr3bLiyJUksCo6KpFZOMbYp2h0Nv//hsCvxwtbukD4bxk4SQx
         JHR1PcU7xZeMA==
Date:   Mon, 6 Jun 2022 07:24:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyufen <wangyufen@huawei.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v4] ipv6: Fix signed integer overflow in
 __ip6_append_data
Message-ID: <20220606072413.284b10fa@kernel.org>
In-Reply-To: <9b09cb01-07ee-6b33-5351-74a40edbda3d@huawei.com>
References: <20220601084803.1833344-1-wangyufen@huawei.com>
        <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
        <20220602090228.1e493e47@kernel.org>
        <34c12525e133402e9d49601974b3deb390991e74.camel@redhat.com>
        <9b09cb01-07ee-6b33-5351-74a40edbda3d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jun 2022 10:03:27 +0800 wangyufen wrote:
> > LGTM. Imho this can even land in a separated patch (whatever is easier)  
> 
> Thanks for all the feedback.
> So, Jakub will send a new patch to fix the l2tp_ip6_sendmsg issue?

That was just a suggestion, if possible I'd prefer if you double
checked the analysis, tested that or similar code, wrote a commit
message etc. and sent it.
