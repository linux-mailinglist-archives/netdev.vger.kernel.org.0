Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEA4BA361
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242022AbiBQOoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:44:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbiBQOo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:44:27 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBCB20D345
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:44:10 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220217144407euoutp01b0e0c4a78de721b6c3dbbe9f1ea889eb~UmfZ-IAVT2353723537euoutp01M
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 14:44:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220217144407euoutp01b0e0c4a78de721b6c3dbbe9f1ea889eb~UmfZ-IAVT2353723537euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1645109047;
        bh=WKwQivU1aXVBSViyMxceD/bLtydyZBoOw9KFoydIfRQ=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=hmMMTa/5scM1lAmzzecr1O3lzOBBwBdqP+1H1wu8yihwZ3W9yfJxIUpDxd4ZyUFTQ
         zFvwKimWkzgw8wSM7DZD7VRF4lr66YUrWUCCWx03NoTrXZ+7NppiguPfcOvldFRYfh
         4J7ox+pZRyhAJVi1YImD0BvvScSrLhBVaOJ5c35Y=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220217144407eucas1p1bce23a558e38be68a47bcca7a25b0bdb~UmfZk17iw1004110041eucas1p1r;
        Thu, 17 Feb 2022 14:44:07 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 54.2A.09887.73F5E026; Thu, 17
        Feb 2022 14:44:07 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220217144406eucas1p2fe25b2fd40f7f7bf8b5c0dc898c16a2b~UmfY9sTsf2096520965eucas1p2s;
        Thu, 17 Feb 2022 14:44:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220217144406eusmtrp273b5ac1c84f7daef09e4e61da6b5b95b~UmfY8ves41922319223eusmtrp2k;
        Thu, 17 Feb 2022 14:44:06 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-c6-620e5f377ee6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B2.99.09522.63F5E026; Thu, 17
        Feb 2022 14:44:06 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220217144405eusmtip2f713d88659db76b998bcd4242784984b~UmfYJ9t9_2647226472eusmtip2J;
        Thu, 17 Feb 2022 14:44:05 +0000 (GMT)
Message-ID: <7bdb9cd2-aed4-f6e5-44a9-7c022201476a@samsung.com>
Date:   Thu, 17 Feb 2022 15:44:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: Correct wrong BH disable in
 hard-interrupt.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rg?= =?UTF-8?Q?ensen?= 
        <toke@toke.dk>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <Yg5Z/bpn/CBJXAqf@linutronix.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7djPc7rm8XxJBl+2iVl8+Xmb3WLaxUnM
        Fp+PHGezWLzwG7PFnPMtLBZPjz1it9jTvp3ZomnHCiaLC9v6WC2OLRCz2LxpKrPFpcOPWCy2
        vl/B7sDrsWXlTSaPnbPusnss2FTq0XXjErPHplWdbB7vzp1j93i/7yqbx5ZDF9k8Pm+SC+CM
        4rJJSc3JLEst0rdL4MpYcfcva8Fb5ooZ0zIbGLuYuxg5OSQETCQWPG8Esrk4hARWMEqc/bCN
        DcL5wigx8/sLFgjnM6PE611HGbsYOcBaut5zQcSXM0ocmTQHqv0jo8Scn7/B5vIK2Ems3beb
        DcRmEVCVeHNtJwtEXFDi5MwnLCCDRAWSJBZtcwcJCwsESByaOQmsnFlAXOLWk/lMILaIgKlE
        48VDYEcwC3SySFy4d4AVJMEmYCjR9bYLrIFTQFdi85vpTBDN8hLb30IcJCGwnFNi9tVPrBCP
        ukjsnL6XBcIWlnh1fAs7hC0j8X8nyDaQhmZGiYfn1rJDOD2MEpebZjBCVFlL3Dn3iw3kbGYB
        TYn1u/Qhwo4Sf1Y3M0OChU/ixltBiCP4JCZtmw4V5pXoaBOCqFaTmHV8HdzagxcuMU9gVJqF
        FCyzkPw/C8k7sxD2LmBkWcUonlpanJueWmyUl1quV5yYW1yal66XnJ+7iRGY4k7/O/5lB+Py
        Vx/1DjEycTAeYpTgYFYS4f1wkDdJiDclsbIqtSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU
        7NTUgtQimCwTB6dUA5PwF/Y7DQtuBCgYXVf3jy9duvWxcOLPc1/MgqViBDaev+U00SVIucBo
        h7IRm/WWh7ujUhW3nbwudoxby+HRZqZd9y36/zGFynK9+fiknqV3Yd3bO8bJZzOqmiVNXcSZ
        deq4PbUZzB/J/N31SnX29ZuvN9VHf/3PIrtXvlfNh0fbO9rLU239/5kaQaVqf+oqC489+Lgi
        NDb8y/Ewv7cylwpiRVvvPbWXu/fjb8hBgfbK6mZ+5bh6+yMS37I3RQjtW8i2YBfvdf3e3Tcy
        NN1ma8sJR65f2PRU6+sy17vC/NzStYdkts34oPr+XO+ckDat2Jpr7y2V2ix2rZv55P7Hubbx
        kRKJJwubH+mkJBVkKrEUZyQaajEXFScCAK2oDZHgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t/xe7pm8XxJBr2HtSy+/LzNbjHt4iRm
        i89HjrNZLF74jdlizvkWFounxx6xW+xp385s0bRjBZPFhW19rBbHFohZbN40ldni0uFHLBZb
        369gd+D12LLyJpPHzll32T0WbCr16Lpxidlj06pONo93586xe7zfd5XNY8uhi2wenzfJBXBG
        6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GWsuPuX
        teAtc8WMaZkNjF3MXYwcHBICJhJd77m6GLk4hASWMkrsv/2BpYuREyguI3FyWgMrhC0s8eda
        FxuILSTwnlHi/zIjEJtXwE5i7b7dYHEWAVWJN9d2skDEBSVOznwCZosKJEmsmz6fGcQWFvCT
        +Pb8DCOIzSwgLnHryXwmEFtEwFSi8eIhFpAjmAV6WSSab61jgbiol0liddMisElsAoYSXW8h
        ruAU0JXY/GY6E8QkM4murV1QU+Ultr+dwzyBUWgWkkNmIVk4C0nLLCQtCxhZVjGKpJYW56bn
        FhvqFSfmFpfmpesl5+duYgTG9LZjPzfvYJz36qPeIUYmDsZDjBIczEoivB8O8iYJ8aYkVlal
        FuXHF5XmpBYfYjQFhsZEZinR5HxgUskriTc0MzA1NDGzNDC1NDNWEuf1LOhIFBJITyxJzU5N
        LUgtgulj4uCUamDq2HhwY987Fvkzf0O4V3U0yB83rLZ0XuqztrDcz+JcIctmd6GnpnXFW7tr
        96y0mzDtRptaDY/dbM1fnk/2LG0zdPvY8u/RZ16V63JSm74LOHSqmmuuWiemyt98tNDt4rpJ
        X46XzlaQ27J0ckZ3fHuMAE+Cqt7cp8ynfzjl3WXe75GitvaVUdAD0afHrB63OU8MPXXTK3vh
        hAXJsUuUu97Xv7xSXR00f80lrkTRxBsW279/7J7NzX9Q5ZajyZxZq7iWMwTapmb+DXo667zv
        YY49LY+znB2Ovu+uKubNcN0Ssy3C/MyRj06TTh71P3ZKsWjyu4sNP+3eNH3qt7RIuLTeSsj4
        /aF9LfOtZdk/LTirxFKckWioxVxUnAgAn9cCunIDAAA=
X-CMS-MailID: 20220217144406eucas1p2fe25b2fd40f7f7bf8b5c0dc898c16a2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08
References: <CGME20220216175054eucas1p2d8aef6c75806dcdab18b37a4e317dd08@eucas1p2.samsung.com>
        <Yg05duINKBqvnxUc@linutronix.de>
        <ce67e9c9-966e-3a08-e571-b7f1dacb3814@samsung.com>
        <c2a64979-73d1-2c22-e048-c275c9f81558@samsung.com>
        <Yg5Z/bpn/CBJXAqf@linutronix.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2022 15:21, Sebastian Andrzej Siewior wrote:
> On 2022-02-17 15:08:55 [+0100], Marek Szyprowski wrote:
>> I've just noticed that there is one more issue left to fix (the $subject
>> patch is already applied) - this one comes from threaded irq (if I got
>> the stack trace right):
> This is not `threadirqs' on the command line, right?

I don't have 'threadirqs' in the kernel cmdline for that board.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

