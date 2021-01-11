Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27D2F0AE4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 03:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbhAKCDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 21:03:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61039 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbhAKCDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 21:03:32 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210111020246epoutp012dbc81a1c582fb06c731789529efbb3c~ZCx5KYLZL1498414984epoutp01L
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:02:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210111020246epoutp012dbc81a1c582fb06c731789529efbb3c~ZCx5KYLZL1498414984epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610330566;
        bh=/Iude2iisz7XVckjhji6PJ9V5UsIYReD/W4aRp8FiBQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Wc2xhxtCqXsnN0hv19P6tkg0RRG3QIVxImaFIOhMttaI7h0UbCgKrpz2H2JXUte++
         BvsUQiFLgtg9FwE6zBrIUIMkqbA7TvrgxBepclDjgkRl5moGWZNuGnGUh7dsczeQDR
         +x4TSw1cU0kDoZFPzbpTG/hbSzsMbBDttzOGS/+I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210111020245epcas2p4ef5b9b9ae8a6aebfa60146e4eb9f750a~ZCx4oVjBX1287812878epcas2p4k;
        Mon, 11 Jan 2021 02:02:45 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DDcRS5txxz4x9Pr; Mon, 11 Jan
        2021 02:02:44 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.C2.10621.3C1BBFF5; Mon, 11 Jan 2021 11:02:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210111020243epcas2p4083354605de48cc97ceb8fd8ab5fb54e~ZCx2IoN1N1288312883epcas2p4k;
        Mon, 11 Jan 2021 02:02:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210111020243epsmtrp1f1fc8ba01e91779aa1febf9f8e041baf~ZCx2HW_ul0344803448epsmtrp1-;
        Mon, 11 Jan 2021 02:02:43 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-af-5ffbb1c3c820
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.92.08745.3C1BBFF5; Mon, 11 Jan 2021 11:02:43 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210111020242epsmtip2eb83b1c8eaaea05d59c8714e498ff6e2~ZCx159JES2714827148epsmtip2B;
        Mon, 11 Jan 2021 02:02:42 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>,
        "'Alexey Kuznetsov'" <kuznet@ms2.inr.ac.ru>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210108133502.GZ3576117@gauss3.secunet.de>
Subject: RE: [RFC PATCH net] udp: check sk for UDP GRO fraglist
Date:   Mon, 11 Jan 2021 11:02:42 +0900
Message-ID: <003701d6e7bd$d90ea860$8b2bf920$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFzjcR3biIClNsmzYH4fgoQxWffJwE+IFZfAbZGHEmq0LVV0A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmue7hjb/jDc4tULSYc76FxeLCtj5W
        iwttr1gtLu+aw2bRcKeZzeLYAjGL3Z0/2C3ebTnCbvF1bxeLA6fHlpU3mTwWbCr12LSqk82j
        7doqJo8tv7+zefRtWcXosal1CavH501yARxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
        hrqGlhbmSgp5ibmptkouPgG6bpk5QNcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtS
        cgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMo5OmcJWMIGv4vOlzWwNjLO5uxg5OSQETCTa
        jrxg72Lk4hAS2MEoMfvkLxYI5xOjxIP5E9lBqoQEPjNKnH9aANNx++hNRoiiXYwSu9/9YYNw
        XjBKfJh4hgmkik1AS+LNrHZWEFtEwFxi9atpTCBFzAK7mCTebVzD3MXIwcEpYCnxcbUcSI2w
        gL3EiecbWUBsFgFVieuftjGD2LxAJaf+HmaCsAUlTs58AlbDLGAg8f7cfGYIW15i+9s5zBDX
        KUj8fLoMaq+TxN4dEL3MAiISszvbmEFukBA4wCHxc/dbVpAbJARcJB7+ioboFZZ4dXwLO4Qt
        JfGyv40doqReorU7BqK1h1Hiyj6IGyQEjCVmPWtnhKhRljhyC+o0PomOw3+hWnklOtqEIEwl
        iYlf4iEaJSRenJzMMoFRaRaSv2Yh+WsWkr9mIbl/ASPLKkax1ILi3PTUYqMCQ+S43sQITrha
        rjsYJ7/9oHeIkYmD8RCjBAezkgjvwl0/4oV4UxIrq1KL8uOLSnNSiw8xmgKDeiKzlGhyPjDl
        55XEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYDpRwm+e8zDW1+T/
        1qdSTdMS/yx011mz6lXqYuPdS4TPBOTf/q3tNC/GLsy4Mvpy7Rkjm67Y6FJ9gaNJjpmFekfO
        6Jg+MdWU3ZE+X5R7QchB/Zv5WwN4z//jbWG4cJ3hz5ynGZLO8qIxLVuz39zoOy/2KJvNeEKI
        U2aNjINzWuPGvryyT3uDzmp+Pbf761ujuB1Kj46G3eD+bPXSinkba9Yan3sSKmqf+ndPO6/E
        5ehz49cunXzLz2y3ZcVlnTKnTFasEjDm0lNQyMrRi6vc9/HokaNaysrOYhsTJKRYf7luOp0k
        vJchZjbv0nSndf+++rdytq6c+jTmzicTwdn932O6NSK6pkheq6l0nMupxFKckWioxVxUnAgA
        MEYtvkEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvO7hjb/jDWbcYbOYc76FxeLCtj5W
        iwttr1gtLu+aw2bRcKeZzeLYAjGL3Z0/2C3ebTnCbvF1bxeLA6fHlpU3mTwWbCr12LSqk82j
        7doqJo8tv7+zefRtWcXosal1CavH501yARxRXDYpqTmZZalF+nYJXBlHp0xhK5jAV/H50ma2
        BsbZ3F2MnBwSAiYSt4/eZOxi5OIQEtjBKDHh+wzWLkYOoISExK7NrhA1whL3W46wQtQ8Y5T4
        +voXK0iCTUBL4s2sdjBbRMBcYvWraUwgRcwCB5gk9sxczgTRcYRR4s2VCewgUzkFLCU+rpYD
        aRAWsJc48XwjC4jNIqAqcf3TNmYQmxeo5NTfw0wQtqDEyZlPwGqYBYwkzh3azwZhy0tsfzuH
        GeI6BYmfT5dBHeEksXcHRC+zgIjE7M425gmMwrOQjJqFZNQsJKNmIWlZwMiyilEytaA4Nz23
        2LDAKC+1XK84Mbe4NC9dLzk/dxMjOPq0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHehbt+xAvxpiRW
        VqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAlB7+/ug6dpkjaiV3
        bA38tt/5Xbng+eKZxW9diqSWqx1a/US7eW+smfB3h/emxp9nTEyYGX/5yh2ZDSkLuBtfHrWv
        3Hb/lfbqUtalzKu2L7XqepNmuF3sodk655X/37KzNMw4l/uwZhk724ZFy/+95/OtLEt/cLfw
        1u8NX7Sv7arKmPrVYs5bzy8qDM4b8jcc40radD8xdeV3GbtvRT7Tr84of8P7NFfx7mNfzqV1
        nRF7n5zgU1ux6nLjQX69Yz1ZXEIMmvNv1ZStfB/w6n6LY4RhmY/o6eXSfmXhHFwXl3Mm1Leu
        mXjeR/mXTn5qwjG/JwZvo0Sex1nuvNM2If6h8SuZOE+tDSrCmcYPRSI65yixFGckGmoxFxUn
        AgArU31/LQMAAA==
X-CMS-MailID: 20210111020243epcas2p4083354605de48cc97ceb8fd8ab5fb54e
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134
References: <CGME20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134@epcas2p3.samsung.com>
        <1610110348-119768-1-git-send-email-dseok.yi@samsung.com>
        <20210108133502.GZ3576117@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-08 22:35, Steffen Klassert wrote:
> On Fri, Jan 08, 2021 at 09:52:28PM +0900, Dongseok Yi wrote:
> > It is a workaround patch.
> >
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> >
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update any UDP/IP header of the segment list.
> >
> > It might make sense because each skb of frag_skbs is converted to a
> > list of regular packets. Header update with checksum calculation may
> > be not needed for UDP GROed frag_skbs.
> >
> > But UDP GRO frag_list is started from udp_gro_receive, we don't know
> > whether the skb will be NAT forwarded at that time. For workaround,
> > try to get sock always when call udp4_gro_receive -> udp_gro_receive
> > to check if the skb is for local.
> >
> > I'm still not sure if UDP GRO frag_list is really designed for local
> > session only. Can kernel support NAT forward for UDP GRO frag_list?
> > What am I missing?
> 
> The initial idea when I implemented this was to have a fast
> forwarding path for UDP. So forwarding is a usecase, but NAT
> is a problem, indeed. A quick fix could be to segment the
> skb before it gets NAT forwarded. Alternatively we could
> check for a header change in __udp_gso_segment_list and
> update the header of the frag_skbs accordingly in that case.

Thank you for explaining.
Can I think of it as a known issue? I think we should have a fix
because NAT can be triggered by user. Can I check the current status?
Already planning a patch or a new patch should be written?

