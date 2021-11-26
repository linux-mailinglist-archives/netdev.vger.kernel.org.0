Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E061645ED58
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377269AbhKZMIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:08:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376834AbhKZMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637928199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GVX98ikHeZ7eJCoOXrjvQJfNzLzuoPo0mWyUsTqXrE=;
        b=bxIIsjizE1AHcKwI1Hy1hqxU2Td0ZdYBZNR3VFDllj0Y29Uac49AtZjWBn5oUGvxSJ7gnE
        65vvAjyaTJlA1sFGXLvZU6BAR4NhThTez9JaOtIgpmhoh1BUYKqh30+ghkLOIc8EyyRk9Y
        3o0xtO+Y6xSZ0Xzl/8cOuaM0YAmapdg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-DHl79P8sPcq1tjezUkUMtA-1; Fri, 26 Nov 2021 07:03:18 -0500
X-MC-Unique: DHl79P8sPcq1tjezUkUMtA-1
Received: by mail-ed1-f69.google.com with SMTP id eg20-20020a056402289400b003eb56fcf6easo7818030edb.20
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:03:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+GVX98ikHeZ7eJCoOXrjvQJfNzLzuoPo0mWyUsTqXrE=;
        b=P84BIIVi67iN4nmiiiGSokvaE1ExSIX4ors7MzwruVt5Laj/tDGFDnQWsl54DPfS6F
         rcN49E5EF1AxGF2VuYdL2nBlEj27bKDiIqDYQfTjNV79+SUT/DfDtj/mJqAsmw9mPhki
         miwa50wP9nRPEzD2R7c1fw8DnfBW4OsO3lg+oIHGcTpgpdP+AYXTudQoUsWEdm36Q6Ej
         bDjylr7qZbDT29UpWiX/HV5yHT7rd2mu65IPcA8raimbIe2dUS7OEDrAX4TepTQeWiKd
         Inv8AsVlImNzEwauBezc2yPVOevORLIHklhPlqyDspLN7zdhLBOU+PKBIntUWemuYhG5
         JWeQ==
X-Gm-Message-State: AOAM532jIXVwSrnWfzQgrs+c6x05zRbzo4LjvWieJ2+9pDmoxyauot+0
        wOsOpB8rO9ATd4eau+AlgROpNvxgFaJZ9GPYfVfM9JZdkIingRATDIMx2JF4xASurQhYJ6TtNnr
        X8hAijGwFL6wZoMkt
X-Received: by 2002:aa7:c946:: with SMTP id h6mr47811427edt.190.1637928196860;
        Fri, 26 Nov 2021 04:03:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQA6Z+BWdbXXyqxo121uGQ8KKTBdbgLCQrPsB9Lo/Twf7z/WcPPdkcCsl+v1t+q1ZS/vGzvw==
X-Received: by 2002:aa7:c946:: with SMTP id h6mr47811353edt.190.1637928196355;
        Fri, 26 Nov 2021 04:03:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id hq9sm3068890ejc.119.2021.11.26.04.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:03:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1E4581802A0; Fri, 26 Nov 2021 13:03:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
In-Reply-To: <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
References: <cover.1637924200.git.pabeni@redhat.com>
 <277a9483b38f9016bc78ce66707753681684fbd7.1637924200.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Nov 2021 13:03:15 +0100
Message-ID: <87wnkv9la4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> In non trivial scenarios, the action id alone is not sufficient
> to identify the program causing the warning. Before the previous
> patch, the generated stack-trace pointed out at least the
> involved device driver.
>
> Let's additionally include the program name and id, and the
> relevant device name.
>
> If the user needs additional infos, he can fetch them via a
> kernel probe, leveraging the arguments added here.
>
> v1 -> v2:
>  - do not include the device name for maps caller (Toke)
>
> rfc -> v1:
>  - do not print the attach type, print the program name
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

