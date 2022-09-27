Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC645EBFAC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiI0KYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiI0KYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46133C8CC;
        Tue, 27 Sep 2022 03:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55010617B2;
        Tue, 27 Sep 2022 10:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FE5C433D7;
        Tue, 27 Sep 2022 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664274283;
        bh=68k0xU1GfUSymB8AypufkqWyiTubHjmRgLZtW7+ewT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yw3tmZt5rZWo3ewUFQvmHrIcWXW+NQnK4t82rlrLQvC1e8zvgybFDSKYGeYJAiZc5
         +RdqXmjN98axgJoJpD5ut2tiAy0Gc7jN+8cIkSmdIJV79ocCGcCDweW+5CV79/CLMY
         p0WfphvEH0994jZGy9alODCmx3Wm3GzdIbixni0fd5+BOJF0zqxZvnftehTLzultXg
         G9RNOnmkJjaF44zOZCdexOMOgCdnNF3YJOhowAtV3IIhN8SPs2IIfY9byEk6c2Sh66
         wyTL2Y1Q+CTGHbArVACxa5G4fKV8TPJ180QKzoqeMqucXhecB6hDHo3x2QZXWpT49k
         +4ZbqZfcyhOOw==
Date:   Tue, 27 Sep 2022 13:24:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "huangguangbin (A)" <huangguangbin2@huawei.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, lanhao@huawei.com
Subject: Re: [PATCH net-next 00/14] redefine some macros of feature abilities
 judgement
Message-ID: <YzLPZrNdm4Ol6hUb@unreal>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
 <Yy7pjTX8VLLIiA0G@unreal>
 <77050062-93b5-7488-a427-815f4c631b32@huawei.com>
 <20220926101135.26382c0c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926101135.26382c0c@kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:11:35AM -0700, Jakub Kicinski wrote:
> On Mon, 26 Sep 2022 20:56:26 +0800 huangguangbin (A) wrote:
> > On 2022/9/24 19:27, Leon Romanovsky wrote:
> > > On Sat, Sep 24, 2022 at 10:30:10AM +0800, Guangbin Huang wrote:  
> > >> The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
> > >> hns3_enet layer may need to use, so this serial redefine these macros.  
> > > 
> > > IMHO, you shouldn't add new obfuscated code, but delete it.
> > > 
> > > Jakub,
> > > 
> > > The more drivers authors will obfuscate in-kernel primitives and reinvent
> > > their own names, macros e.t.c, the less external reviewers you will be able
> > > to attract.
> > > 
> > > IMHO, netdev should have more active position do not allow obfuscated code.
> > > 
> > > Thanks
> > >   
> > 
> > Hi, Leon
> > I'm sorry, I can not get your point. Can you explain in more detail?
> > Do you mean the name "macro" should not be used?
> 
> He is saying that you should try to remove those macros rather than
> touch them up. 

Exactly, thanks Jakub.
