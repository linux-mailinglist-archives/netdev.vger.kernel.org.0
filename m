Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2D1B27BC
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgDUNZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:25:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728719AbgDUNZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587475512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnU6y96zUNHQD/gmWmM4G8MM8/6DSkwG67vvNCRAkTA=;
        b=V7TOe2EwT8JExUVipx2kM6J96/v/HlsZBp2idb2xuh0gFZRj5e0ff3QKvVx2pPyzlx5l/d
        hpMOO3JFPRV3g0+K/vzY4mQSZLk3yr0IyCoFX4BWM6AhixS8EDjWJfAvldLZ1eZBN4GoZ1
        wt4OczJ5Fqz6NeM6e6EQnUw3FnhyL1c=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-QbbWaUO_OZCfsAaQ0lS4vg-1; Tue, 21 Apr 2020 09:25:10 -0400
X-MC-Unique: QbbWaUO_OZCfsAaQ0lS4vg-1
Received: by mail-lf1-f69.google.com with SMTP id d5so5778331lfb.5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fnU6y96zUNHQD/gmWmM4G8MM8/6DSkwG67vvNCRAkTA=;
        b=V5HpioqCoAKCUNp5Yt40iLkByFLqvNdsnPy2TE5BhwMh5lCQuaChZUo/hqRwzV80XG
         LvUty5JCM9TyaAjvdyAPsizH78/xSewHb+8rC6fkMjWBqKpzL+KRgpLgp2XBqSQrMEfz
         psW1eOYGUJ00P7DZ5Cr7YvDb+gHapx6EBcOuT+Gp2EdjfTiptckLeNtu0ZGjf19q8WTO
         B38lILTB/Vmli1JcbycldosNtn/EbMTVDwccKURoAXm1PeAI6hkr35KHhf1m2sl64F8e
         6asx/dEaofJcww3dIZ5dMEPp3Nuj//Hx4i2I/Y3eBqgRc/8aBCIz/vWViIXseZDKofCn
         E1vA==
X-Gm-Message-State: AGi0PubDX9p/RB9cBUWg886tnH1EY4R/OWxAGZNCfDQ7QVWV2GSuelXB
        AdXkmU6XTrJgMPWmcLMBMtWhjLsVy/11pr+Q9aJKYjVtDxIU7wTYNpp+VRUQUQvDQOKtY4iRmug
        redH/raBS6zexELAw
X-Received: by 2002:ac2:48b1:: with SMTP id u17mr13464758lfg.187.1587475509308;
        Tue, 21 Apr 2020 06:25:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypLgChzcJTlBu8zdw+Hl3CUTeHc+9bWsQOnRm3+uqheKq7/o45jseTn2MqLuOqYdWHPBh+nEgQ==
X-Received: by 2002:ac2:48b1:: with SMTP id u17mr13464737lfg.187.1587475509058;
        Tue, 21 Apr 2020 06:25:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r206sm2067961lff.65.2020.04.21.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 06:25:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A02C18157F; Tue, 21 Apr 2020 15:25:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Apr 2020 15:25:06 +0200
Message-ID: <87pnc17yz1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/21/20 4:14 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> As I pointed out on the RFC patch, I'm concerned whether this will work
>> right with freplace programs attaching to XDP programs. It may just be
>> that I'm missing something, but in that case please explain why it
>> works? :)
>
> expected_attach_type is not unique to XDP. freplace is not unique to
> XDP. IF there is a problem, it is not unique to XDP, and any
> enhancements needed to freplace functionality will not be unique to XDP.

Still needs to be fixed, though :)

Also, at least looking through all the is_valid_access functions in
filter.c, they all seem to "fail safe". I.e., specific
expected_attach_type values can permit the program access to additional
ranges. In which case an freplace program that doesn't have the right
attach type will just be rejected if it tries to access such a field.
Whereas here you're *disallowing* something based on a particular
expected_attach_type, so you can end up with an egress program that
should have been rejected by the verifier but isn't because it's missing
the attach_type.

-Toke

