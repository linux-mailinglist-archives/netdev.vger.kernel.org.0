Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4F1DD0AE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgEUPBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:01:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgEUPBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:01:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LEfPAi102177;
        Thu, 21 May 2020 15:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zAw1u07pbRDu+xvWXDwgv7P7rAeqqEG3qCROxNYz4Qw=;
 b=WcR2EviD0S8hW4M2rvwjYzJmQw4FXWXPBUrrFqEw1sUnEyiMbxupFvOgeiaqsO35y4jQ
 CPzN4RPWZ6CN7vjd6wBYwrtQUBjUMj9m0EAj6CSAN7hZzaajn1ZSnKnNebi9STjS87+w
 JKL62APs7QzHF9pg28671gwh0ONBuSPHok4+1ywoLlXr3HhK4IfhyKSbOVhikEcTfkxF
 9stgAB1nQtebaQ/IRHWLcG1ceA7kwj4KhpyGXBYsO9ItnyKUCR3Cg7SuHMkRyzT2Y+Ua
 jnI2GFQJ+lm1iENMft9tc6tPnnqNuUZR+w0R92TuT1D5sfFSWNj5/xpNnLmioaAkH55q Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krh0yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 15:01:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LEXEmm064466;
        Thu, 21 May 2020 14:59:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t3bdb1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 14:59:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LExUkO015814;
        Thu, 21 May 2020 14:59:30 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 07:59:29 -0700
Date:   Thu, 21 May 2020 17:59:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        horatiu.vultur@microchip.com, kuba@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: KASAN: slab-out-of-bounds Read in br_mrp_parse
Message-ID: <20200521145921.GJ30374@kadam>
References: <0000000000007b211005a6187dc9@google.com>
 <20200521140803.GI30374@kadam>
 <CACT4Y+bzz-h5vNGH0rDMUiuGZVX01oXawXAPbjtnNHb1KVWSvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bzz-h5vNGH0rDMUiuGZVX01oXawXAPbjtnNHb1KVWSvg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=944
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=982 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:28:05PM +0200, 'Dmitry Vyukov' via syzkaller-bugs wrote:
> On Thu, May 21, 2020 at 4:08 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > On Wed, May 20, 2020 at 11:23:18AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    dda18a5c selftests/bpf: Convert bpf_iter_test_kern{3, 4}.c..
> > > git tree:       bpf-next
> >                   ^^^^^^^^
> >
> > I can figure out what this is from reading Next/Trees but it would be
> > more useful if it were easier to script.
> 
> Hi Dan,
> 
> Is there a canonical way to refer to a particular branch of a particular tree?
> >From what I observed on mailing lists people seem to say "linux-next"
> or "upstream tree" and that seems to mean specific things that
> everybody understands.

git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git#master

I kind of hate that format because you have to replace the # with a
space, but it's what everyone uses.

regards,
dan carpenter

