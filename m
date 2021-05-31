Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440263967C8
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhEaS0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 14:26:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhEaS0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 14:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622485479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ZTyS8OALHEqITSxfehy1CmNLlMZGuyCOsGuJTxDUp0=;
        b=Y2yQBzSgT7q3vWsrBWE0iaV2UetGIbPWNgiNjmY+rZcBOz1j1oVe4D5K8ThluKONwBVkCA
        1Iwt8InHL5E+aMZ2H8kLDcsa8PZ+eyO5/j4uFjxyfyDQH/T+chPnm4X9DciDUMkC8+BMOm
        pa4+OhEtcOEOFqQ3elyJxtK/8AMer8g=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-pPg0pRPQOGyO5YNAS5ckzQ-1; Mon, 31 May 2021 14:24:38 -0400
X-MC-Unique: pPg0pRPQOGyO5YNAS5ckzQ-1
Received: by mail-io1-f71.google.com with SMTP id i13-20020a5e9e0d0000b029042f7925649eso7612761ioq.5
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 11:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=1ZTyS8OALHEqITSxfehy1CmNLlMZGuyCOsGuJTxDUp0=;
        b=kbnpQcRQ13Cq2e7nlNmBv4tS6XI+Q1hxrGFUt5WWyW3WLj+sZXUgJIikbtlQMfG3Bl
         utwK7+X8In7mSSl9WYBj1KOQ9oRMXzd7bRgFYi25l+wyRO65kq7QMNg5W0lGLVHqEjWG
         KIs3QjS9vSgen2f6Dp6Tkol2hmUtWPa9MQ91gK/MSX0waA+lPumYT0Hy/AlUi7x1+ksd
         B5db6eUZJM+qthy6iRWaK1bnfQLMDnZ7t6w7clf96ulZhNdPSKeCBQq9N7Ls7rFRzPoo
         YuK7/NSbEIvVjr6oIJHHEBeY+d6h4Drfv6AVtAqj+w+Bz5aWkDDK0V4QTVOGYmC+64Ej
         7QHA==
X-Gm-Message-State: AOAM532I89PQgwbym1EiKNJJGmI8GDBrZlBHLnf1v/KnQjVOJpcpFEcn
        VTOAIbC+2Dbc2nZg3WpIu23fXW1O0QLCIwuaZ7I8QWbdk+jNIj2qQ9pqUYqrFnMUj8CN6WFC270
        OoGbDSdRDbbEJ5p1lcqFM24pi0ulaYvsE
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr18286019iog.86.1622485477805;
        Mon, 31 May 2021 11:24:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWpEREf/C4y4/0lhLfQRDbKmV+zJ7cJ+Rlmd86ci7XAPLLWUXyIGJB9tQuSSoRpbxJNsAEO0IiYRl8t64rdGs=
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr18286009iog.86.1622485477674;
 Mon, 31 May 2021 11:24:37 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 31 May 2021 18:24:37 +0000
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210531124607.29602-1-simon.horman@corigine.com> <20210531124607.29602-9-simon.horman@corigine.com>
MIME-Version: 1.0
In-Reply-To: <20210531124607.29602-9-simon.horman@corigine.com>
Date:   Mon, 31 May 2021 18:24:37 +0000
Message-ID: <CALnP8Zb_MPukyNrFNWN9+--bQROQOqTV=K_cLngR_kmUMNJSDg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 8/8] nfp: flower-ct: add tc merge functionality
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 02:46:07PM +0200, Simon Horman wrote:
> +static int nfp_ct_do_tc_merge(struct nfp_fl_ct_zone_entry *zt,
> +			      struct nfp_fl_ct_flow_entry *ct_entry1,
> +			      struct nfp_fl_ct_flow_entry *ct_entry2)
> +{
> +	struct nfp_fl_ct_flow_entry *post_ct_entry, *pre_ct_entry;
> +	struct nfp_fl_ct_tc_merge *m_entry;
> +	unsigned long new_cookie[2];
> +	int err;
> +
> +	if (ct_entry1->type == CT_TYPE_PRE_CT) {
> +		pre_ct_entry = ct_entry1;
> +		post_ct_entry = ct_entry2;
> +	} else {
> +		post_ct_entry = ct_entry1;
> +		pre_ct_entry = ct_entry2;
> +	}
> +
> +	if (post_ct_entry->netdev != pre_ct_entry->netdev)
> +		return -EINVAL;
> +	if (post_ct_entry->chain_index != pre_ct_entry->chain_index)
> +		return -EINVAL;

I would expect this to always fail with OVS/OVN offload, as it always
jump to a new chain after an action:ct call.

  Marcelo

