Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E00A623E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfICHJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:09:32 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:55847 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfICHJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 03:09:32 -0400
Received: from [192.168.0.7] ([91.45.211.96]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mzydy-1iPaem017W-00x3Db; Tue, 03 Sep 2019 09:09:18 +0200
Subject: Re: [Intel-wired-lan] [PATCH] i40e: clear __I40E_VIRTCHNL_OP_PENDING
 on invalid min tx rate
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190903060810.30775-1-sassmann@kpanic.de>
 <36909884-1de6-a537-0341-b060d01e4c0d@molgen.mpg.de>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <58a1b74a-574e-ed95-e33e-49a230017773@kpanic.de>
Date:   Tue, 3 Sep 2019 09:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <36909884-1de6-a537-0341-b060d01e4c0d@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lfBeCfRWBy8mYEQMm9BalBScGqz+N1wwtJ0UDkwj0CN2cf8HyrI
 s0g9tsMu4994FJ5It7KZPj3rOnQYTlVGX2VEFomNd+0VZ6SE3/Ti1wk6OCfN1FfuCnXSKYx
 +pu3YZ3fw0cbL6OI4U0U9UCoepTMXETQuShSBYm+/ASF9J3TT8F0WWyKdoP5adEu+0p1Ofg
 h9Al6kMQcMEBiGbj0vU3w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+gWPVoVvNr0=:jqIPIUdaAIkeGILb1U4v1/
 Q/ISpv68zP2U03oghYD5FsTj21kTfOMrL0S3NSaR6frTMbXy+F+bsNOvo6N6JTlSnt83J9Wnu
 whHAsyqGJa5YNWKcWW4j33tLyBBRZdDL0iTqXcTOVJJ+tH3qrO6upeYOZik3V7zfui3Kv4nfP
 nd5VRK/Dt5Kh44OXlGXvuQCNBgv8yPnRJovjO/6JnDLRXLZqlrPIseFZrzG/GcmQVaY4h+KQP
 oqFFuLT3rJ7VO1eMRlXWteQ5hsWfdNbRrA0uKOB5xmDxIZmqfZROTXLr/Y2r/L8ckm9Zlx4zt
 7nRQ/WqvrCwJiIULU4aqvmd5tjLgj0w/CSjvG8G7lqMCZDivCO49PYjNxdLSyXy0QGO+vvzoC
 5FFME8HR1f0pyhtt9fbtxeQSRl7skHM+gMubNO9kVIll/sMxX+mgTszCCLU+D7sYiIsDRnbho
 k9+b+euKEVa4eakY3ZdaT3HzUUpmKjubd+E+1Xcfnz4Z65aXXEGg54rY5v4BhoLjSRip6ButY
 qWc/xwo8QLo3nooBxIInlA9TIjEBUNdX56THpE5ZxsjNz8nBG2uD2wAkc9F3uWb3km9nscs7h
 TJGHLzgMN01NIFY3o4PObyuosZfkzne7ijLXpdiJfgrGcnjKY0D6CzotEhGiygF+FPwGFm1fi
 /fgEp3e6AEK2657G6jfbHkpFBNhbHCgnToLXmBmvLSx0BMJmGAP7oVdJXMCsdG2eWuGU+Vzl+
 V5JgX74V5Mqdmb+x0+l4XnrHaj4bnXFjxs/d2nlyBfsu1j4HC+NXX3DPzqb5kFVFTvpwv4D5n
 TwM1pkyFOzs88jorEZ0FR4Pcf9S3w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.19 08:42, Paul Menzel wrote:
> Dear Stefan,

Hi Paul,

> On 03.09.19 08:08, Stefan Assmann wrote:
>> In the case of an invalid min tx rate being requested
>> i40e_ndo_set_vf_bw() immediately returns -EINVAL instead of releasing
>> __I40E_VIRTCHNL_OP_PENDING first.
> 
> What problem does this cause?

If the __I40E_VIRTCHNL_OP_PENDING bit never gets cleared no further
virtchnl op can be processed. For example you can no longer destroy the
VFs.

  Stefan

>> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> index f8aa4deceb5e..3d2440838822 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> @@ -4263,7 +4263,8 @@ int i40e_ndo_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
>>   	if (min_tx_rate) {
>>   		dev_err(&pf->pdev->dev, "Invalid min tx rate (%d) (greater than 0) specified for VF %d.\n",
>>   			min_tx_rate, vf_id);
>> -		return -EINVAL;
>> +		ret = -EINVAL;
>> +		goto error;
>>   	}
>>   
>>   	vf = &pf->vf[vf_id];
> 
> 
> Kind regards,
> 
> Paul
> 

