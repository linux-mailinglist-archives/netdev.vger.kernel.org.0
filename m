Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743F64F662E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiDFRHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbiDFRHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:07:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C68B2F3D27;
        Wed,  6 Apr 2022 07:30:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bg10so4696488ejb.4;
        Wed, 06 Apr 2022 07:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vMzHq1nDdrTgNWerlZndh8+uHJuzMZUk5JD3WK4zHos=;
        b=b28NPSS+1bg37gEmwgiee4aegL8utqDr/xTOCnCKJVqzF4/NMDjmdcRP9K3OCbrkg+
         eOCO5ChW9MediiismI+cr/RxTxvd9QWwBhgslhp0AWtb9f6CckOyewF2Pup6uu+JxXYa
         MIV0akmn6I0YJHpkEAIJHOh6aXcv5Cz3UEOuLbV3Ciknbfp4gHCibWbDnOGebuUiAdHG
         csXyGE5btDdtVRmhFwdDJfN+/BayVuuxKXYNjwKg6pZuQTnzePXYbR6Xv2ZBbxYZJdsf
         OTSnvWxrJC3S9OO9ZKLiQm3dRyUYsjSTrguslVJt/oRV+BIYvVxvuxyM1MKnIW1uWjdU
         kqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vMzHq1nDdrTgNWerlZndh8+uHJuzMZUk5JD3WK4zHos=;
        b=eYxuz4reewKUatJrrbbTbjRiChQCz0szZiZlNfd9iNfJWKHRCqivgDshwcU4HfqFyU
         FIAdx7gReqL0yrRZV0KWoIgbkX/rK46gWjl0U5eK/4I9axDjQtklWPtFb4ysUIMWGLDn
         fXU0Th3Rz4FarSh38a2t1He109cs0JPnjm5rOhPinA7OLQak3v4cmFp99s0zlUj6bYRQ
         yqmNZqcXGgP9Iq8R1H1/0Ygqe0VCVTDLFoSZcnAeKXIdztiqN8IiyIPP1E3wI+Icwhix
         YxN2ZN2Mle0JO4Ezqtu0/S9fG3omVbgCqh4KBeZm8goezo9pT0eIY715dvQw/JnMnVEa
         LmWQ==
X-Gm-Message-State: AOAM533HjOppxKv59x+xBt2XoA930y3DgTupdm2pDVqCK4+DXO739RKP
        CV/3QuKTZ4306fx2N44n7Bk=
X-Google-Smtp-Source: ABdhPJwj5LMBNvlor+0fHq6krcRwBsg/XTJyYzN+wrPisCqeAZjQM8jMzy+Lkvlak65z9QeNtCE12A==
X-Received: by 2002:a17:907:6e89:b0:6df:d819:dc9c with SMTP id sh9-20020a1709076e8900b006dfd819dc9cmr9096219ejc.158.1649255437119;
        Wed, 06 Apr 2022 07:30:37 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id e19-20020a056402105300b004162d0b4cbbsm7933952edu.93.2022.04.06.07.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 07:30:36 -0700 (PDT)
Date:   Wed, 6 Apr 2022 17:30:34 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jianbo Liu <jianbol@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v3 1/2] net: flow_offload: add tc police action
 parameters
Message-ID: <20220406143034.voa7afprh3xa5epp@skbuf>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
 <20220315191358.taujzi2kwxlp6iuf@skbuf>
 <YjM2IhX4k5XHnya0@shredder>
 <20220317185249.5mff5u2x624pjewv@skbuf>
 <YjON61Hum0+B4m6y@shredder>
 <YjmhS7mEw7DraXfE@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjmhS7mEw7DraXfE@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 12:13:31PM +0200, Ido Schimmel wrote:
> On Thu, Mar 17, 2022 at 09:37:22PM +0200, Ido Schimmel wrote:
> > On Thu, Mar 17, 2022 at 08:52:49PM +0200, Vladimir Oltean wrote:
> > > I'd just like the 'reclassify' action to be propagated in some reasonable
> > > way to flow offload, considering that at the moment the error is quite cryptic.
> > 
> > OK, will check next week. Might be best to simply propagate extack to
> > offload_act_setup() and return a meaningful message in
> > tcf_police_offload_act_setup(). There are a bunch of other actions whose
> > callback simply returns '-EOPNOTSUPP' that can benefit from it.
> 
> # tc filter add dev dummy0 ingress protocol ip flower skip_sw ip_proto icmp action police rate 100Mbit burst 10000
> Error: act_police: Offload not supported when conform/exceed action is "reclassify".
> We have an error talking to the kernel
> 
> Available here:
> https://github.com/idosch/linux/commits/tc_extack
> 
> I plan to submit the patches after net-next reopens.

Thanks. I've tested these partially and at least the case that I
reported is now covered.
