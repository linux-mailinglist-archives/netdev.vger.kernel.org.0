Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83529CBFC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832428AbgJ0Wcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:32:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29710 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1832423AbgJ0Wcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:32:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RMW6R6146869
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 18:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : subject : in-reply-to : references : message-id : content-type
 : content-transfer-encoding; s=pp1;
 bh=gUY6Y3DybNID6gtJNLlKiKjF1R/lY4zLcHqO1iv+kfI=;
 b=c1BF8xyVl0Ml43dHaDs0ZkaDBQgQI791gPk83z4aTFxC+zFrOHOI596lFyCmUcW6iklv
 75Inys6L5uhSTBcwNVWarfTNpeA1gCkM7OcYp6vX++qHMQ5hnUFa4Y9PbWga1Aitbao5
 F5nNAWSn7mzEkEGzaDg2vdg9m1DncBPQjoMwJdvwIjPAV3ivtXoGhZA+l8c0tHP0o9nz
 SvhGfxjlQn3cwFX2b9o7d/aAT67cbIH0rda29y7VkP9lHrP4JvKeQTZP6N/LrzScNzmH
 5x9DBCyvToE7iA9zj0WQ9sZy6CQX2MJ0e0a61uWLP6TIS99evYcaMAawSjmTXske51N7 pQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34efx4j0hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 18:32:41 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RMRFoB002253
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:41 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 34cbw92819-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:41 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RMWegw50659594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:40 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 698D4B208A
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:40 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EA23B2086
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:40 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 22:32:40 +0000 (GMT)
MIME-Version: 1.0
Date:   Tue, 27 Oct 2020 17:32:39 -0500
From:   ljp <ljp@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/1] powerpc/vnic: Extend "failover pending" window
In-Reply-To: <20201024000233.GC1411079@us.ibm.com>
References: <20201019195233.GA1282438@us.ibm.com>
 <FC9128E6-0E4A-476C-8A98-B04785385841@linux.vnet.ibm.com>
 <20201024000233.GC1411079@us.ibm.com>
Message-ID: <34e618d28741ae5bac8cb7e126f79f65@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_15:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 suspectscore=1 spamscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010270127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-23 19:02, Sukadev Bhattiprolu wrote:
> Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
>>    On Oct 19, 2020, at 2:52 PM, Sukadev Bhattiprolu
>>    <[1]sukadev@linux.ibm.com> wrote:
>> 
>>    From 67f8977f636e462a1cd1eadb28edd98ef4f2b756 Mon Sep 17 00:00:00 
>> 2001
>>    From: Sukadev Bhattiprolu <[2]sukadev@linux.vnet.ibm.com>
>>    Date: Thu, 10 Sep 2020 11:18:41 -0700
>>    Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
>>    Commit 5a18e1e0c193b introduced the 'failover_pending' state to 
>> track
>>    the "failover pending window" - where we wait for the partner to 
>> become
>>    ready (after a transport event) before actually attempting to 
>> failover.
>>    i.e window is between following two events:
>>           a. we get a transport event due to a FAILOVER
>>           b. later, we get CRQ_INITIALIZED indicating the partner is
>>              ready  at which point we schedule a FAILOVER reset.
>>    and ->failover_pending is true during this window.
>>    If during this window, we attempt to open (or close) a device, we
>>    pretend
>>    that the operation succeded and let the FAILOVER reset path 
>> complete
>>    the
>>    operation.
>>    This is fine, except if the transport event ("a" above) occurs 
>> during
>>    the
>>    open and after open has already checked whether a failover is 
>> pending.
>>    If
>>    that happens, we fail the open, which can cause the boot scripts to
>>    leave
>>    the interface down requiring administrator to manually bring up the
>>    device.
>>    This fix "extends" the failover pending window till we are 
>> _actually_
>>    ready to perform the failover reset (i.e until after we get the 
>> RTNL
>>    lock). Since open() holds the RTNL lock, we can be sure that we 
>> either
>>    finish the open or if the open() fails due to the failover pending
>>    window,
>>    we can again pretend that open is done and let the failover 
>> complete
>>    it.
>>    Signed-off-by: Sukadev Bhattiprolu <[3]sukadev@linux.ibm.com>
>>    ---
>>    Changelog [v2]:
>>    [Brian King] Ensure we clear failover_pending during hard reset
>>    ---
>>    drivers/net/ethernet/ibm/ibmvnic.c | 36 
>> ++++++++++++++++++++++++++----
>>    1 file changed, 32 insertions(+), 4 deletions(-)
>>    diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
>>    b/drivers/net/ethernet/ibm/ibmvnic.c
>>    index 1b702a43a5d0..2a0f6f6820db 100644
>>    --- a/drivers/net/ethernet/ibm/ibmvnic.c
>>    +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>>    @@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device
>>    *netdev)
>>    if (adapter->state != VNIC_CLOSED) {
>>    rc = ibmvnic_login(netdev);
>>    if (rc)
>>    - return rc;
>>    + goto out;
>>    rc = init_resources(adapter);
>>    if (rc) {
>>    netdev_err(netdev, "failed to initialize resources\n");
>>    release_resources(adapter);
>>    - return rc;
>>    + goto out;
>>    }
>>    }
>>    rc = __ibmvnic_open(netdev);
>>    +out:
>>    + /*
>>    + * If open fails due to a pending failover, set device state and
>>    + * return. Device operation will be handled by reset routine.
>>    + */
>>    + if (rc && adapter->failover_pending) {
>>    + adapter->state = VNIC_OPEN;
>>    + rc = 0;
>>    + }
>>    return rc;
>>    }
>>    @@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter
>>    *adapter,
>>      rwi->reset_reason);
>>    rtnl_lock();
>>    + /*
>>    + * Now that we have the rtnl lock, clear any pending failover.
>>    + * This will ensure ibmvnic_open() has either completed or will
>>    + * block until failover is complete.
>>    + */
>>    + if (rwi->reset_reason == VNIC_RESET_FAILOVER)
>>    + adapter->failover_pending = false;
>>    netif_carrier_off(netdev);
>>    adapter->reset_reason = rwi->reset_reason;
>>    @@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct 
>> work_struct
>>    *work)
>>    /* CHANGE_PARAM requestor holds rtnl_lock */
>>    rc = do_change_param_reset(adapter, rwi, reset_state);
>>    } else if (adapter->force_reset_recovery) {
>>    + /*
>>    + * Since we are doing a hard reset now, clear the
>>    + * failover_pending flag so we don't ignore any
>>    + * future MOBILITY or other resets.
>>    + */
>>    + adapter->failover_pending = false;
>>    +
>> 
>>    I think it would be better to put above chunk of code to
>>    do_hard_reset()
>>    like you do for do_reset(),  if you really want to extend the 
>> window
> 
> I put it here because we clear the other flags like 
> force_reset_recovery
> also. I have been considering moving the check ->wait_for_reset and the
> rtnl lock also into do_hard_reset(). I will queue that reorg separate
> from this bug fix.
> 
>>    this way.
>>    Extending the window that long may cause some resets being
>>    skipped in some scenarios though I don’t know yet.
> 
> Yes hard to prove, but we have run several tests on this and seems to
> be working.
> 
>>    We have already seen the migration reset being skipped in some 
>> cases.
> 
> Is that happening due to this patch or in general? If a migration 
> occurs

This patch changed the original behavior and clears failover_pending
only in do_reset which caused migration reset being skipped in the 
scenario like,
do_rest(migration reset) somehow calls into do_hard_reset(failover 
reset),
and the failover_pending is not cleared, so that do_hard_reset is 
skipped,
and migration reset is not completely completed.

This is why Brian King suggested this to fix the regression of v1 patch.
    Changelog [v2]:
    [Brian King] Ensure we clear failover_pending during hard reset

> while failover is pending, we should review the best way to handle 
> that.
> Will failover complete in such a case or should we punt the failover 
> and
> process migration instead? I think that should be addressed separately
> because that window is smaller but is there even without this patch?
> 
>>    So my point is extending the window is kind of risky, and do we 
>> have an
>>    alternative to address the "open” problem you want to solve 
>> originally?
>>    For example, would it be a viable approach to only change the code 
>> in
>>    ibmvnic_open() or __ibmvnic_open(), but not extend this window?
> 
> Not sure. We could try and block the open until failover is completed
> but a) that could still timeout the application and b) Existing code
> "pretends" that failover occurred "just after" open succeeded, so marks
> the open successful and lets the failover complete the open.
> 
> Besides, we should also not assume that the failover window will be
> short right?
> 
>> 
>>    /* Transport event occurred during previous reset */
>>    if (adapter->wait_for_reset) {
>>    /* Previous was CHANGE_PARAM; caller locked */
>>    @@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct 
>> ibmvnic_adapter
>>    *adapter,
>>    unsigned long flags;
>>    int ret;
>>    + /*
>>    + * If failover is pending don't schedule any other reset.
>>    + * Instead let the failover complete. If there is already a
>>    + * a failover reset scheduled, we will detect and drop the
>>    + * duplicate reset when walking the ->rwi_list below.
>>    + */
>>    if (adapter->state == VNIC_REMOVING ||
>>       adapter->state == VNIC_REMOVED ||
>>    -    adapter->failover_pending) {
>>    +    (adapter->failover_pending && reason != VNIC_RESET_FAILOVER)) 
>> {
>>    ret = EBUSY;
>>    netdev_dbg(netdev, "Adapter removing or pending failover, skipping
>>    reset\n");
>>    goto err;
>>    @@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union 
>> ibmvnic_crq
>>    *crq,
>>    case IBMVNIC_CRQ_INIT:
>>    dev_info(dev, "Partner initialized\n");
>>    adapter->from_passive_init = true;
>>    - adapter->failover_pending = false;
>>    if (!completion_done(&adapter->init_done)) {
>>    complete(&adapter->init_done);
>>    adapter->init_done_rc = -EIO;
>>    --
>>    2.25.4
>> 
>> References
>> 
>>    1. mailto:sukadev@linux.ibm.com
>>    2. mailto:sukadev@linux.vnet.ibm.com
>>    3. mailto:sukadev@linux.ibm.com
