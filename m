Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7355F4D0C
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJEAay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJEAau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B14756B82;
        Tue,  4 Oct 2022 17:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED89BB81B54;
        Wed,  5 Oct 2022 00:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45066C433D6;
        Wed,  5 Oct 2022 00:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664929847;
        bh=y4Zwm8QOPM6J2mvf2FDbEYt5AqCQVuApnRv1mKgcby8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEoHgV50wq7+CCtjldXASZQq4dfOAIQECU2Ieaczh37GmqqGS57nIuP588wl5TmCk
         3B33uPCR24m791TKLtDOH2u7ptipHps4i2V8ZW8iKy11Sg5Uj3mLyo4gJo/H3CSkxi
         maj/277l9cWCTJHba8dalj/Nq0HSKnRK6KYEsYFhTlV9Rntc1iZvDEMQPnNttqQztc
         jnHRDt4k5QZezRezDhI3VVmBcFIGyiKsWww1A0PVEmezbHnOyzno2f09/VAEnlP6Ip
         fd4IRhGu1iuYAcVBXSOVTAuBQTuhiZqVbBlCAbfjCy8yMYSCX78HScIVl7K2tjxz04
         bn1yg48lGg6xA==
Date:   Tue, 4 Oct 2022 17:30:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Peter Kosyh <pkosyh@yandex.ru>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: benet: use snprintf instead sprintf and IFNAMSIZ
 instead hardcoded constant.
Message-ID: <20221004173046.5ec6d3ca@kernel.org>
In-Reply-To: <20221004082936.0d0c9bcb@hermes.local>
References: <20221004095034.377665-1-pkosyh@yandex.ru>
        <20221004082936.0d0c9bcb@hermes.local>
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

On Tue, 4 Oct 2022 08:29:36 -0700 Stephen Hemminger wrote:
> On Tue,  4 Oct 2022 12:50:34 +0300
> Peter Kosyh <pkosyh@yandex.ru> wrote:
> 
> > printf to array 'eqo->desc' of size 32 may cause buffer overflow when
> > using non-standard IFNAMSIZ.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>  
> 
> NACK
> Non-standard IFNAMSIZ will break uapi and many things.
> I see no reason for kernel or tools like iproute2 to support or
> fix those related bugs.

I think the commit message is missing the point, but the warning
may be legit.

Pater please read the requirements for sending patches based on
automated checkers:

  Documentation/process/researcher-guidelines.rst
