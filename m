Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761B96D70C5
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbjDDXgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbjDDXgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:36:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468B2273F
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 16:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D334663A54
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 23:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A8BC433A0;
        Tue,  4 Apr 2023 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680651381;
        bh=GLF0W1sG/lWgyJ1NYP83Un1EtaVi1Xarz+pRflcCQAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SR8tqIZ8yIkRBIZewRnOeFZ+LzaK5qcOL0f7SZvwij5V2VbR1tfESgAAhotSR0KoU
         BZK4+G9bTgfnxapuKFU3eEE2pyxWkDTzQm/T/Ln+4za+jDO94W6KVJr1+RdaWqzaSm
         DBLWFBgOMmkzKwCeaC95QPgV1EfMQLFZfWKAcBcdXySSuN1snUNzru6rpTgZURa82i
         xQ5JX0B2tLV1SekZG9pVizpT/P6owf4PLUQ6yXjq1dKC5yF7KA2i6QGCc3JKKOX/LI
         7a/zQU7m8+zZFynvTITV8SaGZCwiRikB6TG8wmT6jckcRxsCI+QSSk3PQe4X+XOcfb
         2cVYvKFRCwzew==
Date:   Tue, 4 Apr 2023 16:36:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, habetsm.xilinx@gmail.com,
        sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH net-next 1/6] net: ethtool: attach an IDR of custom
 RSS contexts to a netdevice
Message-ID: <20230404163619.43efc7b7@kernel.org>
In-Reply-To: <8617a74b-959a-761b-3c4a-228a06d2794a@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <671909f108e480d961b2c170122520dffa166b77.1680538846.git.ecree.xilinx@gmail.com>
        <20230403144357.2434352d@kernel.org>
        <8617a74b-959a-761b-3c4a-228a06d2794a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 12:30:42 +0100 Edward Cree wrote:
> > Isn't IDR just a legacy wrapper around xarray anyway?  
> 
> I see it as a *convenience* wrapper.  Is it deprecated?

Hm, I'm not so sure what the relation between idr and xarray
is after glancing at the code.
I'm more used to seeing xarray these days but if you prefer 
to keep the IDR it's fine.
