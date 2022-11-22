Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FA6348E4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiKVVCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVVCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:02:09 -0500
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0DF7AF45
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:02:08 -0800 (PST)
Received: from pps.filterd (m0286619.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMI4I3D030263
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:02:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=1Nr6Weq5S6LppJJOH2ZyQCCwCrs4wzrQyHScK/QvWRk=;
 b=HjrVWujDWNuHi8pFERP9Lw+5qTfHljYM6Bmb/wxltxNnXUtXRdVA7sqcdf/tY66khOLI
 kIHdXGSSpbnmepslG07WQPLAouT0/HwfDLnXn/bDA4+ie4fSnic3fi/UJZdsnIRAVxOU
 Obrd0xZgTuvF/leTBfgNgcTm4OrMxs1t7IQGwyEmE2sVmEu3WJ6VwGOvwNlzRBy7fZog
 +NKmdSNbiJj2Fds30C/RvO5MKTtniZ+EfbjuOOTUo78h8VV2N3opLok5ioyNhM8w3xod
 Blqb1VKzbfvh/uVqxym9q/XbwC/gM5lM+u7CSR1tMtFP6a3SskRynmkNt59h8hx9GJiA 5g== 
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3m13cqr7m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:02:07 -0800
Received: by mail-ed1-f72.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so9565353edz.21
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Nr6Weq5S6LppJJOH2ZyQCCwCrs4wzrQyHScK/QvWRk=;
        b=O75GQ1Jj6qv+bQnEo8Xe3befs0PXMrwaSlS6+eVFyl96hkHNp8tKP7etgDnsvUTcxx
         O7dhtpxJQCZdFN/32ZIfeYfv6m0Mz2LyzIPOZ04AIIu4gUorKT17koHfJKCTL4jUPIsX
         tI+9/NemtIgGvt58gchskMNl7O/Opg/s2gH39lQabctd7D6fv2U8Sm4fr7QRjmhKvBlF
         it5gCYvxe9v5yrf+UemW3WmosGeKe0HGclBA7FpN/U3Z96VxuhD7m3y+GEjohci6P4rG
         Fv96+ijDliHet5TwS/w9o8swIN0dg5usu0pNpo0PmVuQbSjUEMXO5EDJ6KJvtFcgnDOF
         /DLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Nr6Weq5S6LppJJOH2ZyQCCwCrs4wzrQyHScK/QvWRk=;
        b=0yl46BHg/UgjMkkLMJSsrf8oya0VcFAnrrHAyoF2EzCLlZjrTMSWRt8utv6SV7zS/0
         pLfAToDGeFijZtisl175y4KqiGWX/r5S+iaIl8+4GZHyp6cKqjYF3NFw5EU5SUO9XTTY
         z1W+Ge6ChT2vTAwJlF5TfPUzdcsIsTK4D6X2BrRIoDmG92azpKMtKp1nSXHbReONslw6
         /7S2I8tJqLriLqg6bjDdbrE6xkP4YUFdkS/r2Lq6tdnK8WB0KldrrJN8mvJ5VaX4zQuR
         jkSPcg8HK69b20z27KCtm/yLzeGRo27f4kQaV5Q+JrpIBSXAOAnk95ueJA0AmxY3UM4h
         /xsA==
X-Gm-Message-State: ANoB5pneLn43Cy1nikGo4FKBTbYzdXIbn5aOgBzuxvNpwjn1VNmIW0t/
        8dVxhBBBAgMgrzi+CriKgN6u3A6Wnr7vr2D2WSquSZ1dSwUKXMmYZypIGbvTzShfo+iOHJybSDx
        lIO3/HxDMlK+ZpPx0jxyAQia7PO2TDb7Y
X-Received: by 2002:a17:906:1495:b0:7ad:d250:b904 with SMTP id x21-20020a170906149500b007add250b904mr5133044ejc.633.1669150925346;
        Tue, 22 Nov 2022 13:02:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4lwFv3ZRjvTAyj9TUHJAGnvFVdrU/wv9XHdxre/fFeU+J3e7A9x+Vmm3k6hLF8pCT9OK5kz4bJi3oNrusDldY=
X-Received: by 2002:a17:906:1495:b0:7ad:d250:b904 with SMTP id
 x21-20020a170906149500b007add250b904mr5133033ejc.633.1669150925069; Tue, 22
 Nov 2022 13:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org> <20221122113412.dg4diiu5ngmulih2@skbuf> <Y30pD0B6t4MmUht9@lunn.ch>
In-Reply-To: <Y30pD0B6t4MmUht9@lunn.ch>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Tue, 22 Nov 2022 13:01:54 -0800
Message-ID: <CALHoRjeU_28Sm+SoYQ6NP4W0ppK+okUubWt2orwgAZ2B4RVwfw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: u1b6zTB1Xhk71qb4ogsvnIYzdUlogD6y
X-Proofpoint-ORIG-GUID: u1b6zTB1Xhk71qb4ogsvnIYzdUlogD6y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211220161
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 11:55 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > ../drivers/net/hanic/hanic_sysfs.c:83:31: error: =E2=80=98struct hanic_=
netns=E2=80=99 has no member named =E2=80=98class_attr_sandlan_interfaces=
=E2=80=99; did you mean =E2=80=98class_attr_hanic_interfaces=E2=80=99?
> >    83 |         sysfs_attr_init(&xns->class_attr_sandlan_interfaces.att=
r);
>
> There was another submission over the weekend adding a network
> emulation system called sandlan. The cover latter for this patchset
> should of at minimum said there was a dependency between the two. But
> in practice, there should not be any dependency at all. It is unclear
> if sandlan will get merged.
>

Hanic does not rely on sandlan. I used sandlan as a test bed while implemen=
ting
the hanic driver, and apparently some bits leaked into this patch. I'll fix=
 it.
--=20

Stephen Williams

Senior Software Engineer

Cruise

--=20


*Confidentiality=C2=A0Note:*=C2=A0We care about protecting our proprietary=
=20
information,=C2=A0confidential=C2=A0material, and trade secrets.=C2=A0This =
message may=20
contain some or all of those things. Cruise will suffer material harm if=20
anyone other than the intended recipient disseminates or takes any action=
=20
based on this message. If you have received this message (including any=20
attachments) in error, please delete it immediately and notify the sender=
=20
promptly.
