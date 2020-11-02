Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B602A2B2F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgKBNFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgKBNFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:05:14 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8629C0617A6;
        Mon,  2 Nov 2020 05:05:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y14so11045554pfp.13;
        Mon, 02 Nov 2020 05:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XGxtWj7ejGQxivNAFwQZq0uLE5gMKA6WBbBt3+hvmBo=;
        b=rUHG1CLITmXgRBq2bRWi/WVnc/DCyzizg7zcPnbbAANp9kK8hXkmPqKRAvVwpRAP7e
         R3yn0xI2EBeZYWTbPtWUfHAx3L+mNny+eJ7ccCX37gz9luVfLaokanX0jiTeseS5JXsp
         e1BoMTqxSeRg+T/bMF84luANDe6COWw6O8by1cAtCtJMs7dm3HfYBPVCQBHo65GJEflZ
         R7AG22eZeBUAR7LgaL1bZKWavJZ5HTlHxox6vec1Qz+9lUzyFUCishhKAs4u2HSCtVUj
         fbEw1oEBGjig1C313vRSsB2beui37YWDHewmzWYMy4mGAO1ud45+FngaSqygbm6QyN9O
         vnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XGxtWj7ejGQxivNAFwQZq0uLE5gMKA6WBbBt3+hvmBo=;
        b=OwlXVQhfjlifpiolG7sZdy0xiRSdwBjhyXSLmQ9QXviTAUg9iDpmtglLBbPPWVD/Z2
         cHYrEC9YG9IreQlYpaelhWVcTbI/NXr8IUhHDknDZDvuXFVEeU3JXBjq0bsSrNt7q4TK
         UO/j009DLyb0wMkwr7FNFGhfwZ1UNvhBV0LAMB2SY2bUoNlaMdjAWyp+KRZJLaff5UFy
         EwQSADKRPhV1y2eFhZbLn3vpyvfpNBSITslHNLxTKsLeElQU26prSxU1I5U8SX/MjxyJ
         DRQ6s73yCV7/PkVpDZ8QLDMQI5UDw+WW6Ck7WACkfvnweKpOjUsYSwPst4Pv/CM790mr
         YP4A==
X-Gm-Message-State: AOAM533R9iRtwTifAeh2q53Jc6uAcIpvL6IWBEv9cjbUX+Pa6DUmOMHo
        ZWxpAvSTX9wq3jyUd+gTJqNog86KYLoZdQ==
X-Google-Smtp-Source: ABdhPJxUJaZC2sVE0KOMXuPmzOHPcp8amXdCG9xKTD156SC+EmHcgvNUczVtfCBwv+bdGgaXmttLFw==
X-Received: by 2002:a17:90a:de8f:: with SMTP id n15mr17781187pjv.9.1604322313305;
        Mon, 02 Nov 2020 05:05:13 -0800 (PST)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g4sm3083064pgu.81.2020.11.02.05.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:05:12 -0800 (PST)
Message-ID: <995d9925f460c1a540e11838e05c30a7f6ac0046.camel@gmail.com>
Subject: Re: [RFC PATCH] mwifiex: pcie: use shutdown_sw()/reinit_sw() on
 suspend/resume
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl
Date:   Mon, 02 Nov 2020 22:05:07 +0900
In-Reply-To: <8c56efa5420eb4211b1af789ef63931d3504d8e1.camel@gmail.com>
References: <20201028142719.18765-1-kitakar@gmail.com>
         <8c56efa5420eb4211b1af789ef63931d3504d8e1.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-31 at 00:27 +0900, Tsuchiya Yuto wrote:
> On Wed, 2020-10-28 at 23:27 +0900, Tsuchiya Yuto wrote:
>> On Microsoft Surface devices (PCIe-88W8897), there are issues with S0ix
>> achievement and AP scanning after suspend with the current Host Sleep
>> method.
>>
>> When using the Host Sleep method, it prevents the platform to reach S0ix
>> during suspend. Also, sometimes AP scanning won't work, resulting in
>> non-working wifi after suspend.
>>
>> To fix such issues, perform shutdown_sw()/reinit_sw() instead of Host
>> Sleep on suspend/resume.
>>
>> Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
>> ---
>> As a side effect, this patch disables wakeups (means that Wake-On-WLAN
>> can't be used anymore, if it was working before), and might also reset
>> some internal states.
>>
>> Of course it's the best to rather fix Host Sleep itself. But if it's
>> difficult, I'm afraid we have to go this way.
>>
>> I reused the contents of suspend()/resume() functions as much as possible,
>> and removed only the parts that are incompatible or redundant with
>> shutdown_sw()/reinit_sw().
>>
>> - Removed wait_for_completion() as redundant
>>   mwifiex_shutdown_sw() does this.
>> - Removed flush_workqueue() as incompatible
>>   Causes kernel crashing.
>> - Removed mwifiex_enable_wake()/mwifiex_disable_wake()
>>   as incompatible and redundant because the driver will be shut down
>>   instead of entering Host Sleep.
>>
>> I'm worried about why flush_workqueue() causes kernel crash with this
>> suspend method. Is it OK to just drop it? At least We Microsoft Surface
>> devices users used this method for about one month and haven't observed
>> any issues.
>>
>> Note that suspend() no longer checks if it's already suspended.
>> With the previous Host Sleep method, the check was done by looking at
>> adapter->hs_activated in mwifiex_enable_hs() [sta_ioctl.c], but not
>> MWIFIEX_IS_SUSPENDED. So, what the previous method checked was instead
>> Host Sleep state, not suspend itself.
>>
>> Therefore, there is no need to check the suspend state now.
>> Also removed comment for suspend state check at top of suspend()
>> accordingly.
>
> This patch depends on the following mwifiex_shutdown_sw() fix I sent
> separately.
>
> [PATCH 1/2] mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
> https://lore.kernel.org/linux-wireless/20201028142110.18144-2-kitakar@gmail.com/

The AP scanning issue with Host Sleep is now difficult to reproduce on
v5.10-rc2. It might be already gone but not yet so sure.

Here are the details about AP scanning issue with Host Sleep for the
record (as of Apr 2020):

When using Host Sleep on suspend, after resuming from suspend, it
(sometimes) can't connect to APs because it fails to scan APs. When
I set debug_mask to 0xffffffff, I noticed that scanning is being blocked
with this message:

    kern  :info  : [99952.621609] mwifiex_pcie 0000:03:00.0: info: received scan request on mlan0
    kern  :info  : [99952.621613] mwifiex_pcie 0000:03:00.0: cmd: Scan already in process..

What is worse, when this issue happened, the subsequent suspend
(sometimes) fails with the following message:

    kern  :info  : [101844.423427] mwifiex_pcie 0000:03:00.0: hs_activate_wait_q terminated
    kern  :info  : [101844.423433] mwifiex_pcie 0000:03:00.0: cmd: failed to suspend
    kern  :err   : [101844.423446] PM: pci_pm_suspend(): mwifiex_pcie_suspend+0x0/0xd0 [mwifiex_pcie] returns -14
    kern  :err   : [101844.423453] PM: dpm_run_callback(): pci_pm_suspend+0x0/0x160 returns -14
    kern  :err   : [101844.423466] PM: Device 0000:03:00.0 failed to suspend async: error -14
    kern  :debug : [101844.423525] PM: suspend of devices aborted after 10064.914 msecs
    kern  :debug : [101844.423529] PM: start suspend of devices aborted after 10065.318 msecs
    kern  :err   : [101844.423531] PM: Some devices failed to suspend, or early wake event detected

The message is from the following code in mwifiex_cfg80211_scan()
[cfg80211.c].

    /* Block scan request if scan operation or scan cleanup when interface
     * is disabled is in process
     */
    if (priv->scan_request || priv->scan_aborting) {
    	mwifiex_dbg(priv->adapter, WARN,
    		    "cmd: Scan already in process..\n");
    	return -EBUSY;
    }

Further print debugging showed that scan_request was not true but
scan_aborting was true. And the scan_aborting was set by mwifiex_close()
[main.c].

Regarding the S0ix achievement, I don't have any idea how I can fix it
with the Host Sleep method. So, I sent this patch. Any suggestions for
fixing it with Host Sleep are welcome.

If I understand correctly, the mwifiex card is in fully working state
in terms of PCIe. This prevents the platform from going into S0ix state?

>>  drivers/net/wireless/marvell/mwifiex/pcie.c | 29 +++++++--------------
>>  1 file changed, 10 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> index 6a10ff0377a24..3b5c614def2f5 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -293,8 +293,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
>>   * registered functions must have drivers with suspend and resume
>>   * methods. Failing that the kernel simply removes the whole card.
>>   *
>> - * If already not suspended, this function allocates and sends a host
>> - * sleep activate request to the firmware and turns off the traffic.
>> + * This function shuts down the adapter.
>>   */
>>  static int mwifiex_pcie_suspend(struct device *dev)
>>  {
>> @@ -302,31 +301,21 @@ static int mwifiex_pcie_suspend(struct device *dev)
>>  	struct pcie_service_card *card = dev_get_drvdata(dev);
>>  
>>  
>> -	/* Might still be loading firmware */
>> -	wait_for_completion(&card->fw_done);
>> -
>>  	adapter = card->adapter;
>>  	if (!adapter) {
>>  		dev_err(dev, "adapter is not valid\n");
>>  		return 0;
>>  	}
>>  
>> -	mwifiex_enable_wake(adapter);
>> -
>> -	/* Enable the Host Sleep */
>> -	if (!mwifiex_enable_hs(adapter)) {
>> +	/* Shut down SW */
>> +	if (mwifiex_shutdown_sw(adapter)) {
>>  		mwifiex_dbg(adapter, ERROR,
>>  			    "cmd: failed to suspend\n");
>> -		clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
>> -		mwifiex_disable_wake(adapter);
>>  		return -EFAULT;
>>  	}
>>  
>> -	flush_workqueue(adapter->workqueue);
>> -
>>  	/* Indicate device suspended */
>>  	set_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
>> -	clear_bit(MWIFIEX_IS_HS_ENABLING, &adapter->work_flags);
>>  
>>  	return 0;
>>  }
>> @@ -336,13 +325,13 @@ static int mwifiex_pcie_suspend(struct device *dev)
>>   * registered functions must have drivers with suspend and resume
>>   * methods. Failing that the kernel simply removes the whole card.
>>   *
>> - * If already not resumed, this function turns on the traffic and
>> - * sends a host sleep cancel request to the firmware.
>> + * If already not resumed, this function reinits the adapter.
>>   */
>>  static int mwifiex_pcie_resume(struct device *dev)
>>  {
>>  	struct mwifiex_adapter *adapter;
>>  	struct pcie_service_card *card = dev_get_drvdata(dev);
>> +	int ret;
>>  
>>  
>>  	if (!card->adapter) {
>> @@ -360,9 +349,11 @@ static int mwifiex_pcie_resume(struct device *dev)
>>  
>>  	clear_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags);
>>  
>> -	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
>> -			  MWIFIEX_ASYNC_CMD);
>> -	mwifiex_disable_wake(adapter);
>> +	ret = mwifiex_reinit_sw(adapter);
>> +	if (ret)
>> +		dev_err(dev, "reinit failed: %d\n", ret);
>> +	else
>> +		mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
>>  
>>  	return 0;
>>  }
>
>


