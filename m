Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE936E334E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 21:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjDOTcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 15:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDOTca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 15:32:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8292720;
        Sat, 15 Apr 2023 12:32:28 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qb20so53643838ejc.6;
        Sat, 15 Apr 2023 12:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681587146; x=1684179146;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nfRDfg5bIXBIhJpyx54fs18Q87nFwdIB8gGSodLfElM=;
        b=Q6pCrqMf2uXAUSHTjiYzR9lZB/fV7qeKqf2VVFEZPIQRVgatL5weU8Qys5DkYB2UxA
         yLlioVmVp0tIzgRAEJmA+Tu97Tnnwjztjf9nIqF3U/8sqAngaF5A/j0mJSDGWte8yVfn
         e2UFIoEJzNUoaBlI6z9hvWk+4pRB9DDS2XQU3nD1rHW3BEGrTIZt7z0TgcAHKi2gljPY
         HNyI1c2e/0tZgDyjUk5PqMb6lJvIXuBUI1A1tWGVmZSEkld0LvlXG/8Ptgl206qg8SIr
         yPNgatkrCqJKoMvRJIPnedLj8TyOCPYpruf0daCtmRLfSPJE8Ht1AF5HVIowxlgM1Y4j
         HCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681587146; x=1684179146;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nfRDfg5bIXBIhJpyx54fs18Q87nFwdIB8gGSodLfElM=;
        b=KJ8Y0cv8nlJUOIBNoOJIZOg5BqoUbSUcc7grJh1bvL9Qhp8yzgV0ie67VyirW+snmw
         dHOBkUioWkfFTPz3F0UKfXYDqVPIJEf8fZJtMYLGv3acfrv5u8euwJulvhF2Sighpj6Q
         vKIYOdl81CGT06QShY1KfQ0ssTGNUQEJ2hIZrPQcZ8DUOUguRfyeoexLA7Bre6gLfKlW
         ZI3ZAlNFH7hWEzTmJ6a0abENlJlF4eXk6Hd7mWAGleKPtAHVVBZBUObX0t2hc4cQzphA
         V1F5Mwsk81A/GvcGhfgEl4sS7h8w0fsk0vNftbpjIhQffwGgECC5W+1HrufQSAb4Y4zB
         IFIg==
X-Gm-Message-State: AAQBX9dl2YJRjqAq8+bgWSWgXA4UmZUTR7l/xvX3szRCjBCzuaUUdlv7
        Bpdm6LYgOZRoRrr2g4O+T/fgoaivrxJ8ng==
X-Google-Smtp-Source: AKy350bKobVIPFDsauDMvG0/mGZya7MJcmFgK401nShSjAK7jGcFFdIPjBLW7Z7dZkSotypjFiWSwA==
X-Received: by 2002:a17:906:c355:b0:94f:b5c:a254 with SMTP id ci21-20020a170906c35500b0094f0b5ca254mr2457660ejb.49.1681587146123;
        Sat, 15 Apr 2023 12:32:26 -0700 (PDT)
Received: from shift.daheim (pd9e29911.dip0.t-ipconnect.de. [217.226.153.17])
        by smtp.gmail.com with ESMTPSA id k13-20020a17090666cd00b009323f08827dsm4259005ejp.13.2023.04.15.12.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 12:32:25 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pnldJ-006Y0n-16;
        Sat, 15 Apr 2023 21:32:25 +0200
Message-ID: <03a74fbb-dd77-6283-0b08-6a9145a2f4f6@gmail.com>
Date:   Sat, 15 Apr 2023 21:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] ath9k: fix calibration data endianness
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230415150542.2368179-1-noltari@gmail.com>
 <87leitxj4k.fsf@toke.dk> <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
In-Reply-To: <a7895e73-70a3-450d-64f9-8256c9470d25@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/23 18:02, Christian Lamparter wrote:
> Hi,
> 
> On 4/15/23 17:25, Toke Høiland-Jørgensen wrote:
>> Álvaro Fernández Rojas <noltari@gmail.com> writes:
>>
>>> BCM63xx (Big Endian MIPS) devices store the calibration data in MTD
>>> partitions but it needs to be swapped in order to work, otherwise it fails:
>>> ath9k 0000:00:01.0: enabling device (0000 -> 0002)
>>> ath: phy0: Ignoring endianness difference in EEPROM magic bytes.
>>> ath: phy0: Bad EEPROM VER 0x0001 or REV 0x00e0
>>> ath: phy0: Unable to initialize hardware; initialization status: -22
>>> ath9k 0000:00:01.0: Failed to initialize device
>>> ath9k: probe of 0000:00:01.0 failed with error -22
>>
>> How does this affect other platforms? Why was the NO_EEP_SWAP flag set
>> in the first place? Christian, care to comment on this?
> 
> I knew this would come up. I've written what I know and remember in the
> pull-request/buglink.
> 
> Maybe this can be added to the commit?
> Link: https://github.com/openwrt/openwrt/pull/12365
> 
> | From what I remember, the ah->ah_flags |= AH_NO_EEP_SWAP; was copied verbatim from ath9k_of_init's request_eeprom.
> 
> Since the existing request_firmware eeprom fetcher code set the flag,
> the nvmem code had to do it too.
> 
> In theory, I don't think that not setting the AH_NO_EEP_SWAP flag will cause havoc.
> I don't know if there are devices out there, which have a swapped magic (which is
> used to detect the endianess), but the caldata is in the correct endiannes (or
> vice versa - Magic is correct, but data needs swapping).
> 
> I can run tests with it on a Netzgear WNDR3700v2 (AR7161+2xAR9220)
> and FritzBox 7360v2 (Lantiq XWAY+AR9220). (But these worked fine.
> So I don't expect there to be a new issue there).

Nope! This is a classic self-own!... Well at least, this now gets documented!

Here are my findings. Please excuse the overlong lines.

## The good news / AVM FritzBox 7360v2 ##

The good news: The AVM FritzBox 7360v2 worked the same as before.

Bootlog with the patch applied - cold start:

|[   14.738647] ath9k_pci_owl_loader 0000:01:00.0: enabling device (0000 -> 0002)
|[   14.747344] ath9k_pci_owl_loader 0000:01:00.0: fixup device configuration
|[   15.116403] pci 0000:01:00.0: [168c:002e] type 00 class 0x028000
|[   15.121083] pci 0000:01:00.0: reg 0x10: [mem 0x1c000000-0x1c00ffff 64bit]
|[   15.128162] pci 0000:01:00.0: supports D1
|[   15.131841] pci 0000:01:00.0: PME# supported from D0 D1 D3hot
|[   15.144186] pci 0000:01:00.0: BAR 0: assigned [mem 0x1c000000-0x1c00ffff 64bit]
|[...] Wireguard loading
|[   15.367461] ifx_pcie_bios_map_irq port 0 dev 0000:01:00.0 slot 0 pin 1
|[   15.372676] ifx_pcie_bios_map_irq dev 0000:01:00.0 irq 144 assigned
|[   15.379031] ath9k 0000:01:00.0: enabling device (0140 -> 0142)
|[   15.392181] ath: EEPROM regdomain: 0x8114
|[   15.392219] ath: EEPROM indicates we should expect a country code
|[   15.392232] ath: doing EEPROM country->regdmn map search
|[   15.392242] ath: country maps to regdmn code: 0x37
|[   15.392254] ath: Country alpha2 being used: DE
|[   15.392264] ath: Regpair used: 0x37
|[   15.406435] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
|[   15.411722] ieee80211 phy0: Atheros AR9287 Rev:2 mem=0xbc000000, irq=144

## The not so good news / Netgear WNDR3700v2 ##

But not the Netgar WNDR3700v2. One WiFi (The 2.4G, reported itself now as the 5G @0000:00:11.0 -
doesn't really work now), and the real 5G WiFi (@0000:00:12.0) failed with:
"phy1: Bad EEPROM VER 0x0001 or REV 0x06e0"

|[   23.260755] ath9k_pci_owl_loader 0000:00:11.0: enabling device (0000 -> 0002)
|[   23.268319] ath9k_pci_owl_loader 0000:00:12.0: enabling device (0000 -> 0002)
|[   23.285197] ath9k_pci_owl_loader 0000:00:11.0: fixup device configuration
|[   23.297232] ath9k_pci_owl_loader 0000:00:12.0: fixup device configuration
|[   23.320031] pci 0000:00:11.0: [168c:0029] type 00 class 0x028000
|[   23.326070] pci 0000:00:11.0: reg 0x10: [mem 0x10000000-0x1000ffff]
|[   23.332430] pci 0000:00:11.0: PME# supported from D0 D3hot
|[   23.338570] pci 0000:00:11.0: BAR 0: assigned [mem 0x10000000-0x1000ffff]
|[   23.347404] pci 0000:00:12.0: [168c:0029] type 00 class 0x028000
|[   23.353441] pci 0000:00:12.0: reg 0x10: [mem 0x10010000-0x1001ffff]
|[   23.359799] pci 0000:00:12.0: PME# supported from D0 D3hot
|[   23.365906] pci 0000:00:12.0: BAR 0: assigned [mem 0x10010000-0x1001ffff]
|[...] Wireguard loading
|[   24.333503] ath9k 0000:00:11.0: enabling device (0000 -> 0002)
|[   24.363290] ath: EEPROM regdomain: 0x0
|[   24.363319] ath: EEPROM indicates default country code should be used
|[   24.363325] ath: doing EEPROM country->regdmn map search
|[   24.363338] ath: country maps to regdmn code: 0x3a
|[   24.363346] ath: Country alpha2 being used: US
|[   24.363353] ath: Regpair used: 0x3a
|[   24.381709] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
|[   24.383599] gpio-508 (fixed antenna group 1): hogged as output/high
|[   24.389941] gpio-509 (fixed antenna group 1): hogged as output/high
|[   24.396204] gpio-510 (fixed antenna group 1): hogged as output/high
|[   24.402480] gpio-511 (fixed antenna group 1): hogged as output/high
|[   24.409007] ieee80211 phy0: Atheros AR9280 Rev:2 mem=0xb0000000, irq=18
|[   24.415793] ath9k 0000:00:12.0: enabling device (0000 -> 0002)
|[   24.505496] ath: phy1: Bad EEPROM VER 0x0001 or REV 0x06e0
|[   24.511027] ath: phy1: Unable to initialize hardware; initialization status: -22
|[   24.518420] ath9k 0000:00:12.0: Failed to initialize device
|[   24.524004] ath9k: probe of 0000:00:12.0 failed with error -22

without the patch (rebuild mac80211/backports and uploaded the newly
created ath9k*.ko files and loaded them manually):

[ 1205.670387] ath: phy10: Ignoring endianness difference in EEPROM magic bytes. <----
[ 1205.679077] ath: EEPROM regdomain: 0x0
[ 1205.679086] ath: EEPROM indicates default country code should be used
[ 1205.679092] ath: doing EEPROM country->regdmn map search
[ 1205.679105] ath: country maps to regdmn code: 0x3a
[ 1205.679113] ath: Country alpha2 being used: US
[ 1205.679120] ath: Regpair used: 0x3a
[ 1205.692894] ieee80211 phy10: Selected rate control algorithm 'minstrel_ht'
[ 1205.694757] gpio-508 (fixed antenna group 1): hogged as output/high
[ 1205.701115] gpio-509 (fixed antenna group 1): hogged as output/high
[ 1205.707396] gpio-510 (fixed antenna group 1): hogged as output/high
[ 1205.713656] gpio-511 (fixed antenna group 1): hogged as output/high
[ 1205.720192] ieee80211 phy10: Atheros AR9280 Rev:2 mem=0xb0000000, irq=18
[ 1205.816842] ath: phy11: Ignoring endianness difference in EEPROM magic bytes. <----
[ 1205.825521] ath: EEPROM regdomain: 0x0
[ 1205.825530] ath: EEPROM indicates default country code should be used
[ 1205.825537] ath: doing EEPROM country->regdmn map search
[ 1205.825549] ath: country maps to regdmn code: 0x3a
[ 1205.825557] ath: Country alpha2 being used: US
[ 1205.825564] ath: Regpair used: 0x3a
[ 1205.841571] ieee80211 phy11: Selected rate control algorithm 'minstrel_ht'
[ 1205.843795] ieee80211 phy11: Atheros AR9280 Rev:2 mem=0xb0010000, irq=19

Everything was fine again.

### Hexdump extract of relevant ART data (/dev/mtd6)  ###
|00001000  a5 5a 00 00 00 03 60 00  16 8c 00 29 60 08 00 01  |.Z....`....)`...|   <- 2.4GHz WiFi OwlLoader boot code
|00001010  02 80 60 2c 16 8c a0 95  50 00 16 8c 00 2a 50 08  |..`,....P....*P.|   Apart from the Magic 0x5AA5 (or here in LE 0xA55A)
|00001020  00 01 02 80 50 2c 16 8c  a0 95 50 64 0c c0 05 04  |....P,....Pd....|   this is irrelevant for ath9k (it skips it,
|00001030  50 6c 38 11 00 03 40 04  07 3b 00 40 40 74 00 03  |Pl8...@..;.@@t..|   see ar5416_eep_start_loc in ath9k's eeprom_def.c)
|00001040  00 00 40 00 00 00 01 c2  60 34 00 44 00 00 ff ff  |..@.....`4.D....|
|00001050  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
|*
|00001200  0c b8 d5 cc e0 16 02 01  00 00 00 1f 00 21 b7 9b  |.............!..|   <- 2.4GHz ath9k's base_eep_header
|00001210  81 c3 03 03 00 00 00 00  00 00 00 09 07 00 04 01  |................|
|00001220  00 ff 02 00 00 01 00 00  00 fb 00 00 00 00 00 00  |................|
|00001230  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |.............
|[...]
|00005000  a5 5a 00 00 00 03 60 00  16 8c 00 29 60 08 00 01  |.Z....`....)`...|    <- 5GHz WiFi OwlLoader boot code
|00005010  02 80 60 2c 16 8c a0 94  50 00 16 8c 00 2a 50 08  |..`,....P....*P.|
|00005020  00 01 02 80 50 2c 16 8c  a0 94 50 64 0c c0 05 04  |....P,....Pd....|
|00005030  50 6c 38 11 00 03 40 04  07 3b 00 40 40 74 00 03  |Pl8...@..;.@@t..|
|00005040  00 00 40 00 00 00 01 c2  60 34 00 44 00 00 ff ff  |..@.....`4.D....|
|00005050  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
|*
|00005200  0c b8 27 40 e0 16 01 01  00 00 00 1f 00 21 b7 9b  |..'@.........!..| <- 5GHz ath9k's base_eep_header
|00005210  81 c3 03 03 00 00 00 00  00 00 00 09 07 00 04 00  |................|
|00005220  01 ff 02 00 00 01 00 00  00 fe 00 00 00 00 00 00  |................|
|00005230  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

### ath9k debug dumps of ath9k w/o patch (working) ###
# cat /sys/kernel/debug/ieee80211/phy10/ath9k/base_eeprom // 2.4GHz
        Major Version :         14
        Minor Version :         22
             Checksum :      54732
               Length :       3256
           RegDomain1 :          0
           RegDomain2 :         31
              TX Mask :          3
              RX Mask :          3
           Allow 5GHz :          0
           Allow 2GHz :          1
    Disable 2GHz HT20 :          0
    Disable 2GHz HT40 :          0
    Disable 5Ghz HT20 :          0
    Disable 5Ghz HT40 :          0
           Big Endian :          1
    Cal Bin Major Ver :          0
    Cal Bin Minor Ver :          7
        Cal Bin Build :          9
  OpenLoop Power Ctrl :          0
           MacAddress : 00:21:b7:9b:81:c3 <--- This looks like a valid MAC
(Note: This MAC is not used. Netgear stores the MAC at a different location
in the ART - not included in the extract above)

# cat /sys/kernel/debug/ieee80211/phy11/ath9k // 5Ghz
       Major Version :         14
        Minor Version :         22
             Checksum :      10048
               Length :       3256
           RegDomain1 :          0
           RegDomain2 :         31
              TX Mask :          3
              RX Mask :          3
           Allow 5GHz :          1
           Allow 2GHz :          0
    Disable 2GHz HT20 :          0
    Disable 2GHz HT40 :          0
    Disable 5Ghz HT20 :          0
    Disable 5Ghz HT40 :          0
           Big Endian :          1
    Cal Bin Major Ver :          0
    Cal Bin Minor Ver :          7
        Cal Bin Build :          9
  OpenLoop Power Ctrl :          0
           MacAddress : 00:21:b7:9b:81:c3 <--- This one too (it's the same)!

# cat /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
[...]
  Ant. Common Control :        288  // That's 0x0120
[...]

### ath9k debug dumps of the ath9k with patch (Broken) ###

# cat /sys/kernel/debug/ieee80211/phy0/ath9k/base_eeprom  // This is the 2.4GHz Wifi, But now it says 5 GHz
        Major Version :         14
        Minor Version :         22
             Checksum :      54732 <--- checksum matches 2.4GHz @ 0x1200 (0xd5cc)
               Length :       3256 <--- this looks OK? Ok!
           RegDomain1 :          0
           RegDomain2 :         31
              TX Mask :          3
              RX Mask :          3
           Allow 5GHz :          1 <-- Says it's 5G! (0x1)
           Allow 2GHz :          0
    Disable 2GHz HT20 :          0
    Disable 2GHz HT40 :          0
    Disable 5Ghz HT20 :          0
    Disable 5Ghz HT40 :          0
           Big Endian :          0 <-- Oh? what happend here? This should have been 1 (Is this why the 5GHz PHY worked?)
    Cal Bin Major Ver :          7   | My best guess is that the u16 swap ath9k does, swapped opCapFlags and eepmisc.
                                     | So opCapFlags's value of 0x2/AR5416_OPFLAGS_11G in eepMisc is not publicy defined/known.
				    | while the eepMisc value of 0x1 (AR5416_OPFLAGS_11G) became "AR5416_OPFLAGS_11A"
				    | (=aka 5GHz capable) .
    Cal Bin Minor Ver :          0
        Cal Bin Build :          0
  OpenLoop Power Ctrl :          1
           MacAddress : 21:00:9b:b7:c3:81  <--- Multicast Bit set? This is bogus!

# cat /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
[...]
  Ant. Common Control :   18874368  // That's 0x01 20 00 00
[...]


Cheers,
Christian

