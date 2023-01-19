Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B286739C0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjASNRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjASNRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:17:25 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476E74E9F;
        Thu, 19 Jan 2023 05:17:12 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JC8Fk4019769;
        Thu, 19 Jan 2023 12:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : from
 : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=LSgDCbkPP8IyruIRHQ5F4F8g0UlZeC+CR3fid/e7l2I=;
 b=tUs4E5FKQYDPlRhsz54bOFHgl125ZKWvAxrfNQmPUq4NYifS6kjYWyQOck1hAYjK0OZJ
 B6Yf0DjVEMMotOHfCChnooIsk8jPZK3g9NecFLI2hzaEvZqiS1IVJW45SR1ZZGgYyG70
 Sj/sXjFvShLmCiXdFUNAAa1mXu0LQ/7AhGDQEIZ6Uy1+JwuZKSzhmcaxlC2DzJNwdDTN
 NNcTXplxsRNgX24az7A16xEOlwocigQMNpWHetjQF4gB3Y1HeA5xUvH6dbIDN6wy5ofS
 BBpS1d55uvePp12usf4WpgtW2ta86CH/4Kx7PR0l8DcyVsmpJUyZ5tw6ku1ICfzNo1bI 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n758e8txn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 12:30:20 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JCNTGJ005410;
        Thu, 19 Jan 2023 12:30:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n758e8twq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 12:30:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J69nkF006209;
        Thu, 19 Jan 2023 12:30:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfpnx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 12:30:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JCUEsf39518584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 12:30:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43CBA20040;
        Thu, 19 Jan 2023 12:30:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10D0420043;
        Thu, 19 Jan 2023 12:30:14 +0000 (GMT)
Received: from [9.152.224.247] (unknown [9.152.224.247])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 12:30:14 +0000 (GMT)
Message-ID: <b9867c7d-bb2b-16fc-feda-b79579aa833d@linux.ibm.com>
Date:   Thu, 19 Jan 2023 13:30:13 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
From:   Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
To:     Wen Gu <guwen@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
 <4a9b0ff0-8f03-1bfd-d09c-6deb3a9bb39e@linux.alibaba.com>
 <4c7b0f4d-d57d-0aab-4ddd-6a4f15661e8d@linux.ibm.com>
 <b25f56de-7913-2a56-950f-dfe0defd6936@linux.alibaba.com>
 <bc4e55b9-ac35-3c71-104e-862fec958403@linux.ibm.com>
 <44209ace-1357-2387-f4ac-7c06f36319e5@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <44209ace-1357-2387-f4ac-7c06f36319e5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B20X2VMeF1VtHbPwJil6KpsHHa6c2YS1
X-Proofpoint-ORIG-GUID: u5vP5Xy0jrcuohFG_vI9-sjBpEh38JDw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190095
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.01.23 13:15, Wen Gu wrote:
> 
> 
> On 2023/1/16 19:01, Wenjia Zhang wrote:
>>
>>
>> On 12.01.23 13:12, Wen Gu wrote:
>>>
>>>
>>> On 2023/1/5 00:09, Alexandra Winter wrote:
>>>>
>>>>
>>>> On 21.12.22 14:14, Wen Gu wrote:
>>>>>
>>>>>
>>>>> On 2022/12/20 22:02, Niklas Schnelle wrote:
>>>>>
>>>>>> On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
[...]
>>>>>>>
>>>>>>> 2. Way to select different ISM-like devices
>>>>>>>
>>>>>>> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
>>>>>>> device used for inter-VM acceleration as update of [1], SMC-D has more
>>>>>>> options to choose from. So we need to consider that how to indicate
>>>>>>> supported devices, how to determine which one to use, and their priority...
>>>>>>
[...]
>>>>>>>
>>>>>>> IMHO, this may require an update of CLC message and negotiation mechanism.
>>>>>>> Again, we are very glad to discuss this with you on the mailing list.
>>>>
>>>> As described in
>>>> SMC protocol (including SMC-D): https://www.ibm.com/support/pages/system/files/inline-files/IBM%20Shared%20Memory%20Communications%20Version%202_2.pdf
>>>> the CLC messages provide a list of up to 8 ISM devices to chose from.
>>>> So I would hope that we can use the existing protocol.
>>>>
>>>> The challenge will be to define GID (Global Interface ID) and CHID (a fabric ID) in
>>>> a meaningful way for the new devices.
[...]
>>>
>>> I agree with your opinion. The existing SMC-Dv2 protocol whose CLC messages include
>>> ism_dev[] list can solve the devices negotiation problem. And I am very willing to use
>>> the existing protocol, because we all know that the protocol update is a long and complex
>>> process.
>>>
>>> If I understand correctly, SMC-D loopback(dummy) device can coordinate with existing
>>> SMC-Dv2 protocol as follows. If there is any mistake, please point out.
>>>
>>>
>>> # Initialization
>>>
>>> - Initialize the loopback device with unique GID [Q-1].

As you point out below [Q-1], the issue here is the uniqueness of the 8 byte GID
across all possible SMC peers (they could all offer loopback as a choice).

I was pondering some more about this and I am wondering, whether there is another
way to detect that source and target of the CLC proposal are the same Linux instance
(without using the content of the CLC message).
One idea could be:
If the netdev used for the CLC proposal is a local interface, then use smcd-loopback.
What do you think?

Let me try to summarize my pondering as a base for future discussion:

SMC CLC handshake as described in SMC protocol:
------------------------------------------------
The purpose of the handshake is to efficiently find out whether and how SMC can
be used to communicate with a TCP peer (happens over a standard netdevice).
For this purpose the following fields are exchanged:

+ UEID – (32 byte) Defined per system (OS instance).
     User defined group of systems that should use SMC between each other.
     If the peer has only different UEIDs: Don’t try to use SMC with this peer.

+ SEID – (32 byte) Defined per system.
    Maximum space of systems that are able to use SMC-D between each other.
    Equals to the machine hardware / first level hypervisor.
    (in s390 KVM is at least the second level hipervisor)
    Is unique per machine, derived from unique machine ID.
    If the peer has a different SEIDs: Don’t try to use SMC-D with this peer.

+ CHID – (2 Bytes) Defined per SMC-D interface.
    Fabric ID of this interface. Unique against other fabrics on this machine. 
    Try to find a pair of SMC-D interfaces on the same fabric for the 2 peers
    to use for this SMC-D connection.

+ GID – (8 bytes) Defined per SMC-D interface.
    ID of this interface.
    For s390 ISM is actually globally unique. But for SMC-D protocol purpose
    just needs to be unique within the CHID (fabric).
    Use it to identify the chosen interfaces of the 2 peers.

Important usecases:
As the CLC handshake is exchanged via standard netdevice, the 2 peers can be: 
- on different machines
- on same machine but different first level guest
- on same KVM host but different KVM guest,
- on same KVM guest (loopback case) 

and the proposal list can include any combination of:
- one or more RDMA devices (to use with SMC-R)
- one or more s390 ISM devices on one or more CHIDs
- future: virtio-smcd interface(s)


So for loopback there are 2 options to think about, that can be implemented
with today’s SMC-D protocol definition:
 
(1) Smc-d Loopback is listed in the SMC-D proposal list

Loopback could be one interface in the SMC-Dv2 list of up to 8 CHID/GID pairs proposed.
We could use CHID 0xFFFF to point out this is a loopback.
And then only use this GID, if it belongs to both peers. (this is may be a small
add-on to today's protocol)
CON: This requires a unique loopback-GID for every OS instance (on this SEID).
Must also be unique against any other OS that would ever implement SMC-D
loopback, because this could be a handshake with any OS on this SEID.
PRO: It works in all cases where SMC works today.
 
(2)Find out that both peers of the CLC handshake are actually the same
Linux instance, without using the values of the proposal

One idea is that if a local netdev is used for the handshake, then we are in
the same instance.
CON: I guess this should work, but may not cover all usecases, where
smcd-loopback could be desired. (namespaces, etc..)
I still have some hope that there is another way to detect this somehow…
ideas are very welcome.
PRO: This is independent of the SMC protocol. It would be a Linux-only solution, 
actually even *this* Linux only, future implementations could differ.

>>>
>>> - Register the loopback device as SMC-Dv2-capable device with a system_eid whose 24th
>>>     or 28th byte is non-zero [Q-2], so that this system's smc_ism_v2_capable will be set
>>>     to TRUE and SMC-Dv2 is available.
>>>
>> The decision point is the VLAN_ID, if it is x1FFF, the device will support V2. i.e. If you can have subnet with VLAN_ID x1FFF, then the SEID is necessary, so that the series or types is non-zero. (*1)
> 

I guess there is some misunderstanding of today's code.
The invalid VLAN_ID 0x1FFF is used to signal to s390 ISM hardware that SMC-Dv2 is used, where
the CLC handshake does not have to be between peers on the same IP subnet.
If we cannot set x1FFF, then this is old hardware and we have to use SMC-Dv1 on this machine.
(all ISM interfaces are same hardware level).
If we can use SMC-Dv2 then we need to determine the SEID of this machine, so we can use it 
in the CLC handshake. (if we run on v1 hardware, there is no need to determine the SEID)

> In case there is any misunderstanding between us, I would like to rephrase my [Q-2] question:
> 
> int smcd_register_dev(struct smcd_dev *smcd)
> {
>     <...>
>     mutex_lock(&smcd_dev_list.mutex);
>     if (list_empty(&smcd_dev_list.list)) {
>         u8 *system_eid = NULL;
> 
>         smcd->ops->get_system_eid(smcd, &system_eid);
>         if (system_eid[24] != '0' || system_eid[28] != '0') {
>             smc_ism_v2_capable = true;
>             memcpy(smc_ism_v2_system_eid, system_eid,
>                    SMC_MAX_EID_LEN);
>         }
>     }
>     <...>
> }
> 
> It can be inferred from smcd_register_dev() that:
> 
> 1) The 24th and 28th byte are special and determinate whether smc_ism_v2_capable is true.
>    Besides these, do other bytes of system_eid have hidden meanings that need attention ?
> 
> 2) Only when smcd_dev_list is empty, the added smcd_dev will be checked, and its system_eid
>    determinates whether smc_ism_v2_capable is true. Why only the first added device will be
>    checked ?
> 
>    If the first added smcd_dev has an system_eid whose 24th and 28th bytes are zero, and the
>    second added smcd_dev has an system_eid whose 24th and 28th bytes are non-zero. Should
>    smc_ism_v2_capable be true, since the second smcd_dev has v2-indicated system_eid ?
> 


This was a rather indirect way to determine smc_ism_v2_capable,
which is improved in the ism patches currently under review.

>>>
>>> # Proposal
>>>
>>> - Find the loopback device from the smcd_dev_list in smc_find_ism_v2_device_clnt();
>>>
>>> - Record the SEID, GID and CHID[Q-3] of loopback device in the v2 extension part of CLC
>>>     proposal message.
>>>
>>>
>>> # Accept
>>>
>>> - Check the GID/CHID list and SEID in CLC proposal message, and find local matched ISM
>>>     device from smcd_dev_list in smc_find_ism_v2_device_serv(). If both sides of the
>>>     communication are in the same VM and share the same loopback device, the SEID, GID and
>>>     CHID will match and loopback device will be chosen [Q-4].
>>>
>>> - Record the loopback device's GID/CHID and matched SEID into CLC accept message.
>>>
>>>
>>> # Confirm
>>>
>>> - Confirm the server-selected device (loopback device) accordingto CLC accept messages.
>>>
>>> - Record the loopback device's GID/CHID and server-selected SEID in CLC confirm message.
>>>
>>>
>>> Follow the above process, I supplement a patch based on this RFC in the email attachment.
>>> With the attachment patch, SMC-D loopback will switch to use SMC-Dv2 protocol.
>>>
>>>
>>>
>>> And in the above process, there are something I want to consult and discuss, which is marked
>>> with '[Q-*]' in the above description.
>>>
>>> # [Q-1]:
>>>
>>> The GID of loopback device is randomly generated in this RFC patch set, but I will find a way
>>> to unique the GID in formal patches. Any suggestions are welcome.
>>>
>> I think the randowmly generated GID is fine in your case, which is equivalent to the IP address.
> 
> Since whether the two sides can communicate through the loopback will be judged by whether the
> gid of their loopback device is equal, the random GID may bring the risk of misjudgment because
> it may not be unique. But considering this is an RFC, I simply used random GIDs.

I share your concerns about using random 8 byte numbers for all possible instances.
Collisions may be unlikely, but if they happen, they cannot be detected and have nasty effects.

> 
>>>
>>> # [Q-2]:
>>>
>>> In Linux implementation, the system_eid of the first registered smcd device will determinate
>>> system's smc_ism_v2_capable (see smcd_register_dev()).

See above, this is a rather indirect correlation.

>>>
>>> And I wonder that
>>>
>>> 1) How to define the system_eid? It can be inferred from the code that the 24th and 28th byte
>>>      are special for SMC-Dv2. So in attachment patch, I define the loopback device SEID as
>>>
>>>      static struct smc_lo_systemeid LO_SYSTEM_EID = {
>>>              .seid_string = "SMC-SYSZ-LOSEID000000000",
>>>              .serial_number = "1000",
>>>              .type = "1000",
>>>      };
>>>
>>>      Is there anything else I need to pay attention to?
>>>
>> If you just want to use V2, such defination looks good.
>> e.g. you can use some unique information from "lshw"
> 
> OK, thank you.
> 

As mentioned above:
+ SEID – (32 byte) Defined per system.
    Maximum space of systems that are able to use SMC-D between each other.
    Equals to the machine hardware / first level hypervisor.
    (in s390 KVM is at least the second level hipervisor)
    Is unique per machine, derived from unique machine ID.
    If the peer has a different SEIDs: Don’t try to use SMC-D with this peer.

We need to continue to use today's values on s390 architecture for backward compatibility!
Other architectures need to also use values that uniquely identify the machine it is
running on.

>>>
>>> 2) Seems only the first added smcd device determinate the system smc_ism_v2_capable? If two
>>>      different smcd devices respectively with v1-indicated and v2-indicated system_eid, will
>>>      the order in which they are registered affects the result of smc_ism_v2_capable ?
>>>
>> see (*1)

see above: all s390 ISM interfaces on a machine are same hardware level.

>>>
>>> # [Q-3]:
>>>
>>> In attachment patch, I define a special CHID (0xFFFF) for loopback device, as a kind of
>>> 'unassociated ISM CHID' that not associated with any IP (OSA or HiperSockets) interfaces.
>>>
>>> What's your opinion about this?
>>>
>> It looks good to me
> 
> OK.

This maybe a small add-on to today's protocol, as a special CHID number that is evaluated
differently. But IMHO it would fit with the purpose of the VHCID/GID pairs.
0xFFFF cannot appear on today's s390ISM CHIDs. So this could be backwards compatible.

> 
>>>
>>> # [Q-4]:
>>>
>>> In current Linux implementation, server will select the first successfully initialized device
>>> from the candidates as the final selected one in smc_find_ism_v2_device_serv().
>>>
>>> for (i = 0; i < matches; i++) {
>>>      ini->smcd_version = SMC_V2;
>>>      ini->is_smcd = true;
>>>      ini->ism_selected = i;
>>>      rc = smc_listen_ism_init(new_smc, ini);
>>>      if (rc) {
>>>          smc_find_ism_store_rc(rc, ini);
>>>          /* try next active ISM device */
>>>          continue;
>>>      }
>>>      return; /* matching and usable V2 ISM device found */
>>> }
>>>
>>> IMHO, maybe candidate devices should have different priorities? For example, the loopback device
>>> may be preferred to use if loopback is available.
>>>
>> IMO, I'd prefer such a order: ISM -> loopback -> RoCE
>> Because ISM for SMC-D is our standard user case, not loopback.
> 
> OK, will follow this order.

My initial thought would be: loopback -> ISM -> RoCE,
just as it is for netdev loopback. 
But that only makes sense if loopback performs better than ISM.
Can we postpone that decision until we have measurements?


