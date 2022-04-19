Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550B0506E4C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352280AbiDSNkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbiDSNkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:40:35 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A964837AA3;
        Tue, 19 Apr 2022 06:37:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r19so4788278wmq.0;
        Tue, 19 Apr 2022 06:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BKJP+wMrhLiv8U5mTohtsHkHVrvr/Qn6/7wcj0YmhTU=;
        b=KdaXrlnGCGTk+uPwx5slgKSFhnCLkbBPxUSL24gpJtec6AR0NnpchiHu4In5Ly1UsB
         rXLZJ6GUAqjlmTHfVbhaxGzJ+AeoX7RXfjpE19dQYXAfmWCL1NGsKP+9gGeeggoOeocu
         uxLTgHkscj2XdEc3tYKTux1IJx+e3FYvcy0A2oZaL9Vh0WHEd1hp7ed0hxiDrXL3zopH
         SnUnzCXBB9R39gE/VoxX7/G4JHPFA5B6AlHuzOWvG3vTHwBYFAakkcNvfTEKvef+hpby
         hW7L7spMZ+OUvwD/21tsN3aGHitmM87X/weekFDpGcZ9efcpvJYsJvgLJOdweorDjtps
         m79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BKJP+wMrhLiv8U5mTohtsHkHVrvr/Qn6/7wcj0YmhTU=;
        b=t2EapMsfTBGMn0zTzR1lAnzN6gJYx0blij4uUey+Hejmhz48L0h6a2EhdQIwbeN4oP
         lyF5dCCSZetvbNcZNZZYNiMJIXHxVqIWAiwzTIlvCTJwVDqAX1cyXmUAKDvP2SYMX17n
         NgDvW5LzqZhJgBzcLrcLUVlLIfi1lIYL4oFWOaMsquHqRcaOeSequXNCnHfi3A8Su6jv
         AAL1wAabmCJXrYRgDGs7OzP2a5pO5R2sLUsUHcV7k6xJlQldMXysOsn+Iz//ydk/Oogl
         tRwhop3JjXkN+TBRUHBQX+joU0onDbX8DQk+YN2zfBrdqPLt7LyBwxKKEcgZ3TSDiaK3
         3yJQ==
X-Gm-Message-State: AOAM5331WqI5zPzdho2NH2wE/9tHiBVYuugsiYtqzFgRJQTarCqKfoJb
        G/MbewBV96kwIHOPiJhh0+0=
X-Google-Smtp-Source: ABdhPJxDwv1X+/hRo9xop6SusTrN9bqC+b3UgjZEDmS4PvBBI8m7xydBHlVoZ0adElhpenF0fFUI4A==
X-Received: by 2002:a1c:f719:0:b0:381:ba:5247 with SMTP id v25-20020a1cf719000000b0038100ba5247mr16059496wmh.183.1650375469098;
        Tue, 19 Apr 2022 06:37:49 -0700 (PDT)
Received: from [192.168.1.5] ([102.41.109.205])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm17985490wmq.35.2022.04.19.06.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 06:37:48 -0700 (PDT)
Message-ID: <21796697-e4e1-bf51-76fc-bdb0e28d6b60@gmail.com>
Date:   Tue, 19 Apr 2022 15:37:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] intel: igb: igb_ethtool.c: Convert kmap() to
 kmap_local_page()
Content-Language: en-US
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>, outreachy@lists.linux.dev,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220416111457.5868-1-eng.alaamohamedsoliman.am@gmail.com>
 <alpine.DEB.2.22.394.2204161331080.3501@hadrien>
 <df4c0f81-454d-ab96-1d74-1c4fbc3dbd63@gmail.com>
 <Yl3j/bOvoX13WGSW@iweiny-desk3>
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <Yl3j/bOvoX13WGSW@iweiny-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ١٩‏/٤‏/٢٠٢٢ ٠٠:١٩, Ira Weiny wrote:
> On Sat, Apr 16, 2022 at 03:14:57PM +0200, Alaa Mohamed wrote:
>>     On ١٦‏/٤‏/٢٠٢٢ ١٣:٣١, Julia Lawall wrote:
>>
>>
>>   On Sat, 16 Apr 2022, Alaa Mohamed wrote:
>>
>>
>>   Convert kmap() to kmap_local_page()
>>
>>   With kmap_local_page(), the mapping is per thread, CPU local and not
>>   globally visible.
>>
>>   It's not clearer.
>>
>>     I mean this " fix kunmap_local path value to take address of the mapped
>>     page" be more clearer
>>
>>   This is a general statement about the function.  You
>>   need to explain why it is appropriate to use it here.  Unless it is the
>>   case that all calls to kmap should be converted to call kmap_local_page.
>>
>>     It's required to convert all calls kmap to kmap_local_page. So, I don't
>>     what should the commit message be?
>>
>>     Is this will be good :
>>
>>     "kmap_local_page() was recently developed as a replacement for kmap().
>>     The
>>     kmap_local_page() creates a mapping which is restricted to local use by a
>>     single thread of execution. "
>>
> I think I am missing some thread context here.  I'm not sure who said what
> above.  So I'm going to start over.
>
> Alaa,
>
> It is important to remember that a good commit message says 2 things.
>
> 	1) What is the problem you are trying to solve
> 	2) Overview of the solution
>
> First off I understand your frustration.  In my opinion fixes and clean ups
> like this are very hard to write good commit messages for because so often the
> code diff seems so self explanatory.  However, each code change comes at the
> identification of a problem.  And remember that 'problem' does not always mean
> a bug fix.
>
> The deprecation of kmap() may not seem like a problem.  I mean why can't we
> just leave kmap() as it is?  It works right?
>
> But the problem is that the kmap (highmem) interface has become stale and its
> original purpose was targeted toward large memory systems with 32 bit kernels.
> There are very few systems being run like that any longer.
>
> So how do we clean up the kmap interface to be more useful to the kernel
> community now that 32 bit kernels with highmem are so rare?
>
> The community has identified that a first step of that is to move away from and
> eventually remove the kmap() call.  This is due to the call being incorrectly
> used to create long term mappings.  Most calls to kmap() are not used
> incorrectly but those call sites needed something in between kmap() and
> kmap_atmoic().  That call is kmap_local_page().
>
> Now that kmap_local_page() exists the kmap() calls can be audited and most (I
> hope most)[1] can be replaced with kmap_local_page().
>
> The change you have below is correct.  But it lacks a good commit message.  We
> need to cover the 2 points above.
>
> 	1) Julia is asking why you needed to do this change.  What is the
> 	   problem or reason for this change?  (Ira told you to is not a good
> 	   reason.  ;-)
>
> 	   PS In fact me telling you to may actually be a very bad reason...
> 	   j/k ;-)
>
> 	2) Why is this solution ok as part of the deprecation and removal of
> 	   kmap()?
>
> A final note; the 2 above points don't need a lot of text.  Here I used
> 2 simple sentences.
>
> https://lore.kernel.org/lkml/20220124015409.807587-2-ira.weiny@intel.com/
>
> I hope this helps,
> Ira
>
> [1] But not all...  some uses of kmap() have been identified as being pretty
> complex.


Thanks a lot for detailed explaining , yes you help me a lot.


Thanks again,

Alaa

>>   julia
>>
>>
>>   Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>   ---
>>   changes in V2:
>>           fix kunmap_local path value to take address of the mapped page.
>>   ---
>>   changes in V3:
>>           edit commit message to be clearer
>>   ---
>>    drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>
>>   diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>   index 2a5782063f4c..c14fc871dd41 100644
>>   --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>   +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>   @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
>>
>>           frame_size >>= 1;
>>
>>   -       data = kmap(rx_buffer->page);
>>   +       data = kmap_local_page(rx_buffer->page);
>>
>>           if (data[3] != 0xFF ||
>>               data[frame_size + 10] != 0xBE ||
>>               data[frame_size + 12] != 0xAF)
>>                   match = false;
>>
>>   -       kunmap(rx_buffer->page);
>>   +       kunmap_local(data);
>>
>>           return match;
>>    }
>>   --
>>   2.35.2
