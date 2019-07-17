Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077416BDD8
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfGQOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:08:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58327 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfGQOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 10:08:38 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hnkbk-00007L-5L
        for netdev@vger.kernel.org; Wed, 17 Jul 2019 14:08:36 +0000
Received: by mail-pf1-f198.google.com with SMTP id z1so14511679pfb.7
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 07:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YArSjINoQ5yFdh8yhL0SWy97FyGsngj+ePsB8IsMtuk=;
        b=hY0HEsLtnEWQSE73tWQ/90BIrmNDzbTH7r6Umakf/bojl/7dlXHp17Gpwsiwlh4e5G
         QZy2miUp6Gc0ENKXVopoiXtFMaLYMwcT6lQSS/7NyMC2c6Gw2L8dyr6NWrw7U8vtEW1l
         Mb4pv1vO1mY4AeioBdMoWdtmHHOIgSGzBrnJZo3FvdlYq547alS2/JHGGLonKiDzSRQg
         XhoUPr0gJTAhpZs/T9TNPH7x2eKYrJmR/gdfEpBXMLVckBKBm9JJCdDS7hTSWeBcyQa0
         XUtruDCk8TOftNL0a4a1rsoxb2hy02sotzAt9hUDrS87Ebzhi+LDb3y1O51zv2NX6V9K
         7RkQ==
X-Gm-Message-State: APjAAAVi/Q5eTetTgONAVoHYOsUuU+4n+I3LDu6xMykHMJ/8A9gsSxS4
        ZWOQKISu3VcoInjH/c4h1dtpy8uBysYVTvlPC8G3Okyye24iif8nh2yF2ziVvfLZfe88ol8Cx9b
        f9nyZjZbYHclju3pas5DlY867HL3sFYYLEg==
X-Received: by 2002:a63:e807:: with SMTP id s7mr39993819pgh.194.1563372514782;
        Wed, 17 Jul 2019 07:08:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwlK6Qi5Xq0uNYDu0Hh6e2GHdN6OYbWnhf+LwNe56dEfyhwoAbcSFb9/k/IBE3NMcL02+5NqQ==
X-Received: by 2002:a63:e807:: with SMTP id s7mr39993775pgh.194.1563372514392;
        Wed, 17 Jul 2019 07:08:34 -0700 (PDT)
Received: from 2001-b011-380f-3c20-3096-77ea-5bd6-2b56.dynamic-ip6.hinet.net (2001-b011-380f-3c20-3096-77ea-5bd6-2b56.dynamic-ip6.hinet.net. [2001:b011:380f:3c20:3096:77ea:5bd6:2b56])
        by smtp.gmail.com with ESMTPSA id q24sm21479100pjp.14.2019.07.17.07.08.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 07:08:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 1/3] Bluetooth: btintel: Add firmware lock function
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <7CE1949F-76D2-4D27-82B6-02124E62DF5C@holtmann.org>
Date:   Wed, 17 Jul 2019 22:08:30 +0800
Cc:     Johannes Berg <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
Message-Id: <B50A91CA-7379-42F9-8335-8FE4A51BE66F@canonical.com>
References: <20190717074920.21624-1-kai.heng.feng@canonical.com>
 <7CE1949F-76D2-4D27-82B6-02124E62DF5C@holtmann.org>
To:     Marcel Holtmann <marcel@holtmann.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

at 21:36, Marcel Holtmann <marcel@holtmann.org> wrote:

> Hi Kai-Heng,
>
>> When Intel 8260 starts to load Bluetooth firmware and WiFi firmware, by
>> calling btintel_download_firmware() and iwl_pcie_load_given_ucode_8000()
>> respectively, the Bluetooth btintel_download_firmware() aborts half way:
>> [   11.950216] Bluetooth: hci0: Failed to send firmware data (-38)
>>
>> Let btusb and iwlwifi load firmwares exclusively can avoid the issue, so
>> introduce a lock to use in btusb and iwlwifi.
>>
>> This issue still occurs with latest WiFi and Bluetooth firmwares.
>>
>> BugLink: https://bugs.launchpad.net/bugs/1832988
>>
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
>> v2:
>> - Add bug report link.
>> - Rebase on latest wireless-next.
>>
>> drivers/bluetooth/btintel.c   | 14 ++++++++++++++
>> drivers/bluetooth/btintel.h   | 10 ++++++++++
>> include/linux/intel-wifi-bt.h |  8 ++++++++
>> 3 files changed, 32 insertions(+)
>> create mode 100644 include/linux/intel-wifi-bt.h
>>
>> diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
>> index bb99c8653aab..93ab18d6ddad 100644
>> --- a/drivers/bluetooth/btintel.c
>> +++ b/drivers/bluetooth/btintel.c
>> @@ -20,6 +20,8 @@
>>
>> #define BDADDR_INTEL (&(bdaddr_t) {{0x00, 0x8b, 0x9e, 0x19, 0x03, 0x00}})
>>
>> +static DEFINE_MUTEX(firmware_lock);
>> +
>> int btintel_check_bdaddr(struct hci_dev *hdev)
>> {
>> 	struct hci_rp_read_bd_addr *bda;
>> @@ -709,6 +711,18 @@ int btintel_download_firmware(struct hci_dev *hdev,  
>> const struct firmware *fw,
>> }
>> EXPORT_SYMBOL_GPL(btintel_download_firmware);
>>
>> +void btintel_firmware_lock(void)
>> +{
>> +	mutex_lock(&firmware_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(btintel_firmware_lock);
>> +
>> +void btintel_firmware_unlock(void)
>> +{
>> +	mutex_unlock(&firmware_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(btintel_firmware_unlock);
>> +
>
> so I am not in favor of this solution. The hardware guys should start  
> looking into fixing the firmware loading and provide proper firmware that  
> can be loaded at the same time.

Of course it’s much better to fix from hardware side.

>
> I am also not for sure penalizing all Intel Bluetooth/WiFi combos only  
> because one of them has a bug during simultaneous loading of WiFi and  
> Bluetooth firmware.

Yes, it’s not ideal.

>
> Frankly it would be better to detect a failed load and try a second time  
> instead of trying to lock each other out. The cross-contamination of WiFi  
> and Bluetooth drivers is just not clean.

Ok. Where do you think is better to handle it, Bluetooth core or USB core?

Kai-Heng

>
> Regards
>
> Marcel


