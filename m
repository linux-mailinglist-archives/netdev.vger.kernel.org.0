Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771CF13DFF9
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgAPQXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:23:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55174 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgAPQXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579191818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Up4HSTCJxCusPmxMD1aRbim9MClJPO40+o1zlbRH9nk=;
        b=I4eEOWucJ82lvauhsOqWlvfey/CfWe+UHxhMS/RznIcjQzronjWCOKF95suGX87qTP1T7G
        iZFzvl2vguVoSQLFKv8S6pbiH+KhUNUJAwgKuB7YmdfpT9fm97S/8wJOKA55wWVWg65et1
        v1wJ1ES7IK3eUpzQrRqUbXbFD0sPPhg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-IjK75mGUPtOD44CceMsW_Q-1; Thu, 16 Jan 2020 11:23:35 -0500
X-MC-Unique: IjK75mGUPtOD44CceMsW_Q-1
Received: by mail-lj1-f198.google.com with SMTP id g5so5336452ljj.22
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 08:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Up4HSTCJxCusPmxMD1aRbim9MClJPO40+o1zlbRH9nk=;
        b=gQUZqlcRY7Z5LkbYDcyUiS37KL1gb+iclsxceAVOIBHfvZq71px5xxMp9Rl5Jfepr1
         GBPUyaYKLJG9QUvy05zGHMOLDps9BRQJkXtUzywzOieYrtWLH1SQkwnitIozym5vnOOE
         j9qjmOqDv7eaBAKmnK9MSTJUVnuvxNAio11CR2dXEp+hj+FK/+FrHlXso8a7g5laULrF
         XmuD/wh9xVPKdNjqvfBR9qnn3YIvp+Q4s/PwdpMybeKF8PEbauHiRsyiYqOM1Zb7k1g0
         HrGpeU3PEfMgrVH2EFzJuBc2zKRgq1vIowDrbLoVJSaSdDvAuNDyC/00ZUgIONhopEkx
         3w9w==
X-Gm-Message-State: APjAAAVFuX2n+Og6hYIrQCOMMLcnsjYnbu+nnNG0eNm689oWcDebvpav
        1lVaQAz4L8bq9uua8oCAmi2Cfl6n4q1tsn6hBzkAfwOSuK3dJKnJQI7QFrejapnklcbAcGc+zAD
        YDvbxTfj8Ac9kjHkK
X-Received: by 2002:a2e:580c:: with SMTP id m12mr2824699ljb.252.1579191813544;
        Thu, 16 Jan 2020 08:23:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqx/sSFmfnI9HuJu/lalUX3uJu26+JcMC+hV1jIYxiWYy3fycNFR4Rjy2nsEuPEB1WrzA4zpsw==
X-Received: by 2002:a2e:580c:: with SMTP id m12mr2824691ljb.252.1579191813414;
        Thu, 16 Jan 2020 08:23:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z14sm10996920ljm.86.2020.01.16.08.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 08:23:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CCE061804D6; Thu, 16 Jan 2020 17:23:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
In-Reply-To: <20200116160435.GT795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de> <87eevzsa2m.fsf@toke.dk> <20200116160435.GT795@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Jan 2020 17:23:31 +0100
Message-ID: <8736cfs73w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> Florian Westphal <fw@strlen.de> writes:
>>=20
>> > One recurring bug pattern triggered by syzbot is NULL dereference in
>> > netlink code paths due to a missing "tb[NL_ARG_FOO] !=3D NULL" test.
>> >
>> > At least some of these missing checks would not have crashed the kerne=
l if
>> > the various nla_get_XXX helpers would return 0 in case of missing arg.
>>=20
>> Won't this risk just papering over the issue and lead to subtly wrong
>> behaviour instead? At least a crash is somewhat visible :)
>
> How?  Its no different than tb[X] being set with a 0 value.

I was thinking that at lack of NULL check could also imply a lack of
proper bounds checking. And that the crashes at least shine a light on
them forcing people to consider whether that is indeed the case?

(IDK if that's actually the case, I'm asking :))

-Toke

