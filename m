Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD13363CB1C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 23:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiK2Wio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 17:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiK2Wij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 17:38:39 -0500
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5483870461
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:38:38 -0800 (PST)
Received: from pps.filterd (m0286620.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATDvYbE014957
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:38:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=pJiNJ8unIx+MxneWN2hYk+LbzF1KIZOf++G9ThdiI9g=;
 b=ZRC2lerhTSLWjObKh4Aw/C8ge7zSdpVGy0AS3VGntX2URQ5MOVT/aKkwLSA2Ebz49Vxn
 ISRaLTP/v2oDirQIRcinbBmh8QMA95v14Rps9FiJrX/OQ2kynhsKNVE/6iDwjzLvDgTm
 RV9u8Czmuv5dWeV+Trim8dZu0KOo4ypPTsoRKTf3JVr08U3XxoQX9yir0gug+gmcALvD
 XDRSEZI3Nmr3GDaB/ZDre74tiMXP9V9MXsumNbAIc0SEoXYJj2ENesM/R3LT59sUpRjj
 hRdDkeZyXI3niqWhFd6n79dMgZMOOhscxxvpneC51PiU+w5x2gNelsApY08S7K02SONl 3A== 
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3m580vh079-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:38:37 -0800
Received: by mail-ej1-f70.google.com with SMTP id ne29-20020a1709077b9d00b007c0905baae1so1390215ejc.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJiNJ8unIx+MxneWN2hYk+LbzF1KIZOf++G9ThdiI9g=;
        b=BcZzm/XAfVQ5eUp4lr9u32LQjxb2560/nAL50053gIzTwc36EkjMi+jrJfqFJAtzq/
         5JEJgRZtxB11kM8rQIuZSzLSE+la5vsP5zdcB/02wzKS0gNUiqqMVsIXGpR4IAKcNuGU
         qTAcH9uduOUMUTnMysQtDCRJVKCgPWFQg6RHoicoP2Fow8XBUCcQ7yPfDUfKQwqdoOzX
         N75rq/Q6/i3Gw6RXITV+Bp4PADCMXbS0OQEsyuqYjCDIo2Ee4tVdKOKmXfjr9cRX8KXs
         apGVTs6D1oqJxZIZMtNBaHIE9lLEAO1r5aE6CVYmcCDDFJbaan432l0ZpLTtkN8S9/bz
         AqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJiNJ8unIx+MxneWN2hYk+LbzF1KIZOf++G9ThdiI9g=;
        b=RlHdVCwT6ujweeLSDHVbxM64rFEN4rFUbiM+B5d08AXHXmWPQJ/Tl00Aq+txQe8Ycl
         g/9cW+/Os+KO4XHEtBMwsEvCIsF/2NIO3Iy5oMeXXoRNzE5jCmGP464NASI+w4JxAx8G
         q1UdIeBxHtfAc68XKVtKPt6EI0bWI6ZulMEixS3FkCDXJhmifOcTGN1bZZ/EUJ7BaEXf
         TKWu1fVI3uVNDVux8dm4Os+cAlzrvL3hBi9/a+lwccLlhMSSjuGdEzcPrK05LLLSqPDy
         AVYAr6GEaeJvw2Qo3Bo9QrgT6aKzo3+EUtQlVMQ6dNpG0ggpiqn9exi9AcH9ZWT5Dcds
         dInA==
X-Gm-Message-State: ANoB5pm4EoDPKHKsLGl8iKyBXrq/Dv3l4Fvr6VPLGJYWCjqrHczFUjNY
        vce58fQ6LxVzK9qJ168iUq0J78YF2devwWIOttNOnNzoDuA9cpAC3GX2lTYhdVTB80qrsDJK62O
        Tz01B4kZ/JujW+zdR+FgWH2rmzy0fslqT
X-Received: by 2002:a17:906:f857:b0:7c0:85ff:d3ee with SMTP id ks23-20020a170906f85700b007c085ffd3eemr4688874ejb.633.1669761515144;
        Tue, 29 Nov 2022 14:38:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6McRlWkt5cNOuvoePyDj1PbQOlNR9Iixea183FgxcisFDWTj0LaXX7ka4djEnTMFKk0UjNsCCReHgjceSyv04=
X-Received: by 2002:a17:906:f857:b0:7c0:85ff:d3ee with SMTP id
 ks23-20020a170906f85700b007c085ffd3eemr4688866ejb.633.1669761514899; Tue, 29
 Nov 2022 14:38:34 -0800 (PST)
MIME-Version: 1.0
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org> <20221122113412.dg4diiu5ngmulih2@skbuf>
 <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
 <20221123142558.akqff2gtvzrqtite@skbuf> <Y34zoflZsC2pn9RO@nanopsycho>
 <20221123152543.ekc5t7gp2hpmaaze@skbuf> <Y35L9ykSI37snvSw@nanopsycho>
In-Reply-To: <Y35L9ykSI37snvSw@nanopsycho>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Tue, 29 Nov 2022 14:38:23 -0800
Message-ID: <CALHoRjeQij510y223baX3QATVaivyozPzJSb71Aq_noz5gFYTg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: lezxBI5X5KxDpQQ6NHbRDOjL7znV8UiZ
X-Proofpoint-ORIG-GUID: lezxBI5X5KxDpQQ6NHbRDOjL7znV8UiZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_13,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=567 bulkscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290136
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 8:36 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> >The fact that hanic needs 802.1Q uppers as termination points for
> >{MAC, VLAN} addresses seemst to simply not scale for IP-based streams,
> >or generic byte@offset pattern matching based streams.
>
> Vlan implementation could be easily done internally in hanic driver if
> needed, similar to bridge and openvswitch vlan implementations.

Hanic matches streams based on mac and vlan (with absence of vlan a
valid case) with the stream mapping somewhat localized. I see no
reason to not allow for in the future other stream matching methods, I
just didn't see the need for it at this point. If adding a specific
stream matching method is required to get this through design review,
then that is something I can look into. But this method is one of the
few (only?) stream matching methods that doesn't rely on sideband
data. But again, the stream matching code is localized, and it should
suffer expansion well, if that is the desire.

As for Vlan implementation, the hanic driver is aware of vlan tags (or
their absence) in order to do stream matching, but the actual
tagging/untagging is handled by the existing linux vlan support. I'm
not understanding why one might want hanic to do the actual vlan
tagging. Well, actually, if one wants hanic to bridge traffic between
enlisted ports then maybe that's a case where it might need to edit
vlan tags, but this is not something that hanic does at this point. I
don't see why it couldn't gain that functionality if it were
considered desirable.



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
