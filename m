Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F76252AD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbiKKEf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiKKEfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:35:32 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28976F361
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:35:09 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221111043508epoutp03195161f6702136d7e5cd90e9526a3787~mba6FSU3a1361613616epoutp03W
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 04:35:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221111043508epoutp03195161f6702136d7e5cd90e9526a3787~mba6FSU3a1361613616epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668141308;
        bh=6h15vmBu1KlWANEt8q88z1t98BduIhW5b68r16XTLlI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=On8UyeehhKTm5fH5JVYlilXF3E2zV+l1LfSi8JknthHcRERyH8/UsLvOqhOz0eHJ3
         Xet8m/VPgAoMqP2UgzjUAhSaHDfd49kaZty5H4aypdpPzPNVwZUS49YtZlfI78bQHV
         6K2PUf81tFxpTZ26RdQNSLN5NnZp+Vfq0/Jv3HPc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221111043507epcas5p453119b36e9f1aec4f81573152195b725~mba5YPp_p0129601296epcas5p4h;
        Fri, 11 Nov 2022 04:35:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N7m8S6qwTz4x9Q6; Fri, 11 Nov
        2022 04:35:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.88.01710.8F0DD636; Fri, 11 Nov 2022 13:35:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221111040651epcas5p25baa64cda35ccabdc28081ed50b40a9f~mbCNxl-oa1633416334epcas5p2D;
        Fri, 11 Nov 2022 04:06:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221111040651epsmtrp279291d471f5194e1af3257e224072880~mbCNwjDcu1387513875epsmtrp2Y;
        Fri, 11 Nov 2022 04:06:51 +0000 (GMT)
X-AuditID: b6c32a49-a41ff700000006ae-7b-636dd0f86efa
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.A0.18644.B5ACD636; Fri, 11 Nov 2022 13:06:51 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221111040648epsmtip14a368cde17f779d482923804ba92d3bf~mbCKylUd32425424254epsmtip1v;
        Fri, 11 Nov 2022 04:06:48 +0000 (GMT)
From:   "Vivek Yadav" <vivek.2311@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        <rcsekar@samsung.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pankaj.dubey@samsung.com>, <ravi.patel@samsung.com>,
        <alim.akhtar@samsung.com>, <linux-fsd@tesla.com>,
        <robh+dt@kernel.org>
Cc:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <aswani.reddy@samsung.com>, <sriranjani.p@samsung.com>
In-Reply-To: <277004ed-3b6b-4ee5-39e4-beb75a272e60@linaro.org>
Subject: RE: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Date:   Fri, 11 Nov 2022 09:36:46 +0530
Message-ID: <001601d8f583$06d01250$147036f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFejcOECimRbNc2gYBlewkpfd/ZqQHz7ogqAVwjo3kCSHwOhwGfuKaeAOJGcdCu7RURAA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTZxjGc3p6Tlugy+Ey+SDRdEWjIpd2lu6rATXBLGdRlM0MdZKw5nBC
        ETitbdkYJo6iU2GAMGQ4hojXYZmwtFAql+o6QBgdkLG5EJhyFQM4KiXbnAIrPbLx3+/93ufJ
        e/ny8lE/Ay+Yn8roaS2jTBfjXlzLD1s3h//dn0FJLF0yOFJlwaHd3MiDlX2nufByey8GJzvH
        eLDoySgK22bciX5LEQZN4w8waPyrDIWj04fgQHMlDi/22Tiw/uoFLuysXgf/7JlF4NXGBR4c
        dbbyYEW/FYOftbXz4NBsHQZvPLyD7V5HNtwa5JDVpkzy2c9DCGky5uHk8INWnDRf/5Q8vygh
        52y/4mRRgxEhl3Iv8UiXaUO89wdp0SpamUxrRTRDqZNTmZQY8d6DSbFJUXKJNFyqgG+JRYwy
        g44R79kXH/52arp7VLHoI2V6pvspXqnTiSN3RmvVmXpapFLr9DFiWpOcrpFpInTKDF0mkxLB
        0PodUonkzSi38MM0leHpIE9TH5BVdcqA5yAOIh8R8AEhA8tnzVg+4sX3I1oQ4Dj3PZcN5hEw
        bptE2MCFgBvncjmrlvsTDpxNNCNgeOQlygZTCPjt+nmPCifCwKnSRY89gDCgoHy+0xOgRC4H
        2Gbs+IpKQOwEVoPLw/5EMmi8O46uMJfYBO6YnNgKCwkFGK6p5rLsC7q/mvAwSmwDN6/MoGxP
        IvB88qZHH0AkgIVbNozVBIKO5wWe9gDxjQDcttfgrGEPKCxq4LHsD6bvr3IwcP3R9kpDAetS
        HsayClSXtCIs7wL3fql0N8F3F9gK6psj2ef1oOzHOg5b9zVQ+GLi1b6EwFq1yhvBE1cxtmJd
        KVXY61+MiCvWTFaxZrKKNRNU/F+sGuEakSBao8tIoXVRGilDf/zfl1PqDBPiuYXQd6zI7yPO
        CDvC4SN2BPBRcYDQe0sa5SdMVn6STWvVSdrMdFpnR6Lc6y5Bg1+n1O5jYvRJUplCIpPL5TLF
        drlUHCi8djGU8iNSlHo6jaY1tHbVx+ELgnM4TWfGaG2O8dpLIQh9eERQddjoelell37eHUK9
        mEwR1fo8CgqaEzjIkLwSX4PZljjQc9bh21vguvfT3ekz24/si7PFHO6w7vf1OdYEc9q/PL4c
        Ep7QHDc157XlDfPj7EZLgb53KC9htmCsPGwoNneqL8vnRITr0tMdFNPe+O2xWl+ftubx7xbL
        9nt/0ZnYYexynaCoAVVLmbOt9Gip+Sj/wKOw+vnjTQHFrvK8C4m76ycsPdPETPbGg93TuyKX
        5e8bahVBXiIndG7qPhl35fQzRaxkQ83mvdFkYFbXIXowiz45B1vq4qoWohvWlziZ0ELH0j9f
        b+Pll77XhDV0Rjy+LebqVEppKKrVKf8FSw7RWZQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0zMcRzH973fvyvKr6vVVyZ2EkqnzJ9vW2vmAT8siU0WVqf7LdRd566Q
        B0RanFSU6KTumlp3U3Iq4bpxJU50pbljNaRupz+U9cdohevGevbaXu/3e58HHy7GG8B9uUck
        qaxMIkzmk654QzPfL3j/S3FCSKXVA30qbSCR8X49hUrM53FU1tJOIFvrZwrlfunFUNPQX9HR
        kEsgXZ+FQNof1zDUOxiDuh6VkOiG2cBBd8sLcdSq8kaTbcMAldePU6h3VE8hZUcjgbKaWijU
        PVxDoIoPD4lN3kyd5j2HUenSmO9vugGj014kmR6LnmTu3z7D5E2HMCOGtySTW6cFzMy5WxQz
        pvPbNS/WNVzEJh85zsrWRMS7Hv71sY+QDnueHDcUUxkgm1YAFy6k18Hn/a9IBXDl8uhGACeG
        moFT+MLCVwO4kz2hZsZOOUM2ACerOjGHIOnVMLNgerbgRV/BYFP5UkcIoxUc+PrdDO5sdHJg
        bcXgbMqFjoCNZ8dIB3vSh2Br5xPKwTi9HD7UjRIOdqPDYE+VCneyBzQV988yRgdB23vbf65U
        D2HO85bCn7ZKwnnFXjiuMRDOjA989jMHyweeyjlTyjlTyjlTyjkVFcC1YCErlYsTxfJQ6VoJ
        e0IgF4rlaZJEQUKKWAdmvyEwsBHotaMCI+BwgRFALsb3cpu3MimB5yYSpp9iZSlxsrRkVm4E
        i7g438etQ2GK49GJwlQ2iWWlrOyf5XBdfDM4Qmv3SMG2M83d4vSr509MtNU2qHyEBwt/LT52
        KSr89LrJ6tMBY5rV7QX9puO7LwZN01G71E2hl3SRWz+IHijUC3rdf5tqLNuDlr0wzPQnmRX6
        JTEZVw2CgRHRzj0T+qgydzIl9Y51Ijh6c25OQHzX07r8b8u6jkrI7VnW6Bq/FE2QVnCz2KPI
        N3hPtnxK/fjL67zSIllP2qB/n/llhS0yyb4vtseUZd8RYr95IdPCSM1GbXrWqo8B1rAVnC3X
        Wza2l+TFWoxhiaVX5t+LyikcLNZdXu+tjmOnEjYFU/5ft3Vkb3A/kP/cpbXarzl2zeO3pXZe
        ZM3tA9XRp6putHiJBG18XH5YGBqIyeTCPwwyymt8AwAA
X-CMS-MailID: 20221111040651epcas5p25baa64cda35ccabdc28081ed50b40a9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84
References: <20221109100928.109478-1-vivek.2311@samsung.com>
        <CGME20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84@epcas5p3.samsung.com>
        <20221109100928.109478-2-vivek.2311@samsung.com>
        <709daf8b-a58e-9247-c5d8-f3be3e60fe70@linaro.org>
        <000001d8f4f6$1c7e96e0$557bc4a0$@samsung.com>
        <277004ed-3b6b-4ee5-39e4-beb75a272e60@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzysztof.kozlowski=40linaro.org>
> Sent: 10 November 2022 17:42
> To: Vivek Yadav <vivek.2311=40samsung.com>; rcsekar=40samsung.com;
> krzysztof.kozlowski+dt=40linaro.org; wg=40grandegger.com;
> mkl=40pengutronix.de; davem=40davemloft.net; edumazet=40google.com;
> kuba=40kernel.org; pabeni=40redhat.com; pankaj.dubey=40samsung.com;
> ravi.patel=40samsung.com; alim.akhtar=40samsung.com; linux-fsd=40tesla.co=
m;
> robh+dt=40kernel.org
> Cc: linux-can=40vger.kernel.org; netdev=40vger.kernel.org; linux-
> kernel=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> samsung-soc=40vger.kernel.org; devicetree=40vger.kernel.org;
> aswani.reddy=40samsung.com; sriranjani.p=40samsung.com
> Subject: Re: =5BPATCH v2 1/6=5D dt-bindings: Document the SYSREG specific
> compatibles found on FSD SoC
>=20
> On 10/11/2022 12:18, Vivek Yadav wrote:
> >>> +maintainers:
> >>> +  - Alim Akhtar <alim.akhtar=40samsung.com>
> >>> +
> >>> +description: =7C
> >>> +  This is a system control registers block, providing multiple low
> >>> +level
> >>> +  platform functions like board detection and identification,
> >>> +software
> >>> +  interrupt generation.
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    oneOf:
> >>
> >> No need for oneOf.
> >>
> > Removing this results into dt_binding_check error, so this is required.
>=20
> No, this is not required. You do not have more than one condition for one=
Of.
>=20
Oh, ok I got it. I was not removing =22-=22 before items, which is resultin=
g an error. I will update this in next patch series. Sorry for confusion.
> >>> +      - items:
> >>> +          - enum:
> >>> +              - tesla,sysreg_fsys0
> >>> +              - tesla,sysreg_peric
> >>
> >> From where did you get underscores in compatibles?
> >>
> > I have seen in MCAN Driver <drivers/net/can/m_can/m_can_platform.c>
> and also too many other yaml files.
> > Do you have any ref standard guideline of compatible which says
> underscore is not allowed.
>=20
> git grep compatible arch/arm64/boot/dts/exynos/ =7C grep _ git grep
> compatible arch/arm/boot/dts/exynos* =7C grep _
>=20
> Both give 0 results. For few other SoCs there such cases but that's reall=
y,
> really exception. Drop underscores.
>=20
git grep compatible arch/arm64/boot/dts/ =7C grep _ =7C wc -l=20
This gives me 456 location, am I missing anything here ?
Anyway I will replace with =22-=22 in next patch series.
>=20
> Best regards,
> Krzysztof
Thanks for review the patches.


