Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCDBA12C3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfH2HoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfH2HoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 03:44:21 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E15D7FDEE
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 07:44:21 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id y15so1578018edu.19
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 00:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=syJ1qgGbb2nyLjAQ0BdovjtQf9fJ98FvbZ0asS0WfAc=;
        b=JsLq92WwmggvkvwrQKSJnWIbh2GcYEpqiyUhZ8vHe3t2b5hNJLXCKYmxA0dZ047jwe
         ZSGxzEa1ZPpakX5KdGxk5BusOGAjt2CADGCdruYSJmlhfGT0Kk2tnG6ABcQBJHIxBLnR
         3Vt1GunY/JbUCt+8vMs9BYsZ/9zoeEzYkc3bhurNXMJfLmk2FeZLfDdZftyS6i+iLGfC
         VVXEFmuYj7TbA5RQUOmPtdhY2isWZkAZATS83wqIvhtowrYMC2oo2kvE5OWtDh5cEGLs
         5nYS1S+QFVAdc+nHDB51Po31yByWNfnl4nmScJo4VxEg6wRkBIaBp+QyWgH4QOkYXgmv
         GLUw==
X-Gm-Message-State: APjAAAUciJ7xHqDl8vbrAqX2Ra1JwHfAJidpD6l9Zs1u57HpfB2QsTkJ
        ylJ+M/jBLKnAaykUL/F56WiGbvCFyFeA7TQQs6gS6b0gw3XgI9DdZ9JUdam7QOCcnsyAoAsEm5i
        dA3Sg/l937XRE2w8q
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr6877704ejx.181.1567064660256;
        Thu, 29 Aug 2019 00:44:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxTEgOTmPL7C6gKeK+p4p3VDmj4jaAlWchwY4AG0qidGcwqilr8Hiqay9Scqq+u8hizc7+f4A==
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr6877690ejx.181.1567064660112;
        Thu, 29 Aug 2019 00:44:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h9sm292089edv.75.2019.08.29.00.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 00:44:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7C1F2181C2E; Thu, 29 Aug 2019 09:44:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net
Cc:     davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
References: <20190829051253.1927291-1-ast@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Aug 2019 09:44:18 +0200
Message-ID: <87ef14iffx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <ast@kernel.org> writes:

> CAP_BPF allows the following BPF operations:
> - Loading all types of BPF programs
> - Creating all types of BPF maps except:
>    - stackmap that needs CAP_TRACING
>    - devmap that needs CAP_NET_ADMIN
>    - cpumap that needs CAP_SYS_ADMIN

Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?

-Toke
