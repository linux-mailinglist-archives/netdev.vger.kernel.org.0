Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03B863339A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiKVC71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiKVC70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:59:26 -0500
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7921D0FD
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:59:25 -0800 (PST)
Received: from pps.filterd (m0286617.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2omr0026287
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:59:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=kWOydStS6VaRGc76Xz9YCWnu55hveCn2ejyypKNwjew=;
 b=ZtGspjw1c5x/LTqhmbdi5iDXq8+8mh39Ao5Y7X5mbJiT6IrXEHC131r1/kJ8WuZIqujx
 V0rAg1tZHeYljgZg9s4YlmjXSJkYA+i859qZjU5I0ATOuOZAK8gI92P3Sq1rK2GhTBLB
 +PX6f66IVHQzAdc6Ywb3JorknyxHv6TMHApkiZR8tUa0WtqdRXfc4WKskbQQgiIwhuYX
 GARiETXPZsJRmXvEe+ieMNz3jOp8i7MQxJpMVHYIDasiEGFzWGRzgqv+Sv2hXY+jSV2Q
 1y1u9IC61MNOXQ0F9XH2OGODT29u6RFLcQVacbXLsIIQA5b9cqbNuYLhuaLAY35pAyqE CA== 
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kxve99q5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:59:25 -0800
Received: by mail-ed1-f69.google.com with SMTP id w4-20020a05640234c400b004631f8923baso7944535edc.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWOydStS6VaRGc76Xz9YCWnu55hveCn2ejyypKNwjew=;
        b=gwuA5+jtQIErsaMDsqzLYc5yNuhO/T93f1p2RHQSNoDuWPJFxVcRA/4467JkeoL4RN
         PJBddj6wPKhsv3UvdaD/2dMWWoA/3yCUWwCCzgZAEBQ6nd6bc/Rwi1awfoepE8TVPHma
         gfoSWvbBAXnkZBWW372I8/WQZH6ulbdv+9y6GlroKTHdvb7vUQkHQzai4Mf1opWWUxQg
         lFE9iBJgEj/qT2wPI+rZVXrbvHYz52DGLuu9IHK9vzekjo8ZYe5JGSw8H2nEnT6pDzR6
         IUeELnxfSHpo9gbdoV0/pTWwgeigY0Ps3XZZhbJL0/65rp5BFN6trtfmPY/tOo1rthyc
         b8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWOydStS6VaRGc76Xz9YCWnu55hveCn2ejyypKNwjew=;
        b=d0mCdlwIFSHnc63o+ph0O+Y1BEDbl5du+CLwGvIO48AKsZnQThK74ObNYH2lZCXZ9t
         RO6SjsTTr0cJlybvvEZTcdWEprljxHEZgrUznPQS2dZUYXIkcXyiMdTvtMQAdUfB0D5t
         PcQLwopnGtmZHekkehFrCDJ0wqxLfD6iwKS3Ko2TOw8a3wy0ZqPVdST5UE8V6DPgVVHL
         DgnAjwdE0DLuF9PvUny85rIzWXw8VByTKAJsBYrVvqMA/ht2X8yuWZFSe6wd3jlx+Prh
         XiP6JhPacspfntG/1SGm7jY6Knx2ZMzyijv0x3Av22/y65tgHrcxedbbAxDxxyORBniY
         JC3A==
X-Gm-Message-State: ANoB5pme035gWZn/KM2rSvE2lx9nqFyPGYqRykK9BqlE6t9/4QloP6s1
        fgpzw6lrNVdVAhAFbT3/AB0Fabm8ddxWJNDxWXi02Z3OFMUzOcDit/giwbGHCnGBbjTLsu+hKH7
        +HTKuVX4E6ty/m5S3hN5GlVFlmywr33HO
X-Received: by 2002:a17:907:9010:b0:7ad:ba48:7e7c with SMTP id ay16-20020a170907901000b007adba487e7cmr17822966ejc.443.1669085963134;
        Mon, 21 Nov 2022 18:59:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6+uvu1jWKEyootyL/69v6CVb5qh7qBoeZ4qq5dtdMESTkD0QTXd5UZj4B+0e9kTZm/BygXwJYHCNTWyTAJZWA=
X-Received: by 2002:a17:907:9010:b0:7ad:ba48:7e7c with SMTP id
 ay16-20020a170907901000b007adba487e7cmr17822958ejc.443.1669085962820; Mon, 21
 Nov 2022 18:59:22 -0800 (PST)
MIME-Version: 1.0
References: <20221116222429.7466-1-steve.williams@getcruise.com> <20221117200046.0533b138@kernel.org>
In-Reply-To: <20221117200046.0533b138@kernel.org>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Mon, 21 Nov 2022 18:59:11 -0800
Message-ID: <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] sandlan: Add the sandlan virtual
 network interface
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: lDWN4d_TVN7uhom15sibsFjGUitZNaMf
X-Proofpoint-GUID: lDWN4d_TVN7uhom15sibsFjGUitZNaMf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=982 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211220019
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have had trouble with the veth driver not transparently passing the
full ethernet packets unaltered, and this is wreaking havoc with the
hanic driver that I have (and that I'm submitting separately). That,
and veth nodes only come in pairs, whereas with sandlan I can make
more complex LANs and that allows me to emulate more complex
situations. But fair point, and I am looking more closely at figuring
out exactly what the veth driver is doing to my packets.

On Thu, Nov 17, 2022 at 8:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 16 Nov 2022 14:24:29 -0800 Steve Williams wrote:
> > This is a virtual driver that is useful for testing network protocols
> > or other complex networking without real ethernet hardware. Arbitrarily
> > complex networks can be created and simulated by creating virtual netwo=
rk
> > devices and assigning them to named broadcast domains, and all the usua=
l
> > ethernet-aware tools can operate on that network.
> >
> > This is different from e.g. the tun/tap device driver in that it is not
> > point-to-point. Virtual lans can be created that support broadcast,
> > multicast, and unicast traffic. The sandlan nics are not tied to a
> > process, but are instead persistent, have a mac address, can be queried
> > by iproute2 tools, etc., as if they are physical ethernet devices. This
> > provides a platform where, combined with netns support, distributed
> > systems can be emulated. These nics can also be opened in raw mode, or
> > even bound to other drivers that expect ethernet devices (vlans, etc),
> > as a way to test and develop ethernet based network protocols.
> >
> > A sandlan lan is not a tunnel. Packets are dispatched from a source
> > nic to destination nics as would be done on a physical lan. If you
> > want to create a nic to tunnel into an emulation, or to wrap packets
> > up and forward them elsewhere, then you don't want sandlan, you want
> > to use tun/tap or other tunneling support.
>
> As a general rule we don't accept any test/emulation code upstream
> unless it comes with some tests that actually use it.
> We have had bad experience with people adding virtual interfaces and
> features which then bit rot or become static checker fodder and we
> don't know whether anyone is actually using them and how.
>
> Is there something here that you can't achieve with appropriately
> combined veths?

I use the sandlan virtual interfaces to test my hanic driver, which I also =
just
posted as a patch. The hanic driver implements redundant links and sets
ethernet mac addresses, and also uses those mac addresses to infer streams
for deduplication. The veth driver only creates pairs of nics, and it doesn=
't
seem to support setting  the mac address



--

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
