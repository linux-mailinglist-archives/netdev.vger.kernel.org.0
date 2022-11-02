Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FA56156F4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 02:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiKBB0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 21:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiKBB0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 21:26:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5891F9F6
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 18:26:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id p3so15173785pld.10
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 18:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d9wmD1IvAYJQ2kwYwf8vOxIjn3XxuujgFcflY3sL7vQ=;
        b=c9yebsJSsKyPnQUMWWcuD5xjC5JFn8Ay/QR7ejDFGVEVDmYAekFweayjbV0f83sNuD
         +negwoEofL+3toTm88/4DsnHAiY7YA2dWxRicrthrMvWaf666QhR/dMr8i78NPdRxghA
         suU/CtIGN/dtLBGVl4UiVfbz4bB4l+OMQhjMujrzNaft6ey95Ywph52y040+LUYlHrQW
         32VE8sIvo8WScAldH/pq0peK6wV9CtUSV+q+/NtZKTvHUkUPTMgt5VtaWk+6WC1ZLegz
         EM8Y+J/jnyw5Z9Cb1l1Kv92elZhFn1bbkGIZPSdO/8/2EyXPwckG+gjuz5P19LbbNGAM
         uqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9wmD1IvAYJQ2kwYwf8vOxIjn3XxuujgFcflY3sL7vQ=;
        b=Wt0MrSQGFqeQO2FVt4X+xkyJe7oERg9VT5hGdc6xbU27Y0nhDxzJ9yIVqh1Vq86CZL
         dj0piHX69xl/lrC/Xqp+hNuvi7PBFAo8VpGJmPMrazlMX/wxGAbrrqtcOSv6PEv1lEBO
         ig5fI9/Sd1sDOXl6EBmlOrBiLInPNraXi62cmIhQagxtzgfjyQf46hhr2iVJJcbOLlpR
         fUhBwOPV5awkdvktjMTi85E4Iwo3Jw2GdBHx4idhWQ4VnJO/uPW/CW3Xp8JMlauqorO/
         809rTU6y2kjumv6k4YnvKLEcJV45UswnSgZJNK9o/h7MpbvGPmYFqCKH9kyg774wwQU2
         p/gA==
X-Gm-Message-State: ACrzQf06uwrvrUUNDr6o1Bg3I1RW9+zm5qrW9b9QACulaKaN7tpLsIZd
        HMDWJzIH1lt5H0MxcgkAv3DyJp32n9jbiw==
X-Google-Smtp-Source: AMsMyM6syN+oPCX/uFqvz8tYJ/KygLSAj5GSf9yKTuggFknppF322YEWsrZF3zHJn7SBzInG2s67CQ==
X-Received: by 2002:a17:90b:1d90:b0:213:d0a2:72ab with SMTP id pf16-20020a17090b1d9000b00213d0a272abmr16246602pjb.221.1667352402837;
        Tue, 01 Nov 2022 18:26:42 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a12-20020aa794ac000000b0056b91044485sm7143796pfl.133.2022.11.01.18.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 18:26:42 -0700 (PDT)
Date:   Wed, 2 Nov 2022 09:26:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y2HHTV9SFBdFtDuq@Laptop-X1>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
 <YziJS3gQopAInPXw@pop-os.localdomain>
 <Yzillil1skRfQO+C@t14s.localdomain>
 <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1kEtovIpgclICO3@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

Any comments?

Thanks
Hangbin
On Wed, Oct 26, 2022 at 05:58:14PM +0800, Hangbin Liu wrote:
> On Sun, Oct 02, 2022 at 11:27:08AM -0400, Jamal Hadi Salim wrote:
> > > But, precisely. In the example Hangbin gave, it is showing why the
> > > entry is not_in_hw. That's still data that belongs to the event that
> > > happened and that can't be queried afterwards even if the user/app
> > > monitoring it want to. Had it failed entirely, I agree, as the control
> > > path never changed.
> > >
> > > tc monitor is easier to use than perf probes in some systems. It's not
> > > uncommon to have tc installed but not perf. It's also easier to ask a
> > > customer to run it than explain how to enable the tracepoint and print
> > > ftrace buffer via /sys files, and the output is more meaningful for us
> > > as well: we know exactly which filter triggered the message. The only
> > > other place that we can correlate the filter and the warning, is on
> > > vswitchd log. Which is not easy to read either.
> > 
> > To Jakub's point: I think one of those NLMSGERR TLVs is the right place
> > and while traces look attractive I see the value of having a unified
> > collection point via the tc monitor.
> 
> Hi Jamal,
> 
> Sorry for the late response. I just came back form vacation. For this issue,
> I saw netlink_dump_done() also put NLMSGERR_ATTR_MSG in NLMSG_DONE.
> So why can't we do the same here?
> 
> In https://www.kernel.org/doc/html//next/userspace-api/netlink/intro.html,
> The "optionally extended ACK" in NLMSG_DONE is OK.
> 
> > Since you cant really batch events - it seems the NLMSG_DONE/MULTI
> > hack is done just to please iproute2::tc?
> 
> Yes.
> 
> > IMO:
> > I think if you need to do this, then you have to teach iproute2
> > new ways of interpreting the message (which is nice because you
> > dont have to worry about backward compat). Some of that code
> > should be centralized and reused by netlink generically
> > instead of just cls_api, example the whole NLM_F_ACK_TLVS dance.
> 
> Would you please help explain more about this?
> 
> > 
> > Also - i guess it will depend on the underlying driver?
> > This seems very related to a specific driver:
> > "Warning: mlx5_core: matching on ct_state +new isn't supported."
> > Debuggability is always great but so is backwards compat.
> > What happens when you run old userspace tc? There are tons
> > of punting systems that process these events out there and
> > depend on the current event messages as is.
> 
> I think old tc should just ignore this NLMSGERR_ATTR_MSG?
> 
> Thanks
> Hangbin
