Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD1A4CB16C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245382AbiCBVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245358AbiCBVhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:37:22 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D9C5640A;
        Wed,  2 Mar 2022 13:36:37 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id g1so6186206ybe.4;
        Wed, 02 Mar 2022 13:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F9su24UUCpFbzNjnzich2MRj6bAe/1UrU40e7yTrYl4=;
        b=kJYAGOURvvI51nvUQxCcdujpjcu86BIy/7PcVFcAJWYVOU+VYmjLG9uxZrne+ZHDgf
         wtt7Kypti4GRddq2ZjajoyBnDi7tp09Cga9N7UzWlurwi96LioKSp8NONWFv5sT++x/h
         h1WBPZHYIaPO5XacD02pjmsgSaHO6XXw9lqnlBJZ8+nPI42KCQpKwvtxWQvQz8fKku5f
         gFc9tMlKx0mCEsRRlTZWPyER9U3zCGb/3DXO5eD8tMlpAluM0TeeXOqPHirtTqo8eSm0
         0QWH5oMH1IqlROCrEpPnw21RjBWG22y6EHp2rBGdiYKJDjOePeQLu1Vhc3lIvK4Imm4x
         p5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F9su24UUCpFbzNjnzich2MRj6bAe/1UrU40e7yTrYl4=;
        b=JWqXaFIgqrxP2j8EZHSwzPbAJyq5fDaTMNGghNein14AYt2H7EitiPgHHW+S3ZIs6x
         S3ht+ln75f74A7hetB+PqsVo+5QIBP82plYIAY/Be8Hbbw990+45Gj8vqSGHPeteybZh
         bUnmtWyjDgs0SWXPalE1DPfMnxmyKEuSdq7IzWJlHxrehBCnJGoK5Ez87tL6zq5fJT1X
         PR7yuwcaD9OuX/zo8Z8iB8lZzddZHvBaEVQCRPqavcc45SFLNPY24vUFektGNuLc9zne
         ALXl1qr/CIS6gHM8oHxSCOVh0UeBIAOX4yKcXq5/zVu/S2TzlUK/aW9EViDTyTRE3tJs
         Ec+w==
X-Gm-Message-State: AOAM5320W4XrRAGku9lyLkyp7z8Zr1teXjx+NM6uZmWzinFFWdJHhgT9
        dvFMlvnFTU1uNFKzS5JNQ1BLDr5+KxKnXRu03tY=
X-Google-Smtp-Source: ABdhPJw7BiPedTto2QQEQGe/650vKh+a92S6h573kPbrCj+bZkGHT0XJF4cXuWxFhf6Ef1veMooEo6KVj72th/wvP+w=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr29825208ybn.259.1646256996745; Wed, 02
 Mar 2022 13:36:36 -0800 (PST)
MIME-Version: 1.0
References: <e2c2fe36c226529c99595370003d3cb1b7133c47.1646252285.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <e2c2fe36c226529c99595370003d3cb1b7133c47.1646252285.git.christophe.jaillet@wanadoo.fr>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 2 Mar 2022 13:36:25 -0800
Message-ID: <CABBYNZKpZ+tA0YuBFzwug-W3Bcx9GuL4hcrPSfSQt0VnbZi58A@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Don't assign twice the same value
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Wed, Mar 2, 2022 at 12:18 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> data.pid is set twice with the same value. Remove one of these redundant
> calls.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/bluetooth/l2cap_core.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index e817ff0607a0..0d460cb7f965 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1443,7 +1443,6 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
>         data.pdu.scid[0]     = cpu_to_le16(chan->scid);
>
>         chan->ident = l2cap_get_ident(conn);
> -       data.pid = chan->ops->get_peer_pid(chan);

Perhaps we should do if (!data->pid) then since afaik one can do
connect without bind.

>         data.count = 1;
>         data.chan = chan;
> --
> 2.32.0
>


-- 
Luiz Augusto von Dentz
