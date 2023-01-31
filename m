Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAF4968395F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjAaWdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjAaWdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:33:12 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705AC234C3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:33:05 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 129so20128010ybb.0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wt2GACZNz2/zwkt1099fGMajiBK+4ftfZrXVg8BMLeY=;
        b=ckWvdSmJRenx4kalfKNBHz5vRkJRRz38YBw6YX1ZjyPriaTvjQvoQFL0qkm/r337PB
         ouEqYr1S4wLrp8yUUjAD6peiBMVcKGllExbjlqDDn3ZRuhLPmsocgN7fMVYTnm+o1hoq
         tD6rh2bc+3/N5gRt3SV3uvF6WoJkZy4DSR8AtOSjC038CD1Z68v5RxWIDraR+1KBjiyT
         P34yKqNLDaFz+/cL7uSEe+EunT1E4GoeO1rMPABlJ3kkgQLTHmuSJPNARDU4ak/91C6/
         FqZrThG54EKvYekT9bMuesjMjXTCRVV3XeToZRAu9hKWo5EU/EFzzzpePTldFpzehREc
         NwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wt2GACZNz2/zwkt1099fGMajiBK+4ftfZrXVg8BMLeY=;
        b=qE76PD2ApxGIc/EeR5oqbbI+35hC41REdDfYN5hEKsLjxYXqp8jXeCAlpUMUafUFYQ
         wdQXmOZhBWQ1OsUnXtMtOZQ49f7dK/Wmv6uFJcTkC9IU+/xP9FaMtQQatYbiR1DG+4ne
         G3/LI9XVOAGw8FfYSFvsvfKYWl8RWhNER/AYSd9mAVeD0/6Ghye/djfy4PBUhe//vQeO
         MJ4pZhzdbFaQuXLCxYUeLhR2sNfFLQ3tOPSlbtwv8ZUwbA7l56gKB1g27Y7QD+frJxWg
         Z979XKcECvixUMGsQTN01T2CevDaJ6+hK+Csw2efPxn1bmS0w1wRGFsl5/zGpDIwVsek
         1Y/g==
X-Gm-Message-State: AO0yUKUZZsKbpCbxN2MWgDTyOYO4Ej5nUR6Z/mf+3IHBrR9j31R9kMDd
        HlkLLnlZQmYs6xZE1oqzdmw8WvkI2dKCoqXTXEUdwQ==
X-Google-Smtp-Source: AK7set98nTenfnOJsFDPIRzXYAGicB3he44WrDA3Aq6Ww/0w896PqDMLjd4GC1XIGqsDtAFFqvt4l3Cn6J+wFySbyUU=
X-Received: by 2002:a25:d106:0:b0:7e3:5539:9cb5 with SMTP id
 i6-20020a25d106000000b007e355399cb5mr93220ybg.188.1675204384366; Tue, 31 Jan
 2023 14:33:04 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
 <63d85b9191319_3d8642086a@john.notmuch> <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
 <20230130201224.435a4b5e@kernel.org> <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
 <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com> <20230131111020.2821ea17@kernel.org>
In-Reply-To: <20230131111020.2821ea17@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 17:32:52 -0500
Message-ID: <CAM0EoMnKk9=WFm7ZtPbHDRc6_J7Xw8WR3TG2_Em4ucJ6nCNJOw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 2:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 Jan 2023 05:30:10 -0500 Jamal Hadi Salim wrote:
> > > Note, there are two paths in P4TC:
> > > DDP loading via devlink is equivalent to loading the P4 binary for the hardware.
> > > That is one of the 3 (and currently most popular) driver interfaces
> > > suggested. Some of that drew
> >
> > Sorry didnt finish my thought here, wanted to say: The loading of the
> > P4 binary over devlink drew (to some people) suspicion it is going to
> > be used for loading kernel bypass.
>
> The only practical use case I heard was the IPU. Worrying about devlink
> programming being a bypass on an IPU is like rearranging chairs on the
> Titanic.

BTW, I do believe FNICs are heading in that direction as well. I didnt
quiet follow the titanic chairs analogy, can you elaborate on that
statement?

cheers,
jamal
