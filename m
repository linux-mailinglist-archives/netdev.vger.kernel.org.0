Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F65686DAC
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjBASJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjBASJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:09:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073FE1CF44
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675274926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZcu7jPRLCjD8C9ehATgpKBBLoMpj15uHcKH/hMdLRg=;
        b=T/iPNyDKSG5xN9JPv1v+/7V6lv/BcfJEKFYazB3PLrgIiANYmoWY2ESjmfmWyHQnxO4cgd
        F9Bj+aLDHkNN+0ynOYwLqqKdn4yuGCjWgZaNx1eW+eEtJ5dMD6qIibg1bUCC/EWxp3GAwk
        iElWN+ViENknxKO+VDkj5SNA1lj5n7c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-8H0WyjBdP7-aJeq7xxMMLQ-1; Wed, 01 Feb 2023 13:08:44 -0500
X-MC-Unique: 8H0WyjBdP7-aJeq7xxMMLQ-1
Received: by mail-ed1-f72.google.com with SMTP id c12-20020a05640227cc00b0049e2c079aabso13272391ede.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 10:08:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZcu7jPRLCjD8C9ehATgpKBBLoMpj15uHcKH/hMdLRg=;
        b=cgAIyu4tZNg1tKjldAdOJqaoRkwRw2MZlARF1Owgrpt/GUFMZa8t242YI6wCpN1d2m
         cGtULvzhQaChFSHmmR9hFxNE1jOMkpQHdRkumTiHtCH7gOUqs5krNiTuOdj5/Vl/fQJq
         EMCI/dpxCuArjlGw9xf6saOZ05fsYpVj0OLpoBdUCs9yraRpmMKDzbfZ6OO4iY9Hrr5Z
         SEflLkVyKD5erwCcM9JyEMfOvh9nTqrnHLCUukYMA2mT5OAe6bRt5jLruap4Kb6bADKO
         z3jNDbGArIqUNaHASLL9MKlIB3Nvx9S5kczaHaM1NjeDRQ06VKn/WezU2e8jxWAcmaiq
         Sdcw==
X-Gm-Message-State: AO0yUKWT/NHUmbHBrZzRQ5dOWl7VvPBzV7Z6e0d1/S0GCTXT5Z56VIJ+
        ZuDXSjHNAmJPvS2mj+ZNLOwgKaAcx/qhSAlwd/43ZzKZFORNmqPvx+cj9acreBvfDVaie556dkL
        iiQP8fDCy13lJx98M
X-Received: by 2002:a17:907:72c1:b0:871:178d:fc1e with SMTP id du1-20020a17090772c100b00871178dfc1emr3572980ejc.77.1675274922474;
        Wed, 01 Feb 2023 10:08:42 -0800 (PST)
X-Google-Smtp-Source: AK7set/1VqarRLya+zDojPNXMXA2XOOASsPmmwrebLY79urPPXl+NTwAJKXqFCrZba7xfZDImLs+vA==
X-Received: by 2002:a17:907:72c1:b0:871:178d:fc1e with SMTP id du1-20020a17090772c100b00871178dfc1emr3572913ejc.77.1675274921717;
        Wed, 01 Feb 2023 10:08:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b2-20020a170906490200b0084d1b34973dsm10375424ejq.61.2023.02.01.10.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:08:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 01B0B972A00; Wed,  1 Feb 2023 19:08:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
In-Reply-To: <CAM0EoM=qeA1zO-FZNjppzc9V7i3dScCT5rFXbqL=ERcnCuZxfA@mail.gmail.com>
References: <Y9eYNsklxkm8CkyP@nanopsycho> <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <87h6w6vqyd.fsf@toke.dk> <Y9kn6bh8z11xWsDh@nanopsycho>
 <87357qvdso.fsf@toke.dk>
 <CAM0EoMmx9U5TN6+Lb4sKPhR2PLN_vptVQMBzc0EtoSa6W-hsZA@mail.gmail.com>
 <87o7qe2u4c.fsf@toke.dk>
 <CAM0EoM=qeA1zO-FZNjppzc9V7i3dScCT5rFXbqL=ERcnCuZxfA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 01 Feb 2023 19:08:39 +0100
Message-ID: <87r0v91cns.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> On Tue, Jan 31, 2023 at 5:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>>
>> > So while going through this thought process, things to consider:
>> > 1) The autonomy of the tc infra, essentially the skip_sw/hw  controls
>> > and their packet driven iteration. Perhaps (the patch i pointed to
>> > from Paul Blakey) where part of the action graph runs in sw.
>>
>> Yeah, I agree that mixed-mode operation is an important consideration,
>> and presumably attaching metadata directly to a packet on the hardware
>> side, and accessing that in sw, is in scope as well? We seem to have
>> landed on exposing that sort of thing via kfuncs in XDP, so expanding on
>> that seems reasonable at a first glance.
>
> There is  built-in metadata chain id/prio/protocol (stored in cls
> common struct) passed when the policy is installed. The hardware may
> be able to handle received (probably packet encapsulated, but i
> believe that is vendor specific) metadata and transform it into the
> appropriate continuation point. Maybe a simpler example is to look at
> the patch from Paul (since that is the most recent change, so it is
> sticking in my brain); if you can follow the example,  you'll see
> there's some state that is transferred for the action with a cookie
> from/to the driver.

Right, that roughly fits my understanding. Just adding a kfunc to fetch
that cookie would be the obvious way to expose it to BPF.

>> > 2) The dynamicity of being able to trigger table offloads and/or
>> > kernel table updates which are packet driven (consider scenario where
>> > they have iterated the hardware and ingressed into the kernel).
>>
>> That could be done by either interface, though: the kernel can propagate
>> a bpf_map_update() from a BPF program to the hardware version of the
>> table as well. I suspect a map-based API at least on the BPF side would
>> be more natural, but I don't really have a strong opinion on this :)
>
> Should have mentioned this earlier as requirement:
> Speed of update is _extremely_ important, i.e how fast you can update
> could make or break things; see talk from Marcelo/Vlad[1]. My gut
> feeling is dealing with feedback from some vendor firmware/driver
> interface that the entry is really offloaded may cause challenges for
> ebpf by stalling the program. We have seen upto several ms delays on
> occasions.

Right, understandable. That seems kinda orthogonal to which API is used
to expose this data, though? In the end it's all just kernel code, and,
well, if updating things in an offloaded map/table is taking too long,
we'll have to either fix the underlying code to make it faster, or the
application will have keep things only in software? :)

-Toke

