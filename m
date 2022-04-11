Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0E54FB636
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343919AbiDKInb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243313AbiDKIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:43:30 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBB23DDDB
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:17 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 49F803201E78;
        Mon, 11 Apr 2022 04:41:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 11 Apr 2022 04:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649666475; x=
        1649752875; bh=Zpd0dbMP4Qqg9X4hnW+fvYt79OSKTVRKGbShdxRmpz8=; b=W
        EXBJUdrtt46g9rFPLJc2LK70WpYvV2dQ4uaEyx88GQ1MfNWOM1maljBdMlwyjpiN
        l2MER2ZQ+PcDhKd2W6pFcFPqW+65l5Gud7haY7TIhkoHHYFnSkTwhBPzV1LxQAcV
        ZIwrBD7w6qFW6PZ3VhEQXfUNDT9KVJbtLmqSb7OrV+o9mdm8n6YaZWDG21y4MXK/
        cQePpTYVyUjHDucETekE7dm9NKWQXcgvNTo74uTe8XbENk8MLOEWAE88u4A1FzQk
        YGRlOBN0YSj9SJbVd4MNU9+crMvpzfi1PcUQQGWTY/dhrtIAAP6PM0FOpUQ3j+Tj
        MOat/POqg+BCEWPbF8t7g==
X-ME-Sender: <xms:q-lTYjnhsLk7gyG8cvqSMnljjClXCYR6SuR0incil73dJhYpi0vBtw>
    <xme:q-lTYm03K1FPPnho_O6cXXMCDX-yUpcFQMX02fmG6f83DuocFico1T4rp2I7MKKAh
    i7aG0tG_J-k9xE>
X-ME-Received: <xmr:q-lTYprfDvl4XmXkh8dfO_hADWV_Ol7MSvj_Rp09AQfSonIk27t1Lm2IjSVP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekiedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:q-lTYrn8FFvXIPoiHeq5HKx7aGQkIHRuSqWT1QWtmEKGp6JE9mCTxg>
    <xmx:q-lTYh2VzUf_aCWdRVEFY-exWbIPSes7fnuMVogP0lLRHYBJ5ZfC3g>
    <xmx:q-lTYqsnI2Q6M3rdxSaldPz20vpjcM5z9148eofxtjoLYKZFtSaa0g>
    <xmx:q-lTYqy3ipQJa3XcL3VA_RoAxGXLsc_odlOyFM-kqQ-O1W6BwHg2KA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Apr 2022 04:41:15 -0400 (EDT)
Date:   Mon, 11 Apr 2022 11:41:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/6] net: bridge: fdb: add new nl
 attribute-based flush call
Message-ID: <YlPpqKFeAs5oCHGD@shredder>
References: <20220409105857.803667-1-razor@blackwall.org>
 <20220409105857.803667-4-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105857.803667-4-razor@blackwall.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:54PM +0300, Nikolay Aleksandrov wrote:
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 221a4256808f..2f3799cf14b2 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -807,7 +807,15 @@ enum {
>  /* embedded in IFLA_BRIDGE_FLUSH */
>  enum {
>  	BRIDGE_FLUSH_UNSPEC,
> +	BRIDGE_FLUSH_FDB,
>  	__BRIDGE_FLUSH_MAX
>  };
>  #define BRIDGE_FLUSH_MAX (__BRIDGE_FLUSH_MAX - 1)
> +
> +/* embedded in BRIDGE_FLUSH_FDB */
> +enum {
> +	FDB_FLUSH_UNSPEC,

BTW, is there a reason this is not called FLUSH_FDB_UNSPEC given it's
embedded in BRIDGE_FLUSH_FDB, which is embedded in IFLA_BRIDGE_FLUSH ?

Regardless, in the cover letter you have '[ BRIDGE_FDB_FLUSH ]', which
is actually BRIDGE_FLUSH_FDB. I only noticed it because the code didn't
match what I had in my notebook, which I copied from the cover letter :)

> +	__FDB_FLUSH_MAX
> +};
> +#define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
>  #endif /* _UAPI_LINUX_IF_BRIDGE_H */
