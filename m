Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB981B53EF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgDWFG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWFG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:06:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38061C03C1AB;
        Wed, 22 Apr 2020 22:06:25 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id g4so4844705ljl.2;
        Wed, 22 Apr 2020 22:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jitVLzCzbHccVIgiEUXHrtF6n1Cmt04QAZRKLzrNRNQ=;
        b=R56W6NFt+e5ZS3QPpc5TZhTeA4dVrUh7IFqFeUn791DZpOPW8BkqSQiBbQsMzXkRBo
         civn7R+RUwuRJqPgsUSB2Rgs27ydJ0sAG8EuOCVkRnPNKtNNftvZwdEudm6TaOyY3MU8
         Kssy21kuBhXX8Nfi3lFwzMtvUDM7712ipBYrIZ/5jKouA0ruls+RqsjSTPk75ZOsPcok
         pLUoABPPyuhF6+gD91S+yXtmLqDLEZlrvbEEB4v8ka2NiFiwLHvNyTNOSxwLSU4DiH6/
         FL4xZsL5rAAV3/uUI1Arw47VF8zvJbo9p9O7CDAt1+YH2Yj3eBqNnIFiylP6b7klqYWe
         oyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jitVLzCzbHccVIgiEUXHrtF6n1Cmt04QAZRKLzrNRNQ=;
        b=uXqwc9rULFiiKH88rLZ0/ajroEYSevd1KATWAJfWL7x0tmrhROnL5N5a9NuKgO6hgm
         kQZVmFq1CPpsT47/dyeQkcW2K5N7DXbteHkc1HPwFBJw2YxRT6BIRnmJyaQfauDF9SCb
         9ifzsEZCBO7P/X+AxpOtrZbMdptou4MYcLUXucrhmqfxWPj8CITCmabI4eWWqjcKwFqT
         QrxZvNuf1R/0AvC1K87/AzwA0V0kzU5kD3J/E6zifwRaSva1Px3xNb/W6DG+W+bhSWXE
         MECFpFOZWwePVB/EJUrc83GTLCa3Q63nmYmf2cU+xMTzHa4+fPfSnZ5P8v+d0eSceP6s
         Q9nQ==
X-Gm-Message-State: AGi0Pua3AANiwrTa063AEnmFBpgeyYnJWcRYdLRbUXOGU+7VFKKs2XQ6
        TF/ML+GPY2urujkhbB+8At92UwlyVhi3mdPQ9NU=
X-Google-Smtp-Source: APiQypJ/zDz0hcc6CXOCX3H0pPXu7yDUdkc7aERNsItpzBhKuSONl9iuHK9NUBnpdD2YUdP+c1jFgsvDHlL2ra5Esoo=
X-Received: by 2002:a2e:b17a:: with SMTP id a26mr1146628ljm.215.1587618383453;
 Wed, 22 Apr 2020 22:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200420031634.1319102-1-songliubraving@fb.com>
In-Reply-To: <20200420031634.1319102-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:06:12 -0700
Message-ID: <CAADnVQKhqP=iXQYo+_osmacCuHiy2WhRtpZAHsY9HT0_D=aAAQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 8:16 PM Song Liu <songliubraving@fb.com> wrote:
> @@ -971,14 +982,14 @@ union bpf_attr {
>   *
>   *                     int ret;
>   *                     struct bpf_tunnel_key key = {};
> - *
> + *
>   *                     ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key), 0);
>   *                     if (ret < 0)
>   *                             return TC_ACT_SHOT;     // drop packet
> - *
> + *
>   *                     if (key.remote_ipv4 != 0x0a000001)
>   *                             return TC_ACT_SHOT;     // drop packet
> - *
> + *
>   *                     return TC_ACT_OK;               // accept packet
>   *
>   *             This interface can also be used with all encapsulation devices

Please avoid touching random lines or were they meaningful?
In such case separate pls put them in the separate patch.

The rest looks good to me. Please add corresponding libbpf support and selftest.
