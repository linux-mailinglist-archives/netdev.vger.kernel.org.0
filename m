Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02869859A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBOUd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjBOUd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:33:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9822B3B0E9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 12:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676493189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j+yp83NKSNBlISXw4aWxi4wiZRjsgVNQSE1bf21L+vA=;
        b=JsCbCvwKlOmAWwAxbE2X/RSGIMkurrZmJyNgQmGNo/uHNa/she37p8zjE6/ajnNMqZM8rb
        5/C00rYHJozG23gTLroK0UExLeNmuSG5zg3DMmfImTf3dh8GpEYuzcBZffBlbD+2pnlQVg
        5TOVH3+psBt3TNu33TkM+EAB1ebDIYo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-89KyNNfPMnWHm0oadiNA1A-1; Wed, 15 Feb 2023 15:33:05 -0500
X-MC-Unique: 89KyNNfPMnWHm0oadiNA1A-1
Received: by mail-qk1-f198.google.com with SMTP id a198-20020ae9e8cf000000b007259083a3c8so12108127qkg.7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 12:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676493185;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j+yp83NKSNBlISXw4aWxi4wiZRjsgVNQSE1bf21L+vA=;
        b=Eu0arS9bLJAbOKMStbmhmaQV4EHB1mZp8CAJkRqfRMfEQS1WK42c50GpPwUn9RIJH8
         moSH8nBW3ugpDjUgfO64aFvH+lpd5UlCnwp2lfsKf4b/kys6PlYJMwztvanYNqouXmXs
         +ti/9WrGAD28iF82XVrmOtmSbSt1wppOAyXHLI32LX0SwFw1uMZJFVoyD79aNDOMPmy9
         ATGiXPf0pkxZSy+dYsq5Zh/Op4Yec9zYq5mRsenBKXSWsqULwvIGz5eh7+kvJkdwDRqb
         plYaDS+qOEwReASu8IEpB/22M1/5ApQHHMGS/kqazm0X8ATnaDzhAdKrogG4pjkZOyew
         JxVg==
X-Gm-Message-State: AO0yUKWioih2zoe1vva3rkSUUH6wDiw+G1OzfzRFxzcKuQ9Mkoz+/bpC
        LdWCmGvINt+EQfnxv4c/Ai2EQmukwsob+O14tY2xZE36U4lHsDXWopM+6VaesC+GgU7wKhJmvaI
        M+81AKsbCoaWty+OK
X-Received: by 2002:ac8:5951:0:b0:3bb:8f8e:ab72 with SMTP id 17-20020ac85951000000b003bb8f8eab72mr5879750qtz.0.1676493185255;
        Wed, 15 Feb 2023 12:33:05 -0800 (PST)
X-Google-Smtp-Source: AK7set8qHCqrV8BXXNdry3RRw56vMXHutMZbqLv3HE2xtVFYvoPjYNmaghvSnLbpzCjFECBjuwTyxw==
X-Received: by 2002:ac8:5951:0:b0:3bb:8f8e:ab72 with SMTP id 17-20020ac85951000000b003bb8f8eab72mr5879717qtz.0.1676493184991;
        Wed, 15 Feb 2023 12:33:04 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id x66-20020a379545000000b0070d11191e91sm14761559qkd.44.2023.02.15.12.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:33:04 -0800 (PST)
Message-ID: <df8772b86a072b21500392aa45b72ac86d6983e4.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] net: default_rps_mask follow-up
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Date:   Wed, 15 Feb 2023 21:33:01 +0100
In-Reply-To: <20230215112954.7990caa5@kernel.org>
References: <cover.1676484775.git.pabeni@redhat.com>
         <20230215112954.7990caa5@kernel.org>
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

On Wed, 2023-02-15 at 11:29 -0800, Jakub Kicinski wrote:
> On Wed, 15 Feb 2023 19:33:35 +0100 Paolo Abeni wrote:
> > The first patch namespacify the setting: once proper isolation
> > is in place in the main namespace, additional demux in the child
> > namespaces will be redundant.
>=20
> Would you mind spelling this out again for me? If I create a veth with
> the peer in a netns, the local end will get one RPS mask and the netns
> end will get a RPS mask from the netns.=C2=A0

Which should be likely no RPS mask at all.

> If the daemon is not aware of having to configure RPS masks=C2=A0
> (which I believe was your use case) then
> it won't set the default mask in the netns either..=C2=A0

The goal is exactly that: avoiding the long way via the daemon (or
other user-space tool) and the sysfs.

Without this patch the child-ns veth gets the same RPS setting as the
main veth one.

That is not needed, as every other devices forwarding packets to the
netns has proper isolation (RPS or IRQ affinity) already set. If the
child ns device RPS configuration is left unchanged, the incoming
packets in the child netns go through an unneeded RPS stage, which
could be a bad thing if the selected CPU is on a different NUMA node.


Please let me know if the above clarifies the scenario.

Cheers,

Paolo

