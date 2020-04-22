Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7A41B4924
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgDVPvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:51:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55321 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726183AbgDVPvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587570702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6N4qQMsuw89c4ivSAJR7LDuoHhbG8PACpIfCy7OiYEg=;
        b=iRr1Z2nFUTRDZR5it9ks633x65vUCFQw/ueZhiA1QwPAle9Qzr4ESTdIuYBHV0dfVyYFUS
        k58dUyK6/TKnI84r/npuk2Vg09OsYpiGdjIXIiq/R+cfX0zYtinNOirCcCrwGdRZlKfJt/
        fqN6B520/dc79V59GhdSn1n6JAY4lcY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-ZSGyh5jBMzm84XfCbK7O3g-1; Wed, 22 Apr 2020 11:51:41 -0400
X-MC-Unique: ZSGyh5jBMzm84XfCbK7O3g-1
Received: by mail-lf1-f69.google.com with SMTP id a14so1079057lfl.15
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6N4qQMsuw89c4ivSAJR7LDuoHhbG8PACpIfCy7OiYEg=;
        b=bOXE8e+E5v5/2dgBuHz4V8pFFlM7qCv/PwdQBEnMZ77l69WNJ4wuvZjI1cI9dlarlY
         2x6lONyKi9CMO474gHV7BDYSkik/JDd7aHr0E/K5xJzP+BoXmN9HAmsUz8uEMnSh+FzF
         XM1l9Ah1hM9IbIpej7mKo2LOfFP/Ti5VCLqJ3NRcnmqVSC+X+XoxDpX7EyFJyLgyLwVQ
         fjAOEaVK4zeFMTkjBxr6EGdp3//NrL6rh8Ktu6yThWwzgggo1Qt5gbYrnUOEogVW4q+Z
         4hSTbT58lfyuuDqN+6nZalqhLJ2DKnzqGYb5Kl7HGFQpScQJ+57qg2qcbMOzE3qaNNxE
         Xoaw==
X-Gm-Message-State: AGi0PubzguK1CMoR7GRZcV+/1Y4LIf9LxwFs1BV1Ue7MUhoSLUfHLnyF
        GLyn8nYO2RNQyi/tidmlPxv0VMvZOa3OEpmrE/fT/NE7mCDZz5jvJniFj2RfinKOfUQeHaCaxrM
        jHsBJrkPhRfq11V2A
X-Received: by 2002:a2e:988f:: with SMTP id b15mr17152003ljj.232.1587570699292;
        Wed, 22 Apr 2020 08:51:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ3Ppr6QCQ1MyTHXK8Q46MopcBC53f3FtCXH3VAPhNlQ1w1d9kYpRZEU9Imb99vwBfE5tNezg==
X-Received: by 2002:a2e:988f:: with SMTP id b15mr17151938ljj.232.1587570698148;
        Wed, 22 Apr 2020 08:51:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j22sm5224856lfg.96.2020.04.22.08.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 08:51:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B79611814FF; Wed, 22 Apr 2020 17:51:36 +0200 (CEST)
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
In-Reply-To: <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Apr 2020 17:51:36 +0200
Message-ID: <87368v8qnr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/22/20 9:27 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> And as I said in the beginning, I'm perfectly happy to be told why I'm
>> wrong; but so far you have just been arguing that I'm out of scope ;)
>
> you are arguing about a suspected bug with existing code that is no way
> touched or modified by this patch set, so yes it is out of scope.

Your patch is relying on the (potentially buggy) behaviour, so I don't
think it's out of scope to mention it in this context.

> The proper way to discuss a bug in existing code is a thread focused on
> that topic, not buried inside comments on a patch set.

I'm fine with starting a new thread; will do (but as I said, tomorrow).

-Toke

