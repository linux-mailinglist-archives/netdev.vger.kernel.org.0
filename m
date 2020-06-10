Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2521E1F5A34
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 19:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgFJRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 13:22:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727923AbgFJRW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 13:22:27 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AHCUpx141561;
        Wed, 10 Jun 2020 13:22:24 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31k3q6g8n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 13:22:24 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AHEbqk030528;
        Wed, 10 Jun 2020 17:22:24 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 31jqykgese-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 17:22:24 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05AHMN8u52560164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 17:22:23 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36C1E124055;
        Wed, 10 Jun 2020 17:22:23 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E5BE12405A;
        Wed, 10 Jun 2020 17:22:22 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jun 2020 17:22:22 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Jun 2020 10:22:22 -0700
From:   dwilder <dwilder@us.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, wilder@us.ibm.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com
In-Reply-To: <20200609145839.36f1cbec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200609000059.12924-1-dwilder@us.ibm.com>
 <20200609145839.36f1cbec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <f2e408a1cd3b3e7327769f1b8d37aa74@linux.vnet.ibm.com>
X-Sender: dwilder@us.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
Subject: RE: [(RFC) PATCH ] be2net: Allow a VF to use physical link state.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_10:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 cotscore=-2147483648 impostorscore=0
 phishscore=0 clxscore=1011 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006100126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-09 14:58, Jakub Kicinski wrote:
> On Mon,  8 Jun 2020 17:00:59 -0700 David Wilder wrote:
>> Hyper-visors owning a PF are allowed by Emulex specification to 
>> provide
>> a VF with separate physical and/or logical link states. However, on
>> linux, a VF driver must chose one or the other.
>> 
>> My scenario is a proprietary driver controlling the PF, be2net is the 
>> VF.
>> When I do a physical cable pull test the PF sends a link event
>> notification to the VF with the "physical" link status but this is
>> ignored in be2net (see be_async_link_state_process() ).
>> 
>> The PF is reporting the adapter type as:
>> 0xe228   /* Device id for VF in Lancer */
>> 
>> I added a module parameter "use_pf_link_state". When set the VF should
>> ignore logical link state and use the physical link state.
>> 
>> However I have an issue making this work.  When the cable is pulled I
>> see two link statuses reported:
>> [1706100.767718] be2net 8002:01:00.0 eth1: Link is Down
>> [1706101.189298] be2net 8002:01:00.0 eth1: Link is Up
>> 
>> be_link_status_update() is called twice, the first with the physical 
>> link
>> status called from be_async_link_state_process(), and the second with 
>> the
>> logical link status from be_get_link_ksettings().
>> 
>> I am unsure why be_async_link_state_process() is called from
>> be_get_link_ksettings(), it results in multiple link state changes
>> (even in the un-patched case). If I eliminate this call then it works.
>> But I am un-sure of this change.
>> 
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> 
> Hm. Just looking at the code in __be_cmd_set_logical_link_config():
> 
> 
> 	if (link_state == IFLA_VF_LINK_STATE_ENABLE ||
> 	    link_state == IFLA_VF_LINK_STATE_AUTO)
> 		link_config |= PLINK_ENABLE;
> 
> 	if (link_state == IFLA_VF_LINK_STATE_AUTO)
> 		link_config |= PLINK_TRACK;
> 
> Maybe we shouldn't set ENABLE for AUTO?

If I am understanding this correctly, this is used by the linux PF 
driver to configure
how link status is delivered to a VF.

My problem is one of interoperability between the PF (not linux) and the 
VF is running on linux.
The PF driver is implemented to the Emulex/Broadcom spec, which allows a 
PF driver to be configured such that the VF can be notified of both 
physical and logical link status, separately.

> 
> The module parameter is definitely not a good idea, what you're asking
> for seems to be well within the expectation from the
> .ndo_set_vf_link_state config, so it seems the driver / firmware is 
> just
> not implementing that right.

I am attempting to resolve an issue that the linux implementation cant 
conform to the the Emulex specification due to the implementation on 
linux.
