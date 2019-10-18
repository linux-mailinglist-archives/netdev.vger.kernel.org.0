Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B08DD551
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732763AbfJRX1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:27:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44891 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:27:46 -0400
Received: by mail-qt1-f194.google.com with SMTP id u40so11488681qth.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pIIERnZFKY1f0jc9H3Cykl1prQG4BDlyOgMmrh0Tb9I=;
        b=OOjCw69kqdoOHXJ1W07K+hRZWq1xR0XO4JGQqiLiqPbNUca10eXyDlJhCiPz7egXu5
         /bQl/KguVx6rIpin/gwZ56K/znWkJ+52Q69zkX6XyS3+PjwOcbstObKX1hH6ITjZHiSg
         x9hyTzLzdfE3DkBpzgSQq/TfwHsTxRQMwc2BdoeIJT1Oru9ik2bwB353e9AAa1Xv+FIU
         gD0g+7nw+j+MImMiNbABrHBELnzLeyZ9G3AfCtnK96s2i4Vq9z8KfuxO8ZwqLmM7XvyD
         rxISyRV1ZSOMO1k58YaHIe7h2LdNPqWQafO0lN7bKec66F8rI7ElE7VFXWCUB9nkODNB
         FiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIIERnZFKY1f0jc9H3Cykl1prQG4BDlyOgMmrh0Tb9I=;
        b=tH/LGoJjB2srDWsYVm53/FmrcVKhOeJUkT3jhPpbzJqbJrfoSWA8G+Nwhg+LrIT+ev
         /VU/L/2/ZZuBAFHTE6/EY7t7pDo3YAKteLBQSPNlTS7YnTaTMSa1flmbSNaU5JkDL/bh
         LF1YwYfsApAFdf64OJ0wtXQqpq6hgV6FhV9Lv71tSX1Wj37IwFZpnAhYFSAkAosj9aYn
         HaSHRF61vk9xBPf1l519uhHjGOjFZbwMrO5GWnjFhUcjOwgYq+g5pNhYsd9qIaPNR6Rv
         olevfbxOqE9qrrWdjxYR4EOfm8GsJMGPqati3jrXNipFMifTZgxVrnLmrwKcWFa4KpTH
         EzDw==
X-Gm-Message-State: APjAAAVfeSCCM4Dj5fwJNGcSWzB8eJB85pGmVCGCrt1yDNyB22JZqFiO
        szxZILD1Lqhgpq3IHn4mJ8NZZLeRWRPetexPfGt7Exjl
X-Google-Smtp-Source: APXvYqyEstx7f8MPFqnVUPMmbOE4vhZBOkf2ZMHqcb9r9AFMi9nIaXhW9chzmKMFW62zfS0HKVH+ruBU1JORE5jE7Hs=
X-Received: by 2002:ac8:23e8:: with SMTP id r37mr12885283qtr.365.1571441263788;
 Fri, 18 Oct 2019 16:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-7-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-7-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:27:07 -0700
Message-ID: <CALDO+SZ8AR65E9qqxO6MvrRiJrwSy10uK0Ex=hjYBmyJL=2SXA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 06/10] net: openvswitch: simplify
 the flow_hash
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:54 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Simplify the code and remove the unnecessary BUILD_BUG_ON.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>

>  net/openvswitch/flow_table.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index a10d421..3e3d345 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -432,13 +432,9 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
>  static u32 flow_hash(const struct sw_flow_key *key,
>                      const struct sw_flow_key_range *range)
>  {
> -       int key_start = range->start;
> -       int key_end = range->end;
> -       const u32 *hash_key = (const u32 *)((const u8 *)key + key_start);
> -       int hash_u32s = (key_end - key_start) >> 2;
> -
> +       const u32 *hash_key = (const u32 *)((const u8 *)key + range->start);
>         /* Make sure number of hash bytes are multiple of u32. */
> -       BUILD_BUG_ON(sizeof(long) % sizeof(u32));
> +       int hash_u32s = range_n_bytes(range) >> 2;
>
>         return jhash2(hash_key, hash_u32s, 0);
>  }
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
