Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A34E4807
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiCVVDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiCVVDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:03:41 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391254BC8;
        Tue, 22 Mar 2022 14:02:10 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5ae922.dynamic.kabel-deutschland.de [95.90.233.34])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4387161EA1928;
        Tue, 22 Mar 2022 22:02:07 +0100 (CET)
Message-ID: <68ccb162-459b-cb95-19cf-3e0335e4c981@molgen.mpg.de>
Date:   Tue, 22 Mar 2022 22:02:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Don't do arithmetic on anything smaller than 'int' (was: [PATCH v2]
 ice: use min_t() to make code cleaner in ice_gnss)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        intel-wired-lan@lists.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220321135947.378250-1-wanjiabing@vivo.com>
 <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com>
 <20220322175038.2691665-1-alexandr.lobakin@intel.com>
 <af3fa59809654c9b9939f1e0bd8ca76b@AcuMS.aculab.com>
 <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


Am 22.03.22 um 19:27 schrieb Jakub Kicinski:
> On Tue, 22 Mar 2022 18:12:08 +0000 David Laight wrote:
>>>> Oh FFS why is that u16?
>>>> Don't do arithmetic on anything smaller than 'int'
>>>
>>> Any reasoning? I don't say it's good or bad, just want to hear your
>>> arguments (disasms, perf and object code measurements) etc.
>>
>> Look at the object code on anything except x86.
>> The compiler has to add instruction to mask the value
>> (which is in a full sized register) down to 16 bits
>> after every arithmetic operation.
> 
> Isn't it also slower on some modern x86 CPUs?
> I could have sworn someone mentioned that in the past.

I know of Scott’s article *Small Integers: Big Penalty* from 2012 [1].


Kind regards,

Paul


[1]: https://notabs.org/coding/smallIntsBigPenalty.htm
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
