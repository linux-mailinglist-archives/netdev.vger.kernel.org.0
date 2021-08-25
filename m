Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7BD3F7A46
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbhHYQUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237894AbhHYQT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:19:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79F9C0612A9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:18:26 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id y5so6957985edp.8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYsoLSMuOzMjDvy8lt1twkggcFShlOOTyGCbIOCpMO4=;
        b=gex5LlFCGSJBsOdMvLQeXlhE1hu401J/SfKtMaOVZOND/C7MwUcl9/wKb0v3OgMai3
         MN/eyq3pM7e/ue0plkLLpqKQp85GXvN0vHfUshfCn59azb7i8v4TIJQfABBxA0KUsmCb
         YY17u7U1z3yFDacjaejv+tdby1r18FImwvKZaXj+sFBQaLWLrA9bLyvRy0F6nvsEO5HI
         7WLyKII9d7KbG6cwDrAyOvuYNlKVohqdytVKNpGvw+Mc3g8lSYqDhbwsMItkvAiK5Nrh
         bT7P/2Vg4Z8o9w+iuneEohDTNHZjcX1IuKjtUQvuQ/XffVDyPjgmlexaOl5xWJqxPY/X
         Gwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYsoLSMuOzMjDvy8lt1twkggcFShlOOTyGCbIOCpMO4=;
        b=GqUJxi5ZGoWsR75iCUXsJMN/tPAdf5WDevWQeZjkofh5QltpHCYDzXVR0ZKh5Dok8z
         dXTwEGKygpgeXMMIY4x7eBx+tA3msoZzF83J0BzBZJpqeA90/voswcJAtAqJxiPlBaqJ
         ETf8SmxzAsvyD9jEQ0YPQawmcTj0k+ljJXx/irse3tXI25L2hGSvh+qhugUnNKEXlZck
         7j+PH5BX4TG+qQNLplJ5FVBfmZQ3wxsWnqcE5chS9Y3TIuUk1ALdNAEDa+L9qtK3v6Gh
         gZM7V8jeORjrg2U1sGR6kmZu0XCKqARUxaNbuG/5yGcBqPXqnQPaAb+7292q0OjhxZPt
         iWqQ==
X-Gm-Message-State: AOAM530NdL2nN26uso/qElaiX4coWB0ihaEvJvIGrpjMm4x2vcQQjFC9
        RPk2FxWtt8QruHH6PyIAO0hm8MJoh38=
X-Google-Smtp-Source: ABdhPJz/28xyMkipK/TJlIpXdFyV02d4V4kV8KvLY5ThLEr63DyFjLI+KjeHkH+YW9J9S+DifdqQ/A==
X-Received: by 2002:aa7:ca4b:: with SMTP id j11mr23280803edt.342.1629908305491;
        Wed, 25 Aug 2021 09:18:25 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id t8sm74297ejc.8.2021.08.25.09.18.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:18:24 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id n5so76556wro.12
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:18:24 -0700 (PDT)
X-Received: by 2002:a5d:6da4:: with SMTP id u4mr26716519wrs.50.1629908303911;
 Wed, 25 Aug 2021 09:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <2d9ca8df08aed8dcb8c56554225f8f71db621bbe.1629886126.git.pabeni@redhat.com>
In-Reply-To: <2d9ca8df08aed8dcb8c56554225f8f71db621bbe.1629886126.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Aug 2021 12:17:45 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeavsMkRtuLO1EqWjod9ua=Yp4UHnV15+xJJ_6P1gxc7w@mail.gmail.com>
Message-ID: <CA+FuTSeavsMkRtuLO1EqWjod9ua=Yp4UHnV15+xJJ_6P1gxc7w@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests/net: allow GRO coalesce test on veth
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 6:25 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This change extends the existing GRO coalesce test to
> allow running on top of a veth pair, so that no H/W dep
> is required to run them.
>
> By default gro.sh will use the veth backend, and will try
> to use exiting H/W in loopback mode if a specific device
> name is provided with the '-i' command line option.
>
> No functional change is intended for the loopback-based
> tests, just move all the relevant initialization/cleanup
> code into the related script.
>
> Introduces a new initialization helper script for the
> veth backend, and plugs the correct helper script according
> to the provided command line.
>
> Additionally, enable veth-based tests by default.

Very nice. Thanks for extending the test to be run as part of
continuous testing over veth, Paolo.

> +setup_veth_ns() {
> +       local -r link_dev="$1"
> +       local -r ns_name="$2"
> +       local -r ns_dev="$3"
> +       local -r ns_mac="$4"
> +       local -r addr="$5"
> +
> +       [[ -e /var/run/netns/"${ns_name}" ]] || ip netns add "${ns_name}"
> +       echo 100000 > "/sys/class/net/${ns_dev}/gro_flush_timeout"
> +       ip link set dev "${ns_dev}" netns "${ns_name}" mtu 65535
> +       ip -netns "${ns_name}" link set dev "${ns_dev}" up
> +       if [[ -n "${addr}" ]]; then
> +               ip -netns "${ns_name}" addr add dev "${ns_dev}" "${addr}"
> +       fi

unused? setup_veth_ns is always called with four arguments.

> +
> +       ip netns exec "${ns_name}" ethtool -K "${ns_dev}" gro on tso off
> +}
> +
> +setup_ns() {
> +       # Set up server_ns namespace and client_ns namespace
> +       ip link add name server type veth peer name client
> +
> +       setup_veth_ns "${dev}" server_ns server "${SERVER_MAC}"
> +       setup_veth_ns "${dev}" client_ns client "${CLIENT_MAC}"
> +}
