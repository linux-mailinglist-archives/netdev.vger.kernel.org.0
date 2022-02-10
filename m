Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085344B127E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiBJQQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:16:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiBJQQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:16:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B01397
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644509789; x=1676045789;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r8PFA9NdT2h+cbV4pg2OoAdQi1Xi5MNNvod94bUznuQ=;
  b=mjD4jgLmDjeWfOABu32WIHc27QxNzY/MkvvJEehCoakGT8K6Zp3ypJrS
   2kK58k50WPhE2k1sr5lg23TM6LH4RtlSfCyVnjOH+ZdV9y9nVc5gWcWOh
   FxO/AXvQt76GGqt635uL43r8mIqb6QuJlLIwYtMLoDVzeZhfBNHPLmNxk
   r/OwgCFHTvFx7lPKtMZzCHV435eswMBtCtRm8208kc6tImNCiFm2JyMz8
   rxRtLOXK590H+W1Yvl6pPsxCcGFZjCsIGGpfCfSF4/mbAJgfOcbSLACfb
   8l6loAuJSApISMkpXEQIQ6xD4QVPtkxvojtgcKWwJwCRnonwnoXGACQYP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="312812207"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="312812207"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 08:16:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="541669778"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.129.143]) ([10.215.129.143])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 08:16:24 -0800
Message-ID: <fb700c62-eca4-879b-1b1a-966d9232fd4d@linux.intel.com>
Date:   Thu, 10 Feb 2022 21:46:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next] net: wwan: iosm: Enable M.2 7360 WWAN card
 support
Content-Language: en-US
To:     Jan Kiszka <jan.kiszka@siemens.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com, flokli@flokli.de
References: <20220210153445.724534-1-m.chetan.kumar@linux.intel.com>
 <1c9240af-dbf4-0c11-ab25-bec5af132c24@siemens.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <1c9240af-dbf4-0c11-ab25-bec5af132c24@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/2022 9:08 PM, Jan Kiszka wrote:
> On 10.02.22 16:34, M Chetan Kumar wrote:
>> This patch enables Intel M.2 7360 WWAN card support on
>> IOSM Driver.
>>
>> Control path implementation is a reuse whereas data path
>> implementation it uses a different protocol called as MUX
>> Aggregation. The major portion of this patch covers the MUX
>> Aggregation protocol implementation used for IP traffic
>> communication.
>>
>> For M.2 7360 WWAN card, driver exposes 2 wwan AT ports for
>> control communication.  The user space application or the
>> modem manager to use wwan AT port for data path establishment.
>>
>> During probe, driver reads the mux protocol device capability
>> register to know the mux protocol version supported by device.
>> Base on which the right mux protocol is initialized for data
>> path communication.
>>
>> An overview of an Aggregation Protocol
>> 1>  An IP packet is encapsulated with 16 octet padding header
>>      to form a Datagram & the start offset of the Datagram is
>>      indexed into Datagram Header (DH).
>> 2>  Multiple such Datagrams are composed & the start offset of
>>      each DH is indexed into Datagram Table Header (DTH).
>> 3>  The Datagram Table (DT) is IP session specific & table_length
>>      item in DTH holds the number of composed datagram pertaining
>>      to that particular IP session.
>> 4>  And finally the offset of first DTH is indexed into DBH (Datagram
>>      Block Header).
>>
>> So in TX/RX flow Datagram Block (Datagram Block Header + Payload)is
>> exchanged between driver & device.
>>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Hey, cool! I'll be happy to try that out soon. Any special userland
> changes required, or will it "just work" with sufficiently recent
> ModemManager or whatever?

It need some changes at ModemManager side.
