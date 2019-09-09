Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD3BAE100
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbfIIW2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:28:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbfIIW2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:28:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x89MOsD8153655;
        Mon, 9 Sep 2019 22:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=mCSo/zj7/YSUjXhq0JKwCa5UQGg5IoMmZftszTYHZC4=;
 b=FCgXhWBzo6opTttCTRpv/gbHEoCkcMLG9AGKk2++SgoMz+DHAmGjEDB2Ru0qCPtPKKzg
 nltKcFJsUKWZVS5OZd2Mg6VZWbPH6hdZNH6FUts9Xhc4WdZwWBaI+hUnCVAm4ftx5BTj
 u2ZSfXHVUxcmhh3zbtUYU2Vr4ChHBw9AgaiJ+5MUrGOtDiWV0fldM5aNyg0TJpZeJaeP
 lx3pogzH0qwCsrENQfjnSsDC6UO8DabVOU3x++93qEDgF5QaXtW0aMEX+9Sy9TAiQvqw
 SNycnLmbgXbWN0luwyhiBzN75BfgddYGKZQ35SFjspxkk1kquG8z9td8WD70KXEap2uH Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uw1jk7d59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Sep 2019 22:25:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x89MP0YJ016162;
        Mon, 9 Sep 2019 22:25:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2uwqqcyw78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Sep 2019 22:25:22 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x89MPJAJ023570;
        Mon, 9 Sep 2019 22:25:19 GMT
Received: from dhcp-10-175-172-139.vpn.oracle.com (/10.175.172.139)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Sep 2019 15:25:18 -0700
Date:   Mon, 9 Sep 2019 23:25:05 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-172-139.vpn.oracle.com
To:     Yonghong Song <yhs@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "quentin.monnet@netronome.com" <quentin.monnet@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        "joe@wand.net.nz" <joe@wand.net.nz>,
        "acme@redhat.com" <acme@redhat.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "alexey.budankov@linux.intel.com" <alexey.budankov@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "peter@lekensteyn.nl" <peter@lekensteyn.nl>,
        "ivan@cloudflare.com" <ivan@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "bhole_prashant_q7@lab.ntt.co.jp" <bhole_prashant_q7@lab.ntt.co.jp>,
        "david.calavera@gmail.com" <david.calavera@gmail.com>,
        "danieltimlee@gmail.com" <danieltimlee@gmail.com>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        toke@redhat.com, jbenc@redhat.com, acme@redhat.com
Subject: Re: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing
 programs
In-Reply-To: <89305ec8-7e03-3cd0-4e39-c3760dd3477b@fb.com>
Message-ID: <alpine.LRH.2.20.1909092236490.10757@dhcp-10-175-172-139.vpn.oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com> <1567892444-16344-3-git-send-email-alan.maguire@oracle.com> <89305ec8-7e03-3cd0-4e39-c3760dd3477b@fb.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9375 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909090213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9375 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909090213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 8 Sep 2019, Yonghong Song wrote:
 
> For net side bpf_perf_event_output, we have
> static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
>                                    unsigned long off, unsigned long len)
> {
>          void *ptr = skb_header_pointer(skb, off, len, dst_buff);
> 
>          if (unlikely(!ptr))
>                  return len;
>          if (ptr != dst_buff)
>                  memcpy(dst_buff, ptr, len);
> 
>          return 0;
> }
> 
> BPF_CALL_5(bpf_skb_event_output, struct sk_buff *, skb, struct bpf_map 
> *, map,
>             u64, flags, void *, meta, u64, meta_size)
> {
>          u64 skb_size = (flags & BPF_F_CTXLEN_MASK) >> 32;
> 
>          if (unlikely(flags & ~(BPF_F_CTXLEN_MASK | BPF_F_INDEX_MASK)))
>                  return -EINVAL;
>          if (unlikely(skb_size > skb->len))
>                  return -EFAULT;
> 
>          return bpf_event_output(map, flags, meta, meta_size, skb, skb_size,
>                                  bpf_skb_copy);
> }
> 
> It does not really consider output all the frags.
> I understand that to get truly all packet data, frags should be
> considered, but seems we did not do it before? I am wondering
> whether we need to do here.

Thanks for the feedback! In experimenting with packet capture,
my original hope was to keep things simple and avoid fragment parsing
if possible. However if scatter-gather is enabled for the networking
device, or indeed if it's running in a VM it turns out a lot of the
interesting packet data ends up in the fragments on transmit (ssh
headers, http headers etc).  So I think it would be worth considering
adding support for fragment traversal.  It's not needed as much
in the skb program case - we can always pullup the skb - but in
the tracing situation we probably wouldn't want to do something
that invasive in tracing context.

Fragment traversal might be worth breaking out as a separate patchset, 
perhaps triggered by a specific flag to bpf_skb_event_output?

Feedback from folks at Linux Plumbers (I hope I'm summarizing correctly) 
seemed to agree with what you mentioned WRT the first patch in this 
series.  The gist was we probably don't want to force the metadata to be a 
specific packet capture type; we'd rather use the existing perf event 
mechanisms and if we are indeed doing packet capture, simply specify that 
data in the program as metadata. 

I'd be happy with that approach myself if I could capture skb 
fragments in tracing programs - being able to do that would give 
equivalent functionality to what I proposed but without having a packet 
capture-specific helper.
> 
> If we indeed do not need to handle frags here, I think maybe
> bpf_probe_read() in existing bpf kprobe function should be
> enough, we do not need this helper?
> 

Certainly for many use cases, that will get you most of what you need - 
particularly if you're just looking at L2 to L4 data. For full packet 
capture however I think we may need to think about fragment traversal.

> > +
> > +/* Derive protocol for some of the easier cases.  For tracing, a probe point
> > + * may be dealing with packets in various states. Common cases are IP
> > + * packets prior to adding MAC header (_PCAP_TYPE_IP) and a full packet
> > + * (_PCAP_TYPE_ETH).  For other cases the caller must specify the
> > + * protocol they expect.  Other heuristics for packet identification
> > + * should be added here as needed, since determining the packet type
> > + * ensures we do not capture packets that fail to match the desired
> > + * pcap type in BPF_F_PCAP_STRICT_TYPE mode.
> > + */
> > +static inline int bpf_skb_protocol_get(struct sk_buff *skb)
> > +{
> > +	switch (htons(skb->protocol)) {
> > +	case ETH_P_IP:
> > +	case ETH_P_IPV6:
> > +		if (skb_network_header(skb) == skb->data)
> > +			return BPF_PCAP_TYPE_IP;
> > +		else
> > +			return BPF_PCAP_TYPE_ETH;
> > +	default:
> > +		return BPF_PCAP_TYPE_UNSET;
> > +	}
> > +}
> > +
> > +BPF_CALL_5(bpf_trace_pcap, void *, data, u32, size, struct bpf_map *, map,
> > +	   int, protocol_wanted, u64, flags)
> 
> Up to now, for helpers, verifier has a way to verifier it is used 
> properly regarding to the context. For example, for xdp version
> perf_event_output, the help prototype,
>    BPF_CALL_5(bpf_xdp_event_output, struct xdp_buff *, xdp, struct 
> bpf_map *, map,
>             u64, flags, void *, meta, u64, meta_size)
> the verifier is able to guarantee that the first parameter
> has correct type xdp_buff, not something from type cast.
>    .arg1_type      = ARG_PTR_TO_CTX,
> 
> This helper, in the below we have
>    .arg1_type	= ARG_ANYTHING,
> 
> So it is not really enforced. Bringing BTF can help, but type
> name matching typically bad.
> 
> 
One thing we were discussing - and I think this is similar to what
you're suggesting - is to investigate if there might be a way to
leverage BTF to provide additional guarantees that the tracing
data we are handling is indeed an skb.  Specifically if we
trace a kprobe function argument or a tracepoint function, and
if we had that guarantee, we could perhaps invoke the skb-style
perf event output function (trace both the skb data and the metadata).
The challenge would be how to do that type-based matching; we'd
need the function argument information from BTF _and_ need to
somehow associate it at probe attach time. 

Thanks again for looking at the code!

Alan
