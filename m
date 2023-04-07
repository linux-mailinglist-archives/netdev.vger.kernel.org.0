Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138996DB43A
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDGTbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjDGTbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:31:04 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F855FEF;
        Fri,  7 Apr 2023 12:31:01 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l15-20020a05600c4f0f00b003ef6d684102so22199627wmq.3;
        Fri, 07 Apr 2023 12:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680895860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rx0D90x3KO0WoNiFxLvZ3+gh8Q/KVbE9Dy+ykDvkUTA=;
        b=mphGOEyX2BKmhbDGiWCYKdUIitmMUtctAQxb2+cmpfx3xUi1vZT2yd0Hxjr1TIhMhk
         qanE8ytbefDr9n5WwEDNG+vQwXdkX3AYziZyLiL+06hwNHTGJH5CISgjmP8UyT5C61xw
         wQjsPD1pRc65AM2Eufcpfuqd3A6kDAYUESC6pJHEu344rsNMWJwi7yB7BPe6EJT/BUTv
         ds/x4rF+RpiOL2u3BKxIEH21UJk0VegHtscLgku0t7OWxLGbnRAwyhJ/l3I9lGU5EpYz
         4bx7Jj8PtpjCriVjwEiX8+QSuXTDa9LoavgduWQO1ZDr8uXaYvS/pI0z+bxLvad8d8uN
         Zn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680895860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rx0D90x3KO0WoNiFxLvZ3+gh8Q/KVbE9Dy+ykDvkUTA=;
        b=G0nnEVc36sq3UamtGLaOaQ6EUYeunM0ME/e2dug8lkOn21o9ZSuTeK4PPdCsMjqQ88
         VcaNfOc1W4PZBKgLZ3d/yJdTLB5e1Xb3NWazUpJGg4dFPT2ELNZsTmHTVMMUyH2ZLwS+
         mTwZCjJbqOWtfgG6fxczi0El7OB6Nqyv2/nYTyvfh9qgaLG86LTNwf2zb0Rl4JLU4F/i
         zFd9rontLwuiLi9fXGjoSY11LoedN3lzFDRPA5SpXXy79IM51rR3TmhfUTFLAHXnk8X+
         SsXu3U1cHragNwMQPQx4t1u7hMKuuiqDHxQGl6JtEXXt4tCp6xoezlZWQo9aCp7+6yxQ
         WPjg==
X-Gm-Message-State: AAQBX9cqSwtWzT1A34e7+aYBHcc0owcw9jDjHwVV8pzvq6We2XSBi7lT
        uH0Rnq73gES2KdpOZ358O1o=
X-Google-Smtp-Source: AKy350b5ItVpscV4+vIDabe3uocQprIqvZ38nXBB881tUPjft1tMe3+j0XAZPD5sGRLtfBQEHn/daA==
X-Received: by 2002:a05:600c:2285:b0:3ee:8e3d:4b9c with SMTP id 5-20020a05600c228500b003ee8e3d4b9cmr1970470wmf.21.1680895859410;
        Fri, 07 Apr 2023 12:30:59 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id c5-20020a5d5285000000b002cea8e3bd54sm5207352wrv.53.2023.04.07.12.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 12:30:59 -0700 (PDT)
Date:   Fri, 7 Apr 2023 22:30:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230407193056.3rklegrgmn2yecuu@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com>
 <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
 <20230407164103.vstxn2fmswno3ker@skbuf>
 <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=go4RNohHpt6Z9wFk0AU81gJY3puBTUOC6F0xMocJouQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:49:01PM -0400, Jamal Hadi Salim wrote:
> On Fri, Apr 7, 2023 at 12:41 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > On Fri, Apr 07, 2023 at 12:22:26PM -0400, Jamal Hadi Salim wrote:
> > > > +enum {
> > > > +       TC_FP_EXPRESS = 1,
> > > > +       TC_FP_PREEMPTIBLE = 2,
> > > > +};
> > >
> > > Suggestion: Add a MAX to this enum (as is traditionally done)..
> >
> > Max what? This doesn't count anything, it just expresses whether the
> > quality of one traffic class, from the Frame Preemption standard's
> > perspective, is express or preemptible...
> >
> > > > @@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
> > > >         return 0;
> > > >  }
> > > >
> > > > +static const struct
> > > > +nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] = {
> > > > +       [TCA_MQPRIO_TC_ENTRY_INDEX]     = NLA_POLICY_MAX(NLA_U32,
> > > > +                                                        TC_QOPT_MAX_QUEUE),
> > >
> > > And use it here...
> >
> > Where? Above or below the comment? I think you mean below (for the
> > policy of TCA_MQPRIO_TC_ENTRY_FP)?
> 
> That was what I meant. I misread that code thinking it was a nested
> TLV range check. If it is only going to be those two specific values,
> I understand - but then wondering why you need a u32; wouldnt a u8 be
> sufficient?

I believe netlink isn't exactly optimized for passing small values; the
netlink attributes are going to be aligned to NLA_ALIGNTO (4) anyway,
so it's not like this is going to save space or something. Also, there's
a policy restricting the maximum, so arbitrarily large values cannot be
passed now, but could be passed later if needed. I did not see any good
enough reason to close that door.

> The only reason you would need a MAX is if it is possible that new
> values greater than TC_FP_PREEMPTIBLE showing up in the future.

Even if someone wants to add TC_FP_KINDA_PREEMPTIBLE = 3 and
TC_FP_PREEMPTIBLE_WITH_STRIPES = 4 in the future, I'm still not sure how
a MAX definition exported by the kernel is going to help them?

I mean, about the only thing that it would avoid is that I wouldn't be
changing the policy definition, but that's rather minor and doesn't
justify exporting something to UAPI? The changed MAX value is only a
property of the kernel headers that the application is compiled with -
it doesn't give the capability of the running kernel.

To see whether TC_FP_PREEMPTIBLE_WITH_STRIPES is supported, the
application would have to try it and see if it fails. Which is also the
case right now with TC_FP_PREEMPTIBLE.

> > > Lead up question: if the max is 16 then can preemptible_tcs for example be u32?
> >
> > I don't understand this question, sorry. preemptible_tcs is declared as
> > "unsigned long", which IIUC is at least 32-bit.
> 
> I meant: if you only had 16 possible values, meaning 16 bits are
> sufficient, (although i may be misunderstanding the goal of those
> bits) why not be explicit and use the proper type/size?

If you think it's valuable to change the type of preemptible_tcs from
unsigned long to u16 and that's a more "proper" type, I can do so.
