Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E901691878
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjBJGVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjBJGVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:21:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3E05247
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 22:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 003B6B82363
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A7BC433D2;
        Fri, 10 Feb 2023 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676010105;
        bh=JjuQ57U7X4sVR9OW105qwHXuuQfcc3AKy6nePXX6ziI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/X1sj3JRgfPRxp+YmGC+b/yLS627jNEil+LvNBEa122c5OZ5ujyKgsqpBp+DNeo6
         ijPg6bdwctYDlTFu6spyxsNpyXhSbyf4E3sxNkyXnCnYnrF0EMbGpw6yx7aKqktwwm
         IB+ox/7OF0eQtfc0IWQ5PxAvOj8R4tdVdAu7bupZLzqvPPSNJkZd6xFQspn/TXyvbI
         mbb7U8/ybxuo1b82hU6yq0YGY7MW5xK+WbOd67BLbyZEepbDdus8ycwPEzM1Vdvu8c
         c4FRWkiJIACj9r/Qv+8jqQi9vw/OqH3Wl6b0xfXi/qACafnqJQld5X5r+Inc/GR4EI
         PNTv5FO6VsmJw==
Date:   Thu, 9 Feb 2023 22:21:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 0/5] net: move more duplicate code of ovs and
 tc conntrack into nf_conntrack_ovs
Message-ID: <20230209222144.38640609@kernel.org>
In-Reply-To: <cover.1675810210.git.lucien.xin@gmail.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Feb 2023 17:52:05 -0500 Xin Long wrote:
> We've moved some duplicate code into nf_nat_ovs in:
> 
>   "net: eliminate the duplicate code in the ct nat functions of ovs and tc"
> 
> This patchset addresses more code duplication in the conntrack of ovs
> and tc then creates nf_conntrack_ovs for them, and four functions will
> be extracted and moved into it:
> 
>   nf_ct_handle_fragments()
>   nf_ct_skb_network_trim()
>   nf_ct_helper()
>   nf_ct_add_helper()

Hi Pablo, do you prefer to take this or should we?
