Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4565E4E5
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjAEEyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjAEEyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:54:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D81A48839;
        Wed,  4 Jan 2023 20:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E02A3B818F2;
        Thu,  5 Jan 2023 04:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAFBC433D2;
        Thu,  5 Jan 2023 04:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672894479;
        bh=3jGxlIIBUtNtU8F7fzNaR/sMnXA6GWowBwE8yID47R8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sYvGkKEGukfc64sbaHmt08pESFnbfWarRFkfT/O4/FYRdGF8I3boTRUCEdKs54bN8
         pxs8QBjxTaOIfhtyZDlR28aAZlGc+vNDIyDWMR2q7qENzNNNrMKiADCXHCNv+c3Rd9
         1H12lsJcagXjXbdAvP1jlalUHgFadKSLfWoma4cR3k+nf+18xtXrZVgDqhwcsL/ygA
         m2HoF8oojqEmUFg2qHTBMrRM1aM0Ar/vw7MyXFfJVRwxb9/VqPkMV/GyGyj9Q4iQP+
         Rd+/50OasXEZ+hR47YgZ0p3xOGkcxqp1HSJ5FVmAQkDfy6E/ZKokl6zvKduEbv4e96
         9odlMwB+6T1uA==
Date:   Wed, 4 Jan 2023 20:54:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ezchip: Switch to some devm_ function to
 simplify code
Message-ID: <20230104205438.61a7dc20@kernel.org>
In-Reply-To: <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
        <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
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

On Wed,  4 Jan 2023 22:05:33 +0100 Christophe JAILLET wrote:
> devm_alloc_etherdev() and devm_register_netdev() can be used to simplify
> code.
> 
> Now the error handling path of the probe and the remove function are
> useless and can be removed completely.

Right, but this is very likely a dead driver. Why invest in refactoring?
