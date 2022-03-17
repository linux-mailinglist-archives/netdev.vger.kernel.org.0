Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B8B4DCF69
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiCQUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiCQUgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:36:08 -0400
X-Greylist: delayed 181 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Mar 2022 13:34:50 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844D019533C;
        Thu, 17 Mar 2022 13:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647549104;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=vmB+2SRk3Htme+rG0jB2LuwRdxUS0RVqP+fg2c3MCQI=;
    b=Ik1yp8nrcm+dCrkMzM9Xu8PXK5kVWX4jIjYLpJ6gHiYWExOVGT/ZQRaoDnYXrv8Jml
    M24z/j7zZyyuPmfBgZGIRwcZQHNzQMLbYSJ0J3SyohW2yfK0bTzxAdgzXL89INUosuvE
    VINfV/jKRcSG/DYqjKUvd/vD0J2VjKDKhwhPrrPTbcHPU0gofQwswVz//9lkhlnd7KU4
    /oph4psn/mIIKiQ2SpiA5NKVhGJ2q7DmgI6DJeGfu7231biCTRBgC00l/gJHEgOeo12P
    B5MPHhy6abpf5U6RaBXHKbgU7ZMu58FaQf5z3UHw7X8grcJTHkgoRs4biBliFqGGq9tD
    9Ogg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2HKVi3iV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 17 Mar 2022 21:31:44 +0100 (CET)
Message-ID: <1c0a5946-a67d-ae40-dcba-66cd064b53cf@hartkopp.net>
Date:   Thu, 17 Mar 2022 21:31:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: net-next: regression: patch "iwlwifi: acpi: move ppag code from
 mvm to fw/acpi" (e8e10a37c51c) breaks wifi
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Matt Chen <matt.chen@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
References: <18e04a04-2aed-13de-b2fc-dbf5df864359@hartkopp.net>
 <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <af8ea77765cc30ff448256c278b69b2402f018f6.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On 17.03.22 20:58, Johannes Berg wrote:
> On Thu, 2022-03-17 at 20:56 +0100, Oliver Hartkopp wrote:
>> Hi all,
>>
>> the patch "iwlwifi: acpi: move ppag code from mvm to fw/acpi" (net-next
>> commit e8e10a37c51c) breaks the wifi on my HP Elitebook 840 G5.
>>
>> I detected the problem when working on the latest net-next tree and the
>> wifi was fine until this patch.
>>

Thanks for the fast reply!

> Something like this should get submitted soon:
> https://p.sipsolutions.net/3b84353278ed68c6.txt

I applied this patch on the latest net-next tree:

patching file drivers/net/wireless/intel/iwlwifi/mvm/fw.c
Hunk #1 succeeded at 1015 (offset -114 lines).

And it fixed the wifi issue with my system! \o/

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks & best regards,
Oliver
