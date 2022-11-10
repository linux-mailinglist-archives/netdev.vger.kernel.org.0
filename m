Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C4E624190
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiKJLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiKJLhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:37:42 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6653716F3
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:37:36 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221110113731epoutp0199f2fecb24b624b5b611f2d3b09e3fa1~mNia5ECMU3115231152epoutp01V
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:37:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221110113731epoutp0199f2fecb24b624b5b611f2d3b09e3fa1~mNia5ECMU3115231152epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668080251;
        bh=9zUsfjvOSOmVdmyUOZmjw0Q0VPTlS+N90JXHGCj4Mhc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=HdxFhknJy4RWQngprZVsEcQytT6a+7omCPMSOMFjWxAEDH0DvSTvKu0LiA5+tJbKs
         CCiezoYSuudVOx1FpfbwdETd0vYbTzHlfZPsdgDQ1QYODZoplCBcewvunPePg5oSVT
         Z7FCaZg8pEPTdQWXvpipNa8NtilDAmXnQ2FuX4bM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20221110113731epcas5p171c3b8dd3bf2ee37d27369eced74836c~mNiaDNEKV2798527985epcas5p1X;
        Thu, 10 Nov 2022 11:37:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N7KZJ3jRCz4x9Pt; Thu, 10 Nov
        2022 11:37:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.AD.39477.872EC636; Thu, 10 Nov 2022 20:37:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221110111808epcas5p475327708571c477926f9e5ddf20bcd39~mNRfskxaa1388313883epcas5p4m;
        Thu, 10 Nov 2022 11:18:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221110111808epsmtrp1532b9e6b0f65557c128c39615ac3c698~mNRfretKX0272502725epsmtrp1a;
        Thu, 10 Nov 2022 11:18:08 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-e1-636ce278e53e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.A3.14392.0FDDC636; Thu, 10 Nov 2022 20:18:08 +0900 (KST)
Received: from FDSFTE314 (unknown [107.122.81.85]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221110111804epsmtip249f45df58778954cb2a60ffccd6f857b~mNRb-7phY1167011670epsmtip2h;
        Thu, 10 Nov 2022 11:18:04 +0000 (GMT)
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
In-Reply-To: <709daf8b-a58e-9247-c5d8-f3be3e60fe70@linaro.org>
Subject: RE: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Date:   Thu, 10 Nov 2022 16:48:03 +0530
Message-ID: <000001d8f4f6$1c7e96e0$557bc4a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFejcOECimRbNc2gYBlewkpfd/ZqQHz7ogqAVwjo3kCSHwOh68AC28Q
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0ybVRjm9OsVZPlsuRyILk0jkcGAlpX6gbAtSuYn+qNRoon7AaX9RoHS
        Nv1a2XQTBDaESLlMRikVGUPYqoKWy0q5uBQG022MbY5togsdW9m4yQAhZG7YCyj/nvd9n+c8
        5zknLxNhFzBCmVlKLaFRShQ8ui+1e3DXq1GH7yuk/OWNAGyyoZuO2Tu6GJjpWjEV+2ZolIY9
        HL7PwPSPHAjWP+sajHXraZhlapyGmddqEMwx8yF202aiY4ZrAxSsvekrKjbcGIStXp4DWFPX
        CgNzLPYxMOOYlYYd7x9iYBNzbTTs23s9tP1BeOe5uxS80aLDn9yYALjFXErH/xjvo+Mdzfl4
        xTM+/tfALTqu7zQD/Hnh1wx82bJT7PdRTqKckMgIDZdQSlWyLGVmEu+d99PeTIsT8QVRgnjs
        NR5XKcklknjJ74qjDmQpXFF53I8lCp2rJZaQJC9mb6JGpdMSXLmK1CbxCLVMoRaqo0lJLqlT
        ZkYrCW2CgM+PjXMR03PkG9dtQN0bfbiovJZRAGxhZYDFhKgQOs+OgjLgy2SjvQAWl7VQ3AM2
        ugTgfLvWO1gFUP99D2NLcbq1mOYd9APYf+oB1VtMA7hhGvHI6ehuWHTymefcAPRzBNYuDXsK
        BC2kwIFZO93NYqF7YYnT5FFwUBns+nkKcWMqGgZr6897OP5oPDzVuQK8+EX4S53bjuU6KBK2
        nJ5FvHfiwvWHLTQ3DkAPQINpZZMTDC+uf4m4jSHayoKrP7ZvCpKh3q6neTEHzox0boYLhY8r
        TmxiKbQ+L93kyGFjVR/w4n3wwm8mlwHTZbALtttivO2XYc2vbRSv7w5Y/vQBxdv3h9aGLfwK
        fLRcSXNL3Vblo5xKwDNuS2bclsy4LYHxf7NGQDWDEEJN5mYSZJw6Vknk/ffjUlWuBXhWISLF
        ChyTi9F2QGECO4BMhBfg7xeeI2X7yyRHPiE0qjSNTkGQdhDneu4qJDRQqnLtklKbJhDG84Ui
        kUgYv0ck4AX7nzFESNlopkRL5BCEmtBs6ShMVmgBZXdfT4AxY+bySycnj9Xr6gMDJxP8548+
        3mm+Y/qCEdn7RFx5ayEPB6UUn6qIq6ns9JLb4ogf9oclcK+XplR8l654vfWqPtwRc9RJjsqn
        sWaHKfXMTVxeveAzdpDMeOPQn3OJkvzBuQ/2Zedl9z43OI+PR7/1dlB1SXDsTyGsoeI435rI
        2WOF5w23ZQwqaWs3rpk/O9FpE4cm/56xJ9ZpENW+cKXuIEuiadmxPNGTf+RKol9GCOfO2ZGU
        1KcX0+VTF6YRIZJmSa1eGuLcyHQ2tQ3+/c+hBXb4qrWosH+eg62tf9qRXaW/1KwZf+9uFm7F
        740u1uULuvSXCrId52p9GsJ4VFIuEUQgGlLyL21KpPWTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfVCLcQDH/fa8bC25R6N+5So3cYWio7uft7yc0+Oi83qcl8vkEVpb9zzF
        1GFmjuIy8pK1NEm7doRJ0dqQdNeFxQ510YkWKsQW8hLWcP33ufu+3PePrwDzfYsHCrbK0hhW
        JpGKSSFecUccEtHzXJo4+f6bMPTiTAWJaq5e4yOdTY2jwtoHBHLUveSjnDdtGLJ0/REaK3II
        ZHr1hEDGLycw1Na5CtmrdCTKs1l56FLRcRzV6f3Q54ZugIquufioraeaj7SN1wm031LLRy3d
        ZQQ633qDmONHl5c282i9KZ3++KgF0CZjFkk/e1JN0leL99BHfk6mP1gfk3ROuRHQ/aoCPu00
        BS/xXiOcuYmRbt3OsJNiNgi3tJ/fj6VeiVBUH+oileBCaDbwEkBqKjxrUBPZQCjwpcwAFmsO
        Ao8QCI/fe4t7WARL+1/zPSYHgIa+Y4RbIKmJcF/uz4HACOooBi1Fo90mjMrmwftN/bgn8RHA
        0m+dmNvlRcXAAx06nptF1EZY9/AW3804NRaeyq8k3exDTYMny13Aw8Nh/en2gRkYNQE6mh3/
        ueRsF+aZNxr2OUoIz4oFME/n+uvxh3f7DmMaINIOqtIOqtIOqtIOiugBbgQBTCqXkpTCRaVG
        yZgdkZwkhUuXJUUmylNMYOAN48Ovg0pjT2QN4AlADYACTDzCxzssOdHXZ5NkZwbDyhPYdCnD
        1YBRAlzs79OYXZ/gSyVJ0phkhkll2H8qT+AVqORVEN2rCq12lSr5F3r5WmKIXjFNON02139t
        uJYHevHqGHOXsqTVTtvjvDIUu8LOBcH1HYqD+N2vmli5OO/ip/hb5sZoVrVyX7T5e+TT2IAW
        RW/VmIBYNbdWP8Zbk/9jZEPO3pELle31May81LKI7Hmasc6vzllU+G5Wll5dUJVr0P2Yvdp2
        27JwytDdrLlbLG0L1cTG6R7aYa19XHDllaHCkNAGdXLo5alBsovFJ+NsWb1N+fG75Nbm/G1B
        N1qXZnYsLktTufZEPMhUNImWc/NdmSJNwKNlvVaJczMxb8F7Mtzw4iZjnr4+fbVJObcsYYZ1
        yMzLncOCFSEbvjudYpzbIokaj7Gc5Dcj2Y1/fAMAAA==
X-CMS-MailID: 20221110111808epcas5p475327708571c477926f9e5ddf20bcd39
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
> Sent: 09 November 2022 16:39
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
> On 09/11/2022 11:09, Vivek Yadav wrote:
> > From: Sriranjani P <sriranjani.p=40samsung.com>
> >
>=20
> Use subject prefixes matching the subsystem (git log --oneline -- ...).
>=20
Okay, I will add the correct prefixes.
> > Describe the compatible properties for SYSREG controllers found on FSD
> > SoC.
>=20
> This is ARM SoC patch, split it from the patchset.
>
I understand this patch is not to be subset of CAN patches, I will send the=
se patches separately.
These patches will be used by EQos patches. As per reference, I am adding t=
he Address link.
https://lore.kernel.org/all/20221104120517.77980-1-sriranjani.p=40samsung.c=
om/
=20
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey=40samsung.com>
> > Signed-off-by: Ravi Patel <ravi.patel=40samsung.com>
> > Signed-off-by: Vivek Yadav <vivek.2311=40samsung.com>
> > Cc: devicetree=40vger.kernel.org
> > Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt=40linaro.org>
> > Cc: Rob Herring <robh+dt=40kernel.org>
>=20
> Drop the Cc list from commit log. It's not helpful.
>=20
Okay, I will remove.
> > Signed-off-by: Sriranjani P <sriranjani.p=40samsung.com>
> > ---
> >  .../devicetree/bindings/arm/tesla-sysreg.yaml =7C 50
> +++++++++++++++++++
> >  MAINTAINERS                                   =7C  1 +
> >  2 files changed, 51 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> > new file mode 100644
> > index 000000000000..bbcc6dd75918
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
>=20
> arm is only for top level stuff. This goes to soc under tesla or samsung
> directory.
>=20
Okay, this is specific to Samsung fsd SoC, I will be moving this file to ar=
m/samsung in next patch series. Hope that is fine.
> > =40=40 -0,0 +1,50 =40=40
> > +=23 SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause %YAML 1.2
> > +---
> > +=24id:
> > +https://protect2.fireeye.com/v1/url?k=3D1ad2834a-7b59967c-1ad30805-
> 000b
> > +abff9b5d-1f65584e412e916c&q=3D1&e=3Da870a282-632a-4896-ae53-
> 3ecb50f02be5&
> > +u=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2Farm%2Ftesla-
> sysreg.yaml%23
> > +=24schema:
> > +https://protect2.fireeye.com/v1/url?k=3D13876e33-720c7b05-1386e57c-
> 000b
> > +abff9b5d-edae3ff711999305&q=3D1&e=3Da870a282-632a-4896-ae53-
> 3ecb50f02be5&
> > +u=3Dhttp%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
> > +
> > +title: Tesla Full Self-Driving platform's system registers
> > +
> > +maintainers:
> > +  - Alim Akhtar <alim.akhtar=40samsung.com>
> > +
> > +description: =7C
> > +  This is a system control registers block, providing multiple low
> > +level
> > +  platform functions like board detection and identification,
> > +software
> > +  interrupt generation.
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
>=20
> No need for oneOf.
>=20
Removing this results into dt_binding_check error, so this is required.
> > +      - items:
> > +          - enum:
> > +              - tesla,sysreg_fsys0
> > +              - tesla,sysreg_peric
>=20
> From where did you get underscores in compatibles?
>=20
I have seen in MCAN Driver <drivers/net/can/m_can/m_can_platform.c> and als=
o too many other yaml files.
Do you have any ref standard guideline of compatible which says underscore =
is not allowed.
> > +          - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - =7C
> > +    soc =7B
> > +      =23address-cells =3D <2>;
> > +      =23size-cells =3D <2>;
> > +
> > +      sysreg_fsys0: system-controller=4015030000 =7B
> > +            compatible =3D =22tesla,sysreg_fsys0=22, =22syscon=22;
>=20
> Use 4 spaces for example indentation.
>=20
Okay I will make it 4 spaces indentation.
> > +            reg =3D <0x0 0x15030000 0x0 0x1000>;
> > +      =7D;
> > +
> > +      sysreg_peric: system-controller=4014030000 =7B
> > +            compatible =3D =22tesla,sysreg_peric=22, =22syscon=22;
> > +            reg =3D <0x0 0x14030000 0x0 0x1000>;
> > +      =7D;
>=20
> One example is enough, they are the same.
kay  I will remove 1 example.
> > +    =7D;
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > a198da986146..56995e7d63ad 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > =40=40 -2943,6 +2943,7 =40=40 M:	linux-fsd=40tesla.com
> >  L:	linux-arm-kernel=40lists.infradead.org (moderated for non-
> subscribers)
> >  L:	linux-samsung-soc=40vger.kernel.org
> >  S:	Maintained
> > +F:	Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> >  F:	arch/arm64/boot/dts/tesla*
> >
> >  ARM/TETON BGA MACHINE SUPPORT
>=20
> Best regards,
> Krzysztof

Thanks for reviewing the patches.


