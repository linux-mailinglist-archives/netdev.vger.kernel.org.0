Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9760D58CD95
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbiHHSYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243807AbiHHSYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:24:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E61186CE
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 11:24:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8328AB80EF0
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 18:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC822C433C1;
        Mon,  8 Aug 2022 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659983059;
        bh=Uz7aoowsXKaDtG44696AxwDLBfbhT1pulsoIwOQl//Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owW4H/jzI/R9EH2vfZFnxmi98py9ZEWPc9TXNrqKqOUxblnW3wMYAYE8625AOt1cp
         cEchMm1ji1jXi0kKyEetorqGBQKlr5mj3FZHIGkF5Ol3KDOJBPybPfGIQLcbNCseFV
         guXkxHGsVIQkqcTcvtHKmdRrO/hi9+l4zIwHA6UZ2cmCS1FlPOWAM67eCnDcAaJGy2
         lObVi8mjx9rsh7r0X9eNNEQgDGPe5+t2/BxFVV0QZf0jIJD0p/ce+HP3eDb/3lcO7p
         +sCOcPtoREAib+Xq1+HZpZ0oPBg4r0WvFEoyZWHmmaazIMdHlmVeiOnobE4O7xxSrK
         BWeI1O+JHL0gw==
Date:   Mon, 8 Aug 2022 11:24:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Ran Rozenstein <ranro@nvidia.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20220808112417.7839cb5d@kernel.org>
In-Reply-To: <1513fb1a-e196-bc2c-cdb8-34f962282ea2@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <84406eec-289b-edde-759a-cf0b2c39c150@gmail.com>
        <20220803182432.363b0c04@kernel.org>
        <61de09de-b988-3097-05a8-fd6053b9288a@gmail.com>
        <20220804085950.414bfa41@kernel.org>
        <5696e2f2-1a0d-7da9-700b-d665045c79d9@gmail.com>
        <1513fb1a-e196-bc2c-cdb8-34f962282ea2@gmail.com>
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

On Mon, 8 Aug 2022 08:24:05 +0300 Tariq Toukan wrote:
> > Thanks for the patch.
> > We're testing it and I'll update.  
> 
> Trace is gone. But we got TlsDecryptError counter increasing by 2.

Does the connection break? Is there a repro?
