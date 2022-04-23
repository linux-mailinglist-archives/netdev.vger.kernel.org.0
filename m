Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B19B50CA00
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 14:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiDWMm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 08:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235532AbiDWMmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 08:42:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01F91C82E7;
        Sat, 23 Apr 2022 05:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64455610AB;
        Sat, 23 Apr 2022 12:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D501C385A5;
        Sat, 23 Apr 2022 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650717587;
        bh=ELsur7mzYvZlCERYGS2ABT0yO/a5ZsuSylsImoFXyOI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nSpnKpKelloCGmjidMNYKVv3gE7sITRuk/jCskEjq2Ad7CBj8GuUVqOyW1o4GJBMC
         OcVBhTxLpmg67VbJlS7bHTaDqbXakq2dSe9arhze+v11ZIUhXjK33KUi+Xu+w5ea7L
         C2rG/t2wwUSfAFMIZSLk5eiMxF4xqNj8EL+qDfKnHHbpRqm71IpAg23tP6Z/xikO9A
         vPAJ5u34mcmNi7YP0gWLFrKOXi5xUXmryiwWMY5U3hrqiJvnG0TnHSuRBlQJflrKOn
         OSk34hmjm9nZoQvslyasZ47noyzeNv8FQk81Ods3UidyjIw85rye3NunE0yCZTJLMR
         MY+LNhdCq6dZw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] cw1200: fix incorrect check to determine if no element
 is
 found in list
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
References: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     pizza@shaftnet.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165071758339.1434.11994452381557384991.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 12:39:45 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> The bug is here: "} else if (item) {".
> 
> The list iterator value will *always* be set and non-NULL by
> list_for_each_entry(), so it is incorrect to assume that the iterator
> value will be NULL if the list is empty or no element is found in list.
> 
> Use a new value 'iter' as the list iterator, while use the old value
> 'item' as a dedicated pointer to point to the found element, which
> 1. can fix this bug, due to now 'item' is NULL only if it's not found.
> 2. do not need to change all the uses of 'item' after the loop.
> 3. can also limit the scope of the list iterator 'iter' *only inside*
>    the traversal loop by simply declaring 'iter' inside the loop in the
>    future, as usage of the iterator outside of the list_for_each_entry
>    is considered harmful. https://lkml.org/lkml/2022/2/17/1032
> 
> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>

Can someone review this, please?

Patch set to Deferred.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413091723.17596-1-xiam0nd.tong@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

