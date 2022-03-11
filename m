Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA644D578E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345217AbiCKBvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiCKBvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:51:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629D0F65CD;
        Thu, 10 Mar 2022 17:50:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1921BB829A1;
        Fri, 11 Mar 2022 01:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66172C340EB;
        Fri, 11 Mar 2022 01:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646963426;
        bh=UTLIxBwkAa6+a+oJdAWOCcqoxU8Z4IdlVYhcKep9wKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nO2MrXJntZmfjMoIOmT9F0FRcK0mtdojnjJqQ/fteCIixZZbeSf8LiI9E5Ha0eZgD
         59s18emSpb3ohxUSttI/iMdUEnrRhmSzx95LnrKSZITEZqqx7WHuwqPbfzDnk8byzw
         EbrofH30cgteMKHlDuepkyCL4k9iDYOUis/dYitzgFoud2kJLvzy7zLRvYe2URduu0
         1+ZEIIrs8vfk4HbQSnPXTSjbJEoSpWswtnQtrVQDEQcb1vHyYAwXueyEji06vhxrHN
         hNouXWPbm9Z7dqexDJmV39n1NhYfaHgJoloj1+uY/3lM3MWFpnejWqk3o5SV6SB+d/
         nsk7+AAUBmpEQ==
Date:   Thu, 10 Mar 2022 17:50:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiyong Park <jiyong@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vsock: each transport cycles only on its own sockets
Message-ID: <20220310175025.69e35aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALeUXe7OGUUt+5hpiLcg=1vWsOWkSRLN3Lb-ncpXZZjsgZntjQ@mail.gmail.com>
References: <20220310135012.175219-1-jiyong@google.com>
        <20220310141420.lsdchdfcybzmdhnz@sgarzare-redhat>
        <20220310102636-mutt-send-email-mst@kernel.org>
        <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALeUXe7OGUUt+5hpiLcg=1vWsOWkSRLN3Lb-ncpXZZjsgZntjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 10:26:08 +0900 Jiyong Park wrote:
> First of all, sorry for the stupid breakage I made in V2. I forgot to turn
> CONFIG_VMWARE_VMCI_VSOCKETS on when I did the build by
> myself. I turned it on later and fixed the build error in V3.
> 
> > Jiyong, would you mind collecting the tags from Stefano and Michael
> > and reposting? I fixed our build bot, it should build test the patch
> > - I can't re-run on an already ignored patch, sadly.  
> 
> Jakub, please bear with me; Could you explain what you exactly want
> me to do? I'm new to kernel development and don't know how changes
> which Stefano and Machael maintain get tested and staged.

I was just asking to send the same patch (v3) second time to kick off
a CI. You can change the subject prefix to "[PATCH net v3 resend]".
And add

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>

between the "Fixes:" and your "Signed-off-by:" tag, since the code will
be identical.

The CI didn't catch v3 because I fumbled patch filtering config.
Your posting was correct, it was entirely my error.
