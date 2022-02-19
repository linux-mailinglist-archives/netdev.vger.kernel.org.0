Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4844BC56D
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiBSEyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:54:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:54:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C05132F;
        Fri, 18 Feb 2022 20:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B47BEB82711;
        Sat, 19 Feb 2022 04:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503B4C004E1;
        Sat, 19 Feb 2022 04:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645246450;
        bh=h2795+8GYlVPXKPJ5I2QLnhGfDjELLMFhyd7g3oIiok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C67Z4thZk4x8k2ihFzAMQ+CzkTAXiWLj6ky0jZolGsq3PSQ7iava14DtHEJK9pH8B
         XBWY9BP7ryDDq8UGjL1UMl/3hjyB6WBIhxuMRfXKxnBtnSe3Lux6wJ70qrFBbSs0O7
         dMHM2nTL3gxW8+4lpm+3GQEd8WNoeZtGmrB9dV+AHS3zvH6/Yw32O7JIZtLxygcZRU
         IaWc5U9rGgZeSRBmT0sNNjVXq3Jq8m0QxOwb4M7JbMQ+PBvvI/P+6HOEqR1l91CyQp
         sswC45Mxukh0p6GwgJMW54eRsq9L/16ViQBFP4BKw80bWblnhvD1QjDtzFgdrhh4At
         OVHKaaTAdvtoA==
Date:   Fri, 18 Feb 2022 20:54:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@ACULAB.COM,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 17/22] net: marvell: prestera: Don't use GFP_DMA when
 calling dma_pool_alloc()
Message-ID: <20220218205408.45d1085e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220219005221.634-18-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
        <20220219005221.634-18-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Feb 2022 08:52:16 +0800 Baoquan He wrote:
> dma_pool_alloc() uses dma_alloc_coherent() to pre-allocate DMA buffer,
> so it's redundent to specify GFP_DMA when calling.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>

This and the other two netdev patches in the series are perfectly
cleanups reasonable even outside of the larger context.

Please repost those separately and make sure you CC the maintainers
of the drivers.
