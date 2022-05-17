Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6768E52A681
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350073AbiEQP03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349958AbiEQP0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:26:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1077B1F4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 08:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BE10B818F3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 15:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7A4C34113;
        Tue, 17 May 2022 15:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652801160;
        bh=q25BolVy5ttopK3U2L5/6mkE0COeBu9MkPrZYCImf6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qQwYHJ/QMXiXuSf+FDir1v3GwBH8N5cqQ0i14u5uTx+tngTBcfF2FLAQWBRLEx4qy
         TvkcXQtNUV6hl3zCAt484GJusCQ/5L0JhceKAxIB/SG3hUf4n1Uy1uHeVZ/1rxpIcG
         oEI+s/Iqn2v6LgyVp3eGUfWtHVl95/RuWjWDUxUyRrn+C3WG3QC7fQ5XHBv743Sko4
         9qAuh3i+tQkLSlS2qLNzwnonq8PBEHlZZmZigOhIr/uDDaola2RXyi0/WRxhlLW106
         WPzNv96nfmK0jf4Cn5C/44bZBT3yhTQHop/xSMlHfgp2SsGlcVr9Ug88yS7rEsHhrv
         y1SX+OjXC/ktA==
Date:   Tue, 17 May 2022 08:25:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v3 02/10] ptp: ocp: add Celestica timecard PCI
 ids
Message-ID: <20220517082558.59991355@kernel.org>
In-Reply-To: <20220517014644.4jxm4evud46ybsh3@bsd-mbp.dhcp.thefacebook.com>
References: <20220513225924.1655-1-jonathan.lemon@gmail.com>
        <20220513225924.1655-3-jonathan.lemon@gmail.com>
        <20220516174303.73de08ae@kernel.org>
        <20220517014644.4jxm4evud46ybsh3@bsd-mbp.dhcp.thefacebook.com>
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

On Mon, 16 May 2022 18:46:44 -0700 Jonathan Lemon wrote:
> On Mon, May 16, 2022 at 05:43:03PM -0700, Jakub Kicinski wrote:
> > On Fri, 13 May 2022 15:59:16 -0700 Jonathan Lemon wrote:  
> > > +#ifndef PCI_VENDOR_ID_CELESTICA
> > > +#define PCI_VENDOR_ID_CELESTICA 0x18d4
> > > +#endif
> > > +
> > > +#ifndef PCI_DEVICE_ID_CELESTICA_TIMECARD
> > > +#define PCI_DEVICE_ID_CELESTICA_TIMECARD 0x1008
> > > +#endif  
> > 
> > The ifdefs are unnecessary, these kind of constructs are often used out
> > of tree when one does not control the headers, but not sure what purpose
> > they'd serve upstream?  
> 
> include/linux/pci_ids.h says:
> 
>  *      Do not add new entries to this file unless the definitions
>  *      are shared between multiple drivers.
> 
> Neither FACEBOOK (0x1d9b) nor CELESTICA (0x18d4) are present
> in this file.  This seems to a common idiom in several other
> drivers.  Picking one at random:
> 
>    gve.h:#define PCI_VENDOR_ID_GOOGLE 0x1ae0
> 
> 
> So these #defines are needed.

Indeed, but also I'm not complaining about defines but the ifdefs 
in which they are wrapped :)
