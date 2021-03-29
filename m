Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE134C36C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 07:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhC2F4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 01:56:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhC2F4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 01:56:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12T5s3gM107989;
        Mon, 29 Mar 2021 05:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3edm75IWAc+zuu0G5xQYVx5YuLw3zNP6q0YuJG4uQug=;
 b=Ofu9Z1Gr3IsReMY6uL5trKOQoo9stje/0+IYwfyji+xPndR3dTk410vMDc25rQyiSXhA
 W8Iu5lE2bIFTiIxdLwTUtPMLhwfmF2eWmwvYVY0cyWko+gDxR41SOok/1otqKPng/I3t
 JJpZaJDOEOxVqdvJAJVbDHwe5G3PZdyblkHgviqzTeMdAxV2yCvZ/odxwZ0Zw8cCmD+G
 XkHA6bHUJGdVoqVC8Xcssn1qyFUoEfAc2Gie/mXiaUI8/hDIFZUHRRK5xtkjY7FlbkFb
 R3++D3CzsK+73FIcKt3nvbxvbU847z6LW7B0SzRHZWLvFpJ2DKu/5Ti3VVbwyFUEfAtT HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37hvnm2avg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 05:55:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12T5shs3037071;
        Mon, 29 Mar 2021 05:55:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 37jekwqejg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 05:55:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12T5thHZ024472;
        Mon, 29 Mar 2021 05:55:43 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Mar 2021 22:55:42 -0700
Date:   Mon, 29 Mar 2021 08:55:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Song Liu <song@kernel.org>
Cc:     Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: remove redundant assignment of variable id
Message-ID: <20210329055532.GH1717@kadam>
References: <20210326194348.623782-1-colin.king@canonical.com>
 <CAPhsuW4K1RB-kz-Wu32eOFYE=ZwQr7Wr20zuEhhtzK_hr9YGUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4K1RB-kz-Wu32eOFYE=ZwQr7Wr20zuEhhtzK_hr9YGUw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290047
X-Proofpoint-GUID: TmF5Z4G1P92__m9qvJwvO_Itb1MrUHLQ
X-Proofpoint-ORIG-GUID: TmF5Z4G1P92__m9qvJwvO_Itb1MrUHLQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 01:18:36PM -0700, Song Liu wrote:
> On Fri, Mar 26, 2021 at 12:45 PM Colin King <colin.king@canonical.com> wrote:
> >
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > The variable id is being assigned a value that is never
> > read, the assignment is redundant and can be removed.
> >
> > Addresses-Coverity: ("Unused value")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> For future patches, please prefix it as [PATCH bpf-next] for
> [PATCH bpf], based on which tree the patch should apply to.
> 

You can keep asking us to do that but it's never going to happen... :P
I do this for networking but it's a massive pain in the butt and I get
it wrong 20% of the time.

regards,
dan carpenter

