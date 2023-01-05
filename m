Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71E65F3B3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbjAESbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbjAESbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:31:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FDC13F6F;
        Thu,  5 Jan 2023 10:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6A2FB81BA8;
        Thu,  5 Jan 2023 18:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EDC433EF;
        Thu,  5 Jan 2023 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943475;
        bh=SaK0AUs4XAKJbwfwZCnBEO5FT2cIQoQ9UJE/COaeysA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D7aCWR5FN4ts4HSYWLzf419F5pAgvEBPLTYsdSHTeIyFM/jj8jvY38rMfggFwFWD5
         F+XlR3au8wusLhwuSu5RGlvycUBhiWsIi3I01wQ9tA/bNM/HVrOp0KPwUclTzt2uGV
         ttgEY9bIV9oHmBBysHcDywV4fqYHZZITJ/chdYwh8+tzFjfayP1QUdiAOVSpdELwYV
         rrRU07RxFHdH77GO8QDGFJvdKkXobDLLX8b3sGtXR3aVuDYmCgborg8d44N2nA7HWC
         LDB5QRON0lSicHId0wNyupeXWRE5Ee0K7LckPNfAzN5W2OfjeTf3MZaULLjacdw8Af
         uTyLnTO3onj/Q==
Date:   Thu, 5 Jan 2023 10:31:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ezchip: Switch to some devm_ function to
 simplify code
Message-ID: <20230105103114.6c1ee8ec@kernel.org>
In-Reply-To: <94876618-bc7c-dd42-6d41-eda80deb6f1d@wanadoo.fr>
References: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
        <e1fd0cc1fd865e58af713c92f09251e6180c1636.1672865629.git.christophe.jaillet@wanadoo.fr>
        <20230104205438.61a7dc20@kernel.org>
        <94876618-bc7c-dd42-6d41-eda80deb6f1d@wanadoo.fr>
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

On Thu, 5 Jan 2023 07:27:00 +0100 Christophe JAILLET wrote:
> My main point is in the cover letter. I look for feed-back to know if 
> patches like that are welcomed. Only the first, Only the second, Both or 
> None.

Sorry, missed that.

> These patches (at least 1 and 2) can be seen as an RFC for net 
> MAINTAINERS, to see if there is any interest in:
>    - axing useless netif_napi_del() calls, when free_netdev() is called 
> just after. (patch 1)

I think it'd be too much noise. I'd vote no.

>    - simplifying code with axing the error handling path of the probe 
> and the remove function in favor of using devm_ functions (patch 2)

I believe DaveM was historically opposed to those helpers in general.
I think we should avoid pure conversions, unless they are part of
development of new features or fix bugs.
