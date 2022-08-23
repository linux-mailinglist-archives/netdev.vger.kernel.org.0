Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB28F59E445
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbiHWNI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239930AbiHWNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:08:05 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C8A1322C6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661249417; x=1692785417;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+TbYtJBAXfGZg3rIy95CHNlRVLIYrHCdXxpNqLNf9Jk=;
  b=fDfw28QgAiRcd0nJQ5882gTitoe4VuV/rOaw89SjFaMhlacNIjVFbu3t
   lowuI2Y0IJSCZdR8yx4tFBEqS/jIvFMnsXscc7pHQ+Pc3yrVeJD0pA4hw
   DAeCsAChhgrcAOw/pd7uprIQEkBPsJT+zjNVHBIImaHjnLjDODhrklyFM
   zhYAr3GdaBQbLtmbp4s/RyMTrHQ9bdvsiAkge3b8L1pidQhx7jBv2IneW
   V9nwRYXOPBrZ2asEQMv7PUK4cwQdW4Ft0f1SFy26eTtqGl+2QOQWiDgua
   KPo7diRokjtZPdHjA9QZtCxF4VR/8wKfunOFSAI4bmXeFLN8+ZcLomHjL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294436120"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="294436120"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 03:09:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="642389949"
Received: from mckumar-mobl2.gar.corp.intel.com (HELO [10.213.81.81]) ([10.213.81.81])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 03:09:08 -0700
Message-ID: <d2d6f1a3-a9ea-3124-2652-92914172d997@linux.intel.com>
Date:   Tue, 23 Aug 2022 15:39:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [patch net-next 0/4] net: devlink: sync flash and dev info
 command
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com, chandrashekar.devegowda@intel.com,
        soumya.prakash.mishra@intel.com, linuxwwan@intel.com
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818194940.30fd725e@kernel.org> <Yv9I4ACEBRoEFM+I@nanopsycho>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <Yv9I4ACEBRoEFM+I@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/2022 1:55 PM, Jiri Pirko wrote:
> Fri, Aug 19, 2022 at 04:49:40AM CEST, kuba@kernel.org wrote:
>> On Thu, 18 Aug 2022 15:00:38 +0200 Jiri Pirko wrote:
>>> Currently it is up to the driver what versions to expose and what flash
>>> update component names to accept. This is inconsistent. Thankfully, only
>>> netdevsim is currently using components, so it is a good time
>>> to sanitize this.
>>
>> Please take a look at recently merged code - 5417197dd516 ("Merge branch
>> 'wwan-t7xx-fw-flashing-and-coredump-support'"), I don't see any versions
>> there so I think you're gonna break them?
> 
> Ah, crap. Too late :/ They are passing the string to FW (cmd is
> the component name here):
> static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
> {
>          char flash_command[T7XX_FB_COMMAND_SIZE];
> 
>          snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
>          return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
> }
> 
> This breaks the pairing with info.versions assumption. Any possibility
> to revert this and let them redo?
> 
> Ccing m.chetan.kumar@linux.intel.com, chandrashekar.devegowda@intel.com,
> soumya.prakash.mishra@intel.com
> 
> Guys, could you expose one version for component you are flashing? We
> need 1:1 mapping here.

Thanks for the heads-up.
I had a look at the patch & my understanding is driver is supposed
to expose flash update component name & version details via
devlink_info_version_running_put_ext().

Is version value a must ? Internally version value is not used for 
making any decision so in case driver/device doesn't support it should 
be ok to pass empty string ?

Ex:
devlink_info_version_running_put_ext(req, "fw", "",
  DEVLINK_INFO_VERSION_TYPE_COMPONENT);

One observation:-
While testing I noticed "flash_components:" is not getting displayed as 
mentioned in cover note.

Below is the snapshot for mtk_t7xx driver. Am I missing something here ?

# devlink dev info
pci/0000:55:00.0:
driver mtk_t7xx
versions:
        running:
            boot

-- 
Chetan
