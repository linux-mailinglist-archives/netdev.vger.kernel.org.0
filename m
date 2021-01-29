Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1F630861D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 08:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhA2G4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbhA2G4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:56:03 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF32C061573;
        Thu, 28 Jan 2021 22:55:23 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d13so8274570ioy.4;
        Thu, 28 Jan 2021 22:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=//TCrMqV+EN5GZ5kO4qJoRgPAr9PfhXd/Fec/wQrWV8=;
        b=E0IXe8Vo4/tMdLmz383Ch20F3ZtFceSFb97KDmWJjN6SFc/66yALcHdXvx8zvLb1ZE
         GwlG9jxQyz6ZC7xph6DgVAG03vUSm0HsqMjx+4lfsz37yKXah/wu4LQwLJekDERmAVDV
         p9V7FzPE8eJPVAF2J34PjrmfsYreut10xERVgoJZurBLTXz0RbwwQRwFnR1/4CtSiLwR
         B4bgb2Q7iwc7YvCxnvOGJb+FQeJxpB3vSJbXvSCdAR0hD2adE0BoXMD3/meXFfxoItFU
         bSu9mMey+y6vFBSo680uJxHZgFsb/lcxuLsBATJ5NwWMOE8WhnUUfWwnUj+tLX0oxHNE
         mPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=//TCrMqV+EN5GZ5kO4qJoRgPAr9PfhXd/Fec/wQrWV8=;
        b=eJQGtPOOW4auzdVc9EkhJBY9131r10CeRgER0GaSkxf9dCJ1+hQhxV5W4/bynVMIfF
         6dvRDsrydZSl1MD9L/7yz9PVN//IGLv34sekSWCZHuZBSoWYfgmVKC53hmK7ujZR/40i
         OqqLtMYOTBF+b8zrJN1eHS50SGB/rV+GAHLWs75zuWES7iatmgro/gtsm6WrIFSstluS
         apxqKxCNMijCFxLqUo7hB4J+vpqkSLcJmE01JJ9Y12Z986qEijX06uZe1tqfEhJr3iKG
         R7HifZ3sx+LnE5r/8D153svOxWDjKj4ZglOIzcGxyPFHRYDXSW5BHAVo55Sj4xbhI7oS
         PKTg==
X-Gm-Message-State: AOAM531T/ycFn5PqXO4+NukQWij+SWhD5yL+xeKo9s4EPNER/hvSp1sE
        zykqaghOBnVu4WfxpJ4gJBM=
X-Google-Smtp-Source: ABdhPJxV6Hx5vaAZQZFKWiMB4lZRhViJagOAK20NF6nSe97/gn6fcYx0s+R3tDt5XImQluooymd+GA==
X-Received: by 2002:a02:9669:: with SMTP id c96mr2442919jai.47.1611903323076;
        Thu, 28 Jan 2021 22:55:23 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id r7sm3965587ilo.31.2021.01.28.22.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:55:22 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:55:15 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Message-ID: <6013b153d9e91_2683c2086c@john-XPS-13-9370.notmuch>
In-Reply-To: <161159458253.321749.4626116952494155329.stgit@firesoul>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159458253.321749.4626116952494155329.stgit@firesoul>
Subject: RE: [PATCH bpf-next V13 6/7] selftests/bpf: use bpf_check_mtu in
 selftest test_cls_redirect
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> This demonstrate how bpf_check_mtu() helper can easily be used together
> with bpf_skb_adjust_room() helper, prior to doing size adjustment, as
> delta argument is already setup.
> 
> Hint: This specific test can be selected like this:
>  ./test_progs -t cls_redirect
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
