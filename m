Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC8151CEBB
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388100AbiEFBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349717AbiEFBvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:51:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B8F6211A;
        Thu,  5 May 2022 18:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B5D7B82E5C;
        Fri,  6 May 2022 01:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A507C385A8;
        Fri,  6 May 2022 01:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651801668;
        bh=iNUPXDucMQscZkSdsD/gujWEOnLUNJIvuH6wMr6eYqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aElIlxRmxgkknuQ7NnqOdJphYuTMt1YQyUay8eIs9EsHxPHQ7cGYy93rdgJnbP63T
         Ykuj7qhcgFwkCf8B9O+a7yCF/fFlw2Ywp2jIERDv5H/89Lnt6UOcpTTTIq9VaVwJQX
         GaaTIRJeV5I5fW+2jLk4yCI9W7010dmV+YPZGqz67LMadyGgkQqQ7T2Z80EHhMAyDz
         EO4PK28Y7iT9CTb7bXdLzP8YsNUV/XSJHihi1AVr1gt1VpKEgRUNptW2k/ZPOzNY2a
         iEmnh5PDnvFH6CGulrAoJUrSzaU4E/Lk8iuPUD274ZnPxvy5UgaHlrhojAtddwdfNn
         inlF4ZIXAaW/g==
Date:   Thu, 5 May 2022 18:47:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 3/5] net: hns3: add byte order conversion for
 PF to VF mailbox message
Message-ID: <20220505184746.122aea96@kernel.org>
In-Reply-To: <20220505124444.2233-4-huangguangbin2@huawei.com>
References: <20220505124444.2233-1-huangguangbin2@huawei.com>
        <20220505124444.2233-4-huangguangbin2@huawei.com>
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

On Thu, 5 May 2022 20:44:42 +0800 Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently, hns3 mailbox processing between PF and VF missed to convert
> message byte order and use data type u16 instead of __le16 for mailbox
> data process. These processes may cause problems between different
> architectures.
> 
> So this patch uses __le16/__le32 data type to define mailbox data
> structures. To be compatible with old hns3 driver, these structures use
> one-byte alignment. Then byte order conversions are added to mailbox
> messages from PF to VF.

This adds a few sparse [1] warnings, you must have missed a few
conversions.

Please wait at least 24h for additional feedback before reposting.

[1] https://www.kernel.org/doc/html/latest/dev-tools/sparse.html

