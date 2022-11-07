Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA6061F243
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiKGL6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiKGL54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:57:56 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53A31A83B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 03:57:55 -0800 (PST)
Received: from [192.168.0.54] ([185.35.111.107]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M6DnM-1ouCcB2yLY-006h5w; Mon, 07 Nov 2022 12:57:43 +0100
Subject: Re: [PATCH net-next] iavf: check that state transitions happen under
 lock
To:     Leon Romanovsky <leon@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, patryk.piotrowski@intel.com
References: <20221028134515.253022-1-sassmann@kpanic.de>
 <Y2gHqj18Tz66k4ZN@unreal>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <5911b8f9-590b-6e05-646a-c1bc597105d8@kpanic.de>
Date:   Mon, 7 Nov 2022 12:57:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y2gHqj18Tz66k4ZN@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2jA52jcwX3fvaQpF2Bsz1IATYQGTCTrCivoSPvLHnqEGSAopT2s
 tU5Txbr7rUfd1fUs7eAEUzAFkG5d0NKHgdG0sf56cMhKuYRmaGDb6qwr9Kl1HtMfKrD9HkT
 ZhE4fX22v/AXdwicCpFwbPFmjzNHX+n3mt0evdqpVQr2Mwf9T2orpq6GV5+Gy9G1rg6UlJ1
 GT2eEwrF/vzkFjqz4qTEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ek4N2c9+0Ls=:ba1xtT6fDH64bcBREinRym
 I1wnIW/Br5Z+by7rdRHLsZizKp6MBUhQJP6SUy9JpiBCKfs3GTrZSe2MGyWIGqKJvGIElL7XX
 f8Vd0sXBz+tOpZ8rGNYJRHYWfANP7PVANQ7ity/w5VNTsix7i1VOIXpU5L8LTtdiK4EiNPjzj
 6l5FVlr73aHGZLJDmJrySOADyPaC8JMrC/3uBYs51ogMJ5FQSF5FmAlViSoOy367NwlaWo8Dc
 EyJlebSbG6zpI+fcLxFG3kyKsilbxQVMTSksfLmT9fRn0Rf0TsCXgckW7LAtU6qpiiRI4LsNp
 SesvQKN6CgJLIEQwGj0dUA1qUOElztmx24gzqrPgKjtzRhVGftQtbUuGprAXnHnSt3LpjPuyE
 HdN6DnOvWyoqOmMSqV616PnxmZQvNTPDDzsj3IFALuF1mF7AN2bmHBjkUL1hcQDUMLZibwvJk
 mCHL289/uSbTd5udh6LS+K66zhG/Lx1OekXGSMkN/Sxd8PqBzkk4XxPVsMNXMXkj3HYRsvMva
 ACd7M0/ktolP6TqzgMIvz31Gh+4b8YGoXpU/9dflHXq7hQHylJua4roztfRBanogs5Hcz27QD
 34UrEWv2db4BN8+EFNBzlGk12r+WsbL2te1YOduQb8PII06P3cYBQRyy/4gLjhEEEsH3VP949
 AGjsMVi8EPZhrj+wrjZnHMD+cW7kC2RZuoKx+4B9beFvwE3swSG5e233LtkoxXbnfYxMzAcZT
 UhHLm29XTcFFKpktRBsS9jDDXenafZwE9bL0EynZNq7rm9nlR7qNCH6U4r1102zQAjb8EPZfj
 nt+VdvH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.11.22 20:14, Leon Romanovsky wrote:

> On Fri, Oct 28, 2022 at 03:45:15PM +0200, Stefan Assmann wrote:

>> Add a check to make sure crit_lock is being held during every state

>> transition and print a warning if that's not the case. For convenience

>> a wrapper is added that helps pointing out where the locking is missing.

>>

>> Make an exception for iavf_probe() as that is too early in the init

>> process and generates a false positive report.

>>

>> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>

>> ---

>>  drivers/net/ethernet/intel/iavf/iavf.h      | 23 +++++++++++++++------

>>  drivers/net/ethernet/intel/iavf/iavf_main.c |  2 +-

>>  2 files changed, 18 insertions(+), 7 deletions(-)

>>

>> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h

>> index 3f6187c16424..28f41bbc9c86 100644

>> --- a/drivers/net/ethernet/intel/iavf/iavf.h

>> +++ b/drivers/net/ethernet/intel/iavf/iavf.h

>> @@ -498,19 +498,30 @@ static inline const char *iavf_state_str(enum iavf_state_t state)

>>  	}

>>  }

>>  

>> -static inline void iavf_change_state(struct iavf_adapter *adapter,

>> -				     enum iavf_state_t state)

>> +static inline void __iavf_change_state(struct iavf_adapter *adapter,

>> +				       enum iavf_state_t state,

>> +				       const char *func,

>> +				       int line)

>>  {

>>  	if (adapter->state != state) {

>>  		adapter->last_state = adapter->state;

>>  		adapter->state = state;

>>  	}

>> -	dev_dbg(&adapter->pdev->dev,

>> -		"state transition from:%s to:%s\n",

>> -		iavf_state_str(adapter->last_state),

>> -		iavf_state_str(adapter->state));

>> +	if (mutex_is_locked(&adapter->crit_lock))

> 

> Please use lockdep for that, and not reinvent it.

> In you case lockdep_assert_held(&adapter->crit_lock).



Lockdep is mostly enabled in debug kernel but I was hoping to get

warnings in production environments as well. As those transitions don't

happen too often it shouldn't hurt performance.



> In addition, mutex_is_locked() doesn't check that this specific function

> is locked. It checks that this lock is used now.



You are correct, this check only triggers if crit_lock is not locked at

all. It would be better to check the lock owner, but I couldn't find an

easy way to do that. Better than no check IMO but we can drop it if you

don't see a benefit in it.



Thanks for the comments!



  Stefan

