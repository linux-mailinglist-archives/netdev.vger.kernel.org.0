Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A13868205A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 01:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjAaAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 19:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjAaAGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 19:06:45 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D982693
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:06:44 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id r8so6543877pls.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 16:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIqsJLtgi1QoB5xi755afXKVgL09KTFlhyw/V69RD8k=;
        b=S8+gABX5M4lAX7eqetzDmbbHjXgMlA+sfa9/iOca0NwVF8D6sXkq0dZtAYGJgPhxc6
         tuDYj80y04WarGHCpn6XkdINzY2AZMVqfQpIoxKdlwDsj8cXzRIjmIK/KF3uIsIX+MAL
         DLUpv90MwOa+XsMwqqHSM68xnYNgwu3yDzj4N2wt6/IHSQRL/nxM4VNT7lbOcZtJZXZ4
         m2ZP3EtwI4rm8dH+tpn+G1orDR7HpTDBBa8PdBXum63HLCUCDPZU/2IOihvGt86p1MY/
         vPbr6Iyl5To2kO/9R7S7LQYuIYAz9WNPTaWgPjzRG6QvfkD3eDOtkMQAbY1sgN7DFzy3
         /Wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kIqsJLtgi1QoB5xi755afXKVgL09KTFlhyw/V69RD8k=;
        b=0gIL9WaDK82ya+PvQGW/qv2nS9lYGPINxw2RPqNgCbj7Jz9Llvkj66FtA/bwUYqmr5
         XUNp3Zaq/WPnAF+gC5zlTVKI6yDCM8QOQp6V9PjeHU3evmiFpGMwU8J/bvys9J0/UqIv
         5FjG7bpS3NPRCRLkjsMENO4Y/DfSAFtn7bB6fAqhY/S64QoXvkuofued+vAIk9olVUXk
         6IoXquQbuIWhObiB5LE1e293Plqhaqlxh6fu7Qn+8CkPf/2aLtTs5LcTF40tbF72wA/W
         ZZ7MQUraZIPDSq7DE4U7K8Ac/DmVu9Rp5n5wNz7XXdckA4D6Nr45J6R0N8RMS0jaj62y
         jcbA==
X-Gm-Message-State: AO0yUKURbtu5fVD4mCoVQ+iRn8hFKCyM+7e4DqjMg8NhsVS6Hda/iFqf
        U2d125kgm9QVWZH0KgybA64=
X-Google-Smtp-Source: AK7set/VOmtB9fy9DwqWdaX/SddKrmICTvbBmw2ecidN56jm1AXxi1/Fs6kbHns7RSoZtdRUQS7U9Q==
X-Received: by 2002:a17:903:124a:b0:192:ad82:dc98 with SMTP id u10-20020a170903124a00b00192ad82dc98mr12465992plh.34.1675123604164;
        Mon, 30 Jan 2023 16:06:44 -0800 (PST)
Received: from localhost ([98.97.45.87])
        by smtp.gmail.com with ESMTPSA id jc17-20020a17090325d100b001949b92f8a8sm5583050plb.279.2023.01.30.16.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 16:06:43 -0800 (PST)
Date:   Mon, 30 Jan 2023 16:06:41 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Singhai, Anjali" <anjali.singhai@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
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
Message-ID: <63d85b9191319_3d8642086a@john.notmuch>
In-Reply-To: <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <Y9RPsYbi2a9Q/H8h@google.com>
 <CAM0EoM=ONYkF_1CST7i_F9yDQRxSFSTO25UzWJzcRGa1efM2Sg@mail.gmail.com>
 <CAKH8qBtU-1A1iKnvTXV=5v8Dim1FBmtvL6wOqgdspSFRCwNohA@mail.gmail.com>
 <CA+FuTScHsm3Ajje=ziRBafXUQ5FHHEAv6R=LRWr1+c3QpCL_9w@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch>
 <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch>
 <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk>
 <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk>
 <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk>
 <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk>
 <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
Subject: RE: [PATCH net-next RFC 00/20] Introducing P4TC
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Singhai, Anjali wrote:
> Devlink is only for downloading the vendor specific compiler output for a P4 program and for teaching the driver about the names of runtime P4 object as to how they map onto the HW. This helps with the Initial definition of the Dataplane.
> 
> Devlink is NOT for the runtime programming of the Dataplane, that has to go through the P4TC block for anybody to deploy a programmable dataplane between the HW and the SW and have some flows that are in HW and some in SW or some processing HW and some in SW. ndo_setup_tc framework and support in the drivers will give us the hooks to program the HW match-action entries. 
> Please explain through ebpf model how do I program the HW at runtime? 
> 
> Thanks
> Anjali
> 

Didn't see this as it was top posted but, the answer is you don't program
hardware the ebpf when your underlying target is a MAT.

Use devlink for the runtime programming as well, its there to program
hardware. This "Devlink is NOT for the runtime programming" is
just an artificate of the design here which I disagree with and it feels
like many other folks also disagree.

Also if you have some flows going to SW you want to use the most
performant option you have which would be XDP-BPF at the moment in a
standard linux box or maybe af-xdp. So in these cases you should look
to divide your P4 pipeline between XDP and HW. Sure you can say
performance doesn't matter for my use case, but surely it does for
some things and anyways you have the performant thing already built
so just use it.

Thanks,
John
