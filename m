Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB78F6348EF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiKVVJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVVJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:09:51 -0500
Received: from mx0b-003ede02.pphosted.com (mx0b-003ede02.pphosted.com [205.220.181.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFE57C699
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:09:50 -0800 (PST)
Received: from pps.filterd (m0286620.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMI4S6E024085
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:52:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=ioMhQlwG34p+m8/pjImhoC+o75N/VcRHDY3I8VsdufU=;
 b=aT1O+ng5S5MEJolDHXbK+L+nSGmJu/iyt9lQWY2RRpKumDyU9h/LApHNIbnvHVrlw33K
 Xk/BC2fiijxe6FwvBIECYG5admKmWXTTZS+XmuG5MygwaK33Zu1tTfglgLTB0DW/iH/g
 O9B1R4gllazp3OoUfviC40QYBAmktY3Odos7dwb7YapEf2YHZr2m5v2/Lp3dtQjmpWO2
 vCxk8/o7Wa551BFEYTaB6NpR6vqAoSbuvn0KOR7LL2o8nOZReMnQY2Zexl+Y0J6viTgS
 0M5ihXi29YyC7hW9sWTsmjXJ3kDyGttOihNg9Rxkjw33FplMl6xiYO9RgSnstQev0BTq sA== 
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3m13cr0711-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:52:06 -0800
Received: by mail-ej1-f71.google.com with SMTP id qw20-20020a1709066a1400b007af13652c92so8955676ejc.20
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ioMhQlwG34p+m8/pjImhoC+o75N/VcRHDY3I8VsdufU=;
        b=SprEy11qQ+WB7Wzj2sjVw7PJzFJyhpOoaepBuqFSsAgwGDsCOvO/oDY7LJhsu6pPrL
         0XkUkiCJmDoI/2EIdtvfTdgAjkmRkz6HsLs7Gfq745MkZlKAF/rGBnrq5dPRjjbUx3JQ
         TuMGy6jskVQGF9KYKomGkQetAc+A8F7o8dZm5Y/fXCh52UM43C27jTVMaL8Jqk0wtRWt
         5NF6HW8d0XP9J7IBYLZ1zQJB3QNSAhxmIMbEz2s0tby+lj7M2RiGwS5gsEZJeZkfV6GZ
         h9vq0haK6RfFKNDswjHiNSLtYgKh7lOY6tMK5T5LkoUhZsUEWcckhx0DEB+LaKH7D1Y3
         rDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ioMhQlwG34p+m8/pjImhoC+o75N/VcRHDY3I8VsdufU=;
        b=XyCFN/6dhXHGsD8hulscytBHrOajuz/uUNZJumXrQYzIGZXAbwDlbdaF2K7E5AZG39
         yrEf5nyqJtAbzLOsecbAhZTHx5oreSu65ov2TzhCe/8GTLUuUvKKdjcczNVoMM/6z+Ys
         FgH9izutQIYDqfUEd1RH82j/jCYGsgLntziREbTpuJobEfbJ7e/QlEk4+R0OW1NXmhuL
         jQmpD8bfZaoGCfK0WRvtPlAwvq7nvX3tH0Ta0/ZSLqr0k0p1UeALxsoEie7jfSa9Hqb4
         rYU5K6JTw/Cpro9g0UVKWdU2ll2oX0Cejc//qUAeTGuDlE+ExFQZmc82ait5h58o/71A
         4uew==
X-Gm-Message-State: ANoB5plDZ8VrzkNQQKFcT8u9/3G92WzpJy7FhuAh6L7frV+74U5oAOCH
        qMiH+4lL5TQwKRtSmqw8wJ165NC7a0Lqd7hoLL4YemzUHWPUiPP48YY8bozA8CuNNGvkecUPeXR
        IFhT1XcIQyn8tCW486ui5vPdHaIVx9gyz
X-Received: by 2002:a17:906:1495:b0:7ad:d250:b904 with SMTP id x21-20020a170906149500b007add250b904mr5109720ejc.633.1669150324824;
        Tue, 22 Nov 2022 12:52:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf63BonXiTXZTfcVBNbvjCPw2Q7YIDX2PtDjlxec7D4vJj2egSwdexvtrdrItvNuBIU/IyTrEAmoKJ1anxru07A=
X-Received: by 2002:a17:906:1495:b0:7ad:d250:b904 with SMTP id
 x21-20020a170906149500b007add250b904mr5109703ejc.633.1669150324508; Tue, 22
 Nov 2022 12:52:04 -0800 (PST)
MIME-Version: 1.0
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <20221121195810.3f32d4fd@kernel.org> <20221122113412.dg4diiu5ngmulih2@skbuf>
In-Reply-To: <20221122113412.dg4diiu5ngmulih2@skbuf>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Tue, 22 Nov 2022 12:51:53 -0800
Message-ID: <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: Pse5KjatG2fBha7wil1ePkBdc-oSzIQs
X-Proofpoint-ORIG-GUID: Pse5KjatG2fBha7wil1ePkBdc-oSzIQs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220160
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 3:34 AM Vladimir Oltean <vladimir.oltean@nxp.com> w=
rote:
>
>
> I have some problems getting it to compile with W=3D1 C=3D1 (possibly not=
 only
> with those flags).
>

Looks like something I get to address.

>
> It will take me a while until I come with more intelligent feedback, but
> as a first set of questions (based solely on the documentation and not
> the code, I'm wondering a few things):
>
> 1. You seem to create a usage model which is heavily optimized for ping
>    (the termination plane), but not at all optimized for the forwarding
>    plane. What I mean is that the documentation says "Inbound traffic
>    that does not have an R-TAG is assumed to not be redundant, and is
>    simply passed up the network stack." That's a pretty big limitation,
>    isn't that so? If you want to build a RED box (intermediary device
>    which connects a non-redundant device into a redundant network) out
>    of a Linux device with hanic, how would you do that? Inbound traffic
>    which comes from the FRER-unaware device must match on a TSN stream
>    which says where it should go and how it should be tagged. And the
>    set of destination ports for inbound traffic may well be a subset of
>    the other enlisted ports, not the hanic device or one of its VLAN
>    uppers.

This is indeed intended to cover the talker/listener cases, so doesn't impl=
ement
bridging. Besides, there are software bridges for that. This driver provide=
s a
way for outbound traffic to be tagged and duplicated out multiple ports, an=
d
inbound R-TAG'ed packets to be deduplicated. This is probably most like bon=
ding,
and I did look at the bonding driver. But the bulk of the hanic driver is t=
he
R-TAG protocol handling. The ethernet packet editing seemed more than
the bonding driver would handle well, and I also wanted this implementation
to be as lightweight as possible.

Hanic tries to make the R-TAG handling transparent, so a "hanic" device can
be connected to software bridges if one wants to implement a converter box,
but in our experience that's more commonly handled by specialized hardware.

> 2. What about stream identification rules which aren't based on MAC DA/VL=
AN?
>    How about MAC SA/VLAN, or SIP, DIP, or active identification rules,
>    or generic byte@offset pattern matching?

Generic filtering and/or dynamic stream identification methods just seemed
out of scope for this driver. Certainly out of scope for our needs. Althoug=
h as
you noted, there are some controls on this matching, mostly for outbound
traffic, in order to allow some streams to be high-availability, and some t=
o
be not.

> 3. Shouldn't TSN streams be input by NETCONF/YANG in a useful industrial
>    production network, rather than be auto-discovered based on incoming
>    and outgoing traffic?

In theory yes, but the self-configuring has proven helpful. In our practica=
l
systems, there are switches that are routing tagged traffic around, and the=
y
do indeed forward based on fixed routing rules. This driver makes for a cle=
an
way to act as an endpoint in that network. "It just works."

> I mean, I can truly, genuinely understand why you made some of the
> choices you've made in the design of this driver, but the more I look at
> Xiaoliang's tc filter/action based take, the more I get the feeling that
> his approach is the way to fully exploit what can be accomplished with
> the 802.1CB standard. What you're presenting is more like your take on a
> subset that's useful to you (I mean, it *is* called "Cruise High
> Availability NIC driver", so at least it's truthful to that).

Yes, hanic implements a practical subset of the standard, and I try to be
clear about that in the documentation.

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
