Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD0954BF33
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbiFOBTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiFOBTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C761AD85
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 18:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2AF61981
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264C6C3411B;
        Wed, 15 Jun 2022 01:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655255955;
        bh=cqUQldzwMNHn/e5eAgc2b9bv7+EGUVT/AaVRUjmyG5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lQmlLU0ZUUCqtBKy7IMfVBk0cuNMMDwMl30O18ZYA4NsMdw5UyYAxay2H4RnV/vIf
         1X/xyBgOEch7EV9zQveuJkkLIcBagXJN1V3h5dnnCRQ6+g8hQPLZwiOclSdYerF91Q
         46DwvYdXoiBz1YlNmLDZbeBW4wugYR6cdPyEvMHlFSN+zKYZ+mlfqBy982+MWmmzMX
         wLDvK6ySwr9LGo7Fpxz+ER0f7gb88R2iaxJeJanu1b23zCLdvoZzq9zAUcNzCt3OEm
         LBTksV+cqPYio4cU4XDOiiq+q3vFN/WMfy3FiZuaBxgX/zOXA6tqh5eaeIJ3TUBDgh
         5X7zVw54lCAJQ==
Date:   Tue, 14 Jun 2022 18:19:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Lixue Liang <lianglixuehao@126.com>, <pmenzel@molgen.mpg.de>,
        <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <lianglixue@greatwall.com.cn>, <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v6] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <20220614181914.4cd8fe97@kernel.org>
In-Reply-To: <cbfb5d1a-dadd-efe5-b5d9-de9f483e44b2@intel.com>
References: <20220610023922.74892-1-lianglixuehao@126.com>
        <cbfb5d1a-dadd-efe5-b5d9-de9f483e44b2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 12:09:02 -0700 Tony Nguyen wrote:
> > Add the module parameter "allow_invalid_mac_address" to control the  
> 
> netdev maintainers:
> 
> I know the use of module parameters is extremely frowned upon. Is this a 
> use/exception that would be allowed?

I think so, I don't see a different way here.
