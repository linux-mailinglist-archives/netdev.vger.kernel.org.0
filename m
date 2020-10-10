Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCB28A41F
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbgJJWzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731485AbgJJT33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:29:29 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDBCC05BD3C
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:40:53 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id d19so2545591vso.10
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7jeb16lRM5LMeo1k5VR2Q1IFEg2gMmCB/ThZMz7WgeI=;
        b=Wjq41WLHmyYE9lcbNu00wdLSv1ai35+oB1KtAB+D0Po5gV57Ay9diDEtHa99UXuqnf
         LNrnKlPm3eNBr+qWhTU1k7kW9VuWdLEgAQnglDO2/zrPJQe+cdWPDDbnaeXoBXtN4gA5
         1UuWo36cHMSAsCyLdOdRbMOGY3jxicoqgRQsNM5ZgPq8QIhDfQVDh5aRrl4Tk6PwfS/m
         R+/BhXv38H/wdJNlQ+IOULr++uyhRf9XRFs6NKB9X/5M+cjLxGH7HfcuqjL2I5NvXjPN
         oia6zDXQ8RmCkPP6F0aIk+7RU72Hy60XQi/1j7jlsW1eTVz7QU5795XqV1EIYBYP4zrp
         BOSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7jeb16lRM5LMeo1k5VR2Q1IFEg2gMmCB/ThZMz7WgeI=;
        b=ASDehXX9dc0RqT4PSb9yCENHa0+kMRncHXdpbQwACvqTBRYvFto2fYPqRg4oZFtpA7
         CuIx5dCWlakJ3wWK9wqKhYYSek2PbbrV05wPNzvHNRSruGJhdKracEyovcppbxycgx2c
         SQpK5h35SkJ5hYU4fZnCkwx+1z3PK6QLCnINwhfo2qf34BxZXIGXuAGYIDpqT/Om1xxp
         k3KlZDTYv6D/rvahjfcMGe0oKdFkkX/PCFfLrLLgeIEtwytI3P/h85+jQhagz9DfD0sh
         7fkStdC+JdXDT5boNQHNhW4nKRATif3MmWRxrEjBJOiQ6cSQxtd6dD9v2a3dSjoRULBt
         K/Jg==
X-Gm-Message-State: AOAM531h3pwf+8qxqjrVCZkf5s5ThtUKhc9EaBuVhA3bmYle90zwBaky
        4ZqmP3fs5pTm/Za19MVNRk9NrY5pkUY=
X-Google-Smtp-Source: ABdhPJyEi6h8cHu987lSNXZ5rHeQXUjwOLKpFaSTEChwAFhbSnF3woiX8nnVh68dgjHYQn2LjNN0Cw==
X-Received: by 2002:a67:2bc5:: with SMTP id r188mr10616423vsr.16.1602348051184;
        Sat, 10 Oct 2020 09:40:51 -0700 (PDT)
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com. [209.85.221.176])
        by smtp.gmail.com with ESMTPSA id q23sm1692905vkq.18.2020.10.10.09.40.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 09:40:49 -0700 (PDT)
Received: by mail-vk1-f176.google.com with SMTP id p5so2204472vkm.4
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:40:48 -0700 (PDT)
X-Received: by 2002:a1f:3f4d:: with SMTP id m74mr9927092vka.12.1602348048486;
 Sat, 10 Oct 2020 09:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201008190538.6223-1-dwilder@us.ibm.com> <20201008190538.6223-3-dwilder@us.ibm.com>
In-Reply-To: <20201008190538.6223-3-dwilder@us.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 10 Oct 2020 12:40:12 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
Message-ID: <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
Subject: Re: [ PATCH v1 2/2] ibmveth: Identify ingress large send packets.
To:     David Wilder <dwilder@us.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 3:06 PM David Wilder <dwilder@us.ibm.com> wrote:
>
> Ingress large send packets are identified by either:
> The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
> or with a -1 placed in the ip header checksum.
> The method used depends on firmware version.
>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
> Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmveth.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index 3935a7e..e357cbe 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1349,6 +1349,7 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
>                         int offset = ibmveth_rxq_frame_offset(adapter);
>                         int csum_good = ibmveth_rxq_csum_good(adapter);
>                         int lrg_pkt = ibmveth_rxq_large_packet(adapter);
> +                       __sum16 iph_check = 0;
>
>                         skb = ibmveth_rxq_get_buffer(adapter);
>
> @@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
>                         skb_put(skb, length);
>                         skb->protocol = eth_type_trans(skb, netdev);
>
> -                       if (length > netdev->mtu + ETH_HLEN) {
> +                       /* PHYP without PLSO support places a -1 in the ip
> +                        * checksum for large send frames.
> +                        */
> +                       if (be16_to_cpu(skb->protocol) == ETH_P_IP) {
> +                               struct iphdr *iph = (struct iphdr *)skb->data;
> +
> +                               iph_check = iph->check;

Check against truncated/bad packets.
