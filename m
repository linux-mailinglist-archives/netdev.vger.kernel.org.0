Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7128F5A239C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245369AbiHZIzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245084AbiHZIzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:55:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BA555093
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661504100; x=1693040100;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=4bVaYxE7m7CjkrTijKMpH4y4rqG6cT04uA7Mh4TNN8o=;
  b=ayGuYgvxU8RmnHRoHnHWB9g8eiXTO67BqTD+ffdGfmDaXj1XvKRKAkAK
   siilVTHuIC0OYOX/7mP3/77FBauvv4KA3d+auXp/LqnAU534EvHWuWXBr
   volPmC8a84uWvz8O6zLpr1U4x4BCPsGOrOeryJ8Jp7A2alk96Ls0KvXe+
   GPjzFG9UrVW8LleMbthSjli7Sabq1Lcq0kDggomJpIH6/yvLKM7ZTad4E
   9KTiIlJXC4BQJKKyc3suOx9RYaC/1UohGbjST48O0BwHRPP8MS1Z1ySfI
   cegc/XhliwtRyqg8vlw8qMNIGPxCZXpMmZ7vTF3Z2pCp/C0ItmS1t7L7H
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="277474102"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="277474102"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 01:54:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="678799187"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.215.198.161]) ([10.215.198.161])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 01:54:54 -0700
Message-ID: <474077db-df42-6791-0253-74ca6e0d7b34@linux.intel.com>
Date:   Fri, 26 Aug 2022 14:24:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 command
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, idosch@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, jacob.e.keller@intel.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com,
        chandrashekar.devegowda@intel.com, soumya.prakash.mishra@intel.com,
        linuxwwan@intel.com, hua.yang@mediatek.com
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818194940.30fd725e@kernel.org> <Yv9I4ACEBRoEFM+I@nanopsycho>
 <d2d6f1a3-a9ea-3124-2652-92914172d997@linux.intel.com>
 <YwTGKTUY3Ty9OF02@nanopsycho>
 <eaef51b2-07e1-5931-380c-6a8513f9c7b3@linux.intel.com>
 <YwXliFeA9f/j9Ud9@nanopsycho>
Content-Language: en-US
In-Reply-To: <YwXliFeA9f/j9Ud9@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looped hua.yang@mediatek.com to email.

On 8/24/2022 2:17 PM, Jiri Pirko wrote:
> Tue, Aug 23, 2022 at 06:29:48PM CEST, m.chetan.kumar@linux.intel.com wrote:
>> On 8/23/2022 5:50 PM, Jiri Pirko wrote:
>>> Tue, Aug 23, 2022 at 12:09:06PM CEST, m.chetan.kumar@linux.intel.com wrote:
>>>> On 8/19/2022 1:55 PM, Jiri Pirko wrote:
>>>>> Fri, Aug 19, 2022 at 04:49:40AM CEST, kuba@kernel.org wrote:
>>>>>> On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
>>>>>>> Currently it is up to the driver what versions to expose and what flash
>>>>>>> update component names to accept. This is inconsistent. Thankfully, only
>>>>>>> netdevsim is currently using components, so it is a good time
>>>>>>> to sanitize this.
>>>>>>
>>>>>> Please take a look at recently merged code - 5417197dd516 ("Merge branch
>>>>>> 'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
>>>>>> there so I think you're gonna break them?
>>>>>
>>>>> Ah, crap. Too late :/ They are passing the string to FW (cmd is
>>>>> the component name here):
>>>>> static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
>>>>> {
>>>>>            char flash_command[T7XX_FB_COMMAND_SIZE];
>>>>>
>>>>>            snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
>>>>>            return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
>>>>> }
>>>>>
>>>>> This breaks the pairing with info.versions assumption. Any possibility
>>>>> to revert this and let them redo?
>>>>>
>>>>> Ccing m.chetan.kumar@linux.intel.com, chandrashekar.devegowda@intel.com,
>>>>> soumya.prakash.mishra@intel.com
>>>>>
>>>>> Guys, could you expose one version for component you are flashing? We
>>>>> need 1:1 mapping here.
>>>>
>>>> Thanks for the heads-up.
>>>> I had a look at the patch & my understanding is driver is supposed
>>>> to expose flash update component name & version details via
>>>> devlink_info_version_running_put_ext().
>>>
>>> Yes.
>>>
>>>>
>>>> Is version value a must ? Internally version value is not used for making any
>>>> decision so in case driver/device doesn't support it should be ok to pass
>>>> empty string ?
>>>
>>> No.
>>>
>>>>
>>>> Ex:
>>>> devlink_info_version_running_put_ext(req, "fw", "",
>>>> DEVLINK_INFO_VERSION_TYPE_COMPONENT);
>>>>
>>>> One observation:-
>>>> While testing I noticed "flash_components:" is not getting displayed as
>>>> mentioned in cover note.
>>>
>>> You need iproute2 patch for that which is still in my queue:
>>> https://github.com/jpirko/iproute2_mlxsw/commit/e1d36409362257cc42a435f6695d2058ab7ab683
>>
>> Thanks. After applying this patch "flash_components" details are getting
>> displayed.
>>
>> Another observation is if NULL is passed for version_value there is a crash.
> 
> So don't pass NULL :)
> 
> 
>> Below is the backtrace.
>>
>> 3187.556637] BUG: kernel NULL pointer dereference, address: 0000000000000000
>> [ 3187.556659] #PF: supervisor read access in kernel mode
>> [ 3187.556666] #PF: error_code(0x0000) - not-present page
>> 3187.556791] Call Trace:
>> [ 3187.556796]  <TASK>
>> [ 3187.556801]  ? devlink_info_version_put+0x112/0x1d0
>> [ 3187.556823]  ? __nla_put+0x20/0x30
>> [ 3187.556833]  devlink_info_version_running_put_ext+0x1c/0x30
>> [ 3187.556851]  t7xx_devlink_info_get+0x37/0x40 [mtk_t7xx]
>> [ 3187.556880]  devlink_nl_info_fill.constprop.0+0xa1/0x120
>> [ 3187.556892]  devlink_nl_cmd_info_get_dumpit+0xa8/0x140
>> [ 3187.556901]  netlink_dump+0x1a3/0x340
>> [ 3187.556913]  __netlink_dump_start+0x1d0/0x290
>>
>> Is driver expected to set version number along with component name ?
> 
> Of course.
> 
> 
>>
>> mtk_t7xx WWAN driver is using the devlink interface for flashing the fw to
>> WWAN device. If WWAN device is not capable of supporting the versioning for
>> each component how should we handle ? Please suggest.
> 
> The user should have a visibility about what version is currently
> stored/running in the device. You should expose it.

If the only intention of this component version is to give a visbility 
to user, the WWAN Driver exposes the AT & MBIM control ports. 
Applications like Modem Manager uses AT/MBIM commands to obtain fw 
version info.

So would it be ok to keep component version as an optional for WWAN 
drivers ?

-- 
Chetan
