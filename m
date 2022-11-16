Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752A662B334
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiKPGYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiKPGYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:24:40 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02441D0D3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 22:24:37 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221116062433epoutp042129bf3ea80bdf815d096e01dc3a8dd1~n-I3gmJL61687316873epoutp04m
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 06:24:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221116062433epoutp042129bf3ea80bdf815d096e01dc3a8dd1~n-I3gmJL61687316873epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668579873;
        bh=w6POZxD7EOHGAT3g0ChwszoPZ7hzzMiN6LV+nbebvYg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Jl3qihc6Y1zZB87RGo+ktwS/wkUqdpECO0Ga0phhlgq4EFsUnsBQ8CW3Wy7ktZZdi
         Sf5zPJ2P7GnAndmo5o2M9n4MPFL5u1mtATamIaYxZKo5T1Rnm/ZgquK5CzJC2xzdDP
         8fQ7LR1APzG6kEVCUFUE0yfANpAW5vk4jestHfOM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221116062432epcas5p47a5684acb22b004cfe8c651c539316da~n-I25gk972475324753epcas5p4p;
        Wed, 16 Nov 2022 06:24:32 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NBtLQ3WMTz4x9Pw; Wed, 16 Nov
        2022 06:24:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.08.56352.E1284736; Wed, 16 Nov 2022 15:24:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221116062142epcas5p43703e73c1a0d9b530dc0e66faa2966ed~n-GYRRnIp2687526875epcas5p4_;
        Wed, 16 Nov 2022 06:21:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221116062142epsmtrp1848da5b0f7c3fc89ae45733f89518a7e~n-GYLsRdk0157001570epsmtrp1W;
        Wed, 16 Nov 2022 06:21:42 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-72-6374821e7562
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.C1.14392.57184736; Wed, 16 Nov 2022 15:21:41 +0900 (KST)
Received: from FDSFTE302 (unknown [107.122.81.78]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221116062139epsmtip2d927bef92c6680d9a06d78e6d419fbc5~n-GVfmh1e2284422844epsmtip2S;
        Wed, 16 Nov 2022 06:21:39 +0000 (GMT)
From:   "Sriranjani P" <sriranjani.p@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>
Cc:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Jayati Sahu'" <jayati.sahu@samsung.com>, <ravi.patel@samsung.com>
In-Reply-To: <a764159c-e67e-1ee7-4b0f-1a08a06b3b3a@linaro.org>
Subject: RE: [PATCH 1/4] dt-bindings: net: Add EQoS compatible for FSD SoC
Date:   Wed, 16 Nov 2022 11:51:35 +0530
Message-ID: <04ae01d8f983$b1563ac0$1402b040$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHa0oM14/tprCIIIJ9eaP02I486nwKDxKR1AajXdTkBYjlBH64Q6vPA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02TeVATZxjG+2Wzm8QaXUPUz4zSdDswhRaSYMClBVotMAv0oGM706GdgUxY
        wxE2aQ4Qp45ItBxVaB1FiCmXRwWxtuHQqqEUwQMddFqOoRaGUwSsWFAEKaVJFlv++33Pe83z
        fvPyEdEiJuEnMybawKi0BLaC23DFx8fPM9uklo/mQXJurAiQttv7uGRZSztKjlwd5JEtbSc4
        ZF/lQ5QsuD+AkI6Jeh55p6EAJe1DXSj520UbRuZ3DaNk6cJZlLxavo6cufkAkJX1j3nk4kQ9
        IAceXXY2uXUfIfc7Wnhvi6m6qh4ONVJYz6N+svbyqHK7mbJX52HUH12XMar2xB5qsrETowrq
        qgH1S6OCGpl1IFTdz9OAmrZ7xgrjUkOSaFUibZDSjFqXmMxoQomY7fHvxAcGyRV+imByCyFl
        VGl0KBH+bqxfZLLW6ZWQpqu0ZqcUqzIaCVlYiEFnNtHSJJ3RFErQ+kStXqn3N6rSjGZG48/Q
        pjcUcnlAoDMxITXpadE0T9+/aqfFYeFmgTsr84GAD3ElvLu3BuSDFXwRfgnAivL9iCsgwqcA
        nOl/kQ3MAJjT+QM3H/DdFU3XM1jdAWBu8bml6lEALa2t7moMl8GJ02WYKyDGT3LgmYIK9wPB
        DyKw+7tDwJUlwMPg+amv3OyBR0Nr6TM3c3EvWNF3FHWNE+LB8NK9dS5ZiK+BN0qGuS5G8Jfg
        +T9tCOtBCudGTqEuFuORsOCfJozNWQ9b5w4s5dQK4GyJN8vhsL+wF2PZA45fq+OxLIFjhV8u
        sQbWttSiLGthbrZlqc9bsKnD5t4EgvvAcxdlrLwJHmn7nsOOXQUPzg9zWF0IL5Q+Z294fDBv
        iTfCs4NT6NeAsC5zZl3mzLrMgfX/aeWAWw020HpjmoY2Buo3M3TGf/+t1qXZgfsSfGMugMH+
        R/7NgMMHzQDyEUIsPJllUouEiarMXbRBF28wa2ljMwh0bvsbRLJWrXOeEmOKVyiD5cqgoCBl
        8OYgBbFeeLzYVy3CNSoTnUrTetrwvI7DF0iyOOFDX3yOnpq5USb+YOj29Vf4h8pO34vuzEU9
        cFHKkYBnxxrFCfKa175t7ygxRW348eOxhH3t7482ZXhFVL2+Z2K0xHP1ZMrap4t2VMV435Jx
        H5N3RR8KQ+TX2tLGoybLBVv/bmtIZ+S/ZvYP+B2zvmABUwsbGxyKeUtEeo4ySmKqfJKdKuOa
        /RPUkjh0/vfON+MDitfcjAzGZBpLT59j/OjqwG29U4mxK9vNW7Rbo4uqtr/aHtEhH1JjV3bj
        nO6d2k3aAUHP7MvyA4fjWkOarEXZTz6l9m4rrghZPAze+yi8MGlV5q4am5c0ZTEn5q/duQ93
        FMd0P9jBLHwSduazHAvHVkNwjUkqhS9iMKr+BXE+eJiSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWy7bCSvG5ZY0mywcRGRoufL6cxWsw538Ji
        Mf/IOVaLp8cesVscObWEyeLeonesFn0vHjJb7H29ld3iwrY+VotNj6+xWlzeNYfNouvaE1aL
        eX/XslocWyBm8e30G0aLRVu/sFv8f72V0eLhhz1AQ868YLZo3XuE3UHEY8vKm0weT/u3snvs
        nHWX3WPBplKPTas62TzuXNvD5rF5Sb3H+31X2Tz6tqxi9Di4z9Dj6Y+9zB5b9n9m9Pi8SS6A
        N4rLJiU1J7MstUjfLoEr4/u0z+wFD/gqmvc2szQwXuDpYuTgkBAwkThworyLkYtDSGA3o8Tb
        abtYuhg5geIyEicfLGGGsIUlVv57zg5R9JRRYs2OTiaQBJuAvsTrFfPZQBIiAuuZJJ71TGEF
        cZgFpjJLnDnbBdXymVHiee82dpAWTgE7ie2fuhlBbGEBL4lZ836B2SwCqhIL701nBbmJV8BS
        YvczMZAwr4CgxMmZT8BOYhbQlnh68ymULS+x/e0cqPMUJH4+XcYKYosIuEn0/TvABlEjLnH0
        Zw/zBEbhWUhGzUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iRGc
        GrQ0dzBuX/VB7xAjEwfjIUYJDmYlEd6lDSXJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2M
        FxJITyxJzU5NLUgtgskycXBKNTCxv5F90az3+fbqxKXtogwMrPF17Tff6omzXX4Vx5txVENu
        otJM0ZM/zfUuSStyPnzGeT2l6eNMu7Rg8ZXXbs0/0vWxuvaKrl/Tz860hew7lqpumvpDVTq/
        davInn7dCWvuOa4sTL3U9a/7Te65rKs+yQU3k68JrnKrZpr5+eR2jWNxfzhm3U/M3rpU5tj8
        FUfDvm2e4cWxy9nKbduENTtX9Fl1+KZ3lTvctg84cTbV8f2pwIPz9p4uLNt1fe6+kmCj6b3s
        /kK5BrL3y17Na16ym0O2wzhI6t1UXedfx2uiuxdMDjvJ2ntU61Kk4Cojzdxv7T/Muet4e9Q4
        3npeP8RvXtem9zowgZldbb2n7XwlluKMREMt5qLiRAA2QyFafAMAAA==
X-CMS-MailID: 20221116062142epcas5p43703e73c1a0d9b530dc0e66faa2966ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104115841epcas5p490b99811e257b8f3f965748df0a57be5
References: <20221104120517.77980-1-sriranjani.p@samsung.com>
        <CGME20221104115841epcas5p490b99811e257b8f3f965748df0a57be5@epcas5p4.samsung.com>
        <20221104120517.77980-2-sriranjani.p@samsung.com>
        <a764159c-e67e-1ee7-4b0f-1a08a06b3b3a@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski [mailto:krzysztof.kozlowski@linaro.org]
> Sent: 04 November 2022 18:18
> To: Sriranjani P <sriranjani.p@samsung.com>; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; joabreu@synopsys.com;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; mcoquelin.stm32@gmail.com;
> richardcochran@gmail.com
> Cc: netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Rob
> Herring <robh+dt@kernel.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski+dt@linaro.org>; devicetree@vger.kernel.org; Pankaj
> Dubey <pankaj.dubey@samsung.com>; Jayati Sahu
> <jayati.sahu@samsung.com>
> Subject: Re: [PATCH 1/4] dt-bindings: net: Add EQoS compatible for FSD SoC
> 
> On 04/11/2022 08:05, Sriranjani P wrote:
> > Add FSD Ethernet compatible in dt-bindings document
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> > Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> > Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > Cc: Jose Abreu <joabreu@synopsys.com>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > Signed-off-by: Jayati Sahu <jayati.sahu@samsung.com>
> > Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> 
> I did not get cover letter and patch 2. Your CC list is incomplete.
> 
> For the record - DTS will not go via net-net but Samsung SoC tree.
[Sriranjani P] Got it. Will update the CC list in the next version.
> 
> Best regards,
> Krzysztof
[Sriranjani P] Thank you for the comment.


