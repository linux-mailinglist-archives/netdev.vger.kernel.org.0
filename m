Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF6558A093
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiHDSgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiHDSgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:36:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACA1165B3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:36:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5773AB826F3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A22C433C1;
        Thu,  4 Aug 2022 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659638197;
        bh=zrrILRqNecxqrrGtxQqxff5cWO/LBBLqFh9pjOy9oo4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NawcVmAOe0SLN4/wKqt5T9NpZJj/fS6kDTgnV2hi5Uyn+fR6d5hKD7eeDg/ucccMq
         UEkoUt+O0nHmdwfowubrSACqO2WpG+8En3C6sgxXT3VZMH2Rpc0XT2NiWdpeS6LWtC
         ndfhI/5NQ7j54g2xuyMsMOCo0zQI4CY0GV57L+nyn7+UjfdlMs0WyoquUozYSNBdMd
         BfGuYwd+fwq7AASh7YYvu0d34jbJuSodyFSZJvqW3JuOb6pUe1JUCybzp289Ilqil2
         hHNwIQJRQOH+Z5ZACMEC/FZNcVPAf3evcsWnyHqfNhoGWHX6SM3Bg6FJBpZ9xYC+2z
         wq8UlVe7M/Shg==
Message-ID: <5798fe5b-8424-c650-aac0-5293e1d907b4@kernel.org>
Date:   Thu, 4 Aug 2022 12:36:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH main v2 2/3] macsec: add Extended Packet Number support
Content-Language: en-US
To:     Sabrina Dubroca <sd@queasysnail.net>, ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, tariqt@nvidia.com
References: <20220802061813.24082-1-ehakim@nvidia.com>
 <20220802061813.24082-2-ehakim@nvidia.com> <Yuv4RXYlYE6LM2d5@hog>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <Yuv4RXYlYE6LM2d5@hog>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/22 10:48 AM, Sabrina Dubroca wrote:
> Hi Emeel,
> 
> 2022-08-02, 09:18:12 +0300, ehakim@nvidia.com wrote:
>> diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
>> index eee31cec..6edfea0a 100644
>> --- a/include/uapi/linux/if_macsec.h
>> +++ b/include/uapi/linux/if_macsec.h
>> @@ -22,6 +22,8 @@
>>  
>>  #define MACSEC_KEYID_LEN 16
>>  
>> +#define MACSEC_SALT_LEN 12
> 
> That's not in the kernel's uapi file (probably was forgotten), I
> don't think we can just add it here.
> 

can't. uapi files are synched with kernel releases, so that change would
disappear on the next sync.

