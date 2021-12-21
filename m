Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E67E47C97B
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhLUXHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:07:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23102 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235079AbhLUXHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:07:37 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BLJ0uER007454;
        Tue, 21 Dec 2021 15:07:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=5lPZqm5Xs7+kHVs9uMqPUi0Y2b7OLoGdxP8KFyzac6g=;
 b=LZxFVLYRKyXJk8mPL/od4OqlS0v9DZPkfnxXZdA3OktFBDJoFMk0TyvBXbqqjBOXcb5A
 XMe++38ePsBkUFQ0zZhkTFnhGkRySmXHr8Jrh7Dnw8LghHVlDKfLkv2D2L6K2xBIexdT
 YY4vc4DHg77mbNqZ0gS54QR/mobZA2i8wkk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d3mq3hpmn-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 15:07:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:07:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbJSj5NlYqeH4Vi2EMawQkLtfGPfCMkQmpeGqJhakpR6WcDu2s4SSVSlxmw8hwnLZr35UwxbT3TEPnvNSulbHFPPPZgFptChJY+1YKIlih9mVUGSC+l/iLXrHY1iZ47ZwNvEVoMYWBDu4YZKLsMDvPkcA1igq9zeVZQY90NtCkdP+qgxLrMAAVnaCTVx/d3TmZfDKFAJg7cLEoOrc+/Ly7uPtyGkU9AC8Ngey2QHbb9iGrSENvkA81+9R8tKsRKj4/knQypXjf68sVGyXCRrIT2LCFIaDd50rIc6l59u8sosm6kbOMC90G8Ww8E/MEZo0PBFDwdlcEhM6RQ2fSwg0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lPZqm5Xs7+kHVs9uMqPUi0Y2b7OLoGdxP8KFyzac6g=;
 b=O+2vz++VWITKmbSUX+VnpAgYlPuQSUdIiLXN1nVw5i2RDYLWEOQKa5PrfaSgE8cR4Wrf+BhzS7RhX2dAr+GlWq/A/3riZnfomD4v1RfsPMUnOOBQTdWLrQb4CmFFVavyFTr2ay+DkB9BpPhsCYf4UcJpSAEsbKKp1NHu08DPzpuMtcXTmCVZPJ4wD8d355ckD/XloWLEuUdT/8SdRsDID7uRK6Tk9m3FoHUWd33vTOdTsOWCbSj3GMqPn68p4pAuJcjMNCD8TSbeiYWVUd75g/CaG0vs1O4HnBS3zcuuHTh0kByBAvwfeitf6NSaU/FbTwHBEKNbe9sFmyDWHVYQkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5013.namprd15.prod.outlook.com (2603:10b6:806:1d8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Tue, 21 Dec
 2021 23:07:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 23:07:28 +0000
Date:   Tue, 21 Dec 2021 15:07:25 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] Bpf Helper Function BPF_FUNC_skb_change_dsfield
Message-ID: <20211221230725.mm5ycvkof3sgihh6@kafai-mbp.dhcp.thefacebook.com>
References: <20211220204034.24443-1-quic_twear@quicinc.com>
 <41e6f9da-a375-3e72-aed3-f3b76b134d9b@fb.com>
 <20211221061652.n4f47xh67uxqq5p4@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB5238740A681CD4E64D1EE0F0AA7C9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <CANP3RGeNVSwSfb9T_6Xp8GyggbwnY7YQjv1Fw5L2wTtqiFJbpw@mail.gmail.com>
 <20211221215227.4kpw65oeusfskenx@kafai-mbp.dhcp.thefacebook.com>
 <CANP3RGdbYsue7xiYgVavnq2ysg6N6bWpFKnHxg4YkpQF9gv4oA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGdbYsue7xiYgVavnq2ysg6N6bWpFKnHxg4YkpQF9gv4oA@mail.gmail.com>
X-ClientProxiedBy: MWHPR1401CA0004.namprd14.prod.outlook.com
 (2603:10b6:301:4b::14) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da6756c9-5688-40b0-3d60-08d9c4d6a89b
X-MS-TrafficTypeDiagnostic: SA1PR15MB5013:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB50138A03704ACD19D0FD59DCD57C9@SA1PR15MB5013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EskZhj/9lhuemN8FR17kY1Bjm5os5UNejg5r3Q1oAZ0Q3AYD4zepo8hJz7Fwnc5skjfN3zCoQ8+6sF33Pr01anO584rbTedzEnNndpcvGltBZ+IZCiMrZEqXlODtDUzaX4Rh+eTDMYmPEuvAyH8Mx7AbrWTXvNWbeGJ8q/W1yoxKDGEVUGDi6R2vIYePw3ENcsZV8S5mEYza3/5gIUUFigIVQW5y9We5aTkZWXpsU+DTARmlgJnXm0yoeiX21Fvyah/Z03THDGjMle545FHpYXCbNpJNisKADboJutY6/TpYm1ivxUuCZ7iN0zA9vNy5OjWZC1fmKFdXpRXdt4NQI/xPJSmfOxifzvzm8F318eaa635BsIlkGQK9N1Akv7t9Xy6vlDASOE+rEwmebeKgH1wJZfIvVewxuUG2dw0s5OzvUrdb7JJZXZMc6mKjrXWTVv5rcStT58ds2acXQCXivvC0imAl37+PUMQqrOlI5UpSE39ZWn92mee8F/Qy3K5EL4FbEN2EEXdvJguq2oymBnGo4nYqR88zfhlqP6ZdYJR2VAcDa7XoHcVjJub8UisDgbm+JLOCbmiHc0VQx7y+TtjiKEnCFSB+tWqo5Mu/yNICE/Ie1kkCXnwH0kTR5nQlllaDgrae15JcsLrUOrFsTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(1076003)(6666004)(66946007)(9686003)(5660300002)(6916009)(2906002)(52116002)(54906003)(6512007)(66556008)(6486002)(86362001)(4326008)(508600001)(38100700002)(8936002)(66574015)(6506007)(186003)(8676002)(83380400001)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2VjQ2V2OEVmOFU0YUhPQksrc0tsb2Z5b3pQRHVReXdrVlJNaVNSWWZUMWdB?=
 =?utf-8?B?L3cwQnpsU3RNVmwybnJtYzhjRTZLVGdXaDBOUEcwNWpySDl5ZUllazhvNzZH?=
 =?utf-8?B?Z1V2bm9sclhHa2xCdzVHODIwOWpad01NZ2NGTDIweDBlMkZsUU8yY0UwWml3?=
 =?utf-8?B?T3NqamJVRUp4OGtVdlJML05mSEVnNmRtekRjZE15THREaHNMcisyeVlJRmt4?=
 =?utf-8?B?OG5oZHZhZnpubEVvaHF4cTEvQk1udjRaVVp0djUvN0hIb084bnQ1U1hnS3p5?=
 =?utf-8?B?MFplb0RBZmdQL1p5NWVUV1dXZTVzU2s5YWZZTU5qckVHYnNqOEdEU0FkN3p3?=
 =?utf-8?B?bTFxdzdhQ3M5bzFXYXhIZzRUQXRkYkJjTWtPdElITGREeWhIZW5NSVl0ZjA3?=
 =?utf-8?B?SW5sb1UxWE5mUFMrNXNrZXNkWUVPQWlwQ3hCblJjZzNSU1YzbXg2Z3FsSVBw?=
 =?utf-8?B?dWZJVkZKa094VjlGQy9sWFFzTlNHNEpHSU8vWkcwY1FjMXprTWlDU1I5UlJ3?=
 =?utf-8?B?MzFpL1FKT3Z4SldMamluTkwwc3RmVUV3UFgzRGtGK0ZpMUZpWWZxK0d2bHIy?=
 =?utf-8?B?bE5DRElRdUlUbG5aRndvckJzamN0N21VUE5WaHVla0pOa2c2MCtLNGhIQWdj?=
 =?utf-8?B?YmNHU2Vob2ZQMG1SM3pMZ09JWFo5aXZycXNHT3JsTDJhUTRVbFlEcThBTHZo?=
 =?utf-8?B?d3A4Z1daUlFWWGxMNTVZb2tlTDAycjZHY1A4ZzJaT3F6N3E4NWJyUEExUHlN?=
 =?utf-8?B?dlZOWkppTzd2a0lHTWVhRVFCeXpDaHpnaFIvUzU4QmNSRWIwUUVKVjJ4Ykxu?=
 =?utf-8?B?MXlNVnZuN1Z4cnI1eE55bktoU21YNk1BTm1xcHcrb0Q0d2RrdTN3UFZueUxB?=
 =?utf-8?B?QXdsU2l4SUM2QVBIcGdDT0FDdWNnOXlhM211Mms1Nk1ROUtjWGJUK2ZrKzlu?=
 =?utf-8?B?UTRnMzFldXkwbFN5L0gwcGtqSmJFaHR2VjhBMVBLL0lKbmprYkl2aDg3WjNC?=
 =?utf-8?B?RDZoUVFFMUlMU0V5QStoa0RFN3NzVHRJci9DRDVzM29Hb1NmSWo2YitJUXRH?=
 =?utf-8?B?a2drcklCZ21JYjA2WFl3Z1MwSXYzdjRHNHFXWllmNFV4Q29sSzdHUUdwckdt?=
 =?utf-8?B?Um5lT2pOeHpISE12NVFXMG44WEREa1VWRWdMZXdLMUJuNmlGM3o5Nlh1WkNn?=
 =?utf-8?B?QW90S1NXdFJ6L1EzNFZ2WE9aYktuTStFREJYdzlNUGtsckhjQmhiYnJjSXZz?=
 =?utf-8?B?OFpUazE5ellUNjVjVjJJUjhMcDFtY1E4eEtlMDlMN0pVMytpNG5heHVXVkJ0?=
 =?utf-8?B?MGExS1AyZUJuSmo0K1pkSm5GKzdUODkxcDZTTHQrRVZZK1dQMlJ2Z1VaZXkz?=
 =?utf-8?B?RjFlaUlrQjJpYUI1NWdUQ3hyWHkvS0NqcUxYM3liS1o5OW5WblB1Q1JwVjRJ?=
 =?utf-8?B?d2Jmb1hVcW1iWW5QN0FKMTZ6SnRxYjdESVNuTUwrQzVqTDQyT09NS29HcGtH?=
 =?utf-8?B?Z1JmOFpudk5EUEsxOVRyNytpZEozZ0ZYR1J3V20yTVdjcUc5Ty9JNVVwL1lY?=
 =?utf-8?B?Y3BsRVhIOG03TVg0THZjSVJxT25qWm44cTZwMmU2VTIyUDR0WnJJTzZncVk2?=
 =?utf-8?B?WGIvVXVxSDArNmlhOG9JVHdGREhBc25pL0trdFJQbGd3WkJ5RDB6ajZZQXAr?=
 =?utf-8?B?ZGtPV3dPWEZvR3BhWFd1NjVJck9nUmpqU2xtOVA4Y09aOGp0K3QwT3c2T0lX?=
 =?utf-8?B?eG4rT2ZMK1pJalpRMFc1Wkh0Z0NPYVBzYVo3cXlTODRBRDc4VU9vMDREQ09j?=
 =?utf-8?B?b09YdEViNUczaHhXbEJuc1Q1QmZLdTNNdVBjcHhhTTNpT0lpYnBEK0hoRkE3?=
 =?utf-8?B?VUpGMmxxMnZLQlJRUXBxQU45VUxQMnRjQUEvZGJFa2V1ZGg3VmJQWWJVbHd6?=
 =?utf-8?B?eS83VHZmQnRqck1tTzl5OEFWUjRkRnBRR3VyMEJ1WkRzOG1FWTd1RXBqVjhw?=
 =?utf-8?B?NmRwMG1pNUgzV1VCV3d4Rkp0ejk2VmhEZkZINVRxY1Z3SjJ0QTlGWW40Ym43?=
 =?utf-8?B?d1Y5YzFEaEJ0Vnp4ck5tMmFNVjIrNFRSSzhsdEtnVUliR1NKUTJlalBuRk1L?=
 =?utf-8?Q?LR+rtMYmapVBFxA3pBHPzNGZJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da6756c9-5688-40b0-3d60-08d9c4d6a89b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 23:07:28.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWyoBFft9+NggZc6WZO38HHaNg3Ke96bbp4+9VhFXgmZHVE1vsLvpxPd39YdUjm1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5013
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: NzWnSlnsPUpM2PQlojRo4X5Zm6PAn64d
X-Proofpoint-GUID: NzWnSlnsPUpM2PQlojRo4X5Zm6PAn64d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_07,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112210116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 02:13:04PM -0800, Maciej Żenczykowski wrote:
> > > ad 1) AFAIK if bpf calls bpf_setsockopt on the socket in question,
> > > then userspace's view of the socket settings via
> > > getsockopt(IP_TOS/IPV6_TCLASS) will also be affected - this may be
> > > undesirable (it's technically userspace visible change in behaviour
> > > and could, as unlikely as it is, lead to application misbehaviour).
> > > This can be worked around via also overriding getsockopt/setsockopt
> > > with bpf, but then you need to store the value to return to userspace
> > > somewhere... AFAICT it all ends up being pretty ugly and very complex.
> > CGROUP_(SET|GET)SOCKOPT is created for that.
> > The user's value can be stored in bpf_sk_storage.
> 
> Yes, it can be done, it's very complex to do so.
> 
> The policy can change during run time (indeed that's probably a
> relatively likely situation,
> network gear notices a new high bandwidth connection and provides out
> of band feedback
> that it should be using a different dscp code point - we probably
> don't want the full policy to
> be present in the device because it might be a huge number of entries,
> with wildcards).
ic. got it. The value is very dynamic, so changing tos/tclass of a sock
in a more static hook like bind won't work well.

Details like this should have been in the commit message.

> > > I wouldn't be worried about needing to override each individual field,
> > > as the only other field that looks likely to be potentially beneficial
> > > to override would be the ipv6 flowlabel.
> > >
> > > ad 2) I don't think the bpf_setsockopt(IP_TOS/IPV6_TCLASS) approach
> > > works for packets generated via udp sendmsg where cmsg is being used
> > > to set tos.
> > There is CGROUP_UDP[4|6]_SENDMSG.  Right now, it can only change the addr.
> > tos/tclass support could be added.
> 
> It could, that doesn't seem easier to do than this approach though.
> 

[ ... ]

> > > Technically this could be done by attaching the programs to tc egress
> > > instead of the cgroup hook, but then it's per interface, which is
> > > potentially the wrong granularity...
> 
> > Right, there is advantage to do it at higher layer,
> > and earlier also.
> >
> > If the tos/tclass value can be changed early on, the correct
> > ip[6] header can be written at the beginning instead
> > of redoing it later and need to worry about the skb_clone_writable(),
> > rewriting it, do iph->check..etc.
> 
> I would indeed like it if we could decouple what userspace wants,
> from what the kernel/network actually uses.  There would need to be
> some sort of bpf hook,
> that takes a socket/flow and returns the tos/dscp to actually use
> (based on 5-tuple and other information).
> 
> But again, this would be *much* more complex.
In terms of the bpf prog doing the dscp-logic, it should be
pretty much the same.  Getting the 5-tuple, lookup from a map
and return the dscp value.

> > > As for what is driving this?  Upcoming wifi standard to allow access
> > > points to inform client devices how to dscp mark individual flows.
> > Interesting.
> >
> > How does the sending host get this dscp value from wifi
> > and then affect the dscp of a particular flow?  Is the dscp
> > going to be stored in a bpf map for the bpf prog to use?
> 
> It gets it out of band via some wifi signaling mechanism.
> Tyler probably knows the details.
> 
> Storing flow match information to dscp mapping in a bpf map is indeed the plan.
> 
> > Are you testing on TCP also?
> >
> > > As for the patch itself, I wonder if the return value shouldn't be
> > > reversed, currently '1 if the DS field is set, 0 if it is not set.'
> > > But I think returning 0 on success and an error on failure is more in
> > > line with what other bpf helpers do?
> > > OTOH, it does match bpf_skb_ecn_set_ce() returning 0 on failure...
> 
> > If adding a helper , how about making the bpf_skb_store_bytes()
> > available to BPF_PROG_TYPE_CGROUP_SKB?  Then it will be
> > more flexible to change other fields in the future in
> > the network and transport header.
> 
> I assume there's some reason why it's not available?
Not that I am aware of.  There was just no use case for it.
The static case is handled in socket bind/creation time.
The more dynamic case is handled in the udp_sendmsg which so
far the use case is changing the address only.

I don't mind adding bpf_skb_store_bytes() which could be useful
for other header's fields.
