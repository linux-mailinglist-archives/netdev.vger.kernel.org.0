Return-Path: <netdev+bounces-2865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F70704563
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B79991C20939
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685B83D8E;
	Tue, 16 May 2023 06:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5E23C3;
	Tue, 16 May 2023 06:38:55 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9101FD4;
	Mon, 15 May 2023 23:38:54 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34G6c1f8024124;
	Tue, 16 May 2023 06:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=9DmXpqDg3O9x9sNFjmzLOnR7Rix1h8qN/8nG3xKpvRY=;
 b=UEsj2VKSJ1H9Xp0n1zHRNCf1ZNlcPgij2sZ94uPNQg1kjt8BJQWspIVdjmiD0L7iGvpJ
 YMilIL/ilwe1K1YSCHZxN6d5Cazwnd5+mzBh/nBAttSs74qTuvo+Qlr6YJBXQcfTiG1K
 Z5HTi3QPkat/739riWjX22ij51vvyUvOqMp1I/a9jlo1tOPQVjP8GUPbxfSKTjnj0uxO
 x1Nd0qf7c3RW4/drx+NMKH2Nvl48Dy/oWHlZCR4L83+D6iruAl2IZIliiMCXCAgygcPA
 T6M8cTEJyFwxOFdmJ+ThK6wfSw3p0KCJ25TyJ1Hz0Q7DvEBGqNM33kVts/tNUI1qyAsb nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm3ms1qy9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 06:38:47 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34G6cV4M027450;
	Tue, 16 May 2023 06:38:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm3ms1qvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 06:38:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G3nLnr002047;
	Tue, 16 May 2023 06:33:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdseb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 06:33:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34G6XdHJ62521808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 06:33:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9875D20040;
	Tue, 16 May 2023 06:33:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CF7B20043;
	Tue, 16 May 2023 06:33:38 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.16.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 May 2023 06:33:38 +0000 (GMT)
Date: Tue, 16 May 2023 08:33:36 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc: selinux@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v4 5/9] drivers: use new capable_any functionality
Message-ID: <ZGMjwGTDgCGrfsC8@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230511142535.732324-1-cgzones@googlemail.com>
 <20230511142535.732324-5-cgzones@googlemail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511142535.732324-5-cgzones@googlemail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xqf_N-JoXc2UVfYLwyAFExMe35oo7Cp0
X-Proofpoint-ORIG-GUID: PZdVErVtm-1oMWtVtghhxQof6lFPLe0D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_02,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 malwarescore=0
 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 04:25:28PM +0200, Christian Göttsche wrote:
> Use the new added capable_any function in appropriate cases, where a
> task is required to have any of two capabilities.
> 
> Reorder CAP_SYS_ADMIN last.
> 
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> ---
> v4:
>    Additional usage in kfd_ioctl()
> v3:
>    rename to capable_any()
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 3 +--
>  drivers/net/caif/caif_serial.c           | 2 +-
>  drivers/s390/block/dasd_eckd.c           | 2 +-
>  3 files changed, 3 insertions(+), 4 deletions(-)
...
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index ade1369fe5ed..67d1058bce1b 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -5370,7 +5370,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
>  	char psf0, psf1;
>  	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_any(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EACCES;
>  	psf0 = psf1 = 0;

For s390 part:
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>

