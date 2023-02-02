Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC0668872F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjBBS4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbjBBS4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:56:19 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8494F10254;
        Thu,  2 Feb 2023 10:56:15 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312HIFVv002326;
        Thu, 2 Feb 2023 18:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=YS8OxqX6Xa4ReQhYwflKc5aSv/9TMKB2gRMMZTEJZEM=;
 b=CFDCGulP3P9Xe+2FAp6xgIgRdBQw74UWN3jgGISv3dFzGsARHrCHm0mKBX/ELGDgttez
 O2meJewgXXM7+teNdX1OhLZrAIM2aVkDVTHAidhbq037PYHO8U582Sv4uDmN9nO7C+H0
 Ct6DdO3veQD6OKh6pBbNXbO7fmZB2GLhEks2HUnbj9M40HZLiGUM/0/PZYRpNZFTZABc
 KUw69DyK4MX540GbhWsmE2ikKCZ2qfXEtoCa6lzKc4HwYnA/+A4P1qpvOVXru7Rg7Eu5
 s6n0B3YDRpfXh9P9tepOpIUV6KxgO+ZDzTxLDiaQq2Q5zExlYDSpXCevnb+PR2ZAq65+ Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngeuff37e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 18:55:15 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312InxkL010732;
        Thu, 2 Feb 2023 18:55:14 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngeuff36u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 18:55:14 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312IQsak007753;
        Thu, 2 Feb 2023 18:55:12 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3ncvtf51nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 18:55:12 +0000
Received: from b03ledav001.gho.boulder.ibm.com ([9.17.130.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312ItBP011600580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 18:55:12 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90C1C6E050;
        Thu,  2 Feb 2023 18:57:22 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3D826E04E;
        Thu,  2 Feb 2023 18:57:16 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.110.248])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 18:57:15 +0000 (GMT)
Message-ID: <ac6270fe1dba1b3398dc2b830cf9bda5c89a7a3d.camel@linux.ibm.com>
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jonathan Corbet <corbet@lwn.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org
Cc:     nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
        sparclinux@vger.kernel.org,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Alasdair Kergon <agk@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mike Snitzer <snitzer@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, cgroups@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-hwmon@vger.kernel.org, rcu@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date:   Thu, 02 Feb 2023 13:54:33 -0500
In-Reply-To: <87o7qbvra9.fsf@meer.lwn.net>
References: <20230129231053.20863-1-rdunlap@infradead.org>
         <875yckvt1b.fsf@meer.lwn.net>
         <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
         <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
         <87o7qbvra9.fsf@meer.lwn.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rINHRxV1D64-5YqYmvXoiq9bBKTirX1e
X-Proofpoint-ORIG-GUID: eZPeQqFlkdhx5p58topJeC6q8R4gRCuD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_12,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302020166
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 11:46 -0700, Jonathan Corbet wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
> 
> > On 2/2/23 10:33, Randy Dunlap wrote:
> > > On 2/2/23 10:09, Jonathan Corbet wrote:
> > > > Randy Dunlap <rdunlap@infradead.org> writes:
> > > > >   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct
> > > > > spelling
> > > > >   [PATCH 7/9] Documentation: scsi: correct spelling
> > > > 
> > > > I've left these for the SCSI folks for now.  Do we *really*
> > > > want to be
> > > > fixing spelling in ChangeLog files from almost 20 years ago?
> > > 
> > > That's why I made it a separate patch -- so the SCSI folks can
> > > decide that...
> > 
> > How about removing the Documentation/scsi/ChangeLog.* files? I'm
> > not sure these changelogs are still useful since these duplicate
> > information that is already available in the output of git log
> > ${driver_directory}.
> 
> Actually, the information in those files mostly predates the git era,
> so you won't find it that way.  I *still* question their value,
> though...

In the pre-source control days they were the answer to the GPLv2
Section 2 requirement to " carry prominent notices stating that you
changed the files and the date of any change." 

If you remove the files you may run afoul of the GPLv2 Section 1
requirement to "keep intact all the notices that refer to this
License".  Of course, nowadays we assume the source control does this
for us, so people rarely think of these requirements, but for files
that predate source control I think you need to consider the licence
implications.

James


