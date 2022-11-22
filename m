Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7C6348CC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiKVU6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiKVU6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:58:01 -0500
X-Greylist: delayed 352 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 12:58:00 PST
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC8223BC6
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:57:59 -0800 (PST)
Received: from pps.filterd (m0286620.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMI4OuR024045
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:57:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=A48ysXrBx0Egj8YibRSr15pEd/e7roUjXOs+vftsnLE=;
 b=q21ySUcZgJxEidXUZI9gSdkevII/GleE9U9KXzdh26M6pvLiXK6RHLlVUnBEg5fdb4Cs
 WBFPQPDZnV5YuqYgWAjMUWagxSEoob6J9KyoksqXMNDm43G3tTkRz5AdazJ5VWsr7Uzd
 GU+EENdOVFBlkZGuq4Vyvo7hRhLQyGAisqBm950bIx7M6JhDi3S0SSZ49OB5YuGVFdOM
 aCCbDtUsBbf/h7zNWAjHiKz9TP1jQJ9iKmAe16TFRDQj9+a3aNFV4su1q0Ci7a5lw/MN
 Vp94ymPHkEeUNo2E5aP73cPwk9Nve1Z2PdHlirNGGUUdMwqhk7Uqe/VJEdZtPNL0OTNK 8Q== 
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3m13cr079w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:57:58 -0800
Received: by mail-ed1-f71.google.com with SMTP id v18-20020a056402349200b004622e273bbbso9418145edc.14
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A48ysXrBx0Egj8YibRSr15pEd/e7roUjXOs+vftsnLE=;
        b=rOlgBahzfp8b+gOxt6X5J0kO/Z9o16Mm6cyXN1K0UKwOXN1Mf11IFdXhaDiepS6R4Y
         5bp43BfHqUnn5nKyBlL0pf8Akcx7bmKF3ZWt7I44oSxsaZOq53MyyL+ZXbqSwjlirc3J
         N33n8PIYii4BsJJC9C4utOs4rCyXrMb0MVxmRq0oH6SxiJDxZ1CgoNNPIzzDRuN4DUoA
         7DWxTVpMuVxyLeB/igv97pArM4U0pZ9h2rc7YxNPvTH9ITftwx55f9cPgSJT4nbLPzg4
         Qh05hSlxMAOmW/luAUl9PiAZpz2ubRXbIEroDmIxo8woPW88ZHTWcI6NsZAoypc0efaa
         ObJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A48ysXrBx0Egj8YibRSr15pEd/e7roUjXOs+vftsnLE=;
        b=UgutT/48IUQI0RKBka6RrzjkDGS0se7qh6wJLINKKIx+ZbPBEergG4re/KqlNK/DwP
         WYIkDkm3WIJiheAACZdz45VVF8kWIwSoqqCtfFsTug/JViV6M3d5JwAlitbN4ssYDwJS
         1ze3HoueMm6KavCJlfctxWBO0WCGuxo7peuQ5Xxw7fMBg9hZAZ4+b9JewV8kMRhxnfm6
         6aEIMppk6wxMn9ODlgUAYOdaQbGP+cTC+7kd+3csuoHBpRAR5tTYDp9JEJik+NDxRcqN
         MHK49I0KVJblh8hk81ux6J/nS2uzzz9CM41kp46WlOG7W9EZKs0lYSlOvhqP9iFgLlCU
         bHlQ==
X-Gm-Message-State: ANoB5pnloXKo7KZyAOoXhZ2R0bSXqa8IVaR1aI6Ks+eZCC+EVwJ7AYkK
        AqUNZ3f892h8iazZNF1NC6fqNhUlFzkuyXNeZ1YNMfDwmt2iogMIrKKime7yUcXiGfHn8QRVOyd
        GjV+/d40stoZFtaSRxaRQTVTzoKZLX8iJ
X-Received: by 2002:a17:906:a2d1:b0:781:bc28:f455 with SMTP id by17-20020a170906a2d100b00781bc28f455mr20924388ejb.170.1669150677312;
        Tue, 22 Nov 2022 12:57:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf49BrYqLm5rW9quFCD1MG9+UqzrdFH0CNqdnkV8UeUlyIVFDOhp0hwi42Alxg0zRmGehS2DYFL3pGdVBUsqQRE=
X-Received: by 2002:a17:906:a2d1:b0:781:bc28:f455 with SMTP id
 by17-20020a170906a2d100b00781bc28f455mr20924378ejb.170.1669150677028; Tue, 22
 Nov 2022 12:57:57 -0800 (PST)
MIME-Version: 1.0
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <Y3zFYh55h7y/TQXB@nanopsycho> <20221122135529.u2sq7qsrgrhddz6u@skbuf>
In-Reply-To: <20221122135529.u2sq7qsrgrhddz6u@skbuf>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Tue, 22 Nov 2022 12:57:46 -0800
Message-ID: <CALHoRjdOPdipZ8kgBCxZ_45DXiurE57YFocvgnrugGt6ugG-Dw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: krwXMle_W6Lm5_oujzzunytEEvU47r7V
X-Proofpoint-ORIG-GUID: krwXMle_W6Lm5_oujzzunytEEvU47r7V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=787
 priorityscore=1501 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220161
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 5:55 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> Neither bond nor team have forwarding between ports built in, right?
> Forwarding is pretty fundamental to 802.1CB (at least to the use cases
> I know of).

This driver also does not forward between ports. My intent wasn't to
implement a bridge,
but an endpoint. If forwarding between ports is desired, then perhaps
you want a bridge?
I think some other 802.1cb offerings on this list took that approach,
but didn't seem to
handle the endpoint case well.

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
