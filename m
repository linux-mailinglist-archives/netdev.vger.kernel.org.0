Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530DD1EC03F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgFBQmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:42:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgFBQmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:42:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052GfwWi027116;
        Tue, 2 Jun 2020 16:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=p52x2Baw9/LPh2wvk1CQWEy2tmRGP0WhETKpvLUn4P4=;
 b=Suu4/FUMudbk/xV4zMUScVstK+NHpKu6GE3BPYi4V3E/VLKg/XKQFf9IEJR7cUmKxqdO
 CYlJM3GT1LNCcfyEoYj0hupNeIqr/lsg3ZR92BH1zwNxi5OJOQxhkiqRNXmAg95WnYMB
 ukPoTlIMW+JPWZzyjMSoDC8ymLgXrGtv3nUK0qelQE97nmfpTTdVhc7ysuPNyFRztJ52
 PX1mEP5cEBO7rs4ByeZv7z4ZO6unTjuMhBO8o4bq5lD5Xg9fopw1C7E4+G2RguVpqMfa
 G35Fb0w1Gnsxx4u/KX/OE7ZeOM9Fjitr358z5gohkXWobeMLuwai7CjgwNIrL5+X3TGu xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31bewqw3x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 16:41:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052GY07X004749;
        Tue, 2 Jun 2020 16:41:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31dju1sv01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 16:41:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052Gfvba008028;
        Tue, 2 Jun 2020 16:41:57 GMT
Received: from dhcp-10-175-162-197.vpn.oracle.com (/10.175.162.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 09:41:57 -0700
Date:   Tue, 2 Jun 2020 17:41:51 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Daniel Borkmann <daniel@iogearbox.net>
cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 2/3] bpf: Add csum_level helper for fixing up csum
 levels
In-Reply-To: <5d317380-142e-c364-2793-68d0bed9efcd@iogearbox.net>
Message-ID: <alpine.LRH.2.21.2006021730340.17227@localhost>
References: <cover.1591108731.git.daniel@iogearbox.net> <279ae3717cb3d03c0ffeb511493c93c450a01e1a.1591108731.git.daniel@iogearbox.net> <CACAyw982WPUfNN_9LD0bhGPTtBSca7t0UV_0UsO3dVGjtEZm9A@mail.gmail.com> <5d317380-142e-c364-2793-68d0bed9efcd@iogearbox.net>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=11 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=11 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020, Daniel Borkmann wrote:

> On 6/2/20 5:19 PM, Lorenz Bauer wrote:
> > On Tue, 2 Jun 2020 at 15:58, Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> Add a bpf_csum_level() helper which BPF programs can use in combination
> >> with bpf_skb_adjust_room() when they pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET
> >> flag to the latter to avoid falling back to CHECKSUM_NONE.
> >>
> >> The bpf_csum_level() allows to adjust CHECKSUM_UNNECESSARY skb->csum_levels
> >> via BPF_CSUM_LEVEL_{INC,DEC} which calls
> >> __skb_{incr,decr}_checksum_unnecessary()
> >> on the skb. The helper also allows a BPF_CSUM_LEVEL_RESET which sets the
> >> skb's
> >> csum to CHECKSUM_NONE as well as a BPF_CSUM_LEVEL_QUERY to just return the
> >> current level. Without this helper, there is no way to otherwise adjust the
> >> skb->csum_level. I did not add an extra dummy flags as there is plenty of
> >> free
> >> bitspace in level argument itself iff ever needed in future.
> >>
> >> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >> ---
> >>   include/uapi/linux/bpf.h       | 43 +++++++++++++++++++++++++++++++++-
> >>   net/core/filter.c              | 38 ++++++++++++++++++++++++++++++
> >>   tools/include/uapi/linux/bpf.h | 43 +++++++++++++++++++++++++++++++++-
> >>   3 files changed, 122 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 3ba2bbbed80c..46622901cba7 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -3220,6 +3220,38 @@ union bpf_attr {
> >>    *             calculation.
> >>    *     Return
> >>    *             Requested value, or 0, if flags are not recognized.
> >> + *
> >> + * int bpf_csum_level(struct sk_buff *skb, u64 level)
> > 
> > u64 flags? We can also stuff things into level I guess.
> 
> Yeah, I did mention it in the commit log. There is plenty of bit space to
> extend
> with flags in there iff ever needed. Originally, helper was called
> bpf_csum_adjust()
> but then renamed into bpf_csum_level() to be more 'topic specific' (aka do one
> thing
> and do it well...) and avoid future api overloading, so if necessary level can
> be
> used since I don't think the enum will be extended much further from what we
> have
> here anyway.
> 
> [...]
> > 
> > Acked-by: Lorenz Bauer <lmb@cloudflare.com>
>

Looks great! The only thing that gave me pause was
the -EACCES return value for the case where we query
and the skb is not subject to CHECKSUM_UNNECESSESARY ;
-ENOENT ("no such level") feels slightly closer to the
situation to me but either is a reasonable choice I think.

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
