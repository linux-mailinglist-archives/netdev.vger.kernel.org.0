Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1403B733
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403847AbfFJOXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:23:51 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39030 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403788AbfFJOXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:23:50 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5AENfwf016170;
        Mon, 10 Jun 2019 09:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1560176621;
        bh=qkxPPYNIuHPPab+NJdI+AxUj148DFYJDNTnjFsrGlD8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ixVN1PeD8NeIuhlcmaYP2bH2G9G/cQrMZzcGWZqQJS9N/Lppq+I+M9TrySIDG9v3R
         mrLYkEjHY7os85QZAqZ178y0UqizxXrb8yMBp3EcVdORSEtq8thPqehsPATGhBAVwv
         Yu+Fl8dEiUG+pH+f/0gwpXKCRaCHBj6VL5lTwf3k=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5AENfS9069556
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Jun 2019 09:23:41 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 10
 Jun 2019 09:23:40 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 10 Jun 2019 09:23:40 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5AENdVS070363;
        Mon, 10 Jun 2019 09:23:40 -0500
Subject: Re: [PATCH net-next v1 5/7] taprio: Add support for txtime offload
 mode.
To:     "Patel, Vedang" <vedang.patel@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
 <1559065608-27888-6-git-send-email-vedang.patel@intel.com>
 <55c2daae-c69b-4847-f995-4df85c4ee8b8@ti.com>
 <E6AB74F1-C942-4167-97EF-329831D73F6C@intel.com>
 <7a8f56c5-69aa-52ed-3889-810466f80137@ti.com>
 <7F0484D6-80AA-454B-B179-9FAC20D633FD@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <89d1cea2-ae1c-bc1c-0327-29a3334cba49@ti.com>
Date:   Mon, 10 Jun 2019 10:27:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <7F0484D6-80AA-454B-B179-9FAC20D633FD@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vedang,

On 06/07/2019 05:12 PM, Patel, Vedang wrote:
> Hi Murali,
> 
>> On Jun 7, 2019, at 11:52 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> On 06/04/2019 04:06 PM, Patel, Vedang wrote:
>>> Hi Murali,
>>>> On Jun 3, 2019, at 7:15 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>>>
>>>> Hi Vedang,
>>>>
>>>> On 05/28/2019 01:46 PM, Vedang Patel wrote:
>>>>> Currently, we are seeing non-critical packets being transmitted outside
>>>>> of their timeslice. We can confirm that the packets are being dequeued
>>>>> at the right time. So, the delay is induced in the hardware side.  The
>>>>> most likely reason is the hardware queues are starving the lower
>>>>> priority queues.
>>>>> In order to improve the performance of taprio, we will be making use of the
>>>>> txtime feature provided by the ETF qdisc. For all the packets which do not have
>>>>> the SO_TXTIME option set, taprio will set the transmit timestamp (set in
>>>>> skb->tstamp) in this mode. TAPrio Qdisc will ensure that the transmit time for
>>>>> the packet is set to when the gate is open. If SO_TXTIME is set, the TAPrio
>>>>> qdisc will validate whether the timestamp (in skb->tstamp) occurs when the gate
>>>>> corresponding to skb's traffic class is open.
>>>>> Following is the example configuration for enabling txtime offload:
>>>>> tc qdisc replace dev eth0 parent root handle 100 taprio \\
>>>>>        num_tc 3 \\
>>>>>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
>>>>>        queues 1@0 1@0 1@0 \\
>>>>>        base-time 1558653424279842568 \\
>>>>>        sched-entry S 01 300000 \\
>>>>>        sched-entry S 02 300000 \\
>>>>>        sched-entry S 04 400000 \\
>>>>>        offload 2 \\
>>>>>        txtime-delay 40000 \\
>>>>>        clockid CLOCK_TAI
>>>>> tc qdisc replace dev $IFACE parent 100:1 etf skip_sock_check \\
>>>>>        offload delta 200000 clockid CLOCK_TAI
>>>>> Here, the "offload" parameter is indicating that the TXTIME_OFFLOAD mode is
>>>>> enabled. Also, all the traffic classes are mapped to the same queue.  This is
>>>>> only possible in taprio when txtime offload is enabled. Also note that the ETF
>>>>> Qdisc is enabled with offload mode set.
>>>>> In this mode, if the packet's traffic class is open and the complete packet can
>>>>> be transmitted, taprio will try to transmit the packet immediately. This will
>>>>> be done by setting skb->tstamp to current_time + the time delta indicated in
>>>>> the txtime_delay parameter. This parameter indicates the time taken (in
>>>>> software) for packet to reach the network adapter.
>>>>
>>>> In TSN Time aware shaper, packets are sent when gate for a specific
>>>> traffic class is open. So packets that are available in the queues are
>>>> sent by the scheduler. So the ETF is not strictly required for this
>>>> function.
>>>> I understand if the application needs to send packets with
>>>> some latency expectation should use ETF to schedule the packet in sync
>>>> with the next gate open time. So txtime_delay is used to account for
>>>> the delay for packets to travel from user space to nic.
>>> This is not true. As explained in the other email, txtime-delay is the maximum time a packet might take after reaching taprio_enqueue() assuming the gate corresponding to that packet was already open.
>>>> So it is ETF
>>>> that need to inspect the skb->tstamp and allow or if time match or
>>>> discard if late. Is this the case?
>>>>
>>> The role of ETF is just to sort packets according to their transmit timestamp and send them to the hardware queues to transmit whenever their time comes. This is needed because the i210 hardware does not have any sort feature within its queue. If 2 packets arrive and the first packet has a transmit timestamp later than the second packet, the second packet won’t be transmitted on time.
>>> Taprio in the txtime offload mode (btw, this will soon be renamed to txtime-assist) will set the transmit timestamp of each packet (in skb->tstamp) and then send it to ETF so that it can be sorted with the other packets and sent to hardware whenever the time comes. ETF will discard the packet if the transmit time is in the past or before the transmit time of the packet which is already been sent to the hardware.
>>> Let me know if you have more questions about this.
>>
>> It is bit confusing to have this mode in taprio. My assumption is
>> that taprio implements TSN standard 802.1Qbv scheduler that is
>> responsible for managing the Gate open/close and sending frames
>> for specific traffic class during the Gate open. AFAIK, this
>> scheduler doesn't inspect the packet's metadata such as time to
>> send or such. So why is txtime offload mode is added to taprio?
>> Could you please explain?
>>
>> Murali
>>
> Short answer: Taprio still implements a 802.1Qbv like schedule. But, it leverages the functionality from ETF to do so.
> 
> Long answer:
> The software-only implementation of 802.1Qbv has quite a few low priority packets being transmitted outside their timeslice. This is because the higher priority queues in i210 are starving the lower priority queues. So, what the txtime-assist mode does is to assign an explicit tx timestamp and use the launchtime feature of the i210 adapter card to transmit the packets on time. It is still sending frames for a particular traffic class only when their gate is open. Also, it is not modifying any data in the packet which is transmitted. Just notifying the NIC when to transmit the packet. If there is a tx timestamp already assigned to a packet, it does not change it. Since we are assigning the tx timestamp, we have to route the packet through the ETF queue disc for sorting the packets according to their timestamps and sending it to the NIC.
> 
> We have to implement the above mechanism because, currently, we do not have the capability to offload the taprio schedule to the hardware.
> 
Ok, Thanks for the patience and explanation. Yes, it helps.

One last question. If your hardware i210 checks the time in a packet
and finds it is  late, does it drop the packet? I understand that
txtime-delay is for tuning this such that hardware see the packet on
time and transmit. I also understand that packets get dropped
at the ETF qdisc if late.

Murali
> Hope this makes things a bit more clear. Let me know if you have more questions.
> 
> Thanks,
> Vedang
>>> Thanks,
>>> Vedang
>>>> For offload case, the h/w that offload ETF needs to send a trigger to
>>>> software to get packet for transmission ahead of the Gate open event?
>>>>
>>>> Thanks
>>>>
>>>> Murali
>>>>> If the packet cannot be transmitted in the current interval or if the packet's
>>>>> traffic is not currently transmitting, the skb->tstamp is set to the next
>>>>> available timestamp value. This is tracked in the next_launchtime parameter in
>>>>> the struct sched_entry.
>>>>> The behaviour w.r.t admin and oper schedules is not changed from what is
>>>>> present in software mode.
>>>>> The transmit time is already known in advance. So, we do not need the HR timers
>>>>> to advance the schedule and wakeup the dequeue side of taprio.  So, HR timer
>>>>> won't be run when this mode is enabled.
>>>>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>>>>> ---
>>>>>   include/uapi/linux/pkt_sched.h |   1 +
>>>>>   net/sched/sch_taprio.c         | 326 ++++++++++++++++++++++++++++++---
>>>>>   2 files changed, 306 insertions(+), 21 deletions(-)
>>>>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>>>>> index 3319255ffa25..afffda24e055 100644
>>>>> --- a/include/uapi/linux/pkt_sched.h
>>>>> +++ b/include/uapi/linux/pkt_sched.h
>>>>> @@ -1174,6 +1174,7 @@ enum {
>>>>>   	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
>>>>>   	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
>>>>>   	TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, /* u32 */
>>>>> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
>>>>>   	__TCA_TAPRIO_ATTR_MAX,
>>>>>   };
>>>>>   diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>>>>> index 8d87ba099130..1cd19eabc53b 100644
>>>>> --- a/net/sched/sch_taprio.c
>>>>> +++ b/net/sched/sch_taprio.c
>>>>> @@ -21,6 +21,7 @@
>>>>>   #include <net/pkt_sched.h>
>>>>>   #include <net/pkt_cls.h>
>>>>>   #include <net/sch_generic.h>
>>>>> +#include <net/sock.h>
>>>>>     static LIST_HEAD(taprio_list);
>>>>>   static DEFINE_SPINLOCK(taprio_list_lock);
>>>>> @@ -40,6 +41,7 @@ struct sched_entry {
>>>>>   	 * packet leaves after this time.
>>>>>   	 */
>>>>>   	ktime_t close_time;
>>>>> +	ktime_t next_txtime;
>>>>>   	atomic_t budget;
>>>>>   	int index;
>>>>>   	u32 gate_mask;
>>>>> @@ -76,6 +78,7 @@ struct taprio_sched {
>>>>>   	struct sk_buff *(*peek)(struct Qdisc *sch);
>>>>>   	struct hrtimer advance_timer;
>>>>>   	struct list_head taprio_list;
>>>>> +	int txtime_delay;
>>>>>   };
>>>>>     static ktime_t sched_base_time(const struct sched_gate_list *sched)
>>>>> @@ -116,6 +119,235 @@ static void switch_schedules(struct taprio_sched *q,
>>>>>   	*admin = NULL;
>>>>>   }
>>>>>   +/* Get how much time has been already elapsed in the current cycle. */
>>>>> +static inline s32 get_cycle_time_elapsed(struct sched_gate_list *sched, ktime_t time)
>>>>> +{
>>>>> +	ktime_t time_since_sched_start;
>>>>> +	s32 time_elapsed;
>>>>> +
>>>>> +	time_since_sched_start = ktime_sub(time, sched->base_time);
>>>>> +	div_s64_rem(time_since_sched_start, sched->cycle_time, &time_elapsed);
>>>>> +
>>>>> +	return time_elapsed;
>>>>> +}
>>>>> +
>>>>> +static ktime_t get_interval_end_time(struct sched_gate_list *sched,
>>>>> +				     struct sched_gate_list *admin,
>>>>> +				     struct sched_entry *entry,
>>>>> +				     ktime_t intv_start)
>>>>> +{
>>>>> +	s32 cycle_elapsed = get_cycle_time_elapsed(sched, intv_start);
>>>>> +	ktime_t intv_end, cycle_ext_end, cycle_end;
>>>>> +
>>>>> +	cycle_end = ktime_add_ns(intv_start, sched->cycle_time - cycle_elapsed);
>>>>> +	intv_end = ktime_add_ns(intv_start, entry->interval);
>>>>> +	cycle_ext_end = ktime_add(cycle_end, sched->cycle_time_extension);
>>>>> +
>>>>> +	if (ktime_before(intv_end, cycle_end))
>>>>> +		return intv_end;
>>>>> +	else if (admin && admin != sched &&
>>>>> +		 ktime_after(admin->base_time, cycle_end) &&
>>>>> +		 ktime_before(admin->base_time, cycle_ext_end))
>>>>> +		return admin->base_time;
>>>>> +	else
>>>>> +		return cycle_end;
>>>>> +}
>>>>> +
>>>>> +static inline int length_to_duration(struct taprio_sched *q, int len)
>>>>> +{
>>>>> +	return (len * atomic64_read(&q->picos_per_byte)) / 1000;
>>>>> +}
>>>>> +
>>>>> +/* Returns the entry corresponding to next available interval. If
>>>>> + * validate_interval is set, it only validates whether the timestamp occurs
>>>>> + * when the gate corresponding to the skb's traffic class is open.
>>>>> + */
>>>>> +static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
>>>>> +						  struct Qdisc *sch,
>>>>> +						  struct sched_gate_list *sched,
>>>>> +						  struct sched_gate_list *admin,
>>>>> +						  ktime_t time,
>>>>> +						  ktime_t *interval_start,
>>>>> +						  ktime_t *interval_end,
>>>>> +						  bool validate_interval)
>>>>> +{
>>>>> +	ktime_t curr_intv_start, curr_intv_end, cycle_end, packet_transmit_time;
>>>>> +	ktime_t earliest_txtime = KTIME_MAX, txtime, cycle, transmit_end_time;
>>>>> +	struct sched_entry *entry = NULL, *entry_found = NULL;
>>>>> +	struct taprio_sched *q = qdisc_priv(sch);
>>>>> +	struct net_device *dev = qdisc_dev(sch);
>>>>> +	int tc, entry_available = 0, n;
>>>>> +	s32 cycle_elapsed;
>>>>> +
>>>>> +	tc = netdev_get_prio_tc_map(dev, skb->priority);
>>>>> +	packet_transmit_time = length_to_duration(q, qdisc_pkt_len(skb));
>>>>> +
>>>>> +	*interval_start = 0;
>>>>> +	*interval_end = 0;
>>>>> +
>>>>> +	if (!sched)
>>>>> +		return NULL;
>>>>> +
>>>>> +	cycle = sched->cycle_time;
>>>>> +	cycle_elapsed = get_cycle_time_elapsed(sched, time);
>>>>> +	curr_intv_end = ktime_sub_ns(time, cycle_elapsed);
>>>>> +	cycle_end = ktime_add_ns(curr_intv_end, cycle);
>>>>> +
>>>>> +	list_for_each_entry(entry, &sched->entries, list) {
>>>>> +		curr_intv_start = curr_intv_end;
>>>>> +		curr_intv_end = get_interval_end_time(sched, admin, entry,
>>>>> +						      curr_intv_start);
>>>>> +
>>>>> +		if (ktime_after(curr_intv_start, cycle_end))
>>>>> +			break;
>>>>> +
>>>>> +		if (!(entry->gate_mask & BIT(tc)) ||
>>>>> +		    packet_transmit_time > entry->interval)
>>>>> +			continue;
>>>>> +
>>>>> +		txtime = entry->next_txtime;
>>>>> +
>>>>> +		if (ktime_before(txtime, time) || validate_interval) {
>>>>> +			transmit_end_time = ktime_add_ns(time, packet_transmit_time);
>>>>> +			if ((ktime_before(curr_intv_start, time) &&
>>>>> +			     ktime_before(transmit_end_time, curr_intv_end)) ||
>>>>> +			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
>>>>> +				entry_found = entry;
>>>>> +				*interval_start = curr_intv_start;
>>>>> +				*interval_end = curr_intv_end;
>>>>> +				break;
>>>>> +			} else if (!entry_available && !validate_interval) {
>>>>> +				/* Here, we are just trying to find out the
>>>>> +				 * first available interval in the next cycle.
>>>>> +				 */
>>>>> +				entry_available = 1;
>>>>> +				entry_found = entry;
>>>>> +				*interval_start = ktime_add_ns(curr_intv_start, cycle);
>>>>> +				*interval_end = ktime_add_ns(curr_intv_end, cycle);
>>>>> +			}
>>>>> +		} else if (ktime_before(txtime, earliest_txtime) &&
>>>>> +			   !entry_available) {
>>>>> +			earliest_txtime = txtime;
>>>>> +			entry_found = entry;
>>>>> +			n = div_s64(ktime_sub(txtime, curr_intv_start), cycle);
>>>>> +			*interval_start = ktime_add(curr_intv_start, n * cycle);
>>>>> +			*interval_end = ktime_add(curr_intv_end, n * cycle);
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	return entry_found;
>>>>> +}
>>>>> +
>>>>> +static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
>>>>> +{
>>>>> +	struct taprio_sched *q = qdisc_priv(sch);
>>>>> +	struct sched_gate_list *sched, *admin;
>>>>> +	ktime_t interval_start, interval_end;
>>>>> +	struct sched_entry *entry;
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +	sched = rcu_dereference(q->oper_sched);
>>>>> +	admin = rcu_dereference(q->admin_sched);
>>>>> +
>>>>> +	entry = find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
>>>>> +				       &interval_start, &interval_end, true);
>>>>> +	rcu_read_unlock();
>>>>> +
>>>>> +	return entry;
>>>>> +}
>>>>> +
>>>>> +static inline ktime_t get_cycle_start(struct sched_gate_list *sched,
>>>>> +				      ktime_t time)
>>>>> +{
>>>>> +	ktime_t cycle_elapsed;
>>>>> +
>>>>> +	cycle_elapsed = get_cycle_time_elapsed(sched, time);
>>>>> +
>>>>> +	return ktime_sub(time, cycle_elapsed);
>>>>> +}
>>>>> +
>>>>> +/* There are a few scenarios where we will have to modify the txtime from
>>>>> + * what is read from next_txtime in sched_entry. They are:
>>>>> + * 1. If txtime is in the past,
>>>>> + *    a. The gate for the traffic class is currently open and packet can be
>>>>> + *       transmitted before it closes, schedule the packet right away.
>>>>> + *    b. If the gate corresponding to the traffic class is going to open later
>>>>> + *       in the cycle, set the txtime of packet to the interval start.
>>>>> + * 2. If txtime is in the future, there are packets corresponding to the
>>>>> + *    current traffic class waiting to be transmitted. So, the following
>>>>> + *    possibilities exist:
>>>>> + *    a. We can transmit the packet before the window containing the txtime
>>>>> + *       closes.
>>>>> + *    b. The window might close before the transmission can be completed
>>>>> + *       successfully. So, schedule the packet in the next open window.
>>>>> + */
>>>>> +static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
>>>>> +{
>>>>> +	ktime_t transmit_end_time, interval_end, interval_start;
>>>>> +	int len, packet_transmit_time, sched_changed;
>>>>> +	struct taprio_sched *q = qdisc_priv(sch);
>>>>> +	ktime_t minimum_time, now, txtime;
>>>>> +	struct sched_gate_list *sched, *admin;
>>>>> +	struct sched_entry *entry;
>>>>> +
>>>>> +	now = q->get_time();
>>>>> +	minimum_time = ktime_add_ns(now, q->txtime_delay);
>>>>> +
>>>>> +	rcu_read_lock();
>>>>> +	admin = rcu_dereference(q->admin_sched);
>>>>> +	sched = rcu_dereference(q->oper_sched);
>>>>> +	if (admin && ktime_after(minimum_time, admin->base_time))
>>>>> +		switch_schedules(q, &admin, &sched);
>>>>> +
>>>>> +	/* Until the schedule starts, all the queues are open */
>>>>> +	if (!sched || ktime_before(minimum_time, sched->base_time)) {
>>>>> +		txtime = minimum_time;
>>>>> +		goto done;
>>>>> +	}
>>>>> +
>>>>> +	len = qdisc_pkt_len(skb);
>>>>> +	packet_transmit_time = length_to_duration(q, len);
>>>>> +
>>>>> +	do {
>>>>> +		sched_changed = 0;
>>>>> +
>>>>> +		entry = find_entry_to_transmit(skb, sch, sched, admin,
>>>>> +					       minimum_time,
>>>>> +					       &interval_start, &interval_end,
>>>>> +					       false);
>>>>> +		if (!entry) {
>>>>> +			txtime = 0;
>>>>> +			goto done;
>>>>> +		}
>>>>> +
>>>>> +		txtime = entry->next_txtime;
>>>>> +		txtime = max_t(ktime_t, txtime, minimum_time);
>>>>> +		txtime = max_t(ktime_t, txtime, interval_start);
>>>>> +
>>>>> +		if (admin && admin != sched &&
>>>>> +		    ktime_after(txtime, admin->base_time)) {
>>>>> +			sched = admin;
>>>>> +			sched_changed = 1;
>>>>> +			continue;
>>>>> +		}
>>>>> +
>>>>> +		transmit_end_time = ktime_add(txtime, packet_transmit_time);
>>>>> +		minimum_time = transmit_end_time;
>>>>> +
>>>>> +		/* Update the txtime of current entry to the next time it's
>>>>> +		 * interval starts.
>>>>> +		 */
>>>>> +		if (ktime_after(transmit_end_time, interval_end))
>>>>> +			entry->next_txtime = ktime_add(interval_start, sched->cycle_time);
>>>>> +	} while (sched_changed || ktime_after(transmit_end_time, interval_end));
>>>>> +
>>>>> +	entry->next_txtime = transmit_end_time;
>>>>> +
>>>>> +done:
>>>>> +	rcu_read_unlock();
>>>>> +	return txtime;
>>>>> +}
>>>>> +
>>>>>   static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>>>>   			  struct sk_buff **to_free)
>>>>>   {
>>>>> @@ -129,6 +361,15 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>>>>   	if (unlikely(!child))
>>>>>   		return qdisc_drop(skb, sch, to_free);
>>>>>   +	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
>>>>> +		if (!is_valid_interval(skb, sch))
>>>>> +			return qdisc_drop(skb, sch, to_free);
>>>>> +	} else if (TXTIME_OFFLOAD_IS_ON(q->offload_flags)) {
>>>>> +		skb->tstamp = get_packet_txtime(skb, sch);
>>>>> +		if (!skb->tstamp)
>>>>> +			return qdisc_drop(skb, sch, to_free);
>>>>> +	}
>>>>> +
>>>>>   	qdisc_qstats_backlog_inc(sch, skb);
>>>>>   	sch->q.qlen++;
>>>>>   @@ -206,11 +447,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
>>>>>   	return q->peek(sch);
>>>>>   }
>>>>>   -static inline int length_to_duration(struct taprio_sched *q, int len)
>>>>> -{
>>>>> -	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
>>>>> -}
>>>>> -
>>>>>   static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
>>>>>   {
>>>>>   	atomic_set(&entry->budget,
>>>>> @@ -594,7 +830,8 @@ static int parse_taprio_schedule(struct nlattr **tb,
>>>>>     static int taprio_parse_mqprio_opt(struct net_device *dev,
>>>>>   				   struct tc_mqprio_qopt *qopt,
>>>>> -				   struct netlink_ext_ack *extack)
>>>>> +				   struct netlink_ext_ack *extack,
>>>>> +				   u32 offload_flags)
>>>>>   {
>>>>>   	int i, j;
>>>>>   @@ -642,6 +879,9 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
>>>>>   			return -EINVAL;
>>>>>   		}
>>>>>   +		if (TXTIME_OFFLOAD_IS_ON(offload_flags))
>>>>> +			continue;
>>>>> +
>>>>>   		/* Verify that the offset and counts do not overlap */
>>>>>   		for (j = i + 1; j < qopt->num_tc; j++) {
>>>>>   			if (last > qopt->offset[j]) {
>>>>> @@ -804,6 +1044,9 @@ static int taprio_enable_offload(struct net_device *dev,
>>>>>   	const struct net_device_ops *ops = dev->netdev_ops;
>>>>>   	int err = 0;
>>>>>   +	if (TXTIME_OFFLOAD_IS_ON(offload_flags))
>>>>> +		goto done;
>>>>> +
>>>>>   	if (!FULL_OFFLOAD_IS_ON(offload_flags)) {
>>>>>   		NL_SET_ERR_MSG(extack, "Offload mode is not supported");
>>>>>   		return -EOPNOTSUPP;
>>>>> @@ -816,15 +1059,28 @@ static int taprio_enable_offload(struct net_device *dev,
>>>>>     	/* FIXME: enable offloading */
>>>>>   -	q->dequeue = taprio_dequeue_offload;
>>>>> -	q->peek = taprio_peek_offload;
>>>>> -
>>>>> -	if (err == 0)
>>>>> +done:
>>>>> +	if (err == 0) {
>>>>> +		q->dequeue = taprio_dequeue_offload;
>>>>> +		q->peek = taprio_peek_offload;
>>>>>   		q->offload_flags = offload_flags;
>>>>> +	}
>>>>>     	return err;
>>>>>   }
>>>>>   +static void setup_txtime(struct taprio_sched *q,
>>>>> +			 struct sched_gate_list *sched, ktime_t base)
>>>>> +{
>>>>> +	struct sched_entry *entry;
>>>>> +	u32 interval = 0;
>>>>> +
>>>>> +	list_for_each_entry(entry, &sched->entries, list) {
>>>>> +		entry->next_txtime = ktime_add_ns(base, interval);
>>>>> +		interval += entry->interval;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>   static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>>>   			 struct netlink_ext_ack *extack)
>>>>>   {
>>>>> @@ -846,7 +1102,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>>>   	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
>>>>>   		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
>>>>>   -	err = taprio_parse_mqprio_opt(dev, mqprio, extack);
>>>>> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
>>>>> +		offload_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
>>>>> +
>>>>> +	err = taprio_parse_mqprio_opt(dev, mqprio, extack, offload_flags);
>>>>>   	if (err < 0)
>>>>>   		return err;
>>>>>   @@ -887,6 +1146,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>>>   		goto free_sched;
>>>>>   	}
>>>>>   +	/* preserve offload flags when changing the schedule. */
>>>>> +	if (q->offload_flags)
>>>>> +		offload_flags = q->offload_flags;
>>>>> +
>>>>>   	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
>>>>>   		clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
>>>>>   @@ -914,7 +1177,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>>>   	/* Protects against enqueue()/dequeue() */
>>>>>   	spin_lock_bh(qdisc_lock(sch));
>>>>>   -	if (!hrtimer_active(&q->advance_timer)) {
>>>>> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
>>>>> +		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
>>>>> +
>>>>> +	if (!TXTIME_OFFLOAD_IS_ON(offload_flags) && !hrtimer_active(&q->advance_timer)) {
>>>>>   		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
>>>>>   		q->advance_timer.function = advance_sched;
>>>>>   	}
>>>>> @@ -966,20 +1232,35 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>>>>   		goto unlock;
>>>>>   	}
>>>>>   -	setup_first_close_time(q, new_admin, start);
>>>>> +	if (TXTIME_OFFLOAD_IS_ON(offload_flags)) {
>>>>> +		setup_txtime(q, new_admin, start);
>>>>> +
>>>>> +		if (!oper) {
>>>>> +			rcu_assign_pointer(q->oper_sched, new_admin);
>>>>> +			err = 0;
>>>>> +			new_admin = NULL;
>>>>> +			goto unlock;
>>>>> +		}
>>>>> +
>>>>> +		rcu_assign_pointer(q->admin_sched, new_admin);
>>>>> +		if (admin)
>>>>> +			call_rcu(&admin->rcu, taprio_free_sched_cb);
>>>>> +	} else {
>>>>> +		setup_first_close_time(q, new_admin, start);
>>>>>   -	/* Protects against advance_sched() */
>>>>> -	spin_lock_irqsave(&q->current_entry_lock, flags);
>>>>> +		/* Protects against advance_sched() */
>>>>> +		spin_lock_irqsave(&q->current_entry_lock, flags);
>>>>>   -	taprio_start_sched(sch, start, new_admin);
>>>>> +		taprio_start_sched(sch, start, new_admin);
>>>>>   -	rcu_assign_pointer(q->admin_sched, new_admin);
>>>>> -	if (admin)
>>>>> -		call_rcu(&admin->rcu, taprio_free_sched_cb);
>>>>> -	new_admin = NULL;
>>>>> +		rcu_assign_pointer(q->admin_sched, new_admin);
>>>>> +		if (admin)
>>>>> +			call_rcu(&admin->rcu, taprio_free_sched_cb);
>>>>>   -	spin_unlock_irqrestore(&q->current_entry_lock, flags);
>>>>> +		spin_unlock_irqrestore(&q->current_entry_lock, flags);
>>>>> +	}
>>>>>   +	new_admin = NULL;
>>>>>   	err = 0;
>>>>>     unlock:
>>>>> @@ -1225,6 +1506,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>>>>>   	if (nla_put_u32(skb, TCA_TAPRIO_ATTR_OFFLOAD_FLAGS, q->offload_flags))
>>>>>   		goto options_error;
>>>>>   +	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
>>>>> +		goto options_error;
>>>>> +
>>>>>   	if (oper && dump_schedule(skb, oper))
>>>>>   		goto options_error;
> 

