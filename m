Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06D15541CD
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356882AbiFVEi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356131AbiFVEi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D19C34BB1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 21:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E96FE61947
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020DCC34114;
        Wed, 22 Jun 2022 04:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655872705;
        bh=AOeAKspaAI3fRgwPOl9B6waVIpiwWmGpp+PYyTm3s5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqBorpHjb72UU0kTZi0vxn6lbeHt7D+0xIMXmgJQImk+fYeQshBH0Yx7J1VIAKTja
         foGGDwlmVI9vjeYRT3gKIXknCXCsMw4uG2+en7wvu3of7RaI2JVQKSQsSubB/mjliw
         eMqt7edDi5daoNeLeSyxjUvpycmwYwQSFuWM2c6jsnAoIoXpyY5Df7U6bUe+H0yD4g
         rFDSyikJBvFsU+LmHRJsAjRf2hoGvEPCKfTVWlCc9eLYZJ0PqsgHdWOKPt34b/M5ev
         LAox5/q87EMGpWVv5qcwnvBTofoWEdJGlo60MHJQA4KFcVRCC060DgqBOO6wqM6veI
         OJK5zff9tk01g==
Date:   Tue, 21 Jun 2022 21:38:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
Message-ID: <20220621213823.51c51326@kernel.org>
In-Reply-To: <15667.1655862139@famine>
References: <9088.1655407590@famine>
        <20220617084535.6d687ed0@kernel.org>
        <5765.1655484175@famine>
        <20220617124413.6848c826@kernel.org>
        <28607.1655512063@famine>
        <20220617175550.6a3602ab@kernel.org>
        <20220621125233.1d36737b@kicinski-fedora-PC1C0HJN>
        <15667.1655862139@famine>
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

On Tue, 21 Jun 2022 18:42:19 -0700 Jay Vosburgh wrote:
> 	Sorry, was out for the three day weekend.
> 
> 	I had a quick look and I think you're probably right that
> anything with a ndo_tx_timeout will deal with trans_start, and anything
> without ndo_tx_timeout will be a software device not subject to delayed
> batching of stats updates.
> 
> 	And, yes, if there are no objections, what I'd like to do now is
> apply the veth change to get things working and work up the bifurcated
> approach separately (which would ultimately include removing the
> trans_start updates from veth and tun).

Works for me, thanks!
