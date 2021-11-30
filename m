Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6180A46335B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhK3Lxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:53:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231396AbhK3Lxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638273033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QYC3XnTEw007bEFYMyAJDS/BqhYWTSHCXS0Pa7RRXls=;
        b=BjO8W7Nxabfc6oWV+MDEt6iDZp5a4kjdiTu18Eu8EvFC4FlTNb7nNhJP/xuyZjqOa/mqlU
        ltdKLmxhxQHbSSnAQDi5wwNLeELX6P1NlvVBGgCN6CDgYhNrpIaOjTWVaZb0gFvYO5zCXJ
        XVqDkZlCQ7EwdUSJJo4/Uej2Ke3eGCY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-0_uJZ1KHPQe-9-tQ4Lo0lQ-1; Tue, 30 Nov 2021 06:50:32 -0500
X-MC-Unique: 0_uJZ1KHPQe-9-tQ4Lo0lQ-1
Received: by mail-ed1-f70.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so16668045edw.6
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 03:50:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QYC3XnTEw007bEFYMyAJDS/BqhYWTSHCXS0Pa7RRXls=;
        b=1PwTuC/CD+QcmHwJsvPv8EwQu0rtFAMmRGkUk3UaAYq+WjM466mahWdYKPZ4RHCDYl
         FHNjfMrUs5M+xAt1Xr0KcaGW3OtnpO8T/umgibvEbBotX6MECr+1rRrKnaJr0GI3LYtC
         +vQsHKaucl1lyxxUKBVjh9s2MHZ0Ht1CuDVmWLEj+HuyB15TzJS6B5Bs9hGAZQFu12Hk
         L7RM1QK5Nnwj6VHWzG+t9fbaBCXiiXzbvEm9UQWHKdcILVcLgEWMtkT6lKYu49lG8YH2
         gheySqtDnSoiu6oUZyVGs0zH7OZa7zsgvJeWZgAP3rlxTjYaZXgWwWxAzdrdok068ekJ
         C+zw==
X-Gm-Message-State: AOAM530x9TUvi9NYi4U06j6B1c6mZ4uZb/YBVOKGy1u0e3j10QtRM9dm
        VNS/p/Z951dR99NCfjzcHS1v26WOEPRbZzPCmXedtaGfEhRSbtO85JGlTRbnMRHWzpn3ILd3CK1
        3nn7zAaSw17Godsn3
X-Received: by 2002:a05:6402:1a42:: with SMTP id bf2mr81541387edb.64.1638273031099;
        Tue, 30 Nov 2021 03:50:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxHEn/BPB80XStTpfeoFDZ6bBAF4TWAd6ni14rD7Mi0KlcY4OziyMXI9urRE05ocRNRqvp2HA==
X-Received: by 2002:a05:6402:1a42:: with SMTP id bf2mr81541370edb.64.1638273030783;
        Tue, 30 Nov 2021 03:50:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c8sm10719395edu.60.2021.11.30.03.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 03:50:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B36EE1802A3; Tue, 30 Nov 2021 12:33:20 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
In-Reply-To: <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
References: <cover.1638189075.git.pabeni@redhat.com>
 <ddb96bb975cbfddb1546cf5da60e77d5100b533c.1638189075.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 30 Nov 2021 12:33:20 +0100
Message-ID: <87fsrd98u7.fsf@toke.dk>
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
> v2  -> v3:
>  - properly check NULL dev argument (kernel test robot)
>
> v1  -> v2
>   - do not include the device name for maps caller (Toke)
>
> rfc -> v1:
>  - do not print the attach type, print the program name
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

You forgot my ack :) here it is again:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

