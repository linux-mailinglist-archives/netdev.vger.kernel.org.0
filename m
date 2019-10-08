Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB494CFF30
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfJHQpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:45:25 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46735 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJHQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:45:25 -0400
Received: by mail-oi1-f193.google.com with SMTP id k25so15337213oiw.13;
        Tue, 08 Oct 2019 09:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EyjT+7gDIxKm4XRLVmG8u2dpIVBV5blxBBh56Z3Elbc=;
        b=fu3K4OJoMa9+WSnK+4Z2Y65pFTeMt+ukaBs6TN1nLfX+wM4KzIax94PEbHOKQVyKwe
         oPLJpXz6Y/wQsJ6LeyX+Lpd1h5ZtUEZ7m4NEkj34VPx4JcSCfDlztoIUAYa/19m9+I25
         26abw51oDJ29P3YBwsTcj9m6R489NftngpqeE+Cl6Vim62KcjZiTgDcDBII+Fk9jTbuG
         QPwJt2QX9xgtzwfgfL1njNSfAMMa93x3vEUp3IRQB+rrAFSuEUlOwQIiUdFzuW/BFjL6
         9tZZiUtlvr619lyPSsG7I7PCUzkir8pQ2ZYonBnNzt+ul4t5C35aNczd8ZhGpRnxhI2L
         EQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EyjT+7gDIxKm4XRLVmG8u2dpIVBV5blxBBh56Z3Elbc=;
        b=K7JYKxhloGR5G9QEtCxgVS+QhMplzBuF017+mJl5prwkQkojuteCXLAItnraJdVCMN
         O++ayajCpuNmA0orj/oOl3lJ25eIFn7YK4gUBw2Hw1G2zI64twzYnLv09r9ZG7Yjq9BO
         5wGZTay5PVvh8VfZVHAwgpR5DO/Po8dsVYVSi/dpaL6gihFaQJDHGOQfs6MNiLin+tjq
         ECj6fJ+NNfx4rCVnaZzoRu0RJ//Tma3SCVLl7hE/YmkfTS2KHxlF/AUsJuGEHEWytc2z
         X+EZ9C2//9WzRVtJPi3GDJ7aus2/3XjJ8AQ6DTyhb9ONE02cZmr0hF5JYKoa/8vwJDYr
         ftow==
X-Gm-Message-State: APjAAAWdjM8YYJuLqqGDnsqg4Xa3WUDfAzotZLRAp54MW9pplmfTgtSc
        yl79ymgmzckvbizAX5IsxjxFXhj+it+3jI7tA0g=
X-Google-Smtp-Source: APXvYqxLtMydhQHvcgJ9zqo6gXmpExfNC08S29EXUgBNsSTwazlQirszM6KoJKOkcVBiUXFkRlDIyTMtrhayL9uaz8g=
X-Received: by 2002:aca:508d:: with SMTP id e135mr4538530oib.31.1570553124489;
 Tue, 08 Oct 2019 09:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570539863.git.jbenc@redhat.com> <513a298f53e99561d2f70b2e60e2858ea6cda754.1570539863.git.jbenc@redhat.com>
In-Reply-To: <513a298f53e99561d2f70b2e60e2858ea6cda754.1570539863.git.jbenc@redhat.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Tue, 8 Oct 2019 09:45:13 -0700
Message-ID: <CAGdtWsR9b3_6=40B0F5wX4cyBpWPBBoYgWujCiKS_AyJEVSJ3Q@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: set rp_filter in test_flow_dissector
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 6:11 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> Many distributions enable rp_filter. However, the flow dissector test
> generates packets that have 1.1.1.1 set as (inner) source address without
> this address being reachable. This causes the selftest to fail.
>
> The selftests should not assume a particular initial configuration. Switch
> off rp_filter.
>
> Fixes: 50b3ed57dee9 ("selftests/bpf: test bpf flow dissection")
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Acked-by: Petar Penkov <ppenkov@google.com>

> ---
>  tools/testing/selftests/bpf/test_flow_dissector.sh | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
> index d23d4da66b83..e2d06191bd35 100755
> --- a/tools/testing/selftests/bpf/test_flow_dissector.sh
> +++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
> @@ -63,6 +63,9 @@ fi
>
>  # Setup
>  tc qdisc add dev lo ingress
> +echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
> +echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
> +echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
>
>  echo "Testing IPv4..."
>  # Drops all IP/UDP packets coming from port 9
> --
> 2.18.1
>
