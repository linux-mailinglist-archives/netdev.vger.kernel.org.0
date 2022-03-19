Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6054DE4F5
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbiCSBRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiCSBRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:17:23 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25CE2BB35E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:16:01 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q14so8041ljc.12
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RNzVA1KW3UzYMqNDYYsfXv4IGBK2GQNhTubN9v32FiU=;
        b=19Q9P5DSJQGXRevQSJ9UXKRsYwf2iK98FR3ynTB22BI94428JMdkbBGjcV3ZPKsRJm
         EHsSlpRY3/ZF7aax1O/YAl6gZXOtfp+V5CgcUxkXcs4iL8yptOVUPdc2/40Lqg6dY+0p
         ulkV3+Ud/PPvFmEP3dJDJ5XMt1er9+XH+2O2zaXqPKrZQ6PjO41Q916GX2BwIUWX3Rh8
         8F/SlEmCXMhMRYo7ysIajTxxNkVianikXtHjUEtZZOAJA5/9h7bzlo++RsnSIVygSzCH
         7nplDNGHg5sVaYN4RTfVDedAnmnMB/+8ojuXNyeAYoOssiQ0LQLVwWZtQ5aqJj6C6oVa
         klZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=RNzVA1KW3UzYMqNDYYsfXv4IGBK2GQNhTubN9v32FiU=;
        b=GQkR9d7Xv2yMMMAVgkQU01IF0ViD6F/pzjUC1TRgV6D1YLwwGPwLRe4HghcVkWt38E
         NPW1v9kOokIlehht3CmKRVibatBFogme+JdUxV9O02hwOze4gBJjQPN2H7FHC7hb1eJ7
         AOTD6cA3GYCWSdF8V0MPAeVe1hqFKoUIGnmI9t/+mDoyqtvwAdTMINxUCIckh2tBhu16
         g4s7hYO+jpaeCqTcP2eIY12yRxO/tidM+hJMURpG+nl0RfYIQkhwD0cvopGszVxBQVdY
         /Gt1VcabFJIEiY2Hg1BDMjD44lMuZuyX60hA3IBTEpultzns4myRDY/m3DV81WhN8dWD
         P7yQ==
X-Gm-Message-State: AOAM530Iss2YJew6hHy8bY9KJ+bTCWVl9ggHMjtXFi7kruLTAzcrUHuF
        EofKmsyTgykYKULUGJxQaw3TYXJVmhXtm339
X-Google-Smtp-Source: ABdhPJwpBRgmonOrqRtoBOYQzyDPwwjFX4SNki5i6VlZm8kt5U5bt412DAXIhy87eoXFu5F68Uh7fw==
X-Received: by 2002:a2e:3914:0:b0:247:f8fa:5070 with SMTP id g20-20020a2e3914000000b00247f8fa5070mr7736364lja.191.1647652559554;
        Fri, 18 Mar 2022 18:15:59 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id w7-20020a194907000000b0044828c52479sm1082508lfa.198.2022.03.18.18.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 18:15:59 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
In-Reply-To: <20220318230229.urddx3t7x4hk356t@skbuf>
References: <20220318182817.5ade8ecd@dellmb> <87a6dnjce6.fsf@waldekranz.com>
 <20220318201825.azuoawgdl7guafrp@skbuf> <874k3vj708.fsf@waldekranz.com>
 <20220318230229.urddx3t7x4hk356t@skbuf>
Date:   Sat, 19 Mar 2022 02:15:58 +0100
Message-ID: <871qyykai9.fsf@waldekranz.com>
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

On Sat, Mar 19, 2022 at 01:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 18, 2022 at 10:16:55PM +0100, Tobias Waldekranz wrote:
>> On Fri, Mar 18, 2022 at 22:18, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > Hello Tobias,
>> >
>> > On Fri, Mar 18, 2022 at 08:20:33PM +0100, Tobias Waldekranz wrote:
>> >> On Fri, Mar 18, 2022 at 18:28, Marek Beh=C3=BAn <kabel@kernel.org> wr=
ote:
>> >> > Hello Tobias,
>> >> >
>> >> > mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads =
to
>> >> > commit
>> >> >   49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
>> >>=20
>> >> Oh wow, really sorry about that! I have it reproduced, and I understa=
nd
>> >> the issue.
>> >>=20
>> >> > Trace:
>> >> >   mv88e6xxx_setup
>> >> >     mv88e6xxx_setup_port
>> >> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
>> >> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP
>> >> >
>> >>=20
>> >> Thanks, that make it easy to find. There is a mismatch between what t=
he
>> >> family-info struct says and what the chip-specific ops struct support=
s.
>> >>=20
>> >> I'll try to send a fix ASAP.
>> >
>> > I've seen your patches, but I don't understand the problem they fix.
>> > For switches like 6190 indeed this is a problem. It has max_stu =3D 63=
 but
>> > mv88e6190_ops has no stu_getnext or stu_loadpurge. That I understand.
>> >
>> > But Marek reported the problem on 6176. There, max_sid is 0, so
>> > mv88e6xxx_has_stu() should already return false. Where is the
>> > -EOPNOTSUPP returned from?
>>=20
>> Somewhat surprisingly, it is from mv88e6xxx_broadcast_setup.
>
> Sorry for the delay, I didn't notice the email because I was busy
> gathering my jaw from the floor after relistening some of Marc Martel's
> Queen covers.

Wow. He somehow manages to channel Freddie while still having his own
vibe too.

> This one looks a lot more plausible, let me see if I get it right below.
>
>> Ok, I'll go out on a limb and say that _now_ I know what the problem
>> is. If I uncomment .max_sid and .stu_{loadpurge,getnext} from my 6352
>> (which, like the 6176, is also of the Agate-family) I can reproduce the
>> same issue.
>>=20
>> It seems like this family does not like to load VTU entries who's SID
>> points to an invalid STU entry. Since .max_sid =3D=3D 0, we never run
>> stu_setup, which takes care of loading a valid STU entry for SID 0;
>> therefore when we read back MV88E6XXX_VID_BRIDGED in
>> mv88e6xxx_port_db_load_purge it is reported as invalid.
>>=20
>> This still doesn't explain why we're able to load
>> MV88E6XXX_VID_STANDALONE though...
>
> Why doesn't it explain it? MV88E6XXX_VID_STANDALONE is 0, we have this
> code so it falls in the branch that doesn't call mv88e6xxx_vtu_get():
>
> 	if (vid =3D=3D 0) {
> 		fid =3D MV88E6XXX_FID_BRIDGED;
> 	} else {
> 		err =3D mv88e6xxx_vtu_get(chip, vid, &vlan);
> 		if (err)
> 			return err;
>
> 		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
> 		if (!vlan.valid)
> 			return -EOPNOTSUPP;
>
> 		fid =3D vlan.fid;
> 	}

Ah, yes, of course. We should really change that to

    if (vid =3D=3D MV88E6XXX_VID_BRIDGED)

I guess we can also add an exception for MV88E6XXX_VID_STANDALONE now so
that we save a roundtrip to the VTU in those cases too. Anyway...

>> Vladimir, any advise on how to proceed here? I took a very conservative
>> approach to filling in the STU ops, only enabling it on HW that I could
>> test. I could study some datasheets and make an educated guess about the
>> full range of chips that we could enable this on, and which version of
>> the ops to use. Does that sound reasonable?
>
> Before, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE was done from 2 places:
>
> mv88e6352_g1_vtu_loadpurge()
> mv88e6085_ops, mv88e6097_ops, mv88e6123_ops, mv88e6141_ops, mv88e6161_ops,
> mv88e6165_ops, mv88e6171_ops, mv88e6172_ops, mv88e6175_ops, mv88e6176_ops,
> mv88e6240_ops, mv88e6341_ops, mv88e6350_ops, mv88e6351_ops, mv88e6352_ops
>
> mv88e6390_g1_vtu_loadpurge()
> mv88e6190_ops, mv88e6190x_ops, mv88e6191_ops, mv88e6290_ops, mv88e6390_op=
s,
> mv88e6390x_ops, mv88e6393x_ops
>
> After the change, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE is done only from th=
e ops
> that have stu_loadpurge:
>
> mv88e6352_g1_stu_loadpurge()
> mv88e6097_ops, mv88e6352_ops
>
> mv88e6390_g1_stu_loadpurge()
> mv88e6390_ops, mv88e6390x_ops, mv88e6393x_ops
>
> So if I understand correctly, we have this regression for all families th=
at are
> in the first group but not in the second group. I.e. a lot of families.

I don't have the hardware to test it, but I have now gone through the
the functional spec for each of these devices.

I have confirmed that all those using mv88e6352_g1_vtu_loadpurge support
the same STU operations and SID pool size (63).

Ditto for those using mv88e6390_g1_vtu_loadpurge.

> There's nothing wrong with being conservative, as long as you're a
> correct conservative. In this case, I believe that the switch families
> where you couldn't test MSTP should at least have a max_sid of 1, to
> allow SID 0 to be loaded. So you don't have to claim untested MSTP
> support. But then you may need to refine the guarding that allows for
> MSTP support, to check for > 1 instead of > 0.

Having now done the research, which I should have just done from the
beginning, I think the best approach is to just enable the regular MST
offloading for all supported chips, i.e. all chips with separated
VTU/STU.

Fair?
