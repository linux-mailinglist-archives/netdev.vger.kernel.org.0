Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC167EEB2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjA0Tqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbjA0TpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:45:14 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A0D8CAA1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 11:43:52 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g15so2734033ild.3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 11:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SijeQqkfCq43OlPBiGBLjxvXBx+3grE6U1Z5UEo1nkw=;
        b=d1EbQIwduMKDj2WlU1wilH9mR+umuTjYCcvYY+ydxjLiHABCT/e/2G1HreHrhOKi8L
         Eu9ImaEENKm80S5ylUpCQgABw1d2syAIR3HZgwUIQrls4YNvEBh2lQ02fHKOebLfLeTA
         gapHaL3ILGzvDOR4ivN0ETLe+aaynRBDVVi4GdmtrkbjnWNX10+D1rdpBYx+tlG/tSng
         7y8xlFt3hdReGytDbt1l/DUCQLtgA1uJ6CU8KeLWtux8FT1Gi4QCh3NeAHp5fVwvK9yH
         GoK6gaNFpdORbYlOgllNavsZnf6JYwxjcW9M4wVa4M/GXXUMJZwTalTp4aLNCK2scZCY
         fufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SijeQqkfCq43OlPBiGBLjxvXBx+3grE6U1Z5UEo1nkw=;
        b=t6R35eOLhjQn5viqeoZUiaoxDsywYQaCKEqVp5YQy1uCyPe3zGDBbx3dsLYC2eNyV3
         ntOMdRMJvMO+oby/qwLul2gyCVnHQMDot2BrWCCDB3s9J9wHRYZR0+29Pbk23XUpmXK8
         +lQr7m9bQIN1cFsdv8XBHzA+E7xKEyaCzYknHP/hJ+UjHkKhSOR/P/tCfmvjYXaIDPK2
         T7NvmLrFNjxhzPkLRVLZBHopxYJHhgzmjTILd1DQnN+Gq/wWBZ37+Nab/6ePGQkrKUew
         WhJwYx0POXp7Ho2VnbgoTzbc/UZhEnxwtd+KajbFXjk8AENDDLe+V+U+wxqShpP7JswV
         ZBag==
X-Gm-Message-State: AO0yUKXl5nwvZdpYf+/d2fiULDjOqLsS5usJwb4yqS4hd9mJgL47einv
        h/geRCovF5egzcgpwrdvAn4cZypmvtYHQNRSz79luQ==
X-Google-Smtp-Source: AK7set9HbHfOzQCLEsbU1wunc16kIe4oA4TudsWuD6i344oBnMjXw1EtAJ9IQD3cO6fuiHzzPJV0YW2gTtJ0JPje524=
X-Received: by 2002:a92:9510:0:b0:310:ab98:81f2 with SMTP id
 y16-20020a929510000000b00310ab9881f2mr1315884ilh.80.1674848579280; Fri, 27
 Jan 2023 11:42:59 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com> <20230127091815.3e066e43@kernel.org>
In-Reply-To: <20230127091815.3e066e43@kernel.org>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Fri, 27 Jan 2023 14:42:48 -0500
Message-ID: <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, vladbu@nvidia.com,
        simon.horman@corigine.com, stefanc@marvell.com, seong.kim@amd.com,
        mattyk@nvidia.com, dan.daly@intel.com,
        john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 12:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 27 Jan 2023 08:33:39 -0500 Jamal Hadi Salim wrote:
> > On Thu, Jan 26, 2023 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:

[..]
> > Network programmability involving hardware  - where at minimal the
> > specification of the datapath is in P4 and
> > often the implementation is. For samples of specification using P4
> > (that are public) see for example MS Azure:
> > https://github.com/sonic-net/DASH/tree/main/dash-pipeline
>
> That's an IPU thing?
>

Yes, DASH is xPU. But the whole Sonic/SAI thing includes switches and P4 plays
a role there.

> > If you are a vendor and want to sell a NIC in that space, the spec you
> > get is in P4.
>
> s/NIC/IPU/ ?

I do believe that one can write a P4 program to express things a
regular NIC could express
that may be harder to expose with current interfaces.

> > Your underlying hardware
> > doesnt have to be P4 native, but at minimal the abstraction (as we are
> > trying to provide with P4TC) has to be
> > able to consume the P4 specification.
>
> P4 is certainly an option, especially for specs, but I haven't seen much
> adoption myself.

The xPU market outside of hyper-scalers is emerging now. Hyperscalers
looking at xPUs
are looking at P4 as the datapath language - that sets the trend
forward to large enterprises.
That's my experience.
Some of the vendors on the Cc should be able to point to adoption.
Anjali? Matty?

> What's the benefit / use case?

Of P4 or xPUs?
Unified approach to standardize how a datapath is defined is a value for P4.
Providing a singular abstraction via the kernel (as opposed to every
vendor pitching
their API) is what the kernel brings.

> > For implementations where P4 is in use, there are many - some public
> > others not, sample space:
> > https://cloud.google.com/blog/products/gcp/google-cloud-using-p4runtime-to-build-smart-networks
>
> Hyper-scaler proprietary.

The control abstraction (P4 runtime) is certainly not proprietary.
The datapath that is targetted by the runtime is.
Hopefully we can fix that with P4TC.
The majority of the discussions i have with some of the folks who do
kernel bypass have one theme in common:
The kernel process is just too long. Trying to add one feature to
flower could take anywhere from 6 months to 3
years to finally show up in some supported distro. With P4TC we are
taking the approach of scriptability to allow
for speacilized datapaths (which P4 excels in). The google datapath
maybe proprietary while their hardware may
even(or not) be using native P4 - but the important detail is we have
_a way_ to abstract those datapaths.

> > There are NICs and switches which are P4 native in the market.
>
> Link to docs?
>

Off top of my head Intel Mount Evans, Pensando, Xilinx FPGAs, etc. The
point is to bring them together
under the linux umbrella.

> > IOW, there is beacoup $ investment in this space that makes it worth pursuing.
>
> Pursuing $ is good! But the community IMO should maximize
> a different function.

While I agree $ is not the primary motivator it is a factor, it is a
good indicator. No different than the network stack
being tweaked to do certain things that certain hyperscalers need
because they invest $.
I have no problems with a large harmonious tent.

cheers,
jamal

> > TC is the kernel offload mechanism that has gathered deployment
> > experience over many years - hence P4TC.
>
> I don't wanna argue. I thought it'd be more fair towards you if I made
> my lack of conviction known, rather than sit quiet and ignore it since
> it's just an RFC.
