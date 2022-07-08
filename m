Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000EA56AF46
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbiGHAB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiGHAB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F28A6EE84
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 17:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E63A7B82446
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6249EC3411E;
        Fri,  8 Jul 2022 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657238514;
        bh=9TeYqA/IjM9JoR7I/QJLtUhv1h8C/I9sCNXIdt1aoxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UOPcGbJ7/6SPupOUvEesq7niv32av5eD1Tiwi5FJmUGiJnJBl07nQVifgGZgqQcv+
         ZWmnfAzH13xWclAee6aKFevkjTiyzPoMlFSPhA6WicpEY4uuiuimXAtHYWQ5gZyInj
         OBuat9RtGjFK7BAz5VXqEzELAs1IUDCO+RCqqs4NP3e7IiLVDrO1NSpGAo+dA64jtK
         2Tt2nYuSLaPYpAmmC5lUMT2KPlvMVPZTiusHfyHinVbb7qzAg3jswgZK7vdTFJQeGZ
         YcvFyiQHOHkj1xmfckAIU9eOM9SvF1cYz3crqIGbZlaaNYRIaqngabA4Gq4TOmk8BZ
         wRQ8q85T9B7Tw==
Date:   Thu, 7 Jul 2022 17:01:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220707170145.0666cd4c@kernel.org>
In-Reply-To: <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
        <20220705182512.309f205e@kernel.org>
        <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
        <20220706131735.4d9f4562@kernel.org>
        <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 15:59:10 +0200 Matthias May wrote:
> Has setting the TOS for ip6gretap ever worked?

Not sure, looks like the code is there, but I haven't used it myself.
I presume "0xa0" is not trying to set the ECN bits? I never remember
which end has the ECN bits, those may well get nuked on the way.

> How should i go forward with this?

I think your example above shows that "tos 0xa0" does not work but the
conversation was about inheritance, does "tos inherit" not work either?
