Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C455D24A1E8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgHSOjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:39:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727072AbgHSOjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597847991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FbsnLY9rKkobFTZIKxecpfsJvpNNawkeoUCvEimCuCc=;
        b=cY+hUPY4yPBWVc96i4cpHsK+jR4RvynatropWIDatReSQJr6cxLIK3N1xHpz5ax20GNJlf
        Htalkoc/ztHONG/mVMbhRkS04USJRnP+9r9d5v5vtujXoWJS9VQXB4DwqzlTI85+1qQCKa
        e5NDDXX+ld+1UonCCf78ndpK9zhCv/g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-gbxRVLtGOV-fdSIsLZF94w-1; Wed, 19 Aug 2020 10:39:49 -0400
X-MC-Unique: gbxRVLtGOV-fdSIsLZF94w-1
Received: by mail-wm1-f69.google.com with SMTP id c186so1100104wmd.9
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 07:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FbsnLY9rKkobFTZIKxecpfsJvpNNawkeoUCvEimCuCc=;
        b=C7zSpIPc8XYuS0Sh3eWRkno0nYINUkr/EtVqSxeB3MruYY2rnmflK7T1cr12MVqMDl
         PlPpPqr+5txAXPmMAvtWpx225PjKYS0OiWmrcTrlpP+o63pOoCdIrbYUZnHqkd76JUne
         5hi2F0IFjRQrbjT1MNqD/HICR4abaC/Bcms7ovqd/iCeixM88czmT456ntm8KQ6lq6eo
         Ji46Qoru4JnNGwCkg4uUozKhODPwcjJenFMgEM/7c4g1Crnj0HUZPdA4cH6DAVuyMAB+
         1MgVO5QZ0AKRr2uyWjI/Jxj8OVgXiSOM7kQH8WRYWs199P6YCDJnnDrBpIboKnUpVE3O
         Mmzg==
X-Gm-Message-State: AOAM531sgRrGR4HI+trkrpzLx4Vpb7QVbX9rShTuWxhgvWmtSqwCNyqg
        dWOUY0fzFGMR6WXqE/IT6wuX2LQkRXjOnUE35ChzJJ5P7k5wAr0GAWW7g22gnSyMdoD2SSZmGdk
        qE3AbH6UB5whhHAmE
X-Received: by 2002:a1c:b443:: with SMTP id d64mr5702116wmf.68.1597847988801;
        Wed, 19 Aug 2020 07:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyESO9tY3SC/TsbFL+82UpS0RG6FkakxcRfLLk+J/ZHSgrHlQcsjl4YHHeQCicvNi05JwEY1A==
X-Received: by 2002:a1c:b443:: with SMTP id d64mr5702098wmf.68.1597847988612;
        Wed, 19 Aug 2020 07:39:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w1sm5599495wmc.18.2020.08.19.07.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 07:39:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2D3A6182B54; Wed, 19 Aug 2020 16:39:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, andriin@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, ast@kernel.org
Subject: Re: xdp generic default option
In-Reply-To: <20200819092811.GA2420@lore-desk>
References: <20200819092811.GA2420@lore-desk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 19 Aug 2020 16:39:47 +0200
Message-ID: <87eeo2pumk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Hi Andrii,
>
> working on xdp multi-buff I figured out now xdp generic is the default choice
> if not specified by userspace. In particular after commit 7f0a838254bd
> ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device"), running
> the command below, XDP will run in generic mode even if the underlay driver
> support XDP in native mode:
>
> $ip link set dev eth0 xdp obj prog.o
> $ip link show dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc mq state UP mode DEFAULT
>    group default qlen 1024
>    link/ether f0:ad:4e:09:6b:57 brd ff:ff:ff:ff:ff:ff
>    prog/xdp id 1 tag 3b185187f1855c4c jited

Yeah, defaulting to xdpgeneric is not a good idea (and a change in
behaviour; I get native mode on the same command on a 5.8 kernel)...

-Toke

