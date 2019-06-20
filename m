Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA1E4CD62
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731722AbfFTMFA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jun 2019 08:05:00 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42684 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731678AbfFTMFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:05:00 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so4336455edq.9
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 05:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HG+KkhYMDkBh6yTSLxKMxMt66aeJ+AV/PAMDiZRpj78=;
        b=GZp3g55Khzhycgis8YhU65cWq9aDT0mv1jJCNbs/MMJYkKSZcKl5NFw0EcQZSFxrv6
         NjIWsHY8D0qgfI9s2vAgKzYwuiT/Q4UeTO5+44+PGyEWfmKhxxtj3iqZxdcYxLeZZ96G
         7zX6TBs88OLKQ9RttsxJ06suGpJnqpTv5F/N8jJhhahQo9HtnCUCi7PnS9WkkRoVzfEe
         dyy3U9tpcgwGhZzHKiFL5iOGnRdTcsaN8DK6svuAf2I8WJnymnVAPrO0iUB3MPMkbo3+
         tKGfPSz5BROS4Wvevf6uxK38nkLafvxYHTaivEtBjEr/dQNFfIW4wGVIgOl9dYWwckld
         ItBQ==
X-Gm-Message-State: APjAAAXHHtni/j7DyJW90GB1ryQ2d/G5C+wgGDq/+GniMqKtww1CHifg
        Uku0BmwDJagR4GDHNGRyysQK3g==
X-Google-Smtp-Source: APXvYqzsZFWB0VaHqfx6NP6Jbe+EWR9eOWHHs81WS6UsqOyYfeLG3lCdiBEgYgeyU8yq/xkQSmsBmg==
X-Received: by 2002:a17:907:20db:: with SMTP id qq27mr90675612ejb.30.1561032298590;
        Thu, 20 Jun 2019 05:04:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id d28sm7091780edn.31.2019.06.20.05.04.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 05:04:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 714E3181CED; Thu, 20 Jun 2019 07:57:11 -0400 (EDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] samples/bpf: xdp_redirect, correctly get dummy program id
In-Reply-To: <20190620065815.7698-1-prashantbhole.linux@gmail.com>
References: <20190620065815.7698-1-prashantbhole.linux@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 20 Jun 2019 07:57:11 -0400
Message-ID: <87muic8o6g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Bhole <prashantbhole.linux@gmail.com> writes:

> When we terminate xdp_redirect, it ends up with following message:
> "Program on iface OUT changed, not removing"
> This results in dummy prog still attached to OUT interface.
> It is because signal handler checks if the programs are the same that
> we had attached. But while fetching dummy_prog_id, current code uses
> prog_fd instead of dummy_prog_fd. This patch passes the correct fd.
>
> Fixes: 3b7a8ec2dec3 ("samples/bpf: Check the prog id before exiting")
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>

Huh, I seem to recall fixing this for the other example program, but
guess I missed this one.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
