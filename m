Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999116BDA7E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCPU73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCPU72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EEB3CE07
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 13:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84DCA62120
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78559C433D2;
        Thu, 16 Mar 2023 20:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679000365;
        bh=KFcq5kiUa6UxBPCJWG0fcMpgMZkOUlwzqDRWprus/hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xpjn4Rg5uy+8lAEtVw34F7yFVZibWg2HntOX4SvjV8sfU56f89XK4ZCl/PBNMYeR4
         mCht3zkiMMgxS0jLCShe9oK/5Th3fdeNFzGSkK4e0H1yT+VXLH+i6YvGrHELNs0D82
         Ued21FqxOCp0CdvOFaMkbnmiWpi2Q6sYFu3MaO1x8NSQWQbBkFwQ+5Dv0tSQMR/5Nt
         g2pfNwxqmq0nnkQ0G7FgbY9b0/HjgoXsvx8rNj5Ep0rtAppJz5ekLkwbTdKhWPfwjX
         FOTp33ttFuDa+P4yORlJFKRPfArjwN38MZFNTlfX+X+z3SnPLvi/IhN4G+CdkeO+FK
         zoryvBHp5irwQ==
Date:   Thu, 16 Mar 2023 13:59:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmed Zaki <ahmed.zaki@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 3/3] iavf: do not track VLAN 0 filters
Message-ID: <20230316135924.4ece7127@kernel.org>
In-Reply-To: <bf4ce937-8528-69f1-7ba5-ef9772ce42aa@intel.com>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
        <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
        <20230315084856.GN36557@unreal>
        <bf4ce937-8528-69f1-7ba5-ef9772ce42aa@intel.com>
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

On Thu, 16 Mar 2023 07:15:32 -0600 Ahmed Zaki wrote:
> > I would expect similar check in iavf_vlan_rx_kill_vid(),
>
> Thanks for review. Next version will include the check in 
> iavf_vlan_rx_kill_vid()

FWIW it is okay to ask more clarifying questions / push back
a little. I had a quick look and calling iavf_vlan_rx_kill_vid()
with vid of 0 does not seem harmful. Or any vid that was not added
earlier. So it's down to personal preference. I see v2 is already 
out but just for future reference..
