Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F60349C0D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCYWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhCYWCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 18:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616709749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w9rOIKpwbA95BInVBsqrxFma4Tk6j2iapw6W0tMr/Og=;
        b=aBkpom3+Jzh+gas4l3lKct4sPxqvnmS/aYdJ9nfjs5zY+0YhjDuSvdiQUUIbZf+Cni46zi
        ICsCshfZJaDT+2D3HH8LDo6Srhw43nsQ2BART9Y/oDPgioilt3aGGk3eOrhZt8mk/xMFUy
        gqfJCw7UgnO5PJ9KnnvpP9u9YJ0qA28=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-uuOp3rfKO1W3suYpqA7tpw-1; Thu, 25 Mar 2021 18:02:27 -0400
X-MC-Unique: uuOp3rfKO1W3suYpqA7tpw-1
Received: by mail-ed1-f72.google.com with SMTP id y10so3356381edr.20
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 15:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=w9rOIKpwbA95BInVBsqrxFma4Tk6j2iapw6W0tMr/Og=;
        b=N9xlPz4Ss8II4NF8dF590A4GhWa4k6S6p4wsqENOpOApdN8b6ekHmBymeprxK0zN6U
         fXjYhsvkniwrs7oBOl9HIlQbdCArUqXaaF39zM6MLAGcmChSuvySMJmvemPLM74QeMJ/
         DEOiThPAibtpD04fa4MSpWSXeRqHSyALFbCu5dKIstNCutjtjToHNhiWNtwsFCKr5JVt
         uOUYUSexz85D2/yxjoqhO6D+xT7YdP0XZ0AnUZVowi2DEl4meliN04e76cxC+kIcToHq
         SYrQBYeAMltuNbD00QgzqaMKJFwOSQhBtqpXjdJoZkrGiJ38+fToAmyJtR1VcYKzlBuT
         aS+A==
X-Gm-Message-State: AOAM532q6ofl1xYBMLH35f84zn808bBXQ2XQYpqDrwfNvSHkaIxvyATc
        ewQC9NXq/UpMCXMPxa2HzgPXcOXXi2DW/uZUt0HM74DagmnK7qxRPVIXoJHLoNI0c4Zo3B4jxQ3
        Ms0fgRpdU+HiZ9WjV
X-Received: by 2002:a17:906:ad85:: with SMTP id la5mr11788656ejb.37.1616709746332;
        Thu, 25 Mar 2021 15:02:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGpJzC4cCibS6RmSlQYtMZP//X7FCaLqhC2P2oVdltJe+qGqBupZliZGm1OjPZ4PzXb7gqnw==
X-Received: by 2002:a17:906:ad85:: with SMTP id la5mr11788620ejb.37.1616709745988;
        Thu, 25 Mar 2021 15:02:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n16sm3305606edr.42.2021.03.25.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 15:02:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CD3BC1801A3; Thu, 25 Mar 2021 23:02:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling
 kernel function
In-Reply-To: <20210325015142.1544736-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Mar 2021 23:02:23 +0100
Message-ID: <87wntudh8w.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> This patch adds support to BPF verifier to allow bpf program calling
> kernel function directly.

Hi Martin

This is exciting stuff! :)

Just one quick question about this:

> [ For the future calling function-in-kernel-module support, an array
>   of module btf_fds can be passed at the load time and insn->off
>   can be used to index into this array. ]

Is adding the support for extending this to modules also on your radar,
or is this more of an "in case someone needs it" comment? :)

-Toke

