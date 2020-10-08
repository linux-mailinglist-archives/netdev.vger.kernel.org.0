Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A5E287CF6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgJHUTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgJHUTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:19:48 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6E4C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 13:19:48 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id r78so1606792vke.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fQf6r2JMGkCPIjSjkajiQ9DgFijRPXMGJ//ZUAyC4s=;
        b=N8fd4y2OoJsfOsQBGSArjnRk68ndhcvccAYWElwGA3ETHesFHEx/NtGpSWtWt2Kvt9
         qn8izhoOrZcjCREI5eeuc42pStPBYsaiiob32SGigN9RUcLQZj0qclJKwZYGPi3YxqYL
         /TZurNg7feoqSzwgHHAR2+KZ4r+6IYbMN0SmYtwZjruMMPIFegxivWGurOFmoqMBxWzT
         pBHpi2CVmbpk2MOK2xJxx/PTnvXmu6jFeWFpEmvLiEubE7cUfh8Z5j4ciOrL32gpxVmL
         Z2r5dA9C7vA/ACC5kd3WGGF3uvLc9txZRs2Pz73WF7stJ8aO9vwwKf4bTfOF24CJJc5H
         Z9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+fQf6r2JMGkCPIjSjkajiQ9DgFijRPXMGJ//ZUAyC4s=;
        b=XBCsnq1fGJ4/UE0hzplEtb1mOjzZ4kAK711XT7y7xx8ACIT2RzRyyyOAfbK0Iys4xU
         bbz8nYdlRdreNCLUMFyASDPSlyVnMAv5vonfRuLY/Dor0ctkMfDMyjVc+8zA+KGUuafe
         d7pQkzqicS2zyAnJxqy/u+v9F8puInHJ5RPT0cDNsqtRrDYLb8kOqt7BrT5IrcHXTfuu
         uv/+8GCIi7CxCGUrWaYsyX1hBKNIum2tBM3fDhv1t/6jlPumPFAWN5f6WRfQV1Ty6WEO
         sYOjpiBzupS9taRfNJFN6/4nbLd9NqSObh1ykFj7AWq3/4V+PhGX2mkzxwuwD7gCB36r
         5RJA==
X-Gm-Message-State: AOAM531xLwaToOIr33MvcdlvIqKzJ57LudqUr+Aq6tDTX/rzolgFcOiC
        dAKWdcLq+/WOytG1F50/ZaijX6Bss9o=
X-Google-Smtp-Source: ABdhPJyL0ySKAXfwDO6olznhur2yIJqrLPS8POMdLjgzpBOrhsLk6Df8kLtmk5F6/2DK2gW5rl9JzA==
X-Received: by 2002:a1f:19d1:: with SMTP id 200mr5993908vkz.20.1602188386743;
        Thu, 08 Oct 2020 13:19:46 -0700 (PDT)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id v76sm861512vke.2.2020.10.08.13.19.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 13:19:45 -0700 (PDT)
Received: by mail-ua1-f44.google.com with SMTP id d18so2313187uae.0
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:19:45 -0700 (PDT)
X-Received: by 2002:ab0:6495:: with SMTP id p21mr5972181uam.108.1602188385086;
 Thu, 08 Oct 2020 13:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 16:19:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfcefUt5EkWEUh3FzDUiCuEcDSJ4KP0wu_U+B_btuecQA@mail.gmail.com>
Message-ID: <CA+FuTSfcefUt5EkWEUh3FzDUiCuEcDSJ4KP0wu_U+B_btuecQA@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 9:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> conditionally. When it is set, it assumes the outer IP header is
> already created before ipgre_xmit().
>
> This is not true when we send packets through a raw packet socket,
> where L2 headers are supposed to be constructed by user. Packet
> socket calls dev_validate_header() to validate the header. But
> GRE tunnel does not set dev->hard_header_len, so that check can
> be simply bypassed, therefore uninit memory could be passed down
> to ipgre_xmit().
>
> Fix this by setting dev->hard_header_len whenever sets header_ops,
> as dev->hard_header_len is supposed to be the length of the header
> created by dev->header_ops->create() anyway.
>
> Reported-and-tested-by: syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com
> Cc: William Tu <u9012063@gmail.com>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

> The syzbot report has the information for both of your questions:
> https://syzkaller.appspot.com/text?tag=CrashReport&x=11845568500000
>
> It clearly shows packet_snd() and ipgre_xmit().

Thanks. I hadn't thought to check that (clearly).
