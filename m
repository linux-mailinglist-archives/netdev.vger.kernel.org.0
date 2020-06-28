Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0B620C944
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 19:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgF1RfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 13:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1RfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 13:35:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50210C03E979;
        Sun, 28 Jun 2020 10:35:22 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u9so2573808pls.13;
        Sun, 28 Jun 2020 10:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GuL9Juv0Z9aqWRkO4VvampwxVeKu82teqvGixzJtcrM=;
        b=VVgqlgwjMQDPIi4NEvB12W0OSJkPhPoo9BRph5bn3fiaiNWdFO3PsdBUB40w/uC77B
         1z6MNvno+v2eB11gkVNQOe1kB4+q12GmGeQ+pj8rWywi1u/r2lcYXo5tMEyTcGqX7jE2
         ur0lgtW9lSG/qO/sozjDk8SCnD0GeLW9kTnbFlN+XtBMjxE9FZBl1kuWCe4vIKLQSPD0
         FUn+ciCKk5Y3OmXWErV66Y6LuMYoa6+FF7ID+Yg/uB7fgl2JdDaOT0H74jE8bjE06dS0
         4ij1N+ry55dtvVK7GnJm6aisCXBwaRCpNJSlJmpp79UJAb3AmK8Y9AO1cZRn0k5mG3gV
         EFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GuL9Juv0Z9aqWRkO4VvampwxVeKu82teqvGixzJtcrM=;
        b=XGhMYU7fyQs+0MQnn7oKHTMijGHIJpVhPSr7Ln/DaHY7fPjo6wuZ9Fb2N/cZiI51Gr
         Ul0dct4bGGvGfiARlwzTNMKxWiq9aZpHkGDq1jweQpl2PV+lt91uJf6NApebH1kHhbVl
         DM0vlH1LfWJw+VAJB30TrdI1OV+W0CY7gjgADxL3mInm6kphHqN6PWb1hUHnO7cfssKB
         UqakBD6iPs9LqtyBAYIS/b9jsMQng5+PUwJCXxxu6jxR53zZyuYzPZ/opM0bjDrMcgyA
         ctrz/TqmMrBVPY0GPJd+3cxb8qj76ZNfqh9RWRznWdolGxZmjEhnsdvgdQD9ns4moW1H
         ih8Q==
X-Gm-Message-State: AOAM531H/gxeqTcUyha3FZHt9xBU3A67b5B3lTZtJmC91qZaW4Du9nCy
        r/kiJQ9Fq2IVoyXRKC079xE=
X-Google-Smtp-Source: ABdhPJzmuDS5ikkS3f/rxJZjsNbyUEvZSj7t9+zUOPA/zYkpAYizhWWYUKASzKDGKshLHgVF8/MUvw==
X-Received: by 2002:a17:90a:d709:: with SMTP id y9mr13841350pju.30.1593365721882;
        Sun, 28 Jun 2020 10:35:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:616])
        by smtp.gmail.com with ESMTPSA id mu17sm18716494pjb.53.2020.06.28.10.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 10:35:21 -0700 (PDT)
Date:   Sun, 28 Jun 2020 10:35:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 2/4] libbpf: add support for
 BPF_CGROUP_INET_SOCK_RELEASE
Message-ID: <20200628173519.j3acq5cp6yvbntqk@ast-mbp.dhcp.thefacebook.com>
References: <20200626165231.672001-1-sdf@google.com>
 <20200626165231.672001-2-sdf@google.com>
 <CAEf4BzYWUZhgK-XpOxV76bzk1pnVzKgyu3AtCRtdVbW2ix4D7A@mail.gmail.com>
 <CAKH8qBtaEWJPFWGqXuZzz8ymOCxwK1NWdrstvj7g2Z3z2khh_A@mail.gmail.com>
 <CAEf4BzZxasCcvrT2fQ9szXe6TjFwPGiv9vsGOjPJdKcozn70XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZxasCcvrT2fQ9szXe6TjFwPGiv9vsGOjPJdKcozn70XQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 05:59:41PM -0700, Andrii Nakryiko wrote:
> 
> As for the cover letter, unless it's some trivial independent fixes,
> cover letter ties everything together and is a good place to track
> "what changed between versions". So I'd recommend adding it anyways.

+1
For independent fixes it's ok to skip cover, but it's often nice to have one.
New release hook like this one certainly deserves a cover.
