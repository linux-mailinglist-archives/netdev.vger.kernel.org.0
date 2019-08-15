Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02D58ECFD
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbfHONhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:37:10 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:53076 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727160AbfHONhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:37:10 -0400
Received: from pps.filterd (m0049297.ppops.net [127.0.0.1])
        by m0049297.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x7FDZbRS014283;
        Thu, 15 Aug 2019 09:36:58 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049297.ppops.net-00191d01. with ESMTP id 2ud68qb775-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Aug 2019 09:36:57 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x7FDau76004618;
        Thu, 15 Aug 2019 09:36:56 -0400
Received: from zlp27127.vci.att.com (zlp27127.vci.att.com [135.66.87.31])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x7FDaorv004516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 15 Aug 2019 09:36:50 -0400
Received: from zlp27127.vci.att.com (zlp27127.vci.att.com [127.0.0.1])
        by zlp27127.vci.att.com (Service) with ESMTP id 83886400A0AA;
        Thu, 15 Aug 2019 13:36:50 +0000 (GMT)
Received: from mlpi432.sfdc.sbc.com (unknown [144.151.223.11])
        by zlp27127.vci.att.com (Service) with ESMTP id 6D490400A0A2;
        Thu, 15 Aug 2019 13:36:50 +0000 (GMT)
Received: from sfdc.sbc.com (localhost [127.0.0.1])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x7FDaoAI031260;
        Thu, 15 Aug 2019 09:36:50 -0400
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x7FDag8n031062;
        Thu, 15 Aug 2019 09:36:43 -0400
Received: from pruddy-Precision-7520 (unknown [10.156.30.225])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 09477360471;
        Thu, 15 Aug 2019 06:36:40 -0700 (PDT)
Message-ID: <45a527bf8946b52abb939fbdf844c98ac3ee7c0f.camel@vyatta.att-mail.com>
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
From:   Patrick Ruddy <pruddy@vyatta.att-mail.com>
Reply-To: pruddy@vyatta.att-mail.com
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc:     bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com
Date:   Thu, 15 Aug 2019 14:36:39 +0100
In-Reply-To: <d0be5038-e76f-d21b-a034-e450cbb3010e@cumulusnetworks.com>
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
         <20190813195341.GA27005@splinter>
         <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
         <620d3cfbe58e3ae87ef1d5e7f2aa1588cac3e64a.camel@vyatta.att-mail.com>
         <20190814201138.GE2431@otheros>
         <d0be5038-e76f-d21b-a034-e450cbb3010e@cumulusnetworks.com>
Organization: Vyatta
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-08-14 at 23:34 +0300, Nikolay Aleksandrov wrote:
> On 8/14/19 11:11 PM, Linus Lüssing wrote:
> > On Wed, Aug 14, 2019 at 05:40:58PM +0100, Patrick Ruddy wrote:
> > > The group is being joined by MLD at the L3 level but the packets are
> > > not being passed up to the l3 interface becasue there is a MLD querier
> > > on the network
> > > 
> > > snippet from /proc/net/igmp6
> > > ...
> > > 40   sw1             ff0200000000000000000001ff008700     1 00000004 0
> > > 40   sw1             ff020000000000000000000000000002     1 00000004 0
> > > 40   sw1             ff020000000000000000000000000001     1 0000000C 0
> > > 40   sw1             ff010000000000000000000000000001     1 00000008 0
> > > 41   lo1             ff020000000000000000000000000001     1 0000000C 0
> > > 41   lo1             ff010000000000000000000000000001     1 00000008 0
> > > 42   sw1.1           ff020000000000000000000000000006     1 00000004 0
> > > 42   sw1.1           ff020000000000000000000000000005     1 00000004 0
> > > 42   sw1.1           ff0200000000000000000001ff000000     2 00000004 0
> > > 42   sw1.1           ff0200000000000000000001ff008700     1 00000004 0
> > > 42   sw1.1           ff0200000000000000000001ff000099     1 00000004 0
> > > 42   sw1.1           ff020000000000000000000000000002     1 00000004 0
> > > 42   sw1.1           ff020000000000000000000000000001     1 0000000C 0
> > > 42   sw1.1           ff010000000000000000000000000001     1 00000008 0
> > > ...
> > > 
> > > the bridge is sw1 and the l3 intervace is sw1.1
> > 
> > What kind of interface is sw1.1 exactly? Is it a VLAN or a VRF
> > interface? Something else?
> > 
> +1
> 
> > Could you also post the output of bridge mdb show?
> > 
> > Regards, Linus
> > 
> > 
> > PS: Also please include the bridge mailinglist in the future.
> > 
> 
> Note that if you'd like to debug a host joined group currently bridge mdb show
> will not dump it and if the group is host-joined only it
> can even be empty. You can use my latest set (not applied yet):
> https://urldefense.proofpoint.com/v2/url?u=http-3A__patchwork.ozlabs.org_project_netdev_list_-3Fseries-3D125169&d=DwIDaQ&c=LFYZ-o9_HUMeMTSQicvjIg&r=au3D9TlUU6OvFpWOU9cuIHeNeV2fw-AOF1ZqCRqsILc&m=KsdarH0MAMMoKZ4PuvHrEC57uEluTGK-XSL4uUxu9MY&s=jyoK6VVmFh1KpKZirrtUYwq9nLy8fz-GigFFLjaLsoE&e=
> 
> Alternatively you could monitor the mdb events, it will show up there even
> today without any changes (bridge monitor mdb) and you can check if it's
> getting deleted.
> 
> Cheers,
>  Nik

The sw1.1 interface is a .1q vlan

The output of "bridge monitor mdb" is empty

I can see the incoming query and the outging report on tshark:
29002 72654.887739 fe80::4041:1ff:fe00:101 → ff02::1      ICMPv6 94
Multicast Listener Query
29003 72655.502035 fe80::eac5:7aff:fe00:8700 → ff02::16     ICMPv6 194
Multicast Listener Report Message v2

debugging shows that bridge code sees the incoming query but not the
outgoing report.

Thanks for all the pointers - I will pursue what is happening.

-pr 

