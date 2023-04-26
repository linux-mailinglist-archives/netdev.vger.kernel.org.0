Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF7A6EEB89
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 02:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbjDZAmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 20:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjDZAmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 20:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED16AF22
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 17:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD2362E3B
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 00:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523FDC433D2;
        Wed, 26 Apr 2023 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682469732;
        bh=CPNVA3FH9DGh7I+5aVr2P0I5quFJ4wC4GLXyO0CBLEI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Xf9ygwaTJ8HLAaTM6HhQkbuDdvT10c/B0t8Yj9DZrw1SBXJbEBFEKLNN8L3sHWI69
         chJlLsGB94Lccy1MM7yOsroJV9BK4FXzWttL/zR9zwN3e9fNQpGCXm8UqWpDO0aFum
         6N0HkspIrn6dvuOOsoMy0LxLEDCsMhdaeG05XLQn4biCuzAgYK7hVFEtiWkgydkhZO
         vKyTS/7hKOTItbodNelC2JibgCTMqstARkj+T3hRt6aUFGqnwA4CmhUXQx5mT32Cm2
         1IC4FslkK5aN2bzjEHpjkJMd8nRcvmgOweiUqgnRNsJye3dNZEgnKWhIfXZt7PGxms
         U368tfghiKKQg==
Message-ID: <28816788-3499-adca-b792-a5eafa2e2b14@kernel.org>
Date:   Tue, 25 Apr 2023 18:42:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio
 support for preemptible traffic classes
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
 <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
 <20230422165945.7df2xbpeg3llgt7x@skbuf>
 <5575810d-ceee-7b7b-fba4-e14e5ca6e412@kernel.org>
 <20230425125511.qro3vql5aivxnxlh@skbuf>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230425125511.qro3vql5aivxnxlh@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/23 6:55 AM, Vladimir Oltean wrote:
> On Mon, Apr 24, 2023 at 07:47:31PM -0600, David Ahern wrote:
>> On 4/22/23 10:59 AM, Vladimir Oltean wrote:
>>> Unless there are changes I need to make to the contents of the patches,
>>> could you take these from the lists, or is that a no-no?
>>
>> iproute2 follows the netdev dev model with a main tree for bug fixes and
>> -next tree for features. In the future please separate out the patches
>> and send with proper targets. If a merge is needed you can state that in
>> the cover letter of the set for -next.
> 
> I know that the trees are split and it is no coincidence that my patches
> were sorted in the correct order. I've been working for 10 months on
> this small feature and I was impatient to get it over with, so I wanted
> to eliminate one round-trip time if possible (send to "iproute2", ask
> for merge, send to "iproute2-next"). I requested this honestly thinking
> that there would be no difference to the end result, only less pretentious
> in terms of the process. If there is any automation (I didn't see any in
> Patchwork at least) or any other reason that would justify the more
> pretentious process, then again, my excuses, I plead ignorance and I
> will follow it more strictly next time, but I'd also like to know it :)

Maybe the word choice here is a language issue, but it is not a
'pretentious' process, it is "the" process for submitting patches to
both networking trees and iproute2 trees. You would not send a mixed
patch set to the netdev maintainers, so don't do it for iproute2.
