Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBA4DE464
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 00:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiCRXDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 19:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbiCRXDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 19:03:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE16B2F24E8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 16:02:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id d10so19649001eje.10
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 16:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=68UcBWCxr9f6UE6zB0F3Jacphuan0SZVsJqVb6T4PBw=;
        b=Ui21BtDmeIFQ/1Tnu/4TDUmVBeDveLrFvn2jYuv5hPbcSsvXMGJEx1g34El4PQp/2d
         2QrfYjDu7Ip/fqjuQLuY3+PA6OzCDkPIrYwXa8td06VKz2AHvAIGT0ZanAyEB21Y6J6u
         fv+/pgmmOoLphOiy75cw/+xnUsBCKjpOeMx/e3AGV9Rf8b7JVpl2apLK/RzhSUaGukG0
         Au25oWbaCpYZc8nQV02CGqUvRJIdl82z/U0iDLSxAonpJl0Fy3VJUOvkDU2vPLQMMw8T
         wRvijoCD/c7dgR/WEt1Nw8PFFjsUh8tXEUvPbDjpVEarJCps7zKTvef33of4UYN21mL+
         J9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=68UcBWCxr9f6UE6zB0F3Jacphuan0SZVsJqVb6T4PBw=;
        b=8H2FxSaywPsxddc5/ec683HYlpyDnkJEyGblkSVHjtgi42c4Oj0LdZBNDNHkfIHFlB
         5YoYGLOvlpdL+yt/l20k6uvTJklANXJ/gjAmFvDSCj1gHIzUUjVSnTs+o21+/1U6EbF/
         ZwbYJsE9exZPPHVDpKdX78EK0D69DrSOqgX6RQFUfKfSaxTmjt3tjsXJebkoUFpMfRGB
         mOtd6zvNyvo8OxFqDAVZ0LAqu9pESR/awbFRpnKEOwKCMd1XOsGprdbm/m3mTjIgpkZp
         m7wm1idyECiZx3lxkZW9HhtPorLQMdxLnTf51YAKHMbbN6PkBlLnenbIwhj8yVGqhPLR
         grLA==
X-Gm-Message-State: AOAM530GsphqBFiMJDVtZH8bvS7kOqEfbh4eyfReRPz+nQ2Vj+KQHwAh
        njDB/A4FwKOR2HTCXJeaoVvnrIW/OWk=
X-Google-Smtp-Source: ABdhPJx8WYgDi71jDRrt6JXeH+hxAjytDvXr5n313t74iHHxftCbwYApIf4E6OnCvRuOe4KFI2SSqA==
X-Received: by 2002:a17:907:1b27:b0:6d9:ceb6:7967 with SMTP id mp39-20020a1709071b2700b006d9ceb67967mr11438544ejc.186.1647644551051;
        Fri, 18 Mar 2022 16:02:31 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id y27-20020a170906519b00b006dfaf4466ebsm1747444ejk.116.2022.03.18.16.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 16:02:30 -0700 (PDT)
Date:   Sat, 19 Mar 2022 01:02:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
Message-ID: <20220318230229.urddx3t7x4hk356t@skbuf>
References: <20220318182817.5ade8ecd@dellmb>
 <87a6dnjce6.fsf@waldekranz.com>
 <20220318201825.azuoawgdl7guafrp@skbuf>
 <874k3vj708.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874k3vj708.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 10:16:55PM +0100, Tobias Waldekranz wrote:
> On Fri, Mar 18, 2022 at 22:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Hello Tobias,
> >
> > On Fri, Mar 18, 2022 at 08:20:33PM +0100, Tobias Waldekranz wrote:
> >> On Fri, Mar 18, 2022 at 18:28, Marek Behún <kabel@kernel.org> wrote:
> >> > Hello Tobias,
> >> >
> >> > mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads to
> >> > commit
> >> >   49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> >> 
> >> Oh wow, really sorry about that! I have it reproduced, and I understand
> >> the issue.
> >> 
> >> > Trace:
> >> >   mv88e6xxx_setup
> >> >     mv88e6xxx_setup_port
> >> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
> >> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP
> >> >
> >> 
> >> Thanks, that make it easy to find. There is a mismatch between what the
> >> family-info struct says and what the chip-specific ops struct supports.
> >> 
> >> I'll try to send a fix ASAP.
> >
> > I've seen your patches, but I don't understand the problem they fix.
> > For switches like 6190 indeed this is a problem. It has max_stu = 63 but
> > mv88e6190_ops has no stu_getnext or stu_loadpurge. That I understand.
> >
> > But Marek reported the problem on 6176. There, max_sid is 0, so
> > mv88e6xxx_has_stu() should already return false. Where is the
> > -EOPNOTSUPP returned from?
> 
> Somewhat surprisingly, it is from mv88e6xxx_broadcast_setup.

Sorry for the delay, I didn't notice the email because I was busy
gathering my jaw from the floor after relistening some of Marc Martel's
Queen covers.

This one looks a lot more plausible, let me see if I get it right below.

> Ok, I'll go out on a limb and say that _now_ I know what the problem
> is. If I uncomment .max_sid and .stu_{loadpurge,getnext} from my 6352
> (which, like the 6176, is also of the Agate-family) I can reproduce the
> same issue.
> 
> It seems like this family does not like to load VTU entries who's SID
> points to an invalid STU entry. Since .max_sid == 0, we never run
> stu_setup, which takes care of loading a valid STU entry for SID 0;
> therefore when we read back MV88E6XXX_VID_BRIDGED in
> mv88e6xxx_port_db_load_purge it is reported as invalid.
> 
> This still doesn't explain why we're able to load
> MV88E6XXX_VID_STANDALONE though...

Why doesn't it explain it? MV88E6XXX_VID_STANDALONE is 0, we have this
code so it falls in the branch that doesn't call mv88e6xxx_vtu_get():

	if (vid == 0) {
		fid = MV88E6XXX_FID_BRIDGED;
	} else {
		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
		if (err)
			return err;

		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
		if (!vlan.valid)
			return -EOPNOTSUPP;

		fid = vlan.fid;
	}

> Vladimir, any advise on how to proceed here? I took a very conservative
> approach to filling in the STU ops, only enabling it on HW that I could
> test. I could study some datasheets and make an educated guess about the
> full range of chips that we could enable this on, and which version of
> the ops to use. Does that sound reasonable?

Before, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE was done from 2 places:

mv88e6352_g1_vtu_loadpurge()
mv88e6085_ops, mv88e6097_ops, mv88e6123_ops, mv88e6141_ops, mv88e6161_ops,
mv88e6165_ops, mv88e6171_ops, mv88e6172_ops, mv88e6175_ops, mv88e6176_ops,
mv88e6240_ops, mv88e6341_ops, mv88e6350_ops, mv88e6351_ops, mv88e6352_ops

mv88e6390_g1_vtu_loadpurge()
mv88e6190_ops, mv88e6190x_ops, mv88e6191_ops, mv88e6290_ops, mv88e6390_ops,
mv88e6390x_ops, mv88e6393x_ops

After the change, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE is done only from the ops
that have stu_loadpurge:

mv88e6352_g1_stu_loadpurge()
mv88e6097_ops, mv88e6352_ops

mv88e6390_g1_stu_loadpurge()
mv88e6390_ops, mv88e6390x_ops, mv88e6393x_ops

So if I understand correctly, we have this regression for all families that are
in the first group but not in the second group. I.e. a lot of families.

There's nothing wrong with being conservative, as long as you're a
correct conservative. In this case, I believe that the switch families
where you couldn't test MSTP should at least have a max_sid of 1, to
allow SID 0 to be loaded. So you don't have to claim untested MSTP
support. But then you may need to refine the guarding that allows for
MSTP support, to check for > 1 instead of > 0.
