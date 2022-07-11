Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7503570977
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiGKRuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKRuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:50:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFA71707E;
        Mon, 11 Jul 2022 10:50:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAD0C6147C;
        Mon, 11 Jul 2022 17:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD7DC34115;
        Mon, 11 Jul 2022 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657561799;
        bh=TP/EcJV+sjjnlp/CRGatSWqAfclKvmMEZc4Huz5tlko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MsCA4h4hUTIvzBgG9Ci8oxvGRXrMkXdpMuuTnPi6YlRl/uG56mpxOlPDwhjn4wt8a
         S3fMRh3KEMzRzcbxOisRkDHmrgRSwYasgZI7y5jRm9q+fg07WTYf/jyTAf2WNo87jh
         wbj42Ch6SMoRJvaC7WJB+TUYwfxcMw3ReBu65TS/Kbxg4FWxKm4MeL2U1A1P2nRtDo
         8QD6BFpNJK87dX+5S98qM4Jqta3ajtiiKxjiM4BJgWypKEN2ULX9Dlb4yZRiJaUo6M
         ranLnctMmixiGIs8FDHbnAGeZ6FO+sBRt1pOh/uePOLjggNENetv9v2Z/xsjAJ4U+k
         MGk3FnkxY/kQw==
Date:   Mon, 11 Jul 2022 10:49:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     duoming@zju.edu.cn
Cc:     linux-hams@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
Message-ID: <20220711104949.3de90fc5@kernel.org>
In-Reply-To: <56319300.38660.181e861b71b.Coremail.duoming@zju.edu.cn>
References: <56319300.38660.181e861b71b.Coremail.duoming@zju.edu.cn>
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

Hi Duoming!

Unrelated to this particular patch, but it seems like you're working
a lot on AF_ROSE, would you consider adding a good set of selftests 
for it?  It'd be easier to you to validate the changes and much easier
for us to trust the fixes seeing how they were validated.
