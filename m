Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F5563C6DD
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiK2Rys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiK2Ryp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:54:45 -0500
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949BD27140
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:54:43 -0800 (PST)
Received: from pps.filterd (m0286614.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATEaO15015193
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:54:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : cc :
 content-type : content-transfer-encoding; s=ppemail;
 bh=uWXrCdPelYzin+4K8npplpf2gvKRjBtOt3/S94bUI/c=;
 b=YFQr0M7FYnGa8W8uDDI5dMyNScB4o/Tq7CZCN+U3M3oQ+g1sIjnWeuo6q+s9vxyxTxiD
 lCOP4aWMZp2saHIYoay0+5uBPxWLjFWaps78f3thm0NzgJeYZXfZbe2DmYJvn4y5bTn5
 BxK5dO+mfz2YAb5FG8nuKrOwAeB4tvc3/J6pEdFrYhTYdhLafx8GPxLam3/H2A68KBOT
 H9oiJJf+SupaFkaSicebZ2jnuN3CrrGgoUGixKK0f6m+3VNYCAzOuH8n9W60CIm487BV
 pex7fDojxA4jw3iocnctAwuV+e+S6L3BWeAGgkKMAvYdgM+e6Hg+2gaFSnEBcgqksvKT yg== 
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3m43jchpf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:54:43 -0800
Received: by mail-ed1-f71.google.com with SMTP id m13-20020a056402510d00b0046913fa9291so8490497edd.6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWXrCdPelYzin+4K8npplpf2gvKRjBtOt3/S94bUI/c=;
        b=eRNoQhEX5e13xdUe1RsgdrB/qFRw9AFZTGAdlFAauHTDyOKdzuHIxWMP1R9qiFRBEl
         2ExnRUL++iKkmlvz4tlY7/oO9LySkKbx5XdPy42a70w0xONd4J6h6LkLB9DIfJxfja9r
         9QkTxqsrlT/zPVwk/1bfVm6xS0dPWo3bOnIFlCBvkgZqD1w+7N5cg7qyS1pyU5bRE7zT
         phCyjRAUOE6ex9ufXQyxS5HHo01jj9jUJs5cl5BUKyL/X+bX4WgCoprIblAoGYOIDAZB
         1ZNwLqB4XSxm+kTDSfT2XFV0Ak1kO+mIAX2PRk++Ibx9BHZIqgYFOYsd49W4GmNUftK6
         gJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uWXrCdPelYzin+4K8npplpf2gvKRjBtOt3/S94bUI/c=;
        b=K9REyHSkLmFXKUpb7FEuE4+fJTS7PB6tbb+TMvVHZSKhzC5XAf6VB8TMDW3XjBy/+h
         hk/L6qUF353py1YfGHfoYNYStFYGOVFCYAumGRmAzWgn0uEvCE2aiwr2oe29hWRzNuAr
         fI6e2NdYEoya3A7Tb1If4GBT1wJoP7Cjio3tw3O43T/NkrklDioowYmcwDUaW/JpvDG/
         p0k4SuJlrl4JovKWx1LmCYdWleuFf0+AkuppdTjpSznM1H8mzXFBNQO/owOfGfPOZGMy
         S/ZMdfLEHvGe8JX8VHRuDobhdcvmwpx/xvOp2KBBRveHOiM7bVhcnilLG1VvaUMYTwlU
         AjnA==
X-Gm-Message-State: ANoB5pn3jvGIuHvyLsjTFS0xFyEwez7kECG9jsdivVi+TZ5PMuf1cAoU
        09Hq48VHOZjGs+4kHZ2AK1uChRlGyzW19amEyTyJ12qecK/yUGGCvcM0a/KkEy7L78haCaxrXph
        8VNQZ/ZPBYmepw44oFWB4wyAg8fGeSqNY
X-Received: by 2002:a17:906:5050:b0:7b2:8f2c:a877 with SMTP id e16-20020a170906505000b007b28f2ca877mr23469811ejk.90.1669744480903;
        Tue, 29 Nov 2022 09:54:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7qxpLMZzTXIzDpTTxhtcYo+9K1Sia2ntYKsuu9xSv5S7uQatz1xh5y/8SGVCnIGIhD9IVEWMTcKrr1H7mfdHY=
X-Received: by 2002:a17:906:5050:b0:7b2:8f2c:a877 with SMTP id
 e16-20020a170906505000b007b28f2ca877mr23469798ejk.90.1669744480511; Tue, 29
 Nov 2022 09:54:40 -0800 (PST)
MIME-Version: 1.0
References: <20221116222429.7466-1-steve.williams@getcruise.com>
 <20221117200046.0533b138@kernel.org> <CALHoRjctagiFOWi8OWai5--m+sezaMHSOpKNLSQbrKEgRbs-KQ@mail.gmail.com>
 <Y30sfGrQ2lQN+CMY@lunn.ch>
In-Reply-To: <Y30sfGrQ2lQN+CMY@lunn.ch>
From:   Steve Williams <steve.williams@getcruise.com>
Date:   Tue, 29 Nov 2022 09:54:29 -0800
Message-ID: <CALHoRjcwnHGWKDLD_RO5W2yDSTBbmPUq+eEczk7v5FjuhKikLw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] sandlan: Add the sandlan virtual
 network interface
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: nrddofFc7QpVunibUVrL7IVa7gGHKS2R
X-Proofpoint-ORIG-GUID: nrddofFc7QpVunibUVrL7IVa7gGHKS2R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_11,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=913
 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290100
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

On Tue, Nov 22, 2022 at 12:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Nov 21, 2022 at 06:59:11PM -0800, Steve Williams wrote:
> > I have had trouble with the veth driver not transparently passing the
> > full ethernet packets unaltered, and this is wreaking havoc with the
> > hanic driver that I have (and that I'm submitting separately). That,
> > and veth nodes only come in pairs, whereas with sandlan I can make
> > more complex LANs and that allows me to emulate more complex
> > situations. But fair point, and I am looking more closely at figuring
> > out exactly what the veth driver is doing to my packets.
>
> If there is a real problem with veth, please describe it, so we can
> fix the bugs. We don't add new emulators because of bugs in the
> existing system.

In light of the feedback I received here, I revisited the issue; and
was able to get the veth driver to work after all, at least for
regression tests of the hanic driver. I can't seem to reproduce the
issue I thought I was having. So that kills one motivation for the
sandlan driver, at least for me.

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
