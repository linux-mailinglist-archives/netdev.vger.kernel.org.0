Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258794DA28B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345461AbiCOSmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239074AbiCOSmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C881931933;
        Tue, 15 Mar 2022 11:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D83C61696;
        Tue, 15 Mar 2022 18:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A328FC340E8;
        Tue, 15 Mar 2022 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647369688;
        bh=6oUs/mx6wQln4IG1fFwGx9u0M0eAOSXZ12ymfyvVnOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fvtjgtTpkOHrSw1w5biaauh+LWMEkSTWlHgojD70NFoG5ZsK9Ddirxmy3lI3Eov1M
         68v3OXXRm1A1dzWE5W4Bl2NyzwVuOPYh1v6jLcy3t48NCpdBuIgZTcAi7zbg5Yu0t9
         DfZY9J7+2O/sQ0LphAru6i0gsv5dmBvq9fTGzBpMJ7raGW5bZCq5wG0t50h3MHgkRF
         GwQ5l3VoZ7oXAYX0y9WXYHV51tD8a4mE8c2+67cw9aG7tb7F92oY4CLWwmvhCRs+n2
         090Ae00C10rntjhzuR13Hosi5DvpPcgpJUokN2zu+R6Xdgzz1hCMqhUbzOBxeQxTa7
         kxQUfWCQ9o1mg==
Date:   Tue, 15 Mar 2022 11:41:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: de4x5: Optimize if branch in
 de4x5_parse_params
Message-ID: <20220315114127.7c9bb48d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315074952.6577-1-tangmeng@uniontech.com>
References: <20220315074952.6577-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 15:49:52 +0800 Meng Tang wrote:
> In the de4x5_parse_params, 'if (strstr(p, "BNC_AUI"))' condition and
> 'if (strstr(p, "BNC_AUI"))' condition are both execute the statement
> 'lp->params.autosense = BNC', these two conditions can be combined.
> 
> In addition, in the current code logic, when p = "BNC", the judgments
> need to be executed four times. In order to simplify the execution
> process and keep the original code design, I used the statement which
> is 'if (strstr(p, "BNC") || strstr(p, "BNC_AUI"))' to deal with it,
> after that once 'strstr(p, "BNC")' is established, we no longer need
> to judge whether 'strstr(p, "BNC_AUI")' is true(not NULL).
> 
> In this way, we can execute the judgment statement one time less.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>

This is ancient code, let's leave it be.
