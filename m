Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAA4DCE12
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbiCQSyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiCQSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:54:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E5E223237;
        Thu, 17 Mar 2022 11:52:53 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m12so7666677edc.12;
        Thu, 17 Mar 2022 11:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gzPNpJdEUpw3mjUuvvjyqVBEBTyj2FECQV6z8PHyMUo=;
        b=o8xcG4Q+J5j5DHCk14HT66nrZU0u6AZoeh/Aw+tjG1dcVctOCVXQEOFDdRTJXLRJRR
         zhPKcAj1o02tj+2vcRXRPR2Q44pFKEIX0pe7g2Ex3Q+cFcg8wfcQnZS6g0YSwH3JmLj7
         4d9Nii3rvYgFt6yAABgUxDloQQo2XDDOppA9jTFKk3z7I3/fVH5w+h46mFevPqG1NvqG
         HroOsgPHDweuLvtuhPTZP9QH35NSUL9nniqT31QUIR0al8skfmpm59tzwywtVvN0B++l
         qkoekCxEe/+IbL7nzeo5BYQras2tEbtT5XUYcwCP/BeEHVIWKly9fFRy3ypfIGmVIrio
         VJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gzPNpJdEUpw3mjUuvvjyqVBEBTyj2FECQV6z8PHyMUo=;
        b=bRNHHp7FV0Y1BBQi2qdPc/sqh+407xVVDCmNET3FHY0NZdccaohp5U3l0g0x0SY9Cd
         sGgpR5dKXRoU3B3xfot/UnOOap5lU4feMlYCJjXKZEx/U+jBnPkhNJEa9jtj2pZiKRuB
         9BwcyJPLCX3X2/TPNqnnLr2TizZzkJ+BhVihX2/avSbVNDngsuNIKW5oZmPaAV+5wdfu
         l1EV35HLu0ibcbOkx8SshrPn7Lze0hBm3WkAuleEd/v3pozc85VARZfn9jOOiL9uufSe
         m6KnlI8ysTwrbcaOUzs73EJhc2UaDUUGuTMJF1HnascgY4AyQLmUeUfu7tTBkXJV5NpX
         gAFQ==
X-Gm-Message-State: AOAM533J9qsTaCj+5ESr66mW2D6E7tWlAGlhle74I1dDaT7l0nH/ZV/p
        patVwT7aoazIa92esmQtxLo=
X-Google-Smtp-Source: ABdhPJxGrv4Uv97ZSvQ2Qc4XMAXAd/7yWAQZiZ3RUMtorHOVIudOPLE7TAOqKap7BPA+lba5yVEbBg==
X-Received: by 2002:a05:6402:3483:b0:418:fb7c:8d23 with SMTP id v3-20020a056402348300b00418fb7c8d23mr4175401edc.249.1647543171871;
        Thu, 17 Mar 2022 11:52:51 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f4-20020a170906738400b006df8b6787afsm1811219ejl.13.2022.03.17.11.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 11:52:51 -0700 (PDT)
Date:   Thu, 17 Mar 2022 20:52:49 +0200
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
Message-ID: <20220317185249.5mff5u2x624pjewv@skbuf>
References: <20220224102908.5255-1-jianbol@nvidia.com>
 <20220224102908.5255-2-jianbol@nvidia.com>
 <20220315191358.taujzi2kwxlp6iuf@skbuf>
 <YjM2IhX4k5XHnya0@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjM2IhX4k5XHnya0@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 03:22:42PM +0200, Ido Schimmel wrote:
> > I don't know why just now, but I observed an apparent regression here
> > with these commands:
> > 
> > root@debian:~# tc qdisc add dev swp3 clsact
> > root@debian:~# tc filter add dev swp3 ingress protocol ip flower skip_sw ip_proto icmp action police rate 100Mbit burst 10000
> > [   45.767900] tcf_police_act_to_flow_act: 434: tc_act 1
> > [   45.773100] tcf_police_offload_act_setup: 475, act_id -95
> > Error: cls_flower: Failed to setup flow action.
> > We have an error talking to the kernel, -1
> > 
> > The reason why I'm not sure is because I don't know if this should have
> > worked as intended or not. I am remarking just now in "man tc-police"
> > that the default conform-exceed action is "reclassify".
> > 
> > So if I specify "conform-exceed drop", things are as expected, but with
> > the default (implicitly "conform-exceed reclassify") things fail with
> > -EOPNOTSUPP because tcf_police_act_to_flow_act() doesn't handle a
> > police->tcf_action of TC_ACT_RECLASSIFY.
> > 
> > Should it?
> 
> Even if tcf_police_act_to_flow_act() handled "reclassify", the
> configuration would have been rejected later on by the relevant device
> driver since they all support "drop" for exceed action and nothing else.

This is correct, but currently, the error is:

Error: cls_flower: Failed to setup flow action.
We have an error talking to the kernel, -1

I'd appreciate if the error was instead:

Error: mscc_ocelot: Offload not supported when exceed action is not drop.

which is basically what Jianbo was trying to achieve when he added the
policer_validate() functions. At least I'd know what's wrong. No?

> I don't know why iproute2 defaults to "reclassify", but the
> configuration in the example does something different in the SW and HW
> data paths. One ugly suggestion to keep this case working it to have
> tcf_police_act_to_flow_act() default to "drop" and emit a warning via
> extack so that user space is at least aware of this misconfiguration.

I don't want to force a reinterpretation of "reclassify" just to make
something that used to work by mistake continue to work. It sucks to
have to adapt, but not being able to make progress because of such
things sucks even more.

I'd just like the 'reclassify' action to be propagated in some reasonable
way to flow offload, considering that at the moment the error is quite cryptic.

> > > +		if (act_id < 0)
> > > +			return act_id;
> > > +
> > > +		entry->police.exceed.act_id = act_id;
> > > +
> > > +		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
> > > +						    &entry->police.notexceed.extval);
> > > +		if (act_id < 0)
> > > +			return act_id;
> > > +
> > > +		entry->police.notexceed.act_id = act_id;
> > > +
> > >  		*index_inc = 1;
> > >  	} else {
> > >  		struct flow_offload_action *fl_action = entry_data;
> > > -- 
> > > 2.26.2
> > > 
