Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216F6607BC5
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiJUQIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 12:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJUQIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 12:08:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285FC2764C5;
        Fri, 21 Oct 2022 09:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77673B82A05;
        Fri, 21 Oct 2022 16:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55DDC433C1;
        Fri, 21 Oct 2022 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368478;
        bh=UiRSkmLGG8h8OWUsuukJPGxm5IF9vPXFbdctAfnfQG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O0otrJUFVQxArQ1LLLMimV5X3ynOIRSb527unrytBuZAcHdrhYEH5bSoGBZ0EK9Ck
         6CkNnMQntosNqV9q2ysoZpZOPEJXxhVNIdO/m4fopFw0N8S6yJfEwYKYiOXS2eGlN5
         HsIaRAlVCvucORO7b89HksjYWkwpjkG5Fu4qxf/Q/9VURaRYxPbM2n4xnKDD4/CEmY
         FmpwhdmkdlOKbUOw0SnHmwX5BNe9oHQnr+MAGsUD2eTgufMBwKvzMh9S6QXsUlfkK+
         83NTAfl3j38Ds+GR2P5ORvYuHGJlxus6zUzhBHvCvB5vK6r0R6jCaqdC00jImZkAIN
         UiXMoelYn/bdQ==
Date:   Fri, 21 Oct 2022 09:07:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFE net-next] net: tun: 1000x speed up
Message-ID: <20221021090756.0ffa65ee@kernel.org>
In-Reply-To: <20221021114921.3705550-1-i.maximets@ovn.org>
References: <20221021114921.3705550-1-i.maximets@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 13:49:21 +0200 Ilya Maximets wrote:
> Bump the advertised speed to at least match the veth.  10Gbps also
> seems like a more or less fair assumption these days, even though
> CPUs can do more.  Alternative might be to explicitly report UNKNOWN
> and let the application/user decide on a right value for them.

UNKOWN would seem more appropriate but at this point someone may depend
on the speed being populated so it could cause regressions, I fear :S

> Sorry for the clickbait subject line.

Nicely done, worked on me :)
