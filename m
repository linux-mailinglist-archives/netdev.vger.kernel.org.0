Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F23B1B734C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 13:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgDXLkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 07:40:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726746AbgDXLkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 07:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587728421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SWZ1+8++HCeLZRs7dW4H8lydDzVCFKNZ/YDYwbv9WFc=;
        b=GO//Ua368E2juxl51pPN9TUPMGf4NBwt1ZP9N8kAqabXWj9S/o+rUeMJPjbz0II0jXHr9u
        nL1sAd9muKnn8MpKS89eZ+cXtPDhPg878Lp9ZT0cS1RXeI+M9pNWFqTkcIywlZ6LQW3rfX
        8RnHGbSvqknE0T8wgaL1Y6tjgA/1iek=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-m0UiAUIYNfG-yVLR38sChA-1; Fri, 24 Apr 2020 07:40:20 -0400
X-MC-Unique: m0UiAUIYNfG-yVLR38sChA-1
Received: by mail-lf1-f72.google.com with SMTP id t22so3793234lfe.14
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 04:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SWZ1+8++HCeLZRs7dW4H8lydDzVCFKNZ/YDYwbv9WFc=;
        b=rNAfkGEPdmLckuWpf4JPubkV8sDgBTTBI3zHcoAknbV0fgRMi85XMWUWMziIxPz6yk
         JFTKfizxvxczAJckIpzuLUYgwNxfL+N/bg1yj1jN9u+wDHU7n0sEY3iVA9oyPES5wKkf
         bVKgRfrghg452dyK/mDGA5UmCV8dFPbYkBHOyyWAAq1wcxDhCODXAKPdGg8P2sxyb8b3
         kLsWvH1UB/Vxc5TIWZ38lBRfc8TazgMcR1SY7q8O/vM1ot50QmT3ldl52n41ObwSHvlB
         cEFKoOwlJ7WEFAldxaMDzLFoK0km+617eOqU64Cmfq6ZYPtRpf54dpS1hGBVGA20CVnV
         BLPA==
X-Gm-Message-State: AGi0PuYFF3Ij0p/Ioxk227h62n5RFFp6wGRvIpxUvnm0OCg8lQw0L2Fr
        EMXUAZ/ljrPvJXgvreTml7+qls5x482ScCEnHakL5iKsFgCuA5OjB8yE350argENiXQKoWOIyR1
        E7nr/LeqhQ8Ub0uMq
X-Received: by 2002:a2e:593:: with SMTP id 141mr5398735ljf.271.1587728418456;
        Fri, 24 Apr 2020 04:40:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypIQZNpneb3kebTL2SDME7wq525YBjp1hgEf/Tc9yA0gnoqdxk1TPntfGJsmXk04XCBKhMauEQ==
X-Received: by 2002:a2e:593:: with SMTP id 141mr5398732ljf.271.1587728418265;
        Fri, 24 Apr 2020 04:40:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id s7sm4344285ljm.58.2020.04.24.04.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:40:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0190E1814FF; Fri, 24 Apr 2020 13:40:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 00/10] bpf_link observability APIs
In-Reply-To: <20200424053505.4111226-1-andriin@fb.com>
References: <20200424053505.4111226-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 13:40:16 +0200
Message-ID: <87sggt3ye7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> This patch series adds various observability APIs to bpf_link:
>   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by which
>     user-space can iterate over all existing bpf_links and create limited FD
>     from ID;
>   - allows to get extra object information with bpf_link general and
>     type-specific information;
>   - implements `bpf link show` command which lists all active bpf_links in the
>     system;
>   - implements `bpf link pin` allowing to pin bpf_link by ID or from other
>     pinned path.
>
> rfc->v1:
>   - dropped read-only bpf_links (Alexei);

Just to make sure I understand this right: With this change, the
GET_FD_BY_ID operation will always return a r/w bpf_link fd that can
subsequently be used to detach the link? And you're doing the 'access
limiting' by just requiring CAP_SYS_ADMIN for the whole thing. Right? :)

-Toke

