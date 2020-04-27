Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04771BA7D6
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgD0PVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:21:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgD0PVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588000890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x2Fed9EQj8re4fkzPZjxJHZSxmXdYa0OFjhBohlx6qw=;
        b=BkFszNrip7KVbrZBz9QISI4bDs9ON6ljNsJi96jcTrbpyuu1rwDA2QkhXBgqoNyKNqKRDE
        U/qiFRCT2uaEzGigr9ThcquN8rwM0oSeuTN2aQ1ypiYtWQzIQ6sHHC905JY/Fip2BF3UxQ
        tGwYHe3+obC/i/mN/4peqOcIpMbdqCA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-leWDt5l8Ova4-ef1pBSxuw-1; Mon, 27 Apr 2020 11:21:27 -0400
X-MC-Unique: leWDt5l8Ova4-ef1pBSxuw-1
Received: by mail-lf1-f71.google.com with SMTP id l28so7595024lfp.8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:21:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=x2Fed9EQj8re4fkzPZjxJHZSxmXdYa0OFjhBohlx6qw=;
        b=EPRh6MAOm/aA6EKQufFuqFUzu3uCQ3UgQDR7oIv6doSR2RmXp7gleFe33JRpEwZ0hb
         ntOT5B7hFckVQZIitjius/2SmudL/zIOwbFnJuwY+swdAyz3oZUptaFuafSWPDyagSQD
         B7mwdzeAPuE8wExSOE1ZTibEv7Pia1C5hd9gV3ismLZ/C3oP0HaD5fE/eVXXdWJUnSm8
         qQcE2WzQ/SvMEbG9733Ecbto7Z1UH4PRzU3K4UvUZbS1rK+RrzujoaFxM6fLdLU/LJmP
         QcGnJULR01jrhY3RrMO0zy0v8wW+5W9RgtuUJvXEDNG2+Zw5DJJ5NT7DhI7qEQ3f/6Fn
         xVRQ==
X-Gm-Message-State: AGi0PuasIMoSDWwDM0O6sSMfjDbuJgiA8FvdshYmj4my44vgpaiIgdLg
        K5DSee4jr2kbElo6bcVN3Ue+rcYHpjn1YBS9YNOc83uMbHGXOO/K1hTKQiqns/kO4TOdPMWR5JI
        vLt5i/VgdftwFswm8
X-Received: by 2002:ac2:5684:: with SMTP id 4mr15488338lfr.88.1588000886137;
        Mon, 27 Apr 2020 08:21:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypL8lGr9nEbWTiYW9QbtY+ytEdJ8atVXoi7lGev+nbup8L56B7WedNvYOXnJG6QgPjmFJhym1w==
X-Received: by 2002:ac2:5684:: with SMTP id 4mr15488322lfr.88.1588000885953;
        Mon, 27 Apr 2020 08:21:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p2sm10156289ljn.56.2020.04.27.08.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 08:21:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9139F1814FF; Mon, 27 Apr 2020 17:21:24 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH v3 bpf-next 00/15] net: Add support for XDP in egress path
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 27 Apr 2020 17:21:24 +0200
Message-ID: <87zhaxx8cr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dsahern@gmail.com>
>
> This series adds support for XDP in the egress path by introducing
> a new XDP attachment type, BPF_XDP_EGRESS

Can't find anything more to complain about :)

Ran a quick performance test: On a test using xdp_redirect_map from
samples/bpf, which gets 8.15 Mpps normally, loading an XDP egress
program on the target interface drops performance to 7.55 Mpps. So ~600k
pps, or ~9.5ns overhead for the egress program. So other than the nit in
the bpftool patch, please consider the series:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

