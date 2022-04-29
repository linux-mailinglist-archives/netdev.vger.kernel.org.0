Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AF051483A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358438AbiD2Lfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358434AbiD2Lff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:35:35 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD9B562D4;
        Fri, 29 Apr 2022 04:32:17 -0700 (PDT)
Received: from [2a02:8108:963f:de38:6624:6d8d:f790:d5c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nkOr7-0000tj-Nz; Fri, 29 Apr 2022 13:32:13 +0200
Message-ID: <34bc7a39-b7e6-55a8-38d9-4a49c34d1797@leemhuis.info>
Date:   Fri, 29 Apr 2022 13:32:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH] ice: wait for EMP reset after firmware
 flash #forregzbot
Content-Language: en-US
To:     regressions@lists.linux.dev, Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220412102753.670867-1-poros@redhat.com>
 <bc534155-e5bc-b9d2-24b4-e7559a7c5fb5@molgen.mpg.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <bc534155-e5bc-b9d2-24b4-e7559a7c5fb5@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1651231937;985029ba;
X-HE-SMSGID: 1nkOr7-0000tj-Nz
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

#regzbot fixed-by: b537752e6cbf0e

On 12.04.22 15:28, Paul Menzel wrote:
> [Cc: +Jakob, +regressions@lists.linux.dev]
> 
> 
> Dear Petr,
> 
> 
> Thank you for your patch for the regression.
> 
> #regzbot ^introduced 399e27dbbd9e94
> 
> 
> Am 12.04.22 um 12:27 schrieb Petr Oros:
> 
> Please mention the time in the commit message summary:
> 
> ice: Wait 5 s for EMP reset after firmware flash
> 
>> We need to wait for EMP reset after firmware flash.
>> Code was extracted from OOT driver and without this wait fw_activate let
> 
> Which OOT driver exactly?
> 
>> card in inconsistent state recoverable only by second flash/activate
> 
> Please reflow for 75 characters per line, and add a dot/period to the
> end of sentences.
> 
>> Reproducer:
>> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file
>> E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
>> Preparing to flash
>> [fw.mgmt] Erasing
>> [fw.mgmt] Erasing done
>> [fw.mgmt] Flashing 100%
>> [fw.mgmt] Flashing done 100%
>> [fw.undi] Erasing
>> [fw.undi] Erasing done
>> [fw.undi] Flashing 100%
>> [fw.undi] Flashing done 100%
>> [fw.netlist] Erasing
>> [fw.netlist] Erasing done
>> [fw.netlist] Flashing 100%
>> [fw.netlist] Flashing done 100%
>> Activate new firmware by devlink reload
>> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
>> reload_actions_performed:
>>      fw_activate
>> [root@host ~]# ip link show ens7f0
>> 71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq
>> state DOWN mode DEFAULT group default qlen 1000
>>      link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>>      altname enp202s0f0
>>
>> dmesg after flash:
>> [   55.120788] ice: Copyright (c) 2018, Intel Corporation.
>> [   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status =
>> -5, continuing anyway
>> [   55.569797] ice 0000:ca:00.0: The DDP package was successfully
>> loaded: ICE OS Default Package version 1.3.28.0
>> [   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
>> [   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
>> [   55.647348] ice 0000:ca:00.0: PTP init successful
>> [   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max
>> number of TCs supported on this port are 8
>> [   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW
>> mode.
>> [   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
>> [   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe
>> bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable
>> of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
> 
> So, what is the error? `Get PHY capabilities failed status = -5`?
> 
> What firmware version did the network card have before and after the
> update?
> 
>> Reboot don't help, only second flash/activate with OOT or patched
>> driver put card back in consistent state
> 
> s/don't/doesn’t/
> 
>> After patch:
>> [root@host ~]# devlink dev flash pci/0000:ca:00.0 file
>> E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
>> Preparing to flash
>> [fw.mgmt] Erasing
>> [fw.mgmt] Erasing done
>> [fw.mgmt] Flashing 100%
>> [fw.mgmt] Flashing done 100%
>> [fw.undi] Erasing
>> [fw.undi] Erasing done
>> [fw.undi] Flashing 100%
>> [fw.undi] Flashing done 100%
>> [fw.netlist] Erasing
>> [fw.netlist] Erasing done
>> [fw.netlist] Flashing 100%
>> [fw.netlist] Flashing done 100%
>> Activate new firmware by devlink reload
>> [root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
>> reload_actions_performed:
>>      fw_activate
>> [root@host ~]# ip link show ens7f0
>> 19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
>> UP mode DEFAULT group default qlen 1000
>>      link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
>>      altname enp202s0f0
> 
> Did you try anything less than five seconds? i40e uses one second, cf.
> commit 9b13bd53134c (i40e: Increase delay to 1 s after global EMP reset).
> 
>> Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via
>> devlink reload")
>> Signed-off-by: Petr Oros <poros@redhat.com>
>> ---
>>   drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>> b/drivers/net/ethernet/intel/ice/ice_main.c
>> index d768925785ca79..90ea2203cdc763 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>> @@ -6931,12 +6931,15 @@ static void ice_rebuild(struct ice_pf *pf,
>> enum ice_reset_req reset_type)
>>         dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
>>   +#define ICE_EMP_RESET_SLEEP 5000
> 
> Please append the unit to the macro name.
> 
>>       if (reset_type == ICE_RESET_EMPR) {
>>           /* If an EMP reset has occurred, any previously pending flash
>>            * update will have completed. We no longer know whether or
>>            * not the NVM update EMP reset is restricted.
>>            */
>>           pf->fw_emp_reset_disabled = false;
>> +
>> +        msleep(ICE_EMP_RESET_SLEEP);
>>       }
>>         err = ice_init_all_ctrlq(hw);
> 
> 
> Kind regards,
> 
> Paul
> 
> 
