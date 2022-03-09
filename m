Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F114D2545
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiCIBEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiCIBEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:04:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F3B12E752
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 16:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1D86130D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 00:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97349C340EB;
        Wed,  9 Mar 2022 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646785102;
        bh=okjlSinp9rZHpJvOQY8IQ+pibQVol1fKNmJ4RqNuu3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DuECPDfeMHk5/hU/eKxKDXngTlT01L2s5JfMaHpvdgm+WXABjuxK4mNHlG5l6bKDU
         9jay6igZM31nMER4cOuHhNDCaxjSHKd3l0F8l2Ok7jGrMjqt22ep+gwT/2Ryf+vsC1
         QAwZ29j+A3XLwVC3k5vzdjU3Gs5l7is5fbgEJoaKBBBjOyySGNrNhdcz+YnYDvpS0B
         QPAKDA4X4u1hS3Zm+kA2s9dSBmKoZpVdjxr7L4X9H9sv4HvUllvlpn8lB0rEJnga9h
         jqpRpmlexlCG9EcXwFCtrR8519zBmyMVHFI3m3dd06PY4kTTwzEHxvObkUs3oGgT6j
         J63w1T8UtuXmQ==
Date:   Tue, 8 Mar 2022 16:18:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
Message-ID: <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
References: <20220308030348.258934-1-kuba@kernel.org>
        <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
        <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
        <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Mar 2022 11:53:38 -0800 Eric Dumazet wrote:
> Jakub, Neal, I am going to send a patch for net-next.
> 
> In conjunction with BIG TCP, this gives a considerable boost of performance.

SGTM! The change may cause increased burstiness, or is that unlikely?  
I'm asking to gauge risk / figure out appropriate roll out plan.
