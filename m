Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCF0554229
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356787AbiFVFOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbiFVFOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE635DEE
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25A1361924
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 05:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D104AC34114;
        Wed, 22 Jun 2022 05:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655874891;
        bh=T2PkwlkkESqUql7fYiPbAKX1hJqpBOmiBxn2Zjqu6Bg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EIBw5cISgl23ZKJkpe6qa7HJeuzjWtOMDb8mSsMnZOKQdF9YA+wyxkvw5A037Mvzh
         Cjv+58lZcxo5kEneeh1Evy+24/el3tR4qUx8YJQKVnhJt84vQHT4Pfm76eRRgMI+go
         N3V3zh2P7doByhfjxngen7hU4QUyG0xCbTR6Ggs8OBa6nYRdSWDk/6SFc4Vh713nh5
         wdue/ukqMFEbdALAADF9wDzhos1MsIfT+cGRFHF5NbJNlJpFaCjHSv4lyZYEo60XXY
         jE0C5uq+uKBeo+Cmgr4VJI+lSEXaVyz+mzwC4byz9TssxsJO5IczLvEHfMPycgx2Y0
         0A6yl0MVK7ZjA==
Date:   Tue, 21 Jun 2022 22:14:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        willemb@google.com, imagedong@tencent.com, talalahmad@google.com,
        kafai@fb.com, vasily.averin@linux.dev, luiz.von.dentz@intel.com,
        jk@codeconstruct.com.au, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: helper function for skb_shift
Message-ID: <20220621221449.28c30caa@kernel.org>
In-Reply-To: <20220620155641.GA3846@debian>
References: <20220620155641.GA3846@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 17:56:48 +0200 Richard Gobert wrote:
> + * skb_update_len - Updates len fields of skb
> + * @skb: buffer to add len to
> + * @len: number of bytes to add
> + */
> +static inline void skb_update_len(struct sk_buff *skb, int len)
> +{
> +	skb->len += len;
> +	skb->data_len += len;
> +	skb->truesize += len;
> +}

On reflection, maybe skb_len_add() would be a better name?
"update" does not express what the meaning of the parameter is.
It could be delta it could be new length.
