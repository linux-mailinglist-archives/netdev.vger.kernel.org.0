Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A707228313
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgGUPEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgGUPEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 11:04:46 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B5DC0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 08:04:46 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id ed14so9463762qvb.2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xcBXfL/2ghXmfWUhIUFmjDIyiJHk+JdIwC3C6WYMhpA=;
        b=nkEVU9ZU87N0ifRBVfB1q8YCi1RxVxmEu5RdvsDBXhFiPEL0+m0yusDrGS/FPQ3rV4
         xIvv4ogoqcsmhBb2zKHlT8evZyfcSrjlNRIDagEWf2bZJ+APn9ZNgdOWqtt3jSVKMQjc
         8jA9M3khDvpJ/TEVAbWFQNwBkiJyvtzM7IUzy0BA1NgrC9LRk93FKRVqtD9AEsVn6viX
         kgsPnKKqECnJc6sBS4aeiSeBZeS7SKdsRVwoyZ5zVYFPPkcY7RARcI5IxXIJT+kqyJKJ
         /9YzVuyStefKMLITBThkojKd8PUiTeZAmOJfUyw230YDsecfXsxPQHpsqj579b/xhvBO
         TQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xcBXfL/2ghXmfWUhIUFmjDIyiJHk+JdIwC3C6WYMhpA=;
        b=Z+mxMMPPCEuIG1fkIxA9XrHrb+tiYHP2vzgIf6+fG6CLSY6MYv6Dmwa4aRv76sPSkM
         e4B7pTC0vtOscN6kzcMrMvwuzxlVsCk+Uxx3cuTokno8zZeYYL5hOYxW9byPKofBj1uR
         V0XYp4YSei54pgUHezjvk4ViM7v8o52psD3Yc+ACIxQe1JZzHBrZT82U3GPf6KcdN2D+
         M25Vl3WfsPODoSHvckVw7r/JJP9wA0gblprfjqXvKv7ZKGjMIapxvIhfMsc6u6LsueGp
         NlWSnG99ySt+vOv3Z3x9017x9hRmyPopBFCZ9XEUexBFluE4W6NpQGaK6Ue+AHWh814H
         NtDg==
X-Gm-Message-State: AOAM531tjcJwyW9/0PfA19XxtgD06SPdYdJ9aNZQAKqizUP1EVzU5oVC
        KwcYH7Aqyl8gUwRcHWIIYstVmsxl
X-Google-Smtp-Source: ABdhPJylOR5eWhOFIwQi7+lij8erf6IFaF7/bX6a2PN5H7W7qkcACLRVCdtQsYKq7q0F7IRclbkFjQ==
X-Received: by 2002:a0c:fb47:: with SMTP id b7mr26979129qvq.129.1595343884547;
        Tue, 21 Jul 2020 08:04:44 -0700 (PDT)
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com. [209.85.222.177])
        by smtp.gmail.com with ESMTPSA id k5sm827637qke.18.2020.07.21.08.04.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 08:04:43 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id z15so12804804qki.10
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 08:04:43 -0700 (PDT)
X-Received: by 2002:a25:4886:: with SMTP id v128mr40285167yba.53.1595343882471;
 Tue, 21 Jul 2020 08:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200721145249.72153-1-paolo.pisati@canonical.com>
In-Reply-To: <20200721145249.72153-1-paolo.pisati@canonical.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 21 Jul 2020 11:04:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
Message-ID: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
Subject: Re: [PATCH] selftests: txtimestamp: tear down setup() 'tc' and 'ip'
 env on EXIT
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Jian Yang <jianyang@google.com>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 10:52 AM Paolo Pisati
<paolo.pisati@canonical.com> wrote:
>
> Add a cleanup() path upon exit, making it possible to run the test twice in a
> row:
>
> $ sudo bash -x ./txtimestamp.sh
> + set -e
> ++ ip netns identify
> + [[ '' == \r\o\o\t ]]
> + main
> + [[ 0 -eq 0 ]]
> + run_test_all
> + setup
> + tc qdisc add dev lo root netem delay 1ms
> Error: Exclusivity flag on, cannot modify.
>
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

The test should already clean up after itself, by being run inside a
network namespace. That is a more robust method to ensure that all
state is reset.

The issue here is that the else branch is taken in

  if [[ "$(ip netns identify)" == "root" ]]; then
          ./in_netns.sh $0 $@
  else
          main $@
  fi

because the ip netns identify usually returns an empty string, not
"root". If we fix that, no need to add additional cleanup.
