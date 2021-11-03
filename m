Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF5A44494E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhKCUEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:04:34 -0400
Received: from mout-p-102.mailbox.org ([80.241.56.152]:35478 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhKCUEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:04:33 -0400
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HkyN33xfPzQjf7;
        Wed,  3 Nov 2021 21:01:55 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <4a83c5d9-e501-e32b-f1da-ee60c6917b28@v0yd.nl>
Date:   Wed, 3 Nov 2021 21:01:49 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] mwifiex: Use a define for firmware version string
 length
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211103171055.16911-1-verdre@v0yd.nl>
 <20211103171055.16911-2-verdre@v0yd.nl> <YYLGsPhKZe4A0XFr@google.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
In-Reply-To: <YYLGsPhKZe4A0XFr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 461B81315
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 18:28, Brian Norris wrote:
> On Wed, Nov 03, 2021 at 06:10:54PM +0100, Jonas Dreßler wrote:
>> Since the version string we get from the firmware is always 128
>> characters long, use a define for this size instead of having the number
>> 128 copied all over the place.
>>
>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> 
> Thanks for this patch. For the series:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
>> ---
>>   drivers/net/wireless/marvell/mwifiex/fw.h          | 4 +++-
>>   drivers/net/wireless/marvell/mwifiex/main.h        | 2 +-
>>   drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 5 +++--
>>   3 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
>> index 2ff23ab259ab..63c25c69ed2b 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
>> @@ -2071,9 +2071,11 @@ struct mwifiex_ie_types_robust_coex {
>>   	__le32 mode;
>>   } __packed;
>>   
>> +#define MWIFIEX_VERSION_STR_LENGTH  128
>> +
>>   struct host_cmd_ds_version_ext {
>>   	u8 version_str_sel;
>> -	char version_str[128];
>> +	char version_str[MWIFIEX_VERSION_STR_LENGTH];
>>   } __packed;
>>   
>>   struct host_cmd_ds_mgmt_frame_reg {
>> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
>> index 90012cbcfd15..65609ea2327e 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/main.h
>> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
>> @@ -646,7 +646,7 @@ struct mwifiex_private {
>>   	struct wireless_dev wdev;
>>   	struct mwifiex_chan_freq_power cfp;
>>   	u32 versionstrsel;
>> -	char version_str[128];
>> +	char version_str[MWIFIEX_VERSION_STR_LENGTH];
>>   #ifdef CONFIG_DEBUG_FS
>>   	struct dentry *dfs_dev_dir;
>>   #endif
>> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>> index 6b5d35d9e69f..20b69a37f9e1 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>> @@ -711,8 +711,9 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
>>   	if (version_ext) {
>>   		version_ext->version_str_sel = ver_ext->version_str_sel;
>>   		memcpy(version_ext->version_str, ver_ext->version_str,
>> -		       sizeof(char) * 128);
>> -		memcpy(priv->version_str, ver_ext->version_str, 128);
>> +		       MWIFIEX_VERSION_STR_LENGTH);
>> +		memcpy(priv->version_str, ver_ext->version_str,
>> +		       MWIFIEX_VERSION_STR_LENGTH);
> 
> Not related to your patch, but this highlights that nobody is ensuring
> this string is 0-terminated, and various other places (notably, *not*
> your patch 2!) assume that it is.
> 
> We should either fix those to use an snprintf()/length-restricted
> variant, or else just force:
> 
> 		priv->version_str[MWIFIEX_VERSION_STR_LENGTH - 1] = '\0';
> 
> here.

Indeed, right now we just trust the firmware to make sure that's the case.

Let me add another patch appending the '\0' to priv->version_str...

> 
> But that's a separate issue/patch. I can cook one on top of your series
> when it gets merged if you don't want to.
> 
> Brian
> 
>>   	}
>>   	return 0;
>>   }
>> -- 
>> 2.33.1
>>

