Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F281374C7D
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 02:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhEFAqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 20:46:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34400 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhEFAqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 20:46:09 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210506004510epoutp0110016774ba88323bfc2b0e23922b0a21~8U5_cJSM42231322313epoutp01d
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:45:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210506004510epoutp0110016774ba88323bfc2b0e23922b0a21~8U5_cJSM42231322313epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620261910;
        bh=CiOK3qGZ7nBWoEAHSm+8G1elh3nIWvLZdgFSdlkXHcE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gvxJMo7d1beHIupqu5lrZmc9blb3ljuNP6jauNtfhsDDpfIcYbrbvpLQ4nRKRn6gw
         BntHVRfJrdLcs6mVT3LSmJbXo1r2ESqmHfy2pwEwf2wSuPaSONdAtVaje6flra2NNn
         h/QaFUHY39PMp86Ma8aHHCWRivzJ7FBIyOVNUkgY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210506004510epcas2p2b2d6f174318e9894fc6b022182bd4c93~8U59x0lO-1290612906epcas2p2k;
        Thu,  6 May 2021 00:45:10 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FbFGr6TBCz4x9QJ; Thu,  6 May
        2021 00:45:08 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.CF.09604.41C33906; Thu,  6 May 2021 09:45:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210506004508epcas2p18bf556bc66604f19e3613badc48e5831~8U5763EJr2032920329epcas2p1e;
        Thu,  6 May 2021 00:45:08 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210506004508epsmtrp1ff420a29a508c8a748ca8e7a68e547db~8U575_u9x0403004030epsmtrp1j;
        Thu,  6 May 2021 00:45:08 +0000 (GMT)
X-AuditID: b6c32a45-38939a8000002584-0f-60933c1449ee
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.46.08163.41C33906; Thu,  6 May 2021 09:45:08 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210506004507epsmtip1cab4cc63a47d8d01d1d811ad76a2c1a4~8U57rMT1Y0420704207epsmtip1T;
        Thu,  6 May 2021 00:45:07 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Daniel Borkmann'" <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Cc:     "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Andrii Nakryiko'" <andrii@kernel.org>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>,
        "'John Fastabend'" <john.fastabend@gmail.com>,
        "'KP Singh'" <kpsingh@kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>
In-Reply-To: <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
Subject: RE: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
Date:   Thu, 6 May 2021 09:45:07 +0900
Message-ID: <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKypHYW3xad5/j2XvChPebQmKG2owG+YoocAqFpyMuo+9TVEA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDJsWRmVeSWpSXmKPExsWy7bCmqa6IzeQEg4+ztS2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hszi2QMzi5+EzzBaL
        f24Aqlgyg9GBz2PLyptMHhOb37F77Jx1l92j68YlZo9NqzrZPD5vkgtgi8qxyUhNTEktUkjN
        S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VkmhLDGnFCgUkFhcrKRv
        Z1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJNx4+oDxoK5IhVH
        Fl9nb2DczN/FyMkhIWAiseNSA0sXIxeHkMAORomrv54yQzifGCV6Xs1mA6kSEvjMKPH0tz5M
        x/H9s1khinYxSuzYsIUdwnnBKNGw6RcLSBWbgJbEm1ntQFUcHCICrhJHP8aAhJkFTjNLPHti
        AGJzCjhKHJ/8iRnEFhYIlng6qYkJxGYRUJF49mgOK4jNK2ApcfzwV2YIW1Di5MwnLBBz5CW2
        v53DDHGQgsTPp8tYIeIiErM728DiIgJOEtcuH2EEuU1C4AqHxMo3v1khGlwkfh1/ygZhC0u8
        Og7yAIgtJfGyv40d5GYJgXqJ1u4YiN4eRokr+yAWSwgYS8x61s4IUsMsoCmxfpc+RLmyxJFb
        UKfxSXQc/gs1hVeio00IwlSSmPglHmKGhMSLk5NZJjAqzULy1ywkf81C8ssshFULGFlWMYql
        FhTnpqcWGxUYIsf0JkZwMtZy3cE4+e0HvUOMTByMhxglOJiVRHgL1vYnCPGmJFZWpRblxxeV
        5qQWH2I0BYb0RGYp0eR8YD7IK4k3NDUyMzOwNLUwNTOyUBLn/ZlalyAkkJ5YkpqdmlqQWgTT
        x8TBKdXAZFMe+FnjWKb9qokqbs+W/qw8eNz/mGxbC3vSjp2LxYS5T7OYX5K71OOf2Nd59OG7
        adrCm+I56ooNta8l7P1g9nH2/ALr4tMHBGXXrgw9pycr4LRDk13NfZ2XwX25O+yyHFm9r9an
        7ZzJ9yk3rHxG9STfv4nP//F0HnuS/J7xXS+jhvm6x5sfyr55dP+enWSeziT+1q/H7UvVTztv
        npvb8j7JIlMiUfvT2n8vnmcudXnWLblnr/3B6JfhyS5/pyXomM6+bPLw9QbXUxFR9Ycf1zxJ
        NY4xVvrNIRId2xez/1zo8R3SnufPZtyaysCa2BT8JaDxqOIiofzCTPm/QTtMUicsOuyRrlvp
        UpcVXP9DiaU4I9FQi7moOBEALna7V08EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnK6IzeQEg1vr2Cy+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFoumHSuYLF58eMJo8XxfL5PFhW19rBaXd81hszi2QMzi5+EzzBaL
        f24Aqlgyg9GBz2PLyptMHhOb37F77Jx1l92j68YlZo9NqzrZPD5vkgtgi+KySUnNySxLLdK3
        S+DKuHH1AWPBXJGKI4uvszcwbubvYuTkkBAwkTi+fzZrFyMXh5DADkaJZxuvsncxcgAlJCR2
        bXaFqBGWuN9yBKrmGaPElO4eZpAEm4CWxJtZ7awg9SIC7hLbjheD1DALXGWW2LBxBVTDKUaJ
        lTt/soM0cAo4Shyf/AmsWVggUKL/3y1GEJtFQEXi2aM5rCA2r4ClxPHDX5khbEGJkzOfsIDY
        zALaEr0PWxkhbHmJ7W/nMENcpyDx8+kyVoi4iMTszjawuIiAk8S1y0cYJzAKz0IyahaSUbOQ
        jJqFpH0BI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg6NTS2sG4Z9UHvUOMTByM
        hxglOJiVRHgL1vYnCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbL
        xMEp1cDkYZCmb9/wZ5eb9D8es0+iER8WFGX8WRSdLr5gmf9WDu0HLy1f8m05nBmuMIP/sZS6
        qojBJIdF6oVPS3frMVknx5e2vOYq9QypYEn5c5rr4DnTldkl18y+3HSb2XZKWSXknOyBrw1B
        7rMtbv0N/bRsdkjtk0+/n35wMDG3Wf32ldkilu7Z8mfmZDsksgTsCc6zn3PQlvOV3MF0dZP9
        K/NrYy77xCdzH7pYXf737sp13QdLJyzbZciUmXa+4urpLqXg0tmzlP/ocegW1l/61qCUW5m9
        fu4imU3850uN9hV1ZNW1Niq90uIqu3vmb7dnL4totF/yl+mFV06nPrO/Z8Cp+uFyxdlLbaLB
        036Vr1JiKc5INNRiLipOBABIWw+cPQMAAA==
X-CMS-MailID: 20210506004508epcas2p18bf556bc66604f19e3613badc48e5831
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210429102143epcas2p4c8747c09a9de28f003c20389c050394a
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
        <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 10:55:10PM +0200, Daniel Borkmann wrote:
> On 4/29/21 12:08 PM, Dongseok Yi wrote:
> > tcp_gso_segment check for the size of GROed payload if it is bigger
> > than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> > bigger than the size of GROed payload unexpectedly if data_len is not
> > big enough.
> >
> > Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
> > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > with 1380 <= 1392.
> >
> > Check for the size of GROed payload if it is really bigger than target
> > mss when increase mss.
> >
> > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> >   net/core/filter.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 9323d34..3f79e3c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> >   		}
> >
> >   		/* Due to IPv4 header, MSS can be upgraded. */
> > -		skb_increase_gso_size(shinfo, len_diff);
> > +		if (skb->data_len > len_diff)
> 
> Could you elaborate some more on what this has to do with data_len specifically
> here? I'm not sure I follow exactly your above commit description. Are you saying
> that you're hitting in tcp_gso_segment():
> 
>          [...]
>          mss = skb_shinfo(skb)->gso_size;
>          if (unlikely(skb->len <= mss))
>                  goto out;
>          [...]

Yes, right

> 
> Please provide more context on the bug, thanks!

tcp_gso_segment():
        [...]
	__skb_pull(skb, thlen);

        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
        [...]

skb->len will have total GROed TCP payload size after __skb_pull.
skb->len <= mss will not be happened in a normal GROed situation. But
bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
hit an error condition.

We should ensure the following condition.
total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)

Due to
total GROed TCP payload = the original mss + skb->data_len
IPv6 size - IPv4 size = len_diff

Finally, we can get the condition.
skb->data_len > len_diff

> 
> > +			skb_increase_gso_size(shinfo, len_diff);
> > +
> >   		/* Header must be checked, and gso_segs recomputed. */
> >   		shinfo->gso_type |= SKB_GSO_DODGY;
> >   		shinfo->gso_segs = 0;
> >


