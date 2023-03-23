Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E706C6EB3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCWRYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjCWRX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:23:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCFA26C2A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06979B821EB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 17:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E06C433D2;
        Thu, 23 Mar 2023 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679592212;
        bh=Z5yFouO4Y/B0wIrNXGglmNZazWi6fNHni7xFvhYIa+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxW1WvUhs3XDImCh7zAadlbJgQSUrnY75pHnPyDAEjqSGgsqnbBgi2dnfIQsgWnqa
         MXXrMmOoSItE6bIbLt0Qhyy0VmS2eOH6SvQoiDZZWSlA5Si5eHUsmJev+s7knCShUP
         TU5ppvUfmTaBuhc86i7LF3F/UCagFB9Y8kpoH90HljlrXug35SVWv2kn4ffrd0DIDi
         c56D3LLog5jaNTqDCFBCPzLQOWGVm66zGZ4HNtOkxUDq9O0C9DmLMe9xDWxLHCOLcS
         6SshnQ4Ola710HRmIFqxkMwFcpxSpvC2EipRtpnH9ASNO+yYXid6yTSjYYAbriUjCU
         gz8DvEhR7+wiA==
Date:   Thu, 23 Mar 2023 10:23:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] devlink: Add port function attributes to
 enable/disable IPsec crypto and packet offloads
Message-ID: <20230323102331.682ac5d6@kernel.org>
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
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

On Thu, 23 Mar 2023 13:10:55 +0200 Dima Chumak wrote:
> Currently, mlx5 PCI VFs are disabled by default for IPsec functionality.
> A user does not have the ability to enable IPsec support for a PCI VF
> device.
> 
> It is desirable to provide a user with a fine grained control of the PCI
> VF device IPsec capabilities. 

Is it fine grained? How many keys can each VF allocate?

> The above are a hypervisor level control, to set the functionality of
> devices passed through to guests.
> 
> This is achieved by extending existing 'port function' object to control
> capabilities of a function. It enables users to control capability of
> the device before enumeration.
> 
> The series introduces two new boolean attributes of port function:
> ipsec_crypto and ipsec_packet. They can be controlled independently.
> Each to provide a distinct level of IPsec offload support that may
> require different system and/or device firmware resources. 

On a quick read I have no idea what the difference between the two
knobs is :S
