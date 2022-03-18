Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6B04DE2A0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbiCRUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbiCRUjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:39:32 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262732878BA
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:38:13 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 17so12761720lji.1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NK5AtsioL1KwECKEZJIzv1qQ/ep2IDY+gI94j58iiGs=;
        b=ByexFiB1ELyHdGTBHDECIPbwmkyUMg+uhgDdiFewW4DM0ZFqq3ZChKT19CYvfdTGEw
         QDm5jfVIC5UOmqjAj0eSm0iy3jDjYNacDMewqSv068XK9o+sAarbnAfqG/fqMAtK50Va
         yBp+a7Atcya41BKgw3LvIzPgrTiseTsgZfmtutcNnFn3RV6GVMXBtprmYTXoLryWrN7w
         fJLOABztCbczxeAEtZvcB0oAT6vcDAJrKuhPUn4z4ZCVcThllmKIRx63AWhVLcf7euwp
         xh9oH8RFrIWEFzsFKQ2yzGouYbn2FcinEwpVHA42uP9KenebaN1C8UwJe9MrU39DQkaK
         FuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=NK5AtsioL1KwECKEZJIzv1qQ/ep2IDY+gI94j58iiGs=;
        b=t6j5ZhM3S7r9JRlv/Hy1Ufvy8PqfZJtFkQeQDtUcZVeYG+tQOkkaqPfZ+1f4rXIhP+
         lJ8eLotvox4qkVcKn1jr1LLV0AZbYeqFnrRTND2uyfcD765fmx+dDJPu7HRgaCt7bDlS
         9WPm4NuC1wtTfd9q+otgNMgldKqk+7Ls0vPVgncG4d+8wc9KcBpH3uJWsTK/W2/L7NRW
         DVzf8BOiKSn8YdnpRBH05oF4G+g8sPl2AEqCbKoHSkX8spDuaGed3HygWBnttuKyYg1u
         45wvtdi6wWy9tI4COfVmTz6x3v/z9DgaZncdXwd3wPDobhF4NlaXBVwLiDPHGTtUII/+
         G5Fw==
X-Gm-Message-State: AOAM531NYcKoMYRGCzRs5EE3E6eEe9SEx/lSs3yqgzmfN7RVOGT36okH
        P2UAJO72PYmWuqjn8jEhceg2xOKzqYuUmSNi
X-Google-Smtp-Source: ABdhPJytwgh5og8u57/2vhOAmBwOgofL4RbzCt8G4Ho6ErN8xgrrebGz/G3zWHwLTrLoeTOvAgSsQw==
X-Received: by 2002:a2e:9887:0:b0:247:e4e0:5b70 with SMTP id b7-20020a2e9887000000b00247e4e05b70mr7198358ljj.150.1647635891283;
        Fri, 18 Mar 2022 13:38:11 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id j14-20020a056512108e00b004481ee0cee1sm992983lfg.67.2022.03.18.13.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:38:10 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
In-Reply-To: <20220318201825.azuoawgdl7guafrp@skbuf>
References: <20220318182817.5ade8ecd@dellmb> <87a6dnjce6.fsf@waldekranz.com>
 <20220318201825.azuoawgdl7guafrp@skbuf>
Date:   Fri, 18 Mar 2022 21:38:10 +0100
Message-ID: <877d8rj8st.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 22:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hello Tobias,
>
> On Fri, Mar 18, 2022 at 08:20:33PM +0100, Tobias Waldekranz wrote:
>> On Fri, Mar 18, 2022 at 18:28, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
>> > Hello Tobias,
>> >
>> > mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads to
>> > commit
>> >   49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
>>=20
>> Oh wow, really sorry about that! I have it reproduced, and I understand
>> the issue.
>>=20
>> > Trace:
>> >   mv88e6xxx_setup
>> >     mv88e6xxx_setup_port
>> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
>> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP
>> >
>>=20
>> Thanks, that make it easy to find. There is a mismatch between what the
>> family-info struct says and what the chip-specific ops struct supports.
>>=20
>> I'll try to send a fix ASAP.
>
> I've seen your patches, but I don't understand the problem they fix.
> For switches like 6190 indeed this is a problem. It has max_stu =3D 63 but
> mv88e6190_ops has no stu_getnext or stu_loadpurge. That I understand.
>
> But Marek reported the problem on 6176. There, max_sid is 0, so
> mv88e6xxx_has_stu() should already return false. Where is the
> -EOPNOTSUPP returned from?

Yeah you're right, if I remove both .max_sid and
.stu_{loadpurge,getnext} from one of the chips that I run on (6097),
everything still probes fine.

I'll keep digging.
