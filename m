Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9168D568
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjBGL2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjBGL2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:28:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166504ED2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 03:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675769254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjK2kZBOicICFKKeKjHG/kRG3ABMzmNQEsUkC1U+ZhY=;
        b=DjBeICxUnEM9ovj58ec2cv8OTX/LcLqt7DTvXwxfTfDAf/brm76IkvoTofnPp/KILwuGKZ
        30m46xfiQ6T/Z2qi6b0QRzTAcLRlpe95riw4mG/FPnt6dgc0G33lNlZ1P7NnK9aaiYXejI
        GH0rbH2fbC+zYezMRsm5ZMc0lNw2u80=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-PpipOIGLMpStS--qJRvBQA-1; Tue, 07 Feb 2023 06:27:30 -0500
X-MC-Unique: PpipOIGLMpStS--qJRvBQA-1
Received: by mail-qv1-f70.google.com with SMTP id e5-20020a056214110500b0053547681552so7407926qvs.8
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 03:27:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NjK2kZBOicICFKKeKjHG/kRG3ABMzmNQEsUkC1U+ZhY=;
        b=Aw2G7+LSckT3s3VbBnczt1x1eB59NKa69W+TlqoiiAe2/1l8ode2nEofu2qIsZU6bp
         66t2/6FoUpkmtqSs/ihLFoJ/uDWRuFj3mQU+F/0I9A3CsUO2tGskurm2uxhjQx5y2Ro/
         F6y+3ue8bmwzpkwsDQfOhg8ehXV0bnHx1cYPa9OOFglONx81kUoRSrlSLSe83wCpxidz
         bUllAshUz/WIcM2LHbb8HoF/EIOoWWf48ZLDlQprKY0wQ1MjWgLWpK5nwehC6AyQAuw3
         u0Yx6kliU9TRcymGtAOa1osk+kq+rtPpVA8Q/bA6dSDxr4hWCvizEjAlNMlEECWR64dg
         q3yw==
X-Gm-Message-State: AO0yUKU6Anf3+iGMCBjBDRqy2wM8ShhbAk2UaJcCIbyTTxe7D+ChDRAH
        ueHzV1kiTsa60+RebVCS4DQRRYv76lMeW43S44Vp1FJKxyAwkWnSLHcMg+Nye+P2dyFknJpD+h+
        v+8shazebP87UJeiQ
X-Received: by 2002:a0c:f587:0:b0:538:a431:8630 with SMTP id k7-20020a0cf587000000b00538a4318630mr3558222qvm.1.1675769249871;
        Tue, 07 Feb 2023 03:27:29 -0800 (PST)
X-Google-Smtp-Source: AK7set/UomiMZJq0DCZT+ohWr7e/c9M7OAp5dyxgo1bvtA3OuUL0OCSJ2+9BVBbxQJwAvBRDKfrIVg==
X-Received: by 2002:a0c:f587:0:b0:538:a431:8630 with SMTP id k7-20020a0cf587000000b00538a4318630mr3558188qvm.1.1675769249547;
        Tue, 07 Feb 2023 03:27:29 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id br34-20020a05620a462200b0071d7ade87afsm9482828qkb.67.2023.02.07.03.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 03:27:28 -0800 (PST)
Message-ID: <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonas Suhr Christensen <jsc@umbraculum.org>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Feb 2023 12:27:25 +0100
In-Reply-To: <20230205201130.11303-2-jsc@umbraculum.org>
References: <20230205201130.11303-1-jsc@umbraculum.org>
         <20230205201130.11303-2-jsc@umbraculum.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 2023-02-05 at 21:11 +0100, Jonas Suhr Christensen wrote:
> Add missing conversion of address when unmapping dma region causing
> unmapping to silently fail. At some point resulting in buffer
> overrun eg. when releasing device.
>=20
> Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian platfo=
rms")
>=20
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>

I'm sorry for nit-picking, but you must avoid empty lines in the tag
area. Please post a v2 avoiding the empty line between the Fixes and
sob tags (both here and in the next patch).

You can retain (include in the tag area) the already collected
reviewed-by/acked-by tags.

Thanks,

Paolo

