Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE664ACFE2
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345332AbiBHDvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238983AbiBHDvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8854EC0401DC;
        Mon,  7 Feb 2022 19:51:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6BF61529;
        Tue,  8 Feb 2022 03:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DBAC004E1;
        Tue,  8 Feb 2022 03:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644292300;
        bh=ABaVsbOIb3+OcYn2+ylzu6Byh3EUHq/wPhjW1EhoBIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBYF/lrlFyeSuS2oqOc/d9fIcdy7zrA4gRdFau3P52O1c7B+0o3KhDqmNTPlsH/0i
         sunvseBZ+AZWK+CfmcUkUJEE3Mv+4xW8md3dh+Q0vo+eYssqxMSr661akKap8ptas6
         B8ugcNMyduW8TdDMPVYV7p4dTFqIJtzEWrHJOuLkz4hW4hzSuywV6C/pP61M1ziHtX
         6QYbo+UbjMctfN34OuqMJGraQLIv0l9DSW8q96rWUEDU6eq0Pe63zjwDNorG/uHRIj
         JTrCuucSraQq+eWphiznzSzOEKFNpL5uyVRyk9jkPbrH0TE8vhkSnWB/uWc9hzJpMM
         Reo9UYUvAUa2w==
Date:   Mon, 7 Feb 2022 19:51:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v7 net-next] net-core: add InDropOtherhost counter
Message-ID: <20220207195139.77d860cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207235714.1050160-1-jeffreyji@google.com>
References: <20220207235714.1050160-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Feb 2022 23:57:14 +0000 Jeffrey Ji wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> Increment InDropOtherhost counter when packet dropped due to incorrect dest
> MAC addr.
> 
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
> 
> example output from nstat:
> \~# nstat -a | grep InMac
> Ip6InDropOtherhost                  0                  0.0
> IpExtInDropOtherhost                1                  0.0
> 
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> counter was incremented.

As far as I can tell nobody objected to my suggestion of making this 
a netdev counter, so please switch to working on that. Thanks.
