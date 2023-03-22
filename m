Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5292B6C4226
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCVFYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCVFYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:24:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95FE4EC3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDF161F5C
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBABC433EF;
        Wed, 22 Mar 2023 05:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679462566;
        bh=VPeRMY24RUByHh3Qk/pV4yKXWfkfuEd8wwmeEsGmEyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=emVziaNX3frBTdOnNzS0QA9/a3Fp4uwLT1sBONQVsA/rKDuL1RR6LxlX+g4G4qa++
         L5v87+iU4yTtTa/pHAJqyJ0KDIOgvVjY3DZ0enSeGm3vy6Y4GigUtPFP9xFdvxrjti
         UGeY+RAgjk45/ZbDEblCMaqUPDRxL4AgVw2PoiyKb0PeA6Q+diIux5KeEdqBOr21ia
         fatchXKruSk5ABa/xlDtw+om7p9JBMZbcZSwLnEd2WvQoIQvxaeccJziYDaNcwl4dp
         uGR1AuNVpBVP/90le1Jau2hBVnK6QqGteE5rmIRMsTjZaDIsaB7Wzaz+E5Q8pP6ZJM
         lB8L/clgeZ93g==
Date:   Tue, 21 Mar 2023 22:22:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 2/6] tools: ynl: Add struct parsing to
 nlspec
Message-ID: <20230321222245.48328d8b@kernel.org>
In-Reply-To: <20230319193803.97453-3-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-3-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 19:37:59 +0000 Donald Hunter wrote:
> +class SpecStructMember(SpecElement):
> +    """Struct member attribute
> +
> +    Represents a single struct member attribute.
> +
> +    Attributes:
> +        type    string, kernel type of the member attribute

We can have structs inside structs in theory, or "binary blobs" so this
is really a subset of what attr can be rather than necessarily a kernel
type?

> +    """
> +    def __init__(self, family, yaml):
> +        super().__init__(family, yaml)
> +        self.type = yaml['type']
> +

nit: double new line

> +class SpecStruct(SpecElement):
> +    """Netlink struct type
