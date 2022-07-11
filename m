Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258A5570C28
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 22:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiGKUo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 16:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGKUo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 16:44:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFE241D12
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 13:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7495C61683
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 20:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5944C34115;
        Mon, 11 Jul 2022 20:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657572296;
        bh=oTTI/sFYECmPYbjlogwc9NHIB+pa8H2pNywfsDg/tIU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Si28cbR/4w2QNavFLEgNLr7ZwP3YkVq2LjoayQaso720DgcGIJTfp+X+C2cyzNzmF
         KSHrWuLsQt4UrvCGqUO0kICul/cbDhtbvVvVDVz0Bmkn/HOC70LCNgrfLv/LcKkBeS
         0y01Cs6X0rNXZIX9OyAHaCcx/y7dMSLR26hzcQa4CQe8RqtBBUcHrIyB8eptnLxwKo
         CJf4CR/9SJWCvqPQKik5N9RNY8U9eqRQ7Kmf9MDwrbIRsQSYX33lfgPL82HVOSz3b6
         0vps/GyDZF3KSxAFoBqd44BnRUT4jnH3OKGG5DKNmYVfSZemPPeLiNlo6M0yurbCKo
         kmaEZFZRAD/Vw==
Date:   Mon, 11 Jul 2022 13:44:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Yonan <james@openvpn.net>
Cc:     netdev@vger.kernel.org, therbert@google.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] rfs: added /proc/sys/net/core/rps_allow_ooo
 flag to tweak flow alg
Message-ID: <20220711134447.51162fd5@kernel.org>
In-Reply-To: <b84863e7-5acc-697c-0e08-af88b691e678@openvpn.net>
References: <20220624100536.4bbc1156@hermes.local>
        <20220628051754.365238-1-james@openvpn.net>
        <20220628100126.5a906259@kicinski-fedora-PC1C0HJN>
        <5ceef56b-9f7b-df36-17e4-1542d3306267@openvpn.net>
        <b84863e7-5acc-697c-0e08-af88b691e678@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 14:38:39 -0600 James Yonan wrote:
> Any further questions/comments about this patch?=C2=A0 The v2 patch=20
> incorporates all feedback received so far, including refactoring a large=
=20
> conditional in the original code to make it more readable and maintainabl=
e.

There was another patch on the list doing a very similar thing right
around the time you posted yours. IIUC wireguard implements farming=20
out decryption to multiple cores, implementing something in the tunnel
layer seems better. You can do the crypto in process context which is
much more efficient while at it, and put the packets back in order.
