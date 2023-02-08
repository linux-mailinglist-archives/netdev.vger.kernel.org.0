Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D1968E815
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 07:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjBHGM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 01:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBHGMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 01:12:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1051A1E9C3;
        Tue,  7 Feb 2023 22:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB49611BC;
        Wed,  8 Feb 2023 06:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08E1C433EF;
        Wed,  8 Feb 2023 06:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675836743;
        bh=kl0CmqDczRj918avqw3W5gZdBSg+OQAV0J0rp0R7zqI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OXcQ43aJxfNmfcBnpslF/sEZj9HF5Cqrc5iGCYdAhjL+zC7Eiy87mTSTSoEzDOOzC
         QhjOddoeFVIRsoRQt1rZau5hmatQLeNp5O2KJS0gFOd+J8J1Veui4OZ2JDECy4tq/b
         lN7rygHXhtjXD+RHPzi3JJRw0Akc6qJe/QDxim6C3A1+lUG93JmRv0sARxdpnIJr/Z
         475BtuVqNtzdSTM8vgHH6i8UbSqpG50AYHoAoeGcZFLkhb/a7uoMvuesLyc0Y06Qtz
         f4Q0dx5kMcWZO7Nl+yWNlMb7c7pTVoyaT/QiRdG7s0riQwQa62nXc3Y8+gR/+j+O7H
         5VOWMPL2SnkyQ==
Date:   Tue, 7 Feb 2023 22:12:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Message-ID: <20230207221221.52de5c9a@kernel.org>
In-Reply-To: <20230207192849.2732-1-doshir@vmware.com>
References: <20230207192849.2732-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Feb 2023 11:28:49 -0800 Ronak Doshi wrote:
> Commit b3973bb40041 ("vmxnet3: set correct hash type based on
> rss information") added hashType information into skb. However,
> rssType field is populated for eop descriptor.
> 
> This patch moves the RSS codeblock under eop descritor.

Does it mean it always fails, often fails or occasionally fails 
to provide the right hash?

Please add a Fixes tag so that the patch is automatically pulled 
into the stable releases.
