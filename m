Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893D0A204C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfH2QDe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 12:03:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727008AbfH2QDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:03:34 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TG2buS153331
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 12:03:33 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2umpb4gtdx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 12:03:32 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 29 Aug 2019 17:03:17 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 17:03:13 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TG2nZC21561674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 16:02:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB28D52050;
        Thu, 29 Aug 2019 16:03:11 +0000 (GMT)
Received: from dyn-9-152-98-121.boeblingen.de.ibm.com (unknown [9.152.98.121])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A0E015204F;
        Thu, 29 Aug 2019 16:03:11 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH bpf-next 2/3] tools: bpftool: improve and check builds for
 different make invocations
From:   Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20190829105645.12285-3-quentin.monnet@netronome.com>
Date:   Thu, 29 Aug 2019 18:03:11 +0200
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Transfer-Encoding: 8BIT
References: <20190829105645.12285-1-quentin.monnet@netronome.com>
 <20190829105645.12285-3-quentin.monnet@netronome.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
X-Mailer: Apple Mail (2.3445.9.1)
X-TM-AS-GCONF: 00
x-cbid: 19082916-0016-0000-0000-000002A455E6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082916-0017-0000-0000-00003304AC8E
Message-Id: <C90F7A80-D2E9-401B-8BFC-47C22A44ADAC@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=466 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Am 29.08.2019 um 12:56 schrieb Quentin Monnet <quentin.monnet@netronome.com>:
> 
> +make_and_clean() {
> +	echo -e "\$PWD:    $PWD"
> +	echo -e "command: make -s $* >/dev/null"
> +	make $J -s $* >/dev/null

Would it make sense to set ERROR=1 if make produces a bpftool binary,
but still fails with a non-zero RC for whatever reason?

