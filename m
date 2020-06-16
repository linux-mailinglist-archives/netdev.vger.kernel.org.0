Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6531FAF1A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgFPL0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 07:26:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50848 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgFPL0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 07:26:35 -0400
Received: from [114.249.250.117] (helo=[192.168.1.10])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <aaron.ma@canonical.com>)
        id 1jl9jc-0005el-RY; Tue, 16 Jun 2020 11:26:33 +0000
Subject: Re: [PATCH] e1000e: continue to init phy even when failed to disable
 ULP
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vitaly.lifshits@intel.com,
        sasha.neftin@intel.com
References: <20200616100512.22512-1-aaron.ma@canonical.com>
 <4CC928F1-02CC-4675-908E-42B26C151FA1@canonical.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Autocrypt: addr=aaron.ma@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFffeLkBCACi4eE4dPsgWN6B9UDOVcAvb5QgU/hRG6yS0I1lGKQv4KA+bke0c5g8clbO
 9gIlIl2bityfA9NzBsDik4Iei3AxMbFyxv9keMwcOFQBIOZF0P3f05qjxftF8P+yp9QTV4hp
 BkFzsXzWRgXN3r8hU8wqZybepF4B1C83sm2kQ5A5N0AUGbZli9i2G+/VscG9sWfLy8T7f4YW
 MjmlijCjoV6k29vsmTWQPZ7EApNpvR5BnZQPmQWzkkr0lNXlsKcyLgefQtlwg6drK4fe4wz0
 ouBIHJEiXE1LWK1hUzkCUASra4WRwKk1Mv/NLLE/aJRqEvF2ukt3uVuM77RWfl7/H/v5ABEB
 AAG0IUFhcm9uIE1hIDxhYXJvbi5tYUBjYW5vbmljYWwuY29tPokBNwQTAQgAIQUCV994uQIb
 AwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDNxCzQfVU6ntJ9B/9aVy0+RkLqF9QpLmw+
 LAf1m3Fd+4ZarPTerqDqkLla3ekYhbrEtlI1mYuB5f+gtrIjmcW27gacHdslKB9YwaL8B4ZB
 GJKhcrntLg4YPzYUnXZkHHTv1hMw7fBYw82cBT+EbG0Djh6Po6Ihqyr3auHhfFcp1PZH4Mtq
 6hN5KaDZzF/go+tRF5e4bn61Nhdue7mrhFSlfkzLG2ehHWmRV+S91ksH81YDFnazK0sRINBx
 V1S8ts3WJ2f1AbgmnDlbK3c/AfI5YxnIHn/x2ZdXj1P/wn7DgZHmpMy5DMuk0gN34NLUPLA/
 cHeKoBAF8emugljiKecKBpMTLe8FrVOxbkrauQENBFffeLkBCACweKP3Wx+gK81+rOUpuQ00
 sCyKzdtMuXXJ7oL4GzYHbLfJq+F+UHpQbytVGTn3R5+Y61v41g2zTYZooaC+Hs1+ixf+buG2
 +2LZjPSELWPNzH9lsKNlCcEvu1XhyyHkBDbnFFHWlUlql3nSXMo//dOTG/XGKaEaZUxjCLUC
 8ehLc16DJDvdXsPwWhHrCH/4k92F6qQ14QigBMsl75jDTDJMEYgRYEBT1D/bwxdIeoN1BfIG
 mYgf059RrWax4SMiJtVDSUuDOpdwoEcZ0FWesRfbFrM+k/XKiIbjMZSvLunA4FIsOdWYOob4
 Hh0rsm1G+fBLYtT+bE26OWpQ/lSn4TdhABEBAAGJAR8EGAEIAAkFAlffeLkCGwwACgkQzcQs
 0H1VOp6p5Af/ap5EVuP1AhFdPD3pXLNrUUt72W3cuAOjXyss43qFC2YRjGfktrizsDjQU46g
 VKoD6EW9XUPgvYM+k8BJEoXDLhHWnCnMKlbHP3OImxzLRhF4kdlnLicz1zKRcessQatRpJgG
 NIiD+eFyh0CZcWBO1BB5rWikjO/idicHao2stFdaBmIeXvhT9Xp6XNFEmzOmfHps+kKpWshY
 9LDAU0ERBNsW4bekOCa/QxfqcbZYRjrVQvya0EhrPhq0bBpzkIL/7QSBMcdv6IajTlHnLARF
 nAIofCEKeEl7+ksiRapL5Nykcbt4dldE3sQWxIybC94SZ4inENKw6I8RNpigWm0R5w==
Message-ID: <dc46e68f-8af7-327e-3763-ebcb24df3a83@canonical.com>
Date:   Tue, 16 Jun 2020 19:26:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4CC928F1-02CC-4675-908E-42B26C151FA1@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/20 7:23 PM, Kai-Heng Feng wrote:
> 
> 
>> On Jun 16, 2020, at 18:05, Aaron Ma <aaron.ma@canonical.com> wrote:
>>
>> After commit "e1000e: disable s0ix entry and exit flows for ME systems",
>> some ThinkPads always failed to disable ulp by ME.
>> commit "e1000e: Warn if disabling ULP failed" break out of init phy:
>>
>> error log:
>> [   42.364753] e1000e 0000:00:1f.6 enp0s31f6: Failed to disable ULP
>> [   42.524626] e1000e 0000:00:1f.6 enp0s31f6: PHY Wakeup cause - Unicast Packet
>> [   42.822476] e1000e 0000:00:1f.6 enp0s31f6: Hardware Error
>>
>> When disable s0ix, E1000_FWSM_ULP_CFG_DONE will never be 1.
>> If continue to init phy like before, it can work as before.
>> iperf test result good too.
>>
>> Chnage e_warn to e_dbg, in case it confuses.
>>
>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>> ---
>> drivers/net/ethernet/intel/e1000e/ich8lan.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> index f999cca37a8a..63405819eb83 100644
>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> @@ -302,8 +302,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
>> 	hw->dev_spec.ich8lan.ulp_state = e1000_ulp_state_unknown;
>> 	ret_val = e1000_disable_ulp_lpt_lp(hw, true);
> 
> If si0x entry isn't enabled, maybe skip calling e1000_disable_ulp_lpt_lp() altogether?
> We can use e1000e_check_me() to check that.
> 

No, s0ix is different feature with ULP mode.

Aaron

>> 	if (ret_val) {
>> -		e_warn("Failed to disable ULP\n");
>> -		goto out;
>> +		e_dbg("Failed to disable ULP\n");
>> 	}
> 
> The change of "e1000e: Warn if disabling ULP failed" is intentional to catch bugs like this.
> 
> Kai-Heng
> 
>>
>> 	ret_val = hw->phy.ops.acquire(hw);
>> -- 
>> 2.26.2
>>
> 
