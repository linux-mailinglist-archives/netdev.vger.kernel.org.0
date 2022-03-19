Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93A84DE4FE
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 02:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiCSB2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 21:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiCSB2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 21:28:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85B30A8A5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:27:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a8so20075083ejc.8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F/kZaaqHUwwd2zi442uCPD1MjBwwAWu9ZwJNQ9Z+bzo=;
        b=DTK//oav5Jcd7l7WYSvMqYv9IJRt1/Ft3D3pSh26ueco2nGUMl1WYZlwKRPkXaY3a0
         SE5ZUodSXoTCc50cxm0QGOdXkqG10ukpFhvpFzKvWz4wQohYb5HTUiWyB1en3hhadMup
         595PPOzmIhusCO96BQOAqauiJiC+HEUiglyVo6H5gVVP+gnDFzrqiVBK+vbjvfQsfw6F
         zZ4EdArmKT3R1Pi9mpVBIqlX8Xtvqy8VHqCoaM0GImSatdf6lWv+IvBWrxaL7Sds41Zb
         0B/g9ZzQWhN3oEuGvX3dh5pGe7nX1eI8IjQSUYECXYUwdKNfj5ZHKu1pY0w6//iqgZsT
         3eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F/kZaaqHUwwd2zi442uCPD1MjBwwAWu9ZwJNQ9Z+bzo=;
        b=AwexWYBcWCViHwqF1ZkFhp2BInwVSSUh7vxzHAozc55y2WYsJogFK3DxVj6mtThIIU
         OJfmcWpLLWhSMtFI2Cbxjo5x9C7AGstPOhOma6GHojJT0InCkOSJNtPjBaiOmxbpuAn6
         N0zDZAfUQ7iN4JXsgWpkYkVhud8MdsEKdbORlLERAeXV20IPGs1Q89g4bKBWmszROgn6
         9hH00Ehz/CeeyFuoPxqXv9+B/qudRdHRAdf0izoBFs/IJK7GTcMZq3Tj0yIx6nBUSqVk
         d1abpox4yYGttNl7w8P7BF7XdfFQMnm37Jo53sFcwJc9Ok+1EZY4jJP0hC0mZdAjYGRf
         4XAQ==
X-Gm-Message-State: AOAM532ntocul+k66YwTIncnit3L2t0qSa/e1mk51WcCi/cJfXL8HID9
        gfakRoaxOXHRcpKXD81lZiLpv5aAR1o=
X-Google-Smtp-Source: ABdhPJz0J00TTbg/sA3Jg4nW0CK94u4kp4xY3iy4x5Oaa6O7iHk4KzNwvnQ//up0YCipcc09Ev208A==
X-Received: by 2002:a17:907:3f86:b0:6df:ad43:583 with SMTP id hr6-20020a1709073f8600b006dfad430583mr7415958ejc.535.1647653242531;
        Fri, 18 Mar 2022 18:27:22 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id lb14-20020a170907784e00b006d5c0baa503sm4264431ejc.110.2022.03.18.18.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 18:27:22 -0700 (PDT)
Date:   Sat, 19 Mar 2022 03:27:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
Message-ID: <20220319012720.b2jempaih5y3c7lf@skbuf>
References: <20220318182817.5ade8ecd@dellmb>
 <87a6dnjce6.fsf@waldekranz.com>
 <20220318201825.azuoawgdl7guafrp@skbuf>
 <874k3vj708.fsf@waldekranz.com>
 <20220318230229.urddx3t7x4hk356t@skbuf>
 <871qyykai9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qyykai9.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 02:15:58AM +0100, Tobias Waldekranz wrote:
> >> This still doesn't explain why we're able to load
> >> MV88E6XXX_VID_STANDALONE though...
> >
> > Why doesn't it explain it? MV88E6XXX_VID_STANDALONE is 0, we have this
> > code so it falls in the branch that doesn't call mv88e6xxx_vtu_get():
> >
> > 	if (vid == 0) {
> > 		fid = MV88E6XXX_FID_BRIDGED;
> > 	} else {
> > 		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
> > 		if (err)
> > 			return err;
> >
> > 		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
> > 		if (!vlan.valid)
> > 			return -EOPNOTSUPP;
> >
> > 		fid = vlan.fid;
> > 	}
> 
> Ah, yes, of course. We should really change that to
> 
>     if (vid == MV88E6XXX_VID_BRIDGED)
> 
> I guess we can also add an exception for MV88E6XXX_VID_STANDALONE now so
> that we save a roundtrip to the VTU in those cases too. Anyway...

Hmmm, no. It's a bit late to think straight right now, but I'm pretty
sure that was not the intention, and that the code was at least at some
point correct.

The 0 from "vid == 0" is not the 0 from MV88E6XXX_VID_STANDALONE.
Instead, the "vid == 0" is supposed to match on the bridge's VID 0, aka
the VLAN-unaware database. Hence FID_BRIDGED. Perhaps confusingly, 'vid 0'
bridge FDB entries are classified to VTU entry 4095.

The fact that we have code that's loading ATU entries in FID_BRIDGED
from code paths that were triggered by VID_STANDALONE is what is
concerning. If I was the one who added those code paths, it was
certainly not intended. But I think it's since you've added the
mv88e6xxx_port_vlan_join(VID_STANDALONE) call in mv88e6xxx_setup_port().

> >> Vladimir, any advise on how to proceed here? I took a very conservative
> >> approach to filling in the STU ops, only enabling it on HW that I could
> >> test. I could study some datasheets and make an educated guess about the
> >> full range of chips that we could enable this on, and which version of
> >> the ops to use. Does that sound reasonable?
> >
> > Before, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE was done from 2 places:
> >
> > mv88e6352_g1_vtu_loadpurge()
> > mv88e6085_ops, mv88e6097_ops, mv88e6123_ops, mv88e6141_ops, mv88e6161_ops,
> > mv88e6165_ops, mv88e6171_ops, mv88e6172_ops, mv88e6175_ops, mv88e6176_ops,
> > mv88e6240_ops, mv88e6341_ops, mv88e6350_ops, mv88e6351_ops, mv88e6352_ops
> >
> > mv88e6390_g1_vtu_loadpurge()
> > mv88e6190_ops, mv88e6190x_ops, mv88e6191_ops, mv88e6290_ops, mv88e6390_ops,
> > mv88e6390x_ops, mv88e6393x_ops
> >
> > After the change, MV88E6XXX_G1_VTU_OP_STU_LOAD_PURGE is done only from the ops
> > that have stu_loadpurge:
> >
> > mv88e6352_g1_stu_loadpurge()
> > mv88e6097_ops, mv88e6352_ops
> >
> > mv88e6390_g1_stu_loadpurge()
> > mv88e6390_ops, mv88e6390x_ops, mv88e6393x_ops
> >
> > So if I understand correctly, we have this regression for all families that are
> > in the first group but not in the second group. I.e. a lot of families.
> 
> I don't have the hardware to test it, but I have now gone through the
> the functional spec for each of these devices.
> 
> I have confirmed that all those using mv88e6352_g1_vtu_loadpurge support
> the same STU operations and SID pool size (63).
> 
> Ditto for those using mv88e6390_g1_vtu_loadpurge.
> 
> > There's nothing wrong with being conservative, as long as you're a
> > correct conservative. In this case, I believe that the switch families
> > where you couldn't test MSTP should at least have a max_sid of 1, to
> > allow SID 0 to be loaded. So you don't have to claim untested MSTP
> > support. But then you may need to refine the guarding that allows for
> > MSTP support, to check for > 1 instead of > 0.
> 
> Having now done the research, which I should have just done from the
> beginning, I think the best approach is to just enable the regular MST
> offloading for all supported chips, i.e. all chips with separated
> VTU/STU.
> 
> Fair?

Fair.
