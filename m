Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0256820AF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjAaA0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjAaA0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:26:18 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA76312586
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:26:17 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id 123so16213398ybv.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aVLTDvHnjrme3W3SY4DGV4VMS1aHzAMSbxi5Uf8uzY=;
        b=lQf3EWFDFk5stpOISNba1yd0+Yo8x08X8+Gvr/UWfc+trU4GlHfJo3iL0EsfY7eblR
         rhYsBIV3TC17lAbXickqi5KmZvcD/G7tbr0z77ZKuyolbjFdn4Ln53oRJWcVA53mNR49
         4jHvSihQclLU5q1WIQcVb/rpK9ia/hU2urbfS6hbXyqjGmCU/DGC4f9bNanjgi8P1okC
         i6JZF0fZXQqEqzL+TSanViS500ptuJOGz9ojuxgYaVMBhIdZOi50C6IEVPDvR8lHhcJC
         K2FCKu3k0E7gHdyjCpmx6b7r3WD+UqfYeIZ65lDcrtCCGepSyosrP+8ik7Mh7abUiS+j
         Jr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3aVLTDvHnjrme3W3SY4DGV4VMS1aHzAMSbxi5Uf8uzY=;
        b=m7qTrn+GjOtmseanT4vmI75cHrtIQ8EXJKDNX8pbxrEknWcywlEZrgY8zlHXTDFSg4
         hFVPzZtGLCzPMihwVjFhwDGYLwAkLfd3yGbobauMdfQ2sopFH5A76NA18gnEK5jfMHbY
         H5tAK9KiIQnSCSVluHy5GRxXAAKj/FlGDhIRq1qgZr5MfoXhyzY/lJpSSV7U2ns83qKA
         viTE/fVtQBRa6Gc1l1QnLrxClQXHOfAlEECWT/3dlf5tpJWdGLxDoaDMhfvQdJZf2veG
         4CbTUm2IOBHKNUMdl6KZI1c0ZjjL5cHGiNFDkfF8hReE5BG3Ke1Ffu71fNCf+St0QZPg
         DyBg==
X-Gm-Message-State: AO0yUKUBIzP7JIWBSsvVtGeYQNF5BuIhLgUvJfIO7z4EPkP26oVmuGAi
        VTZegDcTyEwhw5E09mqv5JJwepJwsLrk/CEyr2tNJA==
X-Google-Smtp-Source: AK7set/osahnUGKCJHscIbrArsQ6F/TUDcntbcgzziJuES958JoH8i+uSAyg1lGoQ5zjXlPCgY8mz4vcc1UAwHsIczI=
X-Received: by 2002:a25:ab24:0:b0:80b:8fbc:7e68 with SMTP id
 u33-20020a25ab24000000b0080b8fbc7e68mr3013331ybi.517.1675124777030; Mon, 30
 Jan 2023 16:26:17 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com> <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
 <63d85b9191319_3d8642086a@john.notmuch>
In-Reply-To: <63d85b9191319_3d8642086a@john.notmuch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 30 Jan 2023 19:26:05 -0500
Message-ID: <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Singhai, Anjali" <anjali.singhai@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 7:06 PM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Singhai, Anjali wrote:
> > Devlink is only for downloading the vendor specific compiler output for=
 a P4 program and for teaching the driver about the names of runtime P4 obj=
ect as to how they map onto the HW. This helps with the Initial definition =
of the Dataplane.
> >
> > Devlink is NOT for the runtime programming of the Dataplane, that has t=
o go through the P4TC block for anybody to deploy a programmable dataplane =
between the HW and the SW and have some flows that are in HW and some in SW=
 or some processing HW and some in SW. ndo_setup_tc framework and support i=
n the drivers will give us the hooks to program the HW match-action entries=
.
> > Please explain through ebpf model how do I program the HW at runtime?
> >
> > Thanks
> > Anjali
> >
>
> Didn't see this as it was top posted but, the answer is you don't program
> hardware the ebpf when your underlying target is a MAT.
>
> Use devlink for the runtime programming as well, its there to program
> hardware. This "Devlink is NOT for the runtime programming" is
> just an artificate of the design here which I disagree with and it feels
> like many other folks also disagree.
>

We are going to need strong justification to use devlink for
programming the  binary interface to begin with - see the driver
models discussion. And let me get this clear: you are suggesting we
use it for runtime and redo all that tc ndo and associated infra?

cheers,
jamal

> Also if you have some flows going to SW you want to use the most
> performant option you have which would be XDP-BPF at the moment in a
> standard linux box or maybe af-xdp. So in these cases you should look
> to divide your P4 pipeline between XDP and HW. Sure you can say
> performance doesn't matter for my use case, but surely it does for
> some things and anyways you have the performant thing already built
> so just use it.
> Thanks,
> John
