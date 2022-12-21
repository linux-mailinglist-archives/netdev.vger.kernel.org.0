Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B5E652C22
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 05:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbiLUElM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 23:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLUElK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 23:41:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759B21DA40;
        Tue, 20 Dec 2022 20:41:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88611615E4;
        Wed, 21 Dec 2022 04:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2D0C433D2;
        Wed, 21 Dec 2022 04:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671597664;
        bh=wSFQUgGJzXV6d5gMKnkYoaOMkAFlJRLD40jAU2lzBgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZTCajLEr95mk1dWWzJXkTGmclB8AP4Zp2iWzv3qqntF4IvSFPWU2u7Jv2+FAfjq3Z
         MUyjmRfJofbtS8XOGhBuSyuxLeSH7CNbjePGL74xNqiFanX7HoG6pk9kYKpPCsByrN
         EAaXCSfqLTZGSt2RrqE4zj6KOiky4ibeAx+itHxrNhXODSZ0vWYNCHAm9ROLTVF5Kn
         ARbP74GOV/K0ufsNySJsmafg/tk3BrUJGKI9+VETAw1pAsXNeRP9/M2j7Ei/x9dY6o
         kNLzDSXsxKro9YUINkN8yiSVnTmVtgsFVeTdkeM1XuDEORsmSi1NIAsgrj+fzT/hg3
         AmW1FFr+sZatw==
Date:   Tue, 20 Dec 2022 20:41:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majtyka <alardam@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, hawk@kernel.org,
        pabeni@redhat.com, edumazet@google.com, toke@redhat.com,
        memxor@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
Message-ID: <20221220204102.5e516196@kernel.org>
In-Reply-To: <20221220153903.3fb7a54b@kernel.org>
References: <cover.1671462950.git.lorenzo@kernel.org>
        <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
        <20221219171321.7a67002b@kernel.org>
        <Y6F+YJSkI19m/kMv@lore-desk>
        <CAAOQfrF963NoMhQUTdGXyzLMdAjHfUmvzvxpOL0A1Cv4NhY97w@mail.gmail.com>
        <20221220153903.3fb7a54b@kernel.org>
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

On Tue, 20 Dec 2022 15:39:03 -0800 Jakub Kicinski wrote:
> On Tue, 20 Dec 2022 23:51:31 +0100 Marek Majtyka wrote:
> > Everybody is allowed to make a good use of it. Every improvement is
> > highly appreciated. Thanks Lorenzo for taking this over.  
> 
> IIUC this comment refers to the rtnl -> genl/yaml conversion.
> In which case, unless someone objects, I'll take a stab at it 
> in an hour or two and push the result out my kernel.org tree ...

I pushed something here:

https://github.com/kuba-moo/ynl/commits/xdp-features

without replacing all you have. But it should give enough of an idea 
to comment on.
