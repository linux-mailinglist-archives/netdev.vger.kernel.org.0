Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7A6544FA
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiLVQRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiLVQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:17:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF10220C6;
        Thu, 22 Dec 2022 08:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C895AB803F2;
        Thu, 22 Dec 2022 16:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B5BC433EF;
        Thu, 22 Dec 2022 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725847;
        bh=Dg4BfgoD9YyHNiJlbfaKe3wduOjMhakUuIqaDZWVMts=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=r6iKDDAJAHG+tS7DCBhoWziRGZ0VtwQfnefbMTUuPF7/ibqRSOCtx1EF1UK+X+9U/
         /k+smgNITqozFDcN3VQBWmPmYBbwMyYH2FR7yBWIIfgvsf9WTtMANljAh3mITMtsDM
         9okAQrVDObXXuv3RnHWjt3W/sYMUVgSjdFaWO0qgLyP1DNDEMoQNA1HGGcNjfsNYjl
         HQz5bANbmLgCg4xofTFJyPCVh9x8DU0RHm3HV++HGeD99FPZDj9Nfjvg+B+4az3d4Z
         t12BI4bPjjXIlA3M0fgFWptMgDNXESRPYlizuE5HRA729tAv6TIj1fRfZMqKuKYj4g
         OLniTpyqA30wQ==
Message-ID: <4f52f323-c8eb-bab0-ffa8-2c53c20d35ec@kernel.org>
Date:   Thu, 22 Dec 2022 09:17:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next] ipv6: fix routing cache overflow for raw sockets
To:     Jonathan Maxwell <jmaxwell37@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221218234801.579114-1-jmaxwell37@gmail.com>
 <9f145202ca6a59b48d4430ed26a7ab0fe4c5dfaf.camel@redhat.com>
 <bf56c3aa-85df-734d-f419-835a35e66e03@kernel.org>
 <CAGHK07BehyHXoS+27=cfZoKz4XNTcJjyB5us33sNS7P+_fudHQ@mail.gmail.com>
 <CAGHK07D2Dy4zFGHqwdyg+nsRC_iL4ArWTPk7L2ndA2PaLfOMYQ@mail.gmail.com>
 <CAGHK07DU15NhFvGuLB6WHUF0fffT3MefL3E3JWHmtWR6Wzm0bA@mail.gmail.com>
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAGHK07DU15NhFvGuLB6WHUF0fffT3MefL3E3JWHmtWR6Wzm0bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/22 10:39 PM, Jonathan Maxwell wrote:
> There are some mistakes in this prototype patch. Let me come up with a
> better one. I'll submit a new patch in the new year for review. Thanks for
> the suggestion DavidA.

you are welcome. When you submit the next one, it would be helpful to
show change in memory consumption and a comparison to IPv4 for a similar
raw socket program.
