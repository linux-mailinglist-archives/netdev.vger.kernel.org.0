Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD14C9B3F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbiCBCfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiCBCfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:35:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D914A54FAF;
        Tue,  1 Mar 2022 18:34:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5749C616B7;
        Wed,  2 Mar 2022 02:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBAFC340EE;
        Wed,  2 Mar 2022 02:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646188495;
        bh=3ebq/SE9f91HOoVzaRVcyofM+nWVMKFrPc2bbax7dLg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uOusbWgresNDpIUy+KdmEQuejIn/VTLzvcDL0ic+qccMGsszeBjsCyIzsEfygmzs2
         MgArpSjB78gdvnstKoQFlRwQ/GyFLzVMlt+n+7dZOFcRCcv4xvb7gSpQ01mIivMUIr
         RNsz/qFxIhImkWb5q1ZPnmnAr9g1+umx2NjPqyRUnQZiSnZK9EP5MCUHasaObhwlPb
         wjwlKeQpefW05G8XdiIo+oKhymea30W3pwWhki6txjVdw4LPEfowx/TAI/ahwRPBxa
         Z5Lp+/sXMJTKfu0y6m+WCMFZ6n44Jm7P+aVla3jTyJR1hxcbDgIGxITK2VbguWwuC7
         3G3s1HJY8yOTg==
Date:   Tue, 1 Mar 2022 18:34:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v4 1/4] skbuff: introduce
 kfree_skb_list_reason()
Message-ID: <20220301183454.4813d022@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220226084929.6417-2-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-2-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Feb 2022 00:49:26 -0800 Dongli Zhang wrote:
> +void kfree_skb_list(struct sk_buff *segs)
> +{
> +	kfree_skb_list_reason(segs, SKB_DROP_REASON_NOT_SPECIFIED);
> +}
>  EXPORT_SYMBOL(kfree_skb_list);

Why not make it a static inline now, like we did with kfree_skb()?
