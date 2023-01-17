Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC70B66D94C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbjAQJG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbjAQJGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:06:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEA710436
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 01:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673946061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F1fcEh/FdJjyaY5CQPPGO813hLrAQ1OYFYBLAYHZZX0=;
        b=OUvAfGA2KctrBap/Nighy8DeGiSQgngqmoCgb880xTTNmaY7QrwLgXrelor3ZD8oVg/kGw
        +nXkUT4BmGkPr7ym/3uydWdkJHXfk+V+pki/sDub+4Hqid7NcDkTECTsitSi+MrGBka2bD
        AAAM66xyS2WFAjqbOV2s9lAeKviC1HM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-192-ZybUSqy1OnqONb0fziR6Lw-1; Tue, 17 Jan 2023 04:01:00 -0500
X-MC-Unique: ZybUSqy1OnqONb0fziR6Lw-1
Received: by mail-qv1-f69.google.com with SMTP id o95-20020a0c9068000000b005320eb4e959so15734724qvo.16
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 01:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1fcEh/FdJjyaY5CQPPGO813hLrAQ1OYFYBLAYHZZX0=;
        b=zmsdJqAmgRfyqW8CcafNAxg+282/FBbjJa6wSrmsZRFHlU4Dmiwuk0gCa3vH33Zdfk
         BGTcwPIWQWZUab54JkiBW6JpPTy0GbP4MhzxwLqkIdnCOKNdfrg37ne6BAfUheRO80FM
         o4qdsCYBk8CezjK5+c1HB1EuwWZasv/bOSONtqihNbWUx/x2wnrYgRlidc1bQRX+pV0g
         y5vXohp17C4eMG0mNMyUGJOf+YTWQAzhE/ObT/8H3YVensDJV/VTncd+NG0AthSl4mlr
         VuPJoIYgnzg5pdnvjl/N6gllgHJq6gCa8ItVpL5fFwta3QhbsbMeCRCWUrPtCJgQLfmb
         xfNw==
X-Gm-Message-State: AFqh2krB/R4Q2Gvxi92WS1zvOzneA6jJ4tRH8pzZf3r9xxrq6dGiTdYL
        dja/HOwzhp5wABSvgg/gpYslBoVYaWm6KLI9HbM+XVCHygLFW7Sg9Yoxsi3PawNTBBXxFseTcXl
        eCSSXvRiXiobvILtA
X-Received: by 2002:ac8:6690:0:b0:3a7:efe3:47c8 with SMTP id d16-20020ac86690000000b003a7efe347c8mr2826527qtp.6.1673946059579;
        Tue, 17 Jan 2023 01:00:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtZ0LkbP5JOOtFVy++5zkP4Pcpbpai/pXdY1PYZRzeRTHF00kvnsZ1i9t/cdyURtpt2brZyww==
X-Received: by 2002:ac8:6690:0:b0:3a7:efe3:47c8 with SMTP id d16-20020ac86690000000b003a7efe347c8mr2826507qtp.6.1673946059332;
        Tue, 17 Jan 2023 01:00:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id az42-20020a05620a172a00b006fae7e6204bsm16966628qkb.108.2023.01.17.01.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:00:58 -0800 (PST)
Message-ID: <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding
 offloads to stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us, john.hurley@netronome.com
Date:   Tue, 17 Jan 2023 10:00:56 +0100
In-Reply-To: <Y8Ni7XYRj5/feifn@pop-os.localdomain>
References: <20230113044137.1383067-1-kuba@kernel.org>
         <Y8Ni7XYRj5/feifn@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2023-01-14 at 18:20 -0800, Cong Wang wrote:
> On Thu, Jan 12, 2023 at 08:41:37PM -0800, Jakub Kicinski wrote:
> > Naresh reports seeing a warning that gred is calling
> > u64_stats_update_begin() with preemption enabled.
> > Arnd points out it's coming from _bstats_update().
>=20
>=20
> The stack trace looks confusing to me without further decoding.
>=20
> Are you sure we use sch->qstats/bstats in __dev_queue_xmit() there
> not any netdev stats? It may be a false positive one as they may end up
> with the same lockdep class.

I'm unsure I read you comment correctly. Please note that the
referenced message includes several splats. The first one - arguably
the most relevant - points to the lack of locking in the gred control
path.

The posted patch LGTM, could you please re-phrase your doubts?

Thanks,

Paolo

