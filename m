Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7235E87E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbhDMVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:46:29 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.95]:45655 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346785AbhDMVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:46:28 -0400
X-Greylist: delayed 1226 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 17:46:28 EDT
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 7738A400D3204
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 16:25:41 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id WQXVlludtL7DmWQXVlzgJn; Tue, 13 Apr 2021 16:25:41 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BeO8GkAjgrMdjfp0UoCjCPgX7wT/SJDYDrx5yHmB4jM=; b=GURnayccnGmttggv8tWi7/B6eW
        cqI+AksMy4q8I8vZQHVTFoVIWyJEa0g5sakcJY1HlLOjz/5dEGBnzbGWe6J4NaE5WslpTIU3y2sui
        7IKI/0vWhjrn2tmd3QLPxAIMcyRLklDUg/FBgidzssAYZrLQqKWzCIMQj/m9r1o04lWM1DF1UWc4c
        /XwX2HMYIxHi9T2EjU4ak73eT4nF2ozmT7Qe6yO5D5G/cs1DlLKy5m+rrl7GDulOIWca0QlFJmp4B
        +FSMOTZ6rVqhkVVA92rPLCEwGgnhgrQTDfeJ1jnRgQ5iwXuijapm1BG4Lmxi5gc/IQfoT3tarC5jU
        6kT0+1Pw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:50198 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lWQXS-003IaF-0m; Tue, 13 Apr 2021 16:25:38 -0500
Subject: Re: [PATCH v2 2/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_mgmt_join
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <cover.1617226663.git.gustavoars@kernel.org>
 <83b0388403a61c01fad8d638db40b4245666ff53.1617226664.git.gustavoars@kernel.org>
 <202104071158.B4FA1956@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <2bc27d10-efa2-3ab7-fb58-556cfd252927@embeddedor.com>
Date:   Tue, 13 Apr 2021 16:25:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <202104071158.B4FA1956@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lWQXS-003IaF-0m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:50198
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

On 4/7/21 14:02, Kees Cook wrote:
> On Wed, Mar 31, 2021 at 04:45:34PM -0500, Gustavo A. R. Silva wrote:
>> Fix the following out-of-bounds warning by enclosing
>> some structure members into new struct req:
>>
>> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [39, 108] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 36 [-Warray-bounds]
>>
>> Refactor the code, accordingly:
>>
>> $ pahole -C wl3501_join_req drivers/net/wireless/wl3501_cs.o
>> struct wl3501_join_req {
>> 	u16                        next_blk;             /*     0     2 */
>> 	u8                         sig_id;               /*     2     1 */
>> 	u8                         reserved;             /*     3     1 */
>> 	struct iw_mgmt_data_rset   operational_rset;     /*     4    10 */
>> 	u16                        reserved2;            /*    14     2 */
>> 	u16                        timeout;              /*    16     2 */
>> 	u16                        probe_delay;          /*    18     2 */
>> 	u8                         timestamp[8];         /*    20     8 */
>> 	u8                         local_time[8];        /*    28     8 */
>> 	struct {
>> 		u16                beacon_period;        /*    36     2 */
>> 		u16                dtim_period;          /*    38     2 */
>> 		u16                cap_info;             /*    40     2 */
>> 		u8                 bss_type;             /*    42     1 */
>> 		u8                 bssid[6];             /*    43     6 */
>> 		struct iw_mgmt_essid_pset ssid;          /*    49    34 */
>> 		/* --- cacheline 1 boundary (64 bytes) was 19 bytes ago --- */
>> 		struct iw_mgmt_ds_pset ds_pset;          /*    83     3 */
>> 		struct iw_mgmt_cf_pset cf_pset;          /*    86     8 */
>> 		struct iw_mgmt_ibss_pset ibss_pset;      /*    94     4 */
>> 		struct iw_mgmt_data_rset bss_basic_rset; /*    98    10 */
>> 	} req;                                           /*    36    72 */
> 
> This section is the same as a large portion of struct wl3501_scan_confirm:
> 
> struct wl3501_scan_confirm {
>         u16                         next_blk;
>         u8                          sig_id;
>         u8                          reserved;
>         u16                         status;
>         char                        timestamp[8];
>         char                        localtime[8];
> 
> from here
>         u16                         beacon_period;
>         u16                         dtim_period;
>         u16                         cap_info;
>         u8                          bss_type;
>         u8                          bssid[ETH_ALEN];
>         struct iw_mgmt_essid_pset   ssid;
>         struct iw_mgmt_ds_pset      ds_pset;
>         struct iw_mgmt_cf_pset      cf_pset;
>         struct iw_mgmt_ibss_pset    ibss_pset;
>         struct iw_mgmt_data_rset    bss_basic_rset;
> through here
> 
>         u8                          rssi;
> };
> 
> It seems like maybe extracting that and using it in both structures
> would make more sense?

If I do this, I would therefore have to make a bunch of other changes,
accordingly. I'm OK with that but I'd like to have the opinion of the
maintainers on all this. So, I will go and ping them from the cover
letter of this series with the hope that we can get some feedback from
them. :) They have been silent for a couple of weeks now.

> 
>>
>> 	/* size: 108, cachelines: 2, members: 10 */
>> 	/* last cacheline: 44 bytes */
>> };
>>
>> The problem is that the original code is trying to copy data into a
>> bunch of struct members adjacent to each other in a single call to
>> memcpy(). Now that a new struct _req_ enclosing all those adjacent
>> members is introduced, memcpy() doesn't overrun the length of
>> &sig.beacon_period, because the address of the new struct object
>> _req_ is used as the destination, instead.
>>
>> Also, this helps with the ongoing efforts to enable -Warray-bounds and
>> avoid confusing the compiler.
>>
>> Link: https://github.com/KSPP/linux/issues/109
>> Reported-by: kernel test robot <lkp@intel.com>
>> Build-tested-by: kernel test robot <lkp@intel.com>
>> Link: https://lore.kernel.org/lkml/60641d9b.2eNLedOGSdcSoAV2%25lkp@intel.com/
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>> Changes in v2:
>>  - None.
>>
>>  drivers/net/wireless/wl3501.h    | 22 ++++++++++++----------
>>  drivers/net/wireless/wl3501_cs.c |  4 ++--
>>  2 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
>> index ef9d605d8c88..774d8cac046d 100644
>> --- a/drivers/net/wireless/wl3501.h
>> +++ b/drivers/net/wireless/wl3501.h
>> @@ -389,16 +389,18 @@ struct wl3501_join_req {
>>  	u16			    probe_delay;
>>  	u8			    timestamp[8];
>>  	u8			    local_time[8];
>> -	u16			    beacon_period;
>> -	u16			    dtim_period;
>> -	u16			    cap_info;
>> -	u8			    bss_type;
>> -	u8			    bssid[ETH_ALEN];
>> -	struct iw_mgmt_essid_pset   ssid;
>> -	struct iw_mgmt_ds_pset	    ds_pset;
>> -	struct iw_mgmt_cf_pset	    cf_pset;
>> -	struct iw_mgmt_ibss_pset    ibss_pset;
>> -	struct iw_mgmt_data_rset    bss_basic_rset;
>> +	struct {
>> +		u16			    beacon_period;
>> +		u16			    dtim_period;
>> +		u16			    cap_info;
>> +		u8			    bss_type;
>> +		u8			    bssid[ETH_ALEN];
>> +		struct iw_mgmt_essid_pset   ssid;
>> +		struct iw_mgmt_ds_pset	    ds_pset;
>> +		struct iw_mgmt_cf_pset	    cf_pset;
>> +		struct iw_mgmt_ibss_pset    ibss_pset;
>> +		struct iw_mgmt_data_rset    bss_basic_rset;
>> +	} req;
>>  };
>>  
>>  struct wl3501_join_confirm {
>> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
>> index e149ef81d6cc..399d3bd2ae76 100644
>> --- a/drivers/net/wireless/wl3501_cs.c
>> +++ b/drivers/net/wireless/wl3501_cs.c
>> @@ -590,7 +590,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
>>  	struct wl3501_join_req sig = {
>>  		.sig_id		  = WL3501_SIG_JOIN_REQ,
>>  		.timeout	  = 10,
>> -		.ds_pset = {
>> +		.req.ds_pset = {
>>  			.el = {
>>  				.id  = IW_MGMT_INFO_ELEMENT_DS_PARAMETER_SET,
>>  				.len = 1,
>> @@ -599,7 +599,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
>>  		},
>>  	};
>>  
>> -	memcpy(&sig.beacon_period, &this->bss_set[stas].beacon_period, 72);
>> +	memcpy(&sig.req, &this->bss_set[stas].beacon_period, sizeof(sig.req));
> 
> If not, then probably something like this should be added to make sure
> nothing unexpected happens to change structure sizes:
> 
> BUILD_BUG_ON(sizeof(sig.req) != 72);

Yep, this is sensible.

Thanks for the feedback!
--
Gustavo

> 
>>  	return wl3501_esbq_exec(this, &sig, sizeof(sig));
>>  }
>>  
>> -- 
>> 2.27.0
>>
> 
