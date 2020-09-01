Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86402584E6
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgIAAhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIAAhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 20:37:53 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92132C061573;
        Mon, 31 Aug 2020 17:37:53 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id p65so6228353qtd.2;
        Mon, 31 Aug 2020 17:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dIEiNvBLTWIM+tsDzxoNt6hyhVE3CsWqm/oHRKciIWg=;
        b=HRRVF+tc4ypb2vdDNbx/KCJwXvTudDkCICJgqEHeViRKY5LkASvyKgKess9ALDPEOz
         zsB4d9J6LKLTdu/R7sTuvlo/J9gcsSevNMkPUhdqpkRmOPsP6RkVruHzdMWUnSPQGOI0
         q8B35pKiq0jbdAnJKPgcDXtRC+XIi6bkhenvuO4YHYCAbfnsKrE3W0n1Jh7312xXCbiE
         WVjUCswFcipZScBQPsHYd2oSN96ZcSuWQzYv3Oz2AcgNz/byGmyW5FBQJ6ZTtvS2hnyW
         MFvFIGfbs0GaYn9WaiNCeBQaLPpDpHGvEPDV3u7ygVfDsf4NMdYm7H7hW6EU7F15TxkG
         29QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIEiNvBLTWIM+tsDzxoNt6hyhVE3CsWqm/oHRKciIWg=;
        b=dDqt+B+C/nHVLvGqVPOzhkW+/En5UwatUhXh2SDttMjd93pk7hOAOt7n1gpQ6o9+N2
         e4ty0NzVO+D6PTyGaV0FdWu5XU3icNMQhlTKYcNPWJ/F2ju1e5nd0OHB6OpDVJRgAym1
         w/RI3DzADjI6YU1CzHB6bqKp4TN3EUXmx7pgRmTOEJu5Tj9p0Rg4Wh9s46rmsGs5H5N5
         c6DCIcCPjyfkg1eqL2lQrPNkPv+djXFCOfovsjoUTDw6AQFGa/p/gTYn3CMxP/pyFeuY
         dYbOFsQPgR2QTF9HnrYUrWXrIjNHLPaKhSKRH9L+tBB04OnwlH5FVwmxT+i1PtSLFN4A
         Jgwg==
X-Gm-Message-State: AOAM532JHqgc7AKAFJ8kGL9bsAWOsZ2Da+Emv5TXKcsB0xdxvqOTNevw
        61SIDHIzshIC3dZ2EvoQJZc=
X-Google-Smtp-Source: ABdhPJz8Wv+480GnFY5uMGID4S7SJE7C6JOU80tX6PtSYNDga7dFV/9ruYA31xALkSW8gmKcxnVesw==
X-Received: by 2002:aed:3081:: with SMTP id 1mr3885485qtf.356.1598920671550;
        Mon, 31 Aug 2020 17:37:51 -0700 (PDT)
Received: from [192.168.1.181] (pool-173-75-208-99.phlapa.fios.verizon.net. [173.75.208.99])
        by smtp.gmail.com with ESMTPSA id m26sm12957327qtc.83.2020.08.31.17.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 17:37:50 -0700 (PDT)
Subject: Re: KASAN: use-after-free Write in rtl_fw_do_work
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+dc3cab055dff074f2d7f@syzkaller.appspotmail.com>,
        andreyknvl@google.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pkshih@realtek.com,
        syzkaller-bugs@googlegroups.com
References: <00000000000059779405ae2afa90@google.com>
 <20200831133053.9300-1-hdanton@sina.com>
 <35bb65f9-0a9e-7fb8-ee8d-47ce3c781fe4@gmail.com>
From:   Brooke Basile <brookebasile@gmail.com>
Message-ID: <77d41cee-d145-d1b5-729e-4931839ea41f@gmail.com>
Date:   Mon, 31 Aug 2020 20:37:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <35bb65f9-0a9e-7fb8-ee8d-47ce3c781fe4@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 7:56 PM, Hillf Danton wrote:
> 
> On Mon, 31 Aug 2020 15:15:13 -0400 Brooke Basile wrote:
>>
>> On 8/31/20 9:30 AM, Hillf Danton wrote:
>>>
>>> Mon, 31 Aug 2020 04:48:15 -0700
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    3ed8e1c2 usb: typec: tcpm: Migrate workqueue to RT priorit..
>>>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=111f9015900000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccafc70ac3d5f49c
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=dc3cab055dff074f2d7f
>>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148a00c9900000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+dc3cab055dff074f2d7f@syzkaller.appspotmail.com
>>>>
>>>> usb 1-1: Direct firmware load for rtlwifi/rtl8192cufw_TMSC.bin failed with error -2
>>>> usb 1-1: Direct firmware load for rtlwifi/rtl8192cufw.bin failed with error -2
>>>> rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
>>>> rtlwifi: Selected firmware is not available
>>>> ==================================================================
>>>> BUG: KASAN: use-after-free in rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
>>>> Write of size 4 at addr ffff8881c9c2ff30 by task kworker/1:5/3063
>>>>
>>>> CPU: 1 PID: 3063 Comm: kworker/1:5 Not tainted 5.9.0-rc1-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> Workqueue: events request_firmware_work_func
>>>> Call Trace:
>>>>    __dump_stack lib/dump_stack.c:77 [inline]
>>>>    dump_stack+0xf6/0x16e lib/dump_stack.c:118
>>>>    print_address_description.constprop.0+0x1c/0x210 mm/kasan/report.c:383
>>>>    __kasan_report mm/kasan/report.c:513 [inline]
>>>>    kasan_report.cold+0x37/0x7c mm/kasan/report.c:530
>>>>    rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
>>>>    request_firmware_work_func+0x126/0x250 drivers/base/firmware_loader/main.c:1001
>>>>    process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
>>>>    worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>>>>    kthread+0x392/0x470 kernel/kthread.c:292
>>>>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>>>
>>>> The buggy address belongs to the page:
>>>> page:000000008323bb9d refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1c9c2f
>>>> flags: 0x200000000000000()
>>>> raw: 0200000000000000 0000000000000000 ffffea0007270bc8 0000000000000000
>>>> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>>>> page dumped because: kasan: bad access detected
>>>>
>>>> Memory state around the buggy address:
>>>>    ffff8881c9c2fe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>    ffff8881c9c2fe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>> ffff8881c9c2ff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>                                        ^
>>>>    ffff8881c9c2ff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>>    ffff8881c9c30000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> ==================================================================
>>>
>>>
>>> While probing pci for instance, wait for kworker to finish its work in the
>>> err branches.
>>>
>>>
>>> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
>>> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
>>> @@ -78,7 +78,6 @@ static void rtl_fw_do_work(const struct
>>>    
>>>    	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
>>>    		 "Firmware callback routine entered!\n");
>>> -	complete(&rtlpriv->firmware_loading_complete);
>>>    	if (!firmware) {
>>>    		if (rtlpriv->cfg->alt_fw_name) {
>>>    			err = request_firmware(&firmware,
>>> @@ -91,13 +90,12 @@ static void rtl_fw_do_work(const struct
>>>    		}
>>>    		pr_err("Selected firmware is not available\n");
>>>    		rtlpriv->max_fw_size = 0;
>>> -		return;
>>> +		goto out;
>>>    	}
>>>    found_alt:
>>>    	if (firmware->size > rtlpriv->max_fw_size) {
>>>    		pr_err("Firmware is too big!\n");
>>> -		release_firmware(firmware);
>>> -		return;
>>> +		goto release;
>>>    	}
>>>    	if (!is_wow) {
>>>    		memcpy(rtlpriv->rtlhal.pfirmware, firmware->data,
>>> @@ -108,7 +106,11 @@ found_alt:
>>>    		       firmware->size);
>>>    		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
>>>    	}
>>> +
>>> +release:
>>>    	release_firmware(firmware);
>>> +out:
>>> +	complete(&rtlpriv->firmware_loading_complete);
>>>    }
>>>    
>>>    void rtl_fw_cb(const struct firmware *firmware, void *context)
>>> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
>>> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
>>> @@ -2161,6 +2161,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
>>>    	struct rtl_pci *rtlpci;
>>>    	unsigned long pmem_start, pmem_len, pmem_flags;
>>>    	int err;
>>> +	bool wait_kworker = false;
>>>    
>>>    	err = pci_enable_device(pdev);
>>>    	if (err) {
>>> @@ -2272,6 +2273,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
>>>    		err = -ENODEV;
>>>    		goto fail3;
>>>    	}
>>> +	wait_kworker = true;
>>>    	rtlpriv->cfg->ops->init_sw_leds(hw);
>>>    
>>>    	/*aspm */
>>> @@ -2327,7 +2329,8 @@ fail2:
>>>    		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
>>>    
>>>    	pci_release_regions(pdev);
>>> -	complete(&rtlpriv->firmware_loading_complete);
>>> +	if (wait_kworker == true)
>>> +		wait_for_completion(&rtlpriv->firmware_loading_complete);
>>>    
>>>    fail1:
>>>    	if (hw)
>>>
>>
>> Hi,
> 
> Hi Brooke
>>
>> It looks like this is probably a duplicate related to this patch:
>> https://syzkaller.appspot.com/bug?id=1f05ed98df706bb64aeee4dccc5ab48cd7542643
> 
> Quite likely, particularly for the accesses to the link above in the
> far east cities like Shanghai. More interesting may be that we can see
> the difference between the two patches if you can copy-n-paste that
> one in reply to this message because I have no clear idea if it's the
> ad hoc matter of fact that fixes for syzbot reports should better be
> posted in the report mail thread at lore.kernel.org, with the
> ant-anntena-size bonus to facilitate those who are disabled outside
> lore in the split of a second.
> 

Sorry, in hindsight my wording may have been a bit awkward in my 
message-- what I meant to say is, your patch may also resolve that bug. :)
I don't actually have a patch for this, I had just begun working on it 
over the weekend and saw that your patch could be related to the issue.

Best,
Brooke Basile
