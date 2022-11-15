Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C603628EF4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiKOBNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiKOBNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16BEFAF3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:13:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FC29B8163C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F1EC433C1;
        Tue, 15 Nov 2022 01:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668474787;
        bh=zSWoh/Wz7OwHLZ2Lk5RQVxYpD/vHXtotWaQPtWfkLEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1hs81Hgr3ZwjdHR2X9R88c3vF+dtaTp8RV05N9XoV97sh8fX7aBxg4RMqiCbpDxg
         AeCVTwSjKBc2SHcgeJvd2NKotGrw3ewFrgvnWTCBlvHDtZwlxu7WPRUYvuVvQ99xFC
         tJzxZ9rw8FZdjAHagxdZUAsDXzZY6/00TrTz6FwwfOVR1YVtu2lY2XHfXjLMVXRdBE
         SHl+L5ww9RmAmF1sDgWKVjbZdCylJvE/yyunDjkcukKajJylVWVtFem8Ajozgm2YxL
         +v+HuSXiBmsXLv5/qZC2CwPsy37Uv9h8j6VDrIs63q4BYKp9bqHBaoNm5688lUfm5S
         zjvkGuI0tRjww==
Date:   Mon, 14 Nov 2022 17:13:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <20221114171305.6af508be@kernel.org>
In-Reply-To: <Y3LmC7r4YP++q8fa@lunn.ch>
References: <20221109224752.17664-1-davthompson@nvidia.com>
        <20221109224752.17664-4-davthompson@nvidia.com>
        <Y2z9u4qCsLmx507g@lunn.ch>
        <20221111213418.6ad3b8e7@kernel.org>
        <Y29s74Qt6z56lcLB@x130.lan>
        <20221114165046.43d4afbf@kernel.org>
        <Y3LmC7r4YP++q8fa@lunn.ch>
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

On Tue, 15 Nov 2022 02:06:19 +0100 Andrew Lunn wrote:
>   > I am not advocating for black magic tables of course :), but how do we  
> > > avoid them if request_firmware() will be an overkill to configure such a
> > > simple device? Express such data in a developer friendly c structures
> > > with somewhat sensible field names?  
> > 
> > I don't feel particularly strongly but seems like something worth
> > exploring. A minor advantage is that once the init is done the tables
> > can be discarded from memory.  
> 
> I wondered about that, but i'm not sure initdata works for modules,
> and for hot pluggable devices like PCIe, you never know when another
> one might appear and you need the tables.

Right, I meant that the request_firmware() version can discard 
the tables. I shouldn't have said tables :)
