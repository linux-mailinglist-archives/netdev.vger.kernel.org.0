Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB2647969
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 00:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLHXAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 18:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLHXAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 18:00:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF307A188
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 14:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670540379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=baTIkTKoeOdiFtRby0whXRwP+amvPAt/6cxtZd8HV9w=;
        b=dkfSWrgkkUqBIdKyqXdGR5kE8X1Qay6QMsWEULrnh0F9D+cDMl+h6/nbxywzHZ4mGykICh
        l0R1RneEOcUjBkuZ6BCTl4jL6UMO0BpOWLbOg3WUSm8vgNj/5AS86jY+t2i8b6gLZhXHuN
        tbfR/7JHc/TPUn997rcrmASu5JRiZ6Q=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-gPhyoDvvOK2DQYOUU2WGdg-1; Thu, 08 Dec 2022 17:59:38 -0500
X-MC-Unique: gPhyoDvvOK2DQYOUU2WGdg-1
Received: by mail-ej1-f69.google.com with SMTP id hd17-20020a170907969100b007c117851c81so1955355ejc.10
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 14:59:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baTIkTKoeOdiFtRby0whXRwP+amvPAt/6cxtZd8HV9w=;
        b=akNOUg3b3lLwYUoDNGP4RR6KhifUyCO2NOi1Jg0/fsEfqM+Ugc5z5hqGr2Yx6TVZbh
         lcB5wqrxxbq8CU/9R107a5l24O1WzepGubyTTqYRBHMLaWy6HOW95pJrFvn7gY+iIrh2
         kl7bHE7ay5LWWY9WJgyMeFrh/L52o2NPO233TB4dIQuOFVZuwQFFAtvbgopxrrVELYrI
         OttwyWfF0oFdI/gHfZyjdcIymf9YNSZ8ygsaxGercE937eofOPClUn7WzuPCzRqc1hKr
         uFm6sWFlB6tiKFiKzcKlvklpUil7//amQLlt7HBYnqlUL7jOpuJaVQ63jr2UIhPIB0Xg
         ngIg==
X-Gm-Message-State: ANoB5pmvCrTxAYoOuYN0FTZjGptHB4cvJ5XPrFz5yZb8a1Qsj9x6wSaU
        9TYK4toZtXsvvh8E7rTqaAMNlGmVs6lZUMWwwmNpr7r0In7ioJ/ZzBzFowvEkd70b5v1sOjjXpb
        qmF++yfIRnNIuVnuD
X-Received: by 2002:a17:906:f741:b0:7b4:edca:739 with SMTP id jp1-20020a170906f74100b007b4edca0739mr3069800ejb.5.1670540375558;
        Thu, 08 Dec 2022 14:59:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4O+Sh1+ZnimYfAGU1O9NIcjaEK3y0uiAjFVUdKd6hZII5wg8CkGMiUh5lXxHViZL7jNEWBEg==
X-Received: by 2002:a17:906:f741:b0:7b4:edca:739 with SMTP id jp1-20020a170906f74100b007b4edca0739mr3069736ejb.5.1670540374385;
        Thu, 08 Dec 2022 14:59:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m14-20020a170906848e00b007c0a7286ac8sm9777449ejx.69.2022.12.08.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 14:59:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0DA6782E9A9; Thu,  8 Dec 2022 23:59:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
In-Reply-To: <20221206024554.3826186-12-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-12-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Dec 2022 23:59:33 +0100
Message-ID: <875yellcx6.fsf@toke.dk>
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

Stanislav Fomichev <sdf@google.com> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
> pointer to the mlx5e_skb_from* functions so it can be retrieved from the
> XDP ctx to do this.

So I finally managed to get enough ducks in row to actually benchmark
this. With the caveat that I suddenly can't get the timestamp support to
work (it was working in an earlier version, but now
timestamp_supported() just returns false). I'm not sure if this is an
issue with the enablement patch, or if I just haven't gotten the
hardware configured properly. I'll investigate some more, but figured
I'd post these results now:

Baseline XDP_DROP:         25,678,262 pps / 38.94 ns/pkt
XDP_DROP + read metadata:  23,924,109 pps / 41.80 ns/pkt
Overhead:                   1,754,153 pps /  2.86 ns/pkt

As per the above, this is with calling three kfuncs/pkt
(metadata_supported(), rx_hash_supported() and rx_hash()). So that's
~0.95 ns per function call, which is a bit less, but not far off from
the ~1.2 ns that I'm used to. The tests where I accidentally called the
default kfuncs cut off ~1.3 ns for one less kfunc call, so it's
definitely in that ballpark.

I'm not doing anything with the data, just reading it into an on-stack
buffer, so this is the smallest possible delta from just getting the
data out of the driver. I did confirm that the call instructions are
still in the BPF program bytecode when it's dumped back out from the
kernel.

-Toke

