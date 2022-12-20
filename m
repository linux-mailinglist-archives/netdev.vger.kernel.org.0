Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D776529F0
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiLTXjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiLTXjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:39:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4681FF90;
        Tue, 20 Dec 2022 15:39:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A9D761627;
        Tue, 20 Dec 2022 23:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3349C433D2;
        Tue, 20 Dec 2022 23:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671579544;
        bh=Pqts0QvvwS19/BeiYhbX1dNE/hndPp0pOtk3LpXTkVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RNXm66T1rPxCTv2heKoNPSw6u9DAYb2Rc/0Mu7GUXebMJX2mHpBC9xN8ag3g57PYu
         alm/NGg3+KS0kHvu6Ucu0NTSuT5wJZcK2lvMaF75zmgi9cbJvPlverFfDclO+wWvN3
         xPMDmIlJDMcHom4MU43p5i//6ACXGKhJUdBUG66pWj51+3ptLYx/Et/ZMKpCS2IhKi
         MbQbj9Y9zxt8ePcIvnNYjIpeocRb+UKfqAUHTzlqO7PvPdVtODtZeQWa0Sy/N+qjTG
         7YKOHq8u9R09YANjT5Sq9cPuPg7xhOfZpn9ACoHd1yvCcbOeI5qsISulo28Je0jxnn
         2zuf9k1S/P79A==
Date:   Tue, 20 Dec 2022 15:39:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Majtyka <alardam@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
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
Message-ID: <20221220153903.3fb7a54b@kernel.org>
In-Reply-To: <CAAOQfrF963NoMhQUTdGXyzLMdAjHfUmvzvxpOL0A1Cv4NhY97w@mail.gmail.com>
References: <cover.1671462950.git.lorenzo@kernel.org>
        <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
        <20221219171321.7a67002b@kernel.org>
        <Y6F+YJSkI19m/kMv@lore-desk>
        <CAAOQfrF963NoMhQUTdGXyzLMdAjHfUmvzvxpOL0A1Cv4NhY97w@mail.gmail.com>
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

On Tue, 20 Dec 2022 23:51:31 +0100 Marek Majtyka wrote:
> Everybody is allowed to make a good use of it. Every improvement is
> highly appreciated. Thanks Lorenzo for taking this over.

IIUC this comment refers to the rtnl -> genl/yaml conversion.
In which case, unless someone objects, I'll take a stab at it 
in an hour or two and push the result out my kernel.org tree ...
