Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432C928C4C3
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgJLWaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:30:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43134 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388361AbgJLWaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:30:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CMKGc6025175;
        Mon, 12 Oct 2020 18:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc :
 in-reply-to : references : message-id : subject; s=pp1;
 bh=46iaAyJ+E5UQWvbeuMx7hJ72/RT3X/tQYGgdD57Lteo=;
 b=A01aDoN050Rvm7bOzxsB/dRQVSy6bDNRA6uBqOdH+xGOCHeCJpM6qs/KtgdNPFgykUDt
 eKxfjPIOwZlbTh/quK6Z42QMe0klPmcB94e9R4TKeeWGyCcHlLE3mhFpxBZhbqNgLdlN
 Z04nr4pmGvi92eMXjVOJVS2+nZuict1KOSUJDCy3+V8k2MN2T1f3tk4uLlXOEzmOtfVw
 gCYByi31HV+RNXLhYIHdkqTPossUf2hO1jAJrn7nsf4t612QWu520dOqmK4DtDJGk58Z
 PFewgnu8nzH0fYQOqi139m2yOuQo1j0jZ4RN6ccQ7e0Vt51Vqig1nZ8VsYOZmIu6hhNu Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344yuqg57y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 18:30:17 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09CMKQXm025332;
        Mon, 12 Oct 2020 18:30:17 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344yuqg579-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 18:30:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09CMRmwq012980;
        Mon, 12 Oct 2020 22:30:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3434k8yjk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 22:30:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09CMUEgv32178636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 22:30:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE0B2112066;
        Mon, 12 Oct 2020 22:30:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BF08112063;
        Mon, 12 Oct 2020 22:30:13 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 12 Oct 2020 22:30:13 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 12 Oct 2020 15:30:12 -0700
From:   dwilder <dwilder@us.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
In-Reply-To: <20201011113125.3f370b77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201008190538.6223-1-dwilder@us.ibm.com>
 <20201008190538.6223-3-dwilder@us.ibm.com>
 <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
 <CA+FuTSejypj6fvU3-b8V-kU6Xcwg7m4R3OO3Ry4kQK=87hNwvw@mail.gmail.com>
 <20201011113125.3f370b77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <ad0d23a8d3c246d5ff10c52b52a8175c@linux.vnet.ibm.com>
X-Sender: dwilder@us.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
Subject: RE: [ PATCH v1 2/2] ibmveth: Identify ingress large send packets.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_18:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=955 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010120162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-11 11:31, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 12:51:30 -0400 Willem de Bruijn wrote:
>> > > @@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
>> > >                         skb_put(skb, length);
>> > >                         skb->protocol = eth_type_trans(skb, netdev);
>> > >
>> > > -                       if (length > netdev->mtu + ETH_HLEN) {
>> > > +                       /* PHYP without PLSO support places a -1 in the ip
>> > > +                        * checksum for large send frames.
>> > > +                        */
>> > > +                       if (be16_to_cpu(skb->protocol) == ETH_P_IP) {
> 
> You can byteswap the constant, so its done at compilation time.

Thanks for the comments.

For V2 of patch I will change above to BE16_TO_CPU()

> 
>> > > +                               struct iphdr *iph = (struct iphdr *)skb->data;
>> > > +
>> > > +                               iph_check = iph->check;
>> >
>> > Check against truncated/bad packets.
>> 
>> .. unless I missed context. Other code in this driver seems to peek in
>> the network and transport layer headers without additional geometry
>> and integrity checks, too.
> 
> Good catch, even if we trust the hypervisor to only forward valid
> frames this needs to be at least mentioned in the commit message.
> 
> Also please add Fixes tags to both patches.

For V2: ( posting soon )
-Will add Fix tags
-update commit message re: validity of frames from Hypervisor.
-switch be16_to_cpu() to BE16_TO_CPU().

Thanks
