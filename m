Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBD465D2AC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbjADM3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbjADM3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:29:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F621A22F
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672835341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D83ggwJK4ngkFfN/2WNdiEe8asazEJXPWDhn2wflgWs=;
        b=Tn+Pea4WtSYxCpTwYtgysdPwDVBK0BZViHVpk/Ar6PJVGpx3494WR/RLl4idoWBnJ38yLZ
        RUUfUq7308iTQBKRbbU70yvRys5DkeflKMZKtjSWdaBBvuSDciPHT0mDc9gfrPbMXeRhFr
        zmZexxpXbncip0dBzcP1s9S4BOFsrAM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-393-MyBLeOjWNaC8POIkVeeJKQ-1; Wed, 04 Jan 2023 07:29:00 -0500
X-MC-Unique: MyBLeOjWNaC8POIkVeeJKQ-1
Received: by mail-ed1-f70.google.com with SMTP id s13-20020a056402520d00b0046c78433b54so21603538edd.16
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 04:29:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D83ggwJK4ngkFfN/2WNdiEe8asazEJXPWDhn2wflgWs=;
        b=nJ1fpY0dTyx6a5T/YChNHCvMw1+y7rBu6m+IoqaKxMNEJr9ThoemLtsRKSNbDuh37v
         qxrv8Hs9j+IxXW8VnaqaX6SUvSil8AQzOhfm5q8RpOoVRl7jbZVGRjEQ8+TCSZjU8Xuc
         TWEBKFpUbHpfsC9SJBpciytHRINTCIjKN6oXhdTV8enr/thoUD4Y2l4JIyvBDtBpz/Dn
         FskTbhdDQquvr1gxwEKNaQ+Xpdsu5g0H2Pvvx/XGvkg/c8OZ4xG/niGzNL7WQ2UH6Jbc
         EJSL7PDSKzjXuK9bHzismW0tCxbINQUUdhCKxoey2tsncJvL3uMlLeiJpGV8W/EsPTsE
         jNNA==
X-Gm-Message-State: AFqh2koNqc6rejQ8aEcMWqKdUjIwoboM6sBRtNcMU/Vu69XzJGjIR8cX
        1+G3A0bii+MZUEtPjRjqCR9tFsnvUfMwo7FcGMI8yP8TQIvj1cFPdOi4CH320PHBmxcsD+luH3i
        GgFbKWgxoLPzs93mj
X-Received: by 2002:aa7:c659:0:b0:48c:7e42:844c with SMTP id z25-20020aa7c659000000b0048c7e42844cmr11649465edr.10.1672835339058;
        Wed, 04 Jan 2023 04:28:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv3D10jrlC5WnU/hlTFXGNbMH9aBiPcxBGaYmUhTGAyAXaetE2FdzSJ7TbI2gYyDdewD6T+ng==
X-Received: by 2002:aa7:c659:0:b0:48c:7e42:844c with SMTP id z25-20020aa7c659000000b0048c7e42844cmr11649443edr.10.1672835338765;
        Wed, 04 Jan 2023 04:28:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s22-20020aa7cb16000000b00457b5ba968csm14644608edt.27.2023.01.04.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 04:28:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A4388A2934; Wed,  4 Jan 2023 13:28:57 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
In-Reply-To: <Y7U8aAhdE3TuhtxH@lore-desk>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y7U8aAhdE3TuhtxH@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 04 Jan 2023 13:28:57 +0100
Message-ID: <87bkne32ly.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> > Hmm, good question! I don't think we've ever explicitly documented any
>> > assumptions one way or the other. My own mental model has certainly
>> > always assumed the first frag would continue to be the same size as in
>> > non-multi-buf packets.
>>=20
>> Interesting! :) My mental model was closer to GRO by frags=20
>> so the linear part would have no data, just headers.
>
> That is assumption as well.

Right, okay, so how many headers? Only Ethernet, or all the way up to
L4 (TCP/UDP)?

I do seem to recall a discussion around the header/data split for TCP
specifically, but I think I mentally put that down as "something people
may way to do at some point in the future", which is why it hasn't made
it into my own mental model (yet?) :)

-Toke

