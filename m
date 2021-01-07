Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278672ECEE3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhAGLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:41:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12819 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbhAGLlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:41:03 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210107114020epoutp02f80dd74c6f769e723b86eda37c2af407~X8FCDbrDM3064730647epoutp02r
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 11:40:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210107114020epoutp02f80dd74c6f769e723b86eda37c2af407~X8FCDbrDM3064730647epoutp02r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610019620;
        bh=6Ap581Jx/ziXeV0lLyPgUqLA2un92mIco2n3ISCJq/4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Ds2CjUpxlgXoEbTxAuxJ79uJUuC0cPsc6avar+q+YPqSIU0bbwTxz6hNJAjhO2Dud
         3Xk2ykI4LTs4+JXA4i+YAm24TUhlT6dHHtpwTb3DJ2k1fC7HH69X87gp1Pox+pITT5
         Z1CYS4l5VeaH0OcUwnqxN6/iEZr5bHc1phlkCMdg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210107114018epcas2p33a2646ef65b58953bfb4977eb736f228~X8FArEFHx1947219472epcas2p3T;
        Thu,  7 Jan 2021 11:40:18 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DBPRj0khCz4x9Pp; Thu,  7 Jan
        2021 11:40:17 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.53.56312.023F6FF5; Thu,  7 Jan 2021 20:40:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210107114015epcas2p4a0cf77bfc460baaf218e3269a6521b45~X8E95Vbm_0720507205epcas2p4I;
        Thu,  7 Jan 2021 11:40:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210107114015epsmtrp1d7240dbe8e70f24ae5590dca6ba4327f~X8E90UKe_2121121211epsmtrp1h;
        Thu,  7 Jan 2021 11:40:15 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-99-5ff6f320b9b0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.98.13470.F13F6FF5; Thu,  7 Jan 2021 20:40:15 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210107114015epsmtip22dabc353e29bcd54d6cf24ef1312ca2b~X8E9fFm621170511705epsmtip2N;
        Thu,  7 Jan 2021 11:40:15 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Willem de Bruijn'" <willemb@google.com>
Cc:     "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Miaohe Lin'" <linmiaohe@huawei.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Florian Westphal'" <fw@strlen.de>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'Guillaume Nault'" <gnault@redhat.com>,
        "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        "'Marco Elver'" <elver@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
In-Reply-To: <83a2b288-c0b2-ed98-9479-61e1cbe25519@iogearbox.net>
Subject: RE: [PATCH net v2] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Thu, 7 Jan 2021 20:40:14 +0900
Message-ID: <028b01d6e4e9$ddd5fd70$9981f850$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCENc+NAyQMqgCGEz6xhAsYrD3IVQLGY4ZsAcImhwYCjYeBdKyIs4GA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbZRjG/XrOaQuu21nB7ROzrTtblgwGtMV2H254RXLiiBIxWaJgaeix
        IL2lBxySoOCgA2SrCBotLBbszFYTgZbAhgjhIsjFsgwvG0GyMNgYUscAgbEBtj0s8t/zvvk9
        7+W7CDHxTX6YMNOQzZgNah3FD8abuw+jyP0LSyqpdSf6tnYJQzXDRTiyDLUQqPns9wB9Nd8o
        QFebzxHoh+Y6gEqXL+BopLWGjwq8wahg7DQf9dp3oaXBWYB+LF0RoOG1PgL909QjeJGkmy7d
        4NFXbH8JaLsrhy7q8RJ02fVrGO1ylvLpe+2/8+lzTU5Au4odBN21bCfoBdde2jXp5SVte1t3
        PINRaxizhDGkGzWZBm0cdSJZ9YpKoZTKImWx6CglMaj1TBwVn5gUmZCp861EST5Q63J8qSQ1
        y1LRzx83G3OyGUmGkc2OoxiTRmeSyUxRrFrP5hi0UelG/XMyqVSu8JFpuowrrkaeqVWS655v
        xwtA79NlIEgIyWdhSUM3VgaChWLyMoB3Bjs2g3kArQse4KfE5BKAlW2nHjtKh8pxDvoJwPNf
        egQcNA3gvaEIv+aT4XDWdobwQ6GkBUDnJ50Cf4CRjzC4ctEacASRL8HCGmegRQh5Eq5aNnxa
        KMTJg7CuKNefFpGx0HH/Ps7pnbD/68mAxsh9sMVbg3ETSeCDqe8IvzWUTIAX/z7EIaGwutQS
        2AaS1iA4uv4H7mcgGQ/La9/nrCFwpq9JwOkweNdqEXDIx7D40xTOWg7gb+1cW0jGQNvtM4Ep
        MfIwrG+N5vADsGd0c7DtsKR7bbOKCJZYxJykYMWiiqsB4XR/Jf4ZoGxbtrJt2cq2ZXzb/63s
        AHeCXYyJ1WsZVm6Sb71oFwg89fCEy6DKOxfVBXhC0AWgEKNCRah3USUWadQf5jFmo8qco2PY
        LqDwHXMFFvZUutH3VwzZKplCrlRKYxVIoZQjareIld5UiUmtOpvJYhgTY37s4wmDwgp4/Snt
        p48cq/uoMm4g9gJNyNcTx8q7fk6ufXPqrfqj1cPEvtHxzvEvJqLFiZnLZSVVblGEe+11V/8E
        Lu3MYiI6Ym41dnqeUT6xmxDMxD+MLk61W6/lnXpoPcbsyU9KmX119PrVjdw+TVH15JM3zG3r
        9KBrpWUsOS3Smw/e+GZVm5HKNKxO54GBkz3jG3NZCr3dsu3XjQfvvYDV74D8BHdDxZ67v2x3
        yG+L+hz/Tpw4MD79+dy7rc2L9MvVxktT/ba2s4eMisHc1UcDHS3OnpH5QgMKIhUxnpEjrzkT
        nVrKY5yZXgg56LizNz/V0GB958+s85324JC0W253gQRPwqoKKZzNUMvCMTOr/g8wA0N0cwQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWy7bCSvK7852/xBtvmalosXviN2WLO+RYW
        i7Yz21kttvWuZrSY8Wkju8WFbX2sFuu2LWK06Py+lMXi8q45bBYNb7ksGu40s1kcWyBm8e30
        G0aL3Z0/2C3O/z3OavFuyxF2BwGPLStvMnnsnHWX3WPBplKPliNvWT26blxi9ti0qpPN4/2+
        q2wefVtWMXpsal3C6nHo+wJWj8+b5Dw2PXnLFMATxWWTkpqTWZZapG+XwJWxc9NGpoJdChWb
        P+1jaWA8JtnFyMkhIWAi0Xmmh6WLkYtDSGA3o8T5ow1MXYwcQAkJiV2bXSFqhCXutxxhhah5
        xiixbfsWRpAEm4CWxJtZ7WAJEYEORolZP/vYQBxmgTYWif2zzrNDtLQxSTxp+sUM0sIp4CjR
        OGcVWLuwQKjE/b0nGEHWsQioSCxqqQAJ8wpYSiz5+JEFwhaUODnzCZjNLKAt0fuwlRHClpfY
        /nYOM8R5ChI/ny5jBRkjIuAmseK1GkSJiMTszjbmCYzCs5BMmoVk0iwkk2YhaVnAyLKKUTK1
        oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM40rU0dzBuX/VB7xAjEwfjIUYJDmYlEV6LY1/i
        hXhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamAqX7Baw+aC
        jcq8T5VP5+tIGps9ZrTRTTxiF/Jau7fj8yP/bzlvHgWe0Yjd90CAx0vmz35JmXMqMaHxqQ/F
        50muf7hkWkaLb1vZDS8J0V1nNjJM5L7yf/8Eo2N67/R4rS/Leend1thZ8im4wzE2dMX9W4v3
        2Kr90Y3rW9fIOG1h3MPfX+ZfrlEuyLvwqvkxR1Wb8QWd+ssSEY/n+ezaLsl+bf2NQI9jM8st
        jx15wn/VplBc9Gt/8PQmy9OxMl6MlmfMS5oFp/Fr2H5dJZJSKxa1iD+2Xe/zi6MXUph8an5f
        nWk9if3mnhRt4Xq1hc8skn+bvtCanhPW6fGHb/ne59d+/ygqWnl1Rbv/3kXdhwKUWIozEg21
        mIuKEwElJpKCYwMAAA==
X-CMS-MailID: 20210107114015epcas2p4a0cf77bfc460baaf218e3269a6521b45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210107005028epcas2p35dfa745fd92e31400024874f54243556
References: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210107005028epcas2p35dfa745fd92e31400024874f54243556@epcas2p3.samsung.com>
        <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
        <83a2b288-c0b2-ed98-9479-61e1cbe25519@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-07 20:05, Daniel Borkmann wrote:
> 
> On 1/7/21 1:39 AM, Dongseok Yi wrote:
> > skbs in fraglist could be shared by a BPF filter loaded at TC. It
> > triggers skb_ensure_writable -> pskb_expand_head ->
> > skb_clone_fraglist -> skb_get on each skb in the fraglist.
> >
> > While tcpdump, sk_receive_queue of PF_PACKET has the original fraglist.
> > But the same fraglist is queued to PF_INET (or PF_INET6) as the fraglist
> > chain made by skb_segment_list.
> >
> > If the new skb (not fraglist) is queued to one of the sk_receive_queue,
> > multiple ptypes can see this. The skb could be released by ptypes and
> > it causes use-after-free.
> >
> > [ 4443.426215] ------------[ cut here ]------------
> > [ 4443.426222] refcount_t: underflow; use-after-free.
> > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > [ 4443.426808] Call trace:
> > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426823]  skb_release_data+0x144/0x264
> > [ 4443.426828]  kfree_skb+0x58/0xc4
> > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > [ 4443.426880]  el0_svc+0x8/0xc
> >
> > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > ---
> >   net/core/skbuff.c | 20 +++++++++++++++++++-
> >   1 file changed, 19 insertions(+), 1 deletion(-)
> >
> > v2: Expand the commit message to clarify a BPF filter loaded
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f62cae3..1dcbda8 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >   	unsigned int delta_truesize = 0;
> >   	unsigned int delta_len = 0;
> >   	struct sk_buff *tail = NULL;
> > -	struct sk_buff *nskb;
> > +	struct sk_buff *nskb, *tmp;
> > +	int err;
> >
> >   	skb_push(skb, -skb_network_offset(skb) + offset);
> >
> > @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >   		nskb = list_skb;
> >   		list_skb = list_skb->next;
> >
> > +		err = 0;
> > +		if (skb_shared(nskb)) {
> > +			tmp = skb_clone(nskb, GFP_ATOMIC);
> > +			if (tmp) {
> > +				kfree_skb(nskb);
> 
> Should use consume_skb() to not trigger skb:kfree_skb tracepoint when looking
> for drops in the stack.

I will use to consume_skb() on the next version.

> 
> > +				nskb = tmp;
> > +				err = skb_unclone(nskb, GFP_ATOMIC);
> 
> Could you elaborate why you also need to unclone? This looks odd here. tc layer
> (independent of BPF) from ingress & egress side generally assumes unshared skb,
> so above clone + dropping ref of nskb looks okay to make the main skb struct private
> for mangling attributes (e.g. mark) & should suffice. What is the exact purpose of
> the additional skb_unclone() in this context?

Willem de Bruijn said:
udp_rcv_segment later converts the udp-gro-list skb to a list of
regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
Now all the frags are fully fledged packets, with headers pushed
before the payload.

PF_PACKET handles untouched fraglist. To modify the payload only
for udp_rcv_segment, skb_unclone is necessary.

> 
> > +			} else {
> > +				err = -ENOMEM;
> > +			}
> > +		}
> > +
> >   		if (!tail)
> >   			skb->next = nskb;
> >   		else
> >   			tail->next = nskb;
> >
> > +		if (unlikely(err)) {
> > +			nskb->next = list_skb;
> > +			goto err_linearize;
> > +		}
> > +
> >   		tail = nskb;
> >
> >   		delta_len += nskb->len;
> >


