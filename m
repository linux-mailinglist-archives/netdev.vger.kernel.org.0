Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642485A4030
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 01:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiH1Xxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 19:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH1Xxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 19:53:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE971EEE2
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 16:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C028B80B72
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 23:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69C0C433C1;
        Sun, 28 Aug 2022 23:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661730821;
        bh=r1xauZ9Ds39SOgjKCbHKKrttJWBPsS3a8PzweBwhfi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sss3NTs2RMdKbwt5kvJA8zs3VsJfFka7EEpNno2os06GgBeGc2Z7luNxBCvFOLHbe
         49GuTahmx3HHlbMPxZk5gh8t5OcrIxAEtNcEqoTXQSjWJCoINvxLdgL2GFjoPc+dV6
         DY7eDsQ5EXt5r5fuC2O3QcZWwqAR3SM44N6UyqEzYWwrHiFaqAFHXbAtkYhy1qv0IL
         tIRKnGsx6GxBnB17s1WUYD0xzXf9QsIljOOC4lU5D6K5To6nNtvsGh++tH6qi4VJuy
         NKzE8SM42TQ0jgPwqy1Sh0/2H6wKgqwPgpoWiSl5mL4JGNNK/DK2wVMdDqBksr4bV8
         WXwfLp2KdLhiw==
Date:   Sun, 28 Aug 2022 17:53:40 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Kyle Rose <krose@krose.org>
Cc:     netdev@vger.kernel.org
Subject: Re: ULA and privacy addressing
Message-ID: <20220828235340.GA13078@u2004-local>
References: <CAJU8_nU2Yb1yR7j8zMEnF63Lszbu8MVbePWsuwG2_mimU9iwOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJU8_nU2Yb1yR7j8zMEnF63Lszbu8MVbePWsuwG2_mimU9iwOg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:29:33PM -0400, Kyle Rose wrote:
> Does anyone have any opinions on the right way to implement a
> configuration knob for this (i.e., one that has a chance of being
> merged)?

take a look at the handling of RA messages
   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv6/ndisc.c#n1233

shows a few existing sysctl knobs for managing what is allowed and
how.
