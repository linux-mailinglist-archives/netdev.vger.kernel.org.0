Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE1C4DE360
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbiCRVSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiCRVSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:18:18 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FDE2DF3E2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:16:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p14so4649302lfe.4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=xcxoFFGg/3cfEVwF6TvR1NCK/ezSXazwMZ0iBgscOFE=;
        b=bXBOH090jhD9oQZ5flvPWBR1suZ1HkB7e1zIl6/FDJ3RrjNRgqOIYcl1CoYmfunYvD
         zcGP13A/1HP/yN9kQKjqfPMF2us5WLCfk8KiPIFvCjA+k5DTKQDYbs8WaVUw7Oqa84mF
         lmlSzBtxZNjsntTqDadUlQJdKcj2+kTkMYDcPbjAXN6ur1ArHU1T1v9SyzI3SM75hS2w
         RnSJ+QbQU455xttMRrhEU7zXG3ob0qNN4CjpM1eDzvlMq7iQMXULf4UULJvwiocet91f
         UjN1r9CM8DiukiA47N3bZSvN8k/e5JbQVCM64Vqp+ykyds9UVco3k72DLinIEiXMk2VO
         PIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xcxoFFGg/3cfEVwF6TvR1NCK/ezSXazwMZ0iBgscOFE=;
        b=O18A54dzDXjcNWdRviG1iV82oh8Lmaap8/arWLyODHyKcSx/YNTd9qbaARFseJFs+V
         810c6j/DFC/jX/GJVGTrBYMVpgY++nQ7oSKH9M29d2rq/3/I1o5iyw309aD6z2HqXjry
         8KuJ+tmlbX0Tixy0yUJ2YQvDpNMa8aj1WRUTNT2WSxwW6J2ZYLhmzZuILWzbrjtmiYXG
         2VvXTVVMnPJDnLKgs4lzAsRX+a0wcaWhNJxI6Ov6lZrrYJbthzcFgbpGtcCqJm6LBDve
         gDUgV0uiftgPAb37Q14CUa6NGOvXEYRzoXGLW1fKeWb1OXO5Tc8Z7Lj/kJtG6jvcH64b
         ycNw==
X-Gm-Message-State: AOAM530/4JECbdIrLVwF3hTP7aAI9daD0XJuFig6P7RLZWh/oi++R1aX
        wL2wOaz7uXpNd17HaYjDvVa533YIc7lWnGqn
X-Google-Smtp-Source: ABdhPJyoMEpBl2UgsqLTZWggq40YSYaibNblLvnz+c4HPfHUU2aStClBi1XXt3uVa933/o4xGw2Ahg==
X-Received: by 2002:a05:6512:696:b0:448:4df1:77b1 with SMTP id t22-20020a056512069600b004484df177b1mr6978244lfe.623.1647638216950;
        Fri, 18 Mar 2022 14:16:56 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id s27-20020ac2465b000000b00449fa1cb427sm705328lfo.193.2022.03.18.14.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 14:16:56 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
In-Reply-To: <20220318201825.azuoawgdl7guafrp@skbuf>
References: <20220318182817.5ade8ecd@dellmb> <87a6dnjce6.fsf@waldekranz.com>
 <20220318201825.azuoawgdl7guafrp@skbuf>
Date:   Fri, 18 Mar 2022 22:16:55 +0100
Message-ID: <874k3vj708.fsf@waldekranz.com>
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

Somewhat surprisingly, it is from mv88e6xxx_broadcast_setup.

Ok, I'll go out on a limb and say that _now_ I know what the problem
is. If I uncomment .max_sid and .stu_{loadpurge,getnext} from my 6352
(which, like the 6176, is also of the Agate-family) I can reproduce the
same issue.

It seems like this family does not like to load VTU entries who's SID
points to an invalid STU entry. Since .max_sid =3D=3D 0, we never run
stu_setup, which takes care of loading a valid STU entry for SID 0;
therefore when we read back MV88E6XXX_VID_BRIDGED in
mv88e6xxx_port_db_load_purge it is reported as invalid.

This still doesn't explain why we're able to load
MV88E6XXX_VID_STANDALONE though...

Vladimir, any advise on how to proceed here? I took a very conservative
approach to filling in the STU ops, only enabling it on HW that I could
test. I could study some datasheets and make an educated guess about the
full range of chips that we could enable this on, and which version of
the ops to use. Does that sound reasonable?
