Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3450654E763
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiFPQeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiFPQe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:34:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1C42F018;
        Thu, 16 Jun 2022 09:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EFD78CE263E;
        Thu, 16 Jun 2022 16:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F4C34114;
        Thu, 16 Jun 2022 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655397264;
        bh=29T+OZ2dJ8xYgp5r7/nDFbsxSnK+qN8k/QH2sDJqclU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nkaBP3DydJciNyiYD+He/cemq7jOl1vFjzycfaq7HUEXNmaAiTvhL3KFqt3U4pdmx
         OkwvanYXO5S9uINrPZ6QSpIzF1KAc16/FflMYMVBxWSeZOxLiTVb0/cEMfzsSsyyRe
         wrMkldTF5Khbat6folXjrqr9MSQONZokoOYqvHV3DvksPSDteRuNhIjP0Bgp1s7BFp
         G4DzVGbeLBy1QKQJ1QaI9Smr/GPCEzMmoi4lST1ncKbeksUoDTNP+Nmp/Ambtg1ovM
         8exV2SmcP+4c8ooLPW42RRn+BzPvbXqis4Lr2yvKhlbYKCmVVH24CGspp0ayB1FD1S
         qWGEzDk8NYLSA==
Date:   Thu, 16 Jun 2022 09:34:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: 6lowpan netlink
Message-ID: <20220616093422.2e9ec948@kernel.org>
In-Reply-To: <CAK-6q+h7497czku9rf9E4E=up5k5gm_NT0agPU2bUZr4ADKioQ@mail.gmail.com>
References: <CAK-6q+g1jy-Q911SWTGVV1nw8GAbEAVYSAKqss54+8ehPw9RDA@mail.gmail.com>
        <e3efe652-eb22-4a3f-a121-be858fe2696b@datenfreihafen.org>
        <CAK-6q+h7497czku9rf9E4E=up5k5gm_NT0agPU2bUZr4ADKioQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 09:00:08 -0400 Alexander Aring wrote:
> > > I want to spread around that I started to work on some overdue
> > > implementation, a netlink 6lowpan configuration interface, because
> > > rtnetlink is not enough... it's for configuring very specific 6lowpan
> > > device settings.  
> >
> > Great, looking forward to it!  
> 
> I would like to trigger a discussion about rtnetlink or generic. I can
> put a nested rtnetlink for some device specific settings but then the
> whole iproute2 (as it's currently is) would maintain a specific
> 6lowpan setting which maybe the user never wants...
> I think we should follow this way when there is a strict ipv6 device
> specific setting e.g. l2 neighbor information in ipv6 ndisc.

Unless you'll have to repeat attributes which are already present 
in rtnetlink in an obvious way genetlink > rtnetlink.
