Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0791E83F4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgE2Qqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:46:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726616AbgE2Qqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590770809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=satBzjqEWExQ7MJMHl6Q6QslZmW/U2ljzHPOP9S7DpI=;
        b=ZZiANsnduuxV5MvPj0uzcHE9cJCzoh7VLY9pc+F80LLYzulWGvL13EFpxgl/lAi+smCRem
        PScu8GuG0ZN9zPmK7331vR0o7v1X+BU8tXVITasdYPye0IeaWnXfkgTJM1csjQJzxJ6xcX
        d90s8iJuFMSsVTGPC/t6i5o5K58gU50=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-ML5v_Zs4MGqsYGmOLCaiOA-1; Fri, 29 May 2020 12:46:48 -0400
X-MC-Unique: ML5v_Zs4MGqsYGmOLCaiOA-1
Received: by mail-ed1-f69.google.com with SMTP id i93so1440598edi.4
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 09:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=satBzjqEWExQ7MJMHl6Q6QslZmW/U2ljzHPOP9S7DpI=;
        b=PZqz2L9O1gm6WfMl+laPmnX7Oz79d39u5kFz4HosLjnCO5/GrA5C/jX+MmX1wvmaWb
         XCs7fCb6yWytQ4E/Ex/eMZ5BD2/t6e2HiBy/bPS+ULSZUQW495rRHMtgQ/QkEP9lqnnR
         rDQ5TKjTJoyHhMVKdhxtZKxYtTGB4e3K6TUzO+gQaoKpu0NVtThs1CKg8UJp5eBQl8Qd
         zeNoLTxzk6MEme6odYd4Yc1RwH6ovMUS0zqd28oYqTJsP4NiIXWnenEdKGJ5noBwGBH4
         KRDG8970D78ICIqvjwHtDXFyrWICHnHx0siZh5yemqG64LUcKf0cB0u7MicJe48wtVTK
         a33w==
X-Gm-Message-State: AOAM532VXr4en5wfovv+55PGl7OUrIQrvTMAaGC+z+0Fzg7EjGZ3i/Vz
        4kGYLKVeGAOgGzAy9bIh7hqOONlSSFRghzyN42KKJxV0azewwpzQjNIZxMvmHcNk6IgLjjhgB/9
        alCg9A/ILm1VQ1ptH
X-Received: by 2002:a05:6402:1d10:: with SMTP id dg16mr8923708edb.309.1590770806802;
        Fri, 29 May 2020 09:46:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyd2YI0laEZoe5KG/qECc2J3Yng27MQ7+AWtHrrldc9w01zYj1Sk8C5tjbmFh4eXEjLY8Cchw==
X-Received: by 2002:a05:6402:1d10:: with SMTP id dg16mr8923687edb.309.1590770806664;
        Fri, 29 May 2020 09:46:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g21sm7220308edw.9.2020.05.29.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:46:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 79F88182019; Fri, 29 May 2020 18:46:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, lorenzo@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 bpf-next 0/5] bpf: Add support for XDP programs in DEVMAP entries
In-Reply-To: <20200529052057.69378-1-dsahern@kernel.org>
References: <20200529052057.69378-1-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 29 May 2020 18:46:45 +0200
Message-ID: <87o8q6zo22.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Implementation of Daniel's proposal for allowing DEVMAP entries to be
> a device index, program fd pair.
>
> Programs are run after XDP_REDIRECT and have access to both Rx device
> and Tx device.

Found one more nit apart from the changes you already said you'd do for
v4. So with those fixes, feel free to add my:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

