Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB65C50046E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 04:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiDNCvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 22:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbiDNCvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 22:51:21 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1672E25C7A;
        Wed, 13 Apr 2022 19:48:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso5075897pjj.1;
        Wed, 13 Apr 2022 19:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ExK3KYmT63mlzsc1H5mAMuoECkC1IzjYUfQd1hV1KJY=;
        b=ddqa2/lU8t9nzNvpVJ+NPkMneyeSDQvHKelcBVeG5dVeiN3x7Ow7J56LSfAkEMZpPS
         c08/IEpZY8KR+yHUMb+JRrcTWWCAa7dN/s3JJ2bpyzEXxOXDq/4CU3p19AYkkksGTff/
         ONa/WE7MxuVsJZwTBDe4Eo6S6mvrIYX6LnYZeapcia+9z3nGECJpKy9Z1vYhjgWZJOX+
         CMJVCpqx5Pm4qPZz1E4ykoyHAL7+Fb/xtE3u3/iVjF+7ba2qcSqkcgspVIEN5k9DqYeV
         Ao7rkM3/pe1DHxP4qgoIjjtX6ga6QLVLpFMMbh5hhJ8gXXAnO4+ZuniGpA+tCDhlmimE
         6klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ExK3KYmT63mlzsc1H5mAMuoECkC1IzjYUfQd1hV1KJY=;
        b=jd/ZPlSDcA0LJHBphYwUr4rO+dwsHm08FnkKc+rF6+z37dLuwVo6CgpLo8iBodkaB3
         vyflUydDll60zyTOkpcu+UGwFFfV2Vbj955vozwCkO4mXiHrhJ8oGO2F5pO6M9wYbF3P
         PCR6WeLfi3E+2VbD1lq3jBkKS/2feipLKmNXqopSr4AoOBOd1yhpOSnd/UBkke5mlTi/
         HO4Bb21AlSNxrl04ONAUzCpPzlba8vmPnFyri7kR9ns2gCW2v5BmH9S5pskZ8vK5VB2X
         DAvyx9sywsVSpj7NHMCxfr8UX+C3xT+kHq3PoNahUUEwcvMKEHfUZjHzHhJzxZk8UHXO
         QQNQ==
X-Gm-Message-State: AOAM533rKOc90GvAucJOLTaDocbcJ1xaiWIgZOFmgPmzdFrVWdJe/oPl
        MIpwPS5TAO05iTzV044JJhM+cr0AhY6bmGSAcKc=
X-Google-Smtp-Source: ABdhPJz9OW8LG+JtA8NCoRmBqiptAndWiqocqOh224rOmkHGPp88HjkdcPFcwCTj1IzA93W8Ic1P6jNgZVx/MCmr8cg=
X-Received: by 2002:a17:902:d2d0:b0:158:761e:c165 with SMTP id
 n16-20020a170902d2d000b00158761ec165mr14903971plc.59.1649904537551; Wed, 13
 Apr 2022 19:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220411230305.28951-1-luizluca@gmail.com> <20220413200841.4nmnv2qgapqhfnx3@skbuf>
 <Ylc3ca1k1IZUhFxZ@lunn.ch> <20220413205350.3jhtm7u6cusc7kh3@skbuf>
 <Ylc5RhzehbIuLswA@lunn.ch> <20220413210026.pe4jpq7jjefcuypo@skbuf>
In-Reply-To: <20220413210026.pe4jpq7jjefcuypo@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 13 Apr 2022 23:48:46 -0300
Message-ID: <CAJq09z7h_M9u=7jC3i3xEXCt+8wjkV9PfD4iVdje_jZ=9NZNKA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum offload
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Kurt Kanzenbach <kurt@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok, I'll go with "no checksum offload for its trailer tag, and bugs
> never fixed because no one uses it", in any case no Sasquatch. Thanks.

Vladimir, so the DSA switch will not copy the offload flags when a tag
requests tail room? At least it will work.

Now, if the offload HW does support that tag, what would be the
options? Set the slave port checksum flag from userland?
It would be nice to have some type of "magic trick" to have it enabled
by default. I'm already expecting a no, but wouldn't it be a nice case
for a DSA property in the device tree?

Regards,

Luiz
