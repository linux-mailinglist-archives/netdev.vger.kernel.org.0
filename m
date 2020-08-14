Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3AD244ED4
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 21:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgHNT2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 15:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHNT2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 15:28:01 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03379C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 12:28:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 88so9294469wrh.3
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 12:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0TJz1kLb0QG2pucP32+cKX2tfonFz920DYFhEJML22g=;
        b=k2FaGmcZP7IT82JsWX8cTC8sRSrjfZFeXTjmEndRypH8yKwLApSKFznE+ioaSs0EhS
         CMl2vpGDjLsDmqVQai/05M6DPxPIiulpenp3ovpEV570vLl24dENz6ukKMNaQS5lnFJE
         odqWhDKWBBxtu9NjZJySWPfL7LqBJFB0gp85S8cCNtz2UngaJySwd+5SDHcNVP6vnnCm
         5DKWTOvf9+CXD/4IFTuejKfSCoosVt1vPIvGFUfXWlRLSP+3yTjgwEzPjRZklTpQJVg6
         TZ5S3FEYFb/PDlcY/QqGJRovOnrqssELeelK7ANBavON8z5QtbaWPQARpdyeBGhOTMUT
         x9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0TJz1kLb0QG2pucP32+cKX2tfonFz920DYFhEJML22g=;
        b=Pc9CfG7Tl9q2JCJoyiRVbPyD3SYXb/Fh6kvkeVJD9CAr69zROA3nTdnOvMR93I+o0q
         dWE5rqnguRVKAmJ93IARSPb99KJKdec2cPuZMpODdbVJvF+J+d6k5ekJYtqeRpHOgjNm
         V5zLNLqgP7S3BHhN8qrJ3Fpi+dPM/MAaDN8YFNORg/Y6oGiL1wJg46frR/CmEs2WDfDY
         OlCNwDiEpYTJqP+u39Obfo+dhSGG5AkbLuhpDQqMnnUMeuFJojd+R7+btZ6NMcEtyfeh
         PW9S5yES65UQQkC6y7yq6liu/mJH6OfT44TWD0IC5T8o7ZCmn8hoFE9GgL8b/Mco5U3w
         rhVw==
X-Gm-Message-State: AOAM531iSBVN77u3Omv8M4RBtIa+FHtKYUCKikz3IrHYpLCmAJkZ+qlg
        VQEQB2zTdqTtWw0h6LIrYcT9fcy5/KCjn9kGigvN
X-Google-Smtp-Source: ABdhPJxbDEXKOBmxkzJaC7PVVpd1jbi1yF1/ZgMNNO04fETUUB/XMAV8Sl86m1rlxIl5fwU53bY2VtdRm2jLtk4TlvE=
X-Received: by 2002:adf:8405:: with SMTP id 5mr3878667wrf.393.1597433279392;
 Fri, 14 Aug 2020 12:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200812095639.4062-1-xiangxia.m.yue@gmail.com> <20200813.155348.1997626107228415421.davem@davemloft.net>
In-Reply-To: <20200813.155348.1997626107228415421.davem@davemloft.net>
From:   =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>
Date:   Fri, 14 Aug 2020 12:27:47 -0700
Message-ID: <CA+Sh73OVgGEVyhqenXm7HpT4fQfLeZVc+SHWO90iiW2QXkcEQg@mail.gmail.com>
Subject: Re: [PATCH v2] net: openvswitch: introduce common code for flushing flows
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Gregory Rose <gvrose8192@gmail.com>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, dev@openvswitch.org,
        Netdev <netdev@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 3:53 PM David Miller <davem@davemloft.net> wrote:
>
> From: xiangxia.m.yue@gmail.com
> Date: Wed, 12 Aug 2020 17:56:39 +0800
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > To avoid some issues, for example RCU usage warning and double free,
> > we should flush the flows under ovs_lock. This patch refactors
> > table_instance_destroy and introduces table_instance_flow_flush
> > which can be invoked by __dp_destroy or ovs_flow_tbl_flush.
> >
> > Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on destroy=
 flow-table")
> > Reported-by: Johan Kn=C3=B6=C3=B6s <jknoos@google.com>
> > Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/2020-Au=
gust/050489.html
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Applied, thank you.

Tonghao, does the following change to your commit make sense to be
able to apply it on 5.6.14 (e3ac9117b18596b7363d5b7904ab03a7d782b40c)?

@@ -393,7 +387,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)

        free_percpu(table->mask_cache);
        kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-       table_instance_destroy(table, ti, ufid_ti, false);
+       table_instance_destroy(ti, ufid_ti);
 }
