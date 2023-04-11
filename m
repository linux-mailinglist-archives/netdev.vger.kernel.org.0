Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796FD6DD7A2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDKKOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDKKOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:14:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54B6ED;
        Tue, 11 Apr 2023 03:14:11 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33B91On2014681;
        Tue, 11 Apr 2023 10:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zmM+mYhrvWRLh6MWYkg1j/dwztT9aNR74UUScN57emg=;
 b=l960ltP37R2jOMoMW1y1SlX/LzJqmvrZ6Sskjin9TSlgewNPFQtMG/r1haCfcPwc2V1H
 26Fa+PkUKhRNmwfDakvvRf3Sj2daJ/m1zrr4RpF08Bpl6edqgvViXVYOekFZIxY6KSyY
 vMtNtkwojlbS+7Cpgs4VGTpVy0mhM/FvJS9KwHdyhFEGLVyhn4X8jMimhSQlOTWENDdi
 jbziwVXBegEi2BujwwxgNH4ooG78QXi6Ld9COJUtDo1uiA7EygbLkqRcFWaP3II0KIkx
 2UnYEddxJ7NtRb/zI++D/Yn8EZGEbc9BxSaa8gcseQcZThEixJBa4QLI1GPQoEXBjyKY hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pvrr8u5wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:14:04 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33B9RKBY028755;
        Tue, 11 Apr 2023 10:14:04 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pvrr8u5v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:14:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33B4DSwZ022538;
        Tue, 11 Apr 2023 10:14:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3pu0hq1cjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 10:14:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33BADvOP23003648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 10:13:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D4282006A;
        Tue, 11 Apr 2023 10:13:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EDC220040;
        Tue, 11 Apr 2023 10:13:56 +0000 (GMT)
Received: from [9.171.53.122] (unknown [9.171.53.122])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Apr 2023 10:13:56 +0000 (GMT)
Message-ID: <f2bc454b117e7bf5f7cb5882b86b13b6d3da140a.camel@linux.ibm.com>
Subject: Re: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Apr 2023 12:13:55 +0200
In-Reply-To: <20230409085516.GD14869@unreal>
References: <20230403075657.168294-1-schnelle@linux.ibm.com>
         <20230409085516.GD14869@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t_TO8cyWHg7oX6yXJ1wT94H1gryD17nQ
X-Proofpoint-ORIG-GUID: ShXS9HNa2yB8BJuEb751WEMPGFYstnMr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_06,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-04-09 at 11:55 +0300, Leon Romanovsky wrote:
> On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> > after an error on the PCI link, the driver does not need to wait
> > for the link to become functional again as a reset is required. Stop
> > the wait loop in this case to accelerate the recovery flow.
> >=20
> > Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> > Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >=20
>=20
> The subject line should include target for netdev patches: [PATCH net-nex=
t] ....
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks, I'll sent a v2 with your R-b, the correct net-next prefix and a
Link to this discussion.
