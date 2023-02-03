Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AABF6892BA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjBCIvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBCIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:51:21 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935D17AE65
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:51:20 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m8so4452086edd.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPR6u7jSDTiv+QgYVfei44GTwkmZZOiFBEcsK9gwDdE=;
        b=SrdgKPYNjtzGpAQWJd+YxADdVRrGIlfFFI8nYQcPFoRxk3Fj6OKlwV/xcPVqEQxrOg
         VWrmHtDo4TE3HIypveh0hjTENifedhVHcxjT0W7onIq9UdwSmUfqtXyDI3VKegfqVhLN
         AfTjynXr5/un2FwGHBjMJLOv3K7Gr9gHp0iiDsThNHgR3waKmjX+Cy3IlOUIBc/9wssU
         BRdqQXZ3jXyxeBmfTbUhtwhA35T/k/G31RsjZW1yACYwXfTZjO5+/+Td5+XeZgKYBpuQ
         SMR9w5zgMO9aNwMWsszhhBFNOCMa0/WWkLdxxb0jJRAeCjQIvgtAQQ3yRppV5Q6FS31I
         bOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPR6u7jSDTiv+QgYVfei44GTwkmZZOiFBEcsK9gwDdE=;
        b=y3/2l+WOCesHemk+UQ8KhZdhZiliAvfUPG5AgSdEU8Kg+LSkkNvMoFhAC9SpMFQEpr
         VZGiJCHvHaQX+5pED3UeTo6tY82jajcfXl9qBqr22wVLBL1L/rDNvLsISP8n4bQA1hKN
         ZenjzPjKo9oygfmOfBzL9crgPO40+FRf6pH6CReS15NKgDpKFZN+MwywocTMiwEMqD79
         6IVs7CBljzByzEz6wvPSVy8pjB3JZvmAtYEIZKhP5ajntdJeyWsqDy49VNxkVf7Qva08
         hHui3wV7a9D4KQ33EmAL+JYeIY0Oq4nczq3yaFVbdVnV/yW0myCiHytoRnPo9w00nB87
         Cxkw==
X-Gm-Message-State: AO0yUKU5xANvi4lb6krthq1YMtTeGmUdoqi2baTwN1DyjJUPVXhwIidf
        7TUORdtkLs1xUqODdtbva709L3sSVTlZQtn5mdoAxr1JQ7U=
X-Google-Smtp-Source: AK7set9yMo4kx55N7JiAxbpJnYuoi519mfa2RkfNalttns5AOqaW77h92DUamIYJK81jW6y/JBf9yjlryQMT/dmpXNE=
X-Received: by 2002:a50:ab04:0:b0:4a0:b0ed:9ff8 with SMTP id
 s4-20020a50ab04000000b004a0b0ed9ff8mr2847663edc.39.1675414279177; Fri, 03 Feb
 2023 00:51:19 -0800 (PST)
MIME-Version: 1.0
References: <OS3P286MB22950EB574F05C341DEEF554F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <378b2fd8ce742cbb1f1d2e958690490b53f5b6da.camel@perches.com>
 <OS3P286MB22958BF0734E62B7661D06E0F5D69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <db14b18de650f0f9c2a207af1432748d853a75e0.camel@perches.com>
 <CAKXUXMwgqTqjWVsRjSM-RatjjpxMmij+KOHruyhijK0DTzJ_Kw@mail.gmail.com> <OS3P286MB2295DAC1609FDB8844C0494EF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <OS3P286MB2295DAC1609FDB8844C0494EF5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 3 Feb 2023 09:51:08 +0100
Message-ID: <CAKXUXMzvEbzhrhPu6UqV+Sww4rT7=cv4CE3KsCRXgE+M8dbWHg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogbmV0ZGV2L2NoZWNrcGF0Y2ggaXNzdWU=?=
To:     =?UTF-8?B?6Zm2IOe8mA==?= <taoyuan_eddy@hotmail.com>
Cc:     Joe Perches <joe@perches.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 9:44 AM =E9=99=B6 =E7=BC=98 <taoyuan_eddy@hotmail.co=
m> wrote:
>
> Hi, Lukas:
> =E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82Such a co-incidence=
, i just shot out the v4 submission:)
>
> Your analysis is convincing, the only thing is that i count the width in =
the specific line, it is 60+ characters, way below 80.
>
> let me check the script see if i can find anything
>

We assume a tabsize of eight characters, see "my $tabsize =3D 8;". That
is defined in the kernel coding guidelines.

Lukas
