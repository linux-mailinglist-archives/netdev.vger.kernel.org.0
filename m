Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61892F9A71
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 08:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbhARHYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 02:24:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50655 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbhARHYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 02:24:44 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210118072400epoutp0428228ee6d0034285b38e3ee4431253d9~bQrXRHQdj3272632726epoutp04R
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:24:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210118072400epoutp0428228ee6d0034285b38e3ee4431253d9~bQrXRHQdj3272632726epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610954640;
        bh=KUYnFrQQiLvM53tGvfI7wjeX9q4XPE9p+JGYahARuG8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=emL74G6SFKAHIXUCrRsZvwXT0Cx8hv+w63dQ5XoUua9ruM2+oiyyVvnO0yHXsCEnC
         idGw+E9NF7rykTBtKQooYc+K2BrV3Qa+cixiyLRVM6qKVI+1AJTQgsfYy+eZ1VVBqu
         FUjfZ6E75ZbYvVeZDKezw01+lqdKVu1xCCS3FOGI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210118072359epcas2p20780fab8856ac7a7eca6d71fdfa73da3~bQrWy9hme2235322353epcas2p25;
        Mon, 18 Jan 2021 07:23:59 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DK3Ds1474z4x9Pp; Mon, 18 Jan
        2021 07:23:57 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.AF.52511.B8735006; Mon, 18 Jan 2021 16:23:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210118072355epcas2p42644ef37dba3831f50a02c26f4b2661a~bQrSmpRt32759627596epcas2p4Q;
        Mon, 18 Jan 2021 07:23:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210118072355epsmtrp17a22cf9ed76f03265488a8d434cb43a4~bQrSljeJ_2562325623epsmtrp12;
        Mon, 18 Jan 2021 07:23:55 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-a7-6005378be2a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.C7.08745.B8735006; Mon, 18 Jan 2021 16:23:55 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210118072355epsmtip1b1abf3caf3edfa5c0e96b840448cf23e~bQrSUiCyJ2579825798epsmtip12;
        Mon, 18 Jan 2021 07:23:55 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Alexander Lobakin'" <alobakin@pm.me>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>, "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210118063759.GK3576117@gauss3.secunet.de>
Subject: RE: [PATCH net v2] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Mon, 18 Jan 2021 16:23:54 +0900
Message-ID: <004c01d6ed6a$e0ff43b0$a2fdcb10$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJT4Rp7bAvF1bGeZTYGN+mZAmy16AFN1KutAf1qvD8BNDU5EqkPEZpQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmuW63OWuCwdnThharHm9nsZhzvoXF
        4sK2PlaLy7vmsFk03Glmszi2QMxid+cPdot3W46wW3zd28XiwOmxZeVNJo8Fm0o9Nq3qZPNo
        u7aKyePonnNsHn1bVjF6bGpdwurxeZNcAEdUjk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmB
        oa6hpYW5kkJeYm6qrZKLT4CuW2YO0HVKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKU
        nAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjI+d+9kKfghXzP75n7GB8Tl/FyMnh4SAiUTn
        2nOMXYxcHEICOxgl1t88zASSEBL4xCix8V4iROIzo8TxWS+YYToeNPayQiR2MUq8/LaJCcJ5
        wShxcGc7C0gVm4CWxJtZ7awgtohAosSOR1/AipgFupkkdl+cC5bgFLCU2P18JzuILSwQI/F0
        UicbiM0ioCrx6PZNsDgvUM3L5tUsELagxMmZT8BsZgEDiffn5jND2PIS29/OgTpPQeLn02VQ
        i90k+h8/Y4WoEZGY3dkGVbODQ+LiFTEI20Vi7fQ2dghbWOLV8S1QtpTEy36QOAeQXS/R2h0D
        cr+EQA+jxJV9EDdICBhLzHrWzghRoyxx5BbUaXwSHYf/QrXySnS0CUGYShITv8RDNEpIvDg5
        mWUCo9IsJH/NQvLXLCR/zUJy/wJGllWMYqkFxbnpqcVGBSbIkb2JEZxytTx2MM5++0HvECMT
        B+MhRgkOZiUR3tJ1TAlCvCmJlVWpRfnxRaU5qcWHGE2BQT2RWUo0OR+Y9PNK4g1NjczMDCxN
        LUzNjCyUxHmLDB7ECwmkJ5akZqemFqQWwfQxcXBKNTAtes7U03Pt+eqLK9ObpznYX3i6K0Zq
        sUhEm1wl2+7bCtxttXcVdBmq5ScJqV3SYlsr8PHzkVfF0n9m3hfvv6ibpcJxVTFq2fLH0Sdz
        HvaeO3Rn3r/z19c1dDRuvSN84tNGw4owtapo77adRvddhZdbKBfPnrG28CLPdJktords85kC
        nVYu23WIe4uNs8rDhrY/pW23LTK01PcHxDMtWPt91+/uMo8lZYvS7xe4V019wmTqY1QZsPKb
        1pW/P26bfC7esX5GbvqedeW3ON7XOgf0lxb9/eXzt+K6Q2b7Yv0NzZZKGvXB6zbJffkX9TfD
        8OVj9Wp/0fq4aznLJ04Jmss+d0HETbHEV1uLcicrP/mlxFKckWioxVxUnAgAJjPhr0IEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSnG63OWuCwdwz3BarHm9nsZhzvoXF
        4sK2PlaLy7vmsFk03Glmszi2QMxid+cPdot3W46wW3zd28XiwOmxZeVNJo8Fm0o9Nq3qZPNo
        u7aKyePonnNsHn1bVjF6bGpdwurxeZNcAEcUl01Kak5mWWqRvl0CV8bHzv1sBT+EK2b//M/Y
        wPicv4uRk0NCwETiQWMvK4gtJLCDUeLhfYcuRg6guITErs2uECXCEvdbjgCVcAGVPGOU6N+z
        gRkkwSagJfFmVjtYr4hAosTt6SfYQIqYBSYySVx5uJARouMto8SjjfPBOjgFLCV2P9/JDmIL
        C0RJ9La9A4uzCKhKPLp9EyzOC1Tzsnk1C4QtKHFy5hMwm1nASOLcof1sELa8xPa3c5ghzlOQ
        +Pl0GdQVbhL9j5+xQtSISMzubGOewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sNC4zy
        Usv1ihNzi0vz0vWS83M3MYKjT0trB+OeVR/0DjEycTAeYpTgYFYS4S1dx5QgxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA5OV5btX7nGr1/+60TEjX6Fm
        2o1/XTfCLYpcPm98uYEtZH6/odvGb9WhecdYT/T3vRW+lFk3k+10fIXc8m+d4gYNGRKK8THR
        v0vD9GyUbsZWP1rXsdfxjJTksUsaUq4dNqK7ftQecmlbcn26vGuw2oOdgvw7PhrrfVQv3tby
        OnD55Fghnywt9xdOX2bvKv31c/YlnTULJnWzX9HqWvJ+1sr0nSGlm1bcL5FNmKboaXhlxeSo
        zD1MV+71P9UV2B8aaz/jmVyRd8rZ4++5X76a0nJLamL1U2eTHKfe6HVCD1VVwn8uWX5t2q4d
        pQbnBGWT+3xftXIzrV1fsEbjf9rHTC4Nj8xPopW2J2JKpgX0NCuxFGckGmoxFxUnAgDg+KFz
        LQMAAA==
X-CMS-MailID: 20210118072355epcas2p42644ef37dba3831f50a02c26f4b2661a
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
        <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
        <20210115171203.175115-1-alobakin@pm.me>
        <20210118063759.GK3576117@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-18 15:37, Steffen Klassert wrote:
> On Fri, Jan 15, 2021 at 05:12:33PM +0000, Alexander Lobakin wrote:
> > From: Dongseok Yi <dseok.yi@samsung.com>
> > Date: Fri, 15 Jan 2021 22:20:35 +0900
> >
> > > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > > skb_gso_segment is updated but following frag_skbs are not updated.
> > >
> > > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > > does not try to update UDP/IP header of the segment list but copy
> > > only the MAC header.
> > >
> > > Update dport, daddr and checksums of each skb of the segment list
> > > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> > >
> > > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > ---
> > > v1:
> > > Steffen Klassert said, there could be 2 options.
> > > https://lore.kernel.org/patchwork/patch/1362257/
> > > I was trying to write a quick fix, but it was not easy to forward
> > > segmented list. Currently, assuming DNAT only.
> > >
> > > v2:
> > > Per Steffen Klassert request, move the procedure from
> > > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> > >
> > > To Alexander Lobakin, I've checked your email late. Just use this
> > > patch as a reference. It support SNAT too, but does not support IPv6
> > > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > > to the file is in IPv4 directory.
> >
> > I used another approach, tried to make fraglist GRO closer to plain
> > in terms of checksummming, as it is confusing to me why GSO packet
> > should have CHECKSUM_UNNECESSARY.
> 
> This is intentional. With fraglist GRO, we don't mangle packets
> in the standard (non NAT) case. So the checksum is still correct
> after segmentation. That is one reason why it has good forwarding
> performance when software segmentation is needed. Checksuming
> touches the whole packet and has a lot of overhead, so it is
> heplfull to avoid it whenever possible.
> 
> We should find a way to do the checksum only when we really
> need it. I.e. only if the headers of the head skb changed.

It would be not easy to detect if the skb is mangled by netfilter. I
think v2 patch has little impact on the performance. Can you suggest
an another version? If not, I can make v3 including 80 columns
warning fix.

