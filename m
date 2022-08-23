Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB30559E729
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiHWQ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244661AbiHWQX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:23:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23299D66E;
        Tue, 23 Aug 2022 05:46:09 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NCXAw4012627;
        Tue, 23 Aug 2022 12:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=06Qsmq29OzqEWs4XDYpIrPYFzYQA1ylzCMRH9Rv30S4=;
 b=gNBS326FmoN5AjgBPjvRO08XkOXupj9biZxRlT4uCRsnrKg8wFE+2kW1dHKXqwar93Pq
 fpEznWW5fNs3v1WpWlFEW9nzIWvmFpIAP22uftXFr1OHOmvMLOAa8FFSMqmcu6LJuISb
 82230j2OUrqX1DSM0uIYMyp1rEexTGSYCI+PLrPjIdcPGKiRtXMkQcMXSXCpz9B4qBYn
 f1oWf15DTPYI5Y9Db0ZwUGbaI+ZcS+lKWxutAatoN5+MAONBMPMdC8h+Le5GNi4NOgY+
 y2Aewj7A6cjLtAiaM3mJnLcbPR11Ykzz58iXR5OR4DaWLAl+zTTEanpsKgEx7zdmnzp1 lw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j4y0c8bnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 12:46:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NCNZqU013165;
        Tue, 23 Aug 2022 12:45:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88utfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 12:45:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NCjtao32571826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 12:45:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E17D952050;
        Tue, 23 Aug 2022 12:45:54 +0000 (GMT)
Received: from localhost (unknown [9.171.95.166])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2F5C552054;
        Tue, 23 Aug 2022 12:45:54 +0000 (GMT)
Date:   Tue, 23 Aug 2022 14:45:52 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] s390: move from strlcpy with unused retval to strscpy
Message-ID: <your-ad-here.call-01661258752-ext-8248@work.hours>
References: <20220818210102.7301-1-wsa+renesas@sang-engineering.com>
 <20220822180249.2c79c7e8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220822180249.2c79c7e8@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SVNN6Xt3WvYuy7K0mpuD76yH6KnR4CV0
X-Proofpoint-ORIG-GUID: SVNN6Xt3WvYuy7K0mpuD76yH6KnR4CV0
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_05,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 mlxlogscore=755
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208230050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 06:02:49PM -0700, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 23:01:01 +0200 Wolfram Sang wrote:
> > Follow the advice of the below link and prefer 'strscpy' in this
> > subsystem. Conversion is 1:1 because the return value is not used.
> > Generated by a coccinelle script.
> > 
> > Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> > Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > ---
> >  drivers/s390/block/dasd_devmap.c | 2 +-
> >  drivers/s390/block/dasd_eer.c    | 4 ++--
> >  drivers/s390/block/dcssblk.c     | 2 +-
> >  drivers/s390/char/hmcdrv_cache.c | 2 +-
> >  drivers/s390/char/tape_class.c   | 4 ++--
> >  drivers/s390/cio/qdio_debug.c    | 2 +-
> >  drivers/s390/net/ctcm_main.c     | 2 +-
> >  drivers/s390/net/fsm.c           | 2 +-
> >  drivers/s390/net/qeth_ethtool.c  | 4 ++--
> >  drivers/s390/scsi/zfcp_aux.c     | 2 +-
> >  drivers/s390/scsi/zfcp_fc.c      | 2 +-
> 
> I'm assuming this will go via the s390 tree?

Yes, I'll just take it via s390 tree. Thanks

> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> If nobody picks it up please feel free to resend the networking parts to us.
