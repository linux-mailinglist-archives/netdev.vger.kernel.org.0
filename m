Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1941A95B65
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbfHTJqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:46:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728426AbfHTJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:46:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K9iMuS132835;
        Tue, 20 Aug 2019 09:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=rJGY4A3Rt+Hl36n8/Gp1bBe5o1K9b1rfgPgCTlnsZLU=;
 b=IoRCZn/HHyA7FhxFvVj6hDLsTpXJkGk/NUTzOYs36RGnuC1qaGpe24SKjSOvSNnKC0sO
 2JnlmK1q5nnst+K2/9krBshx1SfR0eCVSLjOj+fWYF0bWO9wgUpulpYTKvJdsvpAqHX+
 6kSFK7W56flfSBiEpCiMSER5AAapl3w1C6SDi9SMBDERA+jOO1/1KlZcC1+gmN8eblnD
 uc1MCGJZzgjVhmvcGR8lNh3pYLVhlsk2Pdl/h4yTnCWdMkaaZQUrk2F5YJ8uvOt2XRml
 GyBAglJ3JTWXuh+6H+/qGRcEU6BuSRXThH+BpM2Fh8GuwSCZt6JXAhgHKWFky9GoAMPl xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ue90tdapw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:45:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K9haIU022058;
        Tue, 20 Aug 2019 09:45:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ufwgcywpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 09:45:37 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K9jaH1013512;
        Tue, 20 Aug 2019 09:45:36 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 02:45:35 -0700
Date:   Tue, 20 Aug 2019 12:44:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
Message-ID: <20190820094444.GA3964@kadam>
References: <20190820013652.147041-1-yuehaibing@huawei.com>
 <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com>
 <20190820085547.GE4451@kadam>
 <CAJ+HfNhRf+=yN6eOOZ1zp8=VicT-k6nHLO6r+f__O5X3M+N=ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNhRf+=yN6eOOZ1zp8=VicT-k6nHLO6r+f__O5X3M+N=ug@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:25:29AM +0200, Björn Töpel wrote:
> On Tue, 20 Aug 2019 at 10:59, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > On Tue, Aug 20, 2019 at 09:28:26AM +0200, Björn Töpel wrote:
> > > For future patches: Prefix AF_XDP socket work with "xsk:" and use "PATCH
> > > bpf-next" to let the developers know what tree you're aiming for.
> >
> > There are over 300 trees in linux-next.  It impossible to try remember
> > everyone's trees.  No one else has this requirement.
> >
> 
> Net/bpf are different, and I wanted to point that out to lessen the
> burden for the maintainers. It's documented in:
> 
> Documentation/bpf/bpf_devel_QA.rst.
> Documentation/networking/netdev-FAQ.rst

Ah...  I hadn't realized that BPF patches were confusing to Dave.

I actually do keep track of net and net-next.  I do quite a bit of extra
stuff for netdev patches.  So what about if we used [PATCH] for bpf and
[PATCH net] and [PATCH net-next] for networking?

I will do that.

regards,
dan carpenter
