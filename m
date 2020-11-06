Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899782A9ECB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgKFVCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:02:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgKFVCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:02:38 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6Kb5DQ162691;
        Fri, 6 Nov 2020 16:02:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=SXpYmCvvUiF836r6Iz01TeufGvsPo/Gs8jXJV547tnU=;
 b=c+FcpGWJVWvMKtiUMVb6A6W7ffJqZvumy2BvHLJnA+qD8a3FYWjSQTOS9n/2DNq5bexW
 3hd+dPth3a4J+RfcP9l9gsP4EziJAqutuFKwnvFQYgbebmcdnPmZKbHLrBAX17ywPUL2
 LB9Ac6T7ePQwne6UStIxGWUzNHMSCjwmTXz9jooTsilf33d8+jf8Q+pZPANFm+IupDU6
 d7GP6XArwItL03MO3hGyYHaYNQPj1nWFw6zMRXi8zOMKaGTm2Xb2aFd8z+zNYsvfgdWn
 IbzYxYvDAtOsNHqxGnNNqjDiBqKYIYlYIvMSPjDdMtiZVvqU0TxMoLoZYG8DlEc/rU0U zg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34nd8msa5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 16:02:30 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6L1P6Y000749;
        Fri, 6 Nov 2020 21:02:29 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 34h0fkjqrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 21:02:29 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6L2MSY38273724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 21:02:22 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35C7A6E050;
        Fri,  6 Nov 2020 21:02:28 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECCE46E054;
        Fri,  6 Nov 2020 21:02:27 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 21:02:27 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 06 Nov 2020 15:02:27 -0600
From:   ljp <ljp@linux.vnet.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wvoigt@us.ibm.com, netdev@vger.kernel.org,
        Linuxppc-dev 
        <linuxppc-dev-bounces+ljp=linux.ibm.com@lists.ozlabs.org>,
        Dany Madden <drt@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next] Revert ibmvnic merge do_change_param_reset into
 do_reset
In-Reply-To: <20201106114208.4b0e8eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201106191745.1679846-1-drt@linux.ibm.com>
 <0ff353cbada91b031d1bbae250a975d5@linux.vnet.ibm.com>
 <20201106114208.4b0e8eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <ba446b20f6c90e4db68127238f83f231@linux.vnet.ibm.com>
X-Sender: ljp@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-06 13:42, Jakub Kicinski wrote:
> On Fri, 06 Nov 2020 13:30:25 -0600 ljp wrote:
>> On 2020-11-06 13:17, Dany Madden wrote:
>> > This reverts commit 16b5f5ce351f8709a6b518cc3cbf240c378305bf
>> > where it restructures do_reset. There are patches being tested that
>> > would require major rework if this is committed first.
>> >
>> > We will resend this after the other patches have been applied.
>> 
>> I discussed with my manager, and he has agreed not revert this one
>> since it is in the net-next tree and will not affect net tree for
>> current bug fix patches.
> 
> We merge net into net-next periodically (~every week or so) so if you
> keep making changes to both branches I will have to deal with the
> fallout.
> 
> I'm assuming that the resolution for the current conflict which Stephen
> Rothwell sent from linux-next is correct. Please confirm.
> 
> I will resolve it like he did when Linus pulls from net (hopefully
> later today).
> 
> But if you know you have more fixes I'd rather revert this, get all the
> relevant fixed into net, wait for net to be merged into net-next and
> then redo the refactoring.
> 
> Hope that makes sense.

Jakub,

We had further discussion in the team based on your comments above.
You can revert it for now.
Thanks for your efforts.

Lijun
