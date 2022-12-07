Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CF0645B36
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLGNqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLGNq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:46:28 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C434C59FCA;
        Wed,  7 Dec 2022 05:46:27 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id m18so12552105eji.5;
        Wed, 07 Dec 2022 05:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qg6rscjarIENb4Y9pQnBfqSpVruaA4pKa5wywW78TI4=;
        b=MwsUVjDJmC4I5yYHV3kpu4xgCzlCzOFBqxQqhUcHYF0flutztZmp2Ao8JSgL6XZz2c
         mHIBqvcy7GSh1vrlCBtisgJtOnExtYO/3eAPdgXMUzK8b7VzgL/jacOOE4kUWRxvTdXQ
         KQffjyuNqWFBQcbiUoYJe7PHxELJ1BrgznpaWEFdsrJKWtmtv6SqeiehdqBFWcLtwLJt
         Ug9di9bdrmQ6Tv/yi/3AuaNGYaIlXL6Sfij3RMjYRRfjK0Qkc133Y++DVroVKFXEEuol
         MNa9UocHoAbWsSL9ajSwdoJpPuj57h8iMv9ouOaRWJbpJep4uGMK+nKoT2Diefjig+WU
         pOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qg6rscjarIENb4Y9pQnBfqSpVruaA4pKa5wywW78TI4=;
        b=rZ2q4GURH9gCQyYd5S3+Okm9MtV0Dd5QMBG2ARldSQ1hBTBUj/u1Bk6nNPDMGHqQ3i
         QOnbGbtxs66fOMDXLpCRDj/FCsE9/qcrkZn9JM6qp2Q+zpCFTiYG8bP38+4FWoh+cPpj
         PQJ9LxAmjMt/rilLYGyeV49Fzeir1OubAINy9d8JOJPIdJzR3f1wkBY/ZHNS1a33PX+I
         O4RQhWiwSzCnb5CDnAPx/JbGIx8WS9zuyg7r+24Qh60nnDr37ZSOsp+Nr1biHtVVqr3S
         tMaTUua4InsJGqJKv08yMa9JQNgBWFAtrHWEqvZYPs4lllHFgGQeG8+WXKSOy//50Qf/
         hE+g==
X-Gm-Message-State: ANoB5pmAx5WEhRElvCo5z16s3nMHobbQdG/y0lTo6o3gA7XkXbZKkMuA
        vjB7HXeg2cQoD++g02UYHyOXQOQ98gV5wRGx4Rs=
X-Google-Smtp-Source: AA0mqf5t0KjwzPyZvRZG7MLQbFpXbjxFzDGeMwNmpXfyClD31KDpdah+3VFvdek87O6hyLYA7X3zt1TVPTTh+UVTHDI=
X-Received: by 2002:a17:906:ad86:b0:7c0:7e90:ec98 with SMTP id
 la6-20020a170906ad8600b007c07e90ec98mr7717890ejb.537.1670420786209; Wed, 07
 Dec 2022 05:46:26 -0800 (PST)
MIME-Version: 1.0
References: <20221207072349.28608-1-jgross@suse.com>
In-Reply-To: <20221207072349.28608-1-jgross@suse.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Wed, 7 Dec 2022 08:46:14 -0500
Message-ID: <CAKf6xpu5tCeV4P5TUjDiHfupctwYHsnLUGT+TB5Wxgs9riRQ6A@mail.gmail.com>
Subject: Re: [PATCH] xen/netback: fix build warning
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 2:24 AM Juergen Gross <jgross@suse.com> wrote:
>
> Commit ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in
> the non-linear area") introduced a (valid) build warning.
>
> Fix it.
>
> Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Tested-by: Jason Andryuk <jandryuk@gmail.com>

I applied ad7f402ae4f4 to 5.15.y and 5.4.y and it broke networking
with my driver domains.  The frontend failed to DHCP an address and it
didn't look like any packets were getting through.  This patch fixed
networking with 5.15.y and 5.4.y.

I think the commit message is worth expanding that this is more than
just a build warning.

Thanks,
Jason
