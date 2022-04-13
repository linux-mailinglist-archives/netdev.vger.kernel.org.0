Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F154FF1A3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiDMIU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDMIUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:20:52 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C512A4EA02;
        Wed, 13 Apr 2022 01:18:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t25so1404385edt.9;
        Wed, 13 Apr 2022 01:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NM1pfbSgTEQ9uckWSvNkdocJAYN18ejH2fT6Ofk0eeU=;
        b=ZO7+1DjFeRVhMTsgznRttF4gB2w6B0IYKtFlA4KFq1h3iyBj5QYxSIJne7Yh506ZqM
         swB8QzLiPoWAF3LMh/l3KgD4/mNV4sn59GaBuq53ifDYJ6XuI8eoXMS+5IhfE3NKTDB/
         I4zsbZ5y//peeXAXtyPrmwrTYKsLaEVebBGl+MJmM70/yZUB/e0WGb3YVaxtS0h1vOUV
         7z+2mxqxR0TqdfF1n8LGT7V81mhY2K9kNXpsvuTebVelCQRK3PT0oTHKyMEwiPUGb15s
         FN7kEnSW2tGnQUNQWa/CAboo8LsqaQvW3AqfeP4IN1PEMq1kjLOJjqSJx/cXQ7Gfo5pP
         dacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=NM1pfbSgTEQ9uckWSvNkdocJAYN18ejH2fT6Ofk0eeU=;
        b=4oYCjJbieANqcKitPvuDQtwmKylNPYDxfJWaWL55dau8F21zzBqQy7lmw+kPV6ygSB
         O5+a120Fa8tiSHGOTNy/JjYSWXrPSmHKk5L2chR0pvO/UYB1T/XE1U6k4VKeYR5Dvhi2
         vkUtKf7PnSqzWbHfiM3/kP4uSqts/Uhh+cSF7s7EHHzYSpyQK3l3lYv0+9GIltTJwS3U
         EYSP9JjDzdYQRudRu5DU1/anLsEup1pM7cSov3x9Ercp4UMQLnYmeMFUpzNViST4ZQXG
         PCadDI+7Fp5jug5EwgPetj3vbGIdtrEFqVgtnxxCz8FcmvYsprehwnmNipDOa6Vr5SvJ
         fXiA==
X-Gm-Message-State: AOAM5338BfN21HvhjmqbZeQm/3EgPsoGAlUYtEbbIy+dOOSN9wTvavIf
        TiXS5c+9Pp9ZoASGhpMkBu0=
X-Google-Smtp-Source: ABdhPJz1zFDl7IwBBpiJdJJrHQx/gNJ9eFMxB5nFGFZzuNCuKc3atEKIDRvXQCvDLr+YN63LNf2RhA==
X-Received: by 2002:a05:6402:51c6:b0:419:8269:f33d with SMTP id r6-20020a05640251c600b004198269f33dmr41758137edd.264.1649837910214;
        Wed, 13 Apr 2022 01:18:30 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id u4-20020a170906780400b006ce69ff6050sm13728111ejm.69.2022.04.13.01.18.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:18:29 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next v3 14/18] sfc: Remove usage of list iterator for
 list_add() after the loop body
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220412142905.54489567@kernel.org>
Date:   Wed, 13 Apr 2022 10:18:28 +0200
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        bpf@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Content-Transfer-Encoding: 7bit
Message-Id: <132EC4A3-4397-4124-B736-0C3057B63B26@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
 <20220412121557.3553555-15-jakobkoschel@gmail.com>
 <20220412142905.54489567@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 12. Apr 2022, at 23:29, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Tue, 12 Apr 2022 14:15:53 +0200 Jakob Koschel wrote:
>> -	struct list_head *head = &efx->rss_context.list;
>> +	struct list_head *head = *pos = &efx->rss_context.list;
> 
> ENOTBUILT, please wait with the reposting. Since you posted two
> versions today I guess that's 2x 24h? :)

oh gosh, seems like I indeed forgot to build this commit.
Sorry about all the mess :( Also I'll wait with reposting (not
going to make the same mistake twice ;)).

I messed up three times yesterday, was really not on a high.
I'll be more careful in the future to not the the same kind of
mistakes again :/
