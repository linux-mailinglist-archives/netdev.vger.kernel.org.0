Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F1F5BFEA6
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiIUNHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUNHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC42883E0
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA1162B51
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37E4C433C1;
        Wed, 21 Sep 2022 13:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663765651;
        bh=8+0kOrU41qCOgLpyPSJVLi30VfKoLihecQblhehoXjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DxwvCMADsWlISUTb1iijTa02LZ0KiVy2iRA+sR7/WgS8GNZa3lY5gnv6iAzHs2Xv6
         TLr8I3u4Qa3GLvuNMrMP3qkstkKy8nu4S4GQlFPYVwZV2D9qT1okUUwUfCqJKRhsWP
         ZLa1PogqUSjGUpQr1qeSrWbbPhYOeiVrH3iJ/RZZzFG6Gg/rxrTpdttrwY8+Exd0nj
         nN4QNIJNHeQ5uA55oNZTH52F6FX91xSSnCM3FIu/cqax6X+a6IcKhLW3rDILmAfenr
         WrvdnaScdlZJKdfRDAgKHFg4iLumZE4rsHb8lCPDWMfyNPWVvInhuUPn9muN2j1yjb
         kyr+v6zCHZnAg==
Date:   Wed, 21 Sep 2022 06:07:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Zhong <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        davem@davemloft.net
Subject: Re: [PATCH net-next v2] net/ethtool/tunnels: check the return value
 of nla_nest_start()
Message-ID: <20220921060729.7443f3d2@kernel.org>
In-Reply-To: <20220921083004.1612113-1-floridsleeves@gmail.com>
References: <20220921083004.1612113-1-floridsleeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 01:30:04 -0700 Li Zhong wrote:
> Subject: [PATCH net-next v2] net/ethtool/tunnels: check the return value of nla_nest_start()

Please update the subject to follow the standard kernel convention.
The prefix should be something like

  ethtool: tunnels:

or just

  ethtool:

> Check the return value of nla_nest_start(). When starting the entry
> level nested attributes, if the tailroom of socket buffer is
> insufficient to store the attribute header and payload, the return value
> will be NULL and we should check it. If it is NULL, go to the
> error_cancel_entry label to do error handling.

Better but don't explain what the patch does but lean more into the
assessment of the situation. The last sentence is unnecessary, but
you should include an explanation if there is any _actual_ bug here.
Can something crash or misbehave?

> v2: error handling jump to error_cancel_entry, more details in commit 
> meesage

This should go under the --- separator
