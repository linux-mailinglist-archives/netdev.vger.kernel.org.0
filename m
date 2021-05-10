Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211FC37903C
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243273AbhEJOJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:09:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344187AbhEJOH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:07:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AE34mQ171920;
        Mon, 10 May 2021 10:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7N3vj2CNerYDIrQk0YPsy9jHw8dDgtuI8EkCY3dY5N8=;
 b=gKfwOYjuq6KMaRyqU0hkoFvXLdReTzaaKylUBauup4uL45KSZjE0xJTedZvih2WA//hl
 k7Xzh5UcdzixhQ/XMRoR/CEcfa6JyXQ5BCMfqOME0n+zUkOQI4pWGh4wjwtm881Ix+oM
 cn657EHgiLHMv3bYQ5tiQeHmj1gwx9RvQLharVL4qtdD3nMqPfVjWQ58yo/gpvz7RWix
 uB1qikTuyDsEYSKGC++JQFT9L0Mq06jK7geHE3BanKZdIjptvrNsU9m6iclnS1TwlFSj
 eiY8JlbHKps+TqZvzAURanYP/xYbCpfzY/8imfK4Fm87dzaY2NM/py9jXt2Nh0R3srIY uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f66808j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 10:06:15 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AE35kK171984;
        Mon, 10 May 2021 10:06:14 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f66808gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 10:06:14 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AE32JB026127;
        Mon, 10 May 2021 14:06:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 38dj988hvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 14:06:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AE68qh19071382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 14:06:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3CFAA4055;
        Mon, 10 May 2021 14:06:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45B2AA405F;
        Mon, 10 May 2021 14:06:08 +0000 (GMT)
Received: from sig-9-145-37-150.uk.ibm.com (unknown [9.145.37.150])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 14:06:08 +0000 (GMT)
Message-ID: <f8833399951a5af8d98a8bf344505163c5947ef0.camel@linux.ibm.com>
Subject: Re: [PATCH v5 3/3] asm-generic/io.h: warn in inb() and friends with
 undefined PCI_IOBASE
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Arnd Bergmann <arnd@arndb.de>, kernel test robot <lkp@intel.com>
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        Networking <netdev@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Mon, 10 May 2021 16:06:07 +0200
In-Reply-To: <CAK8P3a0CiVFvgpJJMcutHv6gdfeKWN2=AWYDuAX-ohEg3+L3gQ@mail.gmail.com>
References: <20210510085339.1857696-4-schnelle@linux.ibm.com>
         <202105102111.SyGVczHt-lkp@intel.com>
         <CAK8P3a0CiVFvgpJJMcutHv6gdfeKWN2=AWYDuAX-ohEg3+L3gQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vBfEkW1LBvYu2Gl1VHUytt0e94r5D0RU
X-Proofpoint-ORIG-GUID: F6bd4RJG8syII-GQEGRT02VAJxaPTB09
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-10 at 15:43 +0200, Arnd Bergmann wrote:
> On Mon, May 10, 2021 at 3:30 PM kernel test robot <lkp@intel.com> wrote:
> > All warnings (new ones prefixed by >>):
> > 
> >    In file included from include/linux/kernel.h:10,
> >                     from include/linux/list.h:9,
> >                     from include/linux/module.h:12,
> >                     from drivers/net/arcnet/com20020.c:31:
> >    drivers/net/arcnet/com20020.c: In function 'com20020_reset':
> > > > include/linux/compiler.h:70:32: warning: 'inbyte' is used uninitialized in this function [-Wuninitialized]
> >       70 |   (__if_trace.miss_hit[1]++,1) :  \
> >          |                                ^
> >    drivers/net/arcnet/com20020.c:286:9: note: 'inbyte' was declared here
> >      286 |  u_char inbyte;
> >          |         ^~~~~~
> 
> This looks like a real problem with the patch: the insb()/insw()/insl() helpers
> should memset(buffer, 0xff, size) to avoid using random stack data.
> 
>         Arnd


Yes I agree, will send a v6 shortly. Thanks.

