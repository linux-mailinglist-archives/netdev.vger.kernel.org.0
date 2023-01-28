Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E49567F82F
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjA1NlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbjA1NlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:41:13 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2DD3A85B
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:41:12 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i1so3415262ilu.8
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6PbDeDYHnjXcUjgX9rt+sjAxD+mcicVqmyBP0qmlde0=;
        b=hVGEk1AlhSc6mB8mZ/PYjNgb4C1k+JxtXuP1df7Nh98bTxFLvlsm3eCyfH51oZ/lin
         8ELdcQE0GZybnowRiEuWJCWecSPv87eED5RttPYV9F9C7gaoqOpIn85FDry5PXW56qlb
         Kg8MhXfYgUviDPDckzMcDHZ5mdKPcz9zHXUZ4+kOz8KHm0FEVpM3poPzWSH8oSwgH8rw
         0ge+uRXRGEId2e7FD5irZ78vtiGIgsHSaO6+GGt5eLMtIbgMBkA9/UyRsxAy3TwncK/G
         x5RQcQboZWsDmjaoi0H8xc3My/IcPU81HXTxfBWj+VmCTnI/3hgCryE1XDP1de6DFMGs
         x+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6PbDeDYHnjXcUjgX9rt+sjAxD+mcicVqmyBP0qmlde0=;
        b=OaPCimVp/ZwKy1a8oJ974hJ1W6htO0BEDyd2W+A2tVPivfSs0Tu75v+Yc/vhfRbqpr
         sCOadQrmgZX8sCEHr/922/g3/v5MjE07KswqyPWZ/B8uKo3Xu+NbRxBZCbyZL3H9HHCR
         p3ln288JJbTa4WGQEFORN5eJMnLKrBQ9zQaCvWvCFdAhW+MeYZFPZS3bEfq8divWyb9m
         lSZn8XupN+LCrhQG7LGz6V3z1bTrLrzyNTve9uHsBS1fskjvYw0tgqjG0E5UEY2Jf12M
         gimaVAeZXF/3k0SNTTT9b0M50qsl2G1BBrTgrsUT/7ZvGZ+H/ZtFoFF0KtdU1orAQZX9
         kwqw==
X-Gm-Message-State: AO0yUKXy9ZO32hYpUMzjCuGzyDZB7rf3KEmxe7wirVNLduzNX1MgqaEg
        O82VngzfDBkEGclQjLMOkojDLhlTJH4PgeCDfbi6jg==
X-Google-Smtp-Source: AK7set+ztGHBVSEx/p4yd6Foyd7M3NkE/O7hpVuNydG+WHBiunf+XPQ7hpEV2fXq+wLOnNOauf723o/1HBSwWrsYb7E=
X-Received: by 2002:a92:9510:0:b0:310:ab98:81f2 with SMTP id
 y16-20020a929510000000b00310ab9881f2mr1569495ilh.80.1674913271928; Sat, 28
 Jan 2023 05:41:11 -0800 (PST)
MIME-Version: 1.0
References: <20230124170346.316866-1-jhs@mojatatu.com> <20230126153022.23bea5f2@kernel.org>
 <Y9QXWSaAxl7Is0yz@nanopsycho> <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
In-Reply-To: <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
From:   Jamal Hadi Salim <hadi@mojatatu.com>
Date:   Sat, 28 Jan 2023 08:41:01 -0500
Message-ID: <CAAFAkD-Uq5Zt5YgP2SwC8_vyBdJgP+_9Y_h=g+bPzxbHRSW5zw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 7:48 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jan 27, 2023 at 3:27 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 5:26 PM <sdf@google.com> wrote:
> > >
> > > On 01/27, Jamal Hadi Salim wrote:
> > > > On Fri, Jan 27, 2023 at 1:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > > > >
> > > > > Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
> > > > > >On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:

[..]
> > > Not to derail too much, but maybe you can clarify the following for me:
> > > In my (in)experience, P4 is usually constrained by the vendor
> > > specific extensions. So how real is that goal where we can have a generic
> > > P4@TC with an option to offload? In my view, the reality (at least
> > > currently) is that there are NIC-specific P4 programs which won't have
> > > a chance of running generically at TC (unless we implement those vendor
> > > extensions).
> >
> > We are going to implement all the PSA/PNA externs. Most of these
> > programs tend to
> > be set or ALU operations on headers or metadata which we can handle.
> > Do you have
> > any examples of NIC-vendor-specific features that cant be generalized?
>
> I don't think I can share more without giving away something that I
> shouldn't give away :-)

Fair enough.

> But IIUC, and I might be missing something, it's totally within the
> standard for vendors to differentiate and provide non-standard
> 'extern' extensions.
> I'm mostly wondering what are your thoughts on this. If I have a p4
> program depending on one of these externs, we can't sw-emulate it
> unless we also implement the extension. Are we gonna ask NICs that
> have those custom extensions to provide a SW implementation as well?
> Or are we going to prohibit vendors to differentiate that way?
>

It will dilute the value to prohibit any extern.
What you referred to as "differentiation" is most of the time just
implementation
differences i.e someone may use a TCAM vs SRAM or some specific hw
to implement crypto foobar; however, the "signature" of the extern is
no different
in its abstraction than an action. IOW, an Input X would produce an output Y in
an extern regardless of the black box implementation.
I understand the cases where some vendor may have some ASIC features that
noone else cares about and that said functions can be exposed as externs.
We really dont want these to be part of kernel proper.

In our templating above would mean using the command abstraction to
create the extern.

There are three threads:
1) PSA/PNA externs like crc, checksums, hash etc. Those are part of P4TC as
template commands. They are defined in the generic spec, they are not
vendor specific
and for almost all cases there's already kernel code that implements their
features. So we will make them accessible to P4 programs.
Vendor specific - we dont want them to be part of P4TC and we provide two
ways to address them.
2) We can emulate them without offering the equivalent functionality just so
someone can load a P4 program. This will work with P4TC as is today
but it means for that extern you dont have functional equivalence to hardware.
3) Commands, to be specific for externs can be written as kernel modules.
It's not my favorite option since we want everything to be scriptable but it
is an option available.

cheers,
jamal




> > > And regarding custom parser, someone has to ask that 'what about bpf
> > > question': let's say we have a P4 frontend at TC, can we use bpfilter-like
> > > usermode helper to transparently compile it to bpf (for SW path) instead
> > > inventing yet another packet parser? Wrestling with the verifier won't be
> > > easy here, but I trust it more than this new kParser.
> > >
> >
> > We dont compile anything, the parser (and rest of infra) is scriptable.
>
> As I've replied to Tom, that seems like a technicality. BPF programs
> can also be scriptable with some maps/tables. Or it can be made to
> look like "scriptable" by recompiling it on every configuration change
> and updating it on the fly. Or am I missing something?
>
> Can we have a P4TC frontend and whenever configuration is updated, we
> upcall into userspace to compile this whatever p4 representation into
> whatever bpf bytecode that we then run. No new/custom/scriptable
> parsers needed.
>
> > cheers,
> > jamal
