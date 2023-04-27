Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40BF6EFED0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 03:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbjD0BPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 21:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbjD0BPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 21:15:20 -0400
Received: from mail-m11876.qiye.163.com (mail-m11876.qiye.163.com [115.236.118.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A1A19AE;
        Wed, 26 Apr 2023 18:15:18 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11876.qiye.163.com (Hmail) with ESMTPA id 2526A3C00F0;
        Thu, 27 Apr 2023 09:15:01 +0800 (CST)
Message-ID: <650acda0-9ec9-7634-3e01-e4870c8890b7@sangfor.com.cn>
Date:   Thu, 27 Apr 2023 09:14:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2 1/2] iavf: Fix use-after-free in free_netdev
Content-Language: en-US
To:     Michal Kubiak <michal.kubiak@intel.com>, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, keescook@chromium.org,
        grzegorzx.szczurek@intel.com, mateusz.palczewski@intel.com,
        mitch.a.williams@intel.com, gregory.v.rose@intel.com,
        jeffrey.t.kirsher@intel.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230419150709.24810-1-dinghui@sangfor.com.cn>
 <20230419150709.24810-2-dinghui@sangfor.com.cn>
 <ZElExd5bAL2FCpIB@localhost.localdomain>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZElExd5bAL2FCpIB@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZQ0lKVhofHU5LThhPGR0fTlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a87c0474c3d2eb2kusn2526a3c00f0
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRw6Ihw4Cj0TT0oBIyo3Eyw8
        HTcaCk5VSlVKTUNJTk5DSkpKTEpNVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFISEJINwY+
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/26 23:35, Michal Kubiak wrote:
> On Wed, Apr 19, 2023 at 11:07:08PM +0800, Ding Hui wrote:
>> Cc: Huang Cun <huangcun@sangfor.com.cn>
>> Acked-by: Michal Kubiak <michal.kubiak@intel.com>
> 
> I'm sorry, but I don't remember giving "Acked-by" tag for that patch.
> I gave "Reviewed-by" only for the v2 series.
> 

Sorry, that is added by myself since your reply for v1 "Looks OK to me"
and "Looks correct to me", and I tried to ask for your agreement.

> We can't add any tags if they weren't given by the person himself.

I apologize to you.

> Please fix that.

Hi Tony Nguyen,
the patches is already applied to your dev-queue branch, should I send
v3 or you can fix it in your git?

> Nacked-by: Michal Kubiak <michal.kubiak@intel.com>
> 
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> ---
>> v1 to v2:
>>    - add Fixes: tag
>>    - add reproduction script
>>    - update commit message
>>
>> ---
>>   drivers/net/ethernet/intel/iavf/iavf_main.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> -- 
>> 2.17.1
>>
> 

-- 
Thanks,
- Ding Hui

