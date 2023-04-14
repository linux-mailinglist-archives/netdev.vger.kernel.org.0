Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0CC6E2C38
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjDNWBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjDNWBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF9D46A6
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE06C64A8A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BFFC4339B;
        Fri, 14 Apr 2023 22:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681509704;
        bh=X5lZc7G5j7eCYUHAjQJg1pjKJAsEhJF9kZhPc0ywe/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7yTJ3w0e9mAe48x1Qk+uVLvHEQQ6zVjr5Pt8gUbVdHaSrceCfXMaYLu/crnTCY3z
         c+LckeUX+tEtT2V1odaiEihtD6PZ8M9cLzysekcC6uan/wkK+diRJ3wHPWetUNcDX1
         rCqkx8ymxTISU/tKEI7gpkwdV9NXzuLrRszlQeqAFbeokzH13pl+jppxAcnseJluwj
         j29+TvS78VjjLw4UFS5IGVVtvQG2vlM5ZhIf3Q++l4hfnkH2K2tvV8YpE+zcAqsdX2
         HjgHEVfmfPLc4AVLesiNfQWTAqsqrquwBBY/fw28Z4f2VnYzrihedEfCCxLdGTQ8ZJ
         R27S7KVI+dryA==
Date:   Fri, 14 Apr 2023 18:01:42 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, decot@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Message-ID: <ZDnNRs6sWb45e4F6@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <ZDb3rBo8iOlTzKRd@sashalap>
 <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
 <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
 <20230412192434.53d55c20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230412192434.53d55c20@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 07:24:34PM -0700, Jakub Kicinski wrote:
>On Wed, 12 Apr 2023 19:03:22 -0500 Samudrala, Sridhar wrote:
>> On 4/12/2023 2:16 PM, Willem de Bruijn wrote:
>> > Sasha Levin wrote:
>> >> On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:
>> >> How will this work when the OASIS driver is ready down the road?
>> >>
>> >> We'll end up with two "idpf" drivers, where one will work with hardware
>> >> that is not fully spec compliant using this Intel driver, and everything
>> >> else will use the OASIS driver?
>> >>
>> >> Does Intel plan to remove this driver when the OASIS one lands?
>> >>
>> >> At the very least, having two "idpf" drivers will be very confusing.
>> >
>> > One approach is that when the OASIS v1 spec is published, this driver
>> > is updated to match that and moved out of the intel directory.
>>
>> Yes. We don't want to have 2 idpf drivers in the upstream kernel.
>> It will be an Intel vendor driver until it becomes a standard.
>> Hope it will be OK to move the driver out of the intel directory when
>> that happens.
>
>As I said previously in [0] until there is a compatible, widely
>available implementation from a second vendor - this is an Intel
>driver and nothing more. It's not moving anywhere.

My concern isn't around the OASIS legal stuff, it's about the users who
end up using this and will end up getting confused when we have two (or
more) in-kernel "IDPF" drivers.

I don't think that moving is an option - it'll brake distros and upset
users: we can't rename drivers as we go because it has a good chance of
breaking users.

>I think that's a reasonable position which should allow Intel to ship
>your code and me to remain professional.

No concerns about OASIS or the current code, I just don't want to make
this a mess for the users.

-- 
Thanks,
Sasha
