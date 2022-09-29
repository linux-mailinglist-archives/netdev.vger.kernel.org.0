Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C95EF7D5
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbiI2OlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbiI2OlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:41:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE21C433A;
        Thu, 29 Sep 2022 07:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B27B8246F;
        Thu, 29 Sep 2022 14:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDBC433D7;
        Thu, 29 Sep 2022 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664462467;
        bh=lima4OkKHGllRSkj0VyD0naHNHxdOFN+mrru7+zQUWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KEDnjEjn57eEI/bctcSQQjbUOOQK5aRkqckECCnwYX8k+HO1FpH7BMuBE7fG4B78O
         SPj5AdS6QO9A6usaWMWsLv8wLykVUZ9ttvI5amGX3Zv+am1Ix+4h9L9Rh0otCTHkSD
         Fnb6J3YVnQ3wPzorCQ8PUlHjIILKYXe3KPc+eGuihgAZKvjE2xOsiJYiZhhqEdhwTU
         MD43CMYJQ5EXA0qHtoe3QhBh6oIbmJMx4pcOPY4pQCak17MhSLbMJR7ABIV3+w1+pt
         ilmyFLPwqamUgnqVIG8o8CLH/bzh0vO4BqpIoi5aRdXdOHv+bc29qbu7FfDhufl3K/
         DZAPfOYD+yNow==
Date:   Thu, 29 Sep 2022 07:41:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, gnault@redhat.com
Subject: Re: [PATCH net-next 4/6] netlink: add a proto specification for FOU
Message-ID: <20220929074105.168d944e@kernel.org>
In-Reply-To: <6c64b772-7b2b-77f8-4523-4408e0b3bf8a@6wind.com>
References: <20220929011122.1139374-1-kuba@kernel.org>
        <20220929011122.1139374-5-kuba@kernel.org>
        <6c64b772-7b2b-77f8-4523-4408e0b3bf8a@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 11:02:51 +0200 Nicolas Dichtel wrote:
> > +operations:
> > +  list:
> > +    -
> > +      name: unspec
> > +      doc: unused  
> 
> To what correspond this name?
> It helps to name the generated operations array?
> Something else than 'const struct genl_small_ops fou_ops[3]'?

Same as the attr, it just reserves zero FWIW, never actually used in
the code I've grepped:

linux$ git grep FOU_CMD_UNSPEC
include/uapi/linux/fou.h:       FOU_CMD_UNSPEC,

iproute2$ git grep FOU_CMD_UNSPEC
include/uapi/linux/fou.h:       FOU_CMD_UNSPEC,

BTW thanks for asking, I noticed I mistyped the documentation,
type is 'unused', in the docs I said 'unspec'.
