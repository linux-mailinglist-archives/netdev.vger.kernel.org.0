Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6624DE24D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbiCRUTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbiCRUTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:19:49 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689412A88
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:18:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h1so11496540edj.1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zD4DtQCQOV4Vw/bOvTCBxiOZ+hVEugLE/iEy9KuHKhk=;
        b=OoDYFWhEpw7voN8KckfCGqK5Aoor9IAZ6Lny4wXtrF7sjDyOtif+Z9GhMTINtHkAs+
         75kojreHdF2TvYg4v/i9KFgElCCIKw3RQAx+HJNk78WOM5oO8UedjnKfXqwJ9B+pXFAe
         AM3EaXgSvkN5MxM1hCUFjkDETu/b1dNYMzgCsjWKwhgCw3nPVUbCnfdRm3ZlWiWnUu+M
         ohMDL3RA5VCUWN8UgsT7pdr6i+NPsi7IBruSjzj0c/zPbtPoqM6kqVLFsQxUUi03uEhv
         4QZS/cPaccA5aeUBiOg526wmtofoOMajbet62pTsRMRcCsIVN2oXlf3bAXeqPocqE/r2
         DG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zD4DtQCQOV4Vw/bOvTCBxiOZ+hVEugLE/iEy9KuHKhk=;
        b=VGJz3BJXmaIV6PUKpUylo6INDEFY4bSmUfHIgqhz8vVDdidLtOIgsQBgcktKRBCfWP
         Lloki3xTSKxxG4OI0n83DTSzmuyth3+11DBS9FAzceBIcPMJz3oEtw9+iUQgmqlU4KOm
         9ZKFrIgnu007W8ZKJ/ycLLrT741jZxSBdivZwIB0rJgZ5BSbjwT5g5oSmwio3tdtNlBg
         rpRBY5pyyYPKiPeunoaf2X6Qw7ia2YSJQmRtfmEUEERF/z/bhBqhqARlhH2ZMIqrds59
         B4R4Hsms/aFPdoSZI64sAccgkGOGZR/dzAeUFbA0t0GrGCFHAkYeKqGA7m1YaEbIUBU8
         rS8A==
X-Gm-Message-State: AOAM533x0j9UZ5qWEYVJEZwj1Uv+Z2a1FUprMX6k0gxnU3/c5h+QLY2T
        X8LgfsKbbdLSb5ASUbP6OZmAM7GUZ4E=
X-Google-Smtp-Source: ABdhPJyMHxlNP3vo2Nh9OlDcYq09bNCwVIEhWfKJtV0ra4wwdeRm1B9tQ/sAlu7VfCFUW2oSs/IdPQ==
X-Received: by 2002:a05:6402:486:b0:413:bd00:4f3f with SMTP id k6-20020a056402048600b00413bd004f3fmr11255168edv.103.1647634706855;
        Fri, 18 Mar 2022 13:18:26 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b006a767d52373sm4055289ejb.182.2022.03.18.13.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 13:18:26 -0700 (PDT)
Date:   Fri, 18 Mar 2022 22:18:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
Message-ID: <20220318201825.azuoawgdl7guafrp@skbuf>
References: <20220318182817.5ade8ecd@dellmb>
 <87a6dnjce6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a6dnjce6.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tobias,

On Fri, Mar 18, 2022 at 08:20:33PM +0100, Tobias Waldekranz wrote:
> On Fri, Mar 18, 2022 at 18:28, Marek Behún <kabel@kernel.org> wrote:
> > Hello Tobias,
> >
> > mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads to
> > commit
> >   49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> 
> Oh wow, really sorry about that! I have it reproduced, and I understand
> the issue.
> 
> > Trace:
> >   mv88e6xxx_setup
> >     mv88e6xxx_setup_port
> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
> >       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP
> >
> 
> Thanks, that make it easy to find. There is a mismatch between what the
> family-info struct says and what the chip-specific ops struct supports.
> 
> I'll try to send a fix ASAP.

I've seen your patches, but I don't understand the problem they fix.
For switches like 6190 indeed this is a problem. It has max_stu = 63 but
mv88e6190_ops has no stu_getnext or stu_loadpurge. That I understand.

But Marek reported the problem on 6176. There, max_sid is 0, so
mv88e6xxx_has_stu() should already return false. Where is the
-EOPNOTSUPP returned from?
