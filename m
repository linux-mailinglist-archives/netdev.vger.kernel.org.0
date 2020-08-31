Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F13125819E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHaTPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHaTPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:15:17 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AE2C061573;
        Mon, 31 Aug 2020 12:15:16 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n129so7226402qkd.6;
        Mon, 31 Aug 2020 12:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hxfDO0uX7x7R+DcjMNt3edLL6iVYRbuCVp5kcEOYrro=;
        b=KOwzAdOsTL7UaRr6rGsVGfIc1dlr0pLX/6aqjoJHP7b/aPsF8uRek99N/UY7zOLjWu
         uSyFCD/fNZ58NKEWzKg5MdFhmytSKNpca86RGUmDf0Hru5qdHZmyUwovxJ/IXm5BEEGf
         /igmA8eNKdweC6LxMrBQshlG+Z1pVcBQdVNlw8HhSD5+OCocXg+SewJx2B4kJOuDBoJh
         Ysi2K9psMuvCYXFUktb7P1YiOCoGUf3ZSXO2wYaCKlTW77zzua0Za4zD61eLYLox8KRH
         GIPy8mRbA/j+NlRZZ5nq+8m96HPZ5bWTlHLCd7Z2D+pdR7kw/XYChf3SdQ7G0s7R1W/O
         EO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hxfDO0uX7x7R+DcjMNt3edLL6iVYRbuCVp5kcEOYrro=;
        b=tWMYtp0o0woqyZKZ9ZkByS8n7UQSGhHp0hCwXD+QpmVdatiMgGCBiyZKg1aZORo5UM
         rB9e2FmkVAG9Y7iycVa6gFjbGLsTfWGImX/KuZFirLgKQtkmQ03Poqr1/Vao0yRUNv0Q
         feB606vCLvAYt13hAnw6UMtp0Zj1AH2+dzpj0OyTYZznys3Ql3JzU4Job9Qwnf1WNGKJ
         A3ItWON9mZc67kr14CS+Jzb3+nW99M98bC1dGW6OiCu/PXxj5Pi1S8Pc6wYGboejnCxo
         pF15j6Ur7tXys0NTiPsT+P8vuNBTvk5IP+9EhsGIvjGCOrKxfA97pgnCgw5PKgkLzFlS
         Cl0A==
X-Gm-Message-State: AOAM530R5JS+QKMifhUYh4xiuwEexzBBCrlq9D3Fx2kiQZtXy/2Bct+p
        rCqlqzroGKIymugGpTsu6n0=
X-Google-Smtp-Source: ABdhPJwolbll+xGVR++5dGxOQeXP4li///iUT9Zw/A80iVW+gBssgXb4FMTTWQ41oIGe/tgRh2eqAw==
X-Received: by 2002:a37:2713:: with SMTP id n19mr2969783qkn.497.1598901315014;
        Mon, 31 Aug 2020 12:15:15 -0700 (PDT)
Received: from [192.168.1.181] (pool-173-75-208-99.phlapa.fios.verizon.net. [173.75.208.99])
        by smtp.gmail.com with ESMTPSA id p63sm3870764qkc.4.2020.08.31.12.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 12:15:14 -0700 (PDT)
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
From:   Brooke Basile <brookebasile@gmail.com>
Message-ID: <35bb65f9-0a9e-7fb8-ee8d-47ce3c781fe4@gmail.com>
Date:   Mon, 31 Aug 2020 15:15:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831133053.9300-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 9:30 AM, Hillf Danton wrote:
> 
> Mon, 31 Aug 2020 04:48:15 -0700
>> syzbot found the following issue on:
>>
>> HEAD commit:    3ed8e1c2 usb: typec: tcpm: Migrate workqueue to RT priorit..
>> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
>> console output: https://syzkaller.appspot.com/x/log.txt?x=111f9015900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccafc70ac3d5f49c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=dc3cab055dff074f2d7f
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148a00c9900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+dc3cab055dff074f2d7f@syzkaller.appspotmail.com
>>
>> usb 1-1: Direct firmware load for rtlwifi/rtl8192cufw_TMSC.bin failed with error -2
>> usb 1-1: Direct firmware load for rtlwifi/rtl8192cufw.bin failed with error -2
>> rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
>> rtlwifi: Selected firmware is not available
>> ==================================================================
>> BUG: KASAN: use-after-free in rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
>> Write of size 4 at addr ffff8881c9c2ff30 by task kworker/1:5/3063
>>
>> CPU: 1 PID: 3063 Comm: kworker/1:5 Not tainted 5.9.0-rc1-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events request_firmware_work_func
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0xf6/0x16e lib/dump_stack.c:118
>>   print_address_description.constprop.0+0x1c/0x210 mm/kasan/report.c:383
>>   __kasan_report mm/kasan/report.c:513 [inline]
>>   kasan_report.cold+0x37/0x7c mm/kasan/report.c:530
>>   rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
>>   request_firmware_work_func+0x126/0x250 drivers/base/firmware_loader/main.c:1001
>>   process_one_work+0x94c/0x15f0 kernel/workqueue.c:2269
>>   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
>>   kthread+0x392/0x470 kernel/kthread.c:292
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> The buggy address belongs to the page:
>> page:000000008323bb9d refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1c9c2f
>> flags: 0x200000000000000()
>> raw: 0200000000000000 0000000000000000 ffffea0007270bc8 0000000000000000
>> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff8881c9c2fe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>   ffff8881c9c2fe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> ffff8881c9c2ff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>                                       ^
>>   ffff8881c9c2ff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>   ffff8881c9c30000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ==================================================================
> 
> 
> While probing pci for instance, wait for kworker to finish its work in the
> err branches.
> 
> 
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -78,7 +78,6 @@ static void rtl_fw_do_work(const struct
>   
>   	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
>   		 "Firmware callback routine entered!\n");
> -	complete(&rtlpriv->firmware_loading_complete);
>   	if (!firmware) {
>   		if (rtlpriv->cfg->alt_fw_name) {
>   			err = request_firmware(&firmware,
> @@ -91,13 +90,12 @@ static void rtl_fw_do_work(const struct
>   		}
>   		pr_err("Selected firmware is not available\n");
>   		rtlpriv->max_fw_size = 0;
> -		return;
> +		goto out;
>   	}
>   found_alt:
>   	if (firmware->size > rtlpriv->max_fw_size) {
>   		pr_err("Firmware is too big!\n");
> -		release_firmware(firmware);
> -		return;
> +		goto release;
>   	}
>   	if (!is_wow) {
>   		memcpy(rtlpriv->rtlhal.pfirmware, firmware->data,
> @@ -108,7 +106,11 @@ found_alt:
>   		       firmware->size);
>   		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
>   	}
> +
> +release:
>   	release_firmware(firmware);
> +out:
> +	complete(&rtlpriv->firmware_loading_complete);
>   }
>   
>   void rtl_fw_cb(const struct firmware *firmware, void *context)
> --- a/drivers/net/wireless/realtek/rtlwifi/pci.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
> @@ -2161,6 +2161,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
>   	struct rtl_pci *rtlpci;
>   	unsigned long pmem_start, pmem_len, pmem_flags;
>   	int err;
> +	bool wait_kworker = false;
>   
>   	err = pci_enable_device(pdev);
>   	if (err) {
> @@ -2272,6 +2273,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
>   		err = -ENODEV;
>   		goto fail3;
>   	}
> +	wait_kworker = true;
>   	rtlpriv->cfg->ops->init_sw_leds(hw);
>   
>   	/*aspm */
> @@ -2327,7 +2329,8 @@ fail2:
>   		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
>   
>   	pci_release_regions(pdev);
> -	complete(&rtlpriv->firmware_loading_complete);
> +	if (wait_kworker == true)
> +		wait_for_completion(&rtlpriv->firmware_loading_complete);
>   
>   fail1:
>   	if (hw)
> 

Hi,

It looks like this is probably a duplicate related to this patch:
https://syzkaller.appspot.com/bug?id=1f05ed98df706bb64aeee4dccc5ab48cd7542643

Best,
Brooke Basile
