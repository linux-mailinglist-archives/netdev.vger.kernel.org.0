Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF866C3D6
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjAPP3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjAPP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:28:34 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1844721944
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 07:23:55 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id d66so16906738vsd.9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 07:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJh6pq8lTaLk7cR8LAvrgbsbP2aj9+a9ROA9ONrBwCQ=;
        b=qkRNuHTwBzacSlvnT7CL5P38Wm3jvRKIqR+r91eFLIQ1Q47WSZngyXuE2sskkTalIz
         STlYdimCEiocJvTs9aukfc9ynkpyKqryQjfPxtghi80fF2Ioa87spdTgOuk/uAAqoBrw
         QU0spnpCfqsO6hyEc+jfGR++8GmDRNwwLJ1j68t7Dkeux/sGG3ZSAw5+5sLjO9tDQe5X
         FHFqPVt82x6zXrKqE1vVff6gd46RtLXvnNI8rwCo9fffnE1tB9XyJ2llhmIsN5g7XC7M
         Zjwno7UvsF3r2LC6n9nbBom8Y6GvjHnjlVNOYf7nO6UKcYEY5wxNrJkQ4ON923r68ada
         XKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJh6pq8lTaLk7cR8LAvrgbsbP2aj9+a9ROA9ONrBwCQ=;
        b=fMvkqbA8jtFI7o17PooX/Ozm5WlKDom2cT92ilnq+ud+NZn9QFk3CTIcLSEQFPveMA
         HNxqG3HhCHD+7heaqwGtl2ooeMI96A1MgGkJKkTNQXAn33voGlWNTW7R+nzX+ipAK/8s
         KaKuTkIAoeFZ+ShKSqIR4aPMbrc53s5mdsDCA7+TUduhbWDHys2P1tNAuBvP2KHfcrrD
         1zZu5aotbDKgrbmdUXhUcOyi3P3RHtO/yQgiuxnmiB1oIFaGgb+jxcyjmV8tnxhCCQpG
         cJTgo9bSAJeBqApulfibQRn0NflwI8ktjbPFhiw6SDxUhj/wFTXnQGzyNTYrgDGq1zaf
         27rw==
X-Gm-Message-State: AFqh2kqLw3U/rQa++0CVmfDdrrUkh7g+Lv7VKWvQsWVEx/AxXxBXtfcL
        OguznTnb4+ojBHPiwY+Cs1G1q9Fs+1YzRzejjPJhg+Z1TeTlPnKnqJI=
X-Google-Smtp-Source: AMrXdXuuO+GpjI39hzOFncvd90F6kzYe1N62/z80RitdYILQJr3DufE3k9xZ3a11TcMZsIUTIO23c6r7wdndWQVtJTE=
X-Received: by 2002:a05:6102:41a4:b0:3b1:27c0:5ed1 with SMTP id
 cd36-20020a05610241a400b003b127c05ed1mr12945874vsb.4.1673882634042; Mon, 16
 Jan 2023 07:23:54 -0800 (PST)
MIME-Version: 1.0
References: <20230116112739.ritnefwxhc5nyfqi@zenon.in.qult.net>
In-Reply-To: <20230116112739.ritnefwxhc5nyfqi@zenon.in.qult.net>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 16 Jan 2023 10:23:37 -0500
Message-ID: <CADVnQymmxSkCwxbTiCOBXCPcpVfqu=CB-o0wZ=eX3_k6Ut4-ng@mail.gmail.com>
Subject: Re: Much higher CPU usage when generating UDP vs. TCP traffic
To:     =?UTF-8?Q?Ignacy_Gaw=C4=99dzki?= 
        <ignacy.gawedzki@green-communications.fr>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 7:07 AM Ignacy Gaw=C4=99dzki
<ignacy.gawedzki@green-communications.fr> wrote:
>
> Hi,
>
> While running some network performance tests, I discovered that the
> CPU usage when generating UDP traffic is much higher than when
> generating TCP traffic.  Note that no significant difference of CPU
> usage was observed when simply forwarding UDP vs. TCP traffic.
>
> This happens on Ethernet, on Wi-Fi, even on veth links (but not on the
> loopback interface), so it seems unrelated to any specific hardware
> driver.  BTW this difference in CPU usage decreases quite notably when
> generating UDP paquets of maximum size, resulting in 64 KiB IP paquest
> getting immediately fragmented to fit a standard MTU of 1500 bytes.

Probably a large factor here is the TCP support for TSO/GSO.

There are probably mn
This article has a nice discussion of some of the main issues in UDP
vs TCP performance:
  https://www.fastly.com/blog/measuring-quic-vs-tcp-computational-efficienc=
y

neal
