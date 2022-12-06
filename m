Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B09964426D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLFLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234407AbiLFLtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:49:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB53E17416;
        Tue,  6 Dec 2022 03:49:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 699FCB819AE;
        Tue,  6 Dec 2022 11:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8C4C433D6;
        Tue,  6 Dec 2022 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670327370;
        bh=jpNRSCrAwScrzo73RHAzCPD2+2OMYIYifGr0nc1dD2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zRq5mG4R2BQSp3uA10kQ8Tdt24sbMMLIo2JCqM15zQ/xqAPqoJCrwvkkCr85xbknK
         oZIV0jJIUIPBR74tqcoTADheFOFYoyZ71L8nw9mNJBcrxoQPHqqSPtaY0cHuR1OP1o
         D6xrEO6DG8LI2tsebL7KXjXeei11gSmHMYMR6eFo=
Date:   Tue, 6 Dec 2022 12:49:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cengiz Can <cengiz.can@canonical.com>
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regarding 711f8c3fb3db "Bluetooth: L2CAP: Fix accepting
 connection request for invalid SPSM"
Message-ID: <Y48sR0xv0yuH8GDd@kroah.com>
References: <f0b260c1-a7c4-9e0e-5b29-a3c8a7570df1@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0b260c1-a7c4-9e0e-5b29-a3c8a7570df1@canonical.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:27:27PM +0300, Cengiz Can wrote:
> Hello Luiz Augusto,
> 
> 
> I'm by no means a bluetooth expert so please bear with me if my
> questions sound dumb or pointless.
> 
> 
> I'm trying to backport commit 711f8c3fb3db ("Bluetooth: L2CAP: Fix
> accepting connection request for invalid SPSM") to v4.15.y and older
> stable kernels. (CVE-2022-42896)
> 
> 
> According to the changes to `net/bluetooth/l2cap_core.c` there are two
> functions that need patching:
> 
> 
> * l2cap_le_connect_req
> * l2cap_ecred_conn_req
> 
> 
> 
> Only the former exists in kernels <= v4.15.y. So I decided to skip
> 
> l2cap_ecred_conn_req for older kernels.
> 
> 
> Do you think this would be enough to mitigate the issue?
> 
> 
> 
> If so, older kernels also lack definitions of L2CAP_CR_LE_BAD_PSM and
> 
> L2CAP_PSM_LE_DYN_END.
> 
> 
> I see that L2CAP_CR_LE_BAD_PSM is basically the same as
> L2CAP_CR_BAD_PSM so I used it to signify an error.
> 
> 
> I think it should be enough for the sake of a backport.
> 
> 
> What do you think?

I've already done this backport and it is in the latest -rc1 stable
kernel releases.  Is it not working for you there?  Why do it again?

thanks,

greg k-h
