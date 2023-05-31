Return-Path: <netdev+bounces-6814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D98377184A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B701C20E97
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83F2154B1;
	Wed, 31 May 2023 14:19:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE8F154AD
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:19:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50AF193
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:19:24 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VDgZAR021958;
	Wed, 31 May 2023 13:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=tn2RUJuYJMxwXb5NMDOf2dwV0OhfUmn2YZMIPZVU6fM=;
 b=nmSRc53wB0ONqyxMVO4G0cfZOEK5WH+nUHkRdttvuyMp4p8dzL8H6x+TbxjMJSyR+QgU
 NN4BJ14EK4zutNl9tPzVnMJhyMKzGwK7ZT3vBRjkw5Ds41BqcptnpQKWxvhoKN1c5gWh
 li7ARh4Y3P+1Yd8yfAfTOogyHdQ/HfzRfZlH93CDY8GbAR6O1PKroqnoytoXVZNQyrPv
 EfveNpxLOWqWJR+/slHo9TAE0gOaIHLb556OmaGI79CguE3vs2eiJ+MQji93k3SVsMqD
 6hnOq/XF7FlcLMfROiZujOWnirvAbqmUyB2r4/oKwTqnZrqtGCeKoec6veobfjXFunB5 Vw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx7bx86wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 13:48:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34V2S589010637;
	Wed, 31 May 2023 13:43:18 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5a13b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 13:43:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VDhFhw21431018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 13:43:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DDA620043;
	Wed, 31 May 2023 13:43:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D89F20040;
	Wed, 31 May 2023 13:43:15 +0000 (GMT)
Received: from [9.152.212.237] (unknown [9.152.212.237])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 May 2023 13:43:15 +0000 (GMT)
Message-ID: <c2702c969f01f9dcf2d6b3d3326e804c3fee86c0.camel@linux.ibm.com>
Subject: Re: mlx5 driver is broken when pci_msix_can_alloc_dyn() is false
 with v6.4-rc4
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>,
        Shay Drory
	 <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Eli Cohen
	 <elic@nvidia.com>, netdev@vger.kernel.org
Date: Wed, 31 May 2023 15:43:15 +0200
In-Reply-To: <cb093081-ef71-c556-fe2f-9ec30bbcfe80@leemhuis.info>
References: <d6ada86741a440f99b5d6fedff532c8dbe86254f.camel@linux.ibm.com>
	 <cb093081-ef71-c556-fe2f-9ec30bbcfe80@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: edFdACbBcrpVWztIGm3Hg5GDaQkV1kkP
X-Proofpoint-ORIG-GUID: edFdACbBcrpVWztIGm3Hg5GDaQkV1kkP
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-31 at 15:33 +0200, Linux regression tracking #adding
(Thorsten Leemhuis) wrote:
> [CCing the regression list, as it should be in the loop for regressions:
> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>=20
> [TLDR: I'm adding this report to the list of tracked Linux kernel
> regressions; the text you find below is based on a few templates
> paragraphs you might have encountered already in similar form.
> See link in footer if these mails annoy you.]
>=20
> On 30.05.23 15:04, Niklas Schnelle wrote:
> >=20
> > With v6.4-rc4 I'm getting a stream of RX and TX timeouts when trying to
> > use ConnectX-4 and ConnectX-6 VFs on s390. I've bisected this and found
> > the following commit to be broken:
> >=20
> > commit 1da438c0ae02396dc5018b63237492cb5908608d
> > Author: Shay Drory <shayd@nvidia.com>
> > Date:   Mon Apr 17 10:57:50 2023 +0300
> > [...]
>=20
> Thanks for the report. To be sure the issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
> tracking bot:
>=20
> #regzbot ^introduced 1da438c0ae02396dc5018b63237492cb5908608d
> #regzbot title net/mlx5: RX and TX timeouts with ConnectX-4 and
> ConnectX-6 VFs on s390
> #regzbot ignore-activity
>=20
> This isn't a regression? This issue or a fix for it are already
> discussed somewhere else? It was fixed already? You want to clarify when
> the regression started to happen? Or point out I got the title or
> something else totally wrong? Then just reply and tell me -- ideally
> while also telling regzbot about it, as explained by the page listed in
> the footer of this mail.
>=20
> Developers: When fixing the issue, remember to add 'Link:' tags pointing
> to the report (the parent of this mail). See page linked in footer for
> details.
>=20
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> That page also explains what to do if mails like this annoy you.

Hi Thorsten,

Thanks for tracking. I actually already sent a fix patch (and v2) for
this. Sadly I forgot to link to this mail. Let's see if I can get the
regzbot command right to update it. As for the humans the latest fix
patch is here:

https://lore.kernel.org/netdev/20230531084856.2091666-1-schnelle@linux.ibm.=
com/

Thanks,
Niklas

#regzbot fix: net/mlx5: Fix setting of irq->map.index for static IRQ case


